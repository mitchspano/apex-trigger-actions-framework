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

global class ta_IsRecordChanged_Invc {
	@InvocableMethod
	global static List<sObject> getOldRecord(List<getOldRecordRequest> request) {
		if (request.isEmpty() || request.size() > 1) {
			throw new ta_Flow_Exception(INVALID_REQUEST);
		}
		Map<Id, sObject> oldMap = new Map<Id, sObject>(request[0].oldList);
		if (!oldMap.containsKey(request[0].currentRecord.Id)) {
			throw new ta_Flow_Exception(OLD_RECORD_NOT_FOUND);
		}
		return new List<sObject>{ oldMap.get(request[0].currentRecord.Id) };
	}

	global class getOldRecordRequest {
		@InvocableVariable
		global sObject currentRecord;

		@InvocableVariable
		global List<sObject> oldList;
	}

	@testVisible
	private static final String OLD_RECORD_NOT_FOUND = 'An old version of the record cannot be identified in the oldList';
	@testVisible
	private static final String INVALID_REQUEST = 'You can only pass one getOldRecordRequest into ta_IsRecordChanged_Invc.getOldRecord()';
	class ta_Flow_Exception extends Exception{}
}
