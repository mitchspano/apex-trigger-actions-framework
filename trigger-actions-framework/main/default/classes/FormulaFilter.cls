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

/**
 * @description The `FormulaFilter` class provides functionality to filter lists of SObjects based on a configurable
 * entry criteria formula defined within a `Trigger_Action__mdt` configuration row.
 */
global class FormulaFilter {
	private String entryCriteriaFormula;
	private System.Type typeToEvaluate;
	private FormulaEval.FormulaInstance fx;

	/**
	 * @description Constructs a new `FormulaFilter` instance with the specified trigger action configuration.
	 * @param triggerActionConfiguration The trigger action configuration containing the entry criteria formula.
	 * @param context The trigger operation context.
	 */
	public FormulaFilter(
		Trigger_Action__mdt triggerActionConfiguration,
		TriggerOperation context
	) {
		this.entryCriteriaFormula = triggerActionConfiguration?.Entry_Criteria__c;
		if (this.entryCriteriaFormula != null) {
			String nameOfTypeToEvaluate = this.getNameOfType(
				triggerActionConfiguration,
				context
			);
			this.typeToEvaluate = Type.forName(nameOfTypeToEvaluate);
			this.setFormulaInstance();
		}
	}

	/**
	 * @description Filters the given lists of new and old SObjects based on the entry criteria formula.
	 *
	 * This method evaluates the entry criteria formula for each record in the `newList` and `oldList`.
	 * If the formula evaluates to true for a record, it is included in the filtered lists.
	 *
	 * @param newList The list of new SObjects to filter.
	 * @param oldList The list of old SObjects to filter.
	 * @return A `FormulaFilter.Result` object containing the filtered lists of new and old SObjects.
	 */
	public FormulaFilter.Result filterByEntryCriteria(
		List<SObject> newList,
		List<SObject> oldList
	) {
		FormulaFilter.Result result = new FormulaFilter.Result();
		if (this.entryCriteriaFormula == null) {
			result.filteredNewList = newList;
			result.filteredOldList = oldList;
			return result;
		}
		List<SObject> filteredNewList = new List<SObject>();
		List<SObject> filteredOldList = new List<SObject>();
		Integer size = newList != null ? newList.size() : oldList.size();
		for (Integer i = 0; i < size; i++) {
			SObject record = newList?.get(i);
			SObject recordPrior = oldList?.get(i);
			TriggerRecord toProcess = (TriggerRecord) (this.typeToEvaluate.newInstance());
			toProcess.newSobject = record;
			toProcess.oldSobject = recordPrior;
			if ((Boolean) this.fx.evaluate(toProcess)) {
				filteredNewList.add(record);
				filteredOldList.add(recordPrior);
			}
		}
		result.filteredNewList = filteredNewList;
		result.filteredOldList = filteredOldList;
		return result;
	}

	private void setFormulaInstance() {
		this.fx = Formula.builder()
			.withReturnType(FormulaEval.FormulaReturnType.Boolean)
			.withGlobalVariables(FormulaEval.FormulaGlobal.values())
			.withType(this.typeToEvaluate)
			.withFormula(this.entryCriteriaFormula)
			.build();
	}

	private String getNameOfType(
		Trigger_Action__mdt triggerActionConfiguration,
		TriggerOperation context
	) {
		String triggerOperation = context.name();
		sObject_Trigger_Setting__mdt triggerSetting = (sObject_Trigger_Setting__mdt) triggerActionConfiguration.getSObject(
			triggerOperation + '__r'
		);
		return triggerSetting.Formula_Evaluation_Class_Name__c;
	}

	/**
	 * @description Inner class representing the result of the `filterByEntryCriteria` method.
	 */
	public class Result {
		/**
		 * @description The filtered list of new SObjects.
		 */
		public List<SObject> filteredNewList;
		/**
		 * @description The filtered list of old SObjects.
		 */
		public List<SObject> filteredOldList;
	}
}
