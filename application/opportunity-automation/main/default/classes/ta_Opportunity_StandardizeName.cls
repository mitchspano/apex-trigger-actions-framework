public class ta_Opportunity_StandardizeName implements TriggerAction.BeforeInsert {
	public void beforeInsert(List<Opportunity> newList) {
		Map<Id, Account> populatedNewMap = OpportunityTriggerQueries.getInstance()
			.oppIdToAccount;
		system.debug('populatedNewMap: ' + populatedNewMap);
		for (Opportunity myOpp : newList) {
			String accountName = populatedNewMap.get(myOpp.Id)?.Name;
			myOpp.Name = accountName != null
				? accountName + ' | ' + myOpp.Name
				: myOpp.Name;
		}
	}
}
