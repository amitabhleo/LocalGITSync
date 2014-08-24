trigger SpamAccount on Case (After Insert , After Update) 
{
    List<Case> CaseList   = trigger.new;
    List<ID>   SpamAccIDs = new List<ID>();
    List<Account> AccountSpam = new List<Account>();
    for(case ocase :  caseList )
    {
        if(ocase.Spam__c == true)
        {                   
            SpamAccIDs.add(ocase.Accountid);   
        }
    }

    
    if(SpamAccIDs.size() > 0)
    {       
        for(Account Oacc : [SELECT ID,Spam_Account__c FROM Account WHERE ID IN: SpamAccIDs ])                       
        {
            Oacc.Spam_Account__c = true;            
            AccountSpam.add(oacc);
        }
        update AccountSpam;
    }


}