@RestResource(urlMapping='/googlelead/*')
global class GoogleLeadManager {
    private static string key = 'exampleKey';
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        Blob body = req.requestBody;
        String bodyString = body.toString();
        JsonLead lead;
        
        	//Api Call Logger
            ApiCallLogger.method(system.UserInfo.getUserId(),'/googlelead/*', req.requestBody.toString(), response.message, 'in');   
        try {
            lead = (JsonLead)JSON.deserializeStrict(bodyString, JsonLead.class);
            system.debug(lead.user_column_data);
            System.debug(lead.user_column_data[2].string_value);
            String APIMOBILE = lead.user_column_data[2].string_value;
            if (lead.google_key != '1234') {
                response.status = 'Failure';
                response.message = 'Invalid key.';
                return response;
            }
            
            
            if(APIMOBILE != null ){
                System.debug(APIMOBILE);
                List<LEAD> ld = [SELECT id,APIMOBILE__c,MobilePhone from Lead where APIMOBILE__c =: APIMOBILE OR AdWords_Mobile__c =: APIMOBILE Limit 1];
                system.debug('ld '+ld);
                if(ld.size() != 0) {
                    Lead new_lead = new Lead();
                    new_lead.Id = ld[0].id;
                    new_lead.DC_Lead_Status__c = 'Recontacted';
                    new_lead.Re_Contact_Date__c = System.now();
                    update new_lead;
                    response.message = 'Updated Successfully';
                    response.status  = 'Success';
                    response.recordId = new_lead.id;
                    return response;
                }
                else{
                    Lead new_lead = new Lead();
                    new_lead.google_lead_id__c = lead.lead_id;
                    new_lead.google_form_id__c = lead.form_id;
                    new_lead.Channel__c = 'Online';
                    new_lead.Source__c = 'Paid';
                    new_lead.DC_Campaign_Source__c = 'Google AdWords';
                    if(lead.form_id == '12320212169'){
                        new_lead.DC_Lead_Source__c ='Google Search Ads';
                    }else if(lead.form_id == '13420916833'){
                        new_lead.DC_Lead_Source__c ='Google Search Ads';
                    }else if(lead.form_id == '12304807067'){
                        new_lead.DC_Lead_Source__c ='Google Search Ads';
                    }else{
                        new_lead.DC_Lead_Source__c ='Google Discovery Ads';
                    }
                    //new_lead.DC_Lead_Source__c ='Google Discovery Ads';
                    new_lead.Ad_Group__c = lead.adgroup_id;
                    new_lead.Campagin__c = lead.campaign_id;
                    new_lead.GClid__c = lead.gcl_id;
                    for(UserLeadColumnData column: lead.user_column_data) {
                        if(column.column_name == 'User Phone'){
                            new_lead.AdWords_Mobile__c = column.string_value;
                            String Mobile_Phone = column.string_value;
                            List<String> parts = Mobile_Phone.split('[+]{1}[0-9]{2}');
                            if (parts.size() > 1) {
                                new_lead.MobilePhone = parts[parts.size()-1];
                                parts.remove(parts.size() -1);
                            }
                            new_lead.Country_Code__c = Mobile_Phone.substring(0, 3);
                        }
                        if(column.column_name == 'User Email'){
                            new_lead.Email = column.string_value; 
                        }
                        if(column.column_name == 'First Name'){
                            new_lead.FirstName = column.string_value;
                        }
                        if(column.column_name == 'Last Name'){
                            new_lead.LastName = column.string_value;
                        }
                        if(column.column_name == 'Postal Code'){
                            new_lead.PostalCode = column.string_value;
                        }
                        
                        if(column.column_name == 'Full Name'){
                            String full_name = column.string_value;
                            List<String> parts = full_name.split(' ');
                            if (parts.size() > 1) {
                                new_lead.LastName = parts[parts.size()-1];
                                parts.remove(parts.size() -1);
                            }
                            new_lead.FirstName = String.join(parts, ' ');
                        }
                        
                        if(column.column_id == 'PREFERRED_LOCATION'){
                            new_lead.Region__c = column.string_value;
                            new_lead.City = column.string_value;
                        }
                        if(column.column_id == 'PROPERTY_TYPE'){
                            new_lead.Home_Type__c = column.string_value;
                        }
                        if(column.column_id == 'PRICE_RANGE'){
                            new_lead.Approx_Budget__c = column.string_value;
                        }
                    }
                    
                    insert new_lead; 
                    response.status = 'Success';
                    response.message  = 'Your Leads have been created successfully';
                    response.recordId = new_lead.Id;
                    return response;
                    
                }
            }
            else{
                response.message = 'Mobile Number is not availbale';
                return response;
            }
            
            
        } catch(Exception e) {
            system.debug(e.getMessage());
            response.message = 'Invalid JSON Lead: ' + e.getMessage();
            return response;
        }
            
           
    } 
    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;
    }
}