({
    init: function (component, event, helper) {

        helper.identifyObject(component); // sets the v.IN_sObject / v.OUT_sObject value providers
        component.set("v.data", component.get("v.IN_sObject"));
        helper.setDataAttribute(component); // copies IN_xxx value provider to v.data
        component.set("v.backingData", component.get("v.data")); // backingData used exclusively for searching

        var action = component.get("c.getSObjectColumns");

        action.setParams({"genericSObject": component.get("v.data")[0]
            ,"hideIdField": component.get("v.hideIdField") // hide id fields
            ,"hideReferenceFields": component.get("v.hideReferenceFields") // hide relationship field
            ,"lstField": component.get("v.fieldList") // optional list of fields (otherwise sobject will be inspected only)
        }); // needs to use v.data object
        action.setCallback(this, function(response) { //Includes the function with a response
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){ //Only look for SUCCESS, no error handling
                component.set("v.columns", JSON.parse(response.getReturnValue()));
                console.table(JSON.parse(response.getReturnValue()));
            }
            else {
                debugger;
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); //Tell lightning framework to take care of the action
    }
    , updateSelectedRows: function(component, event, helper) {
        var sObject = component.get("v.OUT_sObject");
        var selectedRows = event.getParam("selectedRows");
        var setRows = [];

        for (var i = 0; i < selectedRows.length; i++){
            delete selectedRows[i].sobjectType; // remove the sobjecttype attribute
            setRows.push(selectedRows[i]);
        }

        helper.setOutput(component, setRows); // copies setRows to OUT_xxx

        if (component.get("v." + sObject).length > 0)
            component.set("v.hasSelectedRows", true);
        else
            component.set("v.hasSelectedRows", false);

        // In case maxRowSelection == 1 (radio button) and record selected set selectedRowId
        if (setRows.length === 1 && component.get("v.maxRowSelection") === 1)
            component.set("v.selectedRowId", setRows[0].Id);
        else
            component.set("v.selectedRowId", "");

        console.log("[LightningDataWrapperController][updateSelectedRows] hasSelectedRows = " + component.get("v.hasSelectedRows"));
        console.log("[LightningDataWrapperController][updateSelectedRows] selectedRowId = " + component.get("v.selectedRowId"));
    }
    , filterData: function (component) {
        var data = component.get("v.backingData"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            results = data.filter(row => regex.test(JSON.stringify(row)));
        }
        catch (e) {
            // invalid regex, use full list
        }
        component.set("v.data", results);
    }
})