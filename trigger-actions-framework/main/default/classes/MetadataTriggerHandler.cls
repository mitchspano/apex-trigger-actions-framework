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

public with sharing class MetadataTriggerHandler extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
	@TestVisible
	private static Set<String> bypassedActions;
	static Map<String, Boolean> permissionMap;
	static Map<String, Map<String, List<Trigger_Action__mdt>>> sObjectToContextToActions;

	static {
		bypassedActions = new Set<String>();
		permissionMap = new Map<String, Boolean>();
		sObjectToContextToActions = new Map<String, Map<String, List<Trigger_Action__mdt>>>();
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

	private list<Trigger_Action__mdt> getActionMetadata(String relationshipName) {
		if (!sObjectToContextToActions.containsKey(this.sObjectName)) {
			sObjectToContextToActions.put(
				this.sObjectName,
				new Map<String, List<Trigger_Action__mdt>>()
			);
		}
		if (
			!sObjectToContextToActions.get(this.sObjectName)
				.containsKey(relationshipName)
		) {
			list<Trigger_Action__mdt> result = new List<Trigger_Action__mdt>();
			Set<String> bypassedActions = MetadataTriggerHandler.bypassedActions;
			String sObjectName = this.sObjectName;
			List<String> queryArray = new List<String>{
				'SELECT Apex_Class_Name__c,',
				'Order__c,',
				'Flow_Name__c,',
				'Bypass_Permission__c,',
				'Required_Permission__c,',
				'{0}__r.Bypass_Permission__c,',
				'{0}__r.Required_Permission__c',
				'FROM Trigger_Action__mdt',
				'WHERE',
				'Apex_Class_Name__c NOT IN :bypassedActions',
				'AND {0}__c != NULL',
				'AND {0}__r.DeveloperName = :sObjectName',
				'AND {0}__r.Bypass_Execution__c = FALSE',
				'ORDER BY Order__c ASC'
			};
			String queryString = String.format(
				String.join(queryArray, ' '),
				new List<Object>{ relationshipName }
			);
			for (
				Trigger_Action__mdt actionMetadata : (List<Trigger_Action__mdt>) Database.query(
					queryString
				)
			) {
				if (shouldExecute(actionMetadata, relationshipName)) {
					result.add(actionMetadata);
				}
			}
			sObjectToContextToActions.get(this.sObjectName)
				.put(relationshipName, result);
		}
		return sObjectToContextToActions.get(this.sObjectName)
			.get(relationshipName);
	}

	private Boolean shouldExecute(
		Trigger_Action__mdt actionMetadata,
		String relationshipName
	) {
		if (
			actionMetadata.Bypass_Permission__c != null &&
			!permissionMap.containsKey(actionMetadata.Bypass_Permission__c)
		) {
			permissionMap.put(
				actionMetadata.Bypass_Permission__c,
				FeatureManagement.checkPermission(actionMetadata.Bypass_Permission__c)
			);
		}
		if (
			actionMetadata.Required_Permission__c != null &&
			!permissionMap.containsKey(actionMetadata.Required_Permission__c)
		) {
			permissionMap.put(
				actionMetadata.Required_Permission__c,
				FeatureManagement.checkPermission(actionMetadata.Required_Permission__c)
			);
		}
		boolean actionShouldExecute = !((actionMetadata.Bypass_Permission__c !=
		null && permissionMap.get(actionMetadata.Bypass_Permission__c)) ||
		(actionMetadata.Required_Permission__c != null &&
		!permissionMap.get(actionMetadata.Required_Permission__c)));

		String sObjectBypassPermissionName = (String) ((sObject_Trigger_Setting__mdt) actionMetadata.getSobject(
				relationshipName + '__r'
			))
			.get('Bypass_Permission__c');
		String sObjectRequiredPermissionName = (String) ((sObject_Trigger_Setting__mdt) actionMetadata.getSobject(
				relationshipName + '__r'
			))
			.get('Required_Permission__c');
		boolean sObjectShouldExecute = !((sObjectBypassPermissionName != null &&
		permissionMap.get(sObjectBypassPermissionName)) ||
		(sObjectRequiredPermissionName != null &&
		!permissionMap.get(sObjectRequiredPermissionName)));

		return actionShouldExecute && sObjectShouldExecute;
	}

	@TestVisible
	private List<Trigger_Action__mdt> beforeInsertActionMetadata {
		get {
			if (beforeInsertActionMetadata == null) {
				beforeInsertActionMetadata = getActionMetadata(
					System.TriggerOperation.BEFORE_INSERT.name()
				);
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
				afterInsertActionMetadata = getActionMetadata(
					System.TriggerOperation.AFTER_INSERT.name()
				);
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
				beforeUpdateActionMetadata = getActionMetadata(
					System.TriggerOperation.BEFORE_UPDATE.name()
				);
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
				afterUpdateActionMetadata = getActionMetadata(
					System.TriggerOperation.AFTER_UPDATE.name()
				);
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
				beforeDeleteActionMetadata = getActionMetadata(
					System.TriggerOperation.BEFORE_DELETE.name()
				);
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
				afterDeleteActionMetadata = getActionMetadata(
					System.TriggerOperation.AFTER_DELETE.name()
				);
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
				afterUndeleteActionMetadata = getActionMetadata(
					System.TriggerOperation.AFTER_UNDELETE.name()
				);
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
