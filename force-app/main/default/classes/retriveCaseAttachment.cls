@RestResource(urlMapping='/retriveAttachment/*')
global without sharing class retriveCaseAttachment {
    @HttpGet
    global static String retrive(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        String caseId = req.params.get('caseId');
        System.debug('*******'+caseId);
        List<attachWrap> allFileList = new List<attachWrap>();
        Set<String> docId = new Set<String>();
        List<ContentDocumentLink> contentLinkList = [Select Id, LinkedEntityId, LinkedEntity.name, ContentDocumentId , ContentDocument.title from ContentDocumentLink WHERE  LinkedEntityId in (SELECT Id FROM Case Where id = :caseId)];
        System.debug('******'+contentLinkList);
        for(ContentDocumentLink cdl : contentLinkList){
            docId.add(cdl.ContentDocumentId);  
        }
        List<ContentVersion> contentDataList = [SELECT id,Title, FileType,VersionData FROM ContentVersion WHERE ContentDocumentId IN : docId];
        System.debug('*******'+contentDataList);
        for(ContentVersion c : contentDataList){
            attachWrap a = new attachWrap();
            a.caseId = caseId;
            a.fileType = c.FileType;
            a.fileName = c.Title;
            a.filebody = c.VersionData;
            allFileList.add(a);
        }
        System.debug('****'+allFileList);
        
        //Api Call Logger
        ApiCallLogger.method(system.UserInfo.getUserId(),'/retriveAttachment/*', 'req','Res', 'in');
        return JSON.serialize(allFileList);
        
    }
    
    public class attachWrap{
        public string caseId;
        public string fileType;
        public string fileName;
        public blob filebody;
    }
    
}