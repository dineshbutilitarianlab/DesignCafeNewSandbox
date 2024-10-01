@RestResource(urlMapping='/ProposalDate')
global without sharing class Proposal_Sent_Date {
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(),DetailsWrap.class);
        try{
            List<Opportunity> opp = [SELECT id,Proposal_Sent_Date__c,Mobile__c,StageName FROM Opportunity Where Mobile__c =:allDetails.Mobile Limit 1];
            if(opp.size() !=0){
                Opportunity o = new Opportunity();
                o.Id = opp[0].id;
                if(allDetails.Proposal_Date !=null && opp[0].StageName !='Closed Won'){
                   // o.Proposal_Sent_Date__c = allDetails.Proposal_Date;
                   // o.StageName='Proposal Sent';
                   // update o;
                    response.StatusCode = '200';
                    response.status = 'Success';
                    response.message = 'Sent successfully';
                }else{
                 /*   response.StatusCode = '200';
                    response.status = 'Success';
                    response.message = 'Opportunity is already ClosedWon'; */
                }
            }
        }
        catch(Exception exc) {
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = exc.getMessage();
        }
    //Api Call Logger
     ApiCallLogger.method(system.UserInfo.getUserId(),'/ProposalDate', req.requestBody.toString(), Response.message, 'in');
        return response;
    }  
    global class DetailsWrap{       
        public string Mobile;
        public Date Proposal_Date;       
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String StatusCode;
    }
}