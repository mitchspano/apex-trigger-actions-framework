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
public inherited sharing class TriggerActionFlowIsBypassed {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Is Bypassed'
		description='Returns if the bypass for this object, apex action, or flow action is set to true.'
	)
	public static List<Boolean> isBypassed(List<Request> requests) {
		List<Boolean> results = new List<Boolean>();
		for (Request current : requests) {
			TriggerActionFlow.validateType(current.bypassType);
			Boolean result = false;
			if (current.bypassType == TriggerActionFlow.OBJECT_STRING) {
				result = TriggerBase.isBypassed(current.name);
			} else if (current.bypassType == TriggerActionFlow.APEX_STRING) {
				result = MetadataTriggerHandler.isBypassed(current.name);
			} else if (current.bypassType == TriggerActionFlow.FLOW_STRING) {
				result = TriggerActionFlow.isBypassed(current.name);
			}
			results.add(result);
		}
		return results;
	}

	public class Request {
		@InvocableVariable
		public String name;
		@InvocableVariable
		public String bypassType;
	}
}
