@istest(seealldata = false)
public class Test_LeadActivityBatchClass {
    
    @istest Static void LeadActivityCls(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
         DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
      String CRON_EXP = '0 0 0 ? * *';
         
   //   List<Lead>ldlist =[SELECT Id,Delay_in_response__c,Status,DC_Lead_Status__c,Lead_Response_time_by_SM__c FROM Lead];
         
        Lead ld = new Lead();
        ld.LastName                    = 'Priya';
        ld.Status                      = 'Meeting Scheduled';
        ld.City                        = 'Bengaluru';
        ld.MobilePhone                 = '9888888899';
        ld.Email                       = 'priya@gmail.com';
        ld.Channel__c                 = 'Online';
        ld.IsConverted                 = false;
        ld.Follow_Up_Date_Time__c      = system.today()+5;
        ld.Property_Possession_Date__c = date.today();
        ld.Region__c                   =ld.City;
        ld.Approx_Budget__c            = '2L to 3L';
        ld.Meeting_Venue__c            ='HSRDC';
        ld.Meeting_Type__c             ='EC';
        ld.Willingness_For_Meeting__c  = date.today().addDays(5);
        ld.DC_Lead_Status__c           = 'Meeting Scheduled';
        ld.Delay_in_response__c        = true;
        ld.Lead_Allocation_time_to_SM__c = system.today();
 //       ld.Lead_Response_time_by_SM__c   = System.now();
        insert ld;
      
        
        test.startTest();
        
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LeadActivityBatchClass());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered); 
        
        test.stopTest();
        
        SchedulableContext sc = null;
        LeadActivityBatchClass LABC = new LeadActivityBatchClass();
        
        Task tk = new Task();
        tk.Disposition_Type__c ='wert';
        tk.Subject             ='Call';
        insert tk;
        

        }
     }