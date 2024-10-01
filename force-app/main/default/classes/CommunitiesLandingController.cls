/**
* An apex page controller that takes the user to the right start page based on credentials or lack thereof
*/
public with sharing class CommunitiesLandingController {
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        system.debug('user'+UserInfo.getUserId());
        
        User currentuser = [SELECT Id, AccountId FROM User where id =: UserInfo.getUserId() limit 1];
        List<Milestone1_Project__c>  currlist = new List<Milestone1_Project__c>([select Id,Customer__c from Milestone1_Project__c where Customer__c =: currentuser.AccountId limit 1]);

        if(currlist.size() > 0){
            return new PageReference(Label.community_landing_page + '/Customer/s/milestone1-project/' + currlist[0].Id);
        }
        else {
            return Network.communitiesLanding();   
        }
    }
    
    public CommunitiesLandingController() {
        
    }
}