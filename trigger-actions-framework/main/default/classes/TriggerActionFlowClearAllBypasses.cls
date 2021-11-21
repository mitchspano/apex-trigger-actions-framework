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

public inherited sharing class TriggerActionFlowClearAllBypasses {
	@TestVisible
	private static final String CLASS_NAME = 'TriggerActionFlowClearAllBypasses';
	@TestVisible
	private static final String INVALID_REQUEST = String.format(
		TriggerActionFlow.INVALID_BYPASS_REQUEST,
		new List<String>{ CLASS_NAME }
	);

	@InvocableMethod(
		category='Trigger Action Flow'
		label='Clear All Bypasses'
		description='Sets the static bypass to false for all objects, apex actions, or flow actions.'
	)
	public static void clearAllBypasses(List<String> requests) {
		if (requests.size() != 1) {
			throw new TriggerActionFlowClearAllBypassesObjectException(
				INVALID_REQUEST
			);
		}
		if (!TriggerActionFlow.REQUEST_TYPES.contains(requests[0])) {
			throw new TriggerActionFlowClearAllBypassesObjectException(
				TriggerActionFlow.INVALID_TYPE
			);
		}
		if (requests[0] == TriggerActionFlow.OBJECT_STRING) {
			TriggerBase.clearAllBypasses();
		}
		if (requests[0] == TriggerActionFlow.APEX_STRING) {
			MetadataTriggerHandler.clearAllBypasses();
		}
		if (requests[0] == TriggerActionFlow.FLOW_STRING) {
			TriggerActionFlow.clearAllBypasses();
		}
	}

	public class TriggerActionFlowClearAllBypassesObjectException extends Exception {
	}
}
