//@author Amitabh Date May 4th, 2013
//Writing a trigger on Task to roll up all the Est in Mins to the corresponding
//Business requirement.
trigger rollUpEstMinsBulk on Task (after undelete) {
    //Set to make and pass the value and the condition
    //Since I have to commit the Business requirement so I will use the Business Req Ids
    Set<Id> bussReqId = new Set<Id>();
    Business_Requirement__c  nreBR = new Business_Requirement__c();
    //Iterating thru the trigger.new and adding the Ids to the Task
        for(Task tsk : trigger.new){
           for (Business_Requirement__c br :[SELECT Id, Original_Est_Rollup_Mins__c,Remaining_Est_Rollup_Mins__c,
                                          Original_Rollup__c
                                          FROM Business_Requirement__c where Id =:tsk.WhatId]){ 
             //updating the Set with Business Req Id's
                                              nreBR = br;
                bussReqId.add(br.Id);
                System.debug('*****'+bussReqId);
                     }
        }
    
    //Map to make Id and the WhoId and pass all the values of Set i.e IDs using In operator
        Map<Id,Task> taskMap = new Map<Id,Task>();
        //List of Business req which will be upserted at the last
        List<Business_Requirement__c> brList = new List<Business_Requirement__c>();
        //Created a List of the Tasks and pass the value of the Map
            for (Task allTsk : [SELECT Id, WhatId,Status, Original_Est_Mins__c,Remaining_Est_Mins__c 
                                FROM Task where WhatId IN: bussReqId]){
               
            //updating the value in the map
            taskMap.put(allTsk.WhatId,allTsk);    
                                }
        //Iterating thru the trigger again
    //INt intVar = 0;
     //for(Task tsk : taskMap){
        /****
       Business_Requirement__c br = new Business_Requirement__c(); 
         //inetialising roll up 0 for recalculation on every update                               
            br.Original_Est_Rollup_Mins__c = 0; 
            br.Remaining_Est_Rollup_Mins__c = 0; 
       ****/
         
        // intVar = intVar +tsk.Original Est
     }
    /*
    if(nreBR != null)
    {
            /nreBR.Original Est Rollup = nreBR.Original Est Rollup+intVar;
        try{
            update nreBR;
        }
        catch...
        System.debug();
        
    }
    //Upsert the List
}*/