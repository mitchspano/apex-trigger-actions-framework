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
public inherited sharing class TriggerActionFlowClearAllBypasses {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Clear All Bypasses'
		description='Sets the static bypass to false for all objects, apex actions, or flow actions.'
	)
	public static void clearAllBypasses(List<String> requests) {
		TriggerActionFlowBypassProcessor bypassProcessor = new ClearBypassesProcessor();
		for (String myRequest : requests) {
			bypassProcessor.execute(myRequest, myRequest);
		}
	}

	private class ClearBypassesProcessor extends TriggerActionFlowBypassProcessor {
		protected override void processApexBypasses(String name) {
			MetadataTriggerHandler.clearAllBypasses();
		}

		protected override void processFlowBypasses(String name) {
			TriggerActionFlow.clearAllBypasses();
		}

		protected override void processObjectBypasses(String name) {
			TriggerBase.clearAllBypasses();
		}
	}
}
