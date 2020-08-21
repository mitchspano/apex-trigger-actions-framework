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
	
	@IsTest
	private static void sobject_triggerNew () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {new Account()};
		String response;
		Exception myException;
		test.startTest();
		try {
			response = handler.sObjectName;
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals('Account', response);
	}
	
	@IsTest
	private static void sobject_triggerOld () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {new Account()};
		String response;
		Exception myException;
		test.startTest();
		try {
			response = handler.sObjectName;
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals('Account', response);
	}
	
	@IsTest
	private static void triggerActionsForThisObject () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {new Account()};
		List<Trigger_Action__mdt> response;
		Exception myException;
		test.startTest();
		try {
			response = handler.triggerActionsForThisObject;
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertNotEquals(null, response);
	}
	
	@IsTest
	private static void set_triggerActionsForThisObject () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {new Account()};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt beforeInsert = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt afterInsert = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterInsert',
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt beforeUpdate = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeUpdate',
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt afterUpdate = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterUpdate',
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt beforeDelete = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeDelete',
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt afterDelete = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterDelete',
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		Trigger_Action__mdt afterUndelete = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterUndelete',
			After_Undelete__r = setting,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			beforeInsert, afterInsert, beforeUpdate, afterUpdate, beforeDelete, afterDelete, afterUndelete
		};
		Exception myException;
		test.startTest();
		try {
			response = handler.triggerActionsForThisObject;
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertNotEquals(null, response);
		System.assertEquals(7, response.size());
	}
	
	@IsTest
	private static void beforeInsert_success () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType))};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
	private static void beforeInsert_fail () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = 'Account';
		handler.triggerNew = new List<Account> {new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType))};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterInsert',
			Before_Insert__r = setting,
			Before_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.AfterInsert', String.valueOf(System.TriggerOperation.BEFORE_INSERT)})));
	}
	
	@IsTest
	private static void afterInsert_success () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType))};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterInsert',
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
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
	private static void afterInsert_fail () {
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.sObjectName = 'Account';
		handler.triggerNew = new List<Account> {new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType))};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.AFTER_INSERT)})));
	}
	
	@IsTest
	private static void beforeUpdate_success () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {myAccount};
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeUpdate',
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
	private static void beforeUpdate_fail () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {myAccount};
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			Before_Update__r = setting,
			Before_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.BEFORE_UPDATE)})));
	}
	
	@IsTest
	private static void afterUpdate_success () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {myAccount};
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterUpdate',
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
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
	private static void afterUpdate_fail () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerNew = new List<Account> {myAccount};
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.AFTER_UPDATE)})));
	}
	
	@IsTest
	private static void beforeDelete_success () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeDelete',
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
	private static void beforeDelete_fail () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			Before_Delete__r = setting,
			Before_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.BEFORE_DELETE)})));
	}
	
	@IsTest
	private static void afterDelete_success () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterDelete',
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
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
	private static void afterDelete_fail () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
			action
		};
		Exception myException;
		test.startTest();
		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		System.assertEquals(null, myException);
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.AFTER_DELETE)})));
	}
	
	@IsTest
	private static void afterUndelete_success () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.AfterUndelete',
			After_Undelete__r = setting,
			After_Undelete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
	private static void afterUndelete_fail () {
		Account myAccount = new Account(Name = 'My Account', Id = TestUtility.getFakeId(Account.SObjectType));
		MetadataTriggerHandler handler = new MetadataTriggerHandler();
		handler.triggerOld = new List<Account> {myAccount};
		List<Trigger_Action__mdt> response;
		sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
			SObject__c = 'Account',
			Id = TestUtility.getFakeId(sObject_Trigger_Setting__mdt.SObjectType)
		);
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = 'MetadataTriggerHandlerTest.BeforeInsert',
			After_Undelete__r = setting,
			After_Undelete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.triggerActionsForThisObject = new List<Trigger_Action__mdt> {
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
		System.assertEquals(true, ApexPages.hasMessages());
		System.assertEquals(1, ApexPages.getMessages().size());
		System.assertEquals(true, ApexPages.getMessages()[0].getDetail().contains(String.format(MetadataTriggerHandler.INVALID_TYPE_ERROR, new String[] {'MetadataTriggerHandlerTest.BeforeInsert', String.valueOf(System.TriggerOperation.AFTER_UNDELETE)})));
	}

	
	@IsTest
	private static void bypass_success () {
		Exception myException;
		test.startTest();
		try {
			MetadataTriggerHandler.bypass('MetadataTriggerHandlerTest.BeforeInsert');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert (MetadataTriggerHandler.bypassedActions.contains('MetadataTriggerHandlerTest.BeforeInsert'));
	}
	
	@IsTest
	private static void clearBypass_success () {
		Exception myException;
		test.startTest();
		try {
			MetadataTriggerHandler.bypass('MetadataTriggerHandlerTest.BeforeInsert');
			MetadataTriggerHandler.clearBypass('MetadataTriggerHandlerTest.BeforeInsert');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assert (!MetadataTriggerHandler.bypassedActions.contains('MetadataTriggerHandlerTest.BeforeInsert'));
	}
	
	@IsTest
	private static void isBypassed_success () {
		Boolean isBypassed;
		MetadataTriggerHandler.bypass('MetadataTriggerHandlerTest.BeforeInsert');
		Exception myException;
		test.startTest();
		try {
			isBypassed = MetadataTriggerHandler.isBypassed('MetadataTriggerHandlerTest.BeforeInsert');
		} catch (Exception e) {
			myException = e;
		}
		test.stopTest();
		system.assertEquals(null, myException);
		System.assertEquals(true, isBypassed);
	}
	
	@IsTest
	private static void clearAllBypasses_success () {
		MetadataTriggerHandler.bypass('MetadataTriggerHandlerTest.BeforeInsert');
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