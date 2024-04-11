# MetadataTriggerHandler

`SUPPRESSWARNINGS`

The `MetadataTriggerHandler` class is a trigger handler that executes Trigger
Actions defined in Custom Metadata.
This class implements the `TriggerAction` interface for all supported Trigger Operations:
- `BeforeInsert`
- `AfterInsert`
- `BeforeUpdate`
- `AfterUpdate`
- `BeforeDelete`
- `AfterDelete`
- `AfterUndelete`
---
The `MetadataTriggerHandler` class reads from the `Trigger_Action__mdt` Custom Metadata type to
define Trigger Actions.
Each Trigger Action must specify the following information:
- `Apex_Class_Name__c`: The name of the Apex class that implements the Trigger Action.
- `Order__c`: The order in which the Trigger Action should be executed.
- `Flow_Name__c`: The name of the Flow to execute (optional).
- `Bypass_Permission__c`: The permission required to bypass the Trigger Action (optional).
- `Required_Permission__c`: The permission required to execute the Trigger Action (optional).
- `Allow_Flow_Recursion__c`: Whether or not to allow the Flow to recurse (optional).
---
The `MetadataTriggerHandler` class also uses the `sObject_Trigger_Setting__mdt` Custom Metadata type to define
Trigger Action settings for specific sObjects.
Each sObject Trigger Setting must specify the following information:
- `Bypass_Permission__c`: The permission required to bypass the Trigger Action for the specified sObject (optional).
- `Required_Permission__c`: The permission required to execute the Trigger Action for the specified sObject (optional).
---
To use the `MetadataTriggerHandler` class, you must create a Trigger on the desired sObject and specify the
 `MetadataTriggerHandler` class as the handler.
You can then define Trigger Actions and sObject Trigger Settings in Custom Metadata to control the behavior of the Trigger.
**Example:**
```
trigger AccountTrigger on Account (
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
    new MetadataTriggerHandler.execute();
}
```
This example will execute all Trigger Actions defined in Custom Metadata for the `Account` sObject.


**Inheritance**

[TriggerBase](/Trigger-Actions-Framework/TriggerBase.md)
 &gt; 
MetadataTriggerHandler


**Implemented types**

[TriggerAction.BeforeInsert](TriggerAction.BeforeInsert)
, 
[TriggerAction.AfterInsert](TriggerAction.AfterInsert)
, 
[TriggerAction.BeforeUpdate](TriggerAction.BeforeUpdate)
, 
[TriggerAction.AfterUpdate](TriggerAction.AfterUpdate)
, 
[TriggerAction.BeforeDelete](TriggerAction.BeforeDelete)
, 
[TriggerAction.AfterDelete](TriggerAction.AfterDelete)
, 
[TriggerAction.AfterUndelete](TriggerAction.AfterUndelete)


**Group** Trigger Actions Framework

## Properties

### `public idToNumberOfTimesSeenAfterUpdate` → `Map<Id,Integer>`

*Inherited*

This method returns a map of the IDs of the records that have been seen in the `AFTER_UPDATE` context to the number of times they have been seen.

### `public idToNumberOfTimesSeenBeforeUpdate` → `Map<Id,Integer>`

*Inherited*

This method returns a map of the IDs of the records that have been seen in the `BEFORE_UPDATE` context to the number of times they have been seen.

---
## Methods
### `public static void bypass(String actionName)`

Bypass the execution of a Trigger Action.

#### Parameters

|Param|Description|
|---|---|
|`actionName`|The name of the Trigger Action to bypass.|

### `public static void clearBypass(String actionName)`

Clear the bypass for a Trigger Action.

#### Parameters

|Param|Description|
|---|---|
|`actionName`|The name of the Trigger Action to clear the bypass for.|

### `public static Boolean isBypassed(String actionName)`

Check if a Trigger Action is bypassed.

#### Parameters

|Param|Description|
|---|---|
|`actionName`|The name of the Trigger Action to check.|

#### Returns

|Type|Description|
|---|---|
|`Boolean`|True if the Trigger Action is bypassed, false otherwise.|

### `public static void clearAllBypasses()`

Clear all bypasses for Trigger Actions.

### `public void beforeInsert(List<SObject> newList)`

Execute the Before Insert Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records being inserted.|

### `public void afterInsert(List<SObject> newList)`

Execute the After Insert Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that were inserted.|

### `public void beforeUpdate(List<SObject> newList, List<SObject> oldList)`

Execute the Before Update Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of updated records.|
|`oldList`|The list of old records before the update.|

### `public void afterUpdate(List<SObject> newList, List<SObject> oldList)`

Execute the After Update Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of updated records.|
|`oldList`|The list of old records before the update.|

### `public void beforeDelete(List<SObject> oldList)`

Execute the Before Delete Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of records being deleted.|

### `public void afterDelete(List<SObject> oldList)`

Execute the After Delete Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of records that were deleted.|

### `public void afterUndelete(List<SObject> newList)`

Execute the After Undelete Trigger Actions.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records that were undeleted.|

### `public static void offsetExistingDmlRows()`

*Inherited*


This method offsets the number of existing DML rows.

### `public static void waitToFinalize()`

*Inherited*


This method waits to finalize the DML operation.

### `public static void nowFinalize()`

*Inherited*


This method now finalizes the DML operation.

### `public void run()`

*Inherited*


This method runs the trigger handler.

---
