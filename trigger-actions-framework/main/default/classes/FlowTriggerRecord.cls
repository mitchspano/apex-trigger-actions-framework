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
	public static Map<String, SObject> triggerActionFlowIdAndIndexToNewRecord = new Map<String, SObject>();
	private static final String INVALID_INPUT = 'The index of new list and the Flow identifier are required.';
	@TestVisible
	private static final String PIPE = '|';
	private Integer newListIndex;
	private Integer triggerActionFlowId;

	public FlowTriggerRecord() {
		// no argument constructor necessary to use Type.ForName
	}

	protected FlowTriggerRecord(
		SObject newSobject,
		SObject oldSObject,
		Integer newListIndex,
		Integer triggerActionFlowId
	) {
		this.newListIndex = newListIndex;
		this.triggerActionFlowId = triggerActionFlowId;
		this.newSobject = newSobject;
		this.oldSobject = oldSobject;
	}

	public abstract Map<String, Object> getFlowInput(
		List<SObject> newList,
		List<SObject> oldList,
		Integer triggerActionFlowId
	);

	protected SObject newSobject {
		get {
			return newSobject;
		}
		set {
			if (this.newListIndex == null || triggerActionFlowId == null) {
				throw new IllegalArgumentException(INVALID_INPUT);
			}
			this.newSobject = value;
			FlowTriggerRecord.triggerActionFlowIdAndIndexToNewRecord.put(
				this.triggerActionFlowId +
				PIPE +
				this.newListIndex,
				newSobject
			);
		}
	}

	protected SObject oldSobject;
}
