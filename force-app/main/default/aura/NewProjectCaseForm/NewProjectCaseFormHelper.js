({
    validateCaseForm: function(component) {
        var validCase = true;
        
        // Show error messages if required fields are blank
        var allValid = component.find('caseField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
        // Verify we have an account to attach it to
        var project = component.get("v.project");
        if($A.util.isEmpty(project)) {
            validCase = false;
            console.log("Quick action context doesn't have a valid Project.");
        }

        return(validCase);
	}
    }
})