@isTest
public class UserDetailsTriggerHandlerTest {

    @isTest
    static void testHandleAfterInsertOrUpdate() {
        
        
        Region_Group__c regionGroup1 = new Region_Group__c(Name = 'Bengaluru');
        Region_Group__c regionGroup2 = new Region_Group__c(Name = 'Mumbai');
        insert new List<Region_Group__c>{regionGroup1, regionGroup2};
        
        Meeting_Schedule_RR__c meetingSchedule1 = new Meeting_Schedule_RR__c(Name = 'Mumbai DC');
        Meeting_Schedule_RR__c meetingSchedule2 = new Meeting_Schedule_RR__c(Name = 'HSRDC');
        insert new List<Meeting_Schedule_RR__c>{meetingSchedule1, meetingSchedule2};
        
        User_Details__c userDetail1 = new User_Details__c(
            Name = 'User 1',
            Region__c = 'Mumbai',
            User_EC__c = 'Mumbai DC',
            Role__c = 'Administrator',
            Email__c = 'test@gmail.com',
            Include_in_Region_Group__c = true,
            Include_in_MS_RR__c = true
        );
        
        User_Details__c userDetail2 = new User_Details__c(
            Name = 'User 2',
            Region__c = 'Bengaluru',
            User_EC__c = 'HSRDC',
            Role__c = 'Administrator',
            Email__c = 'test@gmail.com',
            Include_in_Region_Group__c = true,
            Include_in_MS_RR__c = true
        );
        
        insert new List<User_Details__c>{userDetail1, userDetail2};
        
        userDetail1.Include_in_Region_Group__c = false;
        userDetail1.Include_in_MS_RR__c = false;
        update userDetail1;
        
        List<Region_Group_Member__c> regionGroupMembers = [SELECT Id, User_Details__c, Region_Group__c FROM Region_Group_Member__c WHERE User_Details__c IN :new List<Id>{userDetail1.Id, userDetail2.Id}];
        System.assertEquals(0, regionGroupMembers.size(), 'Region Group Members should be empty after update.');
        
        List<EC_Members__c> meetingScheduleMembers = [SELECT Id, User_Details__c, Meeting_Schedule_RR__c FROM EC_Members__c WHERE User_Details__c IN :new List<Id>{userDetail1.Id, userDetail2.Id}];
        System.assertEquals(0, meetingScheduleMembers.size(), 'Meeting Schedule Members should be empty after update.');
        
        delete new List<Region_Group__c>{regionGroup1, regionGroup2};
        delete new List<Meeting_Schedule_RR__c>{meetingSchedule1, meetingSchedule2};
        delete new List<User_Details__c>{userDetail1, userDetail2};
    }
}