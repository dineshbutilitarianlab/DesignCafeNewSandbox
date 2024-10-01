/*
*Created By     : 
*Created Date   : 06/01/2020
*Description    : Test Coverage For "FileCardAccess class"
*Class Name     : FileCardAccess
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@isTest
public class FileCardAccess_Test {
    
    @isTest
    private static void accessFileWithoutNote(){
		UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CMM' Limit 1];

		User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and isactive = true Limit 1];

		adminUser.UserRoleId = userRole.Id;
		update adminUser;
        system.runas(adminUser){
            Id p = [select id from profile where name='Customer Community User'].id;
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;  
        //UserRole r = [select id from userRole where name = 'CMM'] ;
       // insert r;
        User user = new User(alias = 'Test', email='test12345@test.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='India',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='Asia/Kolkata', username=System.now().millisecond() + 'test12345@test.com');
        
        insert user;
        
        ID AccID  = [Select AccountID from Contact where id =: User.ContactId].AccountId;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'TestDocumentQuote';
        cv.PathOnClient = 'TestDocumentQuote.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        insert cv;
        
        
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = AccID;
        cdl.ContentDocumentId = cdList[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        //Get Content Version
        List<ContentDocument> conDoc = FileCardAccess.accessFiles(user.id);
        System.assertEquals(conDoc.size(), 1);
        }
    }
}