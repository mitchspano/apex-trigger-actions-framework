# Trigger Action

## API Name
`Trigger_Action__mdt`

## Fields
### After Delete

Enter the name of the sObject you want to have this action execute on during the after delete context

**API Name**

`After_Delete__c`

**Type**

*MetadataRelationship*

---
### After Insert

Enter the name of the sObject you want to have this action execute on during the after insert context

**API Name**

`After_Insert__c`

**Type**

*MetadataRelationship*

---
### After Undelete

Enter the name of the sObject you want to have this action execute on during the after undelete context

**API Name**

`After_Undelete__c`

**Type**

*MetadataRelationship*

---
### After Update

Enter the name of the sObject you want to have this action execute on during the after update context

**API Name**

`After_Update__c`

**Type**

*MetadataRelationship*

---
### Allow Flow Recursion?

Check this box to allow the flow to execute recursively

**API Name**

`Allow_Flow_Recursion__c`

**Type**

*Checkbox*

---
### Apex Class Name
**Required**

Enter the name of the Apex Class which defines the action to be taken

**API Name**

`Apex_Class_Name__c`

**Type**

*Text*

---
### Before Delete

Enter the name of the sObject you want to have this action execute on during the before delete context

**API Name**

`Before_Delete__c`

**Type**

*MetadataRelationship*

---
### Before Insert

Enter the name of the sObject you want to have this action execute on during the before insert context

**API Name**

`Before_Insert__c`

**Type**

*MetadataRelationship*

---
### Before Update

Enter the name of the sObject you want to have this action execute on during the before update context

**API Name**

`Before_Update__c`

**Type**

*MetadataRelationship*

---
### Bypass Execution

Set this to true to bypass this Trigger Action from being called

**API Name**

`Bypass_Execution__c`

**Type**

*Checkbox*

---
### Bypass Permission

Optional. Enter the API name of a permission. If this field has a value, then the triggers on this object will be bypassed if the running user has the custom permission identified.

**API Name**

`Bypass_Permission__c`

**Type**

*Text*

---
### Description

**API Name**

`Description__c`

**Type**

*LongTextArea*

---
### Entry Criteria

Formula which if evaluated to true for a given record during trigger processing, then this trigger action will be processed for that record.

**API Name**

`Entry_Criteria__c`

**Type**

*LongTextArea*

---
### Flow Name

Enter the API name of the flow you would like to execute.

**API Name**

`Flow_Name__c`

**Type**

*Text*

---
### Order
**Required**

**API Name**

`Order__c`

**Type**

*Number*

---
### Required Permission

Optional. Enter the API name of a permission. If this field has a value, then the triggers on this object will  only execute if the running user has the custom permission identified.

**API Name**

`Required_Permission__c`

**Type**

*Text*