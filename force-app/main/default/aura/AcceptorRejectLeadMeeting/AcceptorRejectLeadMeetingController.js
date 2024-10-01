({
    doInit : function(cmp, event, helper){
         try {
             cmp.set("v.isAcceptedOrRejected",false);
           var action = cmp.get("c.checkDesignerStatus");
            action.setParams({aRecID : cmp.get("v.recordId")});
            action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS") {
                    console.log('Server Response' + response.getReturnValue());
                    cmp.set("v.message", response.getReturnValue());
                   if(response.getReturnValue() === $A.get("$Label.c.Designer_Accepted")){
                     cmp.set("v.isAcceptedOrRejected",true);
                     cmp.set("v.message", $A.get("$Label.c.Designer_Accepted"));                       
                   }else if(response.getReturnValue() === $A.get("$Label.c.Designer_Rejected")){
                     cmp.set("v.isAcceptedOrRejected",true);
                     cmp.set("v.message", $A.get("$Label.c.Designer_Rejected"));
                   }
          else if(response.getReturnValue() === $A.get("$Label.c.Invalid_Designer")){
                     cmp.set("v.isAcceptedOrRejected",true);
                     cmp.set("v.message", $A.get("$Label.c.Invalid_Designer"));
                   }                   
                }
                else {
                    console.log('Server call failed!');
                }
            });
        }
        catch(e) {
            console.log(e);
        }
        
        $A.enqueueAction(action);
        
    },
    
    AcceptLeadMeeting : function(cmp, event, helper) {
        try {
          
            var action1 = cmp.get("c.assignDesignOwnership");
            action1.setParams({aRecID : cmp.get("v.recordId")});
            
            action1.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS") {
                    console.log('Server Response' + response.getReturnValue());
                    //cmp.set("v.message", response.getReturnValue());
                   
                   if(response.getReturnValue() === $A.get("$Label.c.Designer_Accepted")){
                     cmp.set("v.isAccepted",true);
                   }
                     var toastEvent = $A.get("e.force:showToast");
   					 toastEvent.setParams({
     			      "title": "Success!",
                         "type" : "success",
      				  "message": "You are now the Design owner for this Lead."
  					  });
   						 toastEvent.fire();
					$A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                else {
                    console.log('Server call failed!');
                }
            });
        }
        catch(e) {
            console.log(e);
        }
        
        $A.enqueueAction(action1);
    },
    
    RejectLeadMeeting : function(cmp, event, helper) {
        try {
            
            var action2 = cmp.get("c.designOwnershipRejected");
            action2.setParams({aRecID : cmp.get("v.recordId")});
            
            action2.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log('Server call succeeded!');
                   // cmp.set("v.message", response.getReturnValue());
                    
                     var toastEvent = $A.get("e.force:showToast");
   					 toastEvent.setParams({
     			      "title": "Success!",
                         "type" : "success",
      				  "message": "You successfully Rejected this Lead."
  					  });
   						 toastEvent.fire();
					$A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                else {
                    console.log('Server call failed!');
                }
            });
        }
        catch(e) {
            console.log(e);
        }
        
        $A.enqueueAction(action2);
    },   
    
})