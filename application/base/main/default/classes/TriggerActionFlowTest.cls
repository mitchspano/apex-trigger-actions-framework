@IsTest
private class TriggerActionFlowTest {
	private static final String MY_ACCOUNT = 'My Account';
	private static final String SAMPLE_FLOW_NAME = 'TriggerActionFlowTest';
	@IsTest
	private static void getOldRecord_Success() {
		List<sObject> result;
		Exception myException;
		String oldAccountName = 'Old Name';
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		Account oldAccount = new Account(Name = oldAccountName, Id = myAccount.Id);
		Test.startTest();
		try {
			TriggerActionFlow.OldRecordRequest oldRecordRequest = new TriggerActionFlow.OldRecordRequest();
			oldRecordRequest.currentRecord = myAccount;
			oldRecordRequest.oldList = new List<SObject>{ oldAccount };
			result = TriggerActionFlow.getOldRecord(
				new List<TriggerActionFlow.OldRecordRequest>{ oldRecordRequest }
			);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertEquals(
			null,
			myException,
			'There should not be an exception called when getOldRecord is called with valid input.'
		);
		System.assertEquals(
			1,
			result.size(),
			'There should only ever be one response from oldRecordRequest'
		);
		System.assertEquals(
			oldAccountName,
			((Account) result[0]).Name,
			'The result of the getOldRecord method should always contain the previous values on the record'
		);
	}

	@IsTest
	private static void getOldRecord_Failure_InvalidRequest_Empty() {
		List<sObject> result;
		Exception myException;
		Test.startTest();
		try {
			TriggerActionFlow.OldRecordRequest oldRecordRequest = new TriggerActionFlow.OldRecordRequest();
			result = TriggerActionFlow.getOldRecord(
				new List<TriggerActionFlow.OldRecordRequest>()
			);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'There should be an exception called when getOldRecord is called with an empty list of requests'
		);
		System.assertEquals(
			TriggerActionFlow.INVALID_REQUEST,
			myException.getMessage(),
			'The exception thrown in this scenario should be for an invalid request'
		);
	}

	@IsTest
	private static void getOldRecord_Failure_InvalidRequest_TooMany() {
		List<sObject> result;
		Exception myException;
		String oldAccountName = 'Old Name';
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		Account oldAccount = new Account(Name = oldAccountName, Id = myAccount.Id);
		Test.startTest();
		try {
			TriggerActionFlow.OldRecordRequest oldRecordRequest = new TriggerActionFlow.OldRecordRequest();
			oldRecordRequest.currentRecord = myAccount;
			oldRecordRequest.oldList = new List<SObject>{ myAccount };
			result = TriggerActionFlow.getOldRecord(
				new List<TriggerActionFlow.OldRecordRequest>{
					oldRecordRequest,
					oldRecordRequest
				}
			);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'There should be an exception called when getOldRecord is called with a list of multiple requests'
		);
		System.assertEquals(
			TriggerActionFlow.INVALID_REQUEST,
			myException.getMessage(),
			'The exception thrown in this scenario should be for an invalid request'
		);
	}

	@IsTest
	private static void beforeInsert_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.beforeInsert(new List<sObject>{ myAccount });
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
	private static void afterInsert_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.afterInsert(new List<sObject>{ myAccount });
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
	private static void beforeUpdate_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.beforeUpdate(
				new List<sObject>{ myAccount },
				new List<sObject>{ myAccount }
			);
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
	private static void afterUpdate_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.afterUpdate(
				new List<sObject>{ myAccount },
				new List<sObject>{ myAccount }
			);
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
	private static void beforeDelete_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.beforeDelete(new List<sObject>{ myAccount });
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
	private static void afterDelete_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.afterDelete(new List<sObject>{ myAccount });
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
	private static void afterUndelete_Success() {
		Exception myException;
		Test.startTest();
		Account myAccount = new Account(
			Name = MY_ACCOUNT,
			Id = TestUtility.getFakeId(Schema.Account.SObjectType)
		);
		TriggerActionFlow triggerActionFlow = new TriggerActionFlow();
		triggerActionFlow.flowName = SAMPLE_FLOW_NAME;
		try {
			triggerActionFlow.afterUndelete(new List<sObject>{ myAccount });
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
}
