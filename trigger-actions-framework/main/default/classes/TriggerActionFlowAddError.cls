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

@SuppressWarnings('PMD.ApexDoc')
public inherited sharing class TriggerActionFlowAddError {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Add Error'
		description='Adds an error to an sObject'
	)
	public static void addError(List<Request> requests) {
		for (Request myRequest : requests) {
			if (!String.isBlank(myRequest.fieldName)) {
				myRequest.record.addError(myRequest.fieldName, myRequest.errorMessage);
			} else {
				myRequest.record.addError(myRequest.errorMessage);
			}
		}
	}

	public class Request {
		@InvocableVariable(
			label='Record'
			description='Record to add the error to'
			required=true
		)
		public SObject record;
		@InvocableVariable(
			label='Field Name'
			description='API name of corresponding field'
		)
		public String fieldName;
		@InvocableVariable(
			label='Error Message'
			description='Error Message'
			required=true
		)
		public String errorMessage;
	}
}
