/* @Name        quickcilverAPI 
* @Author      Colbridge <jozef.colbridge@siratek.in>
* @Date        10 Nov, 2021
* @Description - Calls the Woohoo Card API, Generates signature and access token.
* Checks if the card was created, if not calls the Status API and see card status.
*-------------------------------------------------------------------------------------------
* Modification Log:
* Version      Developer           Date            Description
*-------------------------------------------------------------------------------------------
* 1.0          Colbridge           10 Jan, 2022    Creates a Task (email) if the card
* was created successfully for that opporunity record.
* 1.1          Colbridge           18 Jul, 2022    Avoid duplicat whoohoo card/Task creation
*-------------------------------------------------------------------------------------------*/
public class quickcilverAPI {
    @future(callout=true)
    public static void callServer(String id){
        
        // On successful Woohoo card generation, a Task will be created.
        // To avoid duplicate Whoohoo Card generation/Task check if a task was created.
        Task[] tsk = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId =: id AND Subject = 'Woohoo Card Generation SUCCESS'];
       
        if (tsk.size() == 0) { // check if a task was created for this opportunity - proceed only if none found
        
            Opportunity opp =[Select Id, Account.FirstName,Account.ShippingAddress,Account.BillingAddress, Account.LastName,Email__c,DUP_Mobile__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,
                              account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode from Opportunity where id=: id limit 1];
            
            OpportunityDataWrap oppdata = new OpportunityDataWrap();
            // A random number need to be appended to the refno to avoid duplicate refno api error
            // Generate a random number between 0 and 1000
            Integer randomNumber = Integer.valueof((Math.random() * 1000));
            
            String rno = 'DC-' + opp.Id + '-' + randomNumber;
            oppdata.refno = rno;
            oppdata.syncOnly = true;
            oppdata.deliveryMode = 'EMAIL';
            
            if(opp.Account.ShippingAddress !=null){
                ShippingAddressWrap cc = new ShippingAddressWrap();
                cc.firstname = opp.Account.LastName;
                cc.lastname = '';
                cc.email = opp.Email__c;
                cc.telephone = '+91'+opp.DUP_Mobile__c;
                cc.country = 'IN';
                cc.line1 = opp.Account.ShippingStreet;
                cc.line2 = '-';
                cc.city = opp.Account.ShippingCity;
                cc.postcode = opp.Account.ShippingPostalCode;
                cc.region = opp.Account.ShippingState;
                cc.billToThis = true;
                oppdata.address = cc;
            }
            
            if(opp.Account.BillingAddress !=null){
                BillingAddressWrap cb = new BillingAddressWrap();
                cb.firstname = opp.Account.lastname;
                cb.lastname = '';
                cb.email = opp.Email__c;
                cb.telephone = '+91'+opp.DUP_Mobile__c;
                cb.country = 'IN';
                cb.line1 = opp.Account.ShippingStreet;
                cb.line2 = '-';
                cb.city = opp.Account.ShippingCity;
                cb.postcode = opp.Account.ShippingPostalCode;
                cb.region = opp.Account.ShippingState; 
                oppdata.billing = cb;
            }
            List<paymentwrap> pw = new List<paymentwrap>();
            paymentwrap pwr = new paymentwrap();
            pwr.code = 'svc';
            pwr.amount = 1;
            pw.add(pwr);
            oppdata.payments = pw;
            
            List<productsWrap> prodwrap = new List<productsWrap>();
            productsWrap pdwr = new productsWrap();
            // Testing SKU's: PROCESSINGSTS DISABLEDSTS CNPIN testsuccess001 APITESTTIMFAIL 324
            // SKU: DCEGV001 - use this latest for testing
            // Product Id: 914 - Product Name: Design Cafe eGift Card 
            // Production SKU: EGCGBWCLPGDS002 - Product Name: Rewards eCard-Gold- Design Café - Product Id: 4560
            // Also in production set price and amount to 1
            // pdwr.sku = 'DCEGV001'; // for testing
            pdwr.sku = 'EGCGBWCLPGDS002'; // for Production
            pdwr.price = 1;
            pdwr.qty = 1;
            pdwr.currency_x =356;
            pdwr.giftMessage ='';
            pdwr.theme ='';
            prodwrap.add(pdwr);
            oppdata.products = prodwrap;
            System.debug('OppData:- '+oppdata);
            
            String jsbody = JSON.serialize(oppdata);
            String jsonBody = jsbody.replace('currency_x', 'currency'); 
            System.debug('JSON BODY: '+jsonBody);
            
            map<String,Object> result = (map<String,Object>)JSON.deserializeUntyped(jsonBody);
            System.debug('result: '+result);
            // Create signature for order api using A, C, D, E, F and G below.
            // doc https://developers.woohoo.in/docs/get-started-title/oauth-2-0-protocol-recommended/oauth2-0-signature-generation-steps-for-request/
            
            jsonBody = JSON.serialize(result);	// E
            
            String encodedReqBody = EncodingUtil.URLEncode(jsonBody,'UTF-8').replace('+','%20');	// F
            System.debug('encodedReqBody: '+encodedReqBody);
            System.debug('jsonBody: '+jsonBody);
            
            String absApiUrl = Label.WoohooAPI+'/orders';
            System.debug('absApiUrl: '+absApiUrl);
            
            quickcilver__c	qc = quickcilver__c.getvalues('quickcilver details');
            String secretKeyValue = qc.Consumer_secret__c;
            String bearerToken = qc.Bearer_Token__c;
            Date tokenDate = qc.Token_Date__c; 
            String reqMethod = 'POST';		// A - for order api
            
            String encodedAbsApiUrl = EncodingUtil.URLEncode(absApiUrl,'UTF-8').replace('+','%20');	// C
            
            System.debug('encodedAbsApiUrl: '+encodedAbsApiUrl);
            String endPoint = reqMethod + '&' + encodedAbsApiUrl;		// D = (A&C)
            String baseString = endPoint + '&' + encodedReqBody;		// G = (D&F)
            System.debug('endPoint: '+ endPoint);
            System.debug('baseString: '+ baseString);
            
            String signature;       
            // converting base string (G) to HMAC-SHA512 hash (secret)
            Blob hmacData = Crypto.generateMac('HmacSHA512', Blob.valueOf(baseString), Blob.valueOf(secretKeyValue));
            signature = encodingUtil.convertToHex(hmacData); // signature generated for order api
            System.debug('signature: '+signature);
            
            // Now create another signature for calling status api using A, C and D below.
            // New values required for these parameters. GET API without query parameter.
            // doc https://developers.woohoo.in/docs/get-started-title/oauth-2-0-protocol-recommended/oauth2-0-signature-generation-steps-for-request/
            String reqMethodStatusApi = 'GET';		// A 
            String absStatApiUrl = Label.WoohooAPI + '/order/' + rno + '/status'; // endpoint for status api
            System.debug('absStatApiUrl: ' + absStatApiUrl);
            String encodedAbsStatApiUrl = EncodingUtil.URLEncode(absStatApiUrl,'UTF-8').replace('+','%20');	// C
            String endPointStatusApi = reqMethodStatusApi + '&' + encodedAbsStatApiUrl;		// D = (A&C)
            
            String signatureStatusApi;       
            // converting base string (D) to HMAC-SHA512 hash (secret)
            Blob hmacDataStatApi = Crypto.generateMac('HmacSHA512', Blob.valueOf(endPointStatusApi), Blob.valueOf(secretKeyValue));
            signatureStatusApi = encodingUtil.convertToHex(hmacDataStatApi); // signature generated for status api
            System.debug('signatureStatusApi: ' + signatureStatusApi);
            
            String dateAtClient = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
            System.debug('dateAtClient: ' +  dateAtClient);
            
            // Keep re-using previously generated token for 6 days
            Integer tokenElapsedDays = 0;
            if(tokenDate != null){
                // No. of days between two dates
                tokenElapsedDays = tokenDate.daysBetween(date.today());
                System.debug('No. of tokenElapsedDays : '+ tokenElapsedDays);
            }
            
            Boolean newTokenGenerated = false;
            if(tokenElapsedDays > 6 || bearerToken == null || tokenDate == null){
                bearerToken = quickcilverOauth.BearerToken(); // generate new token after 6 days
                newTokenGenerated = true; // set flag to save token and date
            } 
            
            System.debug('bearerToken: ' + bearerToken);
            String emailAlertBody = '';
            String emailAlertSub = '';
            Integer callOrderApi = 2; // total order api tries max 2, including 1 re-try if needed. 0 = stop.
            Boolean callStatusApi = true; 
            While(callOrderApi > 0 && callStatusApi == true) {
                callStatusApi = true; // reset for second iteration
                try {
                    // send http request
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(absApiUrl);
                    // waiting for 15 sections before timing out, default is 10 and you can use 10 to check
                    // timeout and using SKU testsuccess001
                    request.setTimeout(15000); 
                    request.setMethod(reqMethod);
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('Authorization', 'Bearer ' + bearerToken);
                    request.setHeader('dateAtClient', dateAtClient);
                    request.setHeader('signature', signature);
                    request.setHeader('Accept', '*/*');
                    // following header is for identifying the request, given by qc for uat
                    // request.setHeader('jriu43a2ravtind804ndj2', 'jes1unrcyaf3');
                    // following header is for identifying the request, given by qc for production
                    request.setHeader('mysalesforce', 'oishdfcoekjw345ds');
                    request.setBody(jsonBody);
                    Http http = new Http();
                    HttpResponse response = http.send(request);
                    System.debug('response body: ' + response.getBody());
                    System.debug('response: ' + response); 
                    System.debug('request: ' + request); 
                    System.debug('Authorization: ' + request.getHeader('Authorization'));
                    ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(),ResponseData.class);
                    //Calling ApiCallLogger class
                    ApiCallLogger.method(id, request.getEndpoint(), jsonBody, response.getBody(), 'out');
                    
                    if (response.getStatusCode() == 201) {   // Created success code, for POST request.
                        String responseStatus = (String)rd.status;
                        if (responseStatus == 'COMPLETE') { // if order successfully placed
                            callOrderApi = 0; // no need to re-try, stop the loop.
                            emailAlertSub = 'Woohoo Card creation SUCCESS';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nWoohoo Card created Successfully. \nResponse Status: ' + responseStatus;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                            
                            // Create a Task of type email so that the opportunity record shows Woohoo Card was created successfully.
                            insert new Task(
                                Subject = 'Woohoo Card Generation SUCCESS',
                                WhatId = opp.Id,
                                TaskSubtype = 'Email',
                                ActivityDate = Date.today(),
                                Description =  'Woohoo Card was generated SUCCESSFULLY for this Opportunity.',
                                Status = 'Completed'
                            );
                            
                        } 
                    } else if (response.getStatusCode() == 400) { // Bad request body.
                        callOrderApi = 0; // no need to re-try, stop the loop.
                        String responseCode = (String)rd.code;
                        String responseCodeMsg = (String)rd.message;
                        if (responseCode == '5310'){ // SKU Disabled
                            emailAlertSub = 'Woohoo Card SKU DISABLED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: SKU is Disabled. \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                        } else if (responseCode == '5313'){ // Duplicate ref. no.
                            emailAlertSub = 'Woohoo Card order FAILED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: DUPLICATE Reference No. \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                        } else if (responseCode == '5308'){ // Restricted Product
                            emailAlertSub = 'Woohoo Card order FAILED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: Restricted Product \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                        } else if (responseCode == '6050'){ // Black listed phone number.
                            emailAlertSub = 'Woohoo Card order FAILED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: Blacklisted Customer/Phone No. \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                      } else if (responseCode == '5315'){ // Product mis-configuration.
                            emailAlertSub = 'Woohoo Card order FAILED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: Product mis-configuration. \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                        } else { 
                            String responseCodeMsgs = (String)rd.messages[0]; // additional response messages
                            emailAlertSub = 'Woohoo Card order FAILED';
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nError: Bad request body. \nResponse code: ' + responseCode +
                                '\nResponse message: ' + responseCodeMsg +
                                '\nAdditonal response messages: ' + responseCodeMsgs;
                            sendEmailAlert(emailAlertSub, emailAlertBody);
                        }
                    } else if (response.getStatusCode() == 401) { // Unauthorized
                        bearerToken = quickcilverOauth.BearerToken(); // generate new token if old is rejected
                        newTokenGenerated = true; // set flag to save token and date
                        callStatusApi = false;
                    } else if (response.getStatusCode() == 503 ||
                               response.getStatusCode() == 500) { // Service temp. unavailable or Server error
                                   emailAlertSub = 'Woohoo Card Server ERROR';
                                   emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                       rno + '\nError: Server Error or Server Unavailable.';
                                   sendEmailAlert(emailAlertSub, emailAlertBody);   
                                   System.debug('Order API Server unavailable. Status Code: ' + response.getStatusCode());  
                               } 
                    // Update new token and generation date if a new token was generated
                    if (newTokenGenerated) {
                        qc.Bearer_Token__c = bearerToken;
                        qc.Token_Date__c = date.today();
                        update qc;
                    } 
                } catch (System.CalloutException eOrderApi) {
                    // No response/time out from order api, before retrying calling order api, call status api
                    // Doc: https://developers.woohoo.in/docs/rest-api-v3-revamp/order-status-api/
                    // write error to debug log
                    System.debug('Order API Error: ' + eOrderApi + ' - Order Ref.No: ' + rno);
                    // No need to send email to admin here as we are checking status api below & sending mail there 
                } // end order api try catch
                
                if (callOrderApi > 0 && callStatusApi == true) {
                    try {
                        // call status api
                        HttpRequest statApiReq = new HttpRequest();
                        statApiReq.setEndpoint(absStatApiUrl);
                        statApiReq.setTimeout(40000); // timeout 40 seconds
                        statApiReq.setMethod(reqMethodStatusApi);
                        statApiReq.setHeader('Content-Type', 'application/json');
                        statApiReq.setHeader('Authorization', 'Bearer ' + bearerToken);
                        statApiReq.setHeader('dateAtClient', dateAtClient);
                        statApiReq.setHeader('signature', signatureStatusApi);
                        statApiReq.setHeader('Accept', '*/*');
                        // following header is for identifying the request, given by qc for uat
                        // statApiReq.setHeader('jriu43a2ravtind804ndj2', 'jes1unrcyaf3');
                        // following header is for identifying the request, given by qc for production
                        statApiReq.setHeader('mysalesforce', 'oishdfcoekjw345ds');
                        Http http = new Http();
                        HttpResponse statApiResp = http.send(statApiReq);
                        System.debug('statApiResp body: ' + statApiResp.getBody());
                        System.debug('statApiResp: ' + statApiResp); 
                        System.debug('statApiReq: ' + statApiReq); 
                        System.debug('statAuthorization: ' + statApiReq.getHeader('Authorization'));
                        
                        ResponseData rdStatApi = (ResponseData)JSON.deserialize(statApiResp.getBody(),ResponseData.class);
                        //Calling ApiCallLogger class
                        ApiCallLogger.method(id, statApiReq.getEndpoint(), jsonBody, statApiResp.getBody(), 'out');
                        String responseStatusApi = (String)rdStatApi.status;
                        // Check response statuses from status api
                        if (statApiResp.getStatusCode() == 200) {   // order success
                            if (responseStatusApi == 'COMPLETE') {
                                callOrderApi = 0; // no need to re-try order api, stop the loop
                                emailAlertSub = 'Woohoo Card Order Success. Status is: ' + responseStatusApi;
                                emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                    rno + '\nStatus API response is: ' + responseStatusApi;
                                sendEmailAlert(emailAlertSub, emailAlertBody); 
                            } else if (responseStatusApi == 'PENDING' || 
                                       responseStatusApi == 'CANCELED' ||
                                       responseStatusApi == 'PROCESSING') {
                                           emailAlertSub = 'Woohoo Card Order Status: ' + responseStatusApi;
                                           emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                               rno + '\nStatus API response is: ' + responseStatusApi + ' - Contact QC Woohoo team.';
                                           sendEmailAlert(emailAlertSub, emailAlertBody); 
                                           callOrderApi = 0; // no need to re-try order api, stop the loop
                                       }
                        } else if (statApiResp.getStatusCode() == 400) {   // order not successful
                            if (responseStatusApi == '5320'){ // Order not available. Didn't get placed the first time
                                callOrderApi--; // decrement the re-try flag to call order api one more time and stop
                                // Generate new random # to create new unique ref.no.
                                // re-try order api second time
                                randomNumber = Integer.valueof((Math.random() * 1000));
                                rno = 'DC-' + opp.Id + '-' + randomNumber;
                            } else {
                                callOrderApi = 0; // no need to re-try order api, stop the loop 
                            }
                        } else {
                            emailAlertSub = 'Woohoo Card Order Status: ' + responseStatusApi;
                            emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                                rno + '\nStatus API response is: ' + responseStatusApi;
                            sendEmailAlert(emailAlertSub, emailAlertBody); 
                        }
                    } catch (System.CalloutException eStatApi) {
                        // write error to debug log
                        System.debug('Status API Error: ' + eStatApi + ' - Order Ref.No: ' + rno); 
                        callOrderApi = 0; // no need to re-try, stop the loop
                        emailAlertSub = 'Woohoo Card Order Status Check ERROR';
                        emailAlertBody = 'For this Woohoo Card order with Reference No: ' + 
                            rno + '\nStatus API check Failed: ' + eStatApi;
                        sendEmailAlert(emailAlertSub, emailAlertBody);
                    } // end status api try catch
                } // end callStatusApi
            } // end while loop
            
            // ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(),ResponseData.class);
            //List<ResponseData> rd = (List<ResponseData>)JSON.deserialize(response.getBody(),List<ResponseData>.class);
            // System.debug('Response Data :' + rd);
            
            /* Opportunity oppty = new Opportunity();
    oppty.Id = opp.id;
    //oppty.Wohoo_Card__c = rd.cards[0].cardNumber;
    //oppty.Pin__c = rd.cards[0].cardPin;
    update oppty;*/
        } // end task creation check
    } // end callServer
    
    
    public static void sendEmailAlert(String sub, String bdy){
        /* List<User> userList = new List<User>();
        userList = [SELECT Email FROM User WHERE Name = 'Kezia Dola'];
        
        List<String> toAddresses = new List<String>();
        for (User u : userList) {           
        toAddresses.add(u.Email);
        } */
        
        String messageSub = sub;
        String messageBody = bdy; 
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // message.toAddresses = toAddresses;
        message.toAddresses = new String[] { 'sfapitriggers@designcafe.com' };
        message.subject = messageSub;
        message.plainTextBody = messageBody;
        Messaging.SingleEmailMessage[] messages = 
            new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                         + results[0].errors[0].message);
        }
    }
    
    public class ShippingAddressWrap{
        public String firstname{get;set;}
        public String lastname{get;set;} 
        public String email{get;set;} 
        public String telephone{get;set;} 
        public String line1{get;set;} 
        public String line2{get;set;} 
        public String city{get;set;} 
        public String region{get;set;} 
        public String country{get;set;} 
        public String postcode{get;set;} 
        public boolean billToThis{get;set;} 
    }
    
    public class BillingAddressWrap{
        public String firstname{get;set;}
        public String lastname{get;set;} 
        public String email{get;set;} 
        public String telephone{get;set;} 
        public String line1{get;set;} 
        public String line2{get;set;} 
        public String city{get;set;} 
        public String region{get;set;} 
        public String country{get;set;} 
        public String postcode{get;set;} 
    }
    
    public class paymentwrap{
        public String code{get;set;}
        public integer amount{get;set;}
    }
    
    public class productsWrap{
        public String sku{get;set;}
        public Integer price{get;set;}
        public integer qty{get;set;}
        public integer currency_x{get;set;}
        public String giftMessage{get;set;}
        public String theme{get;set;}
    }
    
    public class OpportunityDataWrap{    
        Public ShippingAddressWrap address{get;set;}
        Public BillingAddressWrap billing{get;set;}
        Public List<paymentwrap> payments{get;set;}
        public String refno{get;set;}
        public List<productsWrap> products{get;set;}
        public boolean syncOnly{get;set;}
        public String deliveryMode{get;set;} 
    }
    
    public class ResponseData {
        public String status;
        public String code;
        public String message;
        public List<String> messages;
        public List<cardwrap> cards;
    }
    
    public class cardwrap{
        public String cardNumber;
        public String cardPin;
    }
}