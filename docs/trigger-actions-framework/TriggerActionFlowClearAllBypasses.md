# TriggerActionFlowClearAllBypasses Class

`SUPPRESSWARNINGS`

The `TriggerActionFlowClearAllBypasses` class is a utility class that handles the 
clearing of all bypasses for objects, Apex actions, or Flow actions. 
 
Bypasses are used to prevent the execution of specific Trigger Actions. 
The `TriggerActionFlowClearAllBypasses` class provides a way to clear all bypasses for a specific object, Apex action, or Flow action. 
 
To use the `TriggerActionFlowClearAllBypasses` class, you must first create a list of the objects, Apex actions, or Flow actions that you want to clear the bypasses for. 
You can then call the `clearAllBypasses` method of the `TriggerActionFlowClearAllBypasses` class and pass the list of objects, Apex actions, or Flow actions as the input parameter. 
 
The `clearAllBypasses` method will clear all bypasses for the specified objects, Apex actions, or Flow actions.

**Group** Trigger Actions Framework

## Methods
### `clearAllBypasses(requests)`

`INVOCABLEMETHOD`

This method clears all bypasses for the specified objects, Apex actions, or Flow actions.

#### Signature
```apex
public static void clearAllBypasses(List<String> requests)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requests | List&lt;String&gt; | A list of the objects, Apex actions, or Flow actions to clear the bypasses for. |

#### Return Type
**void**