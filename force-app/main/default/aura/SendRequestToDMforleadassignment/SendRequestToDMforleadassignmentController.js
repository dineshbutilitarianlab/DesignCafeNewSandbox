({
         doInit : function(cmp, event, helper){
             try {
               var action = cmp.get("c.checkDesignerTLStatus");
                action.setParams({aRecID : cmp.get("v.recordId")});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                   if (state === "SUCCESS") {
                        console.log('Server Response' + response.getReturnValue());
                       
                       if(response.getReturnValue() === $A.get("$Label.c.Designer_TL_Rejected_Lead")){
                         cmp.set("v.isAcceptedOrRejected",true);
                         cmp.set("v.message", $A.get("$Label.c.Designer_TL_Rejected_Lead"));                       
                       } 
                      else{
                       var toastEvent = $A.get("e.force:showToast");
                         toastEvent.setParams({
                          "title": "Success!",
                             "type" : "success",
                          "message": "You successfully Requested DM to assign Designer."
                          });
                         toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire(); 
    
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
            
        }
             
        
    })