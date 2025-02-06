# TriggerActionFlow Class
`virtual`

`SUPPRESSWARNINGS`

This class implements the TriggerAction interface and provides a framework for 
executing Flows before or after the insert, update, delete, or undelete of records.

**Group** Trigger Actions Framework

**Implements**

TriggerAction.BeforeInsert, 
TriggerAction.AfterInsert, 
TriggerAction.BeforeUpdate, 
TriggerAction.AfterUpdate, 
TriggerAction.BeforeDelete, 
TriggerAction.AfterDelete, 
TriggerAction.AfterUndelete

## Fields
### `flowName`

#### Signature
```apex
public flowName
```

#### Type
String

---

### `allowRecursion`

#### Signature
```apex
public allowRecursion
```

#### Type
Boolean

## Methods
### `bypass(flowName)`

This method bypasses the execution of the Flow for the specified list of records.

#### Signature
```apex
public static void bypass(String flowName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| flowName | String | The API name of the Flow to bypass. |

#### Return Type
**void**

---

### `clearBypass(flowName)`

This method clears the bypass for the specified list of records.

#### Signature
```apex
public static void clearBypass(String flowName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| flowName | String | The API name of the Flow to clear the bypass for. |

#### Return Type
**void**

---

### `isBypassed(flowName)`

This method checks if the Flow is bypassed for the specified list of records.

#### Signature
```apex
public static Boolean isBypassed(String flowName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| flowName | String | The API name of the Flow to check the bypass for. |

#### Return Type
**Boolean**

,[object Object], if the Flow is bypassed for the specified list of records, ,[object Object], otherwise.

---

### `clearAllBypasses()`

This method clears all bypasses for all Flows.

#### Signature
```apex
public static void clearAllBypasses()
```

#### Return Type
**void**

---

### `validateType(bypassType)`

This method validates the specified bypass type.

#### Signature
```apex
public static void validateType(String bypassType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| bypassType | String | The bypass type to validate. |

#### Return Type
**void**

#### Throws
IllegalArgumentException: if the bypass type is not valid.

---

### `beforeInsert(newList)`

This method executes the Flow for the specified list of records before the insert of the records.

#### Signature
```apex
public void beforeInsert(List<SObject> newList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| newList | List&lt;SObject&gt; | The list of records to execute the Flow for. |

#### Return Type
**void**

---

### `afterInsert(newList)`

This method executes the Flow for the specified list of records after the insert of the records.

#### Signature
```apex
public void afterInsert(List<SObject> newList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| newList | List&lt;SObject&gt; | The list of records to execute the Flow for. |

#### Return Type
**void**

---

### `beforeUpdate(newList, oldList)`

This method executes the Flow for the specified list of records before the update of the records.

#### Signature
```apex
public void beforeUpdate(List<SObject> newList, List<SObject> oldList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| newList | List&lt;SObject&gt; | The list of new records that are being updated. |
| oldList | List&lt;SObject&gt; | The list of old records that are being updated. |

#### Return Type
**void**

---

### `afterUpdate(newList, oldList)`

This method executes the Flow for the specified list of records after the update of the records.

#### Signature
```apex
public void afterUpdate(List<SObject> newList, List<SObject> oldList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| newList | List&lt;SObject&gt; | The list of new records that are being updated. |
| oldList | List&lt;SObject&gt; | The list of old records that are being updated. |

#### Return Type
**void**

---

### `beforeDelete(oldList)`

This method executes the Flow for the specified list of records before the delete of the records.

#### Signature
```apex
public void beforeDelete(List<SObject> oldList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| oldList | List&lt;SObject&gt; | The list of old records that are being deleted. |

#### Return Type
**void**

---

### `afterDelete(oldList)`

This method executes the Flow for the specified list of records after the delete of the records.

#### Signature
```apex
public void afterDelete(List<SObject> oldList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| oldList | List&lt;SObject&gt; | The list of old records that are being deleted. |

#### Return Type
**void**

---

### `afterUndelete(newList)`

This method executes the Flow for the specified list of records before the undelete of the records.

#### Signature
```apex
public void afterUndelete(List<SObject> newList)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| newList | List&lt;SObject&gt; | The list of records that are being restored. |

#### Return Type
**void**