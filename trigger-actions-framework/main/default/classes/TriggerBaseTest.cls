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
private class TriggerBaseTest {
	private static final String ACCOUNT = 'Account';
	private static final Account MY_ACCOUNT = new Account(
		Id = TestUtility.getFakeId(Schema.Account.SObjectType),
		Name = 'My Account'
	);
	private static BaseTest base = new BaseTest();

	@IsTest
	private static void beforeInsert_success() {
		MY_ACCOUNT.Id = null;
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterInsert_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.AFTER_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeUpdate_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.BEFORE_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUpdate_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.After_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeDelete_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.BEFORE_DELETE;
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterDelete_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.AFTER_DELETE;
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUndelete_success() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.AFTER_UNDELETE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void idToNumberOfTimesSeenBeforeUpdate() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.BEFORE_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			2,
			TriggerBase.idToNumberOfTimesSeenBeforeUpdate.get(MY_ACCOUNT.Id)
		);
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void idToNumberOfTimesSeenAfterUpdate() {
		Exception myException;
		Test.startTest();
		base.context = System.TriggerOperation.AFTER_UPDATE;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		base.triggerOld = new List<SObject>{ MY_ACCOUNT };
		try {
			base.run();
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			2,
			TriggerBase.idToNumberOfTimesSeenAfterUpdate.get(MY_ACCOUNT.Id)
		);
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void run_fail() {
		Exception myException;
		Test.startTest();
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(null, myException);
		System.assert(
			myException.getMessage()
				.contains(TriggerBase.HANDLER_OUTSIDE_TRIGGER_MESSAGE)
		);
	}

	@IsTest
	private static void run_true() {
		MY_ACCOUNT.Id = null;
		Exception myException;
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		Test.startTest();
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(true, base.hasBeenExecuted);
	}

	@IsTest
	private static void run_false() {
		MY_ACCOUNT.Id = null;
		TriggerBase.bypass(ACCOUNT);
		Exception myException;
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ MY_ACCOUNT };
		Test.startTest();
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(false, base.hasBeenExecuted);
	}

	@IsTest
	private static void bypass_success() {
		Exception myException;
		Test.startTest();
		try {
			TriggerBase.bypass(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assert(TriggerBase.bypassedObjects.contains(ACCOUNT));
	}

	@IsTest
	private static void clearBypass_success() {
		Exception myException;
		Test.startTest();
		try {
			TriggerBase.bypass(ACCOUNT);
			TriggerBase.clearBypass(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assert(!TriggerBase.bypassedObjects.contains(ACCOUNT));
	}

	@IsTest
	private static void isBypassed_success() {
		Boolean isBypassed;
		TriggerBase.bypass(ACCOUNT);
		Exception myException;
		Test.startTest();
		try {
			isBypassed = TriggerBase.isBypassed(ACCOUNT);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(true, isBypassed);
	}

	@IsTest
	private static void clearAllBypasses_success() {
		TriggerBase.bypass(ACCOUNT);
		Exception myException;
		Test.startTest();
		try {
			TriggerBase.clearAllBypasses();
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(0, TriggerBase.bypassedObjects.size());
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
