/*
*Created By     : 
*Created Date   : 06/01/2020
*Description    : Test Coverage For "ContentDocumentLinkTriggerHandler"
*Class Name     : ContentDocumentLinkTriggerHandler
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class ContentDocumentLinkTriggerHandler_Test {

   @isTest
    static void ContentDocumentLinkTriggerHandler_UnitTest(){
        Account acc = new Account(name='test acc');
        insert acc;
        Contact con = new Contact(lastname='test cont',accountid=acc.id);
        insert con;
        Opportunity opp = new Opportunity(name='testoppty',AccountId=acc.id,stageName='Qualification',closedate=system.today());
        insert opp;
        
        Quote testQuote = new Quote();
              testQuote.Name='SampleQuote';
              testQuote.OpportunityId = opp.Id;
              insert testQuote;
        
        ContentVersion content=new ContentVersion(); 
            content.Title='Header_Picture1'; 
            content.PathOnClient ='/' + content.Title + '.jpg'; 
            Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData = bodyBlob; 
            //content.LinkedEntityId = sub.id;
            content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = testQuote.id;
            contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
            contentlink.ShareType = 'V';
        insert contentlink;
        
     Test.startTest();
        List<ContentDocumentLink>  listOfContDoc = new List<ContentDocumentLink>();
        ContentDocumentLinkTriggerHandler contDocsTrigg = New ContentDocumentLinkTriggerHandler();
        ContentDocumentLinkTriggerHandler.createCDLforAccount(listOfContDoc);
    Test.stopTest();
    }
}