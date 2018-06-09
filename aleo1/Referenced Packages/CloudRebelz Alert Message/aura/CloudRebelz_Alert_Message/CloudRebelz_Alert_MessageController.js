({
	doInit : function(component, event, helper) {        
        const fieldToFetch = [];
    	fieldToFetch.push(component.get("v.toastField"));
    	component.set("v.formattedFields", fieldToFetch);       
	},
    showToast : function(component, event, helper) {        
        const errorMsg = component.get('v.fields.'+component.get("v.toastField"));
        const toastMode = component.get('v.toastMode');
        const toastType = component.get('v.toastType');
        const toastDuration = component.get('v.toastDuration');
        if(errorMsg){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: toastMode,
                message: errorMsg,
                type: toastType,
                duration: toastDuration
            });
            toastEvent.fire();
        }            
	}
})