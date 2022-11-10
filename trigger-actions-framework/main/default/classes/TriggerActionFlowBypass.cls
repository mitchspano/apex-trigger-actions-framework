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

public inherited sharing class TriggerActionFlowBypass {
	@TestVisible
	private static final String CLASS_NAME = 'TriggerActionFlowBypass';
	@TestVisible
	private static final String INVALID_REQUEST = String.format(
		TriggerActionFlow.INVALID_BYPASS_REQUEST,
		new List<String>{ CLASS_NAME }
	);

	@InvocableMethod(
		category='Trigger Action Flow'
		label='Bypass'
		description='Sets the static bypass to true for this object, apex action, or flow action.'
	)
	public static void bypass(List<Request> requests) {
		if (!TriggerActionFlow.REQUEST_TYPES.contains(requests[0].bypassType)) {
			throw new TriggerActionFlowBypassObjectException(
				TriggerActionFlow.INVALID_TYPE
			);
		}
		if (requests[0].bypassType == TriggerActionFlow.OBJECT_STRING) {
			TriggerBase.bypass(requests[0].name);
		}
		if (requests[0].bypassType == TriggerActionFlow.APEX_STRING) {
			MetadataTriggerHandler.bypass(requests[0].name);
		}
		if (requests[0].bypassType == TriggerActionFlow.FLOW_STRING) {
			TriggerActionFlow.bypass(requests[0].name);
		}
	}

	public class Request {
		@InvocableVariable(
			label='Name'
			description='API Name of the trigger action flow, class, or sObject'
			required=true
		)
		public String name;
		@InvocableVariable(
			label='Bypass Type'
			description='Apex, Flow, or Object'
			required=true
		)
		public String bypassType;
	}

	public class TriggerActionFlowBypassObjectException extends Exception {
	}
}
