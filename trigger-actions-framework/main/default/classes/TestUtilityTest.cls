@IsTest
private class TestUtilityTest {
	@IsTest
	private static void testLoadJSON() {
		String jsonString = TestUtility.loadJSON('TestUtilityTest_testLoadJSON');
		List<Account> accounts = (List<Account>) JSON.deserialize(
			jsonString,
			List<Account>.class
		);
		System.assertEquals('My Account', accounts[0].Name);
		System.assertEquals(3, accounts[0].Contacts.size());
	}
}
