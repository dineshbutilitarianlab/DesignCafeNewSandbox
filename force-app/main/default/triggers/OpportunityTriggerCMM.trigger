trigger OpportunityTriggerCMM on Opportunity (after insert, after Update , after delete, before insert, before update) {
 if( Trigger.isInsert) {        
        if(Trigger.isBefore){
            
        }
        if(Trigger.isAfter){
        
        }
        
    }
    else if(Trigger.isUpdate) { 
                    
        if(Trigger.isBefore){
      
            OpportunityTriggerCMMhandler.getTargetRevenueOfCMMs(trigger.new, trigger.oldMap , false);
        }
              
        if(Trigger.isAfter){
       
            //OpportunityTriggerCMMhandler.rollupSignUpAmontOnCMMMonthlyTarget(trigger.new , trigger.old , true);
           
        }
    }
    else if(Trigger.isDelete){

        //OpportunityTriggerCMMhandler.rollupSignUpAmontOnCMMMonthlyTarget(trigger.new , trigger.old , true);
    }
}