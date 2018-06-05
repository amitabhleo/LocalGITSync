trigger OpenTaskError on Business_Requirement__c (before insert, before update) {
    /**
        @author Amitabh Sharma
        date : 22nd Feb 2012
        The objective is to throw an error on saving the status of Business req
        as closed, if an open task is there, since there is no parent child relationship
        between Br and Tasks.
    **/
    //As we know Trigger.new will return a list 
    for(Business_Requirement__c br :Trigger.new){
        if(br.stage__c == 'Completed'){
            list<Task> tsk =[SELECT Id, 
                                 WhatId, 
                                 Status 
                             FROM 
                                Task 
                             WHERE WhatId =: br.Id 
                             AND 
                                Status <> 'Completed'];
            if (tsk.size()>0){
                br.addError('Please close all open tasks first');
          }
        }
    }
 
}