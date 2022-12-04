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
private class MetadataTriggerHandlerTest {
	private static final String MY_ACCOUNT = 'My Account';
	private static final String ACCOUNT = 'Account';
	private static final String TEST_BEFORE_INSERT = 'MetadataTriggerHandlerTest.TestBeforeInsert';
	private static final String TEST_AFTER_INSERT = 'MetadataTriggerHandlerTest.TestAfterInsert';
	private static final String TEST_BEFORE_UPDATE = 'MetadataTriggerHandlerTest.TestBeforeUpdate';
	private static final String TEST_AFTER_UPDATE = 'MetadataTriggerHandlerTest.TestAfterUpdate';
	private static final String TEST_BEFORE_DELETE = 'MetadataTriggerHandlerTest.TestBeforeDelete';
	private static final String TEST_AFTER_DELETE = 'MetadataTriggerHandlerTest.TestAfterDelete';
	private static final String TEST_AFTER_UNDELETE = 'MetadataTriggerHandlerTest.TestAfterUndelete';
	private static final String BOGUS_CLASS_NAME = 'Bogus';
	private static final String REQUIRED_PERMISSION = 'Bogus_Required_Permission';
	private static final String BYPASS_PERMISSION = 'Bogus_Bypass_Permission';

	private static Account myAccount = new Account(
		Name = MY_ACCOUNT,
		Id = TriggerTestUtility.getFakeId(Schema.Account.SObjectType)
	);
	private static sObject_Trigger_Setting__mdt setting = new sObject_Trigger_Setting__mdt(
		Object_API_Name__c = ACCOUNT,
		Id = TriggerTestUtility.getFakeId(
			Schema.sObject_Trigger_Setting__mdt.SObjectType
		)
	);
	private static MetadataTriggerHandler handler = new MetadataTriggerHandler();
	private static Boolean executed = false;
	private static Exception myException;

	static {
		handler.triggerNew = new List<Account>{ myAccount };
		handler.triggerOld = new List<Account>{ myAccount };
	}

	@IsTest
	private static void beforeInsertShouldSucceed() {
		executed = false;
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

		handler.beforeInsert(handler.triggerNew);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void beforeInsertShouldFailWithIncorrectType() {
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

		try {
			handler.beforeInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_AFTER_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_INSERT),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void beforeInsertShouldFailWithIncorrectClass() {
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

		try {
			handler.beforeInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_INSERT),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterInsertShouldSucceed() {
		executed = false;
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_INSERT,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };

		handler.afterInsert(handler.triggerNew);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void afterInsertShouldFailWithIncorrectType() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_INSERT),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterInsertShouldFailWithIncorrectClass() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Insert__r = setting,
			After_Insert__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterInsertActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterInsert(handler.triggerNew);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_INSERT),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void beforeUpdateShouldSucceed() {
		executed = false;
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

		handler.beforeUpdate(handler.triggerNew, handler.triggerOld);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void beforeUpdateShouldFailWithIncorrectType() {
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

		try {
			handler.beforeUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_UPDATE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void beforeUpdateShouldFailWithIncorrectClass() {
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

		try {
			handler.beforeUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_UPDATE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterUpdateShouldSucceed() {
		executed = false;
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_UPDATE,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };

		handler.afterUpdate(handler.triggerNew, handler.triggerOld);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void afterUpdateShouldFailWithIncorrectType() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_UPDATE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterUpdateShouldFailWithIncorrectClass() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Update__r = setting,
			After_Update__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterUpdateActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterUpdate(handler.triggerNew, handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_UPDATE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void beforeDeleteShouldSucceed() {
		executed = false;
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

		handler.beforeDelete(handler.triggerOld);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void beforeDeleteShouldFailWithIncorrectType() {
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

		try {
			handler.beforeDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.BEFORE_DELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void beforeDeleteShouldFailWithIncorrectClass() {
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

		try {
			handler.beforeDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.BEFORE_DELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterDeleteShouldSucceed() {
		executed = false;
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_AFTER_DELETE,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };

		handler.afterDelete(handler.triggerOld);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void afterDeleteShouldFailWithIncorrectType() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = TEST_BEFORE_INSERT,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_DELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterDeleteShouldFailWithIncorrectClass() {
		Trigger_Action__mdt action = new Trigger_Action__mdt(
			Apex_Class_Name__c = BOGUS_CLASS_NAME,
			After_Delete__r = setting,
			After_Delete__c = setting.Id,
			Order__c = 1,
			Bypass_Execution__c = false
		);
		handler.afterDeleteActionMetadata = new List<Trigger_Action__mdt>{ action };

		try {
			handler.afterDelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_DELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterUndeleteShouldSucceed() {
		executed = false;
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

		handler.afterUndelete(handler.triggerOld);

		System.Assert.isTrue(executed, 'We expect the action to be executed');
	}

	@IsTest
	private static void afterUndeleteShouldFailWithIncorrectType() {
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

		try {
			handler.afterUndelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_TYPE_ERROR,
				new List<String>{
					TEST_BEFORE_INSERT,
					String.valueOf(System.TriggerOperation.AFTER_UNDELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void afterUndeleteShouldFailWithIncorrectClass() {
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

		try {
			handler.afterUndelete(handler.triggerOld);
		} catch (Exception e) {
			myException = e;
		}

		System.Assert.areNotEqual(null, myException, 'An exception should be thrown');
		System.Assert.areEqual(
			myException.getMessage(),
			String.format(
				MetadataTriggerHandler.INVALID_CLASS_ERROR,
				new List<String>{
					BOGUS_CLASS_NAME,
					String.valueOf(System.TriggerOperation.AFTER_UNDELETE),
					ACCOUNT
				}
			),
			'The exception should be of the correct type'
		);
	}

	@IsTest
	private static void actionMetadataShouldConstruct() {
		System.Assert.areNotEqual(
			null,
			handler.beforeInsertActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.afterInsertActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.beforeUpdateActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.afterUpdateActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.beforeDeleteActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.afterDeleteActionMetadata,
			'The metadata should be populated properly'
		);
		System.Assert.areNotEqual(
			null,
			handler.afterUndeleteActionMetadata,
			'The metadata should be populated properly'
		);
	}

	@IsTest
	private static void bypassShouldSucceed() {
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);

		System.Assert.isTrue(
			MetadataTriggerHandler.bypassedActions.contains(TEST_BEFORE_INSERT),
			'All bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void clearBypassShouldSucceed() {
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);
		MetadataTriggerHandler.clearBypass(TEST_BEFORE_INSERT);

		System.Assert.isFalse(
			MetadataTriggerHandler.bypassedActions.contains(TEST_BEFORE_INSERT),
			'All bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void isBypassedShouldSucceed() {
		Boolean isBypassed;
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);

		isBypassed = MetadataTriggerHandler.isBypassed(TEST_BEFORE_INSERT);

		System.Assert.isTrue(
			isBypassed,
			'All bypasses should be configured correctly'
		);
	}

	@IsTest
	private static void clearAllBypassesShouldSucceed() {
		MetadataTriggerHandler.bypass(TEST_BEFORE_INSERT);

		MetadataTriggerHandler.clearAllBypasses();

		System.Assert.areEqual(
			0,
			MetadataTriggerHandler.bypassedActions.size(),
			'All bypasses should be configured correctly'
		);
	}

	public class TestBeforeInsert implements TriggerAction.BeforeInsert {
		public void beforeInsert(List<SObject> newList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestAfterInsert implements TriggerAction.AfterInsert {
		public void afterInsert(List<SObject> newList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestBeforeUpdate implements TriggerAction.BeforeUpdate {
		public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestAfterUpdate implements TriggerAction.AfterUpdate {
		public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestBeforeDelete implements TriggerAction.BeforeDelete {
		public void beforeDelete(List<SObject> oldList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestAfterDelete implements TriggerAction.AfterDelete {
		public void afterDelete(List<SObject> newList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
	public class TestAfterUndelete implements TriggerAction.AfterUndelete {
		public void afterUndelete(List<SObject> newList) {
			MetadataTriggerHandlerTest.executed = true;
		}
	}
}
