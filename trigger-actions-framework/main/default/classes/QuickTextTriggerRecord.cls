public with sharing class QuickTextTriggerRecord extends FlowTriggerRecord {
	public QuickTextTriggerRecord() {
		super();
	}

	public QuickTextTriggerRecord(
		QuickText newRecord,
		QuickText oldRecord,
		Integer newRecordIndex,
		Integer triggerActionFlowIdentifier
	) {
		super(newRecord, oldRecord, newRecordIndex, triggerActionFlowIdentifier);
	}

	@AuraEnabled
	public QuickText newRecord {
		get {
			return (QuickText) this.newSObject;
		}
		set {
			this.newSObject = value;
		}
	}

	@AuraEnabled
	public QuickText oldRecord {
		get {
			return (QuickText) this.oldSObject;
		}
	}

	public override Map<String, Object> getFlowInput(
		List<SObject> newList,
		List<SObject> oldList,
		Integer triggerActionFlowIdentifier
	) {
		List<SObject> collection = newList != null ? newList : oldList;
		List<QuickTextTriggerRecord> triggerRecords = new List<QuickTextTriggerRecord>();
		for (Integer i = 0; i < collection.size(); i++) {
			QuickText newRecord = newList != null ? (QuickText) newList.get(i) : null;
			QuickText oldRecord = oldList != null ? (QuickText) oldList.get(i) : null;
			triggerRecords.add(
				new QuickTextTriggerRecord(
					newRecord,
					oldRecord,
					i,
					triggerActionFlowIdentifier
				)
			);
		}
		return new Map<String, Object>{
			TriggerActionFlow.TRIGGER_RECORDS_VARIABLE => triggerRecords
		};
	}
}
