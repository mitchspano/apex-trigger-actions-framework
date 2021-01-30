public class ta_Opportunity_StandardizeName implements TriggerAction.BeforeInsert {
	public void beforeInsert(List<Opportunity> newList) {
		Map<Id, Account> accountIdToAccount = ta_Opportunity_Queries.getInstance()
			.beforeAccountMap;
		for (Opportunity myOpp : newList) {
			String accountName = accountIdToAccount.get(myOpp.AccountId)?.Name;
			myOpp.Name = accountName != null
				? accountName + ' | ' + myOpp.Name
				: myOpp.Name;
		}
	}
}
