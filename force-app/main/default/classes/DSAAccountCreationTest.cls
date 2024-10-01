@istest
global class DSAAccountCreationTest{
    static testmethod void testPost() {
        Account acc =new Account();
        acc.FirstName='Test';
        acc.LastName='Account';
        acc.PersonMobilePhone ='9876543211';
        acc.BillingPostalCode='430056';
        acc.BillingStreet='Mahatma Gandhi Road';
        acc.ShippingState='Karnataka';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.ShippingPostalCode='430056';
        acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingStreet='Mahatma Gandhi Road';
        acc.BillingCity='Bengaluru';
        acc.ShippingCity='Bengaluru';
        acc.PAN__c = 'AAAAA1234W';
        acc.Customer_type__c = 'B2C';
        acc.Converted_Lead_ID__c='ASDFG5678JHG';
        acc.IsInvoiceGenerated__c=true;
        acc.Customer_created_on_Odoo__c  =true;
        insert acc;
    
        DSAAccountCreation.DetailsWrap Account = new DSAAccountCreation.DetailsWrap();
        Account.name=  Acc.name;
        Account.email = Acc.Acc_Email__c;
        Account.mobileNumber = acc.Phone;
        Account.NoRelationship = acc.NoRelationship__c;
        Account.TnCAggreed = acc.TCAgreed__c;
        Account.region = acc.Region__c;
        DSAAccountCreation.AddressWrap Addr = new DSAAccountCreation.AddressWrap();
        Addr.city = Acc.BillingCity;
        Addr.country = Acc.BillingCountry;
        Addr.state = Acc.BillingState;
        Addr.street = Acc.BillingStreet;
        Addr.zipcode = Acc.BillingPostalCode;
        Account.address = Addr;
        List<DSAAccountCreation.DocumentWrap> doclist1 = new List<DSAAccountCreation.DocumentWrap>();
        DSAAccountCreation.DocumentWrap doc1 = new DSAAccountCreation.DocumentWrap();
        doc1.Content_Type ='pdf';
        doc1.data = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4';
        doc1.fileName = 'test';
        doclist1.add(doc1);
        Account.documents= doclist1;
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(Account));
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestContext.response = RestResponse;
        Test.startTest();
        DSAAccountCreation.doPost();
        Test.stopTest();
        
    }
    static testMethod void testPost1() {
        
        DSAAccountCreation.DetailsWrap Account1 = new DSAAccountCreation.DetailsWrap();
        Account1.name= 'test';
        Account1.email = 'test@test.in';
        Account1.mobileNumber = '9090989098';
        Account1.NoRelationship = true;
        Account1.TnCAggreed = true;
        Account1.region = 'Bengaluru';
        
        DSAAccountCreation.AddressWrap Addr = new DSAAccountCreation.AddressWrap();
        Addr.city = 'Bengaluru';
        Addr.country = 'India';
        Addr.state = 'Karnataka';
        Addr.street = 'Marathalli';
        Addr.zipcode = '560037';
        Account1.address = Addr;
        List<DSAAccountCreation.DocumentWrap> doclist = new List<DSAAccountCreation.DocumentWrap>();
        DSAAccountCreation.DocumentWrap doc = new DSAAccountCreation.DocumentWrap();
        doc.Content_Type ='pdf';
        doc.data = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4';
        doc.fileName = 'test';
        doclist.add(doc);
        Account1.documents= doclist;
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(Account1));
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestContext.response = RestResponse;
        Test.startTest();
        DSAAccountCreation.doPost();
        Test.stopTest();        
    }   
}