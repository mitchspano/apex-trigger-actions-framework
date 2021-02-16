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
	@IsTest
	private static void constructor_success() {
		Exception myException;
		test.startTest();
		try {
			BaseTest base = new BaseTest();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeInsert_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.BEFORE_INSERT;
		base.triggerNew = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void afterInsert_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.AFTER_INSERT;
		base.triggerNew = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeUpdate_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.BEFORE_UPDATE;
		base.triggerNew = new List<SObject>{ new Account(name = 'My Account') };
		base.triggerOld = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUpdate_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.After_UPDATE;
		base.triggerNew = new List<SObject>{ new Account(name = 'My Account') };
		base.triggerOld = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeDelete_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.BEFORE_DELETE;
		base.triggerOld = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void afterDelete_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.AFTER_DELETE;
		base.triggerOld = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUndelete_success() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		base.context = System.TriggerOperation.AFTER_UNDELETE;
		base.triggerNew = new List<SObject>{ new Account(name = 'My Account') };
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
	}

	@IsTest
	private static void run_fail() {
		Exception myException;
		test.startTest();
		BaseTest base = new BaseTest();
		try {
			base.run();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertNotEquals(null, myException);
		System.assert(
			myException.getMessage()
				.contains(TriggerBase.HANDLER_OUTSIDE_TRIGGER_MESSAGE)
		);
	}

	@IsTest
	private static void bypass_success() {
		Exception myException;
		test.startTest();
		try {
			TriggerBase.bypass('Account');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert(TriggerBase.bypassedObjects.contains('Account'));
	}

	@IsTest
	private static void clearBypass_success() {
		Exception myException;
		test.startTest();
		try {
			TriggerBase.bypass('Account');
			TriggerBase.clearBypass('Account');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert(!TriggerBase.bypassedObjects.contains('Account'));
	}

	@IsTest
	private static void isBypassed_success() {
		Boolean isBypassed;
		TriggerBase.bypass('Account');
		Exception myException;
		test.startTest();
		try {
			isBypassed = TriggerBase.isBypassed('Account');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assertEquals(true, isBypassed);
	}

	@IsTest
	private static void clearAllBypasses_success() {
		TriggerBase.bypass('Account');
		Exception myException;
		test.startTest();
		try {
			TriggerBase.clearAllBypasses();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assertEquals(0, TriggerBase.bypassedObjects.size());
	}

	class BaseTest extends TriggerBase implements TriggerAction.BeforeInsert, TriggerAction.AfterInsert, TriggerAction.BeforeUpdate, TriggerAction.AfterUpdate, TriggerAction.BeforeDelete, TriggerAction.AfterDelete, TriggerAction.AfterUndelete {
		public void beforeInsert(List<SObject> newList) {
		}
		public void afterInsert(List<SObject> newList) {
		}
		public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		}
		public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		}
		public void beforeDelete(List<SObject> oldList) {
		}
		public void afterDelete(List<SObject> newList) {
		}
		public void afterUndelete(List<SObject> newList) {
		}
	}
}
