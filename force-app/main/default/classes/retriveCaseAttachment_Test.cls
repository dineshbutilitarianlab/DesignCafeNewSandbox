@isTest
public class retriveCaseAttachment_Test {
    public static testmethod void callmethod(){
        Case c = new Case();
        c.Subject = 'Test Sub';
        insert c;
        
        ContentVersion attach=new ContentVersion();
        attach.ContentLocation ='S';
        attach.Title = 'fileName';
        attach.PathOnClient = 'fileName';
        attach.VersionData  = EncodingUtil.base64Decode('JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4');
        insert attach;
        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
        
        ContentDocumentLink DocLink = new ContentDocumentLink();
        DocLink.ContentDocumentId = Versid;
        docLink.ShareType='V';
        DocLink.LinkedEntityId = c.id;
        DocLink.Visibility='AllUsers';
        insert DocLink;
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        request.addParameter('caseId', c.id);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Test.startTest();
        retriveCaseAttachment.retrive();
        Test.stopTest();
        
    }
    
}