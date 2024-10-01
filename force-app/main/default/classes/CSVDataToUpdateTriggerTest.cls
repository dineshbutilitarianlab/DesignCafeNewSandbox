@isTest
public class CSVDataToUpdateTriggerTest {
    
    @isTest
    private static void csvupdate(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Designer' LIMIT 1];
        list<user> listofusers  = new List<user>();
        User usr1= new User(LastName = 'testonelastname',
                            FirstName='testonefirstname',
                            Alias = 'testone',
                            Email = 'testonelastname@gmail.com',
                            Username = 'testonelastname@gmail.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        listofusers.add(usr1);
        
        User usr2 = new User(LastName = 'testtwolastname',
                             FirstName='testtwofirst',
                             Alias = 'testtwo',
                             Email = 'testtwolastname@gmail.com',
                             Username = 'testtwolastname@gmai.com',
                             ProfileId = profileId.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        
        listofusers.add(usr2);
        
        insert listofusers;
        
        
       /* List<Milestone1_Project__c> projectList = new List<Milestone1_Project__c>();
        Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('Milestone_Project');
        
        project.Deadline__c = System.today()+50;
        projectList.add(project);
        
        Milestone1_Project__c project1 = Milestone1_Test_Utility.sampleProject('Milestone_Template');
        project1.Deadline__c = System.today()+50;
        projectList.add(project1);
        
        
        insert projectList;*/
        
        List<CSVDataToUpdate__c> listofcsvtoupdate = new List<CSVDataToUpdate__c>();
        CSVDataToUpdate__c newcsvdata = new CSVDataToUpdate__c();
        newcsvdata.Customer_Name__c='custname';
        newcsvdata.Customer_email__c='test@gmail.com';
        //newcsvdata.Designer__c=projectList[0].Designer__c;
        newcsvdata.Designer_email_ID__c='testonelastname@gmail.com';
        //newcsvdata.Project__c=projectList[0].id;
        listofcsvtoupdate.add(newcsvdata);
        
        CSVDataToUpdate__c newcsvdata1 = new CSVDataToUpdate__c();
        newcsvdata1.Customer_Name__c='custname1';
        newcsvdata1.Customer_email__c='test@gmail1.com';
        //newcsvdata1.Designer__c=projectList[1].Designer__c;
        newcsvdata1.Designer_email_ID__c='testtwolastname@gmail.com';
        //newcsvdata1.Project__c=projectList[1].id;
        listofcsvtoupdate.add(newcsvdata1);
        
        insert listofcsvtoupdate;
        
    }
    
    
}