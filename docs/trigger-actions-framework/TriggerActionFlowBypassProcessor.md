# TriggerActionFlowBypassProcessor Class
`abstract`

This abstract class provides a framework for processing bypass requests for 
trigger action flows, Apex classes, and Object triggers. 
 
To use this class, you must first create a subclass that implements the 
 `processApexBypasses` , `processFlowBypasses` , and `processObjectBypasses` methods. 
You can then use the `execute` method to process bypass requests for the specified 
type of bypass.

**Group** Trigger Actions Framework

## Methods
### `execute(requestType, requestName)`

This method processes a bypass request for the specified type of bypass.

#### Signature
```apex
public void execute(String requestType, String requestName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| requestType | String | The type of bypass to process. Valid values are `Apex` , `Flow` , or `Object` . |
| requestName | String | The name of the trigger action flow, Apex class, or Object trigger to bypass. |

#### Return Type
**void**