# TriggerAction

`SUPPRESSWARNINGS`

The `TriggerAction` class defines the interfaces that should be implemented by Trigger Actions.
Trigger Actions are classes that define the logic that should be executed before or after a DML operation on a record.
The `TriggerAction` class defines the following interfaces:
- `BeforeInsert`: This interface defines the logic that should be executed before a new record is inserted.
- `AfterInsert`: This interface defines the logic that should be executed after a new record is inserted.
- `BeforeUpdate`: This interface defines the logic that should be executed before a record is updated.
- `AfterUpdate`: This interface defines the logic that should be executed after a record is updated.
- `BeforeDelete`: This interface defines the logic that should be executed before a record is deleted.
- `AfterDelete`: This interface defines the logic that should be executed after a record is deleted.
- `AfterUndelete`: This interface defines the logic that should be executed after a record is undeleted.
- `DmlFinalizer`: This interface defines the logic that should be executed after all DML operations have completed.
---
To implement a Trigger Action, you must create a class that implements one or more of the `TriggerAction` interfaces.
The class must also be annotated with the `@AuraEnabled` annotation.
Once you have created a Trigger Action class, you can register it with the `TriggerActionRegistry` class.
The `TriggerActionRegistry` class is responsible for managing the execution of Trigger Actions.


**Group** Trigger Actions Framework

## Interfaces
### AfterDelete

This interface defines the logic that should be executed after a record is deleted.

#### Methods
##### `public void afterDelete(List&lt;SObject&gt; oldList)`

This method is called after a record is deleted.

###### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that were deleted.|

---

### AfterInsert

This interface defines the logic that should be executed after a new record is inserted.

#### Methods
##### `public void afterInsert(List&lt;SObject&gt; newList)`

This method is called after a new record is inserted.

###### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that were inserted.|

---

### AfterUndelete

This interface defines the logic that should be executed after a record is undeleted.

#### Methods
##### `public void afterUndelete(List&lt;SObject&gt; newList)`

This method is called after a record is undeleted.

###### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that were undeleted.|

---

### AfterUpdate

This interface defines the logic that should be executed after a record is updated.

#### Methods
##### `public void afterUpdate(List&lt;SObject&gt; newList, List&lt;SObject&gt; oldList)`

This method is called after a record is updated.

###### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that were updated.|
|`oldList`|The list of old records that were updated.|

---

### BeforeDelete

This interface defines the logic that should be executed before a record is deleted.

#### Methods
##### `public void beforeDelete(List&lt;SObject&gt; oldList)`

This method is called before a record is deleted.

###### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that are being deleted.|

---

### BeforeInsert

This interface defines the logic that should be executed before
a new record is inserted.

#### Methods
##### `public void beforeInsert(List&lt;SObject&gt; newList)`

This method is called before a new record is inserted.

###### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being inserted.|

---

### BeforeUpdate

This interface defines the logic that should be executed before a record is updated.

#### Methods
##### `public void beforeUpdate(List&lt;SObject&gt; newList, List&lt;SObject&gt; oldList)`

This method is called before a record is updated.

###### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being updated.|
|`oldList`|The list of old records that are being updated.|

---

### DmlFinalizer

This interface defines the logic that should be executed after all DML operations have completed.

#### Methods
##### `public void execute(FinalizerHandler context)`

This method is called after all DML operations have completed.

###### Parameters

|Param|Description|
|---|---|
|`context`|The context of the finalizer.|

---

