public class ta_Opportunity_Queries {
	private static ta_Opportunity_Queries instance;

	private ta_Opportunity_Queries() {
	}

	public static ta_Opportunity_Queries getInstance() {
		if (ta_Opportunity_Queries.instance == null) {
			ta_Opportunity_Queries.instance = new ta_Opportunity_Queries();
		}
		return ta_Opportunity_Queries.instance;
	}

	public Map<Id, Account> beforeAccountMap { get; private set; }

	public class Service implements TriggerAction.BeforeInsert {
		public void beforeInsert(List<Opportunity> newList) {
			ta_Opportunity_Queries.getInstance().beforeAccountMap = getAccountMapFromOpportunities(
				newList
			);
		}

		private Map<Id, Account> getAccountMapFromOpportunities(
			List<Opportunity> newList
		) {
			Set<Id> accountIds = new Set<Id>();
			for (Opportunity myOpp : newList) {
				accountIds.add(myOpp.AccountId);
			}
			return new Map<Id, Account>(
				[SELECT Id, Name FROM Account WHERE Id IN :accountIds]
			);
		}
	}
}
