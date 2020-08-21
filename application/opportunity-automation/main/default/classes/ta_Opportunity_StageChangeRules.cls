/*
   Copyright 2020 Google LLC

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

public class ta_Opportunity_StageChangeRules implements TriggerAction.BeforeUpdate {
	
	@TestVisible
	private static final String INVALID_STAGE_CHANGE_ERROR = 'You cannot change Stage from {0} to {1}';
	
	private static final Map<String,Set<String> > currentStageToNextAllowedStage = new Map<String,Set<String> > {
		Constants.OPPORTUNITY_STAGENAME_PROSPECTING => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_QUALIFICATION,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_QUALIFICATION => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_NEEDS_ANALYSIS,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_NEEDS_ANALYSIS => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_VALUE_PROPOSITION,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_VALUE_PROPOSITION => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_ID_DECISION_MAKERS,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_ID_DECISION_MAKERS => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_PERCEPTION_ANALYSIS,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_PERCEPTION_ANALYSIS => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_PROPOSAL_PRICE_QUOTE,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_PROPOSAL_PRICE_QUOTE => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_NEGOTIATION_REVIEW,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_NEGOTIATION_REVIEW => new Set<String> {
			Constants.OPPORTUNITY_STAGENAME_CLOSED_WON,
			Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST
		},
		Constants.OPPORTUNITY_STAGENAME_CLOSED_LOST => new Set<String>(),
		Constants.OPPORTUNITY_STAGENAME_CLOSED_WON => new Set<String>()
	};
	
	public void beforeUpdate(List<Opportunity> newList, List<Opportunity> oldList) {
		Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>(oldList);
		for (Opportunity opp : newList) {
			if (opp.StageName != oldMap.get(opp.Id).StageName && !currentStageToNextAllowedStage.get(oldMap.get(opp.Id).StageName).contains(opp.StageName)) {
				opp.addError(String.format(INVALID_STAGE_CHANGE_ERROR, new String[] {oldMap.get(opp.Id).StageName, opp.StageName}));
			}
		}
	}
	
}
