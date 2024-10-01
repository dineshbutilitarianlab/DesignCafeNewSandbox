public class UserAfterInsert extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        User [] newList = (List<User>) tp.newList;
        UserTriggerHelper.addToPublicGroup(newList);
        
        if(newList.size() == 1) {
            try {
                Application_Settings__c lSetting1 = Application_Settings__c.getValues('SEND_COMMUNITY_PASSWORD_EMAIL');
                
                if(lSetting1 == null || String.isBlank(lSetting1.Value__c) || lSetting1.Value__c.equalsIgnoreCase('true')) {
        			CustomerCommunityUserUtility.sendCommunityUserWelcomeEmail(newList[0]);
                }
            }
            catch(Exception e) {}
        }
    }
}