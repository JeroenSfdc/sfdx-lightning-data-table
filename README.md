# Lightning Data Table

Ever needed to show a Lightning Data Table as part of a Lightning Flow? 

Just grab these sources to get you going!

What can you do with this (yet Aura-based) Flow component?
- Provide it a list of records and it will figure out labels & data types (easiest way to use)
- Provide it a list of records + a list of fields, and it will show the records and the columns specified (the order in the list of fields dicates the order)
- Allow to hide the Record Id field
- Allow to hide any relationship field
- Allow for single select (radio button style) or multi-select

The main thing to consider: you need to configure the Aura component for it to support additional sObjects... 

Step 1.

Add your sObject to this list, follow the naming convention IN_xxx and OUT_xxx. 

    <!-- Public attributes -->
    <aura:attribute name="divStyle"             type="String"               access="public"/> <!-- e.g. height: 300px; -->
    <aura:attribute name="IN_Account"           type="Account[]"            access="public"/>
    <aura:attribute name="IN_Contact"           type="Contact[]"            access="public"/>
    <aura:attribute name="IN_Case"              type="Case[]"               access="public"/>
    <aura:attribute name="IN_Opportunity"       type="Opportunity[]"        access="public"/>

    <aura:attribute name="OUT_Account"          type="Account[]"            access="public"/>
    <aura:attribute name="OUT_Contact"          type="Contact[]"            access="public"/>
    <aura:attribute name="OUT_Case"             type="Case[]"               access="public"/>
    <aura:attribute name="OUT_Opportunity"      type="Opportunity[]"        access="public"/>

Step 2.

Update the `sObjects` property, add the sObject to this list. 

    <!-- Private attributes -->
    <aura:attribute name="sObjects"             type="List"                 access="private"    default="['Account','Contact','Case','Opportunity']"/>
    
Step 3. 

Add your sObject to the design file:

    <!-- all supported input sobjects -->
    <design:attribute name="IN_Account" label="IN_Account" description="Input. Account object."/>
    <design:attribute name="IN_Contact" label="IN_Contact" description="Input. Contact object."/>
    <design:attribute name="IN_Case" label="IN_Case" description="Input. Case object."/>
    <design:attribute name="IN_Opportunity" label="IN_Opportunity" description="Input. Opportunity object."/>

    <!-- all supported input sobjects -->
    <design:attribute name="OUT_Account" label="OUT_Account"/>
    <design:attribute name="OUT_Contact" label="OUT_Contact"/>
    <design:attribute name="OUT_Case" label="OUT_Case"/>
    <design:attribute name="OUT_Opportunity" label="OUT_Opportunity"/>

![](screen-demo.gif)

Want to deploy to a scratch org?

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com)



