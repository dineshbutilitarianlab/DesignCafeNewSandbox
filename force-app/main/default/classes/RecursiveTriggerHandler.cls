public class RecursiveTriggerHandler{
    public static Boolean isFirstTime = true;
    public static Boolean isFirstTimeAfter = true;
    public static Boolean isFirstTimeOpportunity = true;
    public static Boolean isFirstTimeAfterOpportunity = true;
    public static Boolean isFirstTimeLead = true;
    public static Boolean isFirstTimeAfterLead = true;
    
    public static boolean runOnce(){
        if(isFirstTime){
            isFirstTime = !isFirstTime;
            return !isFirstTime;
        }else{
            return isFirstTime;
        }
    }
    
    public static boolean runOnceAfter(){
        if(isFirstTimeAfter){
            isFirstTimeAfter = !isFirstTimeAfter;
            return !isFirstTimeAfter;
        }else{
            return isFirstTimeAfter;
        }
    }
    public static boolean runOnceLeadAfter(){
        if(isFirstTimeAfterLead){
            isFirstTimeAfterLead = !isFirstTimeAfterLead;
            return !isFirstTimeAfterLead;
        }else{
            return isFirstTimeAfterLead;
        }
    }
    public static boolean runOnceLead(){
        if(isFirstTimeLead){
            isFirstTimeLead = !isFirstTimeLead;
            return !isFirstTimeLead;
        }else{
            return isFirstTimeLead;
        }
    }
    public static boolean runOnceOpp(){
        if(isFirstTimeOpportunity){
            isFirstTimeOpportunity = !isFirstTimeOpportunity;
            return !isFirstTimeOpportunity;
        }else{
            return isFirstTimeOpportunity;
        }
    }
    public static boolean runOnceOppAfter(){
        if(isFirstTimeAfterOpportunity){
            isFirstTimeAfterOpportunity = !isFirstTimeAfterOpportunity;
            return !isFirstTimeAfterOpportunity;
        }else{
            return isFirstTimeAfterOpportunity;
        }
    }
}