({
    identifyObject: function(component) {
        var lstObjects = component.get("v.sObjects");

        for (var index = 0; index < lstObjects.length; index++) {
            var sObject = component.get("v.IN_" + lstObjects[index]);
            if (sObject.length > 0) {
                component.set("v.IN_sObject", "IN_" + lstObjects[index]);
                component.set("v.OUT_sObject", "OUT_" + lstObjects[index] );
                console.log("[LightningDataWrapperController][identifyObject] received object = v.IN_" + lstObjects[index]);
                break;
            }
        }
    }
    , setDataAttribute: function(component) {
        var sObject = component.get("v.IN_sObject");
        component.set("v.data", component.get("v." + sObject));

        // workaround for 'cannot read sObject' error for certain standard object like case
        // See details here https://sforce.co/2Tkqih8
        // Explicity set the sobjectType attribute for the first record
        // v.data[0] is being passsed into the getSObjectColumns method on the Apex controller

        var thisData = component.get("v.data");
        thisData[0].sobjectType = sObject.substr(3); // removes leading 'IN_'
        component.set("v.data", thisData);

        console.log("[LightningDataWrapperController][setDataAttribute] v.data copied with v." + sObject);
        console.table(component.get("v." + sObject));
    }
    , setOutput: function(component, setRows) {
        var sObject = component.get("v.OUT_sObject");
        component.set("v." + sObject, setRows);
        console.log("[LightningDataWrapperController][setOutput] v." + sObject + " copied with selected rows");
        console.table(setRows);
    }
})