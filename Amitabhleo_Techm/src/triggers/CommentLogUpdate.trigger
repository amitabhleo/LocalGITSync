trigger CommentLogUpdate on Task (before insert,before update)
{
    List <ID> WhtIds= new List <Id>();
    for (Task oTask :Trigger.new )
    {
        if (oTask.whatId!=null && String.ValueOf(oTask.whatId).substring(0,3)=='a06' )
        {
            WhtIds.add(oTask.whatId);
        }
    }
    Map  <ID,Business_Requirement__c> MapIdBR = new Map<ID,Business_Requirement__c> ([select id,Task_Comment_Log__c From Business_Requirement__c where id in: WhtIds ]);
    for (Task oTask :trigger.new)
    {
         if (MapIdBR.get(oTask .whatid).Task_Comment_Log__c!=null && MapIdBR.get(oTask .whatid).Task_Comment_Log__c!='' && oTask.Description!=null && oTask.Description!='' )
         {
             MapIdBR.get(oTask .whatid).Task_Comment_Log__c ='<b>'+userInfo.getName()+':'+System.now()+'<br/>'+ oTask.Description + '<br/><hr><br/>'+MapIdBR.get(oTask .whatid).Task_Comment_Log__c;
         }
         else if (oTask.Description!=null && oTask.Description!='')
         {
              MapIdBR.get(oTask .whatid).Task_Comment_Log__c ='<b>'+userInfo.getName()+':</b>'+System.now()+'<br/>'+ oTask.Description + '<br/><hr>';
         }
         oTask.Description='';
    }
    update MapIdBR.values();
     
}