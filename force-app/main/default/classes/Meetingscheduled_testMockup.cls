global class Meetingscheduled_testMockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        Lead l = [Select id,Name,Whatsapp_Opt_IN__c,Meeting_Type__c,Meeting_Venue__c,MobilePhone,EC_Location__c,Propertyaddress__c,Email,OwnerId,Willingness_For_Meeting__c,Approx_Budget__c,Property_Possession_Status__c,Property_Possession_Date__c,Address,Home_Type__c,Interior_work_needed_for__c,Requirement_Details__c,Scope_Of_Work__c from Lead ];
        Meetingscheduled.leadDataWrap ld = new Meetingscheduled.leadDataWrap();
        ld.fullName ='test';
        ld.approxBudget='2L to 3L';
        ld.propertyAddress = 'kormangala,Bengaluru';
        ld.meetingScheduleDateAndTime = System.now();
        ld.homeType=l.Home_Type__c;
        ld.interiorWorkNeededFor='';
        ld.propertyPossessionStatus='';
        ld.id=l.id;
        ld.fullName=l.Name;
        ld.phoneNumber=l.MobilePhone;
        ld.requirementDetails=l.Requirement_Details__c;
        ld.scopeOfWork=l.Scope_Of_Work__c;
        ld.meetingType ='EC';
        ld.meetingVenue='MGDC';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(ld));
        response.setStatusCode(200);
        return response;
    }
}