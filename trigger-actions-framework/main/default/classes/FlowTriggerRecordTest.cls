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

	@IsTest
	private static void triggerRecordsShouldBeUpdated() {
		FlowTriggerRecordTest.AccountTriggerRecord testTriggerRecord = new FlowTriggerRecordTest.AccountTriggerRecord(
			myAccount,
			myAccount,
			0
		);
		System.assertEquals(
			true,
			FlowTriggerRecord.newRecordIndexToNewRecord.containsKey(0),
			'The index of the newRecord should be stored in the newRecordIndexToNewRecord map'
		);

		testTriggerRecord.newRecord.Id = null;

		System.assertEquals(
			null,
			FlowTriggerRecord.newRecordIndexToNewRecord.get(0).Id,
			'Modifications to the newRecord should persist through the newRecordIndexToNewRecord map'
		);
	}

	@IsTest
	private static void triggerRecordsShouldThrowExceptionIfTheNewValueIsSetWithoutAnIndex() {
		Exception myException;
		try {
			FlowTriggerRecordTest.AccountTriggerRecord testTriggerRecord = new FlowTriggerRecordTest.AccountTriggerRecord(
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

	public class AccountTriggerRecord extends FlowTriggerRecord {
		public AccountTriggerRecord() {
			super();
		}

		public AccountTriggerRecord(
			Account newRecord,
			Account oldRecord,
			Integer newRecordIndex
		) {
			super(newRecord, oldRecord, newRecordIndex);
		}

		@AuraEnabled
		public Account newRecord {
			get {
				return (Account) this.newSObject;
			}
			set {
				this.newSObject = value;
			}
		}

		@AuraEnabled
		public Account oldRecord {
			get {
				return (Account) this.oldSObject;
			}
		}

		public override Map<String, Object> getFlowInput(
			List<SObject> newList,
			List<SObject> oldList
		) {
			List<SObject> collection = newList != null ? newList : oldList;
			List<AccountTriggerRecord> triggerRecords = new List<AccountTriggerRecord>();
			for (Integer i = 0; i < collection.size(); i++) {
				Account newRecord = newList != null ? (Account) newList.get(i) : null;
				Account oldRecord = oldList != null ? (Account) oldList.get(i) : null;
				triggerRecords.add(new AccountTriggerRecord(newRecord, oldRecord, i));
			}
			return new Map<String, Object>{
				TriggerActionFlow.TRIGGER_RECORDS_VARIABLE => triggerRecords
			};
		}
	}
}
