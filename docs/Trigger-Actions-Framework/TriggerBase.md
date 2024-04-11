# virtual TriggerBase

`SUPPRESSWARNINGS`

The `TriggerBase` class is a base class for all trigger handlers.
Trigger handlers are classes that define the logic that should be executed before or after
a DML operation on a record.
The `TriggerBase` class provides the following functionality:
- A way to bypass the execution of specific trigger handlers.
- A way to check if a specific trigger handler is bypassed.
- A way to clear all bypasses.
- A way to offset the number of existing DML rows.
- A way to wait to finalize the DML operation.
- A way to now finalize the DML operation.
---
To use the `TriggerBase` class, you must create a subclass that implements the `TriggerAction` interface.
The `TriggerAction` interface defines the methods that should be implemented by trigger actions.


**Group** Trigger Actions Framework

## Properties

### `public idToNumberOfTimesSeenAfterUpdate` → `Map<Id,Integer>`


This method returns a map of the IDs of the records that have been seen in the `AFTER_UPDATE` context to the number of times they have been seen.

### `public idToNumberOfTimesSeenBeforeUpdate` → `Map<Id,Integer>`


This method returns a map of the IDs of the records that have been seen in the `BEFORE_UPDATE` context to the number of times they have been seen.

---
## Methods
### `public static void bypass(String sObjectName)`

This method bypasses the execution of the specified object.

#### Parameters

|Param|Description|
|---|---|
|`sObjectName`|The API name of the object to bypass.|

### `public static void clearBypass(String sObjectName)`

This method clears the bypass for the specified object.

#### Parameters

|Param|Description|
|---|---|
|`sObjectName`|The API name of the object to clear the bypass for.|

### `public static Boolean isBypassed(String sObjectName)`

This method checks if the specified object is bypassed.

#### Parameters

|Param|Description|
|---|---|
|`sObjectName`|The API name of the object to check the bypass for.|

#### Returns

|Type|Description|
|---|---|
|`Boolean`|True if the object is bypassed, false otherwise.|

### `public static void clearAllBypasses()`

This method clears all bypasses.

### `public static void offsetExistingDmlRows()`

This method offsets the number of existing DML rows.

### `public static void waitToFinalize()`

This method waits to finalize the DML operation.

### `public static void nowFinalize()`

This method now finalizes the DML operation.

### `public void run()`

This method runs the trigger handler.

---
