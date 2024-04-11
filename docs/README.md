# Classes
## Trigger Actions Framework

### [FinalizerHandler](/Trigger-Actions-Framework/FinalizerHandler.md)

The `FinalizerHandler` class is a utility class that handles the execution of dynamic finalizers.
Finalizers are classes that implement the `TriggerAction.DmlFinalizer` interface and are defined in Custom Metadata.
Finalizers can be used to perform custom actions after all DML operations have compl&hellip;


### [FlowChangeEventHeader](/Trigger-Actions-Framework/FlowChangeEventHeader.md)

A flow-accessible version of the ChangeEventHeader class for use in
a flow handler of a change data capture event.



### [MetadataTriggerHandler](/Trigger-Actions-Framework/MetadataTriggerHandler.md)

The `MetadataTriggerHandler` class is a trigger handler that executes Trigger
Actions defined in Custom Metadata.
This class implements the `TriggerAction` interface for all supported Trigger Operations:
- `BeforeInsert`
- `AfterInsert`
- `BeforeUpdate`
- `AfterUpdate`
- `BeforeDelete`
- `AfterDele&hellip;


### [TriggerAction](/Trigger-Actions-Framework/TriggerAction.md)

The `TriggerAction` class defines the interfaces that should be implemented by Trigger Actions.
Trigger Actions are classes that define the logic that should be executed before or after a DML operation on a record.
The `TriggerAction` class defines the following interfaces:
- `BeforeInsert`: This i&hellip;


### [TriggerActionConstants](/Trigger-Actions-Framework/TriggerActionConstants.md)

This class contains constants used by the TriggerAction framework.



### [TriggerActionFlow](/Trigger-Actions-Framework/TriggerActionFlow.md)

This class implements the TriggerAction interface and provides a framework for
executing Flows before or after the insert, update, delete, or undelete of records.



### [TriggerActionFlowAddError](/Trigger-Actions-Framework/TriggerActionFlowAddError.md)

This class provides an Invocable method that can be used to add an error to an sObject.
The Invocable method is called `addError` and it takes a list of `Request` objects as input.
Each `Request` object contains the following properties:
- `record`: The sObject to add the error to.
- `fieldName`: T&hellip;


### [TriggerActionFlowBypass](/Trigger-Actions-Framework/TriggerActionFlowBypass.md)

This class provides an Invocable method that can be used to bypass a trigger action flow, Apex class, or Object trigger.
The Invocable method is called `bypass` and it takes a list of `Request` objects as input.
Each `Request` object contains the following properties:
- `name`: The API name of the &hellip;


### [TriggerActionFlowBypassProcessor](/Trigger-Actions-Framework/TriggerActionFlowBypassProcessor.md)

This abstract class provides a framework for processing bypass requests for
trigger action flows, Apex classes, and Object triggers.
To use this class, you must first create a subclass that implements the
`processApexBypasses`, `processFlowBypasses`, and `processObjectBypasses` methods.
You can the&hellip;


### [TriggerActionFlowChangeEvent](/Trigger-Actions-Framework/TriggerActionFlowChangeEvent.md)

The `TriggerActionFlowChangeEvent` class is a subclass of the `TriggerActionFlow`
class that is used to handle change events.
Change events are events that are generated when a record is created, updated, or deleted.
The `TriggerActionFlowChangeEvent` class provides the ability to access the change&hellip;


### [TriggerActionFlowClearAllBypasses](/Trigger-Actions-Framework/TriggerActionFlowClearAllBypasses.md)

The `TriggerActionFlowClearAllBypasses` class is a utility class that handles the
clearing of all bypasses for objects, Apex actions, or Flow actions.
Bypasses are used to prevent the execution of specific Trigger Actions.
The `TriggerActionFlowClearAllBypasses` class provides a way to clear all by&hellip;


### [TriggerActionFlowClearBypass](/Trigger-Actions-Framework/TriggerActionFlowClearBypass.md)

The `TriggerActionFlowClearBypass` class is a utility class that handles the clearing
of bypasses for objects, Apex actions, or Flow actions.
Bypasses are used to prevent the execution of specific Trigger Actions.
The `TriggerActionFlowClearBypass` class provides a way to clear the bypass for a spe&hellip;


### [TriggerActionFlowIsBypassed](/Trigger-Actions-Framework/TriggerActionFlowIsBypassed.md)

The `TriggerActionFlowIsBypassed` class is a utility class that handles the checking of
bypasses for objects, Apex actions, or Flow actions.
Bypasses are used to prevent the execution of specific Trigger Actions.
The `TriggerActionFlowIsBypassed` class provides a way to check if the bypass is set
t&hellip;


### [TriggerBase](/Trigger-Actions-Framework/TriggerBase.md)

The `TriggerBase` class is a base class for all trigger handlers.
Trigger handlers are classes that define the logic that should be executed before or after
a DML operation on a record.
The `TriggerBase` class provides the following functionality:
- A way to bypass the execution of specific trigger&hellip;


### [TriggerTestUtility](/Trigger-Actions-Framework/TriggerTestUtility.md)

The `TriggerTestUtility` class is a utility class that provides helper methods for writing
Apex test classes for trigger handlers.
The `TriggerTestUtility` class provides the following helper methods:
- `getFakeId`: This method generates a fake ID for the specified sObject type.


