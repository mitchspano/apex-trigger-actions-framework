/*
   Copyright 2021 Google LLC

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

@SuppressWarnings('PMD.EmptyStatementBlock')
public abstract class FlowTriggerRecord {
	public static Map<Integer, SObject> newRecordIndexToNewRecord = new Map<Integer, SObject>();
	private static final String NEW_RECORD_INDEX_REQUIRED = 'The index of the newRecord in the newList is required.';
	private Integer newRecordIndex;

	public FlowTriggerRecord() {
		// no argument constructor necessary to use Type.ForName
	}

	protected FlowTriggerRecord(
		SObject newSobject,
		SObject oldSObject,
		Integer newRecordIndex
	) {
		this.newRecordIndex = newRecordIndex;
		this.newSobject = newSobject;
		this.oldSobject = oldSobject;
	}

	public abstract Map<String, Object> getFlowInput(
		List<SObject> newList,
		List<SObject> oldList
	);

	protected SObject newSobject {
		get {
			return newSobject;
		}
		set {
			this.newSobject = value;
			if (this.newRecordIndex == null) {
				throw new IllegalArgumentException(NEW_RECORD_INDEX_REQUIRED);
			}
			FlowTriggerRecord.newRecordIndexToNewRecord.put(
				this.newRecordIndex,
				newSobject
			);
		}
	}

	protected SObject oldSobject;
}
