@IsTest
public class CallyzerAPIBacthTest {
    @testSetup
    static void setupMethod(){
        CallyzerAPIDetails__c cs = new CallyzerAPIDetails__c(
            Name = 'CallyzerDetails',
            Mobile__c = '9731450211',
            Start_Time__c = system.Now(),
            End_Time__c = system.Now()+5,
            Access_Token__c = '543be4d7-c10d-40a9-b541-34197acf9ba5',
            Callyzer_Url__c = 'https://api1.callyzer.co/admin/api/call/callHistory',
            Execution_Date__c = Date.today(),
            Normal_Flow__c = true,
            Duration__c = 30, // Replace with appropriate duration value
            No_Of_Execution__c = 1 // Replace with appropriate number
        );
        insert cs;
        TriggerControl__c tc = new TriggerControl__c();
        tc.Name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc;
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Sales Executive' LIMIT 1]; // Change profile name as per your requirement
        List<User> testUsers = new List<User>();
        User user1 = new User(alias = 'test8009', email='test8009@gmail.com',
                              emailencodingkey='UTF-8', lastname='Siddique Shariff', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = testProfile.Id, country='United States',IsActive =true,
                              timezonesidkey='America/Los_Angeles', username='test8009@noemail.com', MobilePhone='9731450211');    
        insert user1;
        /*
for (Integer i = 0; i < 5; i++) { // Create 5 test users
User u = new User(
ProfileId = testProfile.Id,
Username = 'testuser' + i + '@example.com', // Customize the username as needed
Email = 'testuser' + i + '@example.com',
LastName = 'Test' + i,
FirstName = 'User' + i,
MobilePhone = '8949936701' + i // Sample mobile number
// Add other required fields based on your needs
);
testUsers.add(u);
}*/
        // insert testUsers;
        Lead leadRec = new Lead();
        leadRec.Approx_Budget__c = '3L to 5L';
        leadRec.DC_Campaign_Source__c = 'Direct';
        leadRec.Channel__c = 'Online';
        leadRec.Civil_Work__c = true;
        leadRec.Country_Code__c = '+91';
        leadRec.LastName = 'Test web';
        leadRec.Source__c = 'Direct';
        leadRec.Meeting_Type__c = 'EC';
        leadRec.Meeting_Venue__c = 'WDC';
        leadRec.Messaging_Source__c = 'Chat';
        leadRec.MobilePhone  = '9003014201';
        leadRec.Page_URL__c = 'https://www.designcafe.com';
        leadRec.Property_Possession_Date__c = date.parse('24/11/2022');
        leadRec.Property_Possession_Status__c = 'Property due - next month';
        leadRec.Property_Type_For_Interior__c = 'Flat';
        leadRec.Region__c = 'Bengaluru';
        leadRec.Scope_Of_Work__c = 'Renovation';
        leadRec.Source_Journey__c = 'https://www.designcafe.com';
        leadRec.Whatsapp_Opt_IN__c = false;
        leadRec.YMUrl__c = 'https://www.designcafe.com';
        leadRec.city =  'Bengaluru';
        insert leadRec;		
        // Mock HTTP callout response
        // String mockResponseBody = '{"data": [{"employee": "Siddique Shariff (9731450211)","employeeName": "Siddiqu Shariff","employeeNumber": "9731450211","employeeCode": "DC-01333","client": "Unknown (+91-9003014201)","clientName": "Unknown","countryCode": "91","clientNumber": "9003014201","date": "29 Dec 2023","time": "03:14 PM","duration": null,"durationInSeconds": 0,"callType": "Outgoing","note": null,"callRecordingPath": null,"uniqueId": " -R7tMPUvHk7Sr5vEoitaITex3bGxIvQ2EojsZEQiCbI","createdDate": "2023-12-29 15:15:44","modifiedDate": null}],"message": null,"recordsTotal": 1,"recordsFiltered": 1,"srNoCounterStart": 0}';
        
        //HttpResponse mockResponse = CallyzerMockHttpResponseGenerator.generateMockHttpResponse(mockResponseBody);
        
    }
    @IsTest
    static void testBatchExecution() {
        // Create test data for CallyzerAPIDetails__c (replace with your custom settings data)
        
        Test.startTest();
        // Execute the batch
        Test.setMock(HttpCalloutMock.class, new CallyzerMockHttpResponseGenerator());
        CallyzerAPIBacth batchClassInstance = new CallyzerAPIBacth();
        Database.executeBatch(batchClassInstance);
        Test.stopTest();
        
        // Perform assertions to validate batch execution and expected outcomes
        // Add assertions based on the expected behavior of your batch class
        // For example, check if the expected number of records was processed or if errors were handled correctly
    }
    
    @IsTest
    static void testBatchExecution1() {
        
        CallyzerAPIDetails__c cs = new CallyzerAPIDetails__c(
            Name = 'CallyzerDetails',
            Mobile__c = '9731450211',
            Start_Time__c = system.Now(),
            End_Time__c = system.Now()+5,
            Access_Token__c = '543be4d7-c10d-40a9-b541-34197acf9ba5',
            Callyzer_Url__c = 'https://api1.callyzer.co/admin/api/call/callHistory',
            Execution_Date__c = Date.today() + 1,
            Normal_Flow__c = false,
            Duration__c = 30, // Replace with appropriate duration value
            No_Of_Execution__c = 1 // Replace with appropriate number
        );
        insert cs;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CallyzerMockHttpResponseGenerator());
        CallyzerAPIBacth batchClassInstance = new CallyzerAPIBacth();
        Database.executeBatch(batchClassInstance);
        Test.stopTest();
        
    }
    
    
}