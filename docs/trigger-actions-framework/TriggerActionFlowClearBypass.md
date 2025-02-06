# TriggerActionFlowClearBypass Class

`SUPPRESSWARNINGS`

The `TriggerActionFlowClearBypass` class is a utility class that handles the clearing 
of bypasses for objects, Apex actions, or Flow actions. 
 
Bypasses are used to prevent the execution of specific Trigger Actions. 
The `TriggerActionFlowClearBypass` class provides a way to clear the bypass for a specific object, Apex action, or Flow action. 
 
To use the `TriggerActionFlowClearBypass` class, you must first create a list of the objects, Apex actions, or Flow actions that you want to clear the bypasses for. 
You can then call the `clearBypass` method of the `TriggerActionFlowClearBypass` class and pass the list of objects, Apex actions, or Flow actions as the input parameter. 
 
The `clearBypass` method will clear the bypass for the specified objects, Apex actions, or Flow actions.

**Group** Trigger Actions Framework

## Methods
### `clearBypass(requests)`

`INVOCABLEMETHOD`

This method clears the bypass for the specified objects, Apex actions, or Flow actions.

#### Signature
```apex
public static void clearBypass(List<Request> requests)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requests | List&lt;Request&gt; | A list of the objects, Apex actions, or Flow actions to clear the bypasses for. |

#### Return Type
**void**

## Classes
### Request Class

The `Request` class is a class that represents a request to clear the bypass for a 
specific object, Apex action, or Flow action. 
 
To use the `Request` class, you must specify the following properties: 
 
- `name` : The API name of the object, Apex action, or Flow action to clear the bypass for. 
- `bypassType` : The type of bypass to clear. Valid values are `Apex` , `Flow` , or `Object` .

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