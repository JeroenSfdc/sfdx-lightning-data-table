/*

Copyright (c) 2018, salesforce.com, inc.
All rights reserved.

Licensed under the BSD 3-Clause license.
For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause

*/
public with sharing class FlowLightningDatatableCompController {

    private static Map<Schema.DisplayType, String> typeMap = new Map<Schema.DisplayType, String>();

    private class LightningDatatableColumn {
        String label;
        String fieldName;
        String type;
    }

    private static void initTypeMap() {
        typeMap.put(Schema.DisplayType.ID, 'text');
        typeMap.put(Schema.DisplayType.BOOLEAN, 'boolean');
        typeMap.put(Schema.DisplayType.CURRENCY, 'currency');
        typeMap.put(Schema.DisplayType.DATE, 'date');
        typeMap.put(Schema.DisplayType.DATETIME, 'date');
        typeMap.put(Schema.DisplayType.EMAIL, 'email');
        typeMap.put(Schema.DisplayType.INTEGER, 'number');
        typeMap.put(Schema.DisplayType.STRING, 'text');
        typeMap.put(Schema.DisplayType.PHONE, 'phone');
        typeMap.put(Schema.DisplayType.PICKLIST, 'text');
        typeMap.put(Schema.DisplayType.URL, 'url');
        typeMap.put(Schema.DisplayType.PERCENT, 'percent');
        typeMap.put(Schema.DisplayType.REFERENCE, 'text');
        typeMap.put(Schema.DisplayType.TEXTAREA, 'text');
        typeMap.put(Schema.DisplayType.MULTIPICKLIST, 'text');
        typeMap.put(Schema.DisplayType.DOUBLE, 'number');
    }

    @AuraEnabled
    public static String getSObjectColumns(sObject genericSObject, List<String> lstField, boolean hideIdField, boolean hideReferenceFields) {

        initTypeMap();

        List<LightningDatatableColumn> lstColumnObject = new List<LightningDatatableColumn>();
        Map<String, Object> mapPopulatedField = genericSobject.getPopulatedFieldsAsMap(); // get fields from the record
        List<String> lstPopulatedField = new List<String>(mapPopulatedField.keySet());
        List<String> lstSortedField = lstField;

        // If lstField is provided, add the lstPopulatedField items
        if (!lstField.isEmpty()) {
            for (String fieldName : lstPopulatedField) {
                if (! lstSortedField.contains(fieldName)) {
                    lstSortedField.add(fieldName);
                }
            }
        }
        else {
            lstSortedField = lstPopulatedField;
        }

        String sObjectName = genericSObject.getSObjectType().getDescribe().getName();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectType = globalDescribe.get(sObjectName);
        Map<String, Schema.SobjectField> fieldMap = sObjectType.getDescribe().fields.getMap();

        system.debug('hideIdField = ' + hideIdField);
        system.debug('hideReferenceFields = ' + hideReferenceFields);

        for(String fieldName : lstSortedField) {
            system.debug('fieldMap.get(fieldName).getDescribe().getType() = ' + fieldMap.get(fieldName).getDescribe().getType());

            //don't add column data for the ID field
            if (fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.ID  && hideIdField)
                continue;

            //don't add column data for reference/relationship fields
            if (fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.REFERENCE && hideReferenceFields)
                continue;

            //don't add column data for fields ending in 'Id__c' when reference fields are to be hidden.
            if (fieldName.endsWithIgnoreCase('Id__c')  && hideReferenceFields)
                continue;

            fieldMap.get(fieldName).getDescribe().getLabel();
            // {label: 'Product Name', fieldName: 'Name', type: 'text',sortable: true, initialWidth: 300}
            // TODO ideally also pass additonal parameters such as initialWidth, fixedWidth and possible more detailed typeAttributes
            LightningDatatableColumn ldtColumn = new LightningDatatableColumn();
            ldtColumn.fieldName = fieldName;
            ldtColumn.label = fieldMap.get(fieldName).getDescribe().getLabel();
            ldtColumn.type = typeMap.get(fieldMap.get(fieldName).getDescribe().getType());
            lstColumnObject.add(ldtColumn);
        }

        return JSON.serialize(lstColumnObject);
    }
}