({
	handleRecordUpdated : function(cmp, event, helper) {
        if(navigator.userAgent !== undefined && navigator.userAgent.toLowerCase().indexOf('salesforcemobilesdk') != -1) {
            window.open($A.get('$Label.c.community_landing_page') + '/apex/PaymentPageRedirection?id=' + 
                        cmp.get('v.recordId'), '_blank')
            //window.open('https://www.google.com/', '_blank');
        }
        else {
            window.open($A.get('$Label.c.community_landing_page') + '/Customer/apex/PaymentPageRedirection?id=' + 
                        cmp.get('v.recordId'), '_blank');
            //window.open('https://www.bing.com/search?q=' + encodeURI(navigator.userAgent), '_blank');
        }

        //window.open(cmp.get('v.invoiceRecord.Payment_Link__c'), '_blank');  
        $A.get("e.force:closeQuickAction").fire();
	}
})