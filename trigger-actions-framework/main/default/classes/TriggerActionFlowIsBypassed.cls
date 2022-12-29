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
public inherited sharing class TriggerActionFlowIsBypassed {
	@InvocableMethod(
		category='Trigger Action Flow'
		label='Is Bypassed'
		description='Returns if the bypass for this object, apex action, or flow action is set to true.'
	)
	public static List<Boolean> isBypassed(List<Request> requests) {
		List<Boolean> results = new List<Boolean>();
		FlowIsBypassedProcesser bypassProcesser = new FlowIsBypassedProcesser();
		for (Request myRequest : requests) {
			bypassProcesser.execute(myRequest.bypassType, myRequest.name);
			results.add(bypassProcesser.getHasBeenBypassed());
		}
		return results;
	}

	public class Request {
		@InvocableVariable
		public String name;
		@InvocableVariable
		public String bypassType;
	}

	private class FlowIsBypassedProcesser extends TriggerActionFlowBypassProcessor {
		private Boolean hasBeenBypassed = false;

		public Boolean getHasBeenBypassed() {
			return this.hasBeenBypassed;
		}

		protected override void processApexBypasses(String name) {
			this.hasBeenBypassed = MetadataTriggerHandler.isBypassed(name);
		}

		protected override void processFlowBypasses(String name) {
			this.hasBeenBypassed = TriggerActionFlow.isBypassed(name);
		}

		protected override void processObjectBypasses(String name) {
			this.hasBeenBypassed = TriggerBase.isBypassed(name);
		}
	}
}
