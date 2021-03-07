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
private class TriggerActionFlowClearBypassTest {
	private static final String MY_STRING = 'MY_STRING';

	@IsTest
	private static void object() {
		TriggerBase.bypass(MY_STRING);
		test.startTest();
		List<TriggerActionFlowClearBypass.Request> requests = new List<TriggerActionFlowClearBypass.Request>();
		TriggerActionFlowClearBypass.Request request = new TriggerActionFlowClearBypass.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.OBJECT_STRING;
		requests.add(request);
		TriggerActionFlowClearBypass.clearBypass(requests);
		Test.stopTest();
		System.assertEquals(
			false,
			TriggerBase.isBypassed(MY_STRING),
			'The Object should not be bypassed'
		);
	}

	@IsTest
	private static void apex() {
		MetadataTriggerHandler.bypass(MY_STRING);
		test.startTest();
		List<TriggerActionFlowClearBypass.Request> requests = new List<TriggerActionFlowClearBypass.Request>();
		TriggerActionFlowClearBypass.Request request = new TriggerActionFlowClearBypass.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.APEX_STRING;
		requests.add(request);
		TriggerActionFlowClearBypass.clearBypass(requests);
		Test.stopTest();
		System.assertEquals(
			false,
			MetadataTriggerHandler.isBypassed(MY_STRING),
			'The Apex should be not bypassed'
		);
	}

	@IsTest
	private static void flow() {
		TriggerActionFlow.bypass(MY_STRING);
		test.startTest();
		List<TriggerActionFlowClearBypass.Request> requests = new List<TriggerActionFlowClearBypass.Request>();
		TriggerActionFlowClearBypass.Request request = new TriggerActionFlowClearBypass.Request();
		request.Name = MY_STRING;
		request.bypassType = TriggerActionFlow.FLOW_STRING;
		requests.add(request);
		TriggerActionFlowClearBypass.clearBypass(requests);
		Test.stopTest();
		System.assertEquals(
			false,
			TriggerActionFlow.isBypassed(MY_STRING),
			'The Flow should not be bypassed'
		);
	}

	@IsTest
	private static void invalidRequest() {
		Exception myException;
		test.startTest();
		try {
			TriggerActionFlowClearBypass.clearBypass(
				new List<TriggerActionFlowClearBypass.Request>()
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
			myException instanceof TriggerActionFlowClearBypass.TriggerActionFlowClearBypassObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlowClearBypass.INVALID_REQUEST,
			'The exeption should contain the message we are looking for'
		);
	}

	@IsTest
	private static void invalidBypassType() {
		Exception myException;
		test.startTest();
		List<TriggerActionFlowClearBypass.Request> requests = new List<TriggerActionFlowClearBypass.Request>();
		TriggerActionFlowClearBypass.Request request = new TriggerActionFlowClearBypass.Request();
		request.Name = MY_STRING;
		request.bypassType = MY_STRING;
		requests.add(request);
		try {
			TriggerActionFlowClearBypass.clearBypass(requests);
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
			myException instanceof TriggerActionFlowClearBypass.TriggerActionFlowClearBypassObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlow.INVALID_TYPE,
			'The exeption should contain the message we are looking for'
		);
	}
}
