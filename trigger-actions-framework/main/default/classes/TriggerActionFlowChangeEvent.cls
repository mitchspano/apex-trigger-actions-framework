/*
   Copyright 2023 Google LLC

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
@SuppressWarnings('PMD.ApexDoc')
public with sharing class TriggerActionFlowChangeEvent extends TriggerActionFlow {
	@TestVisible
	private static final String CHANGE_EVENT_HEADER = 'ChangeEventHeader';
	@TestVisible
	private static final String HEADER = 'header';
	@TestVisible
	private static final String NOT_CHANGE_EVENT_ERROR = 'TriggerActionFlowChangeEvent can only be used on change events.';

	@TestVisible
	protected override List<Map<String, Object>> getInterviewInputs(
		List<SObject> records,
		String variableName
	) {
		validateInputs(records, variableName);
		List<Map<String, Object>> result = new List<Map<String, Object>>();
		for (Integer i = 0; i < records.size(); i++) {
			result.add(
				new Map<String, Object>{
					variableName => records[i],
					HEADER => new FlowChangeEventHeader(
						(EventBus.ChangeEventHeader) records[i].get(CHANGE_EVENT_HEADER)
					)
				}
			);
		}
		return result;
	}

	private void validateInputs(List<SObject> records, String variableName) {
		if (records == null || records.isEmpty()) {
			return;
		}
		try {
			records[0].get(CHANGE_EVENT_HEADER);
		} catch (System.SObjectException e) {
			throw new IllegalArgumentException(NOT_CHANGE_EVENT_ERROR);
		}
	}
}
