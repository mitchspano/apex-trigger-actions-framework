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
@SuppressWarnings('PMD.ApexDoc, PMD.CognitiveComplexity')
public inherited sharing class TriggerActionFlowClearBypass {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Clear Bypass'
		description='Sets the static bypass to false for this object, apex action, or flow action.'
	)
	public static void clearBypass(List<Request> requests) {
		TriggerActionFlowBypassProcessor bypassProcesser = new FlowClearBypassProcessor();
		for (Request myRequest : requests) {
			bypassProcesser.execute(myRequest.bypassType, myRequest.name);
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

	private class FlowClearBypassProcessor extends TriggerActionFlowBypassProcessor {
		protected override void processApexBypasses(String name) {
			MetadataTriggerHandler.clearBypass(name);
		}

		protected override void processFlowBypasses(String name) {
			TriggerActionFlow.clearBypass(name);
		}

		protected override void processObjectBypasses(String name) {
			TriggerBase.clearBypass(name);
		}
	}
}
