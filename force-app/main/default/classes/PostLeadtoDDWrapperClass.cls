/*
* Code Creator  : Munna Shaik
* Created Date  : 09 DEC 2021
* Code Modifier : V-Fory Team
* Modified Date : 21th December 2021
* Modified By   : Munna Shaik
*/
public class PostLeadtoDDWrapperClass {
    public String id;
    public String approxBudget;
    public String email;
    public String leadOwnerMobile;
    public String requestType;
    public String city;
    public String convertedOpportunityId;
    public Datetime createdDate;
    public String customerAddress;
    public Date meetingScheduleOn;
    public String designTeamName;
    public String description;
    public String designer;
    public Boolean designerAssigned;
    public String designerName;
    public String leadStage;
    public String leadStatus;
    public String meetingType;
    public String meetingVenue;
    public String name;
    public String phoneNumber;
    public String salesOwner;
    public String broadcastStatus;
    public Datetime dateAndTimeOfMeetingScheduled;
    public RequirementDetailsWrap requirementDetails;
    public MoreDetailsWrap moreDetails;
    public LifeStyleWrap lifeStyle;
    public class RequirementDetailsWrap {
        public String propertyType;
        public String scopeOfWork;
        public String floorArea;
        public String siteServices;
        public String siteServicesNeededFor;
        public String interiorWorkNeededFor;
        public String interiorDetails;
        public String propertyUsage;
        public String floorPlan;
        public String whereAreYouCurrentlyLocated;
        public String whenWouldYouLikeToHaveTheHomeReady;
        public String whichLanguageAreYouMostComfortableIn;
        public String ifOtherLanguagesPleaseSpecify;
    }     
    public class LifeStyleWrap {
        public String live;
        public String OthersForLive;
        public String work;
        public String eat;
        public String play;
        public String OthersForPlay;
    }   
    public class MoreDetailsWrap {
        public String whoWillBeStayingInTheHouse;
        public String HowManyKidsDoYouHave;
        public String genderOfKids;
        public String ageOfKids;
        public String tellUsMoreAboutYourPet;
    }   
  /*   public class leadDDDataListWrap{
        public PostLeadtoDDWrapperClass DDData{get;set;}
    }  */
}