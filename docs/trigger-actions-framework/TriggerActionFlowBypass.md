# TriggerActionFlowBypass Class

`SUPPRESSWARNINGS`

This class provides an Invocable method that can be used to bypass a trigger action flow, Apex class, or Object trigger. 
 
The Invocable method is called `bypass` and it takes a list of `Request` objects as input. 
Each `Request` object contains the following properties: 
 
- `name` : The API name of the trigger action flow, Apex class, or Object trigger to bypass. 
- `bypassType` : The type of bypass to perform. Valid values are `Apex` , `Flow` , or `Object` .

**Group** Trigger Actions Framework

## Methods
### `bypass(requests)`

`INVOCABLEMETHOD`

This Invocable method bypasses a trigger action flow, Apex class, or Object trigger.

#### Signature
```apex
public static void bypass(List<Request> requests)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requests | List&lt;Request&gt; | A list of `Request` objects. |

#### Return Type
**void**

## Classes
### Request Class

This class represents a request to bypass a trigger action flow, Apex class, or Object trigger.

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