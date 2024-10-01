public class Meetingscheduled {
    public class leadDataWrap{
        public string approxBudget{get;set;}
        public string homeType{get;set;}
        public string fullName{get;set;}
        public string MeetingType{get;set;}
        public string MeetingVenue{get;set;}
        public string scopeOfWork{get;set;}
        public string phoneNumber{get;set;}
        public string email{get;set;}
        public string ownerId{get;set;}
        public datetime meetingScheduleDateAndTime{get;set;}
        public string propertyPossessionStatus{get;set;}
        public date propertyPossessionDate{get;set;}
        public string propertyAddress{get;set;}
        public string interiorWorkNeededFor{get;set;}
        public string ECLocation{get;set;}
        public string requirementDetails{get;set;}
        Public string id{get;set;}
        public boolean WhatsapOptin{get;set;}
        Public string floorArea{get;set;}
        Public string siteServices{get;set;}
        Public string siteServicesNeededFor{get;set;}
        Public string propertyUsage{get;set;}
        Public string currentLocation{get;set;}
        Public string homeReadyTime{get;set;}
        Public string languageComfortableIn{get;set;}
        Public string otherLanguage{get;set;}
        Public string whoWillBestayingInHouse{get;set;}
        Public string genderOfFirstKid{get;set;}
        Public string genderOfSecondKid{get;set;}
        Public string genderOfThirdKid{get;set;}
        Public string genderOfFourthKid{get;set;}
        Public string ageOfFirstKid{get;set;}
        Public string ageOfSecondKid{get;set;}
        Public string ageOfThirdKid{get;set;}
        Public string ageOfFourthKid{get;set;}
        Public string noOfKids{get;set;}
        Public string TellUsMoreAboutYourPet{get;set;}
        Public string live{get;set;}
        Public string OthersForLive{get;set;}    
        Public string work{get;set;}
        Public string eat{get;set;}
        Public string play{get;set;}
        Public string OthersForPlay{get;set;}
    }
    public class responsedata{
        public string code;
        public string message;
    }
    @future(callout=true)
    @AuraEnabled
    public static void callServer(String id){
        Lead ld = [Select id,Name,Whatsapp_Opt_IN__c,Meeting_Type__c,Meeting_Venue__c,MobilePhone,EC_Location__c,Propertyaddress__c,Email,OwnerId,
                   Willingness_For_Meeting__c,MS_Date_Time__c,Approx_Budget__c,Property_Possession_Status__c,Property_Possession_Date__c,
                   Address,Home_Type__c,Interior_work_needed_for__c,Requirement_Details__c,Scope_Of_Work__c,Floor_Area__c,Civil_Work__c,
                   Site_Service_Needed_for__c,Property_Usage__c,Where_are_you_currently_located__c,When_would_you_like_to_have_the_home__c,
                   Which_language_are_you_most_comfortable__c,If_other_languages_please_specify__c,Who_will_be_staying_in_the_house__c,
                   How_many_kids_do_you_have__c,Gender_of_First_kid__c,Gender_of_Second_kid__c,Gender_of_Third_kid__c,Gender_of_Fourth_kid__c,
                   Age_of_First_kid__c,Age_of_Second_kid__c,Age_of_Third_kid__c,Age_of_Fourth_kid__c,Do_you_have_pets__c,Live__c,Others_for_Live__c,
                   Work__c,Eat__c,Play__c,Others_for_Play__c from Lead Where id=: id limit 1];
        
        leadDataWrap leaddata = new leadDataWrap();
        leaddata.id = ld.id;
        if(ld.Approx_Budget__c !=null){
            leaddata.approxBudget = ld.Approx_Budget__c;
        }
        if(ld.Home_Type__c != null){
            leaddata.homeType = ld.Home_Type__c;
        }
        if(ld.Name !=null){
            leaddata.fullName = ld.Name;
        }
        if(ld.Meeting_Type__c !=null){
            leaddata.MeetingType = ld.Meeting_Type__c;
        }
        if(ld.Meeting_Venue__c !=null){
            leaddata.MeetingVenue = ld.Meeting_Venue__c;
        }
        if(ld.Scope_Of_Work__c !=null){
            leaddata.scopeOfWork = ld.Scope_Of_Work__c;
        }
        if(ld.MobilePhone !=null){
            leaddata.phoneNumber = ld.MobilePhone;
        }
        if(ld.Email !=null){
            leaddata.email = ld.Email;
        }
        if(ld.ownerId !=null){
            leaddata.ownerId = ld.ownerId;
        }
        if(ld.Willingness_For_Meeting__c !=null){
            leaddata.meetingScheduleDateAndTime = ld.Willingness_For_Meeting__c;
        }
        if(ld.EC_Location__c !=null){
            leaddata.ECLocation = ld.EC_Location__c;
        }
        if(ld.Property_Possession_Status__c !=null){
            leaddata.propertyPossessionStatus = ld.Property_Possession_Status__c;
        }
        if(ld.Property_Possession_Date__c !=null){
            leaddata.propertyPossessionDate = ld.Property_Possession_Date__c;
        }
        if(ld.Propertyaddress__c !=null){
            leaddata.propertyAddress = ld.Propertyaddress__c;
        }
        if(ld.Interior_work_needed_for__c !=null){
            leaddata.interiorWorkNeededFor = ld.Interior_work_needed_for__c;
        }
        if(ld.Requirement_Details__c !=null){
            leaddata.requirementDetails = ld.Requirement_Details__c;
        }
        if(ld.Whatsapp_Opt_IN__c !=null){
            leaddata.WhatsapOptin = ld.Whatsapp_Opt_IN__c;
        }
        //================================================================
        if(ld.Floor_Area__c !=null){
            leaddata.floorArea = ld.Floor_Area__c;
        }
        if(ld.Civil_Work__c == true){
            leaddata.siteServices = 'Yes';
        }else{
            leaddata.siteServices = 'No';
        }
        if(ld.Site_Service_Needed_for__c !=null){
            leaddata.siteServicesNeededFor = ld.Site_Service_Needed_for__c;
        }
        if(ld.Property_Usage__c !=null){
            leaddata.propertyUsage = ld.Property_Usage__c;
        }
        if(ld.Where_are_you_currently_located__c !=null){
            leaddata.currentLocation = ld.Where_are_you_currently_located__c;
        }
        if(ld.When_would_you_like_to_have_the_home__c !=null){
            leaddata.homeReadyTime = ld.When_would_you_like_to_have_the_home__c;
        }
        if(ld.Which_language_are_you_most_comfortable__c !=null){
            leaddata.languageComfortableIn = ld.Which_language_are_you_most_comfortable__c;
        }
        if(ld.If_other_languages_please_specify__c !=null){
            leaddata.otherLanguage = ld.If_other_languages_please_specify__c;
        }
        if(ld.Who_will_be_staying_in_the_house__c !=null){
            leaddata.whoWillBestayingInHouse = ld.Who_will_be_staying_in_the_house__c;
        }
        if(ld.Gender_of_First_kid__c !=null){
            leaddata.genderOfFirstKid = ld.Gender_of_First_kid__c;
        }
        if(ld.Gender_of_Second_kid__c !=null){
            leaddata.genderOfSecondKid = ld.Gender_of_Second_kid__c;
        }
        if(ld.Gender_of_Third_kid__c !=null){
            leaddata.genderOfThirdKid = ld.Gender_of_Third_kid__c;
        }
        if(ld.Gender_of_Fourth_kid__c !=null){
            leaddata.genderOfFourthKid = ld.Gender_of_Fourth_kid__c;
        }
        if(ld.Age_of_First_kid__c !=null){
            leaddata.ageOfFirstKid = ld.Age_of_First_kid__c;
        }
        if(ld.Age_of_Second_kid__c !=null){
            leaddata.ageOfSecondKid = ld.Age_of_Second_kid__c;
        }
        if(ld.Age_of_Third_kid__c !=null){
            leaddata.ageOfThirdKid = ld.Age_of_Third_kid__c;
        }
        if(ld.Age_of_Fourth_kid__c !=null){
            leaddata.ageOfFourthKid = ld.Age_of_Fourth_kid__c;
        }
        if(ld.How_many_kids_do_you_have__c !=null){
            leaddata.noOfKids = ld.How_many_kids_do_you_have__c;
        }
        if(ld.Do_you_have_pets__c != null){
            leaddata.TellUsMoreAboutYourPet = ld.Do_you_have_pets__c;
        }
        if(ld.Live__c !=null){
            leaddata.live = ld.Live__c;
        }
        if(ld.Others_for_Live__c !=null){
            leaddata.OthersForLive = ld.Others_for_Live__c;
        }
         if(ld.Work__c !=null){
            leaddata.work = ld.Work__c;
        }
        if(ld.Eat__c != null){
            leaddata.eat = ld.Eat__c;
        }
        if(ld.Play__c !=null){
            leaddata.play = ld.Play__c;
        }
        if(ld.Others_for_Play__c !=null){
            leaddata.OthersForPlay = ld.Others_for_Play__c;
        }
        system.debug('Json Serialize : '+JSON.serialize(leaddata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.Meeting_Schedule_API);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(leaddata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
    }
}