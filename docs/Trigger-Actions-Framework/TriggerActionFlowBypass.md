# TriggerActionFlowBypass

`SUPPRESSWARNINGS`

This class provides an Invocable method that can be used to bypass a trigger action flow, Apex class, or Object trigger.
The Invocable method is called `bypass` and it takes a list of `Request` objects as input.
Each `Request` object contains the following properties:
- `name`: The API name of the trigger action flow, Apex class, or Object trigger to bypass.
- `bypassType`: The type of bypass to perform. Valid values are `Apex`, `Flow`, or `Object`.


**Group** Trigger Actions Framework

## Methods
### `public static void bypass(List<Request> requests)`

`INVOCABLEMETHOD`

This Invocable method bypasses a trigger action flow, Apex class, or Object trigger.

#### Parameters

|Param|Description|
|---|---|
|`requests`|A list of `Request` objects.|

---
## Classes
### Request

This class represents a request to bypass a trigger action flow, Apex class, or Object trigger.

#### Fields

##### `public bypassType` → `String`

`INVOCABLEVARIABLE` 

##### `public name` → `String`

`INVOCABLEVARIABLE` 

---

---
