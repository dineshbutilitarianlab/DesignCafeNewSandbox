({
    init : function(component, event) {
        try {
            var att_start = window.location.href.indexOf('?') + 1;
            var keys = window.location.href.substring(att_start).split('&');
			
            for(var i=0; i < keys.length; i++) {
                var block = keys[i].split('=');
                
                if(block[0] == 'k') {
                    component.set("v.key", decodeURIComponent(block[1]));
                    this.initPaymentInfo(component, event);
                    break;
                }
            }
        }
        catch(e) {
            console.log(e);
        }
    },
	initPaymentInfo : function(cmp, event) {
        var action = cmp.get("c.getPaymentInfo");
        action.setParams({ aStrKey : cmp.get("v.key") });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                
                if(ret.status_code == '200') {
                    cmp.set("v.paymentInfo", ret.payment_info);
                }
            }
            else if (state === "ERROR") {
				console.log('^^^ error');
            }
        });

        $A.enqueueAction(action);
	},
	initiatePayment : function(cmp, event) {
        var action = cmp.get("c.generateOrderID");
        action.setParams({ aStrKey : cmp.get("v.key") });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                
                if(ret.status_code == '200') {
                    this.saveOrderId(cmp, event, ret.order_id);
                }
                else {
                    try {
                    	$A.util.addClass(cmp.find("spinnerDiv"), "slds-hide");
                    }
                    catch(e) {
                        console.log('^^^ ' + e);
                    }
                    this.showToast('error', 'Error', ret.status_message);
                }
            }
            else if (state === "ERROR") {
				console.log('^^^ ' + ret.status_message);
            }
        });

        $A.enqueueAction(action);
	},
	saveOrderId : function(cmp, event, order_id) {
        var action = cmp.get("c.saveOrderID");
        action.setParams({ aStrKey : cmp.get("v.key"), aOrderID : order_id });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                
                if(ret.status_code == '200') {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    
                    urlEvent.setParams({
                        "url": "/Customer/s/payment?k=" + encodeURIComponent(cmp.get("v.key") + '&o=' + order_id)
                    });
                    
                    urlEvent.fire();
                }
                else {
                    $A.util.addClass(cmp.find("spinnerDiv"), "slds-hide");
                    this.showToast('error', 'Error', ret.status_message);
                }
            }
            else if (state === "ERROR") {
				console.log('^^^ error');
            }
        });

        $A.enqueueAction(action);
	},
    showToast : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        
        toastEvent.fire();
    }
})