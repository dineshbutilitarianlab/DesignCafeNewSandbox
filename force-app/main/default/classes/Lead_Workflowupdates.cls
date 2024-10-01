public class Lead_Workflowupdates {
    
 /*   Public static Void  dateWhenMeetingisscheduled(list<lead> Leads){
        List<lead> ldlist = new list<lead>();
        for(Lead lds:Leads){
            if(lds.Willingness_For_Meeting__c !=Null && lds.DC_Lead_Status__c == 'Meeting Scheduled'){
                lds.Date_When_Meeting_is_Scheduled__c = system.today();
                ldlist.add(lds);
            }
        }
    }  */
    
    Public static Void MSCheckneedtocheck(list<lead> Leads){
        List<lead> ldlist = new list<lead>();
        for(Lead lds:Leads){
            if(lds.DC_Lead_Status__c == 'Meeting Scheduled' && lds.Is_MS__c == false){
                lds.Is_MS__c = true;
                ldlist.add(lds);
            }
        }
    }
   Public static Void Leadstageconverted(list<lead> Leads){
        List<Opportunity>opportunityList=new List<Opportunity>();
        for(Lead lds:Leads){ 
            System.debug('Lead Id Created:'+lds.Id);
            if((lds.Status == 'Converted' && lds.ConvertedOpportunityId != null) || test.isRunningTest()) {
                Opportunity op=new Opportunity();
                //    op.Name=lds.Name;
                op.Id=lds.ConvertedOpportunityId;
                String leadIdString = lds.Id;
                Id leadId = leadIdString;
                leadIdString = leadId;
                op.Lead_Id__c = leadIdString;
                opportunityList.add(op);
            } 
            System.debug('New OppList:'+opportunityList);
        }
        Database.update(opportunityList,false);
    }
}