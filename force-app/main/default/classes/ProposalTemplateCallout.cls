public class ProposalTemplateCallout {
    @future(callout=true)
    public static void sendProposalTemplateCalloutREST(Id CvId){
        
        YM_Invoice_Proposal_Template_Notify__c data1 = YM_Invoice_Proposal_Template_Notify__c.getvalues('proposalinteriorpdftemplate');
        YM_Invoice_Proposal_Template_Notify__c data3 = YM_Invoice_Proposal_Template_Notify__c.getvalues('proposalcivilpdftemplate');
        YM_Invoice_Proposal_Template_Notify__c data4 = YM_Invoice_Proposal_Template_Notify__c.getvalues('proposalpptpdftemplate');
        YM_Invoice_Proposal_Template_Notify__c data2 = YM_Invoice_Proposal_Template_Notify__c.getvalues('hardcodedfileds');
        
        ContentVersion contentDataList = [SELECT id,Title,FileType,VersionData,FirstPublishLocationId,WhatsApp_Int_Proposal__c,WhatsApp_Civil_Proposal__c,Whatsapp_PPT__c,ContentDocumentId FROM ContentVersion WHERE Id =: CvId];
        Set<String> docId = new Set<String>();
        docId.add(contentDataList.ContentDocumentId);  
        list<ContentDocumentLink> contentLinkList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE  ContentDocumentId =: docId];
        Id oppId;
        for(ContentDocumentLink cdl:contentLinkList){
            if(string.valueof(cdl.LinkedEntityId).substring(0,3) =='006'){
              oppId =   cdl.LinkedEntityId;
            }
        }
        opportunity opportunitydata;
        If(!Test.isRunningTest()){
             if(oppId != null)
            opportunitydata = [Select id,Name,Owner.name,Whatsapp_Opt_IN__c,Owner.Mobilephone,account.name,account.MobileYM__c,account.Whatsapp_Opt_IN__c,MobileYM__c from Opportunity where id=: oppId];
        }
        else{
            try{
                opportunitydata = [Select id,Name,Owner.name,Whatsapp_Opt_IN__c,Owner.Mobilephone,account.name,account.MobileYM__c,account.Whatsapp_Opt_IN__c,MobileYM__c from Opportunity LIMIT 1];
            }catch(Exception e){
                opportunitydata = new opportunity();
            }
        }  
     //   opportunity opportunitydata = [Select id,Name,Owner.name,Whatsapp_Opt_IN__c,Owner.Mobilephone,account.name,account.MobileYM__c,account.Whatsapp_Opt_IN__c,MobileYM__c from Opportunity where id=: oppId];
       if(opportunitydata != null){
        if(opportunitydata.account.Whatsapp_Opt_IN__c == true){
            proposalpdftemplateWrapper template = new proposalpdftemplateWrapper();
            proposalpdftemplateWrapper.body TempBody = new proposalpdftemplateWrapper.body();
            proposalpdftemplateWrapper.language lang = new proposalpdftemplateWrapper.language();
            proposalpdftemplateWrapper.template temp = new proposalpdftemplateWrapper.template();
            list<proposalpdftemplateWrapper.components> compList = new list<proposalpdftemplateWrapper.components>();
            proposalpdftemplateWrapper.document doc = new proposalpdftemplateWrapper.document();
            
            try{
                if(contentDataList.WhatsApp_Int_Proposal__c == true){
                    template.type = data2.type__c;
                    template.mime = data2.mime__c;
                    template.file = encodingutil.base64Encode(contentDataList.VersionData);
                    lang.code = data1.code__c;
                    lang.policy = data1.policy__c;
                    temp.name = data1.name__c;
                    temp.namespace = data1.namespace__c;
                    temp.language = lang;
                    proposalpdftemplateWrapper.parameters para = new proposalpdftemplateWrapper.parameters();
                    list<proposalpdftemplateWrapper.parameters> paraList = new list<proposalpdftemplateWrapper.parameters>();
                    para.type = 'document';
                    para.document = doc;
                    paraList.add(para);
                    
                    integer i = 0;
                    list<proposalpdftemplateWrapper.parameters> paraList2 = new list<proposalpdftemplateWrapper.parameters>();
                    proposalpdftemplateWrapper.parameters para2 = new proposalpdftemplateWrapper.parameters();
                    para2.type = 'text';
                    if(i==0){
                        para2.text = opportunitydata.account.name;
                        paraList2.add(para2);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para4 = new proposalpdftemplateWrapper.parameters();
                    para4.type = 'text';
                    if(i==1){
                        para4.text = opportunitydata.Owner.name;
                        paraList2.add(para4);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para5 = new proposalpdftemplateWrapper.parameters();
                    para5.type = 'text';
                    if(i==2){
                        para5.text = opportunitydata.Owner.Mobilephone;
                        paraList2.add(para5);
                        i++;
                    }
                    
                    proposalpdftemplateWrapper.components comp = new proposalpdftemplateWrapper.components();
                    proposalpdftemplateWrapper.components comp2 = new proposalpdftemplateWrapper.components();
                    comp.type = 'header';
                    comp.parameters = paraList;
                    comp2.type = 'body';
                    comp2.parameters = paraList2;
                    compList.add(comp);
                    compList.add(comp2);
                    doc.filename = 'Interior proposal.pdf';
                    TempBody.to = opportunitydata.account.MobileYM__c;
                    TempBody.ttl = data1.ttl__c;
                    TempBody.type = data1.type__c;
                    TempBody.template = temp;
                    temp.components = compList;
                    template.body = TempBody;
                    
                    string Jsonbody = JSON.serialize(template);
                    Httprequest request = new HttpRequest();
                    Http http = new Http();
                    request.setMethod('POST');
                    string jsonString = data1.url__c + '?bot='+data1.bot__c;
                    request.setEndpoint(jsonString);
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('x-auth-token', data1.x_auth_token__c);
                    request.setBody(Jsonbody);
                    HttpResponse response = http.send(request);    
                    system.debug('response body: '+response.getBody());
                }
                else if(contentDataList.WhatsApp_Civil_Proposal__c == true){
                    
                    template.type = data2.type__c;
                    template.mime = data2.mime__c;
                    template.file = encodingutil.base64Encode(contentDataList.versiondata);
                    lang.code = data3.code__c;
                    lang.policy = data3.policy__c;
                    temp.name = data3.name__c;
                    temp.namespace = data3.namespace__c;
                    temp.language = lang;
                    proposalpdftemplateWrapper.parameters para = new proposalpdftemplateWrapper.parameters();
                    list<proposalpdftemplateWrapper.parameters> paraList = new list<proposalpdftemplateWrapper.parameters>();
                    para.type = 'document';
                    para.document = doc;
                    paraList.add(para);
                    
                    integer i = 0;
                    list<proposalpdftemplateWrapper.parameters> paraList2 = new list<proposalpdftemplateWrapper.parameters>();
                    proposalpdftemplateWrapper.parameters para2 = new proposalpdftemplateWrapper.parameters();
                    para2.type = 'text';
                    if(i==0){
                        para2.text = opportunitydata.account.name;
                        paraList2.add(para2);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para4 = new proposalpdftemplateWrapper.parameters();
                    para4.type = 'text';
                    if(i==1){
                        para4.text = opportunitydata.Owner.name;
                        paraList2.add(para4);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para5 = new proposalpdftemplateWrapper.parameters();
                    para5.type = 'text';
                    if(i==2){
                        para5.text = opportunitydata.Owner.Mobilephone;
                        paraList2.add(para5);
                        i++;
                    }
                    
                    proposalpdftemplateWrapper.components comp = new proposalpdftemplateWrapper.components();
                    proposalpdftemplateWrapper.components comp2 = new proposalpdftemplateWrapper.components();
                    comp.type = 'header';
                    comp.parameters = paraList;
                    comp2.type = 'body';
                    comp2.parameters = paraList2;
                    compList.add(comp);
                    compList.add(comp2);
                    doc.filename = 'Civil Work proposal.pdf';
                    TempBody.to = opportunitydata.account.MobileYM__c;
                    TempBody.ttl = data3.ttl__c;
                    TempBody.type = data3.type__c;
                    TempBody.template = temp;
                    temp.components = compList;
                    template.body = TempBody;
                    
                    string Jsonbody = JSON.serialize(template);
                    Httprequest request = new HttpRequest();
                    Http http = new Http();
                    request.setMethod('POST');
                    string jsonString = data3.url__c + '?bot='+data3.bot__c;
                    request.setEndpoint(jsonString);
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('x-auth-token', data3.x_auth_token__c);
                    request.setBody(Jsonbody);
                    HttpResponse response = http.send(request); 
                    system.debug('response body:'+response.getBody());
                }   
                else if(contentDataList.Whatsapp_PPT__c == true){
                    
                    template.type = data2.type__c;
                    template.mime = data2.mime__c;
                    template.file = encodingutil.base64Encode(contentDataList.versiondata);
                    lang.code = data4.code__c;
                    lang.policy = data4.policy__c;
                    temp.name = data4.name__c;
                    temp.namespace = data4.namespace__c;
                    temp.language = lang;
                    proposalpdftemplateWrapper.parameters para = new proposalpdftemplateWrapper.parameters();
                    list<proposalpdftemplateWrapper.parameters> paraList = new list<proposalpdftemplateWrapper.parameters>();
                    para.type = 'document';
                    para.document = doc;
                    paraList.add(para);
                    
                    integer i = 0;
                    list<proposalpdftemplateWrapper.parameters> paraList2 = new list<proposalpdftemplateWrapper.parameters>();
                    proposalpdftemplateWrapper.parameters para2 = new proposalpdftemplateWrapper.parameters();
                    para2.type = 'text';
                    if(i==0){
                        para2.text = opportunitydata.account.name;
                        paraList2.add(para2);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para4 = new proposalpdftemplateWrapper.parameters();
                    para4.type = 'text';
                    if(i==1){
                        para4.text = opportunitydata.Owner.name;
                        paraList2.add(para4);
                        i++;
                    }
                    proposalpdftemplateWrapper.parameters para5 = new proposalpdftemplateWrapper.parameters();
                    para5.type = 'text';
                    if(i==2){
                        para5.text = opportunitydata.Owner.Mobilephone;
                        paraList2.add(para5);
                        i++;
                    }
                    
                    proposalpdftemplateWrapper.components comp = new proposalpdftemplateWrapper.components();
                    proposalpdftemplateWrapper.components comp2 = new proposalpdftemplateWrapper.components();
                    comp.type = 'header';
                    comp.parameters = paraList;
                    comp2.type = 'body';
                    comp2.parameters = paraList2;
                    compList.add(comp);
                    compList.add(comp2);
                    doc.filename = 'PPT.pdf';
                    TempBody.to = opportunitydata.account.MobileYM__c;
                    TempBody.ttl = data4.ttl__c;
                    TempBody.type = data4.type__c;
                    TempBody.template = temp;
                    temp.components = compList;
                    template.body = TempBody;
                    
                    string Jsonbody = JSON.serialize(template);
                    Httprequest request = new HttpRequest();
                    Http http = new Http();
                    request.setMethod('POST');
                    string jsonString = data4.url__c + '?bot='+data4.bot__c;
                    request.setEndpoint(jsonString);
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('x-auth-token', data4.x_auth_token__c);
                    request.setBody(Jsonbody);
                    HttpResponse response = http.send(request); 
                    system.debug('response body:'+response.getBody());
                }             
            }
            catch(Exception e){
                System.debug('Error::'+e.getMessage());
            }
        }   
    } }
}