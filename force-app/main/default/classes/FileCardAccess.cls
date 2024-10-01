/*
Developer : Ranveer Singh  
Created Date :  3rd Jan 2020
Description : Controller file of a FileCardsCmp Lightning Component.     
*/

public with sharing class FileCardAccess {
    
    // This Method will access the files of the current logged-In Customer for the purpose of the lightning component to display the downloadable it. 
    @AuraEnabled
    public static  List<ContentDocument> accessFiles(Id currentUserId){
        List<ContentDocument> quoteOnlyAttachmentList = new List<ContentDocument>();
        User loggedInUser = [SELECT Id, ContactId, AccountId FROM User WHERE Id = : currentUserId];
        
        if(loggedInUser != null){
            set<string> setOfDocId = new set<string>();
            for(ContentDocumentLink link : [SELECT Id,ContentDocumentId,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =:loggedInUser.AccountId]){
                setOfDocId.add(link.ContentDocumentId);
            }
            if(!setOfDocId.isEmpty()){
                List<ContentDocument> cdList =  [SELECT Id, Title, FileType, ContentSize,LatestPublishedVersionId  FROM ContentDocument where id in:setOfDocId ];
                for(ContentDocument cd : cdList){                    
                    if(cd.FileType != 'SNOTE')
                    {               
                       // if(((cd.Title).containsIgnoreCase('quote'))){
                            quoteOnlyAttachmentList.add(cd);
                        //}
                    }
                }                
                return quoteOnlyAttachmentList;                
            }
        }
        return null;
    }
}