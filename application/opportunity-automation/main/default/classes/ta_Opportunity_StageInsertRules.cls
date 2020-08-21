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

public class ta_Opportunity_StageInsertRules implements TriggerAction.BeforeInsert {
	
	@TestVisible
	private static final String INVALID_STAGE_INSERT_ERROR = String.format('The Stage must be {0} when an Opportunity is created', new String[] {Constants.OPPORTUNITY_STAGENAME_PROSPECTING});
	
	public void beforeInsert(List<Opportunity> newList){
		for (Opportunity opp : newList) {
			if (opp.StageName != Constants.OPPORTUNITY_STAGENAME_PROSPECTING) {
				opp.addError(INVALID_STAGE_INSERT_ERROR);
			}
		}
	}
	
}
