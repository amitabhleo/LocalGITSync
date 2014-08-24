trigger UpdateGRMfromSU on Account (before insert, before update) {
    
    for(Account acc:Trigger.new){
//Step 1 Pass the Ids of the Sales Unit in a Set
        Set<Id> sUnit_Id = new Set<Id>();
        //Set<Id> accountId = new Set<Id>();
        if(acc.Sales_Unit_Group__c <> NULL){
            sUnit_Id.add(acc.Sales_Unit_Group__c);
            //AccountId.add(acc.Id);
        }
//Step 2 get the user id from the respective Account.SalesUnit.GRM in a MAP
     	Map<Id,Id> accIdSuId = new Map<Id,Id>();
        for(Account acc1:[SELECT Id, Name, Sales_Unit_Group__c,Account.Sales_Unit_Group__r.User__c 
                          FROM Account where Account.Sales_Unit_Group__r.User__c != NULL 
                          AND Sales_Unit_Group__c IN : sUnit_Id]){
             
           	accIdSuId.put(acc1.Id,acc1.Sales_Unit_Group__r.User__c );                 
        	System.debug('owner1 : '+accIdSuId.get(acc1.Id));
             }
    
//Step 3 Upsert the GRM
	     	List<Account> accList = new List<Account>();
            for(Account acc2 : Trigger.new){
                Account acc3 = new Account();
                acc3.AccountNumber = 'test123';
                acc3.Id = acc2.Id;
                //acc3.OwnerId = accIdSuId.get(acc2.Id);
                accList.add(acc3);
                System.debug('acc3 Owner '+accIdSuId.get(acc2.Id));
                }
            Upsert accList;
		}
}