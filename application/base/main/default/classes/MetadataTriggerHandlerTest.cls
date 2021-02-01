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
private class MetadataTriggerHandlerTest {
	private static final String MY_ACCOUNT = 'My Account';
	private static final String ACCOUNT = 'Account';
	private static final String TEST_BEFORE_INSERT = 'MetadataTriggerHandlerTest.BeforeInsert';
	private static final String TEST_AFTER_INSERT = 'MetadataTriggerHandlerTest.AfterInsert';
	private static final String TEST_BEFORE_UPDATE = 'MetadataTriggerHandlerTest.BeforeUpdate';
	private static final String TEST_AFTER_UPDATE = 'MetadataTriggerHandlerTest.AfterUpdate';
	private static final String TEST_BEFORE_DELETE = 'MetadataTriggerHandlerTest.BeforeDelete';
	private static final String TEST_AFTER_DELETE = 'MetadataTriggerHandlerTest.AfterDelete';
	private static final String TEST_AFTER_UNDELETE = 'MetadataTriggerHandlerTest.AfterUndelete';
	private static final String BOGUS_CLASS_NAME = 'Bogus';
	private static final String REQUIRED_PERMISSION = 'Bogus_Required_Permission';
	private static final String BYPASS_PERMISSION = 'Bogus_Bypass_Permission';

	@IsTest
	private static void beforeInsert_success() {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{
			new Account(
				Name = MY_ACCOUNT,
				Id = TestUtility.getFakeId(Schema.Account.SObjectType)
			)
		};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeInsertActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeInsert_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_INSERT,
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeInsertActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_AFTER_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_INSERT),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void beforeInsert_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeInsertActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_INSERT),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterInsert_success() {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{
			new Account(
				Name = MY_ACCOUNT,
				Id = TestUtility.getFakeId(Schema.Account.SObjectType)
			)
		};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_INSERT,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterInsert_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_INSERT),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterInsert_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_INSERT),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void beforeUpdate_success() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_UPDATE,
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeUpdateActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeUpdate_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeUpdateActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_UPDATE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterUpdate_success() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_UPDATE,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUpdate_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_UPDATE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterUpdate_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_UPDATE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void beforeDelete_success() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_DELETE,
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeDeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void beforeDelete_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeDeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_DELETE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void beforeUpdate_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeUpdateActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_UPDATE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void beforeDelete_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.beforeDeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.beforeDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_DELETE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterDelete_success() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_DELETE,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterDelete_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_DELETE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterDelete_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };
		Exception myException;
		test.startTest();
		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_DELETE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void afterUndelete_success() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_UNDELETE,
			After_Undelete__r = setting,
			After_Undelete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUndeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterUndelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
	}

	@IsTest
	private static void afterUndelete_fail_incorrect_type() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Undelete__r = setting,
			After_Undelete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUndeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterUndelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_UNDELETE),
					ACCOUNT
				}
			)
		);
	}
	@IsTest
	private static void afterUndelete_fail_incorrect_class() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = ACCOUNT;
		handler.triggerOld = new List<Account>{ myAccount };
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = ACCOUNT,
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Undelete__r = setting,
			After_Undelete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUndeleteActionMetadata = new List<Trigger_Action__mdt>{
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterUndelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertNotEquals(null, myException);
		System.assertEquals(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_UNDELETE),
					ACCOUNT
				}
			)
		);
	}

	@IsTest
	private static void actionMetadata() {
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
		System.assertNotEquals(null, handler.actionMetadata);
		System.assertNotEquals(null, handler.beforeInsertActionMetadata);
		System.assertNotEquals(null, handler.afterInsertActionMetadata);
		System.assertNotEquals(null, handler.beforeUpdateActionMetadata);
		System.assertNotEquals(null, handler.afterUpdateActionMetadata);
		System.assertNotEquals(null, handler.beforeDeleteActionMetadata);
		System.assertNotEquals(null, handler.afterDeleteActionMetadata);
		System.assertNotEquals(null, handler.afterUndeleteActionMetadata);
	}

	@IsTest
	private static void shouldExecute_action_default() {
		System.assertEquals(
			true,
			new MetadataTriggerHandler().shouldExecute(new Trigger_Action__mdt())
		);
	}

	@IsTest
	private static void shouldExecute_action_required() {
		System.assertEquals(
			false,
			new MetadataTriggerHandler()
				.shouldExecute(
					new Trigger_Action__mdt(Required_Permission__c = REQUIRED_PERMISSION)
				)
		);
	}
	@IsTest
	private static void shouldExecute_action_bypass() {
		System.assertEquals(
			true,
			new MetadataTriggerHandler()
				.shouldExecute(
					new Trigger_Action__mdt(Bypass_Permission__c = BYPASS_PERMISSION)
				)
		);
	}

	@IsTest
	private static void shouldExecute_setting_default() {
		System.assertEquals(
			true,
			new MetadataTriggerHandler()
				.shouldExecute(new sObject_Trigger_Setting__mdt())
		);
	}

	@IsTest
	private static void shouldExecute_setting_required() {
		System.assertEquals(
			false,
			new MetadataTriggerHandler()
				.shouldExecute(
					new sObject_Trigger_Setting__mdt(
						Required_Permission__c = REQUIRED_PERMISSION
					)
				)
		);
	}
	@IsTest
	private static void shouldExecute_setting_bypass() {
		System.assertEquals(
			true,
			new MetadataTriggerHandler()
				.shouldExecute(
					new sObject_Trigger_Setting__mdt(
						Bypass_Permission__c = BYPASS_PERMISSION
					)
				)
		);
	}

	@IsTest
	private static void bypass_success() {
		Exception myException;
		test.startTest();
		try {
			MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert(
			MetadataTriggerHandler.bypassedActions.contains(TEST_BEFORE_INSERT)
		);
	}

	@IsTest
	private static void clearBypass_success() {
		Exception myException;
		test.startTest();
		try {
			MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);
			MetadataTriggerHandler.clearBypass(TEST_BEFORE_INSERT);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert(
			!MetadataTriggerHandler.bypassedActions.contains(TEST_BEFORE_INSERT)
		);
	}

	@IsTest
	private static void isBypassed_success() {
		Boolean isBypassed;
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);
		Exception myException;
		test.startTest();
		try {
			isBypassed = MetadataTriggerHandler.isBypassed(TEST_BEFORE_INSERT);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assertEquals(true, isBypassed);
	}

	@IsTest
	private static void clearAllBypasses_success() {
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);
		Exception myException;
		test.startTest();
		try {
			MetadataTriggerHandler.clearAllBypasses();
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assertEquals(0, MetadataTriggerHandler.bypassedActions.size());
	}

	public class BeforeInsert implements TriggerAction.BeforeInsert {
		public void beforeInsert(List<SObject> newList) {
		}
	}
	public class AfterInsert implements TriggerAction.AfterInsert {
		public void afterInsert(List<SObject> newList) {
		}
	}
	public class BeforeUpdate implements TriggerAction.BeforeUpdate {
		public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
		}
	}
	public class AfterUpdate implements TriggerAction.AfterUpdate {
		public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
		}
	}
	public class BeforeDelete implements TriggerAction.BeforeDelete {
		public void beforeDelete(List<SObject> oldList) {
		}
	}
	public class AfterDelete implements TriggerAction.AfterDelete {
		public void afterDelete(List<SObject> newList) {
		}
	}
	public class AfterUndelete implements TriggerAction.AfterUndelete {
		public void afterUndelete(List<SObject> newList) {
		}
	}
}
