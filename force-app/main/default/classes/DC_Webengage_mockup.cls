global class DC_Webengage_mockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        Lead leadins = [Select id,Name,Email,Home_Type__c,Project_Name__c,Source__c,Meeting_Type__c,Meeting_Venue__c,Scope_Of_Work__c,Property_Type__c,Call_Stage__c,DC_Lead_Status__c,Channel__c,Property_Possession_Date__c,City,Designer_Name__c from Lead];
        DC_Webengage.leadDataWrap ld = new DC_Webengage.leadDataWrap();
        Leadins.Project_Name__c='Awdhesh test';
        Leadins.Property_Type__c='0';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Scope_Of_Work__c='Home interiors';
        Leadins.Interior_work_needed_for__c='Living Room';
        Leadins.Requirement_Details__c='Wardrobes';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        leadins.FirstName = 'testeasy';
        leadins.Email='imtiyaz043@dc.com';
        leadins.City= 'Bengaluru';
        //leadins.APIMOBILE__c= '9080908012';
        leadins.CMM_Name__c='Harsh Gangwal';
        leadins.Meeting_Type__c = 'EC';
        leadins.Meeting_Venue__c= 'MGDC';
        //ld.Property_Address__c =' Mysore road Bengaluru';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(ld));
        response.setStatusCode(200);
        return response;
    }
}