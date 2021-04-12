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
private class TriggerActionFlowClearAllBypassesTest {
	private static final String MY_STRING = 'MY_STRING';

	@IsTest
	private static void object() {
		TriggerBase.bypass(MY_STRING);
		Test.startTest();
		TriggerActionFlowClearAllBypasses.clearAllBypasses(
			new List<String>{ TriggerActionFlow.OBJECT_STRING }
		);
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
		Test.startTest();
		TriggerActionFlowClearAllBypasses.clearAllBypasses(
			new List<String>{ TriggerActionFlow.APEX_STRING }
		);
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
		Test.startTest();
		TriggerActionFlowClearAllBypasses.clearAllBypasses(
			new List<String>{ TriggerActionFlow.FLOW_STRING }
		);
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
		Test.startTest();
		try {
			TriggerActionFlowClearAllBypasses.clearAllBypasses(new List<String>());
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
			myException instanceof TriggerActionFlowClearAllBypasses.TriggerActionFlowClearAllBypassesObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlowClearAllBypasses.INVALID_REQUEST,
			'The exeption should contain the message we are looking for'
		);
	}

	@IsTest
	private static void invalidBypassType() {
		Exception myException;
		Test.startTest();
		try {
			TriggerActionFlowClearAllBypasses.clearAllBypasses(
				new List<String>{ MY_STRING }
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
			myException instanceof TriggerActionFlowClearAllBypasses.TriggerActionFlowClearAllBypassesObjectException,
			'The exception should be of the correct type'
		);
		System.assertEquals(
			myException.getMessage(),
			TriggerActionFlow.INVALID_TYPE,
			'The exeption should contain the message we are looking for'
		);
	}
}
