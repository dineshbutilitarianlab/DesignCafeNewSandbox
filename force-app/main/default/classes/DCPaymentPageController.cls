global class DCPaymentPageController {
    global class Response {
        global String status_code;
        global String status_message;
		global String rz_key;
        global Integer total_amount;
		global String customer_name;
        global String customer_email;
        global String customer_phone;        
    }

    @RemoteAction
    global static Response saveTransaction(String aStrKey, String aOrderID, String aPaymentID, String aAuth) {
        Response lResponse = new Response();
        lResponse.status_code = '200';
        lResponse.status_message = 'Success';
        
        try {
            PaymentGatewayUtility.saveTransactionDetails(aStrKey, aOrderID, aPaymentID, aAuth);
        }
        catch(Exception e) {
            lResponse.status_code = '500';
            lResponse.status_message = 'Error saving transaction: ' + e.getMessage();
        }
        
        return lResponse;
    }
    
    @RemoteAction
    global static Response getPaymentInfo(String aStrKey, String aOrderID) {
        Response lResponse = new Response();
        lResponse.status_code = '200';
        lResponse.status_message = 'Success';
        PaymentGatewayUtility.InfoForVerification lInfo = null;
            
        try {
			lInfo = PaymentGatewayUtility.getDetailsForVerification(aStrKey);
        }
        catch(Exception e) {
        	lResponse.status_code = '500';
        	lResponse.status_message = 'Failed to get details. ' + e.getMessage();
        }
        
        if(lInfo != null) {
            Application_Settings__c lRZPayToken = Application_Settings__c.getValues('RZRPAY_KEY');
            Integer lAmount = lInfo.mTotalAmount.intValue() * 100;
            lResponse.rz_key = lRZPayToken.Value__c;
            lResponse.total_amount = lAmount;
            lResponse.customer_name = lInfo.mCustomerName;
            lResponse.customer_email = lInfo.mCustomerEmail;
            lResponse.customer_phone = lInfo.mCustomerPhone;
        }
        
        return lResponse;
    }
}