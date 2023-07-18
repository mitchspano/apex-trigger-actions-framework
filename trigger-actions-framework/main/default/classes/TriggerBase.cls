/*
   Copyright 2020 Google LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

	https://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */

@SuppressWarnings(
	'PMD.ApexDoc, PMD.StdCyclomaticComplexity, PMD.CyclomaticComplexity, PMD.cognitivecomplexity'
)
public inherited sharing virtual class TriggerBase {
	@TestVisible
	private static final String HANDLER_OUTSIDE_TRIGGER_MESSAGE = 'Trigger handler called outside of Trigger execution';
	@TestVisible
	private static final String CANNOT_FINALIZE = 'Calling `nowFinalize()` is only allowed after `waitToFinalize()` has been called';
	private static final Map<System.TriggerOperation, System.TriggerOperation> CONTEXT_TO_INVERSE = new Map<System.TriggerOperation, System.TriggerOperation>{
		System.TriggerOperation.AFTER_INSERT => System.TriggerOperation.BEFORE_INSERT,
		System.TriggerOperation.AFTER_UPDATE => System.TriggerOperation.BEFORE_UPDATE,
		System.TriggerOperation.AFTER_DELETE => System.TriggerOperation.BEFORE_DELETE
	};

	@TestVisible
	private static Set<String> bypassedObjects = new Set<String>();
	private static Integer existingDmlRowsOffset = 0;
	private static Integer rowsLeftToProcess;
	private static TriggerBase.Stack contextStack = new TriggerBase.Stack();
	private String lastProcessedContext;
	private static Boolean suppressFinalizeExecution = false;
	private static TriggerBase instanceToFinalize;

	@TestVisible
	public static Map<Id, Integer> idToNumberOfTimesSeenBeforeUpdate {
		get;
		private set;
	}
	@TestVisible
	public static Map<Id, Integer> idToNumberOfTimesSeenAfterUpdate {
		get;
		private set;
	}

	private String contextKey {
		get {
			return this.sObjectName + '|' + this.context.name();
		}
	}
	private String inverseContext {
		get {
			return CONTEXT_TO_INVERSE.containsKey(this.context)
				? this.sObjectName + '|' + CONTEXT_TO_INVERSE.get(this.context)
				: '';
		}
	}

	static {
		idToNumberOfTimesSeenBeforeUpdate = new Map<Id, Integer>();
		idToNumberOfTimesSeenAfterUpdate = new Map<Id, Integer>();
	}

	public static void bypass(String sObjectName) {
		TriggerBase.bypassedObjects.add(sObjectName);
	}

	public static void clearBypass(String sObjectName) {
		TriggerBase.bypassedObjects.remove(sObjectName);
	}

	public static Boolean isBypassed(String sObjectName) {
		return TriggerBase.bypassedObjects.contains(sObjectName);
	}

	public static void clearAllBypasses() {
		TriggerBase.bypassedObjects.clear();
	}

	public static void offsetExistingDmlRows() {
		existingDmlRowsOffset = Limits.getDMLRows();
	}

	public static void waitToFinalize() {
		suppressFinalizeExecution = true;
	}

	public static void nowFinalize() {
		if (suppressFinalizeExecution == false) {
			throw new TriggerBaseException(CANNOT_FINALIZE);
		}
		instanceToFinalize?.finalizeTrigger();
	}

	public void run() {
		if (!shouldRun()) {
			return;
		}
		setInstanceToFinalize();
		setRowsLeftToProcess();
		TriggerBase.contextStack.push(this.contextKey);
		if (
			this.context == System.TriggerOperation.BEFORE_INSERT &&
			this instanceof TriggerAction.BeforeInsert
		) {
			((TriggerAction.BeforeInsert) this).beforeInsert(triggerNew);
		} else if (
			this.context == System.TriggerOperation.AFTER_INSERT &&
			this instanceof TriggerAction.AfterInsert
		) {
			((TriggerAction.AfterInsert) this).afterInsert(triggerNew);
		} else if (
			this.context == System.TriggerOperation.BEFORE_UPDATE &&
			this instanceof TriggerAction.BeforeUpdate
		) {
			for (SObject obj : triggerNew) {
				if (!idToNumberOfTimesSeenBeforeUpdate.containsKey(obj.id)) {
					idToNumberOfTimesSeenBeforeUpdate.put(obj.id, 1);
				} else {
					idToNumberOfTimesSeenBeforeUpdate.put(
						obj.id,
						idToNumberOfTimesSeenBeforeUpdate.get(obj.id) + 1
					);
				}
			}
			((TriggerAction.BeforeUpdate) this).beforeUpdate(triggerNew, triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_UPDATE &&
			this instanceof TriggerAction.AfterUpdate
		) {
			for (SObject obj : triggerNew) {
				if (!idToNumberOfTimesSeenAfterUpdate.containsKey(obj.id)) {
					idToNumberOfTimesSeenAfterUpdate.put(obj.id, 1);
				} else {
					idToNumberOfTimesSeenAfterUpdate.put(
						obj.id,
						idToNumberOfTimesSeenAfterUpdate.get(obj.id) + 1
					);
				}
			}
			((TriggerAction.AfterUpdate) this).afterUpdate(triggerNew, triggerOld);
		} else if (
			this.context == System.TriggerOperation.BEFORE_DELETE &&
			this instanceof TriggerAction.BeforeDelete
		) {
			((TriggerAction.BeforeDelete) this).beforeDelete(triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_DELETE &&
			this instanceof TriggerAction.AfterDelete
		) {
			((TriggerAction.AfterDelete) this).afterDelete(triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_UNDELETE &&
			this instanceof TriggerAction.AfterUndelete
		) {
			((TriggerAction.AfterUndelete) this).afterUndelete(triggerNew);
		}
		checkForEndOfTriggerProcessing();
	}

	private void checkForEndOfTriggerProcessing() {
		if (this.context == System.TriggerOperation.AFTER_UNDELETE) {
			TriggerBase.contextStack.pop();
		}
		if (TriggerBase.contextStack.depth() > 1) {
			String currentContext = TriggerBase.contextStack.pop();
			String previousContext = TriggerBase.contextStack.peek();
			if (previousContext == this.inverseContext) {
				TriggerBase.contextStack.pop();
			} else {
				triggerBase.contextStack.push(currentContext);
			}
		}
		if (TriggerBase.contextStack.isEmpty() && rowsLeftToProcess == 0) {
			rowsLeftToProcess = null;
			existingDmlRowsOffset = limits.getDmlRows();
			if (!suppressFinalizeExecution) {
				this.finalizeTrigger();
			}
		}
	}

	@SuppressWarnings('PMD.EmptyStatementBlock')
	protected virtual void finalizeTrigger() {
	}

	private Boolean shouldRun() {
		if (!Trigger.isExecuting && this.context == null) {
			throw new TriggerBaseException(HANDLER_OUTSIDE_TRIGGER_MESSAGE);
		}
		if (TriggerBase.bypassedObjects.contains(this.sObjectName)) {
			return false;
		}
		return true;
	}

	private void setRowsLeftToProcess() {
		if (!TriggerBase.contextStack.isEmpty()) {
			return;
		}
		if (rowsLeftToProcess == null) {
			rowsLeftToProcess = Limits.getDMLRows() - existingDmlRowsOffset;
		}
		rowsLeftToProcess = rowsLeftToProcess - Trigger.size;
	}

	private void setInstanceToFinalize() {
		if (suppressFinalizeExecution && instanceToFinalize == null) {
			instanceToFinalize = this;
		}
	}

	@TestVisible
	protected String sObjectName {
		get {
			if (sObjectName == null) {
				if (this.TriggerNew != null) {
					sObjectName = this.triggerNew[0]
						.getSObjectType()
						.getDescribe()
						.getName();
				} else {
					sObjectName = this.triggerOld[0]
						.getSObjectType()
						.getDescribe()
						.getName();
				}
			}
			return sObjectName;
		}
		private set;
	}

	@TestVisible
	private System.TriggerOperation context {
		get {
			if (context == null) {
				context = Trigger.operationType;
			}
			return context;
		}
		set;
	}

	@TestVisible
	protected List<SObject> triggerNew {
		get {
			if (triggerNew == null) {
				triggerNew = Trigger.new;
			}
			return triggerNew;
		}
		private set;
	}

	@TestVisible
	protected List<SObject> triggerOld {
		get {
			if (triggerOld == null) {
				triggerOld = Trigger.old;
			}
			return triggerOld;
		}
		private set;
	}

	private class Stack {
		private List<String> data = new List<String>();
		public void push(String s) {
			data.add(s);
		}
		public String peek() {
			if (this.data.isEmpty()) {
				throw new EmptyStackException();
			}
			return this.data.get(this.data.size() - 1);
		}
		public Boolean isEmpty() {
			return this.data.isEmpty();
		}
		public String pop() {
			if (this.data.isEmpty()) {
				throw new EmptyStackException();
			}
			String response = this.data.get(this.data.size() - 1);
			this.data.remove(this.data.size() - 1);
			return response;
		}
		public Integer depth() {
			return this.data.size();
		}
	}

	@TestVisible
	private class TriggerBaseException extends Exception {
	}

	@TestVisible
	private class EmptyStackException extends Exception {
	}
}
