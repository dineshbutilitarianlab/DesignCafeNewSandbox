@istest 
public class test_QuoteLCS {
          @istest
   public Static void Quote_Lcs(){
       
       Test.startTest();
       
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
         DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
      
  
  
        Account accA =new Account(Name='Demo');
        insert accA ; 
      	Design_User__c du= new Design_User__c(Name = 'Demo1',
                                            Email__c= 'test2@gmail.com',
                                           Designer_Dashboard_ID__c='test1234',
                                           Role__c='Inhouse Designer');
       	insert du;
       	Lead leadId = new Lead();
       
        Opportunity opp = new Opportunity(Name='test opp',
                                          StageName='stage',
                                          Amount =1000000,
                                          CloseDate = system.today(),
                                          Update_Booking_Form__c =true, 
                                          AccountId = accA.Id ,
                                          Probability = 95);
        insert opp;
        
        Quote Q = New Quote(Name='Test Quote', 
                            OpportunityId=opp.Id, 
                            Oppty_Customer_email__c='test2@gmail.com', 
                            Latest_Quote__c = true,
                            Status = 'Needs Review',
                            Quote_Link__c = '',
                            Proposal_PDF__c ='',
                            Site_Services_PDF__c='', 
                            oppty_Designer_Email_add__c= 'test1@gmail.com',
                           Modular_Discount__c= 7.00,
                           Site_Services_Discount__c=8.00
                           );
        insert Q;
            
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=q.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
    
        insert contentlink;
       
             Quote_Lcs.sendemailtemplate(Q.id);
        Test.stopTest();
        
    }
    
              @istest
   public Static void Quote_Lcs1(){
       
       Test.startTest();
       
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
         DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
  
        Account accA =new Account(Name='Demo');
        insert accA ; 
      Design_User__c du= new Design_User__c(Name = 'Demo1',
                                            Email__c= 'test2@gmail.com',
                                           Designer_Dashboard_ID__c='test1234',
                                           Role__c='Inhouse Designer');
       insert du;
       
        Opportunity opp = new Opportunity(Name='test opp',
                                          StageName='stage',
                                          Amount =1000000,
                                          CloseDate = system.today(),
                                          Update_Booking_Form__c =true, 
                                          AccountId = accA.Id ,
                                          Probability = 95);
        insert opp;
        
        Quote Q = New Quote(Name='Test Quote', 
                            OpportunityId=opp.Id, 
                            Oppty_Customer_email__c='test2@gmail.com', 
                            Latest_Quote__c = true,
                            Status = 'Approved',
                            Quote_Link__c = '',
                            Proposal_PDF__c ='',
                            Site_Services_PDF__c='', 
                            oppty_Designer_Email_add__c= 'test1@gmail.com',
                           Modular_Discount__c= 7.00,
                           Site_Services_Discount__c=8.00
                           );
        insert Q;
       
       Quote Q1 = New Quote(Name='Test Quote2', 
                            OpportunityId=opp.Id, 
                            Oppty_Customer_email__c='test2@gmail.com', 
                            Latest_Quote__c = true,
                            Status = 'Approved',
                            Quote_Link__c = '',
                            Proposal_PDF__c ='',
                            Site_Services_PDF__c='', 
                            oppty_Designer_Email_add__c= 'test1@gmail.com',
                           Modular_Discount__c= 7.00,
                           Site_Services_Discount__c=8.00
                           );
        insert Q1;
            
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=q.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
    
        insert contentlink;
       
             Quote_Lcs.sendemailtemplate(Q.id);
        Test.stopTest();
        
    }
    
}