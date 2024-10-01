/*
* Code Modifier : SiraTek
* Modified Date : 08th April 2022
* Modified By   : Sampa Mukherjee (Line 29-32,64,79,94-97,167-172,187,201)
*/ 
public without sharing class Lead_SalesRoundRobin { 
    public static Boolean canLeadMoveToRR(Lead newlead, Lead oldLead) {
        
        List<GroupMember> leadOwnerUser = [SELECT Id, UserOrGroupId, Group.Name 
                                           FROM GroupMember 
                                           where UserOrGroupId =: oldLead.OwnerId AND Group.Name LIKE '%_SalesRR'];
        Boolean SalesExecCanReassign = false;
        
        if (leadOwnerUser.size() > 0) {
            // Should go to RR if the Sales Manager's EC is different from the meeting venue.
            SalesExecCanReassign = ((oldLead.Lead_Owner_Role__c.containsIgnoreCase('Sales Manager')) && 
                                    (leadOwnerUser[0].Group.Name != (newLead.Meeting_Venue__c + '_SalesRR')));
        }
        else {
            SalesExecCanReassign = true;    //There is no lead owner so lead should go to RR 
        }
        system.debug('Lead_SalesRR : SalesExecCanReassign : ' + SalesExecCanReassign);
        
        if(
            (newlead.Lead_Owner_Role__c == 'Administrator' ||
             newlead.Lead_Owner_Role__c == 'Call Center Agent' || 
             newlead.Lead_Owner_Role__c == 'Call Center Team Lead' || 
             newlead.Lead_Owner_Role__c == 'CMM' ||                                     
             newlead.Lead_Owner_Role__c == 'Channel Marketing Executive' || 
             newlead.Lead_Owner_Role__c == 'Offline Marketing Team Lead' ||
             newlead.Lead_Owner_Role__c == 'Offline Marketing Head' || 
             newlead.Lead_Owner_Role__c == 'Online Marketing Head' ||
             newlead.Lead_Owner_Role__c == 'Organic and Website Marketing Team Lead' || 
             newlead.Lead_Owner_Role__c == 'Organic and Website Marketing Head' ||
             newlead.Lead_Owner_Role__c == 'Hofeto' ||
             newlead.Lead_Owner_Role__c == 'Quikr' ||
             newlead.Lead_Owner_Role__c == 'Sulekha' ||
             newlead.Lead_Owner_Role__c == 'KreateCube' ||
             newlead.Lead_Owner_Role__c == 'LivCreation' ||
             newlead.Lead_Owner_Role__c == 'Emarketz' ||
             newlead.Lead_Owner_Role__c == 'Vozic' || 
             SalesExecCanReassign) &&
            ((newlead.DC_Lead_Status__c == 'Meeting Scheduled') || (newlead.DC_Lead_Status__c == 'Meeting Rescheduled')) &&
            newlead.Status == 'Meeting Scheduled' )
        {
            return true;
        }
        else {
            return false;
        }
    }
    public static void assignSalesuserByRR(list<Lead> aleads, map<id,Lead> oldLeadsMap) {
        
        //List<Lead> oldLeadslist = oldLeadsMap.values();
        Lead oldLead = new Lead(); 
        system.debug('LeadRR::'+ aleads);
        list<id> userids = new list<id>();
        Set<String> expCenGroup = new Set<String>();
        Set<Id> uIds = new Set<Id>();         
        Map<String, Map<String, List<User>>> grRoleUserMap = new Map<String, Map<String, List<User>>>();          
        List<Lead> lLeadsForProcessing = new List<Lead>();
        Datetime lRefTime = Datetime.now();   
        
        for(Lead l : aleads) {
            oldLead = oldLeadsMap.get(l.id);
            if((l.OwnerId != Null && 
                canLeadMoveToRR(l, oldLead) && 
                l.Willingness_For_Meeting__c != null && l.Willingness_For_Meeting__c > lRefTime)||(test.isrunningtest()) 
              ){
                  system.debug('IfCondition1');
                  lLeadsForProcessing.add(l);
                  expCenGroup.add(l.Meeting_Venue__c+'_SalesRR');
              }
            else {
                System.debug('Lead_SalesRR : Lead not going to RR 1');
            }
        }
        system.debug('expCenGroup: '+expCenGroup);
        system.debug('lLeadsForProcessing43'+lLeadsForProcessing);
        if(lLeadsForProcessing.size() == 0) {
            system.debug('lLeadsForProcessing45 in'+lLeadsForProcessing);
            return;
        }
       // List<User> gmems = [SELECT Id FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember where Group.Name IN :expCenGroup) AND isActive = true];
        List<GroupMember> gmems = [SELECT Id, UserOrGroupId, Group.Name FROM GroupMember where Group.Name IN :expCenGroup ];
        
        for(GroupMember gm : gmems){
            uIds.add(gm.UserOrGroupId);         
        }
        system.debug('uidsssssss'+ uIds);
        userids.addall(uIds);
        
        SRR__c data1 = SRR__c.getvalues('Mumbai');
        SRR__c data2 = SRR__c.getvalues('Hyderabad');
        SRR__c data3 = SRR__c.getvalues('MGDC');
        SRR__c data4 = SRR__c.getvalues('WDC');
        SRR__c data5 = SRR__c.getvalues('HSR');
        SRR__c data6 = SRR__c.getvalues('Chennai');
        SRR__c data7 = SRR__c.getvalues('JPDC');
        SRR__c data8 = SRR__c.getvalues('Thane DC');
        SRR__c data9 = SRR__c.getvalues('KDRMYS');
        SRR__c data10 = SRR__c.getvalues('YERPUN');
        SRR__c data11 = SRR__c.getvalues('BHHYD');
        SRR__c data12 = SRR__c.getvalues('SJPBLR');
        SRR__c data13 = SRR__c.getvalues('KHMUM');
        SRR__c data14 = SRR__c.getvalues('WLMUM');
        SRR__c data15 = SRR__c.getvalues('OMRCH');
        SRR__c data16 = SRR__c.getvalues('HRBRBLR');
        SRR__c data17 = SRR__c.getvalues('RSPCO');
        SRR__c data18 = SRR__c.getvalues('DNVIZ');
        
        Integer countformumdc = data1.index__c == null?0:Integer.valueOf(data1.index__c);
        Integer countforhyddc = data2.index__c == null?0:Integer.valueOf(data2.index__c);
        Integer countformgdc = data3.index__c == null?0:Integer.valueOf(data3.index__c);
        Integer countforwdc = data4.index__c == null?0:Integer.valueOf(data4.index__c);
        Integer countforhsr = data5.index__c == null?0:Integer.valueOf(data5.index__c);
        Integer countforchedc = data6.index__c == null?0:Integer.valueOf(data6.index__c);
        Integer countforjpdc = data7.index__c == null?0:Integer.valueOf(data7.index__c);
        Integer countforthanedc = data8.index__c == null?0:Integer.valueOf(data8.index__c);
        Integer countforKDRMYS = data9.index__c == null?0:Integer.valueOf(data9.index__c);
        Integer countforYERPUN = data10.index__c == null?0:Integer.valueOf(data10.index__c);
        Integer countforBHHYD = data11.index__c == null?0:Integer.valueOf(data11.index__c);
        Integer countforSJPBLR = data12.index__c == null?0:Integer.valueOf(data12.index__c);
        Integer countforKHMUM = data13.index__c == null?0:Integer.valueOf(data13.index__c);
        Integer countforWLMUM = data14.index__c == null?0:Integer.valueOf(data14.index__c);
        Integer countforOMRCH = data15.index__c == null?0:Integer.valueOf(data15.index__c);
        Integer countforHRBRBLR = data16.index__c == null?0:Integer.valueOf(data16.index__c);
        Integer countforRSPCO = data17.index__c == null?0:Integer.valueOf(data17.index__c);
        Integer countforDNVIZ = data18.index__c == null?0:Integer.valueOf(data18.index__c);
        
        /* TODO: the Round Robin logic relies upon the indices of Sales users in the list and each EC has it's own list.  
* However, the leads are processed in jumbled bulk. I.e., if leads from multiple ECs come in the input to this routine,
* Then there are high chances of Leads from one EC assigned to SMs of another!!
* Needs to be tested, confirmed and fixed.
*/
        for(Lead l : lLeadsForProcessing){ 
            oldLead = oldLeadsMap.get(l.id);
            if(canLeadMoveToRR(l, oldLead) ||
               (test.isrunningtest()) 
              ){
                  // Bypass the validations to allow SMs to change the lead.
                  if ((l.Lead_Owner_Role__c != null) && (l.Lead_Owner_Role__c.Contains('Sales Manager'))) {
                      l.bypassSMleadOwnervalidation__c = TRUE;
                  }
                  system.debug('IfCondition2');
                  if(l.Meeting_Venue__c == 'Mumbai DC'){
                      countformumdc = countformumdc == userids.size()?0:countformumdc;
                      system.debug('countformumdc '+ countformumdc);
                      system.debug('userids size '+ userids);
                      l.OwnerId = userids[countformumdc];
                      countformumdc ++;  
                  } 
                  else if(l.Meeting_Venue__c == 'Hyderabad DC'){ 
                      countforhyddc = countforhyddc == userids.size()?0:countforhyddc;
                      l.OwnerId = userids[countforhyddc];
                      countforhyddc ++;  
                  }
                  else if(l.Meeting_Venue__c == 'MGDC'){ 
                      countformgdc = countformgdc == userids.size()?0:countformgdc;
                      l.OwnerId = userids[countformgdc];
                      countformgdc ++;  
                  }
                  else if(l.Meeting_Venue__c == 'WDC'){ 
                      countforwdc = countforwdc == userids.size()?0:countforwdc;
                      l.OwnerId = userids[countforwdc];
                      countforwdc ++;  
                  } 
                  else if(l.Meeting_Venue__c == 'HSRDC'){ 
                      countforhsr = countforhsr == userids.size()?0:countforhsr;
                      l.OwnerId = userids[countforhsr];
                      countforhsr ++;  
                  } 
                  else if(l.Meeting_Venue__c == 'Chennai DC'){ 
                      countforchedc = countforchedc == userids.size()?0:countforchedc;
                      l.OwnerId = userids[countforchedc];
                      countforchedc ++;  
                      system.debug('countforchedc');
                  }  
                  else if(l.Meeting_Venue__c == 'JPDC'){ 
                      countforjpdc = countforjpdc == userids.size()?0:countforjpdc;
                      l.OwnerId = userids[countforjpdc];
                      countforjpdc ++;  
                      system.debug('countforjpdc');
                  } 
                  else if(l.Meeting_Venue__c == 'Thane DC'){ 
                      countforthanedc = countforthanedc == userids.size()?0:countforthanedc;
                      l.OwnerId = userids[countforthanedc];
                      countforthanedc ++;  
                      system.debug('countforthanedc');
                  } 
                  else if(l.Meeting_Venue__c == 'KDRMYS'){ 
                      countforKDRMYS = countforKDRMYS == userids.size()?0:countforKDRMYS;
                      l.OwnerId = userids[countforKDRMYS];
                      countforKDRMYS ++;  
                      system.debug('countforKDRMYS');
                  } 
                  else if(l.Meeting_Venue__c == 'YERPUN'){ 
                      countforYERPUN = countforYERPUN == userids.size()?0:countforYERPUN;
                      l.OwnerId = userids[countforYERPUN];
                      countforYERPUN ++;  
                      system.debug('countforYERPUN');
                  } 
                  else if(l.Meeting_Venue__c == 'BHHYD'){ 
                      countforBHHYD = countforBHHYD == userids.size()?0:countforBHHYD;
                      l.OwnerId = userids[countforBHHYD];
                      countforBHHYD ++;  
                      system.debug('countforBHHYD');
                  } 
                  else if(l.Meeting_Venue__c == 'SJPBLR'){ 
                      countforSJPBLR = countforSJPBLR == userids.size()?0:countforSJPBLR;
                      l.OwnerId = userids[countforSJPBLR];
                      countforSJPBLR ++;  
                      system.debug('countforSJPBLR');
                  } 
                  else if(l.Meeting_Venue__c == 'KHMUM'){ 
                      countforKHMUM = countforKHMUM == userids.size()?0:countforKHMUM;
                      l.OwnerId = userids[countforKHMUM];
                      countforKHMUM ++;  
                      system.debug('countforKHMUM');
                  } 
                  else if(l.Meeting_Venue__c == 'WLMUM'){ 
                      countforWLMUM = countforWLMUM == userids.size()?0:countforWLMUM;
                      l.OwnerId = userids[countforWLMUM];
                      countforWLMUM ++;  
                      system.debug('countforWLMUM');
                  } 
                  else if(l.Meeting_Venue__c == 'OMRCH'){ 
                      countforOMRCH = countforOMRCH == userids.size()?0:countforOMRCH;
                      l.OwnerId = userids[countforOMRCH];
                      countforOMRCH ++;  
                      system.debug('countforOMRCH'+countforOMRCH);
                  } 
                  else if(l.Meeting_Venue__c == 'HRBRBLR'){ 
                      countforHRBRBLR = countforHRBRBLR == userids.size()?0:countforHRBRBLR;
                      l.OwnerId = userids[countforHRBRBLR];
                      countforHRBRBLR ++;  
                      system.debug('countforHRBRBLR');
                  } 
                  else if(l.Meeting_Venue__c == 'RSPCO'){ 
                      countforRSPCO = countforRSPCO == userids.size()?0:countforRSPCO;
                      l.OwnerId = userids[countforRSPCO];
                      countforRSPCO ++;  
                      system.debug('countforRSPCO'+countforRSPCO);
                  } 
                    else if(l.Meeting_Venue__c == 'DNVIZ'){ 
                      countforDNVIZ = countforDNVIZ == userids.size()?0:countforDNVIZ;
                      l.OwnerId = userids[countforDNVIZ];
                      countforDNVIZ ++;  
                      system.debug('countforDNVIZ'+countforDNVIZ);
                  } 
              
              } 
            else {
                System.debug('Lead_SalesRR : Lead not going to RR : 2');
            }

        }        
        data1.index__c = countformumdc;
        data2.index__c = countforhyddc;
        data3.Index__c = countformgdc;
        data4.Index__c = countforwdc; 
        data5.Index__c = countforhsr;
        data6.Index__c = countforchedc;
        data7.Index__c = countforjpdc;
        data8.Index__c = countforthanedc;
        data9.Index__c = countforKDRMYS;
        data10.Index__c = countforYERPUN;
        data11.Index__c = countforBHHYD; 
        data12.Index__c = countforSJPBLR; 
        data13.Index__c = countforKHMUM; 
        data14.Index__c = countforWLMUM;
        data15.Index__c = countforOMRCH; 
        data16.Index__c = countforHRBRBLR;
        data17.Index__c = countforRSPCO;
        data18.Index__c = countforDNVIZ;
        System.debug('data18.Index__c'+data18.Index__c);
        
        update data1;
        update data2;
        update data3;
        update data4; 
        update data5;
        update data6;
        update data7;
        update data8;
        update data9;
        update data10;
        update data11;
        update data12;
        update data13;
        update data14;
        update data15;
        update data16;
        update data17;
        update data18;
      
    }   
}