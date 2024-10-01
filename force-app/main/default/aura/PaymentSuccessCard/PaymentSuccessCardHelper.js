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
	}
})