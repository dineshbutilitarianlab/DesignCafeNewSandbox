@RestResource(urlMapping='/dcleads')
global without sharing class DC_RestResourceCls {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        System.debug('header'+req.headers.get('Authorization'));
        Intergration_Request__c integrationObj = New Intergration_Request__c();
        try {
            LeadWrapper LeadWrapperObj = (LeadWrapper)JSON.deserialize(req.requestBody.toString(), LeadWrapper.class);
            system.debug('json deserialize'+ req.requestBody.toString());
            integrationObj.Request_Body__c = req.requestBody.toString();
            
            // Creating the DMLOptions for "Assign using active assignment rules" checkbox
			Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.useDefaultRule = FALSE;

            List<LEAD> ld = [SELECT id,APIMOBILE__c,Call_Stage__c,Status,DC_Lead_Status__c,CreatedDate,convertedAccountId,convertedOpportunityId,
                             Follow_Up_Date_Time__c,FirstName,LastName,Meeting_Type__c,Meeting_Venue__c,Email,Country_Code__c,Home_Type__c,
                             Property_Possession_Status__c,Preferred_Time_to_Contact__c,Voucher_Code__c,Page_URL__c,Project_Name__c,OwnerId,
                             City,GClid__c,FBCLID__c,Area__c,Device_Name__c,Campagin__c,Ad_Group__c,Keyword__c,Match_Type__c,First_Visit_Time__c,
                             Ad_Name__c,User_Browser__c,IPAddress__c,Time_On_Last_page__c,Page__c,User_Last_Url__c,How_did_you_hear_about_us__c,
                             Entry_Url__c,User_OS__c,Description,PostalCode,Customer_Pincode__c,Civil_Work__c,Property_Possession_Date__c,Messaging_Source__c,
                             Channel__c,Source__c,DC_Campaign_Source__c,DC_Lead_Source__c,Source_Journey__c,Knew_about_Design_Cafe_Because__c,
                             DSA_Code__c,DSA__c,CMM_Name__c,Referee_Name__c,Referee_Email_ID__c,Referee_Code__c,Referee_Number__c,Floor_Plan_Link_from_Chatbot__c,
                             Referrer_City__c,EmployeeCode__c,Re_Contact_Date__c,Street,Requirement_Details__c,Approx_Budget__c,Scope_Of_Work__c,
                             isconverted,MobilePhone,Whatsapp_Opt_IN__c,Willingness_For_Meeting__c,LastModifiedDate,Lead_Owner_Name__c,Lead_Owner_Mobile__c
                             from Lead WHERE APIMOBILE__c =:LeadWrapperObj.Mobile Limit 1];
            
            IF(ld.size() != 0){ 
                // Take the Fields that are mandatory for Lead, from the lead object IFF they're not present in the request body.
                LeadWrapperobj.Region = (LeadWrapperobj.Region == NULL) ? ld[0].City : LeadWrapperobj.Region;
                LeadWrapperobj.Last_Name = (LeadWrapperobj.Last_Name == NULL) ? ld[0].LastName : LeadWrapperobj.Last_Name;
                LeadWrapperobj.Mobile = (LeadWrapperobj.Mobile == NULL) ? ld[0].MobilePhone : LeadWrapperobj.Mobile;
                
                //---------------------------------------------- Updating Existing Records------------------------------------------------//
                //---------------- Attribution DSA(1) ------------------------------//
                
                if((ld[0].Status == 'Connected' && LeadWrapperobj.dsaid!=Null && (ld[0].Follow_Up_Date_Time__c < system.today().addDays(-29) || ld[0].LastModifiedDate < system.today().addDays(-29)))||
                   (ld[0].Status == 'New' && LeadWrapperobj.dsaid!=Null && ld[0].CreatedDate < Date.today().addDays(-30))||
                   (ld[0].Status =='Not Connected' && LeadWrapperobj.dsaid!=Null && (ld[0].Follow_Up_Date_Time__c < system.today().addDays(-29) || ld[0].LastModifiedDate < system.today().addDays(-29)))
                  ){
                      Lead LeadObj = new Lead();
                      LeadObj.id = ld[0].id;
                      LeadObj.DC_Lead_Status__c = 'Recontacted';
                      LeadObj.Re_Contact_Date__c = System.now();  
                      LeadObj.DSA_Code__c = LeadWrapperobj.dsaid;
                      
                      
                      LeadObj.Referee_Name__c = null;
                      LeadObj.Referee_Email_ID__c = null;
                      LeadObj.Referee_Code__c = null;
                      LeadObj.Referee_Number__c = null;
                      LeadObj.Referrer_City__c = null;
                      LeadObj.EmployeeCode__c = null;

                       // Changes Start 03-03-2023 Vikas
                      if (!(ld[0].Status == 'New' && ld[0].DC_Lead_Status__c == 'Undialed' && ld[0].Call_Stage__c == 'Undialed') ) {
                           LeadObj.Old_Source__c = ld[0].Source__c;
                           LeadObj.Channel__c = 'Offline';
                           LeadObj.Source__c  = 'DSA';
                           LeadObj.DC_Campaign_Source__c = null;
                           LeadObj.DC_Lead_Source__c = null;
                      }
                       // Changes End 03-03-2023 Vikas
                      
                      update LeadObj;

                      

                      response.message = 'Submitted Successfully(Attribution Updated - 1)';
                      response.status  = 'Success';
                      response.recordId = LeadObj.id;
                  }    
                //---------------- Attribution DSA(1) ------------------------------//
                //---------------- Logic 1 ------------------------------//
                else if(LeadWrapperobj.dsaid!=Null){
                    Lead LeadObj = new Lead();
                    LeadObj.id = ld[0].id;
                    LeadObj.DC_Lead_Status__c = 'Recontacted';
                    LeadObj.Re_Contact_Date__c = System.now();   
                    update LeadObj;
                    response.message = 'Updated Successfully -1[Record Already Exists]';
                    response.status  = 'Success';
                    response.recordId = LeadObj.id;
                }    
                //---------------- Logic 1 ------------------------------// 
                //---------------- Logic 2 ------------------------------//
                
                else if(
                    (ld[0].Status == 'New' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29))) ||
                    (ld[0].Status == 'Connected' && ld[0].DC_Lead_Status__c == 'Pre-qualified' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29))) ||
                    (ld[0].Status == 'Connected' && ld[0].DC_Lead_Status__c == 'Qualified' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29))) ||
                    (ld[0].Status == 'Connected' && ld[0].DC_Lead_Status__c == 'Followup' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29))) ||
                    (ld[0].Status == 'Connected' && ld[0].DC_Lead_Status__c == 'Junk' && LeadWrapperObj.MS_Date_Time != Null )||
                    (ld[0].Status == 'Connected' && ld[0].DC_Lead_Status__c == 'Recontacted' && LeadWrapperObj.MS_Date_Time != Null )||
                    (ld[0].Status == 'Connected' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29)))||
                    (ld[0].Status == 'Not Connected' && LeadWrapperObj.MS_Date_Time != Null && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29))) 
                ){
                    system.debug('85: ld[0].follow_up_date_time__c : ' + ld[0].follow_up_date_time__c + ' ld[0].LastModifiedDate : ' + ld[0].LastModifiedDate);
                    Lead LeadObj  = New Lead();
                    LeadObj.id                                  = ld[0].id;
                    LeadObj.FirstName                           = LeadWrapperObj.First_Name;
                    LeadObj.LastName                            = LeadWrapperObj.Last_Name;
                    If(LeadObj.LastName==Null){
                        LeadObj.LastName ='.';
                    }
                    LeadObj.MobilePhone                         = LeadWrapperObj.Mobile;
                    LeadObj.Status                              = 'Meeting Scheduled';
                    LeadObj.DC_Lead_Status__c                   = 'Meeting Scheduled';
                    LeadObj.Call_Stage__c                       = 'Meeting Scheduled';
                    LeadObj.Willingness_For_Meeting__c          = LeadWrapperObj.MS_Date_Time;
                    LeadObj.Meeting_Type__c                     = LeadWrapperObj.Meeting_Type;
                    LeadObj.Meeting_Venue__c                    = LeadWrapperObj.Meeting_Venue;
                    LeadObj.Email                               = LeadWrapperObj.Email;
                    LeadObj.Country_Code__c                     = LeadWrapperObj.Country_Code;
                    LeadObj.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                    LeadObj.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                    LeadObj.Voucher_Code__c                     = LeadWrapperobj.Voucher_Code;
                    Leadobj.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                    LeadObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;          
                    LeadObj.GClid__c                            = LeadWrapperobj.gclid;
                    LeadObj.FBCLID__c                           = LeadWrapperobj.fbclid;
                    LeadObj.Project_Name__c                     = LeadWrapperobj.Project_Name;
                    LeadObj.Floor_Plan_Link_from_Chatbot__c     = LeadWrapperobj.YM_FloorPlan;
                    LeadObj.Approx_Budget__c                    = LeadWrapperobj.Approx_Budget;
                    LeadObj.Area__c                             = LeadWrapperobj.Area;
                    LeadObj.Device_Name__c                      = LeadWrapperobj.DeviceName;
                    LeadObj.Campagin__c                         = LeadWrapperobj.Campagin ;
                    LeadObj.Ad_Group__c                         = LeadWrapperobj.AdGroup;
                    LeadObj.Keyword__c                          = LeadWrapperobj.Keyword;
                    LeadObj.Match_Type__c                       = LeadWrapperobj.MatchType ;
                    LeadObj.Ad_Name__c                          = LeadWrapperobj.AdName ;
                    LeadObj.User_Browser__c                     = LeadWrapperobj.User_Browser;
                    LeadObj.IPAddress__c                        = LeadWrapperobj.Ip_Address;
                    LeadObj.Time_On_Last_page__c                = LeadWrapperobj.Time_On_Last_page;
                    LeadObj.First_Visit_Time__c                 = LeadWrapperobj.First_Visit_Time;
                    LeadObj.Page__c                             = LeadWrapperobj.Pages_Visited;   
                    LeadObj.User_Last_Url__c                    = LeadWrapperobj.User_Last_Url;
                    LeadObj.Entry_Url__c                        = LeadWrapperobj.Entry_Url;
                    LeadObj.User_OS__c                          = LeadWrapperobj.User_OS;
                    LeadObj.How_did_you_hear_about_us__c        = LeadWrapperobj.How_did_you_hear_about_us;
                    LeadObj.Description                         = LeadWrapperobj.Notes; 
                    LeadObj.PostalCode                          = LeadWrapperobj.Area_Code;
                    LeadObj.Customer_Pincode__c					= LeadWrapperobj.Customer_Pincode;
                    LeadObj.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    LeadObj.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    If(LeadWrapperobj.Property_Possession_Date!=Null){
                        LeadObj.Property_Possession_Date__c     = Date.valueOf(LeadWrapperobj.Property_Possession_Date.replace('/','-'));
                    }

                    

                    response.message = 'Updated Successfully - 2';
                    response.status  = 'Success';
                    response.recordId = LeadObj.id;
                }
                //---------------- Logic 2 ------------------------------//
                //---------------- Attribution (5) ------------------------------//
                else if(
                    (ld[0].Status == 'New' && LeadWrapperObj.MS_Date_Time != Null)|| (ld[0].Status == 'Connected' && LeadWrapperObj.MS_Date_Time != Null)|| (ld[0].Status == 'Not Connected' && LeadWrapperObj.MS_Date_Time != Null)){
                        Lead LeadObj  = New Lead();
                        LeadObj.id                                 = ld[0].id;
                        LeadObj.LastName                           = LeadWrapperObj.Last_Name;
                        If(LeadObj.LastName==Null){
                            LeadObj.LastName ='.';
                        }
                        LeadObj.MobilePhone                         = LeadWrapperObj.Mobile;
                        LeadObj.Status                              = 'Meeting Scheduled';
                        LeadObj.DC_Lead_Status__c                   = 'Meeting Scheduled';
                        LeadObj.Call_Stage__c                       = 'Meeting Scheduled';
                        LeadObj.Willingness_For_Meeting__c          = LeadWrapperObj.MS_Date_Time;
                        LeadObj.Meeting_Type__c                     = LeadWrapperObj.Meeting_Type;
                        LeadObj.Meeting_Venue__c                    = LeadWrapperObj.Meeting_Venue;
                        Leadobj.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                        LeadObj.Email                               = LeadWrapperObj.Email;
                        LeadObj.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                        LeadObj.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                        LeadObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;          
                        LeadObj.Project_Name__c                     = LeadWrapperobj.Project_Name;
                        LeadObj.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                        LeadObj.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                        If(LeadWrapperobj.Property_Possession_Date!=Null){
                            LeadObj.Property_Possession_Date__c     = Date.valueOf(LeadWrapperobj.Property_Possession_Date.replace('/','-'));
                        }
                       
                        
                        
                        
                        
                        LeadObj.Source_Journey__c                   = LeadWrapperobj.Source_Journey;
                        if(LeadWrapperobj.Channel_Type == 'Online' || LeadWrapperobj.Channel_Type == 'Affiliate'){
                            LeadObj.DSA_Code__c = null;
                            LeadObj.DSA__c = null;
                            LeadObj.CMM_Name__c = null;
                            LeadObj.Referee_Name__c = null;
                            LeadObj.Referee_Email_ID__c = null;
                            LeadObj.Referee_Code__c = null;
                            LeadObj.Referee_Number__c = null;
                            LeadObj.Referrer_City__c = null;
                            LeadObj.EmployeeCode__c = null;
                        }

                        // Changes Start 03-03-2023 Vikas
                        if (!(ld[0].Status == 'New' && ld[0].DC_Lead_Status__c == 'Undialed' && ld[0].Call_Stage__c == 'Undialed') ) {
                            LeadObj.Old_Source__c = ld[0].Source__c;
                            LeadObj.Channel__c = LeadWrapperobj.Channel_Type;
                            LeadObj.Source__c = LeadWrapperobj.Lead_Type;
                            LeadObj.DC_Campaign_Source__c = LeadWrapperobj.Campaign_Source1;
                            LeadObj.DC_Lead_Source__c = LeadWrapperobj.Lead_Source;
                        }
                        // changes End 03-03-2023 Vikas

                        update LeadObj;
                        response.message = 'Submitted Successfully(Attribution Updated - 5)';
                        response.status  = 'Success';
                        response.recordId = LeadObj.id;
                    }
                //---------------- Attribution 5 ------------------------------//
                
                //---------------- Logic 3 ------------------------------//
                else if((ld[0].Status == 'Meeting Scheduled' && ld[0].DC_Lead_Status__c == 'Meeting Scheduled') && LeadWrapperObj.MS_Date_Time != Null){
                    System.debug('ld[0].Status : '+ld[0].Status + ' ... LeadWrapperObj.MS_Date_Time : ' + LeadWrapperObj.MS_Date_Time);
                    Lead ldl = new Lead();
                    ldl.id = ld[0].id;
                    ldl.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    ldl.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    ldl.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    ldl.DC_Lead_Status__c = 'Meeting Rescheduled';
                    ldl.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                    ldl.Whatsapp_Opt_IN__c = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    ldl.Civil_Work__c = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    ldl.Page_URL__c = LeadWrapperobj.Page_URL1;
                    update ldl;
                    response.message = 'Updated Successfully - 3';
                    response.status  = 'Success';
                    response.recordId = ldl.id;
                }
                //---------------- Logic 3 ------------------------------//
                
                //---------------- Logic 9 ------------------------------//
                else if(ld[0].Status == 'Meeting Scheduled' && (ld[0].DC_Lead_Status__c == 'Meeting Scheduled' || ld[0].DC_Lead_Status__c == 'Meeting Rescheduled') ){
                    Lead ldl = new Lead();
                    ldl.id = ld[0].id;
                    //    ldl.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    //     ldl.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    //    ldl.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    ldl.DC_Lead_Status__c = 'Recontacted';
                    ldl.Re_Contact_Date__c = System.now();
                    ldl.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                    ldl.GClid__c = LeadWrapperobj.gclid;
                    ldl.FBCLID__c = LeadWrapperobj.fbclid;
                    ldl.Whatsapp_Opt_IN__c = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    ldl.Civil_Work__c = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    ldl.Page_URL__c = LeadWrapperobj.Page_URL1;
                    update ldl;
                    response.message = 'Updated Successfully - 9';
                    response.status  = 'Success';
                    response.recordId = ldl.id;
                }
                //---------------- Logic 9 ------------------------------//  
                
                //---------------- Logic 4 ------------------------------//
                else if((ld[0].Status == 'Meeting Confirmed' && (ld[0].DC_Lead_Status__c == 'Meeting Rescheduled' || ld[0].DC_Lead_Status__c == 'Lost Prospect' || ld[0].DC_Lead_Status__c == 'Follow-UP' || ld[0].DC_Lead_Status__c == 'Recontacted')) && LeadWrapperObj.MS_Date_Time != Null){
                    Lead ldl = new Lead();
                    ldl.id = ld[0].id;
                    ldl.DC_Lead_Status__c = 'Recontacted';
                    ldl.Re_Contact_Date__c = System.now();
                    ldl.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    ldl.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    ldl.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    ldl.Whatsapp_Opt_IN__c = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    ldl.Civil_Work__c = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    ldl.Page_URL__c = LeadWrapperobj.Page_URL1;
                    update ldl;
                    response.message = 'Updated Successfully - 4';
                    response.status  = 'Success';
                    response.recordId = ldl.id;
                }
                //---------------- Logic 4 ------------------------------// 
                
                //---------------- Logic 10 ------------------------------//
                else if(ld[0].Status == 'Meeting Confirmed'){
                    Lead ldl = new Lead();
                    ldl.id = ld[0].id;
                    ldl.DC_Lead_Status__c = 'Recontacted';
                    ldl.Re_Contact_Date__c = System.now();
                    //        ldl.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    //        ldl.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    //        ldl.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    ldl.Whatsapp_Opt_IN__c = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    ldl.Civil_Work__c = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    ldl.GClid__c = LeadWrapperobj.gclid;
                    ldl.FBCLID__c = LeadWrapperobj.fbclid;
                    ldl.Page_URL__c = LeadWrapperobj.Page_URL1;
                    update ldl;
                    response.message = 'Updated Successfully - 10';
                    response.status  = 'Success';
                    response.recordId = ldl.id;
                }
                //---------------- Logic 10 ------------------------------//         
                
                //---------------- Logic 5 ------------------------------//
                else if(ld[0].Call_Stage__c == 'Undialed' && ld[0].CreatedDate < Date.today().addDays(-5)) {
                    System.debug('Lead--- Creation');
                    Lead led = new Lead();
                    led.id = ld[0].id;
                    led.DC_Lead_Status__c = 'Recontacted';
                    led.Re_Contact_Date__c = System.now();
                    led.Page_URL__c = LeadWrapperobj.Page_URL1; 
                    led.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    led.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    led.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    led.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                    //========================//   
                    
                       
                    
                    
                    led.Source_Journey__c = LeadWrapperobj.Source_Journey;
                    
                    led.Knew_about_Design_Cafe_Because__c = LeadWrapperobj.KnewAboutDesignCafeBecause;

                    // Changes Start 03-03-2023 Vikas
                    if (!(ld[0].Status == 'New' && ld[0].DC_Lead_Status__c == 'Undialed' && ld[0].Call_Stage__c == 'Undialed') ) {
                        led.Old_Source__c = ld[0].Source__c;
                        led.Channel__c = LeadWrapperobj.Channel_Type; 
                        led.Source__c = LeadWrapperobj.Lead_Type;
                        led.DC_Campaign_Source__c = LeadWrapperobj.Campaign_Source1;
                        led.DC_Lead_Source__c = LeadWrapperobj.Lead_Source;
                    }
                    // Changes End 03-03-2023 Vikas

                    if(LeadWrapperobj.Channel_Type == 'Online'){
                        led.DSA_Code__c = null;
                        led.DSA__c = null;
                        led.CMM_Name__c = null;
                        led.Referee_Name__c = null;
                        led.Referee_Email_ID__c = null;
                        led.Referee_Code__c = null;
                        led.Referee_Number__c = null;
                        led.Referrer_City__c = null;
                        led.EmployeeCode__c = null;
                    }
                    if(LeadWrapperobj.Channel_Type == 'Referral'){
                        led.Referee_Name__c = LeadWrapperobj.RefferedName;
                        led.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        led.Referee_Code__c = LeadWrapperobj.ReffaralCode;
                        led.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        led.Referrer_City__c = LeadWrapperobj.Ref_City;
                        led.EmployeeCode__c = LeadWrapperobj.EmpCode;
                        led.DSA__c = null;
                        led.DSA_Code__c = null;
                        led.CMM_Name__c = null;
                    }
                    if(LeadWrapperobj.EmpCode != null){   
                        led.Old_Source__c = ld[0].Source__c;
                        led.Referee_Name__c = LeadWrapperobj.RefferedName;
                        led.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        led.Referee_Code__c = LeadWrapperobj.EmpCode;
                        led.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        led.Referrer_City__c = LeadWrapperobj.Ref_City;
                        led.EmployeeCode__c = LeadWrapperobj.EmpCode;
                        led.DSA__c = null;
                        led.DSA_Code__c = null;
                        led.CMM_Name__c = null;
                        led.Channel__c = 'Referral';    
                        led.Source__c = 'Referral';
                        led.DC_Campaign_Source__c = 'Referral';
                        led.DC_Lead_Source__c = 'Employee referral';   
                    }
                    if(LeadWrapperobj.Messaging_Source!= null){
                        led.Messaging_Source__c = LeadWrapperobj.Messaging_Source;
                    }

                    

                    
                    //=====================//
                    update led;
                    System.debug('Lead--- Creation -- Done');
                    response.message = 'Updated Successfully - 5';
                    response.status  = 'Success';
                    response.recordId = led.id;
                } 
                //---------------- Logic 5 ------------------------------//
                
                //---------------- Attribution (2) ------------------------------//
                else if(ld[0].DC_Lead_Status__c == 'Junk' && ld[0].Messaging_Source__c == null) {
                    Lead jl = new Lead();
                    jl.Id = ld[0].id;
                    jl.Re_Contact_Date__c = System.now();
                    jl.Status = 'Connected';
                    jl.DC_Lead_Status__c = 'Recontacted';
                    jl.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    jl.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    jl.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    jl.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                    jl.Page_URL__c = LeadWrapperobj.Page_URL1;
                    jl.Old_Source__c = ld[0].Source__c;
                    jl.Channel__c = LeadWrapperobj.Channel_Type;    
                    jl.Source__c = LeadWrapperobj.Lead_Type;
                    jl.DC_Lead_Source__c = LeadWrapperobj.Lead_Source;
                    jl.Source_Journey__c = LeadWrapperobj.Source_Journey;
                    jl.DC_Campaign_Source__c = LeadWrapperobj.Campaign_Source1;
                    jl.Knew_about_Design_Cafe_Because__c = LeadWrapperobj.KnewAboutDesignCafeBecause;
                    if(LeadWrapperobj.Channel_Type == 'Online'){
                        jl.DSA_Code__c = null;
                        jl.DSA__c = null;
                        jl.CMM_Name__c = null;
                        jl.Referee_Name__c = null;
                        jl.Referee_Email_ID__c = null;
                        jl.Referee_Code__c = null;
                        jl.Referee_Number__c = null;
                        jl.Referrer_City__c = null;
                        jl.EmployeeCode__c = null;
                    }
                    if(LeadWrapperobj.Channel_Type == 'Referral'){
                        jl.Referee_Name__c = LeadWrapperobj.RefferedName;
                        jl.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        jl.Referee_Code__c = LeadWrapperobj.ReffaralCode;
                        jl.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        jl.Referrer_City__c = LeadWrapperobj.Ref_City;
                        jl.EmployeeCode__c = LeadWrapperobj.EmpCode;
                        jl.DSA__c = null;
                        jl.DSA_Code__c = null;
                        jl.CMM_Name__c = null;
                    }
                    if(LeadWrapperobj.EmpCode != null){
                        jl.Old_Source__c = ld[0].Source__c;
                        jl.Referee_Name__c = LeadWrapperobj.RefferedName;
                        jl.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        jl.Referee_Code__c = LeadWrapperobj.EmpCode;
                        jl.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        jl.Referrer_City__c = LeadWrapperobj.Ref_City;
                        jl.EmployeeCode__c = LeadWrapperobj.EmpCode;
                        jl.DSA__c = null;
                        jl.DSA_Code__c = null;
                        jl.CMM_Name__c = null;
                        jl.Channel__c = 'Referral';    
                        jl.Source__c = 'Referral';
                        jl.DC_Campaign_Source__c = 'Referral';
                        jl.DC_Lead_Source__c = 'Employee referral';
                    }  
                    if(LeadWrapperobj.Messaging_Source!= null){
                        jl.Messaging_Source__c = LeadWrapperobj.Messaging_Source;
                    }
                    update jl;
                    response.message  = 'Submitted Successfully(Attribution Updated - 2)(Junk Record)';
                    response.status   = 'Success';
                    response.recordId = jl.id;
                }
                //---------------- Attribution (2) ------------------------------//
                //---------------- Attribution (3) ------------------------------//
                else if(ld[0].Messaging_Source__c != null &&
                        ((ld[0].Status == 'Connected' && (ld[0].Follow_Up_Date_Time__c < system.today().addDays(-29) || ld[0].LastModifiedDate < system.today().addDays(-29)))||
                         (ld[0].Call_Stage__c == 'Undialed')||
                         (ld[0].Status =='Not Connected' && (ld[0].Follow_Up_Date_Time__c < system.today().addDays(-29) || ld[0].LastModifiedDate < system.today().addDays(-29))))
                       ){
                           Lead lds = new Lead();
                           lds.Id                                  = ld[0].Id;
                           lds.LastName                            = LeadWrapperobj.Last_Name;
                           lds.MobilePhone                         = LeadWrapperobj.Mobile;
                          
                           lds.Re_Contact_Date__c                  = System.now(); 
                           lds.Whatsapp_Opt_IN__c                  = LeadWrapperobj.Whatsapp_OptIN;
                           lds.Email                               = LeadWrapperObj.Email;
                           lds.Country_Code__c                     = LeadWrapperObj.Country_Code;
                           lds.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                           lds.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                           lds.Scope_Of_Work__c                    = LeadWrapperobj.Scope_Of_Work;
                           lds.Approx_Budget__c                    = LeadWrapperobj.Approx_Budget;
                           lds.Requirement_Details__c              = LeadWrapperobj.Requirement_Details;
                           lds.Meeting_Type__c                     = LeadWrapperobj.Meeting_Type;
                           lds.Meeting_Venue__c                    = LeadWrapperobj.Meeting_Venue;
                           lds.Willingness_For_Meeting__c          = LeadWrapperobj.MS_Date_Time;
                           lds.Street                              = LeadWrapperobj.Street;   
                           lds.Messaging_Source__c                 = LeadWrapperobj.Messaging_Source;          
                           lds.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                           lds.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                           lds.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;  
                           lds.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                           
                           if(LeadWrapperobj.Channel_Type == 'Online'){
                               
                               lds.DSA_Code__c = null;
                               lds.DSA__c = null;
                               lds.CMM_Name__c = null;
                               lds.Referee_Name__c = null;
                               lds.Referee_Email_ID__c = null;
                               lds.Referee_Code__c = null;
                               lds.Referee_Number__c = null;
                               lds.Referrer_City__c = null;
                               lds.EmployeeCode__c = null;

                               // Changes Start 03-03-2023 Vikas
                               if (!(ld[0].Status == 'New' && ld[0].DC_Lead_Status__c == 'Undialed' && ld[0].Call_Stage__c == 'Undialed') ) {
                                    lds.Old_Source__c = ld[0].Source__c;
                                    lds.Channel__c = LeadWrapperobj.Channel_Type;
                                    lds.Source__c = LeadWrapperobj.Lead_Type;
                                    lds.DC_Campaign_Source__c = LeadWrapperobj.Campaign_Source1;
                                    lds.DC_Lead_Source__c = LeadWrapperobj.Lead_Source;
                               }
                                // Changes End  03-03-2023 Vikas
                               lds.Messaging_Source__c = LeadWrapperobj.Messaging_Source;

                           }
                           lds.DC_Lead_Status__c = 'Recontacted';
                           Update lds;          
                           response.message  = 'Submitted Successfully(Attribution Updated - 3)';
                           response.status   = 'Success';
                           response.recordId = lds.id;
                           response.MS_DateTime = ld[0].Willingness_For_Meeting__c;
                       }  
                //---------------------- Attribution (3)-----------------------------------------------------   
                //------------------------- Logic 6 ----------------------------------------
                else if(ld[0].Messaging_Source__c != null){
                    Lead lds = new Lead();
                    lds.Id                                  = ld[0].Id;
                    lds.LastName                            = LeadWrapperobj.Last_Name;
                    lds.MobilePhone                         = LeadWrapperobj.Mobile;
                    lds.Whatsapp_Opt_IN__c                  = LeadWrapperobj.Whatsapp_OptIN;
                    lds.DC_Lead_Status__c                   = 'Recontacted';
                    lds.Re_Contact_Date__c                  = System.now(); 
                    lds.Email                               = LeadWrapperObj.Email;
                    lds.Country_Code__c                     = LeadWrapperObj.Country_Code;
                    lds.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                    lds.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                    lds.Scope_Of_Work__c                    = LeadWrapperobj.Scope_Of_Work;
                    lds.Approx_Budget__c                    = LeadWrapperobj.Approx_Budget;
                    lds.Requirement_Details__c              = LeadWrapperobj.Requirement_Details;
                    lds.Meeting_Type__c                     = LeadWrapperobj.Meeting_Type;
                    lds.Meeting_Venue__c                    = LeadWrapperobj.Meeting_Venue;
                    lds.Willingness_For_Meeting__c          = LeadWrapperobj.MS_Date_Time;
                    lds.Street                              = LeadWrapperobj.Street;
                    lds.Messaging_Source__c                 = LeadWrapperobj.Messaging_Source;
                    lds.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                    lds.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                    lds.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;  
                    lds.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    Update lds;
                    response.message  = 'Updated Successfully -6';
                    response.status   = 'Success';
                    response.recordId = lds.id;
                    response.MS_DateTime = ld[0].Willingness_For_Meeting__c;
                }  
                //---------------------- Logic 6 -----------------------------------
                //---------------------- Logic 7 -----------------------
                else if((ld[0].Status == 'New' && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29)))||
                        (ld[0].Status == 'Connected'  && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29)))||
                        (ld[0].Status == 'Not Connected'  && (ld[0].follow_up_date_time__c == null ||(system.today().adddays(-29) < ld[0].follow_up_date_time__c &&  ld[0].follow_up_date_time__c < system.today())|| ld[0].LastModifiedDate > system.today().addDays(-29)))
                       ){
                           system.debug('499 : ld[0].LastModifiedDate : ' + ld[0].LastModifiedDate + ' . ld[0].CreatedDate : ' + ld[0].CreatedDate);
                           Lead l = new Lead();
                           l.id = ld[0].id;
                           l.DC_Lead_Status__c = 'Recontacted';
                           l.Re_Contact_Date__c = System.now();
                           l.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                           l.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                           l.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                           l.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                           l.GClid__c    = LeadWrapperobj.gclid;
                           l.FBCLID__c    = LeadWrapperobj.fbclid;
                           l.Page_URL__c = LeadWrapperobj.Page_URL1;
                           Update l;
                           response.message  = 'Updated Successfully -7';
                           response.status   = 'Success';
                           response.recordId = l.id;
                       }       
                               //---------------------- Logic 7 -------------------------------------------------------- 
                //-------------------Attribution (4) -------------------------------------------------  
                else if((ld[0].Status == 'New')||(ld[0].Status == 'Connected')||(ld[0].Status == 'Not Connected')){
                    Lead l = new Lead();
                    l.id = ld[0].id;
                    
                    l.Re_Contact_Date__c = System.now();
                    l.Willingness_For_Meeting__c = LeadWrapperobj.MS_Date_Time;
                    l.Meeting_Type__c = LeadWrapperobj.Meeting_Type;
                    l.Meeting_Venue__c = LeadWrapperobj.Meeting_Venue;
                    l.City = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region; 
                    l.GClid__c = LeadWrapperobj.gclid;
                    l.FBCLID__c = LeadWrapperobj.fbclid;
                    l.Page_URL__c      = LeadWrapperobj.Page_URL1;

                     // Changes Start 03-03-2023 Vikas
                    if (!(ld[0].Status == 'New' && ld[0].DC_Lead_Status__c == 'Undialed' && ld[0].Call_Stage__c == 'Undialed') ) {
                        l.Old_Source__c = ld[0].Source__c;
                        l.Channel__c = LeadWrapperobj.Channel_Type;    
                        l.Source__c = LeadWrapperobj.Lead_Type;
                        l.DC_Lead_Source__c = LeadWrapperobj.Lead_Source;
                        l.DC_Campaign_Source__c = LeadWrapperobj.Campaign_Source1;   
                    }
                     // Changes Start 03-03-2023 Vikas
                    
                    l.DC_Lead_Status__c = 'Recontacted';
                    l.Source_Journey__c = LeadWrapperobj.Source_Journey;
                    
                    if(LeadWrapperobj.Channel_Type == 'Online'){
                        l.DSA_Code__c = null;
                        l.DSA__c = null;
                        l.CMM_Name__c = null;
                        l.Referee_Name__c = null;
                        l.Referee_Email_ID__c = null;
                        l.Referee_Code__c = null;
                        l.Referee_Number__c = null;
                        l.Referrer_City__c = null;
                        l.EmployeeCode__c = null;
                    }
                    if(LeadWrapperobj.Channel_Type == 'Referral'){
                        l.Referee_Name__c = LeadWrapperobj.RefferedName;
                        l.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        l.Referee_Code__c = LeadWrapperobj.ReffaralCode;
                        l.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        l.Referrer_City__c = LeadWrapperobj.Ref_City;
                        l.DSA__c = null;
                        l.DSA_Code__c = null;
                        l.CMM_Name__c = null;
                    }
                    if(LeadWrapperobj.EmpCode != null){
                        l.Old_Source__c = ld[0].Source__c;
                        l.Referee_Name__c = LeadWrapperobj.RefferedName;
                        l.Referee_Email_ID__c = LeadWrapperobj.Referee_Email_ID;
                        l.Referee_Code__c = LeadWrapperobj.EmpCode;
                        l.Referee_Number__c = LeadWrapperobj.RefferedNumber;
                        l.Referrer_City__c = LeadWrapperobj.Ref_City;
                        l.EmployeeCode__c = LeadWrapperobj.EmpCode;
                        l.DSA__c = null;
                        l.DSA_Code__c = null;
                        l.CMM_Name__c = null;
                        l.Channel__c = 'Referral';    
                        l.Source__c = 'Referral';
                        l.DC_Campaign_Source__c = 'Referral';
                        l.DC_Lead_Source__c = 'Employee referral';
                    }
                    Update l;   
                    response.message  = 'Submitted Successfully(Attribution Updated - 4)';
                    response.status   = 'Success';
                    response.recordId = l.id;
                } 
                //--------------------Attribution (4) ----------------------------------------------------
                //--- Recontacted Functionality Ends(Update Existing Records)---------
                
                //------ Update Whatsapp OptIN in Account Starts ------------
                else if(ld[0].Status == 'Converted' || ld[0].isconverted == true){
                    Account acc = new Account();
                    acc.Id = ld[0].convertedAccountId;
                    acc.Whatsapp_Opt_IN__c = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                    update acc;
                    response.message  = 'Updated Successfully -8(Account Updated)';
                    response.status   = 'Success';
                    response.recordId = acc.id;
                }
                else if (LeadWrapperobj.Whatsapp_OptIN != NULL) {
                    // Change the Whatsapp_OptIn in all cases.
                    Lead l = new Lead();
                    l.id = ld[0].id;
                    l.Whatsapp_Opt_IN__c = LeadWrapperobj.Whatsapp_OptIN;
                    update l;
					response.message  = 'Whatsapp_Optin Updated Successfully -9(Lead Updated)';
                    response.status   = 'Success';
					response.recordId = l.id;
                }
                // Default Case
                else {
                    response.message  = 'Could not Update the lead (Default Case)';
                    response.status   = 'Error';
                }
                //------ Update Whatsapp OptIN in Account Ends ------------    
                //------------------------------------------- Updating Existing Records -----------------------------------------------//
            }
            //-------------------------------------------- Lead Insert Functionality Starts--------------------------------------------//
            //--- New Lead Insert Functionality(MS Date Time Present) Starts--------
            ELSE IF(LeadWrapperObj.MS_Date_Time != Null){              
                Lead LdObj  = New Lead();
                LdObj.FirstName                           = LeadWrapperObj.First_Name;
                LdObj.LastName                            = LeadWrapperObj.Last_Name;
                If(LdObj.LastName==Null){
                    LdObj.LastName ='.';
                }
                LdObj.MobilePhone                         = LeadWrapperObj.Mobile;
                LdObj.Status                              = 'Connected';
                LdObj.Project_Name__c                     = LeadWrapperobj.Project_Name;
                LdObj.Email                               = LeadWrapperObj.Email;
                LdObj.Country_Code__c                     = LeadWrapperObj.Country_Code;
                LdObj.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                LdObj.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                LdObj.Scope_Of_Work__c                    = LeadWrapperobj.Scope_Of_Work;
                LdObj.Approx_Budget__c                    = LeadWrapperobj.Approx_Budget;	
                LdObj.Requirement_Details__c              = LeadWrapperobj.Requirement_Details;
                LdObj.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                LdObj.Meeting_Type__c                     = LeadWrapperobj.Meeting_Type;
                LdObj.Meeting_Venue__c                    = LeadWrapperobj.Meeting_Venue;
                LdObj.Willingness_For_Meeting__c          = LeadWrapperobj.MS_Date_Time;
                LdObj.Street                              = LeadWrapperobj.Street;
                LdObj.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                LdObj.Channel__c                          = LeadWrapperobj.Channel_Type;
                LdObj.Source__c                           = LeadWrapperobj.Lead_Type;
                LdObj.Old_Source__c                       = LeadWrapperobj.Lead_Type;              
                LdObj.DC_Campaign_Source__c               = LeadWrapperobj.Campaign_Source1;
                LdObj.DC_Lead_Source__c                   = LeadWrapperobj.Lead_Source;
                LdObj.Messaging_Source__c                 = LeadWrapperobj.Messaging_Source;
                LdObj.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                LdObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                LdObj.Source_Journey__c                   = LeadWrapperobj.Source_Journey;
                LdObj.YMUrl__c                            = LeadWrapperobj.YM_Url; 
                LdObj.Floor_Plan_Link_from_Chatbot__c     = LeadWrapperobj.YM_FloorPlan;   
                
                If(LeadWrapperobj.Property_Possession_Date!=Null){
                    LdObj.Property_Possession_Date__c     = Date.valueOf(LeadWrapperobj.Property_Possession_Date.replace('/','-'));
                }
                LdObj.setOptions(dmlOpts);
                insert LdObj;
                res.StatusCode                              = 201;
                response.status                             = 'Success';
                response.recordId                           = LdObj.id;   
                response.message                            = 'Inserted Successfully - 1';    
            } 
            //--- New Lead Insert Functionality(MS Date Time Present) Ends--------
            
            //--- New Lead Insert Functionality(Whatsapp OptIN is true,Without MS Date Time) Starts--------
            ELSE IF((LeadWrapperObj.MS_Date_Time == Null && LeadWrapperObj.Messaging_Source =='WhatsApp')||
                    (LeadWrapperObj.MS_Date_Time == Null && LeadWrapperObj.Messaging_Source =='Chat')){
                        
                        Lead LedObj  = New Lead();
                        LedObj.FirstName                           = LeadWrapperObj.First_Name;
                        LedObj.LastName                            = LeadWrapperObj.Last_Name;
                        If(LedObj.LastName==Null){
                            LedObj.LastName ='.';
                        }
                        LedObj.MobilePhone                         = LeadWrapperObj.Mobile;
                        LedObj.Status                              = 'New';
                        LedObj.DC_Lead_Status__c                   = 'Undialed';
                        LedObj.Call_Stage__c                       = 'Undialed';
                        LedObj.Project_Name__c                     = LeadWrapperobj.Project_Name;            
                        LedObj.Email                               = LeadWrapperObj.Email;
                        LedObj.Country_Code__c                     = LeadWrapperObj.Country_Code;
                        LedObj.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                        LedObj.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                        LedObj.Scope_Of_Work__c                    = LeadWrapperobj.Scope_Of_Work;
                        LedObj.Approx_Budget__c                    = LeadWrapperobj.Approx_Budget;
                        LedObj.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                        LedObj.Requirement_Details__c              = LeadWrapperobj.Requirement_Details;
                        LedObj.Street                              = LeadWrapperobj.Street;
                        LedObj.Civil_Work__c                       = (LeadWrapperobj.Civil_Work == NULL? false:LeadWrapperobj.Civil_Work);
                        LedObj.Channel__c                          = LeadWrapperobj.Channel_Type;
                        LedObj.Source__c                           = LeadWrapperobj.Lead_Type;
                        LedObj.Old_Source__c                       = LeadWrapperobj.Lead_Type;            
                        LedObj.DC_Campaign_Source__c               = LeadWrapperobj.Campaign_Source1;
                        LedObj.DC_Lead_Source__c                   = LeadWrapperobj.Lead_Source;
                        LedObj.Messaging_Source__c                 = LeadWrapperobj.Messaging_Source;
                        LedObj.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                        LedObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                        LedObj.Source_Journey__c                   = LeadWrapperobj.Source_Journey;
                        LedObj.YMUrl__c                            = LeadWrapperobj.YM_Url;             
                        
                        If(LeadWrapperobj.Property_Possession_Date!=Null){
                            LedObj.Property_Possession_Date__c     = Date.valueOf(LeadWrapperobj.Property_Possession_Date.replace('/','-'));
                        }
                        LedObj.setOptions(dmlOpts);
                        insert LedObj;           
                        res.StatusCode                              = 201;
                        response.status                             = 'Success';
                        response.recordId                           = LedObj.id;            
                        response.message                            = 'Inserted Successfully - 2';    
                    }
            //--- New Lead Insert Functionality(Whatsapp OptIN is true, Without MS Date Time) Ends--------
            
            
            //--- DSA Lead Insert Starts ---------------------------------------------------------------------
            ELSE IF(LeadWrapperobj.dsaid!=Null){
                
                Lead LeadObj  = New Lead();
                LeadObj.LastName       = LeadWrapperObj.Last_Name;
                If(LeadObj.LastName==Null){
                    LeadObj.LastName ='.';
                }
                LeadObj.MobilePhone                         = LeadWrapperObj.Mobile;
                LeadObj.Status                              = 'New';
                LeadObj.DC_Lead_Status__c                   = 'Undialed';
                LeadObj.Call_Stage__c                       = 'Undialed';
                LeadObj.Email                               = LeadWrapperObj.Email;
                LeadObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                LeadObj.Project_Name__c                     = LeadWrapperobj.Project_Name;
                LeadObj.Area__c                             = LeadWrapperobj.Area;
                LeadObj.DSA_Code__c                         = LeadWrapperobj.dsaid;
                //  LeadObj.CMM_Name__c                         =LeadWrapperobj.CMM_Name;
                LeadObj.Description                         = LeadWrapperobj.Notes; 
                LeadObj.PostalCode                          = LeadWrapperobj.Area_Code;
                LeadObj.Customer_Pincode__c					= LeadWrapperobj.Customer_Pincode;

                If(LeadWrapperobj.dsaid!=Null){
                    if(LeadWrapperobj.dsaid == 'DCREF-0014568'||LeadWrapperobj.dsaid == 'DCREF-0019664'||LeadWrapperobj.dsaid == 'DCREF-0016264'||LeadWrapperobj.dsaid == 'DCREF-0015941'||LeadWrapperobj.dsaid == 'DCREF-0020557'){
                        LeadObj.Channel__c                      = 'Affiliate';
                        LeadObj.Source__c                       = 'Affiliate';
                        LeadObj.DC_Campaign_Source__c           = 'Affiliate';
                    }
                    if(LeadWrapperobj.dsaid == 'DCREF-0014568' ){
                        
                        LeadObj.DC_Lead_Source__c               = 'Full Basket Property';
                    }else if(LeadWrapperobj.dsaid == 'DCREF-0019664'){
                        
                        LeadObj.DC_Lead_Source__c               = 'Niladri Majumder';
                    }else if(LeadWrapperobj.dsaid == 'DCREF-0016264'){
                        
                        LeadObj.DC_Lead_Source__c               = 'Property Links';
                    }else if(LeadWrapperobj.dsaid == 'DCREF-0015941'){
                        
                        LeadObj.DC_Lead_Source__c               = 'RoofandFloor.com';  
                    }else if(LeadWrapperobj.dsaid == 'DCREF-0020557'){
                        
                        LeadObj.DC_Lead_Source__c               = 'Preeti Rana'; 
                    }
                    else{
                        LeadObj.Channel__c                      ='Offline';
                        LeadObj.Source__c                       = 'DSA';
                        LeadObj.Old_Source__c                   = 'DSA';
                    }
                }
                LeadObj.setOptions(dmlOpts);
                insert LeadObj;
                res.StatusCode                              = 201;
                response.status                             = 'Success';
                response.recordId                           = LeadObj.id;
                response.message                            = 'DSA Lead Submitted Successfully';
                integrationObj.Responce__c                  = Json.serialize(response);
                integrationObj.Responce_Code__c             = res.statusCode;
                integrationObj.leadId__c                    = LeadObj.id;
                insert integrationObj;    
            }
            //---- DSA Lead Insert Ends--------------------------------------------------------
            
            //---- New Lead Insert(Old Code) Starts ---------------
            ELSE{
                system.debug('Inside Else -- Insert New Record');
                Lead LeadObj  = New Lead();
                LeadObj.FirstName                          = LeadWrapperObj.First_Name;
                LeadObj.LastName                           = LeadWrapperObj.Last_Name;
                If(LeadObj.LastName==Null){
                    LeadObj.LastName ='.';
                }
                LeadObj.MobilePhone                         = LeadWrapperObj.Mobile;
                LeadObj.Status                              = 'New';
                LeadObj.Call_Stage__c                       = 'Undialed';
                LeadObj.DC_Lead_Status__c                  = 'Undialed';
                LeadObj.Email                               = LeadWrapperObj.Email;
                LeadObj.Country_Code__c                     = LeadWrapperObj.Country_Code;
                LeadObj.Property_Possession_Status__c       = LeadWrapperobj.Property_Possession_Status;
                LeadObj.Home_Type__c                        = LeadWrapperobj.Property_Type_for_Interior;
                
                If(LeadWrapperobj.Preferred_Slots_to_Contact!=Null){
                    LeadObj.Preferred_Time_to_Contact__c    = DateTime.valueOf(LeadWrapperobj.Preferred_Slots_to_Contact.replace('/','-')+':00').time();
                }
                LeadObj.Voucher_Code__c                     = LeadWrapperobj.Voucher_Code;
                LeadObj.Channel__c                          = LeadWrapperobj.Channel_Type;
                LeadObj.Source__c                           = LeadWrapperobj.Lead_Type;
                LeadObj.DC_Campaign_Source__c               = LeadWrapperobj.Campaign_Source1;
                LeadObj.DC_Lead_Source__c                   = LeadWrapperobj.Lead_Source;
                LeadObj.Messaging_Source__c                 = LeadWrapperobj.Messaging_Source;
                Leadobj.Page_URL__c                         = LeadWrapperobj.Page_URL1;
                LeadObj.City                                = LeadWrapperobj.Region=='Bangalore'?'Bengaluru':LeadWrapperobj.Region;
                LeadObj.Source_Journey__c                   = LeadWrapperobj.Source_Journey;
                LeadObj.Last_Source__c                      = LeadWrapperobj.Last_source;
                LeadObj.GClid__c                            = LeadWrapperobj.gclid;
                LeadObj.FBCLID__c                            = LeadWrapperobj.fbclid;
                LeadObj.Project_Name__c                     = LeadWrapperobj.Project_Name;
                LeadObj.Area__c                             = LeadWrapperobj.Area;
                LeadObj.EmployeeCode__c                     = LeadWrapperobj.EmpCode;
                LeadObj.DSA_Code__c                         = LeadWrapperobj.dsaid;
                LeadObj.Referee_Code__c                     = LeadWrapperobj.ReffaralCode;
                LeadObj.Referrer_City__c                    = LeadWrapperobj.Ref_City;
                LeadObj.Referee_Email_ID__c                 = LeadWrapperobj.Referee_Email_ID;
                LeadObj.Referee_Name__c                     = LeadWrapperobj.RefferedName;
                LeadObj.Referee_Number__c                   = LeadWrapperobj.RefferedNumber;
                LeadObj.Device_Name__c                      = LeadWrapperobj.DeviceName;
                LeadObj.Campagin__c                         = LeadWrapperobj.Campagin ;
                LeadObj.Ad_Group__c                         = LeadWrapperobj.AdGroup;
                LeadObj.Keyword__c                          = LeadWrapperobj.Keyword;
                LeadObj.Match_Type__c                       = LeadWrapperobj.MatchType ;
                LeadObj.Ad_Name__c                          = LeadWrapperobj.AdName ;
                LeadObj.Knew_about_Design_Cafe_Because__c   = LeadWrapperobj.KnewAboutDesignCafeBecause;
                LeadObj.User_Browser__c                     = LeadWrapperobj.User_Browser;
                LeadObj.IPAddress__c                        = LeadWrapperobj.Ip_Address;
                LeadObj.Time_On_Last_page__c                = LeadWrapperobj.Time_On_Last_page;
                LeadObj.First_Visit_Time__c                 = LeadWrapperobj.First_Visit_Time;
                LeadObj.Page__c                             = LeadWrapperobj.Pages_Visited;   
                LeadObj.User_Last_Url__c                    = LeadWrapperobj.User_Last_Url;
                LeadObj.Entry_Url__c                        = LeadWrapperobj.Entry_Url;
                LeadObj.User_OS__c                          = LeadWrapperobj.User_OS;
                LeadObj.How_did_you_hear_about_us__c        = LeadWrapperobj.How_did_you_hear_about_us;
                LeadObj.Description                         = LeadWrapperobj.Notes; 
                LeadObj.PostalCode                          = LeadWrapperobj.Area_Code;
                LeadObj.Customer_Pincode__c					= LeadWrapperobj.Customer_Pincode;
                LeadObj.Whatsapp_Opt_IN__c                  = (LeadWrapperobj.Whatsapp_OptIN == NULL? false:LeadWrapperobj.Whatsapp_OptIN);
                LeadObj.Old_Source__c                       = LeadWrapperobj.Lead_Type;
                
                If(LeadWrapperobj.Property_Possession_Date!=Null){
                    LeadObj.Property_Possession_Date__c     = Date.valueOf(LeadWrapperobj.Property_Possession_Date.replace('/','-'));
                }
                
                If(LeadWrapperobj.dsaid!=Null){
                    LeadObj.Channel__c                      ='Offline';
                }
                If(Leadobj.Page_URL__c !=Null && Leadobj.Page_URL__c.contains('walk-in') && String.isBlank(LeadObj.Referee_Name__c) && String.isBlank(LeadObj.Referee_Code__c) && String.isBlank(LeadObj.Referee_Number__c)){
                    LeadObj.Channel__c                      ='Branding';
                }
                If(!String.isblank(LeadObj.EmployeeCode__c) ||  !String.isBlank(LeadObj.Referee_Name__c) || !String.isBlank(LeadObj.Referee_Code__c) || !String.isBlank(LeadObj.Referee_Number__c)){
                    LeadObj.Channel__c                      = 'Referral';
                }
                If(!String.isblank(LeadObj.EmployeeCode__c)){
                    LeadObj.Channel__c                      = 'Referral';
                    LeadObj.Source__c                       = 'Referral';
                    LeadObj.DC_Campaign_Source__c           = 'Referral';
                    LeadObj.DC_Lead_Source__c               = 'Employee referral';
                    LeadObj.Old_Source__c                   = 'Referral';
                }
                LeadObj.setOptions(dmlOpts);
                Database.SaveResult svobj = Database.Insert(LeadObj);
                res.StatusCode                              = 201;
                response.status                             = 'Success';
                response.recordId                           = svobj.id;
                response.message                            = 'Submitted Successfully';
                integrationObj.Responce__c                  = Json.serialize(response);
                integrationObj.Responce_Code__c             = res.statusCode;
                integrationObj.leadId__c                    = svobj.id;
                insert integrationObj;    
            }
            //---- New Lead Insert(Old Code) Ends ---------------
            //------------------------------------Lead Insert Functionality Ends ------------------------------------------------------//
        }
        catch(Exception exc) {
            res.StatusCode                                  = 500;
            response.status                                 = 'Error';
            response.message                                = 'Your request failed with the following error: '+ exc.getMessage();
            integrationObj.Responce__c                      = Json.serialize(response);
            integrationObj.Responce_Code__c                 = res.statusCode;
            insert integrationObj;    
        }
        
        if (response.message == NULL) {
            response.message  = 'Could not Insert/Update the lead (Outside)';
            response.status   = 'Error';
        }
        if(response.message.contains('duplicate') && res.StatusCode==500){
            response.message = 'You\'re creating a duplicate lead. We recommend you use an existing one instead';
        }
        return response;   
    }

    global class PostResponseWrapper {
        String status;
        String message;
        String recordId;
        DateTime MS_DateTime;
        String sales_user;
        String sales_user_number;
        /*public PostResponseWrapper(){

}*/
    }
    
    public class LeadWrapper
    {
        public String First_Name;
        public String Country_Code;
        public String Last_Name;
        public String Mobile;
        public String Referee_Email_ID;
        public String Email;
        public String Ref_City;
        public String Property_Possession_Status;
        public String Property_Type_for_Interior;
        public String Preferred_Slots_to_Contact;
        public String Page_URL1;
        public String Voucher_Code;
        public String Channel_Type;
        public String Lead_Type;
        public String Campaign_Source1;
        public String Lead_Source;
        public String Messaging_Source;
        public Boolean Whatsapp_OptIN;
        public String Region;
        public String Source_Journey;
        public String Last_source;
        public String gclid;
        public String Project_Name;
        public String Area;
        // Public String CMM_Name;
        public String EmpCode;
        public String dsaid;
        public String ReffaralCode;  
        public String RefferedName;
        public String RefferedNumber;
        public String KnewAboutDesignCafeBecause;
        public String DeviceName;
        public String Campagin;
        public String AdGroup;
        public String Keyword;
        public String MatchType;
        public String AdName;
        public String SalesAgentEmail;
        public String Notes;
        public String Property_Possession_Date;
        public String User_Browser;
        public String Ip_Address;
        public String Time_On_Last_page;
        public String First_Visit_Time;
        public String Pages_Visited;
        public String User_Last_Url;
        public String Entry_Url;
        public String User_OS;
        public String How_did_you_hear_about_us;
        public String Scope_Of_Work;
        public String Approx_Budget;
        public String Requirement_Details;
        public String Lead_Status;
        public String Lead_Stage;
        public String Call_Stage;
        public String Meeting_Type;
        public String Meeting_Venue;
        public DateTime MS_Date_Time;
        public String Street;
        public Boolean Civil_Work;
        public String Area_Code;
        public String Customer_Pincode;
        public String YM_Url;
        public String YM_FloorPlan;	
        public String fbclid;
    }		
}