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

@IsTest(isParallel=true)
private class FlowTriggerRecordTest {
	static Account myAccount = new Account(
		Name = 'My Account',
		Id = TestUtility.getFakeId(Schema.Account.SObjectType)
	);

	static Integer i = 0;

	@IsTest
	private static void triggerRecordsShouldBeUpdated() {
		TriggerActionFlowTest.AccountTriggerRecord testTriggerRecord = new TriggerActionFlowTest.AccountTriggerRecord(
			myAccount,
			myAccount,
			0,
			i
		);
		System.assertEquals(
			true,
			FlowTriggerRecord.triggerActionFlowIdAndIndexToNewRecord.containsKey(
				i +
				FlowTriggerRecord.PIPE +
				0
			),
			'The index of the newRecord should be stored in the triggerActionFlowIdAndIndexToNewRecord map'
		);

		testTriggerRecord.newRecord.Id = null;

		System.assertEquals(
			null,
			FlowTriggerRecord.triggerActionFlowIdAndIndexToNewRecord.get(
					i +
					FlowTriggerRecord.PIPE +
					0
				)
				.Id,
			'Modifications to the newRecord should persist through the triggerActionFlowIdAndIndexToNewRecord map'
		);
	}

	@IsTest
	private static void triggerRecordsShouldThrowExceptionIfTheNewValueIsSetWithoutAnIndex() {
		Exception myException;
		try {
			TriggerActionFlowTest.AccountTriggerRecord testTriggerRecord = new TriggerActionFlowTest.AccountTriggerRecord(
				myAccount,
				myAccount,
				null,
				i
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

	@IsTest
	private static void triggerRecordsShouldThrowExceptionIfTheNewValueIsSetWithoutATriggerActionFlowIdentifier() {
		Exception myException;
		try {
			TriggerActionFlowTest.AccountTriggerRecord testTriggerRecord = new TriggerActionFlowTest.AccountTriggerRecord(
				myAccount,
				myAccount,
				0,
				null
			);
		} catch (Exception e) {
			myException = e;
		}

		System.assertNotEquals(
			null,
			myException,
			'Setting the value of the new sObject should fail without the identifer of the trigger action flow'
		);
	}
}
