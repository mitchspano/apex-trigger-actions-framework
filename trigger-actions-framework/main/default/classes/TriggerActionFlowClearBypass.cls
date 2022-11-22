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
@SuppressWarnings('PMD.CognitiveComplexity')
public inherited sharing class TriggerActionFlowClearBypass {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Clear Bypass'
		description='Sets the static bypass to false for this object, apex action, or flow action.'
	)
	public static void clearBypass(List<Request> requests) {
		for (Request current : requests) {
			TriggerActionFlow.validateType(current.bypassType);
			if (current.bypassType == TriggerActionFlow.OBJECT_STRING) {
				TriggerBase.clearBypass(current.name);
			} else if (current.bypassType == TriggerActionFlow.APEX_STRING) {
				MetadataTriggerHandler.clearBypass(current.name);
			} else if (current.bypassType == TriggerActionFlow.FLOW_STRING) {
				TriggerActionFlow.clearBypass(current.name);
			}
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
}
