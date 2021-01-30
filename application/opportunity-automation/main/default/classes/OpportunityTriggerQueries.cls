public class OpportunityTriggerQueries {
	private static OpportunityTriggerQueries instance;

	private OpportunityTriggerQueries() {
	}

	public static OpportunityTriggerQueries getInstance() {
		if (OpportunityTriggerQueries.instance == null) {
			OpportunityTriggerQueries.instance = new OpportunityTriggerQueries();
		}
		return OpportunityTriggerQueries.instance;
	}

	public Map<Id, Account> oppIdToAccount;

	public class BeforeInsert implements TriggerAction.BeforeInsert {
		public void beforeInsert(List<Opportunity> newList) {
			populateOppIdToAccount(newList);
		}

		private void populateOppIdToAccount(List<Opportunity> newList) {
			Map<Id, Account> oppIdToAccount = new Map<Id, Account>();
			Set<Id> accountIds = new Set<Id>();
			for (Opportunity myOpp : newList) {
				accountIds.add(myOpp.AccountId);
			}
			Map<Id, Account> accountMap = new Map<Id, Account>(
				[SELECT Id, Name FROM Account WHERE Id IN :accountIds]
			);
			for (Opportunity myOpp : newList) {
				if (myOpp.AccountId != null) {
					oppIdToAccount.put(myOpp.Id, accountMap.get(myOpp.AccountId));
				}
			}
			OpportunityTriggerQueries.getInstance().oppIdToAccount = oppIdToAccount;
		}
	}
}
