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

/**
 * @group Trigger Actions Framework
 * @description The `MetadataTriggerHandler` class is a trigger handler that executes Trigger
 * Actions defined in Custom Metadata.
 *
 * This class implements the `TriggerAction` interface for all supported Trigger Operations:
 *
 * - `BeforeInsert`
 * - `AfterInsert`
 * - `BeforeUpdate`
 * - `AfterUpdate`
 * - `BeforeDelete`
 * - `AfterDelete`
 * - `AfterUndelete`
 * ---
 * The `MetadataTriggerHandler` class reads from the `Trigger_Action__mdt` Custom Metadata type to
 * define Trigger Actions.
 *
 * Each Trigger Action must specify the following information:
 *
 * - `Apex_Class_Name__c`: The name of the Apex class that implements the Trigger Action.
 * - `Order__c`: The order in which the Trigger Action should be executed.
 * - `Flow_Name__c`: The name of the Flow to execute (optional).
 * - `Bypass_Permission__c`: The permission required to bypass the Trigger Action (optional).
 * - `Required_Permission__c`: The permission required to execute the Trigger Action (optional).
 * - `Allow_Flow_Recursion__c`: Whether or not to allow the Flow to recurse (optional).
 * ---
 *
 * The `MetadataTriggerHandler` class also uses the `sObject_Trigger_Setting__mdt` Custom Metadata type to define
 * Trigger Action settings for specific sObjects.
 *
 * Each sObject Trigger Setting must specify the following information:
 *
 * - `Bypass_Permission__c`: The permission required to bypass the Trigger Action for the specified sObject (optional).
 * - `Required_Permission__c`: The permission required to execute the Trigger Action for the specified sObject (optional).
 * ---
 *
 * To use the `MetadataTriggerHandler` class, you must create a Trigger on the desired sObject and specify the
 *  `MetadataTriggerHandler` class as the handler.
 * You can then define Trigger Actions and sObject Trigger Settings in Custom Metadata to control the behavior of the Trigger.
 *
 *
 * **Example:**
 *
 * ```
 * trigger AccountTrigger on Account (
 *   before insert,
 *   after insert,
 *   before update,
 *   after update,
 *   before delete,
 *   after delete,
 *   after undelete
 * ) {
 *     new MetadataTriggerHandler.execute();
 * }
 * ```
 *
 * This example will execute all Trigger Actions defined in Custom Metadata for the `Account` sObject.
 *
 */
@SuppressWarnings('PMD.CognitiveComplexity')
public inherited sharing class MetadataTriggerHandler extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
	private static final String DOUBLE_UNDERSCORE = '__';
	private static final String EMPTY_STRING = '';
	@TestVisible
	private static final String INVALID_TYPE_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not implement the Trigger Action interface specified for the {1} context.';
	@TestVisible
	private static final String INVALID_CLASS_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not exist.';
	private static final String QUERY_TEMPLATE = String.join(
		new List<String>{
			'SELECT Apex_Class_Name__c,',
			'Order__c,',
			'Flow_Name__c,',
			'Bypass_Permission__c,',
			'Required_Permission__c,',
			'Allow_Flow_Recursion__c,',
			'{0}__r.Bypass_Permission__c,',
			'{0}__r.Required_Permission__c',
			'FROM Trigger_Action__mdt',
			'WHERE',
			'{0}__c != NULL',
			'AND {0}__r.Object_API_Name__c = \'\'{1}\'\'',
			'AND {0}__r.Object_Namespace__c = \'\'{2}\'\'',
			'AND {0}__r.Bypass_Execution__c = FALSE',
			'AND Bypass_Execution__c = FALSE',
			'ORDER BY Order__c ASC'
		},
		' '
	);
	private static final String RELATIONSHIP_SUFFIX = '__r';
	@TestVisible
	private static Set<String> bypassedActions = new Set<String>();
	@TestVisible
	private static Selector selector = new Selector();
	@TestVisible
	private static Map<String, Boolean> permissionMap = new Map<String, Boolean>();
	private static Map<String, Map<String, List<Trigger_Action__mdt>>> sObjectToContextToActions = new Map<String, Map<String, List<Trigger_Action__mdt>>>();
	@TestVisible
	private static FinalizerHandler finalizerHandler = new FinalizerHandler();

	/**
	 * @description Bypass the execution of a Trigger Action.
	 *
	 * @param actionName The name of the Trigger Action to bypass.
	 */
	public static void bypass(String actionName) {
		MetadataTriggerHandler.bypassedActions.add(actionName);
	}

	/**
	 * @description Clear the bypass for a Trigger Action.
	 *
	 * @param actionName The name of the Trigger Action to clear the bypass for.
	 */
	public static void clearBypass(String actionName) {
		MetadataTriggerHandler.bypassedActions.remove(actionName);
	}

	/**
	 * @description Check if a Trigger Action is bypassed.
	 *
	 * @param actionName The name of the Trigger Action to check.
	 * @return True if the Trigger Action is bypassed, false otherwise.
	 */
	public static Boolean isBypassed(String actionName) {
		return MetadataTriggerHandler.bypassedActions.contains(actionName);
	}

	/**
	 * @description Clear all bypasses for Trigger Actions.
	 */
	public static void clearAllBypasses() {
		MetadataTriggerHandler.bypassedActions.clear();
	}

	/**
	 * @description Execute the Before Insert Trigger Actions.
	 *
	 * @param newList The list of new records being inserted.
	 */
	public void beforeInsert(List<SObject> newList) {
		this.executeActions(TriggerOperation.BEFORE_INSERT, newList, null);
	}

	/**
	 * @description Execute the After Insert Trigger Actions.
	 *
	 * @param newList The list of new records that were inserted.
	 */
	public void afterInsert(List<SObject> newList) {
		this.executeActions(TriggerOperation.AFTER_INSERT, newList, null);
	}

	/**
	 * @description Execute the Before Update Trigger Actions.
	 *
	 * @param newList The list of updated records.
	 * @param oldList The list of old records before the update.
	 */
	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		this.executeActions(TriggerOperation.BEFORE_UPDATE, newList, oldList);
	}

	/**
	 * @description Execute the After Update Trigger Actions.
	 *
	 * @param newList The list of updated records.
	 * @param oldList The list of old records before the update.
	 */
	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		this.executeActions(TriggerOperation.AFTER_UPDATE, newList, oldList);
	}

	/**
	 * @description Execute the Before Delete Trigger Actions.
	 *
	 * @param oldList The list of records being deleted.
	 */
	public void beforeDelete(List<SObject> oldList) {
		this.executeActions(TriggerOperation.BEFORE_DELETE, null, oldList);
	}

	/**
	 * @description Execute the After Delete Trigger Actions.
	 *
	 * @param oldList The list of records that were deleted.
	 */
	public void afterDelete(List<SObject> oldList) {
		this.executeActions(TriggerOperation.AFTER_DELETE, null, oldList);
	}

	/**
	 * @description Execute the After Undelete Trigger Actions.
	 *
	 * @param newList The list of records that were undeleted.
	 */
	public void afterUndelete(List<SObject> newList) {
		this.executeActions(TriggerOperation.AFTER_UNDELETE, newList, null);
	}

	/**
	 * @description Finalize the DML operation.
	 *
	 * This method is called after all Trigger Actions have been executed.
	 */
	@TestVisible
	protected override void finalizeDmlOperation() {
		finalizerHandler.handleDynamicFinalizers();
	}

	/**
	 * @description Populate the permission map.
	 *
	 * @param permissionName The name of the permission to check.
	 */
	private void populatePermissionMap(String permissionName) {
		if (permissionName != null && !permissionMap.containsKey(permissionName)) {
			permissionMap.put(
				permissionName,
				FeatureManagement.checkPermission(permissionName)
			);
		}
	}

	/**
	 * @description Get the Trigger Action metadata.
	 *
	 * @param relationshipName The name of the relationship to get the metadata for.
	 * @return The list of Trigger Action metadata for the specified relationship.
	 */
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
			String sObjectLocalName = this.sObjectName;
			List<String> split = sObjectName.split(DOUBLE_UNDERSCORE);
			String namespace;
			if (split.size() > 2) {
				namespace = split[0];
				sObjectLocalName = sObjectLocalName.replaceFirst(
					namespace + DOUBLE_UNDERSCORE,
					EMPTY_STRING
				);
			}
			String queryString = String.format(
				QUERY_TEMPLATE,
				new List<Object>{
					relationshipName,
					sObjectLocalName,
					namespace != null ? namespace : EMPTY_STRING
				}
			);
			for (
				Trigger_Action__mdt actionMetadata : (List<Trigger_Action__mdt>) selector.query(
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

	/**
	 * @description Check if the Trigger Action should be executed.
	 *
	 * @param actionMetadata The Trigger Action metadata.
	 * @param relationshipName The name of the relationship.
	 * @return True if the Trigger Action should be executed, false otherwise.
	 */
	private Boolean shouldExecute(
		Trigger_Action__mdt actionMetadata,
		String relationshipName
	) {
		String sObjectBypassPermissionName = (String) ((sObject_Trigger_Setting__mdt) actionMetadata.getSobject(
				relationshipName + RELATIONSHIP_SUFFIX
			))
			.get(sObject_Trigger_Setting__mdt.Bypass_Permission__c);
		String sObjectRequiredPermissionName = (String) ((sObject_Trigger_Setting__mdt) actionMetadata.getSobject(
				relationshipName + RELATIONSHIP_SUFFIX
			))
			.get(sObject_Trigger_Setting__mdt.Required_Permission__c);
		for (
			String permissionName : new List<String>{
				actionMetadata.Bypass_Permission__c,
				actionMetadata.Required_Permission__c,
				sObjectBypassPermissionName,
				sObjectRequiredPermissionName
			}
		) {
			populatePermissionMap(permissionName);
		}

		return isNotBypassed(
				actionMetadata.Bypass_Permission__c,
				actionMetadata.Required_Permission__c
			) &&
			isNotBypassed(sObjectBypassPermissionName, sObjectRequiredPermissionName);
	}

	/**
	 * @description Check if the Trigger Action is not bypassed.
	 *
	 * @param requiredPermission The required permission for the Trigger Action.
	 * @param bypassPermission The bypass permission for the Trigger Action.
	 * @return True if the Trigger Action is not bypassed, false otherwise.
	 */
	private static boolean isNotBypassed(
		String requiredPermission,
		String bypassPermission
	) {
		return !((requiredPermission != null &&
		permissionMap.get(requiredPermission)) ||
		(bypassPermission != null && !permissionMap.get(bypassPermission)));
	}

	/**
	 * @description Execute the Trigger Actions.
	 *
	 * @param context The Trigger Operation context.
	 * @param newList The list of new records.
	 * @param oldList The list of old records.
	 */
	private void executeActions(
		TriggerOperation context,
		List<SObject> newList,
		List<SObject> oldList
	) {
		List<Trigger_Action__mdt> actionMetadata;

		switch on context {
			when BEFORE_INSERT {
				actionMetadata = this.beforeInsertActionMetadata;
			}
			when AFTER_INSERT {
				actionMetadata = this.afterInsertActionMetadata;
			}
			when BEFORE_UPDATE {
				actionMetadata = this.beforeUpdateActionMetadata;
			}
			when AFTER_UPDATE {
				actionMetadata = this.afterUpdateActionMetadata;
			}
			when BEFORE_DELETE {
				actionMetadata = this.beforeDeleteActionMetadata;
			}
			when AFTER_DELETE {
				actionMetadata = this.afterDeleteActionMetadata;
			}
			when AFTER_UNDELETE {
				actionMetadata = this.afterUndeleteActionMetadata;
			}
		}
		for (Trigger_Action__mdt triggerMetadata : actionMetadata) {
			Object triggerAction;
			try {
				triggerAction = Type.forName(triggerMetadata.Apex_Class_Name__c)
					.newInstance();
				if (triggerMetadata.Flow_Name__c != null) {
					((TriggerActionFlow) triggerAction)
						.flowName = triggerMetadata.Flow_Name__c;
					((TriggerActionFlow) triggerAction)
						.allowRecursion = triggerMetadata.Allow_Flow_Recursion__c;
				}
			} catch (System.NullPointerException e) {
				handleException(
					INVALID_CLASS_ERROR,
					triggerMetadata.Apex_Class_Name__c,
					context
				);
			}
			if (
				!MetadataTriggerHandler.isBypassed(
					triggerMetadata.Apex_Class_Name__c
				) && !TriggerBase.isBypassed(this.sObjectName)
			) {
				this.validateType(
					context,
					triggerAction,
					triggerMetadata.Apex_Class_Name__c
				);
				switch on context {
					when BEFORE_INSERT {
						((TriggerAction.BeforeInsert) triggerAction).beforeInsert(newList);
					}
					when AFTER_INSERT {
						((TriggerAction.AfterInsert) triggerAction).afterInsert(newList);
					}
					when BEFORE_UPDATE {
						((TriggerAction.BeforeUpdate) triggerAction)
							.beforeUpdate(newList, oldList);
					}
					when AFTER_UPDATE {
						((TriggerAction.AfterUpdate) triggerAction)
							.afterUpdate(newList, oldList);
					}
					when BEFORE_DELETE {
						((TriggerAction.BeforeDelete) triggerAction).beforeDelete(oldList);
					}
					when AFTER_DELETE {
						((TriggerAction.AfterDelete) triggerAction).afterDelete(oldList);
					}
					when AFTER_UNDELETE {
						((TriggerAction.AfterUndelete) triggerAction)
							.afterUndelete(newList);
					}
				}
			}
		}
	}

	/**
	 * @description Validate the type of the Trigger Action.
	 *
	 * @param context The Trigger Operation context.
	 * @param triggerAction The Trigger Action object.
	 * @param className The name of the Trigger Action class.
	 */
	private void validateType(
		TriggerOperation context,
		Object triggerAction,
		String className
	) {
		try {
			switch on context {
				when BEFORE_INSERT {
					triggerAction = ((TriggerAction.BeforeInsert) triggerAction);
				}
				when AFTER_INSERT {
					triggerAction = ((TriggerAction.AfterInsert) triggerAction);
				}
				when BEFORE_UPDATE {
					triggerAction = ((TriggerAction.BeforeUpdate) triggerAction);
				}
				when AFTER_UPDATE {
					triggerAction = ((TriggerAction.AfterUpdate) triggerAction);
				}
				when BEFORE_DELETE {
					triggerAction = ((TriggerAction.BeforeDelete) triggerAction);
				}
				when AFTER_DELETE {
					triggerAction = ((TriggerAction.AfterDelete) triggerAction);
				}
				when AFTER_UNDELETE {
					triggerAction = ((TriggerAction.AfterUndelete) triggerAction);
				}
			}
		} catch (System.TypeException e) {
			handleException(INVALID_TYPE_ERROR, className, context);
		}
	}

	/**
	 * @description Handle an exception.
	 *
	 * @param error The error message.
	 * @param className The name of the Trigger Action class.
	 * @param triggerOperation The Trigger Operation context.
	 */
	private void handleException(
		String error,
		String className,
		TriggerOperation triggerOperation
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

	/**
	 * @description Get the Before Insert Trigger Action metadata.
	 *
	 * @return The list of Before Insert Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> beforeInsertActionMetadata {
		get {
			if (beforeInsertActionMetadata == null) {
				beforeInsertActionMetadata = getActionMetadata(
					TriggerOperation.BEFORE_INSERT.name()
				);
			}
			return beforeInsertActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the After Insert Trigger Action metadata.
	 *
	 * @return The list of After Insert Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> afterInsertActionMetadata {
		get {
			if (afterInsertActionMetadata == null) {
				afterInsertActionMetadata = getActionMetadata(
					TriggerOperation.AFTER_INSERT.name()
				);
			}
			return afterInsertActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the Before Update Trigger Action metadata.
	 *
	 * @return The list of Before Update Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> beforeUpdateActionMetadata {
		get {
			if (beforeUpdateActionMetadata == null) {
				beforeUpdateActionMetadata = getActionMetadata(
					TriggerOperation.BEFORE_UPDATE.name()
				);
			}
			return beforeUpdateActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the After Update Trigger Action metadata.
	 *
	 * @return The list of After Update Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> afterUpdateActionMetadata {
		get {
			if (afterUpdateActionMetadata == null) {
				afterUpdateActionMetadata = getActionMetadata(
					TriggerOperation.AFTER_UPDATE.name()
				);
			}
			return afterUpdateActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the Before Delete Trigger Action metadata.
	 *
	 * @return The list of Before Delete Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> beforeDeleteActionMetadata {
		get {
			if (beforeDeleteActionMetadata == null) {
				beforeDeleteActionMetadata = getActionMetadata(
					TriggerOperation.BEFORE_DELETE.name()
				);
			}
			return beforeDeleteActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the After Delete Trigger Action metadata.
	 *
	 * @return The list of After Delete Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> afterDeleteActionMetadata {
		get {
			if (afterDeleteActionMetadata == null) {
				afterDeleteActionMetadata = getActionMetadata(
					TriggerOperation.AFTER_DELETE.name()
				);
			}
			return afterDeleteActionMetadata;
		}
		set;
	}

	/**
	 * @description Get the After Undelete Trigger Action metadata.
	 *
	 * @return The list of After Undelete Trigger Action metadata.
	 */
	@TestVisible
	private List<Trigger_Action__mdt> afterUndeleteActionMetadata {
		get {
			if (afterUndeleteActionMetadata == null) {
				afterUndeleteActionMetadata = getActionMetadata(
					TriggerOperation.AFTER_UNDELETE.name()
				);
			}
			return afterUndeleteActionMetadata;
		}
		set;
	}

	@TestVisible
	private virtual inherited sharing class Selector {
		/**
		 * @description Query the database.
		 *
		 * @param queryString The query string.
		 * @return The list of SObjects returned by the query.
		 */
		public virtual List<SObject> query(String queryString) {
			return Database.query(queryString);
		}
	}

	/**
	 * @description Exception thrown when a Trigger Action is not of the expected type.
	 */
	private class MetadataTriggerHandlerException extends Exception {
	}
}
