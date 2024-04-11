# virtual TriggerActionFlow

`SUPPRESSWARNINGS`

This class implements the TriggerAction interface and provides a framework for
executing Flows before or after the insert, update, delete, or undelete of records.


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

## Fields

### `public allowRecursion` → `Boolean`


### `public flowName` → `String`


---
## Methods
### `public static void bypass(String flowName)`

This method bypasses the execution of the Flow for the specified list of records.

#### Parameters

|Param|Description|
|---|---|
|`flowName`|The API name of the Flow to bypass.|

### `public static void clearBypass(String flowName)`

This method clears the bypass for the specified list of records.

#### Parameters

|Param|Description|
|---|---|
|`flowName`|The API name of the Flow to clear the bypass for.|

### `public static Boolean isBypassed(String flowName)`

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

This method clears all bypasses for all Flows.

### `public static void validateType(String bypassType)`

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

This method executes the Flow for the specified list of records before the insert of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records to execute the Flow for.|

### `public void afterInsert(List<SObject> newList)`

This method executes the Flow for the specified list of records after the insert of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records to execute the Flow for.|

### `public void beforeUpdate(List<SObject> newList, List<SObject> oldList)`

This method executes the Flow for the specified list of records before the update of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being updated.|
|`oldList`|The list of old records that are being updated.|

### `public void afterUpdate(List<SObject> newList, List<SObject> oldList)`

This method executes the Flow for the specified list of records after the update of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of new records that are being updated.|
|`oldList`|The list of old records that are being updated.|

### `public void beforeDelete(List<SObject> oldList)`

This method executes the Flow for the specified list of records before the delete of the records.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that are being deleted.|

### `public void afterDelete(List<SObject> oldList)`

This method executes the Flow for the specified list of records after the delete of the records.

#### Parameters

|Param|Description|
|---|---|
|`oldList`|The list of old records that are being deleted.|

### `public void afterUndelete(List<SObject> newList)`

This method executes the Flow for the specified list of records before the undelete of the records.

#### Parameters

|Param|Description|
|---|---|
|`newList`|The list of records that are being restored.|

---
