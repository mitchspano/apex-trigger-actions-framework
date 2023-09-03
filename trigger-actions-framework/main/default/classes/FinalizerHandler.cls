/*
   Copyright 2023 Google LLC

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
@SuppressWarnings('PMD.ApexDoc')
public with sharing virtual class FinalizerHandler {
	@TestVisible
	private static final String DML_IN_FINALIZER_ERROR = 'DML is not allowed within the finalizer context.';
	@TestVisible
	private static final String INVALID_TYPE_ERROR_FINALIZER = 'Please check the DML Finalizer Custom Metadata. The {0} class does not implement the TriggerAction.DmlFinalizer interface.';
	@TestVisible
	private static final String INVALID_CLASS_ERROR_FINALIZER = 'Please check the DML Finalizer Custom Metadata. The {0} class does not exist.';

	@TestVisible
	private static Set<String> bypassedFinalizers = new Set<String>();

	@TestVisible
	private static Map<String, Boolean> permissionMap = new Map<String, Boolean>();

	public static void bypass(String finalizer) {
		FinalizerHandler.bypassedFinalizers.add(finalizer);
	}

	public static void clearBypass(String finalizer) {
		FinalizerHandler.bypassedFinalizers.remove(finalizer);
	}

	public static Boolean isBypassed(String finalizer) {
		return FinalizerHandler.bypassedFinalizers.contains(finalizer);
	}

	public static void clearAllBypasses() {
		FinalizerHandler.bypassedFinalizers.clear();
	}

	public virtual void handleDynamicFinalizers() {
		Context context = new Context();
		List<DML_Finalizer__mdt> sortedFinalizers = getSortedFinalizers();
		for (DML_Finalizer__mdt finalizerMetadata : sortedFinalizers) {
			if (finalizerMetadata.Bypass_Execution__c) {
				return;
			}
			populatePermissionMap(finalizerMetadata.Bypass_Permission__c);
			populatePermissionMap(finalizerMetadata.Required_Permission__c);
			if (
				isNotBypassed(
					finalizerMetadata.Bypass_Permission__c,
					finalizerMetadata.Required_Permission__c
				)
			) {
				callReferencedFinalizer(finalizerMetadata, context);
			}
		}
	}

	private void callReferencedFinalizer(
		DML_Finalizer__mdt finalizerMetadata,
		Context context
	) {
		Object dynamicInstance;
		String className = finalizerMetadata.Apex_Class_Name__c;
		if (FinalizerHandler.isBypassed(className)) {
			return;
		}
		try {
			dynamicInstance = Type.forName(className).newInstance();
		} catch (System.NullPointerException e) {
			handleFinalizerException(INVALID_CLASS_ERROR_FINALIZER, className);
		}
		TriggerAction.DmlFinalizer finalizer;
		try {
			finalizer = (TriggerAction.DmlFinalizer) dynamicInstance;
		} catch (System.TypeException e) {
			handleFinalizerException(INVALID_TYPE_ERROR_FINALIZER, className);
		}
		Integer dmlOperationsBefore = Limits.getDmlStatements();
		finalizer.execute(context);
		if (limits.getDmlStatements() > dmlOperationsBefore) {
			throw new FinalizerException(DML_IN_FINALIZER_ERROR);
		}
	}

	private List<DML_Finalizer__mdt> getSortedFinalizers() {
		List<FinalizerSorter> sorters = new List<FinalizerSorter>();
		for (DML_Finalizer__mdt finalizer : this.allFinalizers) {
			sorters.add(new FinalizerSorter(finalizer));
		}
		List<DML_Finalizer__mdt> results = new List<DML_Finalizer__mdt>();
		sorters.sort();
		for (FinalizerSorter sorter : sorters) {
			results.add(sorter.metadata);
		}
		return results;
	}

	private void handleFinalizerException(String errorFormat, String className) {
		throw new FinalizerException(
			String.format(errorFormat, new List<String>{ className })
		);
	}

	private boolean isNotBypassed(
		String requiredPermission,
		String bypassPermission
	) {
		return !((requiredPermission != null &&
		permissionMap.get(requiredPermission)) ||
		(bypassPermission != null && !permissionMap.get(bypassPermission)));
	}

	private void populatePermissionMap(String permissionName) {
		if (permissionName != null && !permissionMap.containsKey(permissionName)) {
			permissionMap.put(
				permissionName,
				FeatureManagement.checkPermission(permissionName)
			);
		}
	}

	@TestVisible
	private List<DML_Finalizer__mdt> allFinalizers {
		get {
			if (allFinalizers == null) {
				allFinalizers = DML_Finalizer__mdt.getAll().values();
			}
			return allFinalizers;
		}
		private set;
	}

	private class FinalizerSorter implements Comparable {
		public final DML_Finalizer__mdt metadata;

		public FinalizerSorter(DML_Finalizer__mdt metadata) {
			this.metadata = metadata;
		}

		public Integer compareTo(Object other) {
			Decimal difference = (this.metadata.Order__c -
			((FinalizerSorter) other).metadata.Order__c);
			return difference < 0 ? -1 : difference == 0 ? 0 : 1;
		}
	}

	/**
	 * @description Context to be passed to the implementation's `.execute` method
	 * Currently, this object's definition is empty. We are establishing the interface
	 * to include the context to help future-proof the interface's specifications.
	 */
	public class Context {
	}

	private class FinalizerException extends Exception {
	}
}
