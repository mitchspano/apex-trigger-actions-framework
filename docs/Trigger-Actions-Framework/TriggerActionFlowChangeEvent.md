# TriggerActionFlowChangeEvent

The `TriggerActionFlowChangeEvent` class is a subclass of the `TriggerActionFlow`
class that is used to handle change events.
Change events are events that are generated when a record is created, updated, or deleted.
The `TriggerActionFlowChangeEvent` class provides the ability to access the change event header in the Flow interview.
To use the `TriggerActionFlowChangeEvent` class, you must first create a Flow that accepts a variable of
type `FlowChangeEventHeader`.
You can then use the `TriggerActionFlowChangeEvent` class to invoke the Flow and pass the change event header
as the input variable.


**Inheritance**

[TriggerActionFlow](/Trigger-Actions-Framework/TriggerActionFlow.md)
 &gt; 
TriggerActionFlowChangeEvent


**Group** Trigger Actions Framework

## Fields

### `public allowRecursion` → `Boolean`

*Inherited*

### `public flowName` → `String`

*Inherited*

---
## Methods
### `public static void bypass(String flowName)`

*Inherited*


This method bypasses the execution of the Flow for the specified list of records.

#### Parameters

|Param|Description|
|---|---|
|`flowName`|The API name of the Flow to bypass.|

### `public static void clearBypass(String flowName)`

*Inherited*


This method clears the bypass for the specified list of records.

#### Parameters

|Param|Description|
|---|---|
|`flowName`|The API name of the Flow to clear the bypass for.|

### `public static Boolean isBypassed(String flowName)`

*Inherited*


This method checks if the Flow is bypassed for the specified list of records.

#### Parameters

|Param|Description|
|---|---|
|`flowName`|The API name of the Flow to check the bypass for.|

#### Returns

|Type|Description|
|---|---|
|`Boolean`|`true` if the Flow is bypassed for the specified list of records, `false` otherwise.|

### `public static void clearAllBypasses()`

*Inherited*


This method clears all bypasses for all Flows.

### `public static void validateType(String bypassType)`

*Inherited*


This method validates the specified bypass type.

#### Parameters

|Param|Description|
|---|---|
|`bypassType`|The bypass type to validate.|

#### Throws

|Exception|Description|
|---|---|
|`IllegalArgumentException`|if the bypass type is not valid.|

### `public void beforeInsert(List<SObject> newList)`

*Inherited*


This method executes the Flow for the specified list of records before the insert of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records to execute the Flow for.|

### `public void afterInsert(List<SObject> newList)`

*Inherited*


This method executes the Flow for the specified list of records after the insert of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records to execute the Flow for.|

### `public void beforeUpdate(List<SObject> newList, List<SObject> oldList)`

*Inherited*


This method executes the Flow for the specified list of records before the update of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being updated.|
|`oldList`|The list of old records that are being updated.|

### `public void afterUpdate(List<SObject> newList, List<SObject> oldList)`

*Inherited*


This method executes the Flow for the specified list of records after the update of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being updated.|
|`oldList`|The list of old records that are being updated.|

### `public void beforeDelete(List<SObject> oldList)`

*Inherited*


This method executes the Flow for the specified list of records before the delete of the records.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that are being deleted.|

### `public void afterDelete(List<SObject> oldList)`

*Inherited*


This method executes the Flow for the specified list of records after the delete of the records.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that are being deleted.|

### `public void afterUndelete(List<SObject> newList)`

*Inherited*


This method executes the Flow for the specified list of records before the undelete of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records that are being restored.|

---
