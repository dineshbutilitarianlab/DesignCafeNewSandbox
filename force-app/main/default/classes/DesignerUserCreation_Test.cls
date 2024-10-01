@isTest
public class DesignerUserCreation_Test {
    @istest
    static void DesignerUsr(){
        Design_User__c du = new Design_User__c();
        du.Salutation__c ='Mr.';
        du.Active__c =true;
        du.Designer_Dashboard_ID__c ='12345678';
        du.Designer_Team__c ='test';
        du.Email__c ='test@g.com';
        du.Experience_Center__c ='MGDC';
        du.Mobile__c ='999999999';
        du.Region__c ='Mumbai';
        du.Role__c ='Inhouse Designer';
        insert du;
        
        List<Design_User__c> desuser=[SELECT Id,Designer_Dashboard_ID__c from Design_User__c WHERE Designer_Dashboard_ID__c = :du.Designer_Dashboard_ID__c];
        if(desuser.size() !=0){
        Design_User__c du1 = new Design_User__c();
        du1.id = desuser[0].id;
        du1.Salutation__c ='Mr.';
        du1.Active__c =true;
        du1.Designer_Dashboard_ID__c ='849584967755';
        du1.Designer_Team__c ='test';
        du1.Email__c ='test@g.com';
        du1.Experience_Center__c ='MGDC';
        du1.Mobile__c ='999999999';
        du1.Region__c ='Mumbai';
        du1.Role__c ='Inhouse Designer';
        update du1;
        }
        String myJSON = '{"salutation":"Mr.","isActive":true,"experience_center":"MGDC","designer_team":"test","email":"test@g.com","name":"DesignUser07","designer_dashboard_ID":"849584967755","role":"Inhouse Designer","mobile":"9099999999","region":"Bengaluru"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dev8-designcafe.cs111.force.com/services/apexrest/designeruser';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        test.startTest();
        DesignerUserCreation.doPost();   
        test.stopTest();
    }   
    @istest
    static void DesignerUsr1(){
        Design_User__c du = new Design_User__c();
        du.Salutation__c ='Mr.';
        du.Active__c =true;
        du.Designer_Dashboard_ID__c ='12345678';
        du.Designer_Team__c ='test';
        du.Email__c ='test@g.com';
        du.Experience_Center__c ='MGDC';
        du.Mobile__c ='999999999';
        du.Region__c ='Mumbai';
        du.Role__c ='Inhouse Designer';
        insert du;
        String myJSON = '{"salutation":"Mr.","isActive":true,"experience_center":"MGDC","designer_team":"test","email":"test@g.com","name":"DesignUser07","designer_dashboard_ID":"849584967755","role":"Inhouse Designer","mobile":"9099999999","region":"Bengaluru"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://dev8-designcafe.cs111.force.com/services/apexrest/designeruser';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        test.startTest();
        DesignerUserCreation.doPost();   
        test.stopTest();
    }       
}