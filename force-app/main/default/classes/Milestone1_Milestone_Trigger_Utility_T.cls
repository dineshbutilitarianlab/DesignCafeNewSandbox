@isTest
private class Milestone1_Milestone_Trigger_Utility_T {
    
    @testSetup static void createData(){
        Test.startTest();
            // Create project
            List<Milestone1_Project__c> projectList = new List<Milestone1_Project__c>();
            Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('Milestone_Project');
            
            project.Deadline__c = System.today()+50;
            projectList.add(project);
            
            Milestone1_Project__c project1 = Milestone1_Test_Utility.sampleProject('Milestone_Template');
            project1.Deadline__c = System.today()+50;
            projectList.add(project1);  

            insert projectList;
        Test.stopTest();
                    
    }
    
    @isTest
    private static void handleUpdateCustomerOnPAInsert(){
        List<Milestone1_Project__c> projectList = new List<Milestone1_Project__c>();
        projectList = [SELECT Id, Name FROM Milestone1_Project__c LIMIT 2];
        
        // Create parent milestones
        List<Milestone1_Milestone__c> mileStonesList = new List<Milestone1_Milestone__c>();
        
        for(Integer i = 0; i < 10; i++){
            Milestone1_Milestone__c mileStone = new Milestone1_Milestone__c();
            mileStone = Milestone1_Test_Utility.sampleMilestone(projectList[0].Id, null, 'My Parent Milestone ' + i) ; 
            mileStone.Kickoff__c = System.today();
            mileStone.Deadline__c = System.today()+10;          
            mileStone.Actual_Completion_Date__c = System.today()+28;
            mileStonesList.add(mileStone);
        }
        Test.startTest();

            insert mileStonesList;
            Milestone1_Milestone__c  childMileStone = Milestone1_Test_Utility.sampleMilestone(projectList[0].Id, null, 'My Child Milestone 1');
            childMileStone.Parent_Milestone__c = mileStonesList[0].Id;
            childMileStone.Kickoff__c = System.today();
            childMileStone.Deadline__c = System.today()+10;     
            childMileStone.Actual_Completion_Date__c = System.today()+28;
            insert childMileStone;
        
        Test.stopTest();
        
        mileStonesList[0].Kickoff__c = System.today()+10;
        mileStonesList[0].Deadline__c = System.today()+20;  
        mileStonesList[0].Actual_Completion_Date__c = System.today()+38;
        
        Database.update(mileStonesList,false);

        Milestone1_Milestone_Trigger_Utility.checkAccessRightReferences((List<Sobject>)projectList,'Id','Milestone1_Project__Share', UserInfo.getUserId(), 'Test' );
        Milestone1_Milestone_Trigger_Utility.milestonePermissions('Milestone1_Milestone__c');
        Set<Id> tempId = new Set<Id>();
        tempId.add(mileStonesList[0].Id);
        Milestone1_Milestone_Trigger_Utility.updateMilestones(tempId);
        Milestone1_Milestone_Trigger_Utility.batchUpdateMilestones(tempId);
        
        Database.delete(mileStonesList,false);
    
    }
    
    @isTest
    private static void callMileStoneBatch(){
        List<Milestone1_Project__c> projectList  = [SELECT Id, Name FROM Milestone1_Project__c LIMIT 2];
        
        Test.startTest();
            Set<Id> tempId = new Set<Id>();
            tempId.add(projectList[0].Id);
            Milestone1_Milestone_Trigger_Utility.batchUpdateProjects(tempId);
        Test.stopTest();    
    
    }   
}