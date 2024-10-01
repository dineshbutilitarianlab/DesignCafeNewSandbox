@isTest
public class LeadTrigger_Handler_Test {
    public static void testSetup() {
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        insert SRRjpdc;
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        insert SRRthane;
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        insert SRROMRCH;
        
        SRR__c SRRHRBR = new SRR__c();
        SRRHRBR.Name = 'HRBRBLR';
        SRRHRBR.index__c = 0;
        insert SRRHRBR;
        
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        
        
        
        TriggerControl__c tc = new TriggerControl__c(Name = 'LeadTrigger', Run__c = true);
        insert tc;
        
        Design_User__c designUsers = new Design_User__c(
            Name = 'Test Design User 1',
            Designer_Dashboard_ID__c = '355',
            Role__c= 'Inhouse Designer',
            Email__c = 'test@gmail.com',
            Mobile__c = '7834764321',
            Region__c = 'Bengaluru',
            Experience_Center__c = 'HSRDC'   
        );
        
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New',
            LARR__c = false,
            bypassSMleadOwnervalidation__c = true,
            Design_User__c = designUsers.id,
            city = 'Bengaluru'
        );
        
        Lead testLead2 = new Lead(
            FirstName = 'Test2',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'New',
            LARR__c = false,
            bypassSMleadOwnervalidation__c = false,
            Design_User__c = designUsers.id,
            city = 'Mumbai'
        );
        
        insert testLead2;
        insert testLead;   
    }
    
    
    @isTest
    public static void LdTrigger1(){
        //testSetup();
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        // insert accDSA;
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        // insert accRef;
        // account acc=[select Referee_Code_DC__c from account where id=:accRef.id];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'exclusr',
            Email = 'excludeduser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'excludeduser@example.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            
            List<Lead> l = new List<Lead>();
            Lead ld = new Lead();
            ld.Channel__c = 'Online';
            ld.LastName = 'test';
            ld.FirstName = 'lead';
            ld.MiddleName = 'tesing';
            ld.Suffix = 'salesforce';
            ld.City = 'Bengaluru';
            ld.Email = 'Bengaluru@gmail.com';
            ld.DSA__c = accDSA.id;
            ld.DSA_Code__c = 'testing';
            ld.Designer__c = uDesign.Id;
            ld.Status='FollowUp';
            ld.DC_Lead_Status__c = 'New';
            ld.IsConverted = false;
            ld.Follow_Up_Date_Time__c = system.today()+5;
            ld.Property_Possession_Date__c = date.today();
            ld.LSQ_Lead_Related_ID__c = 'test';
            ld.Client_s_Budget__c = 30000;
            ld.Status = 'Followup';
            ld.Email = 'test@gmail.com';
            ld.Phone = '675432310';
            ld.LeadSource = 'Google AdWords';
            ld.NumberOfEmployees = 3;
            ld.Industry = 'Banking';
            ld.Campagin__c = 'test campagin';
            ld.Company = 'salechaa';
            ld.DoNotCall = false;
            ld.HasOptedOutOfEmail = true;
            ld.Fax = '123-455-7890';
            ld.HasOptedOutOfFax = false;
            ld.AnnualRevenue = 2300000;
            ld.Salutation = 'Mrs';
            ld.Rating = 'Hot';
            ld.Website = 'https://www.w3.org/Provider/Style/dummy.html';
            ld.Title = 'title';
            ld.Ad_Network__c = 'testnetwork';
            ld.Ad_Name__c = 'testName';//
            ld.AdWords_Mobile__c = '8976543231';
            ld.Affiliate_Name__c = 'affiliatename';
            ld.Agency__c = 'Syrow';
            ld.Age_of_First_kid__c = 'firstKid';
            ld.Age_of_Second_kid__c = 'secondKid2';
            ld.Age_of_Fourth_kid__c= 'fourthkid';
            ld.Age_of_Third_kid__c = 'thirdKid';
            ld.Alternate_Contact_Number__c = '8787654323';
            ld.Approx_Budget__c = '5L to 7L';
            ld.Attempt_Count__c = 20;
            ld.Bell_N1_Sent__c = false;
            ld.Bell_N2_Sent__c = false;
            ld.Bell_N3_Sent__c = false;
            ld.Broadcast_Status__c = '5';
            ld.bypassSMleadOwnervalidation__c = false;
            ld.BypassTimebasedWorkflow__c = true;
            ld.Cab_Req__c = 'No';
            ld.Call_Center_Agent__c = ld.OwnerId;  /*sho
            ld.Call_Center_Agent_Team__c = 'LTC-Bangalore;LTC Hyderabad;LTC Mumbai';
            ld.Call_Center_Agent_Region__c = 'Bengaluru;Mumbai;Hyderabad';
            ld.Call_Count__c = 2;
            ld.Callrecording__c = 'textrecording';
            ld.CallUniqueI__c = 'callText';
            ld.DC_Campaign_Source__c = 'Google AdWords';
            ld.Channel__c = 'Online';
            ld.Civil_Work__c = true;
            ld.Client_Site_visit__c = 'Completed';
            ld.CMM_Name__c = 'cmmName';
            ld.Country_Code__c = '7676456596';
            ld.Customer_Pincode__c = '876543';
            ld.Customer_Language_Preference__c = 'Kannada';
            ld.Date_When_Meeting_is_Scheduled__c = date.today();
            ld.DC_Home_Visit__c = 'Completed';
            ld.Delay_in_response__c = true;
            ld.Designers_TL_Email__c = 'test@gmail.com';
            ld.Designers_Email__c = 'test35@gmail.com';
            ld.Designer_Team_Name__c = 'designerName';
            ld.Designer_TL_s_Manager_Email__c = 'manager@test.com';
            ld.Device_Type__c = 'deviceType';
            ld.DialPad_Input_Knowlarity__c = 'dailpadInput';
            ld.Do_you_have_pets__c = 'doyouhave';
            ld.DSA_Category__c = 'Interior Designing Firm';
            ld.DSA_Code__c = '78782eed3';
            ld.DSA_Email__c = 'dsa@testing.com';
            ld.DUP_Update_Owner__c = false;
            ld.Eat__c = 'Cook at home';
            ld.EM4Hr__c = DateTime.now()+1;
            ld.Email_from_Data_Dump__c = 'emailfromData';
            ld.EmployeeCode__c = 'ee0934532';
            ld.Entry_Url__c = 'https://www.w3.org/dummy2.html';
            ld.File_Url__c = 'https://www.w3.org/dummy2.html';
            ld.First_Date_of_Contact__c = Date.today()+1;
            ld.First_Meeting_Date__c = Date.today();
            ld.First_Response_Actual__c = DateTime.now()+1;
            ld.floor_plan_attachment_id__c = '1631';
            ld.Area__c = '1200';
            ld.Floor_Area__c = '1233';
            ld.Floor_Plan_Link_from_Chatbot__c = 'testing';
            ld.Follow_Up_Count__c = 1;
            ld.Follow_Up_Date_Time__c = DateTime.now();
            ld.Fourth_Date_of_Contact__c =  Date.today()+1;
            ld.GCLID__c = 'example';
            ld.Gender_of_First_kid__c = 'test';
            ld.Gender_of_Third_kid__c = 'testing';
            ld.Gender_of_Fourth_kid__c = 'example';
            ld.Gender_of_Second_kid__c = 'second';
            ld.Has_Designer_Accepted__c = 'Designer Not Assigned';
            ld.Home_Type__c = 'Villa';
            ld.How_did_you_hear_about_us__c = 'Online';
            ld.How_many_kids_do_you_have__c = '4';
            ld.If_other_languages_please_specify__c = '3';
            ld.Inbound_Call__c = 'test';
            ld.Initial_Call_Stage__c  = 'example1';
            ld.Interior_work_needed_for__c = 'Modular Kitchen';
            ld.Is_Customer_Created__c = true;
            ld.Is_Bulk_Upload__c = true;
            ld.Is_Designer_Assigned__c = false;
            ld.Is_Lead_Update__c = true;
            ld.Is_MS__c = false;
            ld.Keyword__c = 'testing';
            ld.Knew_about_Design_Cafe_Because__c = 'Advertisements';
            ld.LARR__c = false;
            ld.Last_Source__c = 'Direct';
            ld.Lead_Allocation_Time__c = DateTime.now();
            ld.Lead_Allocation_time_to_SM__c = DateTime.now()+1;
            //ld.Lead_Designer_is_Current_User__c = false;
            ld.Lead_Generator__c = 'Gautam';
            ld.Lead_Qualified_for__c = 'Qarpentri';
            ld.Lead_Qualified_Date__c = Date.today();
            ld.DC_Lead_Source__c = 'Google Display Ads';
            ld.Moderator__c = '99 Acres';
            ld.Move_in__c = Date.today();
            ld.MS_Delay_in_response__c = false;
            ld.MS_First_Response_Actual__c = DateTime.now()+1;
            ld.MS_Follow_Up_Count__c = 1;
            ld.New_TimeStamp__c = DateTime.now();
            ld.NotConnected_TimeStamp__c = DateTime.now();
            ld.Offer_of_the_Month__c = 'DCOFFERCE';
            ld.Old_Source__c = 'testing';
            ld.Others_for_Live__c = 'test2';
            ld.Others_for_Play__c = 'example'; 
            ld.OTP_Verified__c = 'YES';
            ld.Owner__c = 'test2';
            ld.Page__c = 'testting';
            ld.PB_BS_0_or_2__c = true;
            ld.PB_BS_1_or_3_or_4__c = true;
            ld.PB_Design_user_assigned__c = true;
            ld.Play__c = 'Reading(C10 - Book unit)';
            ld.PPT_Uploaded__c = false;
            ld.Pre_Qualified_Date__c = Date.today()+1;
            ld.Pre_Qualified_FollowUp_Date__c = Date.today()+1;
            ld.Project_Name__c = 'projectTest';
            ld.Property_Address__c = 'addrees1';
            ld.Property_Possession_Date__c = Date.today();
            ld.Property_Possession_Status__c = 'Property due - this month';
            ld.RecordForDeletion__c = true;
            ld.Referrer_City__c = 'city';
            ld.Region__c = 'Chennai';
            ld.Scope_Of_Work__c = 'Partial renovation for your flat/house';
            ld.Secondary_Email__c = 'testing@gmail.com';
            ld.Second_Date_of_Contact__c = Date.today()+1;
            //ld.Site_Service_Needed_for__c = 'False Ceiling';
            ld.Source__c = 'Organic';
            ld.Source_Journey__c = 'testing';
            ld.Third_Date_of_Contact__c = Date.today();
            ld.Total_Call_Duration__c = 23;
            ld.Twitter__c = 'twitter';
            ld.Unread_Time__c =  DateTime.now();
            ld.User_Browser__c = 'userbrowser';
            ld.User_Last_Url__c = 'useUrl';
            ld.User_OS__c = 'userOs';
            ld.Voucher_Code__c = 'voucher1';
            ld.Whatsapp_Opt_IN__c = false;
            ld.When_would_you_like_to_have_the_home__c = '3 to 4 Months';
            ld.Who_will_be_staying_in_the_house__c = 'Parents';
            ld.Which_language_are_you_most_comfortable__c = 'kannada';
            ld.Who_will_be_staying_in_the_house__c = 'Parents';
            ld.Wohoo_Card__c = 'test';
            ld.Work__c = 'No';
            ld.XUID__c = 'test1';
            ld.Flat_Number__c = '123';
            ld.For_Reassignment__c = false;
            ld.IP_Address__c = 'test';
            ld.Lead_Source_Sub_Category__c = 'Google Display Ads';
            ld.Location__c = '';
            ld.Page_URL_1__c = 'testurl';
            ld.Page_Variant__c = 'tesing2';
            ld.Partner_Notification__c = true;
            ld.Property_Type__c = 'property1';
            ld.Property_Type_For_Interior__c = 'Flat';
            ld.Qualified_Status__c = '';
            ld.Recontacted__c = true;
            ld.Referral_Mobile__c = '8976567231';
            ld.Submission_Date_Time__c = DateTime.now()+1;
            ld.Units_Required__c = 112346;
            /*ld.Status ='New';
ld.Jigsaw = 'test';
ld.FBCLID__c = 'test';
ld.File_Name__c = 'filename';*/
            ld.Converted_TimeStamp__c = DateTime.now()+1;
            ld.Connected_TimeStamp__c = DateTime.now();
            ld.CMM_Team__c ='test';
            ld.First_Visit_Time__c = 'firstVisit';
            ld.Floor_Area__c = 'area1';
            ld.Live__c = 'Hosting friends for dinner (D10 - Crockery Unit should get selected)';
            ld.Lockdown_Survey__c = 'Considering finance/Emi';
            ld.Mass_email__c = false;
            ld.MeetingConfirmed_TimeStamp__c = DateTime.now();
            ld.Match_Type__c = 'test';
            ld.Meeting_Scheduled_By_Name__c = 'text1';
            ld.Meeting_Scheduled_by__c = 'text1';
            ld.Meeting_Scheduled_on_First_Call__c = true;
            ld.Meeting_Scheduled_Reminder__c = true;
            ld.MeetingScheduled_TimeStamp__c = DateTime.now()+1;
            ld.Meeting_Type__c = 'Site Visit';
            ld.Messaging_Source__c = 'WhatsApp';
            ld.Property_Name__c = 'test1';
            ld.Property_Usage__c = 'Rental';
            ld.Ready_for_Convert_Time__c = DateTime.now();
            ld.Ready_to_Convert__c = false;
            ld.Call_Stage__c = 'Undialed';
            ld.Re_Contact_Date__c = DateTime.now();
            ld.rejected_by__c = 'test1';
            ld.Time_On_Last_page__c = 'testing';
            ld.Is_Customer_Created__c = true;
            
            insert ld;
            
            Test.startTest();
            VDC_LeadProcesstoApex.firstRun = true;
            
            ld.Status = 'Working';
            update ld;
            
            Task t = new Task(IsReminderSet = true, whoId = ld.Id, status='Open');              
            insert t;
            ld.Region__c = ld.City;
            ld.LastName = 'test2';
            ld.FirstName = 'lead2';
            ld.MiddleName = 'tesing2';
            ld.Suffix = 'salesforce2';
            ld.Designer__c = uDesign.Id;
            ld.Meeting_Venue__c='MGDC';
            ld.Meeting_Type__c='EC';
            ld.Willingness_For_Meeting__c = date.today().addDays(5);
            ld.Status = 'Prospect';
            ld.DC_Lead_Status__c = 'Pre-qualified';
            ld.Description = 'Updated Description';
            ld.Email = 'test123@gmail.com';
            ld.Client_s_Budget__c = 20000;
            ld.Status = 'Junk';
            ld.Broadcast_Status__c = '0';
            ld.Phone = '7333231023';
            ld.LeadSource = 'Direct';
            ld.NumberOfEmployees = 2;
            ld.Industry = 'Apparel';
            ld.Campagin__c = 'test campagin2';
            ld.Company = 'Design Cafe';
            ld.DoNotCall = true;
            ld.HasOptedOutOfEmail = false;
            ld.Fax = '123-456-7890';
            ld.HasOptedOutOfFax = true;
            ld.AnnualRevenue = 1000000;
            ld.Salutation = 'Mr';
            ld.Rating = 'Warm';
            ld.Website = 'https://www.w3.org/Provider/Style2/dummy.html';
            ld.Title = 'title2';
            ld.Ad_Network__c = 'testnetwork2';
            ld.Ad_Name__c = 'testName2';
            ld.AdWords_Mobile__c = '8976543000';
            ld.Affiliate_Name__c = 'affiliatename2';
            ld.Agency__c = 'LT2';
            ld.Age_of_First_kid__c = 'firstKid2';
            ld.Age_of_Second_kid__c = 'secondKid';
            ld.Age_of_Fourth_kid__c= 'fourthkid2';
            ld.Age_of_Third_kid__c = 'thirdKid2';
            ld.Alternate_Contact_Number__c = '8787654786';
            ld.Approx_Budget__c = '10L to 12L';
            ld.Attempt_Count__c = 2;
            ld.Bell_N1_Sent__c = true;
            ld.Bell_N2_Sent__c = true;
            ld.Bell_N3_Sent__c = true;
            ld.Broadcast_Status__c = '6';
            ld.bypassSMleadOwnervalidation__c = true;
            ld.BypassTimebasedWorkflow__c = false;
            ld.Cab_Req__c = 'Yes';
            ld.Call_Center_Agent_Team__c = 'LTC-Bangalore;LTC-Bangalore-Offline;LTC Hyderabad;LTC Mumbai';
            ld.Call_Center_Agent_Region__c = 'Bengaluru;Mumbai;Hyderabad;Bengaluru;Mumbai;Hyderabad';
            ld.Call_Count__c = 4;
            ld.Callrecording__c = 'textrecording2';
            ld.CallUniqueI__c = 'callText2';
            ld.DC_Campaign_Source__c = 'Organic Search';
            ld.Channel__c = 'Offline';
            ld.Civil_Work__c = false;
            ld.Client_Site_visit__c = 'Requested';
            ld.CMM_Name__c = 'cmmName2';
            ld.MobilePhone = '8976543234';
            ld.Country_Code__c = '7676453896';
            ld.Customer_Pincode__c = '876565'; 
            ld.Customer_Language_Preference__c = 'English';
            ld.Date_When_Meeting_is_Scheduled__c = date.today().addDays(5);
            ld.DC_Home_Visit__c = 'Requested';
            ld.Delay_in_response__c = false;
            ld.Designers_TL_Email__c = 'test2@gmail.com';
            ld.Designers_Email__c = 'test3@gmail.com';
            ld.Designer_Team_Name__c = 'designerName2';
            ld.Designer_TL_s_Manager_Email__c = 'manager2@test.com';
            ld.Device_Type__c = 'deviceType2';
            ld.DialPad_Input_Knowlarity__c = 'dailpadInputknow';
            ld.Do_you_have_pets__c = 'doyouhavepets';
            ld.DSA_Category__c = 'Architect Firm';
            ld.DSA_Code__c = '882eed3';
            ld.DSA_Email__c = 'dsa@test.com';
            ld.DUP_Update_Owner__c = true;
            ld.Eat__c = 'Maid cooks all meals';
            ld.EM4Hr__c = DateTime.now();
            ld.Email_from_Data_Dump__c = 'emailfromDataDump';
            ld.EmployeeCode__c = 'eef9345321';
            ld.Entry_Url__c = 'https://www.w3.org/dummy.html';
            ld.File_Url__c = 'https://www.org/dum.html';
            ld.First_Date_of_Contact__c = Date.today();
            ld.First_Meeting_Date__c = Date.today()+1;
            ld.First_Response_Actual__c = DateTime.now();
            ld.floor_plan_attachment_id__c = '1632';
            ld.Area__c = '2200';
            ld.Floor_Area__c = '1233';
            ld.Floor_Plan_Link_from_Chatbot__c = 'testing';
            ld.Follow_Up_Count__c = 0;
            ld.Follow_Up_Date_Time__c = DateTime.now()+1;
            ld.Fourth_Date_of_Contact__c =  Date.today();
            ld.GCLID__c = 'example2';
            ld.Gender_of_First_kid__c = 'test2'; 
            ld.Gender_of_Third_kid__c = 'testing2';
            ld.Gender_of_Fourth_kid__c = 'example2';
            ld.Gender_of_Second_kid__c = 'second2';
            ld.Has_Designer_Accepted__c = 'Designer Accepted';
            ld.Home_Type__c = '2 BHK';
            ld.How_did_you_hear_about_us__c = 'Social Media';
            ld.How_many_kids_do_you_have__c = '2';
            ld.If_other_languages_please_specify__c = '2';
            ld.Inbound_Call__c = 'testing';
            ld.Initial_Call_Stage__c  = 'example';
            ld.Interior_work_needed_for__c = 'Living Room';
            ld.Is_Customer_Created__c = false;
            ld.Is_Bulk_Upload__c=false;
            ld.Is_Designer_Assigned__c = true;
            ld.Is_Lead_Update__c = false;
            ld.Is_MS__c = true;
            ld.Keyword__c = 'testing1';
            ld.Knew_about_Design_Cafe_Because__c = 'Article';
            ld.LARR__c = true;
            ld.Last_Source__c = 'AdWords';
            ld.Lead_Allocation_Time__c = DateTime.now()+1;
            ld.Lead_Allocation_time_to_SM__c = DateTime.now();
            //ld.Lead_Designer_is_Current_User__c = true;
            ld.Lead_Generator__c = 'Nikhil';
            ld.Lead_Qualified_for__c = 'Design Cafe';
            ld.Lead_Qualified_Date__c = Date.today();
            ld.DC_Lead_Source__c = 'Google Search Organic';
            ld.Moderator__c = 'AdCanopus';
            ld.Move_in__c = Date.today()+1;
            ld.MS_Delay_in_response__c = true;
            ld.MS_First_Response_Actual__c = DateTime.now();
            ld.MS_Follow_Up_Count__c = 10;
            ld.New_TimeStamp__c = DateTime.now()+1;
            ld.NotConnected_TimeStamp__c = DateTime.now()+1;
            ld.Offer_of_the_Month__c = 'DCOFFERCODE';
            ld.Old_Source__c = 'testing1';
            ld.Others_for_Live__c = 'test';
            ld.Others_for_Play__c = 'example1';
            ld.OTP_Verified__c = 'NO';
            ld.Owner__c = 'test';
            ld.Page__c = 'testting1';
            ld.PB_BS_0_or_2__c = false;
            ld.PB_BS_1_or_3_or_4__c = false;
            ld.PB_Design_user_assigned__c = false;
            ld.PB_Design_user_assigned__c = false;
            ld.Play__c = 'Cooking / Baking';
            ld.PPT_Uploaded__c = true;
            ld.Pre_Qualified_Date__c = Date.today();
            ld.Pre_Qualified_FollowUp_Date__c = Date.today();
            ld.Project_Name__c = 'projectTest1';
            ld.Property_Address__c = 'addrees123';
            ld.Property_Possession_Date__c = Date.today()+1;
            ld.Property_Possession_Status__c = 'Property in possession';
            ld.RecordForDeletion__c = false;
            ld.Referrer_City__c = 'city1';
            ld.Region__c ='Bengaluru';
            ld.Requirement_Details__c = 'TV Unit';
            ld.Scope_Of_Work__c = 'Complete interiors for your new flat/house';
            ld.Secondary_Email__c = 'test@gmail.com';
            ld.Second_Date_of_Contact__c = Date.today();
            //ld.Site_Service_Needed_for__c = 'Painting';
            ld.Source__c = 'Paid';
            ld.Source_Journey__c = 'test';
            ld.Third_Date_of_Contact__c = Date.today()+1;
            ld.Total_Call_Duration__c = 12;
            ld.Twitter__c = 'twitter2';
            ld.Unread_Time__c =  DateTime.now()+1;
            ld.User_Browser__c = 'browser';
            ld.User_Last_Url__c = 'useUrl1';
            ld.User_OS__c = 'userOs1';
            ld.Voucher_Code__c = 'voucher';
            ld.Whatsapp_Opt_IN__c = true;
            ld.When_would_you_like_to_have_the_home__c = '2 to 3 Months';
            ld.Who_will_be_staying_in_the_house__c = 'US';
            ld.Which_language_are_you_most_comfortable__c = 'telugu';
            ld.Who_will_be_staying_in_the_house__c = 'Us';
            ld.Work__c = 'Yes';
            ld.XUID__c = 'test';
            ld.Flat_Number__c = '1235';
            ld.For_Reassignment__c = true;
            ld.IP_Address__c = 'testing';
            ld.Lead_Source_Sub_Category__c = 'Google Search Ads';
            ld.Location__c = 'A';
            ld.Page_URL_1__c = 'testurl1';
            ld.Page_Variant__c = 'tesing';
            ld.Partner_Notification__c = false;
            ld.Property_Type__c = 'property';
            ld.Property_Type_For_Interior__c = 'Villa';
            ld.Qualified_Status__c = 'A';
            ld.Recontacted__c = false;
            ld.Referral_Mobile__c = '8976567643';
            ld.Submission_Date_Time__c = DateTime.now();
            ld.Units_Required__c = 11234;
            //ld.Status ='Connected';
            //ld.Status = 'Not Connected';
            //ld.Status = 'New';
            /*ld.Status = 'Meeting Confirmed';
ld.Jigsaw = 'test1';
ld.FBCLID__c = 'test1';
ld.File_Name__c = 'file';*/
            ld.CMM_Team__c ='test2';
            ld.First_Visit_Time__c = 'firstVisit1';
            ld.Converted_TimeStamp__c = DateTime.now();
            ld.Connected_TimeStamp__c = DateTime.now()+1;
            ld.Floor_Area__c = 'area';
            ld.Live__c = 'Cooking';
            ld.Lockdown_Survey__c = 'Decide post second meeting(EC or VC)';
            ld.Mass_email__c = true;
            ld.MeetingConfirmed_TimeStamp__c = DateTime.now()+1;
            ld.Match_Type__c = 'test1';
            ld.Meeting_Scheduled_By_Name__c = 'text';
            ld.Meeting_Scheduled_by__c = 'text';
            ld.Meeting_Scheduled_on_First_Call__c = false;
            ld.Meeting_Scheduled_Reminder__c = false;
            ld.MeetingScheduled_TimeStamp__c = DateTime.now();
            ld.Meeting_Type__c = 'EC';
            ld.Messaging_Source__c = 'Chat';
            ld.Property_Name__c = 'test';
            ld.Property_Usage__c = 'Self';
            ld.Ready_for_Convert_Time__c = DateTime.now()+1;
            //ld.Rate_of_conversion__c = 1234;
            ld.Ready_to_Convert__c = true;
            ld.Call_Stage__c = 'Meeting Scheduled';
            ld.Re_Contact_Date__c = DateTime.now()+1;
            ld.rejected_by__c = 'test';
            ld.Time_On_Last_page__c = 'testing1';
            update ld;
            
            
            
            //System.assertEquals(false, ld.bypassSMleadOwnervalidation__c, 'The bypass flag should be set to false');
            
            Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
            LeadTrigger_handler.getLocalDateTime(system.today());
            insert new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=9,Working_Hour_End_Time__c = 18);
            LeadTrigger_handler.deadlineOfAcceptance8hoursCalculation(system.today());
            //Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        }        
    }
    
    @istest
    Public static void cp1(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        CPPortal__c  cuset3= new CPPortal__c();
        cuset3.Name = 'cpportalupdate';
        cuset3.url__c= 'https://uat-api.designcafe.com/pp/updateLead';
        insert cuset3; 
        CPPortal__c  cuset4= new CPPortal__c();
        cuset4.Name = 'cpportalinsert';
        cuset4.url__c= 'https://uat-api.designcafe.com/pp/insertLead';
        insert cuset4;
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        
        Lead Leadins = new lead();  
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Email= 'Awdhesh1214@gmail.com';
        Leadins.Property_Type__c='villa';
        Leadins.Property_Possession_Date__c=System.today();
        Leadins.Project_Name__c='Awdhesh test';
        Leadins.Property_Type__c='0';
        leadins.Messaging_Source__c = '';
        leadins.CMM_Name__c = 'Harsh Gangawal';
        Leadins.Willingness_For_Meeting__c = system.today();
        leadins.Campagin__c = 'google';
        leadins.Home_Type__c= '2 BHK';
        leadins.OTP_Verified__c = 'YES';
        leadins.Wohoo_Card__c ='sevenfourzero';
        leadins.PostalCode = '123456';
        leadins.CMM_Name__c = 'sevenfourzero';
        leadins.Date_When_Meeting_is_Scheduled__c = system.today()+2;
        Leadins.Call_Stage__c='';
        Leadins.DC_Lead_Status__c ='Recontacted';
        leadins.Re_Contact_Date__c = system.today();
        Leadins.Channel__c = 'Offline';
        Leadins.Source__c = 'DSA';
        Leadins.City = 'Mumbai';
        leadins.Property_Usage__c ='Self';
        leadins.DSA_Code__c ='DC005643';
        leadins.Property_Possession_Date__c = system.today();
        leadins.Client_Site_visit__c ='Requested';
        leadins.Call_Stage__c = 'Low Budget';
        Leadins.Meeting_Type__c='EC';
        Leadins.Meeting_Venue__c='MGDC';
        Leadins.How_did_you_hear_about_us__c ='Online';
        //     Leadins.DC_Campaign_Source__c ='Email';
        //     leadins.DC_Lead_Source__c ='Email';
        Leadins.Scope_Of_Work__c='Home interiors';
        Leadins.Interior_work_needed_for__c='Living Room';
        Leadins.Requirement_Details__c='Wardrobes';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        leadins.FirstName = 'testeasy';
        leadins.Email='imtiyaz043@dc.com';
        leadins.City= 'Bengaluru';
        leadins.CMM_Name__c='Harsh Gangwal';
        leadins.Meeting_Type__c = 'EC';
        leadins.Meeting_Venue__c= 'MGDC';
        leadins.Property_Address__c =' Mysore road Bengaluru';
        leadins.Messaging_Source__c= 'WhatsApp';
        leadins.Status= 'Meeting Scheduled';
        leadins.Source__c='Paid';
        //  leadins.LeadSource='Google adwards';
        Leadins.Description='test';
        Leadins.MobilePhone = '+910000000000';
        insert Leadins;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        VDC_CPUpdateLead.CPcallout(leadins.Id);
        VDC_CPInsertLead.CPcallout(leadins.Id);
        Test.stopTest();
    }    
    @TestSetup
    Static void SetUpMethod(){
        //insert Custom setting for LeadTrigger
        TriggerControl__c tc = New TriggerControl__c();
        tc.name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc;
        DCWebengage__c dc = new DCWebengage__c();
        dc.Name = 'Dcwebengage';
        dc.url__c = 'https://testing.com';
        insert dc;
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        SRR__c SRRThane = new SRR__c();
        SRRThane.Name = 'Thane DC';
        SRRThane.index__c = 0;
        insert SRRThane;
        SRR__c SRRJPDC = new SRR__c();
        SRRJPDC.Name = 'JPDC';
        SRRJPDC.index__c = 0;
        insert SRRJPDC;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;       
        
        
        SRR__c SRRWLMUM1 = new SRR__c();
        SRRWLMUM1.Name = 'OMRCH';
        SRRWLMUM1.index__c = 0;
        insert SRRWLMUM1; 
        SRR__c SRRWLMUM2 = new SRR__c();
        SRRWLMUM2.Name = 'HRBRBLR';
        SRRWLMUM2.index__c = 0;
        insert SRRWLMUM2; 
        SRR__c SRRWLMUM3 = new SRR__c();
        SRRWLMUM3.Name = 'RSPCO';
        SRRWLMUM3.index__c = 0;
        insert SRRWLMUM3;
        SRR__c SRRWLMUM4 = new SRR__c();
        SRRWLMUM4.Name = 'DNVIZ';
        SRRWLMUM4.index__c = 0;
        insert SRRWLMUM4; 
        
        
        
        
        DC_Center_To_Group_Mapping__c Dcgm = new DC_Center_To_Group_Mapping__c();
        Dcgm.Name = 'testing';
        Dcgm.Venue_Name__c = 'MGDC';
        Dcgm.Public_Group_Name__c = 'Sales MGDC_1';
        insert Dcgm;
        Leadtogenesys__c lts = new Leadtogenesys__c();
        lts.Name = 'genesysapi';
        lts.url__c = 'LeadTrigger';
        insert lts;
        Design_User__c Duser = new Design_User__c();
        Duser.Name = 'testing';
        Duser.Designer_Dashboard_ID__c = '123456789';
        Duser.Role__c = 'Design Partner';
        Duser.Email__c = 'test@test.com';
        Duser.Mobile__c = '9876543210';
        Duser.Region__c = 'mumbai';
        Duser.Experience_Center__c = 'WDC';
        insert Duser;
    }
    static TestMethod Void BroadcastIs0(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD; 
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;           
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId,
                          IsActive = true,
                          MobilePhone = '9176011477');
        
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.Broadcast_Status__c = '0';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Lead_Trace__c lt    = new Lead_Trace__c();
        lt.status__c = 'Converted - Pending Sign-up';
        lt.Tmestamp__c      = system.today();
        insert lt; 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastIs1(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;       
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;         
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.Broadcast_Status__c = '1';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastDesignerUserNoNull(){
        //insert DU user
        Design_User__c du = new Design_User__c();
        du.name = 'test du user';
        du.Designer_Dashboard_ID__c = 'test du';
        du.Email__c = 'test@test.com';
        du.Role__c = 'Design Partner';
        insert du;
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;        
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        
        //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.Design_User__c = du.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void BroadcastDesignerUserNull(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;          
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;  
        
        //insert Lead
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'New';
        Lea.PB_BS_1_or_3_or_4__c = true;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void CCerror(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;   
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;          
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        
        //Lead Creation
        // system.runAs(u){
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.DC_Lead_Status__c = 'CC Error';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today()+1;
        Lea.Meeting_Type__c = 'EC';
        Lea.Broadcast_Status__c = '0';
        Lea.Call_Stage__c = 'Low Budget';
        Lea.City = 'Mumbai';
        Lea.Channel__c = 'Offline';
        Lea.Source__c ='DSA';
        Lea.MobilePhone = '6543234567';
        //Lea.stage = 'New';
        // insert Lea;
        //}
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void ConnectedChat(){
        
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD; 
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;           
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Messaging_Source__c = 'Chat';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today().addMonths(1);
        Lea.Meeting_Type__c = 'EC';
        Lea.City = 'Mumbai';
        Lea.Designer__c = uDesign.Id;
        Lea.Has_Designer_Accepted__c ='Designer Assigned, Acceptance Pending';
        Lea.DC_Lead_Status__c = 'Followup';
		insert Lea;
        
        Lead_Trace__c lt    = new Lead_Trace__c();
        lt.status__c = 'Converted - Pending Sign-up';
        lt.Tmestamp__c = system.today();
        lt.Lead__c =Lea.Id;
        insert lt; 
        
        Lead_Trace__c lt1    = new Lead_Trace__c();
        lt1.status__c = 'Meeting Done';
        lt1.Tmestamp__c = system.today();
        lt1.Lead__c =Lea.Id;
        insert lt1; 
        
        Lead_Trace__c lt2    = new Lead_Trace__c();
        lt2.status__c = 'Converted - Pending Sign-up';
        lt2.Tmestamp__c = system.today();
        lt2.Lead__c =Lea.Id;
        insert lt2;
        
        Recordtype recordTypeId = [Select id, Name from Recordtype where Name = 'Sales Partner'];
             
        Account acc =new Account();
        acc.Name='TestAccount';
        acc.PAN__c='ASDFG1234M';
        acc.l10n_in_gst_treatment__c='Regular';
        acc.GST_No__c='06BZAHM6385P6Z2';
        acc.BillingPostalCode='430056';
        acc.BillingStreet='Mahatma Gandhi Road';
        acc.ShippingState='Karnataka';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.ShippingPostalCode='430056';
        acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingStreet='Mahatma Gandhi Road';
        acc.BillingCity='Bengaluru';
        acc.ShippingCity='Bengaluru';
        acc.Customer_type__c='B2C';
        acc.RecordTypeId = recordTypeId.Id;
        insert acc;
        
        Opportunity opty = new Opportunity();
        opty.Name='OppTest';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = Lea.Id;
        opty.Remarks_For_Marketing__c = 'test 26-day delivery, My offer';
        opty.Offer_and_discounts__c = 'No Offer;26-day delivery';
        insert opty;
        
        Lea.Status = 'Converted';
        Lea.Approx_Budget__c = '2L to 3L';
        Lea.Source__c = 'Paid';
        Lea.Client_s_Budget__c = 10;
        Lea.Is_Customer_Created__c = true;
        Lea.DSA__c = acc.Id;
        System.debug('Lea ==> ' + Lea);
        UPDATE Lea;
        
        
        
        
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedNotChat(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;  
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;         
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId); 
        insert u;
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Meeting_Type__c = 'EC';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    static TestMethod Void ConnectedCCAgent(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD; 
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;           
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        Id ccTeamLeadId = [select Id from Profile where Name = 'Call Center Team Lead' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'CCTeamLead@designer.com', 
                          Username = 'CCTeamLead@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccTeamLeadId); 
        insert u;
        //User Creation
        user u1 = new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = 'designeruser@designer.com', 
                           Username = 'designeruser@designer.com', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = 'deus', 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = ccAgentId); 
        insert u1;
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
       // Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void ConnectedCCTeamLead(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;        
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;           
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;          
        
        Id ccTeamLeadId = [select Id from Profile where Name = 'Call Center Team Lead' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'CCTeamLead@designer.com', 
                          Username = 'CCTeamLead@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccTeamLeadId); 
        insert u;
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        System.debug('uDesign '+uDesign);
        //Lead Creation
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Connected';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.Designer__c = uDesign.Id;
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    static TestMethod Void DCMeetingScheduled(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;        
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;  
        
        Id DCId = [select Id from Profile where Name = 'DesignCafe Profile' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = DCId); 
        insert u;
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Scheduled';
        Lea.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        insert Lea;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    } 
    
    static TestMethod Void MsByCC(){
        
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;     
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;            
        
        Id p = [select id from profile where name='Call Center Agent'].id;
        Id p1 = [select id from profile where name='Call Center Team Lead'].id;
        String orgId=UserInfo.getOrganizationId(); 
        
        User user = new User(alias = 'test8008', email='test8008@gmail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='test8008@noemail.com');
        
        insert user;
        
        
        Lead Lea1 = new Lead();
        Lea1.LastName  = 'testing Lead';
        Lea1.Status = 'Meeting Scheduled';
        Lea1.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea1.Meeting_Venue__c = 'MGDC';
        Lea1.Messaging_Source__c = 'Chat';
        Lea1.Willingness_For_Meeting__c = system.today();
        Lea1.Meeting_Type__c = 'EC';
        Lea1.Meeting_Scheduled_by__c = 'Call Center';  
        Lea1.Broadcast_Status__c = '1';
        //Lea1.LastModifiedById = user.Id;
        Lea1.City = 'Mumbai';
        
        insert Lea1;
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
        system.runAs(user)  {
            
        }
        
    }
    
    static TestMethod Void MsByAffiliate(){
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;  
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;    
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;            
        
        Id p = [select id from profile where name='Affiliate'].id;
        Id p1 = [select id from profile where name='FOFO'].id;
        String orgId=UserInfo.getOrganizationId(); 
        
        
        User user1 = new User(alias = 'test8009', email='test8009@gmail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                              timezonesidkey='America/Los_Angeles', username='test8009@noemail.com');      
        
        insert user1;
        
        
        Lead Lea1 = new Lead();
        Lea1.LastName  = 'testing Lead';
        Lea1.Status = 'Meeting Scheduled';
        Lea1.DC_Lead_Status__c = 'Meeting Scheduled';
        Lea1.Meeting_Venue__c = 'MGDC';
        Lea1.Messaging_Source__c = 'Chat';
        Lea1.Willingness_For_Meeting__c = system.today();
        Lea1.Meeting_Type__c = 'EC';
        Lea1.Meeting_Scheduled_by__c = 'Affiliate';  
        Lea1.Broadcast_Status__c = '1';
       // Lea1.LastModifiedById = user1.Id;
        Lea1.City = 'Mumbai';
        
        insert Lea1;
        
        /*
* FeedItem fi = new FeedItem(ParentId = Lea1.Id, Body = 'Test Body');
INSERT fi;
System.debug('fi ==> ' + fi);
*/
        
        
        Lea1.Status = 'Converted';
        Lea1.Approx_Budget__c = '2L to 3L';
        Lea1.Source__c = 'Paid';
        Lea1.Client_s_Budget__c = 10;
        Lea1.Is_Customer_Created__c = true;
        System.debug('Lea1 ==> ' + Lea1);
        UPDATE Lea1;
        
        
        //LeadConverterController.postFeed(Lea1.Id);
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());   
        system.runAs(user1)  {
            
        }
    }
    
    @isTest
    public static void MGDC(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        LastLeadAssignedDesigner__c MGDCLc = new LastLeadAssignedDesigner__c();
        MGDCLc.Name = 'MGDC_Lead_Count';
        MGDCLc.Number__c = 1;
        insert MGDCLc;
        LastLeadAssignedDesigner__c MGDCLas = new LastLeadAssignedDesigner__c();
        MGDCLas.Name = 'MGDC_Lead_Assigned_Status';
        MGDCLas.Number__c = 2;
        insert MGDCLas;
        LastLeadAssignedDesigner__c MGDCDm = new LastLeadAssignedDesigner__c();
        MGDCDm.Name = 'MGDC_Design_Manager';
        MGDCDm.Number__c = 2;
        insert MGDCDm;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        
        Lead_Trace__c lt    = new Lead_Trace__c();
        lt.status__c = 'Converted - Pending Sign-up';
        lt.Tmestamp__c      = system.today();
        insert lt; 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        //CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    }
    @isTest
    public static void MGDC1(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        LastLeadAssignedDesigner__c MGDCLc = new LastLeadAssignedDesigner__c();
        MGDCLc.Name = 'MGDC_Lead_Count';
        MGDCLc.Number__c = 2;
        insert MGDCLc;
        LastLeadAssignedDesigner__c MGDCLas = new LastLeadAssignedDesigner__c();
        MGDCLas.Name = 'MGDC_Lead_Assigned_Status';
        MGDCLas.Number__c = 2;
        insert MGDCLas;
        LastLeadAssignedDesigner__c MGDCCm = new LastLeadAssignedDesigner__c();
        MGDCCm.Name = 'MGDC_Community_Manager';
        MGDCCm.Number__c = 2;
        insert MGDCCm;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        Lead_Trace__c lt    = new Lead_Trace__c();
        lt.status__c = 'Converted - Pending Sign-up';
        lt.Tmestamp__c      = system.today();
        insert lt;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        //CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    } 
    @isTest
    public static void MUMBAI(){
        DDR__c DDRmumm = new DDR__c();
        DDRmumm.Name = 'Mumbai';
        DDRmumm.index__c = 0;
        insert DDRmumm;
        DDR__c DDRmumm1 = new DDR__c();
        DDRmumm1.Name = 'Mumbai';
        DDRmumm1.index__c = 1;
        insert DDRmumm1;
        DDR__c DDRmumm2 = new DDR__c();
        DDRmumm2.Name = 'Mumbai';
        DDRmumm2.index__c = 2;
        insert DDRmumm2;
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Mumbai';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='Mumbai DC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        insert ld;
        
        Lead ld1 = new Lead();
        ld1.LastName = 'test';
        ld1.City = 'Mumbai';
        ld1.IsConverted = false;
        ld1.Follow_Up_Date_Time__c = system.today()+5;
        ld1.Property_Possession_Date__c=date.today();
        ld1.Region__c = ld.City;
        ld1.Approx_Budget__c = '2L to 3L';
        ld1.Meeting_Venue__c='Mumbai DC';
        ld1.Meeting_Type__c='EC';
        ld1.Willingness_For_Meeting__c = date.today().addDays(5);
        ld1.DC_Lead_Status__c = 'Followup';
        ld1.Follow_Up_Count__c = 11;
        insert ld1;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        //CallCenterAPI.basicAuthCallout(lList.id);
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
    } 
    
    /*@isTest
    public static void LdTriggerstart(){
        testSetup();
        user uDesign = [select id,name from user where profile.name = 'Designer' and team__c != null limit 1];
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Account accDSA  = new Account(Name ='test', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        insert accDSA;
        
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        //insert accRef;
        account acc= [select Name ,Referee_Code_DC__c from account where id=:accDSA.id];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.Referee_Name__c='test';
        ld.Referee_Code__c ='123';
        ld.Status='FollowUp';
        ld.DC_Lead_Status__c = 'No response';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Client_s_Budget__c = 90000;
        insert ld;
        ld.Region__c = ld.City;
        ld.Designer__c = uDesign.Id;
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.MobilePhone = '9876543210';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        update ld;
        
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        LeadTrigger_Handler.assignDesignerOwnership(new List<String>{ld.Id},new List<String>{[SELECT Id FROM user LIMIT 1].Id});   
        //LeadTrigger_Handler.roundRobinAssignmentOfLeadOwner2(mapRegionToUser, regionToLeadsMap, mapOfVenueLastUsernumber)
    } */ 
    
    
    /*@isTest
    public static void LdTrigger(){
        testSetup();
        insert new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=18,Working_Hour_End_Time__c = 9);
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.Source__c = 'Direct';
        ld.DC_Campaign_Source__c = 'Direct';
        ld.DC_Lead_Source__c = 'Direct';
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.Status='Assigned';
        ld.DC_Lead_Status__c = 'Undialed';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        insert ld;
        
        Account acc =new Account();   
        acc.Name='Account';
        acc.RecordTypeId = salesRecId;
        acc.GST_No__c='06BZAHM6385P6Z2';        
        acc.Customer_type__c='B2C';
        acc.Channel_Marketing_Manager__c= uDesign.id ;
        acc.CMM_Name__c='CMM';
        insert acc;
        
        
        account accRec=[select Name, Referee_Code_DC__c from account where id=:acc.id];
        
        Opportunity opty = new Opportunity();
        opty.Name='OppTest';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();    
        opty.Amount=3124;
        opty.Lead_Id__c = ld.Id;
        opty.Remarks_For_Marketing__c = 'test 26-day delivery, My offer';
        opty.Offer_and_discounts__c = 'No Offer;26-day delivery';
        insert opty;
        
        
        ld.DSA__c = acc.id;
        ld.DSA_Code__c = 'testing';
        ld.Referee_Code__c = acc.Referee_Code_DC__c;
        ld.Region__c = ld.City;
        ld.MobilePhone = '9876567895';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Status = 'FollowUp';
        ld.DC_Lead_Status__c = 'No response';
        ld.MobilePhone = '9202930987';
        update ld;
        
        Task t = new Task(IsReminderSet = true, whoId = ld.Id, status='Open');              
        insert t;
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        LeadTrigger_handler.getLocalDateTime(system.today());
        LeadTrigger_handler.deadlineOfAcceptance8hoursCalculation(system.today());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        
    } */
    @isTest
    public static void LdTrigger3(){
        testSetup();
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        user uSales = [select id,name from user where profile.name = 'Sales Executive' and team__c != null limit 1];    
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId(); 
        Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        //  insert accDSA;
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        // insert accRef;
        //account acc=[select Referee_Code_DC__c from account where id=:accRef.id];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.Source__c = 'Direct';
        ld.DC_Campaign_Source__c = 'Direct';
        ld.DC_Lead_Source__c = 'Direct';
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.DSA__c = accDSA.id;
        ld.DSA_Code__c = 'testing';
        ld.Status='Prospect';
        // ld.DC_Lead_Status__c = 'Meeting Scheduled';
        ld.Designer__c = uDesign.Id; 
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);    
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        insert ld;
        ld.Region__c = ld.City;  
        ld.MobilePhone = '9876567895';
        ld.OwnerId = uSales.Id;   
        ld.Status='Prospect';    
        //  ld.DC_Lead_Status__c = 'Meeting Done';
        update ld; 
        lead_trace__c lt = new lead_trace__c();
        lt.Lead__c = ld.Id;
        lt.Tmestamp__c = date.today();    
        lt.Status__c = ld.DC_Lead_Status__c;  
        lt.OwnerId = ld.OwnerId;    
        insert lt;
        lt.Status__c = ld.DC_Lead_Status__c;
        lt.OwnerId = ld.OwnerId;
        update lt;
        
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        LeadTrigger_handler.getLocalDateTime(system.today());
        insert new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=9,Working_Hour_End_Time__c = 18);
        LeadTrigger_handler.deadlineOfAcceptance8hoursCalculation(system.today());
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        
    }   
    @isTest
    public static void LdTrigger5(){
        testSetup();
        Design_User__c Duser = new Design_User__c();
        Duser.Name = 'testing';
        Duser.Designer_Dashboard_ID__c = '123456789';
        Duser.Role__c = 'Design Partner';
        Duser.Email__c = 'test@test.com';
        Duser.Mobile__c = '9876543210';
        Duser.Region__c = 'mumbai';
        Duser.Experience_Center__c = 'WDC';
        insert Duser;
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        //user uDesignUser = [select id,name from user where profile.name = 'Design User' and team__c != null limit 1];
        user uSales = [select id,name from user where profile.name = 'Sales Executive' and team__c != null limit 1];    
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CusRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        // insert accDSA;
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        //  insert accRef;
        //  account acc=[select Referee_Code_DC__c from account where id=:accRef.id];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.Source__c = 'Direct';
        ld.DC_Campaign_Source__c = 'Direct';
        ld.DC_Lead_Source__c = 'Direct';
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.DSA__c = accDSA.id;
        ld.DSA_Code__c = 'testing';
        ld.Status='Prospect';
        ld.DC_Lead_Status__c = 'Meeting Done';
        ld.Designer__c = uDesign.Id; 
        //    ld.Design_User__c = Duser.Id;
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);    
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        insert ld;
        ld.Approx_Budget__c = '5L to 7L';
        ld.MobilePhone = '9876567895';
        ld.Email = 'kim@president.com';    
        ld.OwnerId = uSales.Id;    
        ld.Status='Converted'; 
        ld.DC_Lead_Status__c = 'Meeting Done';
        update ld; 
        Account ac = new Account();
        ac.LastName = 'test';
        ac.Acc_Email__c = 'kim@president.com';   
        ac.RecordTypeId = CusRecId;
        // insert ac;    
        lead_trace__c lt = new lead_trace__c();
        lt.Lead__c = ld.Id;
        lt.Tmestamp__c = date.today();    
        lt.Status__c = 'Converted - Pending Sign-up';  
        lt.OwnerId = ld.OwnerId;    
        insert lt;
        lt.Status__c = ld.DC_Lead_Status__c;
        lt.OwnerId = ld.OwnerId;
        update lt;
        string aLeadIDs = ld.id;
        string aDesignerIDs = duser.Id;
        
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        LeadTrigger_handler.getLocalDateTime(system.today());
        insert new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=9,Working_Hour_End_Time__c = 18);
        LeadTrigger_handler.deadlineOfAcceptance8hoursCalculation(system.today());
        // LeadTrigger_handler.assignDesignerOwnership(aLeadIDs, aDesignerIDs);
        Lead lList = [select id,MobilePhone,Region__c from Lead LIMIT 1];
        
    }
    @isTest
    public static void LdTrigger4(){
        testSetup();
        Design_User__c Duser = new Design_User__c();
        Duser.Name = 'testing';
        Duser.Designer_Dashboard_ID__c = '123456789';
        Duser.Role__c = 'Design Partner';
        Duser.Email__c = 'test@test.com';
        Duser.Mobile__c = '9876543210';
        Duser.Region__c = 'mumbai';
        Duser.Experience_Center__c = 'WDC';
        insert Duser;
        user uDesign = [select id,name from user where profile.name = 'System Administrator' and team__c != null limit 1];
        //user uDesignUser = [select id,name from user where profile.name = 'Design User' and team__c != null limit 1];
        user uSales = [select id,name from user where profile.name = 'Sales Executive' and team__c != null limit 1];    
        Id salesRecId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        Id empRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CusRecId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account accDSA  = new Account(Name ='DSA', RecordTypeId = salesRecId,Channel_Marketing_Manager__c=uDesign.id ,CMM_Name__c='CMM');
        // insert accDSA;
        Account accRef  = new Account(lastName ='Refree',RecordTypeId = empRecId );
        //  insert accRef;
        //  account acc=[select Referee_Code_DC__c from account where id=:accRef.id];
        List<Lead> l = new List<Lead>();
        Lead ld = new Lead();
        ld.Channel__c = 'Online';
        ld.Source__c = 'Direct';
        ld.DC_Campaign_Source__c = 'Direct';
        ld.DC_Lead_Source__c = 'Direct';
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.Email = 'Bengaluru@gmail.com';
        ld.DSA__c = accDSA.id;
        ld.DSA_Code__c = 'testing';
        ld.Status='Prospect';
        //   ld.DC_Lead_Status__c = 'Meeting Done';
        ld.Designer__c = uDesign.Id; 
        ld.Design_User__c = Duser.Id;
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);    
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        insert ld;
        ld.Approx_Budget__c = '5L to 7L';
        ld.MobilePhone = '9876567895';
        ld.Email = 'kim@president.com';
        ld.Client_s_Budget__c = 90000;
        ld.OwnerId = uSales.Id;    
        ld.Status='Converted'; 
        //   ld.DC_Lead_Status__c = 'Meeting Done';
        update ld; 
        Account ac = new Account();
        ac.LastName = 'test';
        ac.Acc_Email__c = 'kim@president.com';   
        ac.RecordTypeId = CusRecId;
        // insert ac;    
        lead_trace__c lt = new lead_trace__c();
        lt.Lead__c = ld.Id;
        lt.Tmestamp__c = date.today();    
        lt.Status__c = 'Converted - Pending Sign-up';  
        lt.OwnerId = ld.OwnerId;    
        insert lt;
        lt.Status__c = ld.DC_Lead_Status__c;
        lt.OwnerId = ld.OwnerId;
        update lt;
        string aLeadIDs = ld.id;
        string aDesignerIDs = duser.Id;
        
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        LeadTrigger_handler.getLocalDateTime(system.today());
        insert new Design_Cafe_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Working_Hour_Start_Time__c=9,Working_Hour_End_Time__c = 18);
        LeadTrigger_handler.deadlineOfAcceptance8hoursCalculation(system.today());
        
    }   
   	@isTest
    static void testLeadTraceOnLeadUpdate() {
        // Create test data
        // 
        Lead lead1 = new Lead(
            LastName = 'Test Lead 1',
            Company = 'Test Company',
            DC_Lead_Status__c = 'Meeting Scheduled',
            isConverted = false,
            City = 'Bengaluru',
            Meeting_Venue__c = 'MGDC',
        	Willingness_For_Meeting__c = system.today(),
        	Meeting_Type__c = 'EC'
        );
        
        Lead lead2 = new Lead(
            LastName = 'Test Lead 2',
            Company = 'Test Company',
            DC_Lead_Status__c = 'Prospect',
            isConverted = false,
            City = 'Bengaluru',
            Meeting_Venue__c = 'MGDC',
        	Willingness_For_Meeting__c = system.today(),
        	Meeting_Type__c = 'EC'
        );
        
        insert new List<Lead>{ lead1, lead2 };
        
        // Simulate updating the leads
        lead1.DC_Lead_Status__c = 'Meeting Done';
        lead2.DC_Lead_Status__c = 'Converted';

        List<Lead> newLeads = new List<Lead>{lead1, lead2};
        Map<Id, Lead> oldLeadsMap = new Map<Id, Lead>{
            lead1.Id => (Lead)lead1.clone(false, true, false, false),
            lead2.Id => (Lead)lead2.clone(false, true, false, false)
        };
        
        // Execute the method
        Test.startTest();
        LeadTrigger_Handler.leadTraceOnLeadUpdate(newLeads, oldLeadsMap);
        Test.stopTest();
        
        // Assert the results
        List<Lead_Trace__c> leadTraces = [SELECT Id, Status__c, Lead__c FROM Lead_Trace__c WHERE Lead__c IN :newLeads];
        Test.setMock(HttpCalloutMock.class, new DC_Webengage_mockup());
        System.assertEquals(1, leadTraces.size(), 'There should be 2 lead trace records created or updated.');
        System.assertEquals('Meeting Scheduled', leadTraces[0].Status__c);
    }
    @isTest
    static void testCheckForExistingLeadTraceRecords() {   
       Id ccAgentId = [select Id from Profile where Name = 'Call Center Agent' limit 1].Id;
        //User Creation
        user u = new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'designeruser@designer.com', 
                          Username = 'designeruser@designer.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'deus', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = ccAgentId,
                          IsActive = true,
                          MobilePhone = '9176011477');
         insert u;
    
        Lead Lea = new Lead();
        Lea.LastName  = 'testing Lead';
        Lea.Status = 'Meeting Confirmed';
        Lea.DC_Lead_Status__c = 'Meeting Done';
        Lea.Meeting_Venue__c = 'MGDC';
        Lea.Willingness_For_Meeting__c = system.today();
        Lea.Meeting_Type__c = 'EC';
        Lea.Pre_Qualified_Date__c = null;
        Lea.Broadcast_Status__c = '0';
        //Lea.LastModifiedById = u.Id;
        Lea.City = 'Mumbai';
        Lea.MobilePhone = '8976543234';
        insert Lea;
        Lead_Trace__c lt    = new Lead_Trace__c();
        lt.status__c = 'Meeting Done';
        lt.Tmestamp__c      = system.today();
        insert lt; 
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        Test.startTest();
        Lea.Status = 'Meeting Scheduled';
        lt.status__c = 'Meeting Scheduled';
        update Lea; 
        update lt;
        Test.stopTest();
    }
}