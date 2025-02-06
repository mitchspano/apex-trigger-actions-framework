# FlowChangeEventHeader Class

A flow-accessible version of the ChangeEventHeader class for use in 
a flow handler of a change data capture event.

**Group** Trigger Actions Framework

**See** https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_event_fields_header.htm

## Fields
### `entityName`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public entityName
```

#### Type
String

---

### `recordIds`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public recordIds
```

#### Type
List&lt;String&gt;

---

### `changeType`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public changeType
```

#### Type
String

---

### `changeOrigin`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public changeOrigin
```

#### Type
String

---

### `transactionKey`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public transactionKey
```

#### Type
String

---

### `sequenceNumber`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public sequenceNumber
```

#### Type
Integer

---

### `commitTimestamp`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public commitTimestamp
```

#### Type
Long

---

### `commitUser`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public commitUser
```

#### Type
String

---

### `commitNumber`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public commitNumber
```

#### Type
Long

---

### `nulledFields`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public nulledFields
```

#### Type
List&lt;String&gt;

---

### `diffFields`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public diffFields
```

#### Type
List&lt;String&gt;

---

### `changedFields`

`INVOCABLEVARIABLE`
`AURAENABLED`

#### Signature
```apex
public changedFields
```

#### Type
List&lt;String&gt;

## Constructors
### `FlowChangeEventHeader(header)`

Constructor that takes an `EventBus.ChangeEventHeader` object and populates 
the properties of this object with the values from the `EventBus.ChangeEventHeader` object.

#### Signature
```apex
public FlowChangeEventHeader(EventBus.ChangeEventHeader header)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| header | EventBus.ChangeEventHeader | The ,[object Object], object to populate the properties of this object with. |

## Methods
### `equals(obj)`

Compares this `FlowChangeEventHeader` object to another object.

#### Signature
```apex
public Boolean equals(Object obj)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| obj | Object | The object to compare this `FlowChangeEventHeader` object to. |

#### Return Type
**Boolean**

,[object Object], if the objects are equal, ,[object Object], otherwise.

---

### `hashCode()`

Returns a hash code value for this `FlowChangeEventHeader` object.

#### Signature
```apex
public Integer hashCode()
```

#### Return Type
**Integer**

A hash code value for this ,[object Object], object.