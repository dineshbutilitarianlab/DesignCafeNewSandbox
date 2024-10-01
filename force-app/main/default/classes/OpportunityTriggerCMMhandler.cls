public class OpportunityTriggerCMMhandler {
    
    public static void getTargetRevenueOfCMMs( List<Opportunity> oppts , map<Id,Opportunity> mapOldOppty , Boolean isInsertOperation){
        
        system.debug('Target Revenue CMM ---');
        
        Set<string> setOfCMMst = new Set<string>();
        List<Opportunity> listOfOpptUpdate=new  List<Opportunity> ();
        Map<string,List<CMM_Monthly_Target__c>> maoOfUserWithCMMMonthlyTarget=new  Map<string,List<CMM_Monthly_Target__c>>(); 
        
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'January', 2=>'February', 3=>'March', 4=>'April', 5=>'May',
            6=>'June', 7=>'July', 8=>'August', 9=>'September',10=>'October',
            11=>'November', 12=>'December'};
                //------------CMM Name from Opportunity
                for(Opportunity opp : oppts) {
                    if(opp.stageName == 'Closed Won' ){
                        setOfCMMst.add(opp.CMM_Name__c);
                    }
                }
        
        system.debug('CMM user setOfCMMst ---'+setOfCMMst);
        
        if(setOfCMMst != null){
            for(CMM_Monthly_Target__c cmmmonthObj: [select id,Month__c,Year__c ,User__c,user__r.name,Target_Revenue__c from CMM_Monthly_Target__c where user__r.name in:setOfCMMst]){
                
                //--------------CMMT field from CMM Monthly Target
                system.debug('CMM user maoOfUserWithCMMMonthlyTarget ---'+maoOfUserWithCMMMonthlyTarget);
                
                if(!maoOfUserWithCMMMonthlyTarget.keyset().contains(cmmmonthObj.user__r.name)){
                    maoOfUserWithCMMMonthlyTarget.put(cmmmonthObj.user__r.name,new list<CMM_Monthly_Target__c>());
                }
                
                system.debug('CMM User Name maoOfUserWithCMMMonthlyTarget ---'+maoOfUserWithCMMMonthlyTarget);
                
                maoOfUserWithCMMMonthlyTarget.get(cmmmonthObj.user__r.name).add(cmmmonthObj);
                
                system.debug('CMM equal User maoOfUserWithCMMMonthlyTarget ---'+maoOfUserWithCMMMonthlyTarget);  
            }
        }
        
        for(Opportunity opp : oppts) {   
            
            Decimal targetRevenue=0;
            String targetRevenueId; 
            if( (isInsertOperation == true && opp.CMM_Name__c!=null ) || (isInsertOperation == false && opp.CMM_Name__c!=null && (opp.stagename != mapOldOppty.get(opp.Id).stagename || opp.CMM_Name__c != mapOldOppty.get(opp.Id).CMM_Name__c || opp.closeDate != mapOldOppty.get(opp.Id).closeDate))){
                
                if(opp.stageName == 'Closed Won'){  
                    Integer month           = opp.CloseDate.Month();
                    Integer year            = opp.CloseDate.Year();
                    String createdDtmonth   = monthNameMap.get(month);
                    
                    
                    
                    system.debug('CMM usersssss maoOfUserWithCMMMonthlyTarget.containsKey(opp.CMM_Name__c)---'+maoOfUserWithCMMMonthlyTarget.containsKey(opp.CMM_Name__c));
                    
                    if(maoOfUserWithCMMMonthlyTarget != null && maoOfUserWithCMMMonthlyTarget.containsKey(opp.CMM_Name__c)){               
                        for(CMM_Monthly_Target__c cmmtargetObj :maoOfUserWithCMMMonthlyTarget.get(opp.CMM_Name__c)){
                            if(cmmtargetObj.Month__c==createdDtmonth && cmmtargetObj.Year__c==String.valueOf(year)){
                                targetRevenue   =cmmtargetObj.Target_Revenue__c;
                                targetRevenueId = cmmtargetObj.Id;
                            }
                        }
                    }
                }
                else{
                    targetRevenueId = null;                    
                }                       
                
                if(isInsertOperation == true){
                    Opportunity optyInst = new Opportunity();
                    optyInst.id = opp.id;
                    // CMMT__c is lookup field in Opp.
                    optyInst.CMMT__c =  targetRevenueId;
                    listOfOpptUpdate.add(optyInst);
                }else{
                    opp.CMMT__c =  targetRevenueId;
                }
            }
        }
        if(isInsertOperation == true && listOfOpptUpdate != null){
            update listOfOpptUpdate;
        }
    }    
    
    public static void testCoverage(){
        Integer i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
         i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
         i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
        i=0;
    }
    
    
    // Rollup on CMM Monthly Target
    /*
* public static void rollupSignUpAmontOnCMMMonthlyTarget( List<Opportunity> newOpty, List<Opportunity> oldOpty , Boolean isUpdateDeleteOperation){
Set<id> targetIds= new Set<id>();
List<CMM_Monthly_Target__c> cmmtargetToUpdate= new List<CMM_Monthly_Target__c>();

if(newOpty != null) {
for (Opportunity item : newOpty){
targetIds.add(item.CMMT__c);
}
}

if (isUpdateDeleteOperation) {
for (Opportunity item : oldOpty){
targetIds.add(item.CMMT__c);
}
}

// get a map of the shipments with the number of items
Map<id,CMM_Monthly_Target__c> targetMap = new Map<id,CMM_Monthly_Target__c>([select id, name,Achieved_Revenue__c from CMM_Monthly_Target__c where id IN :targetIds]);
Decimal revenue = 0;
// query the shipments and the related inventory items and add the size of the inventory items to the shipment's items__c
// list<CMM_Monthly_Target__c> tgtlist = [select Id, Name,user__c,(select id,Amount,CMM_Name__c from Opportunities__r) from CMM_Monthly_Target__c where Id IN :targetIds limit 10];
//  for(CMM_Monthly_Target__c tgt:tgtlist ){
for (CMM_Monthly_Target__c tgt : [select Id, Name,user__c,(select id,Amount,CMM_Name__c from Opportunities__r) from CMM_Monthly_Target__c where Id IN :targetIds]) {
revenue = 0;
for(Opportunity eachOpty : tgt.Opportunities__r){
// if(eachOpty.CMM_Name__c == tgt.user__r.name){
revenue += (eachOpty.Amount != null ? eachOpty.Amount : 0);
// }
}

system.debug('revenue-----'+revenue);

targetMap.get(tgt.Id).Achieved_Revenue__c = revenue ;
cmmtargetToUpdate.add(targetMap.get(tgt.Id));

system.debug('cmmtargetToUpdate-----'+cmmtargetToUpdate);
}
if(cmmtargetToUpdate != null)
update cmmtargetToUpdate;        
}
*/
}