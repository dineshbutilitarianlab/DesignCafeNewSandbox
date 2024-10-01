/*
* Code Creator  : Azar
* Created Date  : 09 JUNE 2020
* Code Modifier : V-Fory Team
* Modified Date : 21th December 2021
* Modified By   : Munna Shaik
*/
public class PostLeadToDesignerDashboard {  
    @future(callout=true)
    public static void callServer(String id){
        Lead ld = [Select id,name,Approx_Budget__c,Broadcast_Status__c,Email,Lead_Owner_Mobile__c,Design_User_Name__c,Region__c,City,Designer_ID_Portal__c,
                   Propertyaddress__c,ConvertedOpportunityId,CreatedDate,Address,Date_When_Meeting_is_Scheduled__c,Willingness_For_Meeting__c,
                   Designer_Team_Name__c,Home_Type__c,Requirement_Details__c,Interior_work_needed_for__c,Scope_Of_Work__c,Description,Designer__c,
                   Designer_Name__c,Is_Designer_Assigned__c,Status,DC_Lead_Status__c,Meeting_Type__c,Meeting_Venue__c,Floor_Plan_Link_from_Chatbot__c,
                   MobilePhone,Lead_Owner_Name__c,Where_are_you_currently_located__c,When_would_you_like_to_have_the_home__c,
                   Which_language_are_you_most_comfortable__c,If_other_languages_please_specify__c,Who_will_be_staying_in_the_house__c,
                   How_many_kids_do_you_have__c,Gender_of_First_kid__c,Gender_of_Second_kid__c,Gender_of_Third_kid__c,Gender_of_Fourth_kid__c,
                   Age_of_First_kid__c,Age_of_Second_kid__c,Age_of_Third_kid__c,Age_of_Fourth_kid__c,Do_you_have_pets__c,Live__c,Others_for_Live__c,
                   Work__c,Eat__c,Play__c,Others_for_Play__c,Floor_Area__c,Civil_Work__c,Site_Service_Needed_for__c,Property_Usage__c from Lead Where id=: id limit 1];
        
        PostLeadtoDDWrapperClass leaddata = new PostLeadtoDDWrapperClass();
        leaddata.id = ld.id;
        if(ld.Approx_Budget__c !=null){
            leaddata.approxBudget = ld.Approx_Budget__c;
        }
        if(ld.Region__c !=null){
            leaddata.city = ld.Region__c;
        }
        if(ld.ConvertedOpportunityId !=null){
            leaddata.convertedOpportunityId = ld.ConvertedOpportunityId;
        }
        if(ld.Email !=null){
            leaddata.email = ld.Email;
        }
        if(ld.Lead_Owner_Mobile__c !=null){
            leaddata.leadOwnerMobile = ld.Lead_Owner_Mobile__c;
        }
        if(ld.Broadcast_Status__c !=null){
            leaddata.broadcastStatus = ld.Broadcast_Status__c;
        }
        if(ld.DC_Lead_Status__c !=null && ld.DC_Lead_Status__c =='Meeting Scheduled'){
            leaddata.requestType = 'insert';
        }
        if(ld.DC_Lead_Status__c !=null && ld.DC_Lead_Status__c =='Meeting Done'){
            leaddata.requestType = 'update';
        }
        if(ld.DC_Lead_Status__c !=null && ld.DC_Lead_Status__c =='Junk'){
            leaddata.requestType = 'update';
        }
        if(ld.Status !=null && ld.Status =='Converted'){
            leaddata.requestType = 'update';
        }
        if(ld.CreatedDate !=null){
            leaddata.createdDate = ld.CreatedDate;
        }
        if(ld.Address !=null){
            leaddata.customerAddress = ld.Propertyaddress__c;
        }
        if(ld.Willingness_For_Meeting__c !=null){
            leaddata.dateAndTimeOfMeetingScheduled = ld.Willingness_For_Meeting__c;
        }
        if(ld.Date_When_Meeting_is_Scheduled__c !=null){
            leaddata.meetingScheduleOn = ld.Date_When_Meeting_is_Scheduled__c;
        }
        if(ld.Designer_Team_Name__c !=null){
            leaddata.designTeamName = ld.Designer_Team_Name__c;
        }
        if(ld.Description !=null){
            leaddata.description = ld.Description;
        }
        if(ld.Designer_ID_Portal__c !=null){
            leaddata.designer = ld.Designer_ID_Portal__c;
        }
        if(ld.Is_Designer_Assigned__c !=null){
            leaddata.designerAssigned = ld.Is_Designer_Assigned__c;
        }
        if(ld.Design_User_Name__c !=null){
            leaddata.designerName = ld.Design_User_Name__c;
        }
        if(ld.Status !=null){
            leaddata.leadStage = ld.Status;
        }
        if(ld.DC_Lead_Status__c !=null){
            leaddata.leadStatus = ld.DC_Lead_Status__c;
        }
        if(ld.Meeting_Type__c !=null){
            leaddata.meetingType = ld.Meeting_Type__c;
        }
        if(ld.Meeting_Venue__c !=null){
            leaddata.meetingVenue = ld.Meeting_Venue__c;
        }
        if(ld.Name !=null){
            leaddata.name = ld.Name;
        }
        if(ld.MobilePhone !=null){
            leaddata.phoneNumber = ld.MobilePhone;
        }
        if(ld.Lead_Owner_Name__c !=null){
            leaddata.salesOwner = ld.Lead_Owner_Name__c;
        }
        
        PostLeadtoDDWrapperClass.RequirementDetailsWrap rd = new PostLeadtoDDWrapperClass.RequirementDetailsWrap();
        rd.propertyType = ld.Home_Type__c;
        rd.scopeOfWork = ld.Scope_Of_Work__c;
        rd.floorArea = ld.Floor_Area__c;
        if(ld.Civil_Work__c == true){
             rd.siteServices = 'Yes';
        }else{
             rd.siteServices = 'No';
        }
     //   rd.siteServices = ld.Civil_Work__c;
        rd.siteServicesNeededFor = ld.Site_Service_Needed_for__c;
        rd.interiorWorkNeededFor = ld.Interior_work_needed_for__c;
        rd.interiorDetails = ld.Requirement_Details__c;
        rd.propertyUsage = ld.Property_Usage__c;
        rd.floorPlan = ld.Floor_Plan_Link_from_Chatbot__c;
        rd.whereAreYouCurrentlyLocated = ld.Where_are_you_currently_located__c;
        rd.whenWouldYouLikeToHaveTheHomeReady = ld.When_would_you_like_to_have_the_home__c;
        rd.whichLanguageAreYouMostComfortableIn = ld.Which_language_are_you_most_comfortable__c;
        rd.ifOtherLanguagesPleaseSpecify = ld.If_other_languages_please_specify__c;
        
        leaddata.requirementDetails = rd;
        
        PostLeadtoDDWrapperClass.LifeStyleWrap md = new PostLeadtoDDWrapperClass.LifeStyleWrap();
        md.live = ld.Live__c;
        md.OthersForLive = ld.Others_for_Live__c;
        md.work = ld.Work__c;
        md.eat = ld.Eat__c;
        md.play = ld.Play__c;
        md.OthersForPlay = ld.Others_for_Play__c;
        
        leaddata.lifeStyle = md;
        
        PostLeadtoDDWrapperClass.MoreDetailsWrap ms = new PostLeadtoDDWrapperClass.MoreDetailsWrap();
        ms.whoWillBeStayingInTheHouse = ld.Who_will_be_staying_in_the_house__c;
        ms.HowManyKidsDoYouHave = ld.How_many_kids_do_you_have__c;
        if(ld.Gender_of_First_kid__c!= null && ld.Gender_of_Second_kid__c!= null && ld.Gender_of_Third_kid__c!=null && ld.Gender_of_Fourth_kid__c!=null){
            ms.genderOfKids = ld.Gender_of_First_kid__c +';'+ ld.Gender_of_Second_kid__c +';'+ ld.Gender_of_Third_kid__c +';'+ ld.Gender_of_Fourth_kid__c;
        }else if(ld.Gender_of_First_kid__c!= null && ld.Gender_of_Second_kid__c!= null && ld.Gender_of_Third_kid__c!=null && ld.Gender_of_Fourth_kid__c == null){
            ms.genderOfKids = ld.Gender_of_First_kid__c +';'+ ld.Gender_of_Second_kid__c +';'+ ld.Gender_of_Third_kid__c;
        }else if(ld.Gender_of_First_kid__c!= null && ld.Gender_of_Second_kid__c!= null && ld.Gender_of_Third_kid__c==null && ld.Gender_of_Fourth_kid__c == null){
            ms.genderOfKids = ld.Gender_of_First_kid__c +';'+ ld.Gender_of_Second_kid__c;
        }else if(ld.Gender_of_First_kid__c!= null && ld.Gender_of_Second_kid__c== null && ld.Gender_of_Third_kid__c==null && ld.Gender_of_Fourth_kid__c == null){
            ms.genderOfKids = ld.Gender_of_First_kid__c;
        }
        
        if(ld.Age_of_First_kid__c!=null && ld.Age_of_Second_kid__c!=null && ld.Age_of_Third_kid__c!=null && ld.Age_of_Fourth_kid__c!=null){
            ms.ageOfKids = ld.Age_of_First_kid__c +';'+ ld.Age_of_Second_kid__c +';'+ ld.Age_of_Third_kid__c +';'+ ld.Age_of_Fourth_kid__c;
        }else if(ld.Age_of_First_kid__c!=null && ld.Age_of_Second_kid__c!=null && ld.Age_of_Third_kid__c!=null && ld.Age_of_Fourth_kid__c==null){
            ms.ageOfKids = ld.Age_of_First_kid__c +';'+ ld.Age_of_Second_kid__c +';'+ ld.Age_of_Third_kid__c;
        }else if(ld.Age_of_First_kid__c!=null && ld.Age_of_Second_kid__c!=null && ld.Age_of_Third_kid__c==null && ld.Age_of_Fourth_kid__c==null){
            ms.ageOfKids = ld.Age_of_First_kid__c +';'+ ld.Age_of_Second_kid__c;
        }else if(ld.Age_of_First_kid__c!=null && ld.Age_of_Second_kid__c==null && ld.Age_of_Third_kid__c==null && ld.Age_of_Fourth_kid__c==null){
            ms.ageOfKids = ld.Age_of_First_kid__c;
        }
        if(ld.Do_you_have_pets__c !=null){
            ms.tellUsMoreAboutYourPet = ld.Do_you_have_pets__c;
        }else{
             ms.tellUsMoreAboutYourPet = null;
        }
             
        leaddata.moreDetails = ms;
        
        String customLabelValue = Label.PostLeadToDD;
        
        //  PostLeadtoDDWrapperClass.leadDDDataListWrap  v = new PostLeadtoDDWrapperClass.leadDDDataListWrap();
        //  v.DDData = leaddata;
        //  system.debug(JSON.serialize(v));
        
        //  system.debug('Json Serialize : '+JSON.serialize(v));
        system.debug('Json Serialize : '+JSON.serialize(leaddata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000);
        //     String jsonBody = JSON.serialize(v);
        String jsonBody = JSON.serialize(leaddata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        
        Http http = new Http();
        if(!test.isRunningTest()){
            HttpResponse res = http.send(request);
            system.debug('resbody'+res.getBody());
        }          
    }
}