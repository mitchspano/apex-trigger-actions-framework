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

public class MetadataTriggerHandler extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert,  TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
	@TestVisible
	private static Set<String> bypassedActions;
	
	static {
		bypassedActions = new Set<String>();
	}
	
	public void beforeInsert(List<SObject> newList) {
		for (TriggerAction.BeforeInsert action : beforeInsertActions) {
			action.beforeInsert(newList);
		}
	}

	public void afterInsert(List<SObject> newList) {
		for (TriggerAction.AfterInsert action : afterInsertActions) {
			action.AfterInsert(newList);
		}
	}

	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		for (TriggerAction.BeforeUpdate action : beforeUpdateActions) {
			action.BeforeUpdate(newList, oldList);
		}
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		for (TriggerAction.AfterUpdate action : AfterUpdateActions) {
			action.AfterUpdate(newList, oldList);
		}
	}

	public void beforeDelete(List<SObject> oldList) {
		for (TriggerAction.BeforeDelete action : beforeDeleteActions) {
			action.BeforeDelete(oldList);
		}
	}

	public void afterDelete(List<SObject> oldList) {
		for (TriggerAction.AfterDelete action : afterDeleteActions) {
			action.AfterDelete(oldList);
		}
	}

	public void afterUndelete(List<SObject> newList) {
		for (TriggerAction.AfterUndelete action : afterUndeleteActions) {
			action.AfterUndelete(newList);
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> beforeInsertActionMetadata {
		get {
			if (beforeInsertActionMetadata == null) {
				beforeInsertActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND Before_Insert__c != null
						AND Before_Insert__r.SObject__r.DeveloperName =: this.sObjectName
						AND Before_Insert__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					beforeInsertActionMetadata.add(actionMetadata);
				}
			}
			return beforeInsertActionMetadata;
		}
		set;
	}
	
	private List<TriggerAction.BeforeInsert> beforeInsertActions {
		get {
			List<TriggerAction.BeforeInsert> returnValue = new List<TriggerAction.BeforeInsert>();
			for (Trigger_Action__mdt triggerMetadata : this.beforeInsertActionMetadata) {
				try {
					returnValue.add((TriggerAction.BeforeInsert)(Type.forName(triggerMetadata.Apex_Class_Name__c).newInstance()));
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_INSERT
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> afterInsertActionMetadata {
		get {
			if (afterInsertActionMetadata == null) {
				afterInsertActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND After_Insert__c != null
						AND After_Insert__r.SObject__r.DeveloperName =: this.sObjectName
						AND After_Insert__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					afterInsertActionMetadata.add(actionMetadata);
				}
			}
			return afterInsertActionMetadata;
		}
		set;
	}
	
	private List<TriggerAction.AfterInsert> afterInsertActions {
		get {
			List<TriggerAction.AfterInsert> returnValue = new List<TriggerAction.AfterInsert>();
			for (Trigger_Action__mdt triggerMetadata : afterInsertActionMetadata) {
				try {
					returnValue.add((TriggerAction.AfterInsert)(Type.forName(triggerMetadata.Apex_Class_Name__c).newInstance()));
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_INSERT
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> beforeUpdateActionMetadata {
		get {
			if (beforeUpdateActionMetadata == null) {
				beforeUpdateActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND Before_Update__c != null
						AND Before_Update__r.SObject__r.DeveloperName =: this.sObjectName
						AND Before_Update__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					beforeUpdateActionMetadata.add(actionMetadata);
				}
			}
			return beforeUpdateActionMetadata;
		}
		set;
	}
	
	
	private List<TriggerAction.BeforeUpdate> beforeUpdateActions {
		get {
			List<TriggerAction.BeforeUpdate> returnValue = new List<TriggerAction.BeforeUpdate>();
			for (Trigger_Action__mdt triggerMetadata : beforeUpdateActionMetadata) {
				try {
					returnValue.add((TriggerAction.BeforeUpdate)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_UPDATE
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> afterUpdateActionMetadata {
		get {
			if (afterUpdateActionMetadata == null) {
				afterUpdateActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND After_Update__c != null
						AND After_Update__r.SObject__r.DeveloperName =: this.sObjectName
						AND After_Update__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					afterUpdateActionMetadata.add(actionMetadata);
				}
			}
			return afterUpdateActionMetadata;
		}
		set;
	}


	private List<TriggerAction.AfterUpdate> afterUpdateActions {
		get {
			List<TriggerAction.AfterUpdate> returnValue = new List<TriggerAction.AfterUpdate>();
			for (Trigger_Action__mdt triggerMetadata : afterUpdateActionMetadata) {
				try {
					returnValue.add((TriggerAction.AfterUpdate)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_UPDATE
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> beforeDeleteActionMetadata {
		get {
			if (beforeDeleteActionMetadata == null) {
				beforeDeleteActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND Before_Delete__c != null
						AND Before_Delete__r.SObject__r.DeveloperName =: this.sObjectName
						AND Before_Delete__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					beforeDeleteActionMetadata.add(actionMetadata);
				}
			}
			return beforeDeleteActionMetadata;
		}
		set;
	}
	
	private List<TriggerAction.BeforeDelete> beforeDeleteActions {
		get {
			List<TriggerAction.BeforeDelete> returnValue = new List<TriggerAction.BeforeDelete>();
			for (Trigger_Action__mdt triggerMetadata : beforeDeleteActionMetadata) {
				try {
					returnValue.add((TriggerAction.BeforeDelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_DELETE
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> afterDeleteActionMetadata {
		get {
			if (afterDeleteActionMetadata == null) {
				afterDeleteActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND After_Delete__c != null
						AND After_Delete__r.SObject__r.DeveloperName =: this.sObjectName
						AND After_Delete__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					afterDeleteActionMetadata.add(actionMetadata);
				}
			}
			return afterDeleteActionMetadata;
		}
		set;
	}
	
	private List<TriggerAction.AfterDelete> afterDeleteActions {
		get {
			List<TriggerAction.AfterDelete> returnValue = new List<TriggerAction.AfterDelete>();
			for (Trigger_Action__mdt triggerMetadata : afterDeleteActionMetadata) {
				try {
					returnValue.add((TriggerAction.AfterDelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_DELETE
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private List<Trigger_Action__mdt> afterUndeleteActionMetadata {
		get {
			if (afterUndeleteActionMetadata == null) {
				afterUndeleteActionMetadata = new List<Trigger_Action__mdt>();
				for (Trigger_Action__mdt actionMetadata : [
					SELECT
						Apex_Class_Name__c
					FROM
						Trigger_Action__mdt
					WHERE 
						Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						AND After_Delete__c != null
						AND After_Delete__r.SObject__r.DeveloperName =: this.sObjectName
						AND After_Delete__r.Bypass_Execution__c = false
						AND Bypass_Execution__c = false
					ORDER BY
						Order__c ASC
				]) {
					afterUndeleteActionMetadata.add(actionMetadata);
				}
			}
			return afterUndeleteActionMetadata;
		}
		set;
	}
	
	private List<TriggerAction.AfterUndelete> afterUndeleteActions {
		get {
			List<TriggerAction.AfterUndelete> returnValue = new List<TriggerAction.AfterUndelete>();
			for (Trigger_Action__mdt triggerMetadata : afterUndeleteActionMetadata) {
				try {
					returnValue.add((TriggerAction.AfterUndelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
				} catch (System.TypeException e) {
					handleTypeException(
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_UNDELETE
					);
				}
			}
			return returnValue;
		}
	}

	private void handleTypeException(String className, System.TriggerOperation triggerOperation) {
		throw new MetadataTriggerHandlerException(
			String.format(
				INVALID_TYPE_ERROR,
				new List<String>{
					className,
					String.valueOf(triggerOperation)
				}
			)
		);
	}
	
	
	public static void bypass(String actionName) {
		MetadataTriggerHandler.bypassedActions.add(actionName);
	}
	
	public static void clearBypass(String actionName) {
		MetadataTriggerHandler.bypassedActions.remove(actionName);
	}
	
	public static Boolean isBypassed(String actionName) {
		return MetadataTriggerHandler.bypassedActions.contains(actionName);
	}
	
	public static void clearAllBypasses() {
		MetadataTriggerHandler.bypassedActions.clear();
	}
	
	@TestVisible
	private static final String INVALID_TYPE_ERROR = 'Trigger Action Custom Metadata is configured incorrectly for class {0}. Either the class does not exist, or it exists and does not implement the Trigger Action interface specified for the {1} context.';
	
	class MetadataTriggerHandlerException extends Exception {}
	
	
}