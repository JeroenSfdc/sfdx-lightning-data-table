/*

Copyright (c) 2018, salesforce.com, inc.
All rights reserved.

Licensed under the BSD 3-Clause license.
For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause

*/
@IsTest
private class TestFlowLightningDatatableCompController {
    static List<String> testLstFields = new List<String>();

    @testSetup static void setup() {
        insert new Account(Name='Test Account');
        insert New Contact(FirstName='Test', LastName='Case', AccountId = [SELECT Id FROM Account LIMIT 1].Id);
    }

    @IsTest
    public static void testSetup() {
        System.assertEquals( true , [SELECT Id FROM Account LIMIT 1].size() > 0, 'One Account should be created in the setup.');
        System.assertEquals( true , [SELECT Id FROM Contact LIMIT 1].size() > 0, 'One Contact should be created in the setup.');
    }

    @IsTest
    public static void testColumnTypes() {
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Name, Phone FROM Account LIMIT 1], testLstFields, true, true);
        System.debug(res);
        System.assertEquals( true , res.containsIgnoreCase('"type":"phone"')
                && res.containsIgnoreCase('"type":"text"'), 'Not the expected column-types returned');
    }

    @isTest
    public static void testFieldOrder() {
        testLstFields.add('Phone');
        testLstFields.add('Name');
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Name, Phone FROM Account LIMIT 1], testLstFields, true, true);
        System.assert(Pattern.matches('(.)*"fieldName":"Phone"(.)*"fieldName":"Name"(.)*', res), 'Returned columns should be in the order of Name then Phone');
    }

    @IsTest
    public static void testHideIdFieldTrue() {
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Id, Name, Phone FROM Account LIMIT 1], testLstFields, true, false);
        System.assertEquals( false , res.containsIgnoreCase('Id'), 'Columns should not contain id field');
    }

    @IsTest
    public static void testHideReferenceFieldTrue() {
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Id, AccountId, Phone FROM Contact LIMIT 1], testLstFields, false, true);
        System.assertEquals( false , res.containsIgnoreCase('Reference'), 'Returned columns should not contain any reference fields');
        System.assertEquals( true , res.containsIgnoreCase('Id'), 'Returned columns should contain the Id field');
    }

    @isTest
    public static void testHideSoftReferenceFields() {
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Name, Phone, OwnerId FROM Account LIMIT 1], testLstFields, false, true);
        System.assert(!res.containsIgnoreCase('OwnerId'), 'Returned columns should not contain any soft reference fields with fieldName ending with "Id__c"');
    }

    @IsTest
    public static void testNumberOfColumns() {
        String res = FlowLightningDatatableCompController.getSObjectColumns([SELECT Name, Phone FROM Account LIMIT 1], testLstFields, false, false);
        System.assertEquals( 3, res.toLowerCase().countMatches('"type":'), 'Not returning the expected number of columns');
    }
}