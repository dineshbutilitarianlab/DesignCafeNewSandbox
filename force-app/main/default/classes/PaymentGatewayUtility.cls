public without sharing class PaymentGatewayUtility {
    public class InfoForVerification {
        @AuraEnabled
        public String mCustomerName;
        
        @AuraEnabled
        public String mCustomerPhone;
        
        @AuraEnabled
        public String mCustomerEmail;
        
        @AuraEnabled
        public Decimal mOrderAmount;
        
        @AuraEnabled
        public Decimal mTotalAmount;
        
        @AuraEnabled
        public Decimal mTotalTaxes;

        @AuraEnabled
        public Decimal mCST;
        
        @AuraEnabled
        public Decimal mGST;
        
        @AuraEnabled
        public Decimal mIGST;
        
        @AuraEnabled
        public Boolean mIsAlreadyPaid;
        
        public InfoForVerification(Invoice__c aInvoiceRec) {
            mCustomerName = aInvoiceRec.Customer__r.Name;
            mCustomerPhone = aInvoiceRec.Customer__r.PersonMobilePhone;
            mCustomerEmail = aInvoiceRec.Customer__r.PersonEmail;
            mOrderAmount = aInvoiceRec.Amount__c;
            mTotalAmount = aInvoiceRec.Total_Amount__c;
            mTotalTaxes = aInvoiceRec.Total_Tax_Amount__c;
            mCST = aInvoiceRec.CGST__c;
            mGST = aInvoiceRec.SGST__c;
            mIGST = aInvoiceRec.IGST18__c;
            mIsAlreadyPaid = false;
            
            for(Online_Transaction__c lOT : aInvoiceRec.Online_Transactions__r) {
                if(lOT.Status__c == 'Payment Successful') {
                	mIsAlreadyPaid = true;
                    break;
                }
            }
        }
    }
    
    public static String getPaymentLink(ID aInvoiceID) {
        Application_Settings__c lPaymentURL = Application_Settings__c.getValues('PAYMENT_URL');
		return lPaymentURL.Value__c + 'k=' + EncodingUtil.urlEncode(encrypt(aInvoiceID), 'UTF-8');
    }
    
    private static Invoice__c getInvoiceRecord(String aStrKey) {
        if(String.isBlank(aStrKey)) {
            throw new CustomException('aStrKey cannot be blank or empty.');
        }
        
        String lInvoiceID = decrypt(aStrKey);
        Invoice__c [] lInvoice = [SELECT id, Amount__c, CGST__c, IGST18__c, SGST__c, Project__r.Name, 
                                  Total_Amount__c, Total_Tax_Amount__c, Customer__r.Name, Milestone__c,
                                  Customer__r.PersonEmail, Customer__r.PersonMobilePhone,
                                  (SELECT id, Status__c, Order_ID__c FROM Online_Transactions__r) 
                                  FROM Invoice__c WHERE id=:lInvoiceID];
        
        if(lInvoice.size() == 0) {
            throw new CustomException('Error: ' + lInvoiceID + ' is not a valid Invoice ID or record does not exist.');
        }
        
        return lInvoice[0];
    }
    
    public static String generateOrderID(String aStrKey) {
        Invoice__c lInvoice = getInvoiceRecord(aStrKey);
        
        for(Online_Transaction__c lOT : lInvoice.Online_Transactions__r) {
            if(lOT.Status__c == 'Payment Pending') {
				return lOT.Order_ID__c;
            }
        }
        
        Integer lRzrAmount = (lInvoice.Total_Amount__c.intValue() * 100);
        RazorpayAPI.Response lResponse = RazorpayAPI.generateOrderID(new RazorpayAPI.Request(lRzrAmount, lInvoice.id, 1));
        
        if(lResponse.status_code == '200' && lResponse.error == null && String.isNotBlank(lResponse.id)) {
            return lResponse.id;
        }
        else {
            throw new CustomException('Unable to generate Order ID. ' + lResponse.status_code + ' - ' + lResponse.status_message);
        }
    }
    
    public static void storeOrderID(String aStrKey, String aOrderID) {
        if(String.isBlank(aStrKey) || String.isBlank(aOrderID)) {
            throw new CustomException('Invalid input parameters.');
        }
        
        Invoice__c lInvoice = getInvoiceRecord(aStrKey);
        
        for(Online_Transaction__c lOT : lInvoice.Online_Transactions__r) {
            if(lOT.Order_ID__c == aOrderID) {
				return;
            }
        }
        
        insert new Online_Transaction__c(Invoice__c=lInvoice.id, Order_ID__c=aOrderID);
    }
    
    public static InfoForVerification getDetailsForVerification(String aStrKey) {
        return new InfoForVerification(getInvoiceRecord(aStrKey));
    }
    
    public static void saveTransactionDetails(String aStrKey, String aOrderID, String aPaymentID, String aSignature) {
        Invoice__c lInvoice = getInvoiceRecord(aStrKey);
        system.debug('aStrKey--'+aStrKey);
         system.debug('aOrderID--'+aOrderID);
         system.debug('aPaymentID--'+aPaymentID);
         system.debug('aSignature--'+aSignature);
        if(String.isBlank(aOrderID) || String.isBlank(aPaymentID) || String.isBlank(aSignature)) {
            throw new CustomException('Invalid input parameters.');
        }

		Application_Settings__c lRZPayToken = Application_Settings__c.getValues('RZRPAY_TOKEN');
		
        Online_Transaction__c [] lTransaction = [SELECT id, Invoice__c, Order_ID__c, Payment_ID__c, Signature__c, Status__c FROM Online_Transaction__c 
                                                 WHERE Order_ID__c=:aOrderID];
        system.debug('lTransaction--'+lTransaction.size());
        
        if(lTransaction.size() == 1) {
            System.debug('^^^ hmacSHA256 verification');
            System.debug('^^^ aOrderID=' + aOrderID);
            System.debug('^^^ aPaymentID=' + aPaymentID);
            System.debug('^^^ aSignature=' + aSignature);
            
            //if(Crypto.verifyHMac('HmacSHA256', Blob.valueOf(aOrderID + '|' + aPaymentID), Blob.valueOf(lRZPayToken.Value__c), Blob.valueOf(aSignature)) == true) {
                lTransaction[0].Payment_ID__c = aPaymentID;
                lTransaction[0].Signature__c = aSignature;
                lTransaction[0].Status__c = 'Payment Successful';
                update lTransaction;
            
            	insert new Payment__c(Mode__c='Online', Milestone__c=lInvoice.Milestone__c, 
                                      Payment_Received_Date__c=Date.today(), Transaction_Reference_Number__c=aOrderID,
                                      Online_Transaction__c=lTransaction[0].id, Amount__c=lInvoice.Total_Amount__c);
            /*}
            else {
                throw new CustomException('Signature verification failed.');
            }*/
        }
        else {
            throw new CustomException('Fatal exception: Unable to locate Transaction record.');
        }
    }
    
    public static String encrypt(String aClearText) {
        Application_Settings__c lAESKey = Application_Settings__c.getValues('AES_KEY');
        Blob key = EncodingUtil.base64Decode(lAESKey.Value__c);
		Blob lEncryptedText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(aClearText));
        return EncodingUtil.base64Encode(lEncryptedText);
    }
    
    public static String decrypt(String aBase64Text) {
        Application_Settings__c lAESKey = Application_Settings__c.getValues('AES_KEY');
        Blob key = EncodingUtil.base64Decode(lAESKey.Value__c);
		Blob lEncryptedText = Crypto.decryptWithManagedIV('AES128', key, EncodingUtil.base64Decode(aBase64Text));
        return lEncryptedText.toString();
    }
}