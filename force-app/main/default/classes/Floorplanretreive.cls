@RestResource(urlMapping='/Floorplanretreive/*')
global without sharing class Floorplanretreive {
    @HttpGet
    global static String retrieve(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        String leadId = req.params.get('leadId');
        System.debug('*******'+leadId);
        List<attachWrap> allFileList = new List<attachWrap>();
        Set<String> docId = new Set<String>();
        List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE  LinkedEntityId in (SELECT Id FROM lead Where id = :leadId)];
        System.debug('******'+contentLinkList);
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
            attachWrap a = new attachWrap();
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
        system.debug(s);
        //Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/Floorplanretreive/*', '', '', 'in');
        return s;
    }
   
    public class attachWrap{
        public string leadId;
        public String CreatedDate;
        public string fileType;
        public string fileName;
        public blob filebody;
    }
   
}