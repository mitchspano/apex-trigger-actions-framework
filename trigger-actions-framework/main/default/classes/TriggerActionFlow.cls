/*
   Copyright 2021 Google LLC

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

public inherited sharing class TriggerActionFlow implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.AfterUndelete {
	public String flowName;
	public Boolean allowRecursion;
	@testVisible
	private static final String INVALID_FLOW_NAME = 'You must provide the name of a flow to execute';
	@testVisible
	private static final String NEW_LIST_AFTER_FLOW = 'newListAfterFlow';
	@testVisible
	private static final String NEW_LIST = 'newList';
	@testVisible
	private static final String OLD_LIST = 'oldList';
	@testVisible
	private static final String OLD_RECORD_NOT_FOUND = 'An old version of the record cannot be identified in the oldList';
	@testVisible
	private static final String INVALID_REQUEST = 'You can only pass one getOldRecordRequest into TriggerActionFlow.getOldRecord()';
	@testVisible
	private static final String NEW_LIST_AFTER_FLOW_NOT_POPULATED_CORRECTLY = 'You must pass ALL records back to the newListAfterFlow in order to apply values to record before insert/update';
	@testVisible
	private static final List<Schema.DisplayType> PICKLIST_TYPES = new List<Schema.DisplayType>{
		Schema.DisplayType.MULTIPICKLIST,
		Schema.DisplayType.PICKLIST
	};
	public static final String OBJECT_STRING = 'Object';
	public static final String APEX_STRING = 'Apex';
	public static final String FLOW_STRING = 'Flow';
	public static final String INVALID_BYPASS_REQUEST = 'You can only pass one request into {0}';
	public static final String INVALID_TYPE = 'The bypassType must equal Object, Apex, or Flow';
	public static final Set<String> REQUEST_TYPES = new Set<String>{
		OBJECT_STRING,
		APEX_STRING,
		FLOW_STRING
	};
	@TestVisible
	private static Set<String> bypassedFlows;

	static {
		bypassedFlows = new Set<String>();
	}

	@invocableMethod(
		category='Trigger Action Flow'
		label='Get Old Record'
		description='Returns the old version of a record from oldList'
	)
	public static List<sObject> getOldRecord(List<OldRecordRequest> request) {
		if (request.isEmpty() || request.size() > 1) {
			throw new TriggerActionFlowException(INVALID_REQUEST);
		}
		List<sObject> result;
		if (request[0].currentRecord != null) {
			Map<Id, sObject> oldMap = new Map<Id, sObject>(request[0].oldList);
			if (!oldMap.containsKey(request[0].currentRecord.Id)) {
				throw new TriggerActionFlowException(OLD_RECORD_NOT_FOUND);
			}
			result = new List<sObject>{ oldMap.get(request[0].currentRecord.Id) };
		}
		return result;
	}

	public void beforeInsert(List<SObject> newList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(newList, null)
			);
			myFlow.start();
			applyFlowValues(
				newList,
				(List<sObject>) myFlow.getVariableValue(NEW_LIST_AFTER_FLOW)
			);
		}
	}

	public void afterInsert(List<SObject> newList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(newList, null)
			);
			myFlow.start();
		}
	}

	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		if (!thisFlowIsBypassed()) {
			List<sObject> recordsNotYetProcessed = new List<sObject>();
			for (sObject record : newList) {
				if (
					TriggerBase.idToNumberOfTimesSeenBeforeUpdate.get(record.id) == 1 ||
					(allowRecursion == true)
				) {
					recordsNotYetProcessed.add(record);
				}
			}
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(recordsNotYetProcessed, oldList)
			);
			myFlow.start();
			applyFlowValues(
				newList,
				(List<sObject>) myFlow.getVariableValue(NEW_LIST_AFTER_FLOW)
			);
		}
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		if (!thisFlowIsBypassed()) {
			List<sObject> recordsNotYetProcessed = new List<sObject>();
			for (sObject record : newList) {
				if (
					TriggerBase.idToNumberOfTimesSeenAfterUpdate.get(record.id) == 1 ||
					(allowRecursion == true)
				) {
					recordsNotYetProcessed.add(record);
				}
			}
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(recordsNotYetProcessed, oldList)
			);
			myFlow.start();
		}
	}

	public void beforeDelete(List<SObject> oldList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(null, oldList)
			);
			myFlow.start();
		}
	}

	public void afterDelete(List<SObject> oldList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(null, oldList)
			);
			myFlow.start();
		}
	}

	public void afterUndelete(List<SObject> newList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(newList, null)
			);
			myFlow.start();
		}
	}

	public static void bypass(String flowName) {
		TriggerActionFlow.bypassedFlows.add(flowName);
	}

	public static void clearBypass(String flowName) {
		TriggerActionFlow.bypassedFlows.remove(flowName);
	}

	public static Boolean isBypassed(String flowName) {
		return TriggerActionFlow.bypassedFlows.contains(flowName);
	}

	public static void clearAllBypasses() {
		TriggerActionFlow.bypassedFlows.clear();
	}

	private Boolean thisFlowIsBypassed() {
		if (String.isBlank(flowName)) {
			throw new TriggerActionFlowException(INVALID_FLOW_NAME);
		}
		return TriggerActionFlow.isBypassed(flowName);
	}

	private Map<String, Object> getFlowInput(
		List<SObject> newList,
		List<SObject> oldList
	) {
		Map<String, Object> result = new Map<String, Object>();
		if (newList != null) {
			result.put(NEW_LIST, newList);
		}
		if (oldList != null) {
			result.put(OLD_LIST, oldList);
		}
		return result;
	}

	private void applyFlowValues(
		List<sObject> newList,
		List<sObject> newListAfterFlow
	) {
		if (
			newList != null &&
			!newList.isEmpty() &&
			newListAfterFlow != null &&
			!newListAfterFlow.isEmpty()
		) {
			if (newList.size() != newListAfterFlow.size()) {
				throw new TriggerActionFlowException(
					NEW_LIST_AFTER_FLOW_NOT_POPULATED_CORRECTLY
				);
			}
			List<Schema.DescribeFieldResult> editableFields = new List<Schema.DescribeFieldResult>();
			for (
				Schema.SObjectField fieldRef : newList[0]
					.getSObjectType()
					.getDescribe()
					.fields.getMap()
					.values()
			) {
				Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
				if (fieldResult.isUpdateable()) {
					editableFields.add(fieldResult);
				}
			}
			for (Integer i = 0; i < newList.size(); i++) {
				for (Schema.DescribeFieldResult field : editableFields) {
					String fieldName = field.getName();
					if (newList[i].get(fieldName) != newListAfterFlow[i].get(fieldName)) {
						if (!PICKLIST_TYPES.contains(field.getType())) {
							newList[i].put(fieldName, newListAfterFlow[i].get(fieldName));
						} else {
							String newValue = String.valueOf(
								newListAfterFlow[i].get(fieldName)
							);
							if (!String.isBlank(newValue)) {
								newList[i]
									.put(
										fieldName,
										newValue.remove('[').remove(']').replace(', ', ';')
									);
							} else {
								newList[i].put(fieldName, null);
							}
						}
					}
				}
			}
		}
	}

	public class OldRecordRequest {
		@InvocableVariable(
			label='Current Record'
			description='The current record'
			required=true
		)
		public sObject currentRecord;
		@InvocableVariable(
			label='Old List'
			description='A list of all the records with the old field values'
			required=true
		)
		public List<sObject> oldList;
	}

	class TriggerActionFlowException extends Exception {
	}
}
