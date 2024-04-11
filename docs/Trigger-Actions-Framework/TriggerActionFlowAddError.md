# TriggerActionFlowAddError

This class provides an Invocable method that can be used to add an error to an sObject.
The Invocable method is called `addError` and it takes a list of `Request` objects as input.
Each `Request` object contains the following properties:
- `record`: The sObject to add the error to.
- `fieldName`: The API name of the field to add the error to.
- `errorMessage`: The error message to add.
---
If the `fieldName` property is not specified, the error message will be added to the sObject without a field name.


**Group** Trigger Actions Framework

## Methods
### `public static void addError(List<Request> requests)`

`INVOCABLEMETHOD`

This Invocable method adds an error to an sObject.

#### Parameters

|Param|Description|
|---|---|
|`requests`|A list of `Request` objects.|

---
## Classes
### Request

This class represents a request to add an error to an sObject.

#### Fields

##### `public errorMessage` → `String`

`INVOCABLEVARIABLE` 

##### `public fieldName` → `String`

`INVOCABLEVARIABLE` 

##### `public record` → `SObject`

`INVOCABLEVARIABLE` 

---

---
