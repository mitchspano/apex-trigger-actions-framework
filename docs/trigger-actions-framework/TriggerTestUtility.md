# TriggerTestUtility Class

`ISTEST`

The `TriggerTestUtility` class is a utility class that provides helper methods for writing 
Apex test classes for trigger handlers. 
 
The `TriggerTestUtility` class provides the following helper methods: 
 
- `getFakeId` : This method generates a fake ID for the specified sObject type.

**Group** Trigger Actions Framework

## Methods
### `getFakeId(sObjectType)`

This method generates a fake ID for the specified sObject type.

#### Signature
```apex
public static Id getFakeId(Schema.SObjectType sObjectType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | The sObject type to generate a fake ID for. |

#### Return Type
**Id**

A fake ID for the specified sObject type.