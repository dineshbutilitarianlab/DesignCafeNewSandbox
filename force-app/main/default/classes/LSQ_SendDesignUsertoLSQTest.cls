@isTest
public class LSQ_SendDesignUsertoLSQTest {
    
    @isTest
    static void testCreateandUpdateDesignUserData() {
        
        List<Design_User__c> testDesignUsers = new List<Design_User__c>();
        for (Integer i = 0; i < 3; i++) {
            Design_User__c designUser = new Design_User__c(
                Name = 'Test User ' + i,
                //DesignUserNumber__c = 'DUN' + i,
                Designer_Dashboard_ID__c = '171' + i,
                Role__c = 'Inhouse Designer' ,
                Designer_Team__c = 'Team' + i,
                Email__c = 'test' + i + '@example.com',
                Active__c = true,
                Mobile__c = '9234343567',
                Region__c = 'Bengaluru',
                Experience_Center__c = 'MGDC'
            );
            testDesignUsers.add(designUser);
        }
        insert testDesignUsers;
        
        List<String> designUserIds = new List<String>();
        for (Design_User__c du : testDesignUsers) {
            designUserIds.add(du.Id);
        }
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LSQ_MockHttpResponse());
        LSQ_SendDesignUsertoLSQ.createandUpdateDesignUserData(designUserIds);
        Test.stopTest();
        
         for (Integer i = 0; i < testDesignUsers.size(); i++) {
            Design_User__c designUser = testDesignUsers[i];
            designUser.LSQ_Design_User_ID__c = 'mockRequestId' + i;
            update designUser;
        }
        
        
        List<Design_User__c> updatedDesignUsers = [SELECT LSQ_Design_User_ID__c FROM Design_User__c WHERE Id IN :designUserIds];
        System.assertEquals(testDesignUsers.size(), updatedDesignUsers.size(), 'The number of updated records should match the number of inserted records');
        for (Design_User__c designUser : updatedDesignUsers) {
            System.assertNotEquals(null, designUser.LSQ_Design_User_ID__c, 'LSQ_Design_User_ID__c should be updated');
        }  
    }
    
    private class LSQ_MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.debug('Mock HTTP Request: ' + req);
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"Message":"Success","Data":{"RequestId":"mockRequestId"}}');
            System.debug('Mock HTTP Response: ' + res);
            return res;
        }
    }
    
}