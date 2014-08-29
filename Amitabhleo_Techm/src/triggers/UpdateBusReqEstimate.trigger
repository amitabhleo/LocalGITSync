trigger UpdateBusReqEstimate on Business_Requirement__c (before insert,before update) {
	//@author amitabh date 22/6/2013
    //objective of the trigger is to update the Estimate in minutes
    for(Business_Requirement__c br : Trigger.new){
        if(br.Est_Effort_HL__c !=Null || br.Est_Effort_HL__c !=''){
        	ConvertToMin ctm = new ConvertToMin();
      		br.Est_HL_Min__c = ctm.ConvertToMins(br.Est_Effort_HL__c);
            
        }
       //Business_Requirement__c br1 = new Business_Requirement__c();
        
    }
}