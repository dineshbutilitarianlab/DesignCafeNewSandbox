({
         doInit : function(cmp, event, helper){
             try {
               helper.deleteExistingTLGroup(cmp, event, helper);
               helper.addNewTLGroup(cmp, event, helper);
             }
            catch(e) {
                console.log(e);
            }                     
             
        }        
    })