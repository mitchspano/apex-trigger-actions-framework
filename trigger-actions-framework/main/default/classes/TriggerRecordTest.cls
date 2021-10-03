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

@IsTest
private class TriggerRecordTest {
	static Account myAccount = new Account(
		Name = 'My Account',
		Id = TestUtility.getFakeId(Schema.Account.SObjectType)
	);

	@IsTest
	static void triggerRecordsShouldBeUpdatedSuccessfully() {
		TriggerRecord testTriggerRecord = new TriggerRecord(
			myAccount,
			myAccount,
			0
		);
		System.assertEquals(
			true,
			TriggerRecord.newRecordIndexToNewRecord.containsKey(0),
			'The index of the newRecord should be stored in the newRecordIndexToNewRecord map'
		);

		testTriggerRecord.newSobject.Id = null;

		System.assertEquals(
			null,
			TriggerRecord.newRecordIndexToNewRecord.get(0).Id,
			'Modifications to the newRecord should persist through the recordHashToNewRecord map'
		);
	}

	@IsTest
	static void triggerRecordsShouldThrowExceptionIfTheNewValueIsSetWithoutAnIndex() {
		Exception myException;
		try {
			TriggerRecord testTriggerRecord = new TriggerRecord(
				myAccount,
				myAccount,
				null
			);
		} catch (Exception e) {
			myException = e;
		}
		System.assertNotEquals(
			null,
			myException,
			'Setting the value of the new sObject should fail without the index within the newList'
		);
	}
}
