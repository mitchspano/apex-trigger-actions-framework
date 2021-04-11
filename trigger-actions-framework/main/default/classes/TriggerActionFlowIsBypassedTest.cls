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

@isTest
private class TriggerActionFlowIsBypassedTest {
	private static final String MY_STRING = 'MY_STRING';

	@IsTest
	private static void object() {
		Test.startTest();
		List<TriggerActionFlowIsBypassed.Request> requests = new List<TriggerActionFlowIsBypassed.Request>();
		TriggerActionFlowIsBypassed.Request request = new TriggerActionFlowIsBypassed.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.OBJECT_STRING;
		requests.add(request);
		List<Boolean> isBypassed = TriggerActionFlowIsBypassed.isBypassed(requests);
		Test.stopTest();
		System.assertEquals(
			1,
			isBypassed.size(),
			'We should only have one result for our request'
		);
		System.assertEquals(
			TriggerBase.isBypassed(MY_STRING),
			isBypassed[0],
			'The result should contain the same result as the TriggerBase'
		);
	}

	@IsTest
	private static void apex() {
		Exception myException;
		Test.startTest();
		List<TriggerActionFlowIsBypassed.Request> requests = new List<TriggerActionFlowIsBypassed.Request>();
		TriggerActionFlowIsBypassed.Request request = new TriggerActionFlowIsBypassed.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.APEX_STRING;
		requests.add(request);
		List<Boolean> isBypassed = TriggerActionFlowIsBypassed.isBypassed(requests);
		Test.stopTest();
		System.assertEquals(
			1,
			isBypassed.size(),
			'We should only have one result for our request'
		);
		System.assertEquals(
			MetadataTriggerHandler.isBypassed(MY_STRING),
			isBypassed[0],
			'The result should contain the same result as the MetadataTriggerHandler'
		);
	}

	@IsTest
	private static void flow() {
		Exception myException;
		Test.startTest();
		List<TriggerActionFlowIsBypassed.Request> requests = new List<TriggerActionFlowIsBypassed.Request>();
		TriggerActionFlowIsBypassed.Request request = new TriggerActionFlowIsBypassed.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.FLOW_STRING;
		requests.add(request);
		List<Boolean> isBypassed = TriggerActionFlowIsBypassed.isBypassed(requests);
		Test.stopTest();
		System.assertEquals(
			1,
			isBypassed.size(),
			'We should only have one result for our request'
		);
		System.assertEquals(
			TriggerActionFlow.isBypassed(MY_STRING),
			isBypassed[0],
			'The result should contain the same result as the TriggerActionFlow'
		);
	}

	@IsTest
	private static void invalidRequest() {
		Exception myException;
		Test.startTest();
		try {
			List<Boolean> isBypassed = TriggerActionFlowIsBypassed.isBypassed(
				new List<TriggerActionFlowIsBypassed.Request>()
			);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'We should have an exception thrown in this scenario'
		);
		System.assert(
			myException instanceof TriggerActionFlowIsBypassed.TriggerActionFlowIsBypassedObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlowIsBypassed.INVALID_REQUEST,
			'The exeption should contain the message we are looking for'
		);
	}

	@IsTest
	private static void invalidBypassType() {
		Exception myException;
		Test.startTest();
		List<TriggerActionFlowIsBypassed.Request> requests = new List<TriggerActionFlowIsBypassed.Request>();
		TriggerActionFlowIsBypassed.Request request = new TriggerActionFlowIsBypassed.Request();
		request.Name = MY_STRING;
		request.bypassType = MY_STRING;
		requests.add(request);
		try {
			List<Boolean> isBypassed = TriggerActionFlowIsBypassed.isBypassed(
				requests
			);
		} catch (Exception e) {
			myException = e;
		}
		Test.stopTest();
		System.assertNotEquals(
			null,
			myException,
			'We should have an exception thrown in this scenario'
		);
		System.assert(
			myException instanceof TriggerActionFlowIsBypassed.TriggerActionFlowIsBypassedObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlow.INVALID_TYPE,
			'The exeption should contain the message we are looking for'
		);
	}
}
