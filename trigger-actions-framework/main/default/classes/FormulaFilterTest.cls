/*
   Copyright 2024 Google LLC

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
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs, PMD.AvoidGlobalModifier')
@IsTest
global class FormulaFilterTest {
	private static List<Account> newList = new List<Account>{
		new Account(Name = 'Test Account 1'),
		new Account(Name = 'Test Account 2')
	};
	private static List<Account> oldList = new List<Account>{
		new Account(Name = 'Test Account 1'),
		new Account(Name = 'Test Account 2')
	};
	private static sObject_Trigger_Setting__mdt sobjectSetting = new sObject_Trigger_Setting__mdt(
		Formula_Evaluation_Class_Name__c = 'FormulaFilterTest.AccountTriggerRecord'
	);
	private static Trigger_Action__mdt configuration = new Trigger_Action__mdt(
        Before_Update__r = sobjectSetting
    );

	@IsTest
	private static void noFormulaShouldProcessAllRecords() {
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.assertEquals(
			2,
			result.filteredNewList.size(),
			'The size of filteredNewList should be 2'
		);
		System.assertEquals(
			2,
			result.filteredOldList.size(),
			'The size of filteredNewList should be 2'
		);
	}

	@IsTest
	private static void validFormulaShouldFilterContentsOfNewList() {
		configuration.Entry_Criteria__c = 'record.Name = "Test Account 1"';

		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.assertEquals(
			1,
			result.filteredNewList.size(),
			'There should be 1 record in filteredNewList'
		);
		System.Assert.areEqual(
			'Test Account 1',
			((Account) result.filteredNewList[0]).Name,
			'The first record newList should have a name of Test Account 1'
		);
		System.assertEquals(
			1,
			result.filteredOldList.size(),
			'There should be 1 record in filteredNewList'
		);
		System.Assert.areEqual(
			'Test Account 1',
			((Account) result.filteredOldList[0]).Name,
			'The first record newList should have a name of Test Account 1'
		);
	}

	@IsTest
	private static void validFormulaWithNoMatchingRecordsShouldProcessNoRecords() {
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';

		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.Assert.isNotNull(result, 'result should not be null');
		System.Assert.isTrue(
			result.filteredNewList.isEmpty(),
			'filteredNewList should be empty'
		);
		System.Assert.isTrue(
			result.filteredOldList.isEmpty(),
			'filteredOldList should be empty'
		);
	}

	@SuppressWarnings('PMD.ApexDoc')
	global class AccountTriggerRecord extends TriggerRecord {
		global Account record {
			get {
				return (Account) this.newSObject;
			}
		}
		global Account recordPrior {
			get {
				return (Account) this.oldSObject;
			}
		}
	}
}
