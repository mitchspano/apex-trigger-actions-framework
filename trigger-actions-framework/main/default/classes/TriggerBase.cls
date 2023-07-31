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
	private static Set<String> bypassedObjects = new Set<String>();

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

	public void run() {
		if (!validateRun()) {
			return;
		}
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
			((TriggerAction.BeforeUpdate) this).beforeUpdate(this.triggerNew, this.triggerOld);
		} else if (
			this.context == System.TriggerOperation.AFTER_UPDATE &&
			this instanceof TriggerAction.AfterUpdate
		) {
			this.incrementUpdateCounts(this.context, this.triggerNew);
			((TriggerAction.AfterUpdate) this).afterUpdate(this.triggerNew, this.triggerOld);
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

	private void incrementUpdateCounts(System.TriggerOperation triggerContext, List<SObject> records) {
		for (SObject obj : records) {
			Map<Id, Integer> idToUpdateCount = CONTEXT_TO_UPDATE_COUNT.get(triggerContext);
			Integer updateCount = idToUpdateCount.get(obj.Id);
			if (updateCount == null) {
				updateCount = 0;
			}
			idToUpdateCount.put(obj.Id, ++updateCount);
		}
	}

	private Boolean validateRun() {
		if (!Trigger.isExecuting && this.context == null) {
			throw new TriggerBaseException(HANDLER_OUTSIDE_TRIGGER_MESSAGE);
		}
		if (TriggerBase.bypassedObjects.contains(this.sObjectName)) {
			return false;
		}
		return true;
	}

	@TestVisible
	protected String sObjectName {
		get {
			if (sObjectName == null) {
				if (this.triggerNew != null) {
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

	@TestVisible
	private class TriggerBaseException extends Exception {
	}
}
