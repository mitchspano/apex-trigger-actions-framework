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
	public static final String APEX_STRING = 'Apex';
	public static final String FLOW_STRING = 'Flow';
	public static final String INVALID_BYPASS_REQUEST = 'You can only pass one request into {0}';
	public static final String INVALID_FLOW_NAME = 'You must provide the name of a flow to execute';
	public static final String INVALD_FLOW_INPUT = 'The Flow Input Generator must provide a map which contains "triggerRecords" as a key that is mapped to a list of FlowTriggerRecord.';
	public static final String INVALID_FLOW_TRIGGER_RECORD_CLASS = ' is not a valid name of a class that extends FlowTriggerRecord';
	public static final String INVALID_TYPE = 'The bypassType must equal Object, Apex, or Flow';
	public static final String OBJECT_STRING = 'Object';
	public static final String TRIGGER_RECORDS_VARIABLE = 'triggerRecords';
	public static final Set<String> REQUEST_TYPES = new Set<String>{
		OBJECT_STRING,
		APEX_STRING,
		FLOW_STRING
	};
	private static final String PIPE = '|';
	@TestVisible
	private static Set<String> bypassedFlows = new Set<String>();
	private static Map<Schema.SObjectType, List<String>> sObjectToEditableFields = new Map<Schema.SObjectType, List<String>>();
	private static Set<Integer> usedIdentifiers = new Set<Integer>();

	public String flowName;
	public Boolean allowRecursion;
	public String flowTriggerRecordClassName;

	private Integer identifier;

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

	public TriggerActionFlow() {
		boolean foundNovelIdentifier = false;
		while (foundNovelIdentifier == false) {
			Integer random = Crypto.getRandomInteger();
			if (usedIdentifiers.contains(random)) {
				continue;
			} else {
				identifier = random;
				usedIdentifiers.add(identifier);
				foundNovelIdentifier = true;
			}
		}
	}

	public void beforeInsert(List<SObject> newList) {
		if (!thisFlowIsBypassed()) {
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(newList, null)
			);
			myFlow.start();
			applyFlowValues(newList);
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
			List<sObject> oldRecordsNotYetProcessed = new List<sObject>();
			for (Integer i = 0; i < newList.size(); i++) {
				sObject record = newList[i];
				if (
					TriggerBase.idToNumberOfTimesSeenBeforeUpdate.get(record.id) == 1 ||
					(allowRecursion == true)
				) {
					recordsNotYetProcessed.add(record);
					oldRecordsNotYetProcessed.add(oldList[i]);
				}
			}
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(recordsNotYetProcessed, oldRecordsNotYetProcessed)
			);
			myFlow.start();
			applyFlowValues(newList);
		}
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		if (!thisFlowIsBypassed()) {
			List<sObject> recordsNotYetProcessed = new List<sObject>();
			List<sObject> oldRecordsNotYetProcessed = new List<sObject>();
			for (Integer i = 0; i < newList.size(); i++) {
				sObject record = newList[i];
				if (
					TriggerBase.idToNumberOfTimesSeenBeforeUpdate.get(record.id) == 1 ||
					(allowRecursion == true)
				) {
					recordsNotYetProcessed.add(record);
					oldRecordsNotYetProcessed.add(oldList[i]);
				}
			}
			Flow.Interview myFlow = Flow.Interview.createInterview(
				flowName,
				getFlowInput(recordsNotYetProcessed, oldRecordsNotYetProcessed)
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

	private Boolean thisFlowIsBypassed() {
		if (String.isBlank(flowName)) {
			throw new TriggerActionFlowException(INVALID_FLOW_NAME);
		}
		return TriggerActionFlow.isBypassed(flowName);
	}

	private Map<String, Object> getFlowInput(
		List<sObject> newList,
		List<sObject> oldList
	) {
		Map<String, Object> generatedInput = getFlowTriggerRecord()
			.getFlowInput(newList, oldList, this.identifier);
		verifyInput(generatedInput);
		return generatedInput;
	}

	private void verifyInput(Map<String, Object> generatedInput) {
		if (
			generatedInput == null ||
			generatedInput.containsKey(TRIGGER_RECORDS_VARIABLE) ||
			!(generatedInput.get(
				TRIGGER_RECORDS_VARIABLE
			) instanceof List<FlowTriggerRecord>)
		) {
			List<FlowTriggerRecord> triggerRecords;
			try {
				triggerRecords = (List<FlowTriggerRecord>) generatedInput.get(
					TRIGGER_RECORDS_VARIABLE
				);
			} catch (Exception e) {
				throw new TriggerActionFlowException(INVALD_FLOW_INPUT);
			}
		}
	}

	private void applyFlowValues(List<sObject> newList) {
		Schema.SObjectType newRecordSObjectType = newList[0].getSObjectType();
		List<String> editableFields = new List<String>();

		if (sObjectToEditableFields.containsKey(newRecordSObjectType)) {
			editableFields = sObjectToEditableFields.get(newRecordSObjectType);
		} else {
			editableFields = getEditableFields(newRecordSObjectType);
			sObjectToEditableFields.put(newRecordSObjectType, editableFields);
		}

		for (Integer i = 0; i < newList.size(); i++) {
			SObject recordInNewList = newList[i];
			SObject recordAfterFlowIsComplete = FlowTriggerRecord.triggerActionFlowIdAndIndexToNewRecord.get(
				this.identifier +
				PIPE +
				i
			);
			for (String fieldName : editableFields) {
				if (
					recordInNewList.get(fieldName) !=
					recordAfterFlowIsComplete.get(fieldName)
				) {
					recordInNewList.put(
						fieldName,
						recordAfterFlowIsComplete.get(fieldName)
					);
				}
			}
		}
	}

	private List<String> getEditableFields(
		Schema.SObjectType newRecordSObjectType
	) {
		List<String> editableFields = new List<String>();
		for (
			Schema.SObjectField fieldRef : newRecordSObjectType
				.getDescribe()
				.fields.getMap()
				.values()
		) {
			Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
			if (fieldResult.isUpdateable()) {
				editableFields.add(fieldResult.getName());
			}
		}
		return editableFields;
	}

	private FlowTriggerRecord getFlowTriggerRecord() {
		FlowTriggerRecord result;
		if (flowTriggerRecordClassName == null) {
			throw new TriggerActionFlowException(
				flowTriggerRecordClassName + INVALID_FLOW_TRIGGER_RECORD_CLASS
			);
		}
		try {
			result = (FlowTriggerRecord) Type.forName(flowTriggerRecordClassName)
				.newInstance();
		} catch (Exception e) {
			throw new TriggerActionFlowException(
				flowTriggerRecordClassName + INVALID_FLOW_TRIGGER_RECORD_CLASS
			);
		}
		return result;
	}

	@TestVisible
	private class TriggerActionFlowException extends Exception {
	}
}
