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
@SuppressWarnings(
	'PMD.ApexUnitTestClassShouldHaveRunAs, PMD.AvoidGlobalModifier'
)
@IsTest
global class FormulaFilterTest {
	private static final String ACCOUNT_SOBJECT_NAME = 'Account';
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
	private static IllegalArgumentException caught;

	@IsTest
	private static void noFormulaShouldProcessAllRecords() {
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.assertEquals(
			2,
			result.newList.size(),
			'The size of newList should be 2'
		);
		System.assertEquals(
			2,
			result.oldList.size(),
			'The size of oldList should be 2'
		);
	}

	@IsTest
	private static void emptyStringFormulaShouldProcessAllRecords() {
		configuration.Entry_Criteria__c = '';

		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.assertEquals(
			2,
			result.newList.size(),
			'The size of newList should be 2'
		);
		System.assertEquals(
			2,
			result.oldList.size(),
			'The size of newList should be 2'
		);
	}

	@IsTest
	private static void validFormulaShouldFilterContentsOfNewList() {
		configuration.Entry_Criteria__c = 'record.Name = "Test Account 1"';

		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.assertEquals(
			1,
			result.newList.size(),
			'There should be 1 record in newList'
		);
		System.Assert.areEqual(
			'Test Account 1',
			((Account) result.newList[0]).Name,
			'The first record newList should have a name of Test Account 1'
		);
		System.assertEquals(
			1,
			result.oldList.size(),
			'There should be 1 record in newList'
		);
		System.Assert.areEqual(
			'Test Account 1',
			((Account) result.oldList[0]).Name,
			'The first record newList should have a name of Test Account 1'
		);
	}

	@IsTest
	private static void validFormulaWithNoMatchingRecordsShouldProcessNoRecords() {
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';

		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);

		FormulaFilter.Result result = filter.filterByEntryCriteria(
			newList,
			oldList
		);

		System.Assert.isNotNull(result, 'result should not be null');
		System.Assert.isTrue(result.newList.isEmpty(), 'newList should be empty');
		System.Assert.isTrue(result.oldList.isEmpty(), 'oldList should be empty');
	}

	@IsTest
	private static void emptyClassShouldThrowException() {
		sobjectSetting.Formula_Evaluation_Class_Name__c = '';
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);
		try {
			filter.filterByEntryCriteria(newList, oldList);
		} catch (IllegalArgumentException e) {
			caught = e;
		}
		Assert.areEqual(
			String.format(
				FormulaFilter.MISSING_CLASS_NAME,
				new List<String>{ ACCOUNT_SOBJECT_NAME }
			),
			caught.getMessage(),
			'The exception message should match the expected error'
		);
	}

	@IsTest
	private static void nullClassShouldThrowException() {
		sobjectSetting.Formula_Evaluation_Class_Name__c = null;
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);
		try {
			filter.filterByEntryCriteria(newList, oldList);
		} catch (IllegalArgumentException e) {
			caught = e;
		}
		Assert.areEqual(
			String.format(
				FormulaFilter.MISSING_CLASS_NAME,
				new List<String>{ ACCOUNT_SOBJECT_NAME }
			),
			caught.getMessage(),
			'The exception message should match the expected error'
		);
	}

	@IsTest
	private static void nonGlobalShouldThrowException() {
		sobjectSetting.Formula_Evaluation_Class_Name__c = 'FormulaFilterTest.AccountTriggerRecordPublic';
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);
		try {
			filter.filterByEntryCriteria(newList, oldList);
		} catch (IllegalArgumentException e) {
			caught = e;
		}
		Assert.areEqual(
			String.format(
				FormulaFilter.CLASS_MUST_BE_GLOBAL,
				new List<String>{
					ACCOUNT_SOBJECT_NAME,
					sobjectSetting.Formula_Evaluation_Class_Name__c
				}
			),
			caught.getMessage(),
			'The exception message should match the expected error'
		);
	}

	@IsTest
	private static void nonTriggerRecordClassShouldThrowException() {
		sobjectSetting.Formula_Evaluation_Class_Name__c = 'FormulaFilterTest.AccountNonTriggerRecord';
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);
		try {
			filter.filterByEntryCriteria(newList, oldList);
		} catch (IllegalArgumentException e) {
			caught = e;
		}
		Assert.areEqual(
			String.format(
				FormulaFilter.INVALID_SUBTYPE,
				new List<String>{
					ACCOUNT_SOBJECT_NAME,
					sobjectSetting.Formula_Evaluation_Class_Name__c
				}
			),
			caught.getMessage(),
			'The exception message should match the expected error'
		);
	}

	@IsTest
	private static void nonExistentClassShouldThrowException() {
		sobjectSetting.Formula_Evaluation_Class_Name__c = 'TotallyBogusClassNameWhichDoesNotExist';
		configuration.Entry_Criteria__c = 'record.Name = "FooBar"';
		FormulaFilter filter = new FormulaFilter(
			configuration,
			TriggerOperation.BEFORE_UPDATE,
			ACCOUNT_SOBJECT_NAME
		);
		try {
			filter.filterByEntryCriteria(newList, oldList);
		} catch (IllegalArgumentException e) {
			caught = e;
		}
		Assert.areEqual(
			String.format(
				FormulaFilter.INVALID_CLASS,
				new List<String>{
					ACCOUNT_SOBJECT_NAME,
					sobjectSetting.Formula_Evaluation_Class_Name__c
				}
			),
			caught.getMessage(),
			'The exception message should match the expected error'
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

	@SuppressWarnings('PMD.ApexDoc')
	global class AccountNonTriggerRecord {
		global Account record {
			get {
				return new Account();
			}
		}
		global Account recordPrior {
			get {
				return new Account();
			}
		}
	}

	@SuppressWarnings('PMD.ApexDoc')
	public class AccountTriggerRecordPublic extends TriggerRecord {
		public Account record {
			get {
				return (Account) this.newSObject;
			}
		}
		public Account recordPrior {
			get {
				return (Account) this.oldSObject;
			}
		}
	}
}
