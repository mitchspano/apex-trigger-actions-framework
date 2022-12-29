/*
   Copyright 2022 Google LLC

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
public inherited sharing abstract class TriggerActionFlowBypassProcessor {
	public void execute(String requestType, String requestName) {
		if (!TriggerActionConstants.REQUEST_TYPES.contains(requestType)) {
			throw new IllegalArgumentException(TriggerActionConstants.INVALID_TYPE);
		} else if (requestType == TriggerActionConstants.FLOW_STRING) {
			this.processFlowBypasses(requestName);
		} else if (requestType == TriggerActionConstants.APEX_STRING) {
			this.processApexBypasses(requestName);
		} else if (requestType == TriggerActionConstants.OBJECT_STRING) {
			this.processObjectBypasses(requestName);
		}
	}

	protected abstract void processApexBypasses(String requestType);
	protected abstract void processFlowBypasses(String requestType);
	protected abstract void processObjectBypasses(String requestType);
}
