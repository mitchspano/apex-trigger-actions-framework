# virtual FinalizerHandler

The `FinalizerHandler` class is a utility class that handles the execution of dynamic finalizers.
Finalizers are classes that implement the `TriggerAction.DmlFinalizer` interface and are defined in Custom Metadata.
Finalizers can be used to perform custom actions after all DML operations have completed.
The `FinalizerHandler` class provides the following functionality:
- A way to bypass the execution of specific finalizers.
- A way to check if a specific finalizer is bypassed.
- A way to clear all bypasses.
- A way to handle dynamic finalizers.
---
To use the `FinalizerHandler` class, you must first create a Custom Metadata type called `DML_Finalizer__mdt`.
The `DML_Finalizer__mdt` Custom Metadata type must have the following fields:
- `Apex_Class_Name__c`: The name of the Apex class that implements the finalizer.
- `Order__c`: The order in which the finalizer should be executed.
- `Bypass_Execution__c`: A flag that indicates whether or not the finalizer should be bypassed.
- `Bypass_Permission__c`: The permission required to bypass the finalizer.
- `Required_Permission__c`: The permission required to execute the finalizer.
---
Once you have created the `DML_Finalizer__mdt` Custom Metadata type, you can create finalizers by creating records
in the `DML_Finalizer__mdt` object.
To bypass the execution of a specific finalizer, you can call the `bypass` method of the `FinalizerHandler` class.
To check if a specific finalizer is bypassed, you can call the `isBypassed` method of the `FinalizerHandler` class.
To clear all bypasses, you can call the `clearAllBypasses` method of the `FinalizerHandler` class.
To handle dynamic finalizers, you can call the `handleDynamicFinalizers` method of the `FinalizerHandler` class.
The `handleDynamicFinalizers` method will instantiate and execute all finalizers that are not bypassed.


**Group** Trigger Actions Framework

## Methods
### `public static void bypass(String finalizer)`

Bypass the execution of a specific finalizer.

#### Parameters

|Param|Description|
|---|---|
|`finalizer`|The name of the finalizer to bypass.|

### `public static void clearBypass(String finalizer)`

Clear the bypass for a specific finalizer.

#### Parameters

|Param|Description|
|---|---|
|`finalizer`|The name of the finalizer to clear the bypass for.|

### `public static Boolean isBypassed(String finalizer)`

Check if a specific finalizer is bypassed.

#### Parameters

|Param|Description|
|---|---|
|`finalizer`|The name of the finalizer to check.|

#### Returns

|Type|Description|
|---|---|
|`Boolean`|True if the finalizer is bypassed, false otherwise.|

### `public static void clearAllBypasses()`

Clear all bypasses.

### `public virtual void handleDynamicFinalizers()`

Handle dynamic finalizers.nstantiates and executes finalizers based on metadata.

---
## Classes
### Context

Context to be passed to the implementation's `.execute` methodis object's definition is empty. We are establishing the interface
to include the context to help future-proof the interface's specifications.


---
