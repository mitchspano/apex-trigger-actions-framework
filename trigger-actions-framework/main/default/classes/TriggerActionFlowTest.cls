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
public class TriggerActionFlowTest {
	private static final String MY_ACCOUNT = 'My Account';
	private static final String OLD_NAME = 'Old Name';
	private static final String BOGUS = 'Bogus';
	private static final String SAMPLE_FLOW_NAME = 'TriggerActionFlowTest';
	private static Account myAccount = new Account(
		Name = MY_ACCOUNT,
		Id = TriggerTestUtility.getFakeId(Schema.Account.SObjectType)
	);
	private static Account oldAccount = new Account(
		Name = OLD_NAME,
		Id = myAccount.Id
	);
	private static List<SObject> newList = new List<SObject>{ myAccount };
	private static List<SObject> oldList = new List<SObject>{ oldAccount };
	private static TriggerActionFlow actionFlow;
	private static Exception myException;

	static {
		actionFlow = new TriggerActionFlow();
		actionFlow.flowName = SAMPLE_FLOW_NAME;
		actionFlow.allowRecursion = true;
	}

	@IsTest
	private static void beforeInsertShouldSucceed() {
		try {
			actionFlow.beforeInsert(newList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void afterInsertShouldSucceed() {
		try {
			actionFlow.afterInsert(newList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void beforeUpdateShouldSucceed() {
		try {
			actionFlow.beforeUpdate(newList, oldList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void afterUpdateShouldSucceed() {
		try {
			actionFlow.afterUpdate(newList, oldList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void beforeDeleteShouldSucceed() {
		try {
			actionFlow.beforeDelete(newList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void afterDeleteShouldSucceed() {
		try {
			actionFlow.afterDelete(newList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void afterUndeleteShouldSucceed() {
		try {
			actionFlow.afterUndelete(oldList);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areEqual(
			null,
			myException,
			'There should be no exception thrown when this method is called with a valid flow.'
		);
	}

	@IsTest
	private static void bypassShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		System.Assert.isTrue(
			TriggerActionFlow.bypassedFlows.contains(SAMPLE_FLOW_NAME),
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void clearBypassShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);
		TriggerActionFlow.clearBypass(SAMPLE_FLOW_NAME);

		System.Assert.isFalse(
			TriggerActionFlow.bypassedFlows.contains(SAMPLE_FLOW_NAME),
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void isBypassedShouldSucceed() {
		Boolean isBypassed;
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		isBypassed = TriggerActionFlow.isBypassed(SAMPLE_FLOW_NAME);

		System.Assert.isTrue(
			isBypassed,
			'Static bypasses should be populated properly'
		);
	}

	@IsTest
	private static void clearAllBypassesShouldSucceed() {
		TriggerActionFlow.bypass(SAMPLE_FLOW_NAME);

		TriggerActionFlow.clearAllBypasses();

		System.Assert.areEqual(
			0,
			TriggerActionFlow.bypassedFlows.size(),
			'Static bypasses should be populated properly'
		);
	}
}
