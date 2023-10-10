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
	@TestVisible
	private static Integer existingDmlRowsOffset = 0;
	private static Integer rowsLeftToProcess;
	private static TriggerBase.Stack contextStack = new TriggerBase.Stack();
	private String lastProcessedContext;
	private static Boolean suppressFinalizeExecution = false;
	private static TriggerBase instanceToFinalize;

	private static final Map<System.TriggerOperation, Map<Id, Integer>> CONTEXT_TO_UPDATE_COUNT {
		get {
			if (CONTEXT_TO_UPDATE_COUNT == null) {
				CONTEXT_TO_UPDATE_COUNT = new Map<System.TriggerOperation, Map<Id, Integer>>{
					System.TriggerOperation.BEFORE_UPDATE => new Map<Id, Integer>(),
					System.TriggerOperation.AFTER_UPDATE => new Map<Id, Integer>()
				};
			}
			return CONTEXT_TO_UPDATE_COUNT;
		}
		set;
	}

	public static Map<Id, Integer> idToNumberOfTimesSeenBeforeUpdate {
		get {
			return CONTEXT_TO_UPDATE_COUNT.get(System.TriggerOperation.BEFORE_UPDATE);
		}
	}

	public static Map<Id, Integer> idToNumberOfTimesSeenAfterUpdate {
		get {
			return CONTEXT_TO_UPDATE_COUNT.get(System.TriggerOperation.AFTER_UPDATE);
		}
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
		instanceToFinalize?.finalizeDmlOperation();
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
			((TriggerAction.BeforeInsert) this).beforeInsert(this.triggerNew);
		} else if (
			this.context == System.TriggerOperation.AFTER_INSERT &&
			this instanceof TriggerAction.AfterInsert
		) {
			((TriggerAction.AfterInsert) this).afterInsert(this.triggerNew);
		} else if (
			this.context == System.TriggerOperation.BEFORE_UPDATE &&
			this instanceof TriggerAction.BeforeUpdate
		) {
			this.incrementUpdateCounts(this.context, this.triggerNew);
			((TriggerAction.BeforeUpdate) this)
				.beforeUpdate(this.triggerNew, this.triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_UPDATE &&
			this instanceof TriggerAction.AfterUpdate
		) {
			this.incrementUpdateCounts(this.context, this.triggerNew);
			((TriggerAction.AfterUpdate) this)
				.afterUpdate(this.triggerNew, this.triggerOld);
		} else if (
			this.context == System.TriggerOperation.BEFORE_DELETE &&
			this instanceof TriggerAction.BeforeDelete
		) {
			((TriggerAction.BeforeDelete) this).beforeDelete(this.triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_DELETE &&
			this instanceof TriggerAction.AfterDelete
		) {
			((TriggerAction.AfterDelete) this).afterDelete(this.triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_UNDELETE &&
			this instanceof TriggerAction.AfterUndelete
		) {
			((TriggerAction.AfterUndelete) this).afterUndelete(this.triggerNew);
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
			existingDmlRowsOffset = getDmlRows();
			if (!suppressFinalizeExecution) {
				instanceToFinalize.finalizeDmlOperation();
				instanceToFinalize = null;
			}
		}
	}

	@SuppressWarnings('PMD.EmptyStatementBlock')
	protected virtual void finalizeDmlOperation() {
	}

	private void incrementUpdateCounts(
		System.TriggerOperation triggerContext,
		List<SObject> records
	) {
		for (SObject obj : records) {
			Map<Id, Integer> idToUpdateCount = CONTEXT_TO_UPDATE_COUNT.get(
				triggerContext
			);
			Integer updateCount = idToUpdateCount.get(obj.Id);
			if (updateCount == null) {
				updateCount = 0;
			}
			idToUpdateCount.put(obj.Id, ++updateCount);
		}
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
			rowsLeftToProcess = getDMLRows() - existingDmlRowsOffset;
		}
		rowsLeftToProcess = rowsLeftToProcess - triggerSize;
	}

	private void setInstanceToFinalize() {
		if (instanceToFinalize == null) {
			instanceToFinalize = this;
		}
	}

	@TestVisible
	private virtual Integer getDmlRows() {
		return Limits.getDmlRows();
	}

	@TestVisible
	protected Schema.SObjectType sObjectType {
		get {
			if (sObjectType == null) {
				if (this.triggerNew != null) {
					sObjectType = this.triggerNew[0].getSObjectType();
				} else {
					sObjectType = this.triggerOld[0].getSObjectType();
				}
			}
			return sObjectType;
		}
		private set;
	}

	@TestVisible
	protected String sObjectName {
		get {
			if (sObjectName == null) {
				sObjectName = this.sObjectType.getDescribe(
						SObjectDescribeOptions.DEFERRED
					)
					.getName();
			}
			return sObjectName;
		}
		private set;
	}

	@TestVisible
	protected System.TriggerOperation context {
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

	private Integer triggerSize {
		get {
			return triggerNew != null
				? triggerNew.size()
				: triggerOld != null ? triggerOld.size() : 0;
		}
	}

	@TestVisible
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
