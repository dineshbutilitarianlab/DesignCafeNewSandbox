({
	doAccept: function(component, event, helper) {
        helper.handleResponse(component, event, 'Yes');
	},
    
    doReject: function(component, event, helper) {
		helper.handleResponse(component, event, 'No');
        
	} 
})