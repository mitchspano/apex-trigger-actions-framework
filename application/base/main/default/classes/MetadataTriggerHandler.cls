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
		try {
			for (TriggerAction.BeforeInsert action : beforeInsertActions) {
				action.beforeInsert(newList);
			}
		} catch (Exception e) {
			for (SObject obj : newList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void afterInsert(List<SObject> newList) {
		try {
			for (TriggerAction.AfterInsert action : afterInsertActions) {
				action.AfterInsert(newList);
			}
		} catch (Exception e) {
			for (SObject obj : newList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		try {
			for (TriggerAction.BeforeUpdate action : beforeUpdateActions) {
				action.BeforeUpdate(newList, oldList);
			}
		} catch (Exception e) {
			for (SObject obj : newList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		try {
			for (TriggerAction.AfterUpdate action : AfterUpdateActions) {
				action.AfterUpdate(newList, oldList);
			}
		} catch (Exception e) {
			for (SObject obj : newList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void beforeDelete(List<SObject> oldList) {
		try {
			for (TriggerAction.BeforeDelete action : beforeDeleteActions) {
				action.BeforeDelete(oldList);
			}
		} catch (Exception e) {
			for (SObject obj : oldList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void afterDelete(List<SObject> oldList) {
		try {
			for (TriggerAction.AfterDelete action : afterDeleteActions) {
				action.AfterDelete(oldList);
			}
		} catch (Exception e) {
			for (SObject obj : oldList) {
				obj.addError(e.getMessage());
			}
		}
	}

	public void afterUndelete(List<SObject> newList) {
		try {
			for (TriggerAction.AfterUndelete action : afterUndeleteActions) {
				action.AfterUndelete(newList);
			}
		} catch (Exception e) {
			for (SObject obj : newList) {
				obj.addError(e.getMessage());
			}
		}
	}
	
	private List<TriggerAction.BeforeInsert> beforeInsertActions {
		get {
			List<TriggerAction.BeforeInsert> returnValue = new List<TriggerAction.BeforeInsert>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.Before_Insert__c != null) {
					try {
						returnValue.add((TriggerAction.BeforeInsert)(Type.forName(triggerMetadata.Apex_Class_Name__c).newInstance()));
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.BEFORE_INSERT)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	private List<TriggerAction.AfterInsert> afterInsertActions {
		get {
			List<TriggerAction.AfterInsert> returnValue = new List<TriggerAction.AfterInsert>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.After_Insert__c != null) {
					try {
						returnValue.add((TriggerAction.AfterInsert)(Type.forName(triggerMetadata.Apex_Class_Name__c).newInstance()));
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.AFTER_INSERT)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	private List<TriggerAction.BeforeUpdate> beforeUpdateActions {
		get {
			List<TriggerAction.BeforeUpdate> returnValue = new List<TriggerAction.BeforeUpdate>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.Before_Update__c != null) {
					try {
						returnValue.add((TriggerAction.BeforeUpdate)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.BEFORE_UPDATE)}));
					}
				}
			}
			return returnValue;
		}
	}
	private List<TriggerAction.AfterUpdate> afterUpdateActions {
		get {
			List<TriggerAction.AfterUpdate> returnValue = new List<TriggerAction.AfterUpdate>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.After_Update__c != null) {
					try {
						returnValue.add((TriggerAction.AfterUpdate)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.AFTER_UPDATE)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	private List<TriggerAction.BeforeDelete> beforeDeleteActions {
		get {
			List<TriggerAction.BeforeDelete> returnValue = new List<TriggerAction.BeforeDelete>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.Before_Delete__c != null) {
					try {
						returnValue.add((TriggerAction.BeforeDelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.BEFORE_DELETE)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	private List<TriggerAction.AfterDelete> afterDeleteActions {
		get {
			List<TriggerAction.AfterDelete> returnValue = new List<TriggerAction.AfterDelete>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.After_Delete__c != null) {
					try {
						returnValue.add((TriggerAction.AfterDelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.AFTER_DELETE)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	private List<TriggerAction.AfterUndelete> afterUndeleteActions {
		get {
			List<TriggerAction.AfterUndelete> returnValue = new List<TriggerAction.AfterUndelete>();
			for (Trigger_Action__mdt triggerMetadata : triggerActionsForThisObject) {
				if (triggerMetadata.After_Undelete__c != null) {
					try {
						returnValue.add((TriggerAction.AfterUndelete)(Type.forName(triggerMetadata.Apex_Class_Name__c)).newInstance());
					} catch (System.TypeException e) {
						throw new CustomMetadataTriggerHandlerException(String.format(INVALID_TYPE_ERROR, new List<String> {triggerMetadata.Apex_Class_Name__c, String.valueOf(System.TriggerOperation.AFTER_UNDELETE)}));
					}
				}
			}
			return returnValue;
		}
	}
	
	
	@TestVisible
	private List<Trigger_Action__mdt> triggerActionsForThisObject {
		get {
			if (triggerActionsForThisObject == null) {
				triggerActionsForThisObject = new List<Trigger_Action__mdt>();
				List<sObject_Trigger_Setting__mdt> sobjectTriggerSettings = new List<sObject_Trigger_Setting__mdt>(
					[SELECT
						 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
						 Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
						 FROM Before_Insert_Actions__r
						 WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
						 ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM After_Insert_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM Before_Update_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM After_Update_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM Before_Delete_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM After_Delete_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC),
					 (SELECT Id, Before_Insert__c, After_Insert__c, Before_Update__c, After_Update__c,
					  Before_Delete__c, After_Delete__c, After_Undelete__c, Apex_Class_Name__c, Order__c
					  FROM After_Undelete_Actions__r
					  WHERE Apex_Class_Name__c NOT IN: MetadataTriggerHandler.bypassedActions
					  ORDER BY Order__c ASC)
					 FROM sObject_Trigger_Setting__mdt
					 WHERE SObject__r.DeveloperName =: this.sObjectName
									  AND Bypass_Execution__c = false
												    LIMIT 1
					]
					);
				if (!sobjectTriggerSettings.isEmpty()) {
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].Before_Insert_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].After_Insert_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].Before_Update_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].After_Update_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].Before_Delete_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].After_Delete_Actions__r);
					triggerActionsForThisObject.addAll(sobjectTriggerSettings[0].After_Undelete_Actions__r);
				}
			}
			return triggerActionsForThisObject;
		}
		set;
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
	
	class CustomMetadataTriggerHandlerException extends Exception {}
	
	
}