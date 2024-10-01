global class Quote_Lcs {
    
    public Quote Qt{get;set;}
    public ContentDocumentlink cd {get;set;}
    
    public static void sendemailtemplate(id quoteid){
        list<quote> Qt = new list<quote>();
        list<ContentDocumentlink> cd = new list<ContentDocumentlink>();
    
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
         List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for (ContentDocumentLink docLinks : [Select Id, ContentDocumentId,LinkedEntityId  from ContentDocumentLink where LinkedEntityId = :quoteid ]) {	 
                for (ContentDocument docs : [Select Id, FileType, Title, FileExtension,LatestPublishedVersionId from ContentDocument where Id= :docLinks.ContentDocumentId]) {
                    for (ContentVersion docVersion : [Select Id, VersionData from ContentVersion where ContentDocumentId =:docLinks.ContentDocumentId ]) {
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        string fileName = docs.Title.Trim() + '.' + docs.FileExtension.Trim();
                        efa.setFileName(fileName); //Title of the PDF
                        efa.setBody(docVersion.VersionData); //Body of the PDF,need to do transfer into blob
                        fileAttachments.add(efa);
                    }
                }
            }
        Qt= [select id,Status, Name,Customer_Email__c,Opportunity.OwnerId, Oppty_Customer_email__c, DesignerEmail__c,oppty_Designer_Email_add__c,Proposal_PDF__c,Site_Services_PDF__c, Quote_Link__c,Opportunity_Owner__c,Opportunity_Amount__c,Modular_Amount_Dis_Incl_GST__c , Modular_Discount__c, Site_Services_Amount_Dis_Incl_GST__c, Site_Services_Discount__c,Latest_Quote__c from Quote where id=:quoteid];  
        
        //cd =[select ContentDocumentId, LinkedEntityId   from ContentDocumentlink  where LinkedEntityId =:Qt[0].id];
        //List<ContentVersion> cvList = [SELECT VersionData, FileExtension FROM ContentVersion WHERE ContentDocumentId = :cd[0].ContentDocumentId];
        
        for (Quote q: Qt){
            if(q.Status=='Approved' && q.Quote_Link__c == Null && q.Proposal_PDF__c == Null && q.Site_Services_PDF__c == Null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add(q.Oppty_Customer_email__c);
                mail.setToAddresses(sendTo);
    
                // (Optional) Set list of people who should be CC'ed
                List<String> ccTo = new List<String>();
                ccTo.add(q.oppty_Designer_Email_add__c);
                ccTo.add(q.Opportunity.OwnerId);
                mail.setCcAddresses(ccTo);
        
                mail.setSubject('LCS - DC Proposal for Interior Work');
                String body = 'Dear Customer,<br/><br/>' +

                'Based on our discussion, please find the proposal and the estimate below:<br/><br/>' +

                '<table border="1">' +
                    '<tr><td>Modular (incl tax, with Discount Rs.: </td><td>' + q.Modular_Amount_Dis_Incl_GST__c + '</td></tr>' + 
                    '<tr><td>Modular Discount %: </td><td>' + q.Modular_Discount__c + '</td></tr>' +
                    '<tr><td>Services (incl tax, with Discount) Rs.: </td><td>' + q.Site_Services_Amount_Dis_Incl_GST__c + '</td></tr>' +
                    '<tr><td>Site Discount %: </td><td>' + q.Site_Services_Discount__c + '</td></tr>' +
                    '<tr><td>Total Project cost (incl tax, with discount) Rs.: </td><td>' + q.Opportunity_Amount__c + '</td></tr>' +
                    '<tr><td>Modular (incl tax, with Discount) Rs.: </td><td>' + q.Modular_Amount_Dis_Incl_GST__c + '</td></tr>' +
                '</table>' +

                '<br/>Please find the attached quotations.<br/><br/>' +
                
                'Thanks,<br/><br/>' + q.Opportunity_Owner__c;
                
                mail.setHtmlBody(body);
                mail.fileattachments =fileAttachments;
                
                mails.add(mail);
            
            /*  Blob fileData = contentDataList[0].VersionData; // <= This step converts the version data into a blob for the attachment
Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
emlAtt.setFilename(contentDataList[0].FileExtension);
emlAtt.setBody(fileData);
system.debug(emlAtt); */
            
            
           /* List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for (ContentDocumentLink docLinks : [Select Id, ContentDocumentId,LinkedEntityId  from ContentDocumentLink where LinkedEntityId = :quoteid ]) { 
                for (ContentDocument docs : [Select Id, FileType, Title, FileExtension,LatestPublishedVersionId from ContentDocument where Id= :docLinks.ContentDocumentId]) {
                    for (ContentVersion docVersion : [Select Id, VersionData from ContentVersion where ContentDocumentId =:docLinks.ContentDocumentId ]) {
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        string fileName = docs.Title.Trim() + '.' + docs.FileExtension.Trim();
                        efa.setFileName(fileName); //Title of the PDF
                        efa.setBody(docVersion.VersionData); //Body of the PDF,need to do transfer into blob
                        fileAttachments.add(efa);
                    }
                    Messaging.sendEmail(mails);
                }
            } */
            }
            Messaging.sendEmail(mails);
        }
    }
}