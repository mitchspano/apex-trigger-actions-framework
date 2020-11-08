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

@IsTest
private class ta_Opportunity_StageInsertRulesTest {
	
	@IsTest
	private static void beforeInsert_test() {
		List<Opportunity> newList = new List<Opportunity>();
		for (Integer i=0; i<100; i++ ) {
			newList.add(
				new Opportunity(
					Name = String.valueOf(i),
					StageName = Constants.OPPORTUNITY_STAGENAME_QUALIFICATION,
					CloseDate = Date.today()
					)
				);
		}
		Test.startTest();
		new ta_Opportunity_StageInsertRules().beforeInsert(newList);
		Test.stopTest();
		//Use Apex Pages Messages to get errors from AddError without performing DML
		System.assertEquals(true, newList[0].hasErrors());
		System.assertEquals(1, newList[0].getErrors().size());
		System.assertEquals(true, newList[0].getErrors()[0].getMessage().contains(ta_Opportunity_StageInsertRules.INVALID_STAGE_INSERT_ERROR));
	}
}