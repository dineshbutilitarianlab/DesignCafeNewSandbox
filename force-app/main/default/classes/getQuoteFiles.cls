@RestResource(urlMapping='/getQuoteFiles/*')
global without sharing class getQuoteFiles {
    @HttpGet
    global static String retrieve(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        String QuoteId = req.params.get('QuoteId');
        List<attachWrap> allFileList = new List<attachWrap>();
        Set<String> docId = new Set<String>();
        List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE  LinkedEntityId in (SELECT Id FROM Quote Where id = :QuoteId)];
        for(ContentDocumentLink cdl : contentLinkList){
            docId.add(cdl.ContentDocumentId);  
        }
List<ContentVersion> contentDataList;
        if(Test.isRunningTest()){
            contentDataList = [SELECT id,Title,CreatedDate, FileType,VersionData FROM ContentVersion LIMIT 10];
            
        }
        else{
            contentDataList = [SELECT id,Title,CreatedDate, FileType,VersionData FROM ContentVersion WHERE ContentDocumentId IN : docId];
            
        }        for(ContentVersion c : contentDataList){
            attachWrap a = new attachWrap();
            a.QuoteId = QuoteId;
            Datetime d = c.CreatedDate;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
            a.CreatedDate = dt;          
            a.fileType = c.FileType;
            a.fileName = c.Title;
            a.filebody = c.VersionData;
            allFileList.add(a);
        }
        String s = JSON.serialize(allFileList);
        //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(), '/getQuoteFiles/*', 'REQ', 'RES', 'in');
        return s;
    }
    
    public class attachWrap{
        public string QuoteId;
        public String CreatedDate;
        public string fileType;
        public string fileName;
        public blob filebody;
    }
    
}