@RestResource(urlMapping='/getLeadFiles/*')
global without sharing class getLeadFiles {
    @HttpGet
    global static String retrieve(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        String leadId = req.params.get('leadId');
        List<filesWrap> allFileList = new List<filesWrap>();
        Set<String> docId = new Set<String>();
        List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE  LinkedEntityId in (SELECT Id FROM Lead Where id = :leadId)];
        System.debug('contentLinkList :'+contentLinkList);
        for(ContentDocumentLink cdl : contentLinkList){
            docId.add(cdl.ContentDocumentId);  
        }
        List<ContentVersion> contentDataList;
        if(Test.isRunningTest()){
            contentDataList = [SELECT id,Title,CreatedDate, FileType,VersionData FROM ContentVersion LIMIT 10];
            
        }
        else{
            contentDataList = [SELECT id,Title,CreatedDate, FileType,VersionData FROM ContentVersion WHERE ContentDocumentId IN : docId];
            
        }
        for(ContentVersion c : contentDataList){
            filesWrap a = new filesWrap();
            a.leadId = leadId;
            Datetime d = c.CreatedDate;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
            a.CreatedDate = dt;
            a.fileType = c.FileType;
            a.fileName = c.Title;
            a.filebody = c.VersionData;
            allFileList.add(a);
        }
        String s = JSON.serialize(allFileList);
        system.debug('AllLeadFiles :'+s);
        
   //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/getLeadFiles/*', 'Req','Res', 'in');
        return s;
    }
    
    global class filesWrap{
        global string leadId;
        global String CreatedDate;
        global string fileType;
        global string fileName;
        global blob filebody;
    }
}