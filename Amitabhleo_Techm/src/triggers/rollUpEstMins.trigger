/**
    @author Amitabh
    Date 5/03/2013
    since the Task and Business requirements are not a parent child relationship
    hence we have to write  atrigger to rollup the Original Est in Mins field to Business req.
    We already have UpdateEstimateinMins Trigger before insert before update
    which is converting day, weeks to minutes.
**/
trigger rollUpEstMins on Task (after insert,after update,after delete)
{
    //Variable Declartion
    Set<Id> sBusiness_ReqIds = new Set<Id>();
    String strPrefix = Business_Requirement__c.SObjectType.getDescribe().getKeyPrefix();
   
    
    List<Business_Requirement__c> lstBusinessReq = new List<Business_Requirement__c>();
    List<Business_Requirement__c> lstUpdateBusinessReq = new List<Business_Requirement__c>();
    if(Trigger.IsInsert || Trigger.isUpdate)
    {
        for(Task oTask : Trigger.new)
        {
            //taking only Business Requirement Tasks
            if(oTask.WhatId != null && String.valueOf(oTask.WhatId).startsWith(strPrefix))
               
            {
             	//adding the Bussiness Req Id to the list
                sBusiness_ReqIds.add(oTask.WhatId);
            }
        }
    }
    if(Trigger.isDelete)
    {
        for(Task oTask : Trigger.old)
        {
            if(oTask.WhatId != null && String.valueOf(oTask.WhatId).startsWith(strPrefix))
            {
                sBusiness_ReqIds.add(oTask.WhatId);
            }
        }
    }
    
    if(sBusiness_ReqIds != null && sBusiness_ReqIds.size()>0)
    {
        //using a nested query instead of using a map here
        lstBusinessReq = [SELECT Id, 
                                 Original_Est_Rollup_Mins__c,
                                 Remaining_Est_Rollup_Mins__c,
                                 Original_Rollup__c,
                                 (Select Id,Original_Est_Mins__c,Remaining_Est_Mins__c from Tasks)
                         FROM Business_Requirement__c where Id IN :sBusiness_ReqIds];
    }
    if(lstBusinessReq != null && lstBusinessReq.size()>0)
    {
        for(Business_Requirement__c oBusiness_Requirement : lstBusinessReq)
        {
            Decimal decOriginal_Est_Rollup_Mins = 0;
            Decimal decRemaining_Est_Rollup_Mins = 0;
            
            for(Task oTask : oBusiness_Requirement.Tasks)
            {
                if(oTask.Original_Est_Mins__c != null)
                decOriginal_Est_Rollup_Mins +=oTask.Original_Est_Mins__c;
                if(oTask.Remaining_Est_Mins__c != null)
                decRemaining_Est_Rollup_Mins +=oTask.Remaining_Est_Mins__c;
            }
            //Instantiating a new Business req Object and passwing the Id
            Business_Requirement__c oBusiness_Req = new Business_Requirement__c(Id=oBusiness_Requirement.Id);
            oBusiness_Req.Original_Est_Rollup_Mins__c = decOriginal_Est_Rollup_Mins;
            oBusiness_Req.Remaining_Est_Rollup_Mins__c = decRemaining_Est_Rollup_Mins;
            Integer Int_Original_Est_Rollup_Mins = decOriginal_Est_Rollup_Mins.intValue();
            //updating the mins to wmd
            ConvertToMin ctm = new ConvertToMin();
            oBusiness_Req.Original_Rollup__c = ctm.convertMinToWeek(Int_Original_Est_Rollup_Mins);
            lstUpdateBusinessReq.add(oBusiness_Req);
            
        }
    }
    if(lstUpdateBusinessReq != null && lstUpdateBusinessReq.size()>0)
    {
        update lstUpdateBusinessReq;
    }
    
    
    
    //trigger rollUpEstMins on Task (after delete) {
    //I am directly using this trigger and not calling an apex class
    //on Edit of a task I will be calling all the child tasks of the parent and update
    /*for(Task tsk : Trigger.new)
    {
        for (Business_Requirement__c br :[SELECT Id, Original_Est_Rollup_Mins__c,Remaining_Est_Rollup_Mins__c,
                                          Original_Rollup__c
                                          FROM Business_Requirement__c where Id =:tsk.WhatId]){
            System.debug('******'+br.Id);
            br.Original_Est_Rollup_Mins__c = 0; 
            br.Remaining_Est_Rollup_Mins__c = 0;                                  
            for (Task allTsk : [SELECT Id, WhatId,Status, Original_Est_Mins__c,Remaining_Est_Mins__c 
                                FROM Task where WhatId =: br.Id]){
            ConvertToMin ctm = new ConvertToMin();                    
                if(allTsk.Status !='Completed'){ 
                    br.Original_Est_Rollup_Mins__c = (br.Original_Est_Rollup_Mins__c + allTsk.Original_Est_Mins__c);
                    br.Remaining_Est_Rollup_Mins__c = (br.Remaining_Est_Rollup_Mins__c + allTsk.Remaining_Est_Mins__c);
                   }
                    else{
                    br.Original_Est_Rollup_Mins__c = (br.Original_Est_Rollup_Mins__c + allTsk.Original_Est_Mins__c);                                    
              System.debug('******from task**'+allTsk.Original_Est_Mins__c);
                    }                      
            }
            System.debug('******FROM br'+br.Original_Est_Rollup_Mins__c);                                         
            upsert br;                                  
        }
    }*/
}