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

@IsTest
private class TriggerActionFlowTest {
	static final String MY_ACCOUNT = 'My Account';
	static final String OLD_NAME = 'Old Name';
	static final String BOGUS = 'Bogus';
	static final String SAMPLE_FLOW_NAME = 'TriggerActionFlowTest';
	static final String INPUT_GENERATOR_CLASS_NAME = 'TriggerActionFlowTest.AccountTriggerRecord';
	static final String INPUT_GENERATOR_CLASS_NAME_WRONG_VARIABLE = 'TriggerActionFlowTest.BadInputWrongVariable';
	static final String INPUT_GENERATOR_CLASS_NAME_WRONG_TYPE = 'TriggerActionFlowTest.BadInputWrongReturnType';
	static Account myAccount = new Account(
		Name = MY_ACCOUNT,
		Id = TestUtility.getFakeId(Schema.Account.SObjectType)
	);
	static Account oldAccount = new Account(Name = OLD_NAME, Id = myAccount.Id);
	static List<SObject> newList = new List<SObject>{ myAccount };
	static List<SObject> oldList = new List<SObject>{ oldAccount };
	static TriggerActionFlow actionFlow;

	static {
		actionFlow = new TriggerActionFlow();
		actionFlow.flowName = SAMPLE_FLOW_NAME;
		actionFlow.inputGeneratorClassName = INPUT_GENERATOR_CLASS_NAME;
		actionFlow.allowRecursion = true;
	}

	@IsTest
	static void beforeInsertShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.beforeInsert(newList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void afterInsertShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.afterInsert(newList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void beforeUpdateShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.beforeUpdate(newList, oldList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void afterUpdateShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.afterUpdate(newList, oldList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void beforeDeleteShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.beforeDelete(newList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void afterDeleteShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.afterDelete(newList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void afterUndeleteShouldSucceed() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.afterUndelete(oldList);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	static void beforeInputShouldFailWithNullInputGenerator() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.inputGeneratorClassName = null;
			actionFlow.beforeInsert(newList);
		} catch (TriggerActionFlow.TriggerActionFlowException e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'An exception should be thrown when there is no specified input generator class name.'
		);
	}

	@IsTest
	static void beforeInputShouldFailWithInvalidInputGenerator() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.inputGeneratorClassName = BOGUS;
			actionFlow.beforeInsert(newList);
		} catch (TriggerActionFlow.TriggerActionFlowException e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'An exception should be thrown when there is no valid input generator class name.'
		);
	}

	@IsTest
	static void beforeInputShouldFailWithInvalidInputMissingKey() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.inputGeneratorClassName = INPUT_GENERATOR_CLASS_NAME_WRONG_VARIABLE;
			actionFlow.beforeInsert(newList);
		} catch (TriggerActionFlow.TriggerActionFlowException e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'An exception should be thrown when the input generated does not contain the key "triggerRecords"'
		);
	}

	@IsTest
	static void beforeInputShouldFailWithInvalidInputWrongDataType() {
		Exception myException;
		Test.startTest();
		try {
			actionFlow.inputGeneratorClassName = INPUT_GENERATOR_CLASS_NAME_WRONG_TYPE;
			actionFlow.beforeInsert(newList);
		} catch (TriggerActionFlow.TriggerActionFlowException e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'An exception should be thrown when the input generated has the key "triggerRecords", but it is mapped to a value that is not a list of TriggerRecord'
		);
	}

	@IsTest
	private static void bypassShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		System.assert(
			TriggerActionFlow.bypassedFlows.contains(SAMPLE_FLOW_NAME),
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void clearBypassShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);
		TriggerActionFlow.clearBypass(SAMPLE_FLOW_NAME);

		System.assert(
			!TriggerActionFlow.bypassedFlows.contains(SAMPLE_FLOW_NAME),
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void isBypassedShouldSucceed() {
		Boolean isBypassed;
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		isBypassed = TriggerActionFlow.isBypassed(SAMPLE_FLOW_NAME);

		System.assertEquals(
			true,
			isBypassed,
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void clearAllBypassesShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		TriggerActionFlow.clearAllBypasses();

		System.assertEquals(
			0,
			TriggerActionFlow.bypassedFlows.size(),
			'Static bypasses should be populated properly'
		);
	}

	public class AccountTriggerRecord extends TriggerRecord implements TriggerActionFlow.GenerateTriggerFlowInput {
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
		public Map<String, Object> getFlowInput(
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

	private class BadInputWrongVariable implements TriggerActionFlow.GenerateTriggerFlowInput {
		public Map<String, Object> getFlowInput(
			List<SObject> newList,
			List<SObject> oldList
		) {
			return new Map<String, Object>{
				BOGUS => new List<AccountTriggerRecord>()
			};
		}
	}

	private class BadInputWrongReturnType implements TriggerActionFlow.GenerateTriggerFlowInput {
		public Map<String, Object> getFlowInput(
			List<SObject> newList,
			List<SObject> oldList
		) {
			return new Map<String, Object>{
				TriggerActionFlow.TRIGGER_RECORDS_VARIABLE => BOGUS
			};
		}
	}
}
