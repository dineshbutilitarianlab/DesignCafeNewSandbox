/*
Developer : Azar khasim.
Company  : SiraTek.
Created Date : 03 MAR 2020
Description : Global Duplicate Search. 
*/

public class GlobalDupSearch1 {
    // PE is for searching for duplicates//   
    public string PE{get;set;}
    public string a;
    // These booleans are for capturing the filtered records//
    public boolean cn1{get;set;}
    public boolean ac1{get;set;}
    public boolean ld1{get;set;}
    public boolean ld2{get;set;}
    public boolean opp1{get;set;}
    // For Capturing of lead status.   
    public boolean Editlead{get;set;}
    public boolean Editlead1{get;set;}
    public boolean Createlead{get;set;}
    public boolean Createlead1{get;set;}
    // These lists are to capture the filtered records and stored in the list//
    public list<Account> aclist{get;set;}
    public list<contact> cnlist{get;set;}
    public list<lead> ldlist{get;set;}
    public list<lead> ldlist1{get;set;}
    public list<opportunity> opplist{get;set;}
    public User userDetails{get;set;}
    
    public GlobalDupSearch1(apexpages.StandardSetController sc){
        a=apexpages.currentPage().getparameters().get('id');  
        //   PE= 'search here...';        
    }
    public void search(){
        Id userId = userinfo.getUserId();
        userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];  
        
        if(pe != null && pe != ''){
            //Account List
            aclist=[select id, name, PersonMobilePhone, PersonEmail, Phone, DUP_Mobile__c, Owner.name, Owner.UserRoleId, Owner.MobilePhone, Owner.Email, OwnerId from account where PersonMobilePhone like :PE or PersonEmail like :PE or DUP_Mobile__c like :PE]; 
            if(aclist.size() > 0){
                ac1=true;
            }
            else{ 
                ac1=false;
            }
            //Opportunity List
            opplist=[SELECT name, Mobile__c, Email__c, StageName, DUP_Mobile__c, Owner.name, Owner.UserRoleId, Owner.MobilePhone, Owner.Email, OwnerId from opportunity where Email__c like :PE or Mobile__c like :PE or DUP_Mobile__c like :PE];
            if(opplist.size()>0){
                opp1=true;
            }
            else{
                opp1=false;
            }
            //Contact List
            cnlist=[SELECT name, MobilePhone, Email, DUP_Mobile__c, Owner.name, Owner.UserRoleId, Owner.MobilePhone, Owner.Email, OwnerId from contact where MobilePhone like :pe or Email like :PE or DUP_Mobile__c like :PE]; 
            if(cnlist.size() > 0){
                cn1=true;
            }
            else{
                cn1=false;
            }
            /// Only for New,Connected,NotConnected stages in Lead List
            ldlist=[SELECT id,name, MobilePhone, Email,Source__c,DC_Campaign_Source__c, Status,DC_Lead_Source__c, DC_Lead_Status__c, Call_Stage__c, Meeting_Venue__c, User_Mobile__c, Lead_Owner_Role__c, DUP_Mobile__c, Owner.name, Owner.UserRoleId, Owner.Email, OwnerId, DUP_Update_Owner__c,Follow_Up_Date_Time__c, Channel__c,CreatedDate  from lead where (Status!= 'Converted') AND (MobilePhone like : pe or Email like :pe or DUP_Mobile__c like : pe)];
            if(ldlist.size() > 0){
                ld1=true;
            }
            else{
                ld1=false;
            }            
            /// Only for Meeting Scheduled,Meeting Confirmed,Converted in Lead List
            ldlist1=[SELECT id,name, MobilePhone,Source__c, Email,DC_Campaign_Source__c, Status,DC_Lead_Source__c, DC_Lead_Status__c,Call_Stage__c, Meeting_Venue__c, User_Mobile__c, Lead_Owner_Role__c, DUP_Mobile__c, Owner.name, Owner.UserRoleId, Owner.Email, OwnerId, DUP_Update_Owner__c, Follow_Up_Date_Time__c, Channel__c,CreatedDate from lead where (Status!= 'New' AND Status!= 'Connected' AND Status!= 'Not Connected'AND Status!= 'Meeting Confirmed' AND Status!= 'Meeting Scheduled') AND (MobilePhone like : pe or Email like :pe or DUP_Mobile__c like : pe)];
            if(ldlist1.size() > 0){
                ld2=true;
            }
            else{
                ld2=false;
            } 
            // To show create lead Button.(No Duplicate Exists)
            if(ac1 == false && cn1 == false && ld1 == false && ld2 == false && opp1 == false){
                if(( userDetails.UserRole.Name  == 'Offline Marketing Head' || userDetails.UserRole.Name  == 'Offline Marketing Team Lead' 
                    || userDetails.UserRole.Name  == 'Online Marketing Head' || userDetails.UserRole.Name  == 'Online Marketing Head (Consultant)' 
                    || userDetails.UserRole.Name  == 'Online Marketing Team Lead' || userDetails.UserRole.Name  == 'Organic and Website Marketing Head' 
                    || userDetails.UserRole.Name  == 'Organic and Website Marketing Team Lead')){
                        Createlead=false;
                        Editlead=false;
                    }
                 else 
               if(( userDetails.UserRole.Name  == 'Hofeto' || userDetails.UserRole.Name  == 'Vozic' 
                    || userDetails.UserRole.Name  == 'Quikr')){
                        Createlead1=true;
                        Editlead1=false;
                    }
                
                else{
                        Createlead=true;
                        Editlead=false;
                    } 
                apexpages.Message m=new apexpages.message(ApexPages.Severity.ERROR,'No records found!');
                apexpages.addMessage(m);
            }
            else{
                Createlead=false;
            } 
        }else{  
            Createlead=false;
            Editlead=false;
            Createlead1=false;
            Editlead1=false;
            apexpages.Message m1=new apexpages.message(ApexPages.Severity.ERROR,'Please enter a Mobile number or Email ID to search duplicates');
            apexpages.addMessage(m1);     
        }
        /// This action is to hide the Save Button when below creteria meets(Record is already with SalesPerson) ///    
      //  for(lead lds:ldlist){
            if(ld1 == true){
                if((userDetails.UserRole.Name == 'Call Center Agent' || userDetails.UserRole.Name  == 'Call Center Team Lead' 
                    || userDetails.UserRole.Name  == 'Internal Sales Agent' || userDetails.UserRole.Name  == 'Internal Sales Team Lead' 
                    || userDetails.UserRole.Name  == 'Internal Sales Team Director' 
                    || userDetails.UserRole.Name  == 'Offline Marketing Head' || userDetails.UserRole.Name  == 'Offline Marketing Team Lead' 
                    || userDetails.UserRole.Name  == 'Online Marketing Head' || userDetails.UserRole.Name  == 'Online Marketing Head (Consultant)' 
                    || userDetails.UserRole.Name  == 'Online Marketing Team Lead' || userDetails.UserRole.Name  == 'Organic and Website Marketing Head' 
                    || userDetails.UserRole.Name  == 'Organic and Website Marketing Team Lead')){
                        Editlead=false;     
                    }else{
                    Editlead=true; 
                }
            }
         }
 //   }
    public pagereference save(){
        //// Need to update OwnerId field of particular record in lead object////
        list<lead> updateLead = new list<lead>();
        lead ldown = new lead();
        integer NoOfCheckes = 0;
        for(lead ld:ldlist){
            if(ld.DUP_Update_Owner__c == true){
                NoOfCheckes++;
                UpdateLead.add(ld);
            }
        }
        if(UpdateLead.size()==1&& Noofcheckes == 1){
            UpdateLead[0].DUP_Update_Owner__c = false;
            UpdateLead[0].OwnerId = userinfo.getUserId();
            Update UpdateLead[0];
        }else{
            apexpages.Message m2=new apexpages.message(ApexPages.Severity.ERROR,'Please Select one Lead at a time');
            apexpages.addMessage(m2);
        }
        pagereference p1=new pagereference('/'+(UpdateLead.size()>0?UpdateLead[0].id:null));
        p1.setRedirect(true);
        return p1; 
    } 
    public pagereference createLead(){
        pagereference cl1=new pagereference('/lightning/o/Lead/new');
        cl1.setRedirect(true);
        return cl1;   
    } 
   public pagereference CreateLead1(){
        pagereference cl2=new pagereference('https://dc.lightning.force.com/lightning/o/Lead/new?count=1&nooverride=1&useRecordTypeCheck=1&navigationLocation=LIST_VIEW&uid=164812528842410603&backgroundContext=%2Flightning%2Fo%2FLead%2Flist%3FfilterName%3DRecent');
        cl2.setRedirect(true);
        return cl2;   
    } 
}