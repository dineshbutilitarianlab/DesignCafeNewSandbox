({
	onSave : function(component, event, helper) {
		helper.RejectDesigner(component, event, helper);
	},
    onCancel:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
	}
})