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

@SuppressWarnings('PMD.ApexDoc, PMD.CyclomaticComplexity')
public virtual inherited sharing class TriggerActionFlow implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
	@TestVisible
	private static final String RECORD_VARIABLE_NOT_FOUND_ERROR = 'There must be a variable defined in this flow with api name of "record" and type of "record" that is marked as "available for output"';
	@TestVisible
	private static Set<String> bypassedFlows = new Set<String>();
	@TestVisible
	private static InvocableAction invocableAction = new InvocableAction();

	public String flowName;
	public Boolean allowRecursion;

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

	public static void validateType(String bypassType) {
		if (!TriggerActionConstants.REQUEST_TYPES.contains(bypassType)) {
			throw new IllegalArgumentException(TriggerActionConstants.INVALID_TYPE);
		}
	}

	public void beforeInsert(List<SObject> newList) {
		if (flowIsBypassed()) {
			return;
		}
		List<Invocable.Action.Result> results = invokeAction(
			getInterviewInputs(newList, TriggerActionConstants.RECORD_VARIABLE)
		);
		handleInvocableResults(results, newList);
		applyFieldValuesDuringBefore(results, newList);
	}

	public void afterInsert(List<SObject> newList) {
		if (flowIsBypassed()) {
			return;
		}
		handleInvocableResults(
			invokeAction(
				getInterviewInputs(newList, TriggerActionConstants.RECORD_VARIABLE)
			),
			newList
		);
	}

	public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		if (flowIsBypassed()) {
			return;
		}
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
		if (recordsNotYetProcessed.isEmpty()) {
			return;
		}
		List<Invocable.Action.Result> results = invokeAction(
			getInterviewInputs(recordsNotYetProcessed, oldRecordsNotYetProcessed)
		);
		handleInvocableResults(results, recordsNotYetProcessed);
		applyFieldValuesDuringBefore(results, recordsNotYetProcessed);
	}

	public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		if (flowIsBypassed()) {
			return;
		}
		List<sObject> recordsNotYetProcessed = new List<sObject>();
		List<sObject> oldRecordsNotYetProcessed = new List<sObject>();
		for (Integer i = 0; i < newList.size(); i++) {
			sObject record = newList[i];
			if (
				TriggerBase.idToNumberOfTimesSeenAfterUpdate.get(record.id) == 1 ||
				(allowRecursion == true)
			) {
				recordsNotYetProcessed.add(record);
				oldRecordsNotYetProcessed.add(oldList[i]);
			}
		}
		if (recordsNotYetProcessed.isEmpty()) {
			return;
		}
		handleInvocableResults(
			invokeAction(
				getInterviewInputs(recordsNotYetProcessed, oldRecordsNotYetProcessed)
			),
			recordsNotYetProcessed
		);
	}

	public void beforeDelete(List<SObject> oldList) {
		if (flowIsBypassed()) {
			return;
		}
		handleInvocableResults(
			invokeAction(
				getInterviewInputs(
					oldList,
					TriggerActionConstants.RECORD_PRIOR_VARIABLE
				)
			),
			oldList
		);
	}

	public void afterDelete(List<SObject> oldList) {
		if (flowIsBypassed()) {
			return;
		}
		handleInvocableResults(
			invokeAction(
				getInterviewInputs(
					oldList,
					TriggerActionConstants.RECORD_PRIOR_VARIABLE
				)
			),
			oldList
		);
	}

	public void afterUndelete(List<SObject> newList) {
		if (flowIsBypassed()) {
			return;
		}
		handleInvocableResults(
			invokeAction(
				getInterviewInputs(newList, TriggerActionConstants.RECORD_VARIABLE)
			),
			newList
		);
	}

	private Boolean flowIsBypassed() {
		if (String.isBlank(flowName)) {
			throw new IllegalArgumentException(
				TriggerActionConstants.INVALID_FLOW_NAME
			);
		}
		return TriggerActionFlow.isBypassed(flowName);
	}

	private List<Invocable.Action.Result> invokeAction(
		List<Map<String, Object>> inputs
	) {
		return invocableAction.invokeAction(this.flowName, inputs);
	}

	private void applyFlowValues(
		sObject stateBeforeFlow,
		sObject stateAfterFlow
	) {
		Boolean hasBeenMutated = false;
		Map<String, Object> afterFlowMap = stateAfterFlow.getPopulatedFieldsAsMap();
		for (String fieldName : afterFlowMap.keySet()) {
			if (stateBeforeFlow.get(fieldName) != stateAfterFlow.get(fieldName)) {
				stateBeforeFlow.put(fieldName, stateAfterFlow.get(fieldName));
				hasBeenMutated = true;
			}
		}
		/**
		 * If the record is not mutated, then any errors will persist after the flow is complete,
		 * so there is no need to re-add them
		 */
		if (hasBeenMutated == false) {
			return;
		}
		for (Database.Error err : stateAfterFlow.getErrors()) {
			/**
			 * Unfortunately, err.getFields() does not include the field api name after
			 * calling .addError(String fieldApiName, String message) from within a flow,
			 * so when the record is mutated before save,
			 * the exact field location for the error cannot be applied.
			 */
			stateBeforeFlow.addError(err.getMessage());
		}
	}

	private List<Map<String, Object>> getInterviewInputs(
		List<SObject> newList,
		List<SObject> oldList
	) {
		List<Map<String, Object>> result = new List<Map<String, Object>>();
		for (Integer i = 0; i < newList.size(); i++) {
			SObject oldRecord = oldList[i];
			SObject newRecord = newList[i];
			result.add(
				new Map<String, Object>{
					TriggerActionConstants.RECORD_PRIOR_VARIABLE => oldRecord,
					TriggerActionConstants.RECORD_VARIABLE => newRecord
				}
			);
		}
		return result;
	}

	protected virtual List<Map<String, Object>> getInterviewInputs(
		List<SObject> records,
		String variableName
	) {
		List<Map<String, Object>> result = new List<Map<String, Object>>();
		for (Integer i = 0; i < records.size(); i++) {
			result.add(new Map<String, Object>{ variableName => records[i] });
		}
		return result;
	}

	private void applyFieldValuesDuringBefore(
		List<Invocable.Action.Result> results,
		List<SObject> newList
	) {
		for (Integer i = 0; i < results.size(); i++) {
			Invocable.Action.Result result = results[i];
			if (result.isSuccess() == true) {
				SObject newRecordWhenFlowIsComplete = (SObject) (result.getOutputParameters()
					.get(TriggerActionConstants.RECORD_VARIABLE));
				if (newRecordWhenFlowIsComplete == null) {
					throw new IllegalArgumentException(
						this.flowName + ': ' + RECORD_VARIABLE_NOT_FOUND_ERROR
					);
				}
				applyFlowValues(newList[i], newRecordWhenFlowIsComplete);
			}
		}
	}

	private void handleInvocableResults(
		List<Invocable.Action.Result> results,
		List<SObject> records
	) {
		for (Integer i = 0; i < results.size(); i++) {
			Invocable.Action.Result result = results[i];
			if (result.isSuccess() == false) {
				records[i].addError(getFormattedErrorMessage(result.getErrors()));
			}
		}
	}

	private String getFormattedErrorMessage(List<Invocable.Action.Error> errors) {
		List<String> messagesAndCodes = new List<String>();
		for (Invocable.Action.Error error : errors) {
			messagesAndCodes.add(error.getCode() + ' - ' + error.getMessage());
		}
		return this.flowName + ': ' + String.join(messagesAndCodes, ', ');
	}

	@TestVisible
	private virtual class InvocableAction {
		public virtual List<Invocable.Action.Result> invokeAction(
			String flowApiName,
			List<Map<String, Object>> inputs
		) {
			Invocable.Action action = Invocable.Action.createCustomAction(
				TriggerActionConstants.FLOW_STRING,
				flowApiName
			);
			action.setInvocations(inputs);
			return action.invoke();
		}
	}
}
