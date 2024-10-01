({
    Confirmation : function(component, event, helper){
        var action = component.get("c.showbutton");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            let invoiceStatus =response.getReturnValue();
            console.log(invoiceStatus);
            if (state === "SUCCESS") {
                if(response.getReturnValue() === 'DisableAcc'){
                    component.set("v.ShowButton",false)
                    component.set("v.HideButton",true)
                    component.set("v.errMsg","Account and opportunity owner should be same")
                    
                }
                else if(response.getReturnValue() === 'Enabled'){
                    component.set("v.ShowButton",true)
                    component.set("v.HideButton",false)
                }
                else if(response.getReturnValue() === 'DisAmount'){
                    component.set("v.ShowButton",false)
                    component.set("v.HideButton",true)
                    component.set("v.errMsg","Sign-up Amount should be completely Paid")
                    
                }
                
                else{
                    component.set("v.ShowButton",false)
                    component.set("v.HideButton",true)
                     component.set("v.errMsg","Invoice already exists for the current Opportunity")
                   
                }
            }
        });
        $A.enqueueAction(action);
    },
    generateNewInvoiceCall : function( component, event, helper ) {
        
        //component.set("v.invoiceVal",0)        
        let action = component.get( "c.generateNewInvoice" );
        component.set("v.Isdisabled",true);
        action.setParams({
            oppId: component.get( "v.recordId" ),
            //invType: component.get( "v.invoiceVal" )
        });
        action.setCallback(this, function(response) {
            console.log("Aura GenerateNewInvoice : Response : "+ response.toString());
            let state = response.getState();
            let invoiceStatus = response.getReturnValue();
            if (invoiceStatus !== undefined) {
                console.log("yes I am in");
                for (let i = 0; i < invoiceStatus.length; i++) {
                    //let Invoice = invoiceStatus[i].invoice;
                    let errorMessage = invoiceStatus[i].errorMessage;
                    let invoiceType = invoiceStatus[i].invoiceType;
                    let APIresptoAura = invoiceStatus[i].APIresptoAura;
                    let APIcodetoAura = invoiceStatus[i].APIcodetoAura;
                    console.log("ErrorMessage: " + errorMessage);
                    console.log("type : " + invoiceType);
                    console.log("APIcodetoAura : " + APIcodetoAura)
                    console.log("APIresptoAura : " + APIresptoAura)
                    //console.log("Invoice : " + Invoice);
                    
                    if (APIcodetoAura === '200') {
                        let showToast = $A.get( "e.force:showToast" );
                        showToast.setParams({
                            title : 'Invoice Generation successful for ' + invoiceType,
                            message : APIresptoAura.toString(),
                            type : 'success',
                        });
                        showToast.fire();
                    }
                    else if (APIcodetoAura === '400'){
                        let showToast = $A.get( "e.force:showToast" );
                        showToast.setParams({
                            title : 'Failure in invoice generation for1 ' + invoiceType,
                            message : APIresptoAura.toString(),
                            type : 'error'
                        });
                        showToast.fire();
                    }
                        else {
                            let showToast = $A.get( "e.force:showToast" );
                            showToast.setParams({
                                title : 'Failure in invoice generation for ' + invoiceType,
                                message : errorMessage,
                                type : 'error'
                            });
                            showToast.fire();
                        }
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction( action );
    },
    //Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        component.set("v.isSpinner", true); 
    },
    
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        component.set("v.isSpinner", false);
    }
})