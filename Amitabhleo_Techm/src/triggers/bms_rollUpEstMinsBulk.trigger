/*
	@author amitabh July 13, 2013
	adding the details here to compare with index
*/

trigger bms_rollUpEstMinsBulk on Task (after insert, after update) {
	//declaring varibles
    Set <ID> setIdBussReq = new Set<ID>();
    String strPrefix = Business_Requirement__c.SObjectType.getDescribe().getKeyPrefix();
    
    List <Business_Requirement__c> lstBussReq = new List <Business_Requirement__c>();
    List <Business_Requirement__c> lstUpdateBussReq = new List <Business_Requirement__c>();
    //Iterating the Trigger now
    if(Trigger.isUpdate || Trigger.isInsert){
        for(Task oTask : Trigger.new){
            //testing for the Buss Req Task Type
            if(oTask.WhatId != null && String.valueOf(oTask.WhatId).startsWith(strPrefix)){
            //updating the Id in the set
                setIdBussReq.add(oTask.WhatId);             
            }
        }
    }
    //updating on delete
     if(Trigger.isDelete){
        for(Task oTask : Trigger.old){
            //testing for the Buss Req Task Type
            if(oTask.WhatId != null && String.valueOf(oTask.WhatId).startsWith(strPrefix)){
            //updating the Id in the set
                setIdBussReq.add(oTask.WhatId);             
            }
        }
     }
    //now iteraing thru the set of Bussiness Id
    if(setIdBussReq != null && setIdBussReq.size() >0){
    	//using a nested query to view the Buss req Object
        lstBussReq = [SELECT Id, 
                                 Original_Est_Rollup_Mins__c,
                                 Remaining_Est_Rollup_Mins__c,
                                 Original_Rollup__c,
                                 (Select Id,Original_Est_Mins__c,Remaining_Est_Mins__c from Tasks)
                         FROM Business_Requirement__c where Id IN:setIdBussReq];
    }
    //iterating thru the list
    if(lstBussReq != null && lstBussReq.size() >0){
        
        for (Business_Requirement__c oBusiness_Requirement :lstBussReq){
            
    	//defining variables
        Integer intOriginal_Est_Rollup_Mins = 0;
        Integer intRemaining_Est_Rollup_Mins = 0;
            //iterate and add the tasks and adding the Roll ups
            for(Task oTask : oBusiness_Requirement.Tasks){
            	if(oTask.Original_Est_Mins__c != null)
                intOriginal_Est_Rollup_Mins +=Integer.valueOf(oTask.Original_Est_Mins__c);
                if(oTask.Remaining_Est_Mins__c != null)
                intRemaining_Est_Rollup_Mins +=Integer.valueOf(oTask.Remaining_Est_Mins__c);
             }  
            //again iterating the business requirement and passing the value in updateBussReq
         Business_Requirement__c oBussiness_Req = new Business_Requirement__c(Id = oBusiness_Requirement.Id);
            oBussiness_Req.Original_Est_Rollup_Mins__c =intOriginal_Est_Rollup_Mins;
            oBussiness_Req.Remaining_Est_Rollup_Mins__c = intRemaining_Est_Rollup_Mins;
              //updating the mins to wmd
            ConvertToMin ctm = new ConvertToMin();
            oBussiness_Req.Original_Rollup__c = ctm.convertMinToWeek(intOriginal_Est_Rollup_Mins);
            lstUpdateBussReq.add(oBussiness_Req);
    	}
    }
    if (lstUpdateBussReq != null && lstUpdateBussReq.size() >0){
    	update lstUpdateBussReq;
    }    
}