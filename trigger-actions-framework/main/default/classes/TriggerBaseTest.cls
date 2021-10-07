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

@IsTest(isParallel=true)
private class TriggerBaseTest {
	private static final String ACCOUNT = 'Account';
	private static final Account MY_ACCOUNT = new Account(
		Id = TestUtility.getFakeId(Schema.Account.SObjectType),
		Name = 'My Account'
	);
	private static BaseTest base = new BaseTest();
	private static Exception myException;

	@IsTest
	private static void beforeInsertShouldSucceed() {
		MY_ACCOUNT.Id = null;
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void afterInsertShouldSucceed() {
		base.context = System.TriggerOperation.AFTER_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void beforeUpdateShouldSucceed() {
		base.context = System.TriggerOperation.BEFORE_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void afterUpdateShouldSucceed() {
		base.context = System.TriggerOperation.After_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void beforeDeleteShouldSucceed() {
		base.context = System.TriggerOperation.BEFORE_DELETE;
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void afterDeleteShouldSucceed() {
		base.context = System.TriggerOperation.AFTER_DELETE;
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void afterUndeleteShouldSucceed() {
		base.context = System.TriggerOperation.AFTER_UNDELETE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void idToNumberOfTimesSeenBeforeUpdate() {
		base.context = System.TriggerOperation.BEFORE_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			2,
			TriggerBase.idToNumberOfTimesSeenBeforeUpdate.get(MY_ACCOUNT.Id),
			'The number of time seen should be populated properly'
		);
		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void idToNumberOfTimesSeenAfterUpdate() {
		base.context = System.TriggerOperation.AFTER_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			2,
			TriggerBase.idToNumberOfTimesSeenAfterUpdate.get(MY_ACCOUNT.Id),
			'The number of time seen should be populated properly'
		);
		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
	}

	@IsTest
	private static void runShouldFailWhenCalledOutsidetrigger() {
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertNotEquals(null, myException, 'An exception should be thrown');
		System.assert(
			myException.getMessage()
				.contains(TriggerBase.HANDLER_OUTSIDE_TRIGGER_MESSAGE),
			'The exception should be the one we are looking for'
		);
	}

	@IsTest
	private static void runShouldSucceed() {
		MY_ACCOUNT.Id = null;
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assertEquals(
			true,
			base.hasBeenExecuted,
			'The base should have executed'
		);
	}

	@IsTest
	private static void runShouldDoNothingWhenBypassed() {
		MY_ACCOUNT.Id = null;
		TriggerBase.bypass(ACCOUNT);
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };

		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assertEquals(
			false,
			base.hasBeenExecuted,
			'The base should not have executed'
		);
	}

	@IsTest
	private static void bypassShouldSucceed() {
		try {
			TriggerBase.bypass(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assert(
			TriggerBase.bypassedObjects.contains(ACCOUNT),
			'The bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void clearBypassShouldSucceed() {
		try {
			TriggerBase.bypass(ACCOUNT);
			TriggerBase.clearBypass(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assert(
			!TriggerBase.bypassedObjects.contains(ACCOUNT),
			'The bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void isBypassedShouldSucceed() {
		Boolean isBypassed;
		TriggerBase.bypass(ACCOUNT);

		try {
			isBypassed = TriggerBase.isBypassed(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assertEquals(
			true,
			isBypassed,
			'The bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void clearAllBypassesShouldSucceed() {
		TriggerBase.bypass(ACCOUNT);

		try {
			TriggerBase.clearAllBypasses();
		} catch (Exception e) {
			myException = e;
		}

		System.assertEquals(
			null,
			myException,
			'We should not encounter an exception'
		);
		System.assertEquals(
			0,
			TriggerBase.bypassedObjects.size(),
			'The bypasses should be configured correctly'
		);
	}

	class BaseTest extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
		public Boolean hasBeenExecuted = false;
		public void beforeInsert(List<SObject> newList) {
			this.hasBeenExecuted = true;
		}
		public void afterInsert(List<SObject> newList) {
			this.hasBeenExecuted = true;
		}
		public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
			this.hasBeenExecuted = true;
		}
		public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
			this.hasBeenExecuted = true;
		}
		public void beforeDelete(List<SObject> oldList) {
			this.hasBeenExecuted = true;
		}
		public void afterDelete(List<SObject> newList) {
			this.hasBeenExecuted = true;
		}
		public void afterUndelete(List<SObject> newList) {
			this.hasBeenExecuted = true;
		}
	}
}
