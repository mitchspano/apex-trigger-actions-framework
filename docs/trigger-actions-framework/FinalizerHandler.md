# FinalizerHandler Class
`virtual`

The `FinalizerHandler` class is a utility class that handles the execution of dynamic finalizers. 
 
Finalizers are classes that implement the `TriggerAction.DmlFinalizer` interface and are defined in Custom Metadata. 
Finalizers can be used to perform custom actions after all DML operations have completed. 
 
The `FinalizerHandler` class provides the following functionality: 
 
- A way to bypass the execution of specific finalizers. 
- A way to check if a specific finalizer is bypassed. 
- A way to clear all bypasses. 
- A way to handle dynamic finalizers. 
--- 
To use the `FinalizerHandler` class, you must first create a Custom Metadata type called `DML_Finalizer__mdt` . 
The `DML_Finalizer__mdt` Custom Metadata type must have the following fields: 
 
- `Apex_Class_Name__c` : The name of the Apex class that implements the finalizer. 
- `Order__c` : The order in which the finalizer should be executed. 
- `Bypass_Execution__c` : A flag that indicates whether or not the finalizer should be bypassed. 
- `Bypass_Permission__c` : The permission required to bypass the finalizer. 
- `Required_Permission__c` : The permission required to execute the finalizer. 
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
### `bypass(finalizer)`

Bypass the execution of a specific finalizer.

#### Signature
```apex
public static void bypass(String finalizer)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| finalizer | String | The name of the finalizer to bypass. |

#### Return Type
**void**

---

### `clearBypass(finalizer)`

Clear the bypass for a specific finalizer.

#### Signature
```apex
public static void clearBypass(String finalizer)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| finalizer | String | The name of the finalizer to clear the bypass for. |

#### Return Type
**void**

---

### `isBypassed(finalizer)`

Check if a specific finalizer is bypassed.

#### Signature
```apex
public static Boolean isBypassed(String finalizer)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| finalizer | String | The name of the finalizer to check. |

#### Return Type
**Boolean**

True if the finalizer is bypassed, false otherwise.

---

### `clearAllBypasses()`

Clear all bypasses.

#### Signature
```apex
public static void clearAllBypasses()
```

#### Return Type
**void**

---

### `handleDynamicFinalizers()`

Handle dynamic finalizers. Instantiates and executes finalizers based on metadata.

#### Signature
```apex
public virtual void handleDynamicFinalizers()
```

#### Return Type
**void**

## Classes
### Context Class

Context to be passed to the implementation&#x27;s `.execute` methodis object&#x27;s definition is empty. We are establishing the interface 
to include the context to help future-proof the interface&#x27;s specifications.