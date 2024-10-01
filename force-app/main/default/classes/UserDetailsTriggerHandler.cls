public class UserDetailsTriggerHandler {
    
    public static void handleAfterInsertOrUpdate(List<User_Details__c> newUserDetails, Map<Id, User_Details__c> oldUserDetailsMap) {
        
        List<Region_Group_Member__c> regionGroupMembersToInsert = new List<Region_Group_Member__c>();
        List<Region_Group_Member__c> regionGroupMembersToDelete = new List<Region_Group_Member__c>();
        List<EC_Members__c> meetingScheduleMembersToInsert = new List<EC_Members__c>();
        List<EC_Members__c> meetingScheduleMembersToDelete = new List<EC_Members__c>();
        
        Set<String> regionValues = new Set<String>();
        Set<String> meetingScheduleValues = new Set<String>();
        
        for (User_Details__c userDetail : newUserDetails) {
            if (userDetail.Region__c != null) {
                regionValues.add(userDetail.Region__c);
            }
            if (userDetail.User_EC__c != null) {
                meetingScheduleValues.add(userDetail.User_EC__c);
            }
        }
        
        Map<String, Id> regionToRegionGroupMap = new Map<String, Id>();
        if (!regionValues.isEmpty()) {
            List<Region_Group__c> regionGroupList = [SELECT Id, Name FROM Region_Group__c WHERE Name IN :regionValues];
            for (Region_Group__c regionGroup : regionGroupList) {
                regionToRegionGroupMap.put(regionGroup.Name, regionGroup.Id);
            }
        }
        
        Map<String, Id> meetingToMeetingGroupMap = new Map<String, Id>();
        if (!meetingScheduleValues.isEmpty()) {
            List<Meeting_Schedule_RR__c> meetingScheduleList = [SELECT Id, Name FROM Meeting_Schedule_RR__c WHERE Name IN :meetingScheduleValues];
            for (Meeting_Schedule_RR__c meetingSchedule : meetingScheduleList) {
                meetingToMeetingGroupMap.put(meetingSchedule.Name, meetingSchedule.Id);
            }
        }
        
        User_Details__c userDetail = newUserDetails[0];
        User_Details__c oldUserDetail = oldUserDetailsMap != null ? oldUserDetailsMap.get(userDetail.Id) : null;
        
        if(userDetail.Include_in_Region_Group__c == false){
            if (oldUserDetail != null && oldUserDetail.Region__c != null) {
                List<Region_Group_Member__c> oldRegionGroupMembers = [SELECT Id FROM Region_Group_Member__c WHERE User_Details__c = :userDetail.Id ];
                
                if (!oldRegionGroupMembers.isEmpty()) {
                    regionGroupMembersToDelete.addAll(oldRegionGroupMembers);
                }
            }
        }
        
        
        if(userDetail.Include_in_Region_Group__c == true){
            if (userDetail.Region__c != null && regionToRegionGroupMap.containsKey(userDetail.Region__c)) {
                List<Region_Group_Member__c> existingRegionGroupMembers = [SELECT Id FROM Region_Group_Member__c WHERE User_Details__c = :userDetail.Id AND Region_Group__c = :regionToRegionGroupMap.get(userDetail.Region__c)];
                if (existingRegionGroupMembers.isEmpty()) {
                    regionGroupMembersToInsert.add(new Region_Group_Member__c(
                        User_Details__c = userDetail.Id,
                        Region_Group__c = regionToRegionGroupMap.get(userDetail.Region__c)
                    ));
                }
            }
        }
        
        
        if(userDetail.Include_in_MS_RR__c == false){
            
            
            if (oldUserDetail != null && oldUserDetail.User_EC__c != null) {
                List<EC_Members__c> oldMeetingScheduleMembers = [SELECT Id FROM EC_Members__c WHERE User_Details__c = :userDetail.Id];
                system.debug('oldMeetingScheduleMembers'+oldMeetingScheduleMembers);
                if (!oldMeetingScheduleMembers.isEmpty()) {
                    meetingScheduleMembersToDelete.addAll(oldMeetingScheduleMembers);
                }
            }
        }
        
        if(userDetail.Include_in_MS_RR__c == true){
            
            if (userDetail.User_EC__c != null && meetingToMeetingGroupMap.containsKey(userDetail.User_EC__c)) {
                List<EC_Members__c> existingMeetingScheduleMembers = [SELECT Id FROM EC_Members__c WHERE User_Details__c = :userDetail.Id AND Meeting_Schedule_RR__c = :meetingToMeetingGroupMap.get(userDetail.User_EC__c)];
                if (existingMeetingScheduleMembers.isEmpty()) {
                    meetingScheduleMembersToInsert.add(new EC_Members__c(
                        User_Details__c = userDetail.Id,
                        Meeting_Schedule_RR__c = meetingToMeetingGroupMap.get(userDetail.User_EC__c)
                    ));
                }
            }
        }
        
                
        if (!regionGroupMembersToDelete.isEmpty()) {
            delete regionGroupMembersToDelete;
        }
        
        if (!meetingScheduleMembersToDelete.isEmpty()) {
            delete meetingScheduleMembersToDelete;
        }
        
        if (!regionGroupMembersToInsert.isEmpty()) {
            insert regionGroupMembersToInsert;
        }
        
        if (!meetingScheduleMembersToInsert.isEmpty()) {
            insert meetingScheduleMembersToInsert;
        }
    }
}