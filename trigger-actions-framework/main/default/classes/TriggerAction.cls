/*
   Copyright 2020 Google LLC

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

@SuppressWarnings('PMD.ApexDoc, PMD.CyclomaticComplexity')
public class TriggerAction {
	public interface BeforeInsert {
		void beforeInsert(List<SObject> newList);
	}

	public interface AfterInsert {
		void afterInsert(List<SObject> newList);
	}

	public interface BeforeUpdate {
		void beforeUpdate(List<SObject> newList, List<SObject> oldList);
	}

	public interface AfterUpdate {
		void afterUpdate(List<SObject> newList, List<SObject> oldList);
	}

	public interface BeforeDelete {
		void beforeDelete(List<SObject> oldList);
	}

	public interface AfterDelete {
		void afterDelete(List<SObject> oldList);
	}

	public interface AfterUndelete {
		void afterUndelete(List<SObject> newList);
	}

	public interface DmlFinalizer {
		void execute(FinalizerHandler.Context context);
	}
}
