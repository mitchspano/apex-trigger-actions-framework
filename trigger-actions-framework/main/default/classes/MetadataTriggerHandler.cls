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

public class MetadataTriggerHandler extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
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
	private List<sObject_Trigger_Setting__mdt> actionMetadata {
		get {
			if (actionMetadata == null) {
				actionMetadata = new List<sObject_Trigger_Setting__mdt>(
					[
						SELECT
							Id,
							Bypass_Permission__c,
							Required_Permission__c,
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM Before_Insert_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM After_Insert_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM Before_Update_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM After_Update_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM Before_Delete_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM After_Delete_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							),
							(
								SELECT
									Apex_Class_Name__c,
									Order__c,
									Flow_Name__c,
									Bypass_Permission__c,
									Required_Permission__c
								FROM After_Undelete_Actions__r
								WHERE
									Bypass_Execution__c = FALSE
									AND Apex_Class_Name__c NOT IN :MetadataTriggerHandler.bypassedActions
								ORDER BY Order__c ASC
							)
						FROM sObject_Trigger_Setting__mdt
						WHERE
							SObject__r.DeveloperName = :this.sObjectName
							AND Bypass_Execution__c = FALSE
						LIMIT 1
					]
				);
				if ((!actionMetadata.isEmpty()) && !shouldExecute(actionMetadata[0])) {
					actionMetadata = new List<sObject_Trigger_Setting__mdt>();
				}
			}

			return actionMetadata;
		}
		set;
	}

	@TestVisible
	private List<Trigger_Action__mdt> beforeInsertActionMetadata {
		get {
			if (beforeInsertActionMetadata == null) {
				beforeInsertActionMetadata = new List<Trigger_Action__mdt>();
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.Before_Insert_Actions__r
					) {
						if (shouldExecute(action)) {
							beforeInsertActionMetadata.add(action);
						}
					}
				}
			}
			return beforeInsertActionMetadata;
		}
		set;
	}

	private List<TriggerAction.BeforeInsert> beforeInsertActions {
		get {
			List<TriggerAction.BeforeInsert> returnValue = new List<TriggerAction.BeforeInsert>();
			for (
				Trigger_Action__mdt triggerMetadata : this.beforeInsertActionMetadata
			) {
				try {
					TriggerAction.BeforeInsert triggerAction = (TriggerAction.BeforeInsert) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_INSERT
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.After_Insert_Actions__r
					) {
						if (shouldExecute(action)) {
							afterInsertActionMetadata.add(action);
						}
					}
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
					TriggerAction.AfterInsert triggerAction = (TriggerAction.AfterInsert) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_INSERT
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.Before_Update_Actions__r
					) {
						if (shouldExecute(action)) {
							beforeUpdateActionMetadata.add(action);
						}
					}
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
					TriggerAction.BeforeUpdate triggerAction = (TriggerAction.BeforeUpdate) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_UPDATE
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.After_Update_Actions__r
					) {
						if (shouldExecute(action)) {
							afterUpdateActionMetadata.add(action);
						}
					}
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
					TriggerAction.AfterUpdate triggerAction = (TriggerAction.AfterUpdate) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_UPDATE
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.Before_Delete_Actions__r
					) {
						if (shouldExecute(action)) {
							beforeDeleteActionMetadata.add(action);
						}
					}
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
					TriggerAction.BeforeDelete triggerAction = (TriggerAction.BeforeDelete) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.BEFORE_DELETE
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				if (!this.actionMetadata.isEmpty()) {
					for (
						Trigger_Action__mdt action : this.actionMetadata[0]
							.After_Delete_Actions__r
					) {
						if (shouldExecute(action)) {
							afterDeleteActionMetadata.add(action);
						}
					}
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
					TriggerAction.AfterDelete triggerAction = (TriggerAction.AfterDelete) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_DELETE
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
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
				afterUndeleteActionMetadata = this.actionMetadata.isEmpty()
					? new List<Trigger_Action__mdt>()
					: this.actionMetadata[0].After_Undelete_Actions__r;
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
					TriggerAction.AfterUndelete triggerAction = (TriggerAction.AfterUndelete) Type.forName(
							triggerMetadata.Apex_Class_Name__c
						)
						.newInstance();
					if (triggerMetadata.Flow_Name__c != null) {
						((TriggerActionFlow) triggerAction)
							.flowName = triggerMetadata.Flow_Name__c;
					}
					returnValue.add(triggerAction);
				} catch (System.TypeException e) {
					handleException(
						INVALID_TYPE_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_UNDELETE
					);
				} catch (System.NullPointerException e) {
					handleException(
						INVALID_CLASS_ERROR,
						triggerMetadata.Apex_Class_Name__c,
						System.TriggerOperation.AFTER_UNDELETE
					);
				}
			}
			return returnValue;
		}
	}

	@TestVisible
	private boolean shouldExecute(Trigger_Action__mdt action) {
		return !((action.Bypass_Permission__c != null &&
		FeatureManagement.checkPermission(action.Bypass_Permission__c)) ||
		(action.Required_Permission__c != null &&
		!FeatureManagement.checkPermission(action.Required_Permission__c)));
	}

	@TestVisible
	private boolean shouldExecute(sObject_Trigger_Setting__mdt setting) {
		return !((setting.Bypass_Permission__c != null &&
		FeatureManagement.checkPermission(setting.Bypass_Permission__c)) ||
		(setting.Required_Permission__c != null &&
		!FeatureManagement.checkPermission(setting.Required_Permission__c)));
	}

	private void handleException(
		String error,
		String className,
		System.TriggerOperation triggerOperation
	) {
		throw new MetadataTriggerHandlerException(
			String.format(
				error,
				new List<String>{
					className,
					String.valueOf(triggerOperation),
					this.sObjectName
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
	private static final String INVALID_TYPE_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not implement the Trigger Action interface specified for the {1} context.';

	@TestVisible
	private static final String INVALID_CLASS_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not exist.';

	class MetadataTriggerHandlerException extends Exception {
	}
}
