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
	public static final String INVALD_FLOW_INPUT = 'The Flow Input Generator must provide a map which contains "triggerRecords" as a key that is mapped to a list of TriggerRecord.';
	public static final String INVALID_INPUT_GENERATOR = ' is not a valid name of a class that implements TriggerActionFlow.GenerateTriggerFlowInput';
	public static final String INVALID_TYPE = 'The bypassType must equal Object, Apex, or Flow';
	public static final String OBJECT_STRING = 'Object';
	public static final String TRIGGER_RECORDS_VARIABLE = 'triggerRecords';
	public static final Set<String> REQUEST_TYPES = new Set<String>{
		OBJECT_STRING,
		APEX_STRING,
		FLOW_STRING
	};
	@TestVisible
	static Set<String> bypassedFlows;

	public String flowName;
	public Boolean allowRecursion;
	public String inputGeneratorClassName;

	static {
		bypassedFlows = new Set<String>();
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

	Map<String, Object> getFlowInput(
		List<sObject> newList,
		List<sObject> oldList
	) {
		GenerateTriggerFlowInput inputGenerator = getInputGenerator();
		Map<String, Object> generatedInput = getInputGenerator()
			.getFlowInput(newList, oldList);
		verifyInput(generatedInput);
		return generatedInput;
	}

	void verifyInput(Map<String, Object> generatedInput) {
		if (
			generatedInput == null ||
			generatedInput.containsKey(TRIGGER_RECORDS_VARIABLE) ||
			!(generatedInput.get(
				TRIGGER_RECORDS_VARIABLE
			) instanceof List<TriggerRecord>)
		) {
			List<TriggerRecord> triggerRecords;
			try {
				triggerRecords = (List<TriggerRecord>) generatedInput.get(
					TRIGGER_RECORDS_VARIABLE
				);
			} catch (Exception e) {
				throw new TriggerActionFlowException(INVALD_FLOW_INPUT);
			}
		}
	}

	private void applyFlowValues(List<sObject> newList) {
		List<String> editableFields = new List<String>();
		for (
			Schema.SObjectField fieldRef : newList[0]
				.getSObjectType()
				.getDescribe()
				.fields.getMap()
				.values()
		) {
			Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
			if (fieldResult.isUpdateable()) {
				editableFields.add(fieldResult.getName());
			}
		}
		for (Integer i = 0; i < newList.size(); i++) {
			SObject recordInNewList = newList[i];
			SObject recordAfterFlowIsComplete = TriggerRecord.newRecordIndexToNewRecord.get(
				i
			);
			if (recordAfterFlowIsComplete != null) {
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
		TriggerRecord.newRecordIndexToNewRecord = new Map<Integer, SObject>();
	}

	GenerateTriggerFlowInput getInputGenerator() {
		GenerateTriggerFlowInput result;
		if (inputGeneratorClassName == null) {
			throw new TriggerActionFlowException(INVALID_INPUT_GENERATOR);
		}
		try {
			result = (GenerateTriggerFlowInput) Type.forName(inputGeneratorClassName)
				.newInstance();
		} catch (Exception e) {
			throw new TriggerActionFlowException(
				inputGeneratorClassName + INVALID_INPUT_GENERATOR
			);
		}
		return result;
	}

	public interface GenerateTriggerFlowInput {
		Map<String, Object> getFlowInput(
			List<SObject> newList,
			List<SObject> oldList
		);
	}

	@TestVisible
	class TriggerActionFlowException extends Exception {
	}
}
