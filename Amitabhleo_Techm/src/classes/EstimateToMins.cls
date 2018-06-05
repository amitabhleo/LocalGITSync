//@amitabh 19/9/2012 updating EstimateMins from Estimate
//copied on this instance to 20/04/2013
public class EstimateToMins {
    //using static so that no need to instantiate for testing
    public static void convertEstimate(Task[]td){
        //iterating thru the array
        
        for(Task tsk:td){
            //Intantiating the ConvertToMin  Class
            ConvertToMin ctm = new ConvertToMin();
            
            if(tsk.Log_Time__c !=Null && tsk.Update_Remaining_Est__c == True){
                System.debug('logtime'+tsk.Log_Time__c);
                 System.debug('updatelogtime'+tsk.Update_Remaining_Est__c);
                
                //convert log time to mins and substract with remaining time
                Integer log_time_min = ctm.ConvertToMins(tsk.Log_Time__c);
                tsk.Original_Est_Mins__c = ctm.ConvertToMins(tsk.Original_Estimate__c);
                
                //tsk.Remaining_Est_Mins__c = ctm.ConvertToMins(tsk.Remaining_Estimate__c);
                if (tsk.Remaining_Estimate__c!=null)
                tsk.Remaining_Est_Mins__c = (ctm.ConvertToMins(tsk.Remaining_Estimate__c)-log_time_min);
                
                //calling the method again to convert to wdm
                tsk.Remaining_Estimate__c = ctm.logMintoHours((tsk.Remaining_Est_Mins__c).intValue());
                System.debug('remaining est'+tsk.Remaining_Estimate__c);
              }else{
                tsk.Original_Est_Mins__c = ctm.ConvertToMins(tsk.Original_Estimate__c);
                tsk.Remaining_Est_Mins__c = ctm.ConvertToMins(tsk.Remaining_Estimate__c);
            	} 

        }//endfor
    }//endMethod
     
}