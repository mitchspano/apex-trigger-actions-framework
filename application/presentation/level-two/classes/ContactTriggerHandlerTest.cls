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

@isTest
private class ContactTriggerTest {
	
	@isTest
	private void beforeInsertTest() {
        List<Contact> myContacts = new List<Contact>();
        myContacts.add(new Contact());
		Test.startTest();
		ContactTriggerHandler.beforeInsert(myContacts);
		Test.stopTest();
        System.assertEquals('Bugs', myContacts[0].FirstName);
        System.assertEquals('Bunny', myContacts[0].LastName);
	}
}