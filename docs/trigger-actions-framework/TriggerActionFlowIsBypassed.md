# TriggerActionFlowIsBypassed Class

`SUPPRESSWARNINGS`

The `TriggerActionFlowIsBypassed` class is a utility class that handles the checking of 
bypasses for objects, Apex actions, or Flow actions. 
 
Bypasses are used to prevent the execution of specific Trigger Actions. 
The `TriggerActionFlowIsBypassed` class provides a way to check if the bypass is set 
to `true` for a specific object, Apex action, or Flow action. 
 
To use the `TriggerActionFlowIsBypassed` class, you must first create a list of the objects, 
Apex actions, or Flow actions that you want to check the bypasses for. 
You can then call the `isBypassed` method of the `TriggerActionFlowIsBypassed` class and 
pass the list of objects, Apex actions, or Flow actions as the input parameter. 
 
The `isBypassed` method will return a list of booleans indicating whether the bypass is set 
to `true` for each of the specified objects, Apex actions, or Flow actions.

**Group** Trigger Actions Framework

## Methods
### `isBypassed(requests)`

`INVOCABLEMETHOD`

This method checks if the bypass is set to `true` for the specified objects, 
Apex actions, or Flow actions.

#### Signature
```apex
public static List<Boolean> isBypassed(List<Request> requests)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requests | List&lt;Request&gt; | A list of the objects, Apex actions, or Flow actions to check the bypasses for. |

#### Return Type
**List&lt;Boolean&gt;**

A list of booleans indicating whether the bypass is set to ,[object Object], for each of the,[object Object],specified objects, Apex actions, or Flow actions.

## Classes
### Request Class

The `Request` class is a class that represents a request to check if the bypass is set to `true` for a specific object, Apex action, or Flow action. 
 
To use the `Request` class, you must specify the following properties: 
 
- `name` : The API name of the object, Apex action, or Flow action to check the bypass for. 
- `bypassType` : The type of bypass to check. Valid values are `Apex` , `Flow` , or `Object` .

#### Fields
##### `name`

`INVOCABLEVARIABLE`

###### Signature
```apex
public name
```

###### Type
String

---

##### `bypassType`

`INVOCABLEVARIABLE`

###### Signature
```apex
public bypassType
```

###### Type
String