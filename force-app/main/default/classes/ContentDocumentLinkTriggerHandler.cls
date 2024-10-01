/*
Created By : Ankit
Description :  To Handle all action fromContentDocumentLinkTrigger
*/
public class ContentDocumentLinkTriggerHandler {
    public static Boolean skipTrigger = false;
    
    //To share the file of quote to Account in order to show files on community for community user.
    public static void createCDLforAccount(List<ContentDocumentLink> cdlList){    
        
        Map<Id, List<ContentDocumentLink>> quoteToCDLsMap = new Map<Id, List<ContentDocumentLink>>();
        Map<Id, ContentVersion> cdlToCvMap = new Map<Id, ContentVersion>();
        Set<Id> cdIds = new Set<Id>();       
        List<ContentDocumentLink> cdlsToInsert  = new List<ContentDocumentLink>();
        List<Quote> notifyQuote  = new List<Quote>();
        Map<Id, Quote> quoteMap = NULL;
        
        if(cdlList != NULL && cdlList.size() >0)
            for(ContentDocumentLink cdl : cdlList){
                String id = cdl.LinkedEntityId;
                
                if (id.substring(0,3) == '0Q0'){ 
                    
                    cdIds.add(cdl.ContentDocumentId);
                    System.debug('cdIds>>'+ cdIds);
                    if(quoteToCDLsMap.get(id) != NULL){
                        quoteToCDLsMap.get(id).add(cdl);
                    }else{
                        quoteToCDLsMap.Put(id, new List<ContentDocumentLink>{cdl});
                    }                    
                } 
            }
        
        if(quoteToCDLsMap != NULL && quoteToCDLsMap.keySet() != null && quoteToCDLsMap.keySet().size() > 0){
            quoteMap = new Map<Id, Quote>([SELECT Id, AccountId FROM Quote WHERE Id In :quoteToCDLsMap.keySet()]);
            
            if(quoteMap != NULL && quoteMap.keySet()!= NULL && quoteMap.keySet().size()>0)
            {            
                for(ContentVersion cv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN : cdIds]){
                    cdlToCvMap.put(cv.ContentDocumentId, cv);
                }
                
                for(Quote q : quoteMap.values()){
                    /*
29/01/2020: Trishagni
Description: the Send_Notification_to_Customer__c value is set to true in line 47 for triggering the WF rule: DC – New Quote Notification to Customer
*/
                    q.Send_Notification_to_Customer__c=true;
                    notifyQuote.add(q);
                    System.debug('QuoteVal q.Send_Notification_to_Customer__c'+q.Send_Notification_to_Customer__c);
                    if(q.AccountId != NULL){ 
                        for(ContentDocumentLink cdl1 : quoteToCDLsMap.get(q.Id)){
                            System.debug(cdlToCvMap + '>>>' + q.AccountId + '>>>');
                            
                            cdlsToInsert.add(new ContentDocumentLink(ContentDocumentId= cdlToCvMap.get(cdl1.ContentDocumentId).ContentDocumentId, LinkedEntityId = q.AccountId, ShareType = 'V', Visibility = 'AllUsers'));
                        }                                       
                    }
                    System.debug('QuoteVal q.Send_Notification_to_Customer__c 1'+q.Send_Notification_to_Customer__c);
                }
                //System.debug('QuoteVal q.Send_Notification_to_Customer__c'+q.Send_Notification_to_Customer__c);
                
                try{
                    if(cdlsToInsert != NULL && cdlsToInsert.size()>0){
                        insert cdlsToInsert;
                        upsert notifyQuote;
                    }
                }catch(Exception e){
                    System.debug('Exception :: '+ e.getStackTraceString());
                }
            }
        }    
    }
    
    public static void preventFileuploadforFinance(List<ContentDocumentLink> cdlList) {
        User currentuser = [select Id,Profile.name from user where id=: UserInfo.getUserId() ];
        if(currentuser.Profile.name != Null && currentuser.Profile.name == 'Finance'){
            for(ContentDocumentLink cdLink :cdlList ){
                system.debug('cdLink'+cdLink);
                cdLink.addError('Not allowed to upload');
                
            }
        }
        
    }
    
}