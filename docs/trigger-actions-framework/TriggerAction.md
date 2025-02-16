# TriggerAction Class

`SUPPRESSWARNINGS`

The `TriggerAction` class defines the interfaces that should be implemented by Trigger Actions. 
 
Trigger Actions are classes that define the logic that should be executed before or after a DML operation on a record. 
The `TriggerAction` class defines the following interfaces: 
 
- `BeforeInsert` : This interface defines the logic that should be executed before a new record is inserted. 
- `AfterInsert` : This interface defines the logic that should be executed after a new record is inserted. 
- `BeforeUpdate` : This interface defines the logic that should be executed before a record is updated. 
- `AfterUpdate` : This interface defines the logic that should be executed after a record is updated. 
- `BeforeDelete` : This interface defines the logic that should be executed before a record is deleted. 
- `AfterDelete` : This interface defines the logic that should be executed after a record is deleted. 
- `AfterUndelete` : This interface defines the logic that should be executed after a record is undeleted. 
- `DmlFinalizer` : This interface defines the logic that should be executed after all DML operations have completed. 
--- 
To implement a Trigger Action, you must create a class that implements one or more of the `TriggerAction` interfaces.

**Group** Trigger Actions Framework

## Interfaces
### BeforeInsert Interface

This interface defines the logic that should be executed before 
a new record is inserted.

#### Methods
##### `beforeInsert(triggerNew)`

This method is called before a new record is inserted.

###### Signature
```apex
public void beforeInsert(List<SObject> triggerNew)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerNew | List&lt;SObject&gt; | The list of new records that are being inserted. |

###### Return Type
**void**

### AfterInsert Interface

This interface defines the logic that should be executed after a new record is inserted.

#### Methods
##### `afterInsert(triggerNew)`

This method is called after a new record is inserted.

###### Signature
```apex
public void afterInsert(List<SObject> triggerNew)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerNew | List&lt;SObject&gt; | The list of new records that were inserted. |

###### Return Type
**void**

### BeforeUpdate Interface

This interface defines the logic that should be executed before a record is updated.

#### Methods
##### `beforeUpdate(triggerNew, triggerOld)`

This method is called before a record is updated.

###### Signature
```apex
public void beforeUpdate(List<SObject> triggerNew, List<SObject> triggerOld)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerNew | List&lt;SObject&gt; | The list of new records that are being updated. |
| triggerOld | List&lt;SObject&gt; | The list of old records that are being updated. |

###### Return Type
**void**

### AfterUpdate Interface

This interface defines the logic that should be executed after a record is updated.

#### Methods
##### `afterUpdate(triggerNew, triggerOld)`

This method is called after a record is updated.

###### Signature
```apex
public void afterUpdate(List<SObject> triggerNew, List<SObject> triggerOld)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerNew | List&lt;SObject&gt; | The list of new records that were updated. |
| triggerOld | List&lt;SObject&gt; | The list of old records that were updated. |

###### Return Type
**void**

### BeforeDelete Interface

This interface defines the logic that should be executed before a record is deleted.

#### Methods
##### `beforeDelete(triggerOld)`

This method is called before a record is deleted.

###### Signature
```apex
public void beforeDelete(List<SObject> triggerOld)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerOld | List&lt;SObject&gt; | The list of old records that are being deleted. |

###### Return Type
**void**

### AfterDelete Interface

This interface defines the logic that should be executed after a record is deleted.

#### Methods
##### `afterDelete(triggerOld)`

This method is called after a record is deleted.

###### Signature
```apex
public void afterDelete(List<SObject> triggerOld)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerOld | List&lt;SObject&gt; | The list of old records that were deleted. |

###### Return Type
**void**

### AfterUndelete Interface

This interface defines the logic that should be executed after a record is undeleted.

#### Methods
##### `afterUndelete(triggerNew)`

This method is called after a record is undeleted.

###### Signature
```apex
public void afterUndelete(List<SObject> triggerNew)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| triggerNew | List&lt;SObject&gt; | The list of new records that were undeleted. |

###### Return Type
**void**

### DmlFinalizer Interface

This interface defines the logic that should be executed after all DML operations have completed.

#### Methods
##### `execute(context)`

This method is called after all DML operations have completed.

###### Signature
```apex
public void execute(FinalizerHandler.Context context)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| context | FinalizerHandler.Context | The context of the finalizer. |

###### Return Type
**void**