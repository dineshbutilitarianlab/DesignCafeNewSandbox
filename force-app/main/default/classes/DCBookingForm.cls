public class DCBookingForm {
    public Opportunity opp{get;set;}
    public Date Dte{get;set;}
    public string rec{get;set;}
    
    public DCBookingForm(apexpages.StandardController sc){ 
        rec=apexpages.currentPage().getparameters().get('id');
        opp=[SELECT Id, Name, Customer_ID__c, Mobile__c, Email__c, Home_Type__c, Offer_and_discounts__c, AccountId, account.name,Payment_Mode__c, 
             account.ShippingStreet, account.ShippingCity, account.ShippingState, account.ShippingCountry, account.ShippingPostalCode,Anniversary__c, 
             account.BillingStreet, account.BillingCity, account.BillingState, account.BillingCountry, account.BillingPostalCode,Birthday__c,
             Signup_Amount__c, Client_s_Budget__c, Amount, X1st_Meeting_Person__r.name, X2nd_Meeting_Person__r.name, X3rd_Meeting_Person__r.name, 
             Possession_Status__c, OwnerId, Owner.name, CloseDate, Owner.Address, account.PAN__c, account.GST_No__c, Owner.MobilePhone,
             Owner.Street, Owner.City,Remarks_For_Marketing__c, Owner.State, Owner.Country, OWner.PostalCode,Wohoo_Card__c, Delivery_time_from_design_signoff__c,  
             Account.PersonContact.Email,Frames_for_all_external_Doors_Windows__c,The_Doors_Windows_are_installed_Requir__c,All_walls_are_completed_Required__c,Putty_and_1_coat_of_plastering_Required__c,Floors_are_levelled_out_prepped_Basic__c,Flooring_is_completed_Required__c,Notes__c FROM Opportunity where id =: rec];
        
        dte = system.today();
    }
    
    public pagereference SaveFile(){
        PageReference pdf = Page.DCBookingFormSendPDF;
        pdf.getParameters().put('id',rec);
        pdf.setRedirect(true);
        
        blob body =Test.isRunningTest() ? Blob.valueOf('UNIT.TEST'):pdf.getContentAsPDF();
        string filename = ' My File Name ';
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'Attachment.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = String.valueOf('DC-'+opp.account.name+'-'+ string.valueof(system.today().format())+'.pdf'); // Display name of the files
        conVer.VersionData = body; // converting your binary string to Blog
        insert conVer;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId =rec; // you can use objectId,GroupId etc
        //cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        //cDe.Visibility = 'System Administrator';
        insert cDe;
        pagereference p=new pagereference('/'+rec);
        return p;
    }
    
 /*   public  pagereference SendFile(){    
        PageReference pdf = Page.DCBookingFormPDF;
        pdf.getParameters().put('id',rec);
        //Take the pdf content
        Blob b =Test.isRunningTest() ? Blob.valueOf('UNIT.TEST'):pdf.getContentAsPDF();
        //create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setContentType('application/pdf');
        efa.setFileName('attachment.pdf');
        efa.setInline(false);
        efa.setBody(b);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] toAddresses = new String[]{opp.Email__c};
            mail.setToAddresses(toAddresses);
        mail.setSubject('DC BookingForm created for your Opportunity :'+' '+ opp.Name);
       
        //mail.plaintextbody ='Dear'+' '+opp.account.Name+','+'\n'+'\n'+'Please find attached Opportunity for Opportunity:'+' '+opp.Name +' '+ 'valid till: '+' '+dateTimeStr+'\n'+'\n'+'\n'+'Thanks,'+'\n'+opp.Owner.Name; 
        mail.plaintextbody ='Dear'+' '+opp.account.Name+','+'\n'+'\n'+'Please find attached DCBookingForm for Opportunity:'+' '+opp.Name +' '+'\n'+'\n'+'\n'+'Thanks,'+'\n'+opp.Owner.Name; 
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{efa});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'Attachment.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = String.valueOf('DC'+ string.valueof(system.today().format())+'.pdf'); // Display name of the files
        conVer.VersionData = b; // converting your binary string to Blog
        insert conVer;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId =rec; // you can use objectId,GroupId etc
        //cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        //cDe.Visibility = 'System Administrator';
        insert cDe; 
        pagereference p=new pagereference('/'+rec);
        return p;    
    }    */
}