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

public with sharing class FlowChangeEventHeader {
	@InvocableVariable
	@AuraEnabled
	public String entityName;
	@InvocableVariable
	@AuraEnabled
	public List<String> recordIds;
	@InvocableVariable
	@AuraEnabled
	public String changeType;
	@InvocableVariable
	@AuraEnabled
	public String changeOrigin;
	@InvocableVariable
	@AuraEnabled
	public String transactionKey;
	@InvocableVariable
	@AuraEnabled
	public Integer sequenceNumber;
	@InvocableVariable
	@AuraEnabled
	public Long commitTimestamp;
	@InvocableVariable
	@AuraEnabled
	public String commitUser;
	@InvocableVariable
	@AuraEnabled
	public Long commitNumber;
	@InvocableVariable
	@AuraEnabled
	public List<String> nulledFields;
	@InvocableVariable
	@AuraEnabled
	public List<String> diffFields;
	@InvocableVariable
	@AuraEnabled
	public List<String> changedFields;

	public FlowChangeEventHeader(EventBus.ChangeEventHeader header) {
		this.entityName = header.entityName;
		this.recordIds = header.recordIds;
		this.changeType = header.changeType;
		this.changeOrigin = header.changeOrigin;
		this.transactionKey = header.transactionKey;
		this.sequenceNumber = header.sequenceNumber;
		this.commitTimestamp = header.commitTimestamp;
		this.commitUser = header.commitUser;
		this.commitNumber = header.commitNumber;
		this.nulledFields = header.nulledFields;
		this.diffFields = header.diffFields;
		this.changedFields = header.changedFields;
	}
}
