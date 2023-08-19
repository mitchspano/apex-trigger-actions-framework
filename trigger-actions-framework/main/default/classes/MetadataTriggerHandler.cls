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
@SuppressWarnings('PMD.ApexDoc, PMD.CognitiveComplexity')
public inherited sharing class MetadataTriggerHandler extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
	private static final String DOUBLE_UNDERSCORE = '__';
	private static final String EMPTY_STRING = '';
	@TestVisible
	private static final String INVALID_TYPE_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not implement the Trigger Action interface specified for the {1} context.';
	@TestVisible
	private static final String INVALID_TYPE_ERROR_FINALIZER = 'Please check the DML Finalizer Custom Metadata. The {0} class does not implement the TriggerAction.DmlFinalizer interface.';
	@TestVisible
	private static final String INVALID_CLASS_ERROR = 'Please check the Trigger Action Custom Metadata for the {1} context on the {2} sObject. The {0} class does not exist.';
	@TestVisible
	private static final String INVALID_CLASS_ERROR_FINALIZER = 'Please check the DML Finalizer Custom Metadata. The {0} class does not exist.';
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

	public void beforeInsert(List<SObject> newList) {
		this.executeActions(TriggerOperation.BEFORE_INSERT, newList, null);
	}

	public void afterInsert(List<SObject> newList) {
		this.executeActions(TriggerOperation.AFTER_INSERT, newList, null);
	}

	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		this.executeActions(TriggerOperation.BEFORE_UPDATE, newList, oldList);
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		this.executeActions(TriggerOperation.AFTER_UPDATE, newList, oldList);
	}

	public void beforeDelete(List<SObject> oldList) {
		this.executeActions(TriggerOperation.BEFORE_DELETE, null, oldList);
	}

	public void afterDelete(List<SObject> oldList) {
		this.executeActions(TriggerOperation.AFTER_DELETE, null, oldList);
	}

	public void afterUndelete(List<SObject> newList) {
		this.executeActions(TriggerOperation.AFTER_UNDELETE, newList, null);
	}

	@TestVisible
	protected override void finalizeTrigger() {
		List<DML_Finalizer__mdt> sortedFinalizers = getSortedFinalizers();
		for (DML_Finalizer__mdt finalizerMetadata : sortedFinalizers) {
			if (finalizerMetadata.Bypass_Execution__c) {
				return;
			}
			populatePermissionMap(finalizerMetadata.Bypass_Permission__c);
			populatePermissionMap(finalizerMetadata.Required_Permission__c);
			if (
				isNotBypassed(
					finalizerMetadata.Bypass_Permission__c,
					finalizerMetadata.Required_Permission__c
				)
			) {
				callReferencedFinalizer(finalizerMetadata);
			}
		}
	}

	private void callReferencedFinalizer(DML_Finalizer__mdt finalizerMetadata) {
		Object dynamicInstance;
		String className = finalizerMetadata.Apex_Class_Name__c;
		try {
			dynamicInstance = Type.forName(className).newInstance();
		} catch (System.NullPointerException e) {
			handleFinalizerException(INVALID_CLASS_ERROR_FINALIZER, className);
		}
		TriggerAction.DmlFinalizer finalizer;
		try {
			finalizer = (TriggerAction.DmlFinalizer) dynamicInstance;
		} catch (Exception e) {
			handleFinalizerException(INVALID_TYPE_ERROR_FINALIZER, className);
		}
		finalizer.execute();
	}

	private void handleFinalizerException(String errorFormat, String className) {
		throw new MetadataTriggerHandlerException(
			String.format(errorFormat, new List<String>{ className })
		);
	}

	private void populatePermissionMap(String permissionName) {
		if (permissionName != null && !permissionMap.containsKey(permissionName)) {
			permissionMap.put(
				permissionName,
				FeatureManagement.checkPermission(permissionName)
			);
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

	private static boolean isNotBypassed(
		String requiredPermission,
		String bypassPermission
	) {
		return !((requiredPermission != null &&
		permissionMap.get(requiredPermission)) ||
		(bypassPermission != null && !permissionMap.get(bypassPermission)));
	}

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

	private List<DML_Finalizer__mdt> getSortedFinalizers() {
		List<FinalizerSorter> sorters = new List<FinalizerSorter>();
		for (DML_Finalizer__mdt finalizer : this.allFinalizers) {
			sorters.add(new FinalizerSorter(finalizer));
		}
		List<DML_Finalizer__mdt> results = new List<DML_Finalizer__mdt>();
		sorters.sort();
		for (FinalizerSorter sorter : sorters) {
			results.add(sorter.metadata);
		}
		return results;
	}

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
	private List<DML_Finalizer__mdt> allFinalizers {
		get {
			if (allFinalizers == null) {
				allFinalizers = DML_Finalizer__mdt.getAll().values();
			}
			return allFinalizers;
		}
		private set;
	}

	private class FinalizerSorter implements Comparable {
		public final DML_Finalizer__mdt metadata;

		public FinalizerSorter(DML_Finalizer__mdt metadata) {
			this.metadata = metadata;
		}

		public Integer compareTo(Object other) {
			Decimal difference = (this.metadata.Order__c -
			((FinalizerSorter) other).metadata.Order__c);
			return difference < 0 ? -1 : difference == 0 ? 0 : 1;
		}
	}

	@TestVisible
	private virtual inherited sharing class Selector {
		public virtual List<SObject> query(String queryString) {
			return Database.query(queryString);
		}
	}

	private class MetadataTriggerHandlerException extends Exception {
	}
}
