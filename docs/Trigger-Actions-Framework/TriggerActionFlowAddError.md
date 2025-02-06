# TriggerActionFlowAddError Class

This class provides an Invocable method that can be used to add an error to an sObject. 
 
The Invocable method is called `addError` and it takes a list of `Request` objects as input. 
Each `Request` object contains the following properties: 
 
- `record` : The sObject to add the error to. 
- `fieldName` : The API name of the field to add the error to. 
- `errorMessage` : The error message to add. 
 
--- 
 
If the `fieldName` property is not specified, the error message will be added to the sObject without a field name.

**Group** Trigger Actions Framework

## Methods
### `addError(requests)`

`INVOCABLEMETHOD`

This Invocable method adds an error to an sObject.

#### Signature
```apex
public static void addError(List<Request> requests)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requests | List&lt;Request&gt; | A list of `Request` objects. |

#### Return Type
**void**

## Classes
### Request Class

This class represents a request to add an error to an sObject.

#### Fields
##### `record`

`INVOCABLEVARIABLE`

###### Signature
```apex
public record
```

###### Type
SObject

---

##### `fieldName`

`INVOCABLEVARIABLE`

###### Signature
```apex
public fieldName
```

###### Type
String

---

##### `errorMessage`

`INVOCABLEVARIABLE`

###### Signature
```apex
public errorMessage
```

###### Type
String