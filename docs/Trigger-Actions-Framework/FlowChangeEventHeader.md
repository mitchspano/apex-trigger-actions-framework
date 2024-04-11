# FlowChangeEventHeader

A flow-accessible version of the ChangeEventHeader class for use in
a flow handler of a change data capture event.


**Group** Trigger Actions Framework


**See** [https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_event_fields_header.htm](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_event_fields_header.htm)

## Constructors
### `public FlowChangeEventHeader(EventBus header)`

Constructor that takes an `EventBus.ChangeEventHeader` object and populates the properties of this object with the values from the `EventBus.ChangeEventHeader` object.

#### Parameters

|Param|Description|
|---|---|
|`header`|The `EventBus.ChangeEventHeader` object to populate the properties of this object with.|

---
## Fields

### `public changeOrigin` → `String`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public changeType` → `String`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public changedFields` → `List<String>`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public commitNumber` → `Long`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public commitTimestamp` → `Long`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public commitUser` → `String`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public diffFields` → `List<String>`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public entityName` → `String`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public nulledFields` → `List<String>`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public recordIds` → `List<String>`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public sequenceNumber` → `Integer`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

### `public transactionKey` → `String`

`INVOCABLEVARIABLE` 
`AURAENABLED` 

---
## Methods
### `public Boolean equals(Object obj)`

Compares this `FlowChangeEventHeader` object to another object.

#### Parameters

|Param|Description|
|---|---|
|`obj`|The object to compare this `FlowChangeEventHeader` object to.|

#### Returns

|Type|Description|
|---|---|
|`Boolean`|`true` if the objects are equal, `false` otherwise.|

### `public Integer hashCode()`

Returns a hash code value for this `FlowChangeEventHeader` object.

#### Returns

|Type|Description|
|---|---|
|`Integer`|A hash code value for this `FlowChangeEventHeader` object.|

---
