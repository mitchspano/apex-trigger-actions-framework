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

public inherited sharing class TriggerActionFlowIsBypassed {
	@TestVisible
	private static final String CLASS_NAME = 'TriggerActionFlowIsBypassed';
	@TestVisible
	private static final String INVALID_REQUEST = String.format(
		TriggerActionFlow.INVALID_BYPASS_REQUEST,
		new List<String>{ CLASS_NAME }
	);

	@invocableMethod(
		category='Trigger Action Flow'
		label='Is Bypassed'
		description='Returns if the bypass for this object, apex action, or flow action is set to true.'
	)
	public static List<Boolean> isBypassed(List<Request> requests) {
		if (requests.size() != 1) {
			throw new TriggerActionFlowIsBypassedObjectException(INVALID_REQUEST);
		}
		if (!TriggerActionFlow.REQUEST_TYPES.contains(requests[0].bypassType)) {
			throw new TriggerActionFlowIsBypassedObjectException(
				TriggerActionFlow.INVALID_TYPE
			);
		}
		Boolean result = false;
		if (requests[0].bypassType == TriggerActionFlow.OBJECT_STRING) {
			result = TriggerBase.isBypassed(requests[0].name);
		}
		if (requests[0].bypassType == TriggerActionFlow.APEX_STRING) {
			result = MetadataTriggerHandler.isBypassed(requests[0].name);
		}
		if (requests[0].bypassType == TriggerActionFlow.FLOW_STRING) {
			result = TriggerActionFlow.isBypassed(requests[0].name);
		}
		return new List<Boolean>{ result };
	}

	public class Request {
		@InvocableVariable
		public String name;
		@InvocableVariable
		public String bypassType;
	}

	public class TriggerActionFlowIsBypassedObjectException extends Exception {
	}
}
