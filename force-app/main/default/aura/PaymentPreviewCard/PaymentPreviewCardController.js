({
    doInit : function(component, event, helper) {
        helper.init(component, event);
    },
	handleNextClick : function(component, event, helper) {
		$A.util.toggleClass(component.find("spinnerDiv"), "slds-hide");
        
        try {
        	helper.initiatePayment(component, event);
        }
        catch(e) {
            console.log(e);
        }
	}
})