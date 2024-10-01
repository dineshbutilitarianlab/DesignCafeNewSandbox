@isTest
public class quickcilverAPI_Test {
    @isTest 
    public static void testCallServer() { // method to test success COMPLETE status. Check quickcilverAPI_Mockup.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            // quickcilver__c	qc = quickcilver__c.getvalues('quickcilver details');
            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';
            /* cusSet1.Bearer_Token__c = qc.Bearer_Token__c;
            cusSet1.url__c = qc.url__c;
            cusSet1.Consumer_secret__c = qc.Consumer_secret__c; */

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }

    @isTest
    public static void testCallServerBadrequest() { // method to test bad request. Check quickcilverAPI_Mockup_Badrequest.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup_Badrequest());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }

    @isTest
    public static void testCallServerDuplicate() { // method to test bad request. Check quickcilverAPI_Mockup_Duplicate.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup_Duplicate());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testCallServerBlacklist() { // method to test bad request. Check quickcilverAPI_Mockup_Blacklist.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup_Blacklist());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }

    @isTest
    public static void testCallServerRestricted() { // method to test bad request. Check quickcilverAPI_Mockup_Restricted.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup_Restricted());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }

    @isTest
    public static void testCallServerUnavailable() { // method to test bad request. Check quickcilverAPI_Mockup_Unavailable.cls
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            
            CPPortal__c  cuset4= new CPPortal__c();
            cuset4.Name = 'cpportalopportunityupdate';
            cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
            insert cuset4;
            
            Account acc = new Account();
            acc.FirstName = 'test opp';
            acc.LastName ='test opp';
            acc.PersonEmail ='test@test.com';
            acc.PersonMobilePhone ='9000009900';
            acc.ShippingStreet = '7th block kormangala';
            acc.ShippingCity ='Bengaluru';
            acc.ShippingState = 'Karnataka';
            acc.ShippingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.BillingStreet = '7th block kormangala';
            acc.BillingCity ='Bengaluru';
            acc.BillingState = 'Karnataka';
            acc.BillingPostalCode ='560096';
            acc.BillingCountry ='India';
            acc.GST_No__c ='06BZAHM6385P6Z2';
            acc.PAN__c ='ASDFG1234M';
            insert acc;
            System.debug('Test Class Account: ' + acc);
        
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.id;
            opp.Name = 'test opp';
            opp.StageName = 'Closed Won';
            opp.CloseDate = System.today();
            opp.Project_Name__c = 'Test opp';
            opp.Amount = 100;
            opp.Meeting_Type__c = 'EC';
            opp.Meeting_Venue__c = 'MGDC';
            opp.Update_Booking_Form__c = true; // has a validation rule
            insert opp;
            System.debug('Test Class Opportunity: ' + opp);

            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Bearer_Token__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb25zdW1lcklkIjoiMTk4IiwiZXhwIjoxNjQzNjE4ODgzLCJ0b2tlbiI6ImRmYTQxODY5Y2VlMzQ0ODc5MzhmZTQ3ODA0MmNiMTA3In0.e6cRnNE87EqK455jyNoNWILno_xvsB3kRL3nm5-WB_A';
            cusSet1.url__c = 'https://sandbox.woohoo.in/oauth2/';
            cusSet1.Consumer_secret__c = '6935b3a44920a833def29070f0abb327';

            cusSet1.Token_Date__c = System.today();
            insert cusSet1;

            String secretKeyValue = cusSet1.Consumer_secret__c;
            String absApiUrl = 'https://sandbox.woohoo.in/rest/v3/orders';
            String reqMethod = 'POST';		// A - for order api
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            
            // Below custom setting data was needed becuase it was used in Class.DC_Webengageupdate.Callout and was being triggered
            DCWebengage__c  cusSet2 = new DCWebengage__c();
            cusSet2.Name = 'Dcwebengage';
            cusSet2.BearerToken__c = 'd94b11b4-cca4-4b68-8e0f-77a1c28e6bb9';
            cusSet2.url__c = 'https://api.webengage.com/v1/accounts/aa131ca9/users';
            insert cusSet2; 

            Opportunity oppdata =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity limit 1];
        
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            jsonBody = JSON.serialize(result);	// E
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            Date tokenDate = System.today(); 
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverAPI_Mockup_Unavailable());
            quickcilverAPI.callServer(opp.id);
            Test.stopTest();
        }
    }
}