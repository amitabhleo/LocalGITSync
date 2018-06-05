/*
	we want to dynamically assign the Account permissions based on the Account Zip code
	if the Zip code is changed then the Territory members shared with the account will be
	removed and New members after checking the account Zip from Territory Zip code will be added.
*/
trigger SFDC99_Chap7_UpdateTerritory on Account (after insert,before update) {
    //Step 1: Querying all accounts which has BillingPostalCode
  		Set<String> accZipCode = new Set<String>();
    	for(Account acc : Trigger.new){
           
            // chcking if trigger is inserted  
            // 	only those accounts which have Postal code       
                if(Trigger.isinsert && acc.BillingPostalCode != NULL) {
                    accZipCode.add(acc.BillingPostalCode); 
                    } 
            //taking all the old values of the trigger
            if(Trigger.isUpdate){
            Account OldAcc = Trigger.oldmap.get(acc.id);
            //compare the old and the new values of the zipcode to check if changed
            Boolean zipIsChanged = (acc.BillingPostalCode <> oldAcc.BillingPostalCode);
        	
     //Step 2: Check if the account is edited and Postal code is changed
          	//now checking if the Trigger is update and the value of zip code is changed
                //if(Trigger.isupdate && zipIsChanged == true){
                    accZipCode.add(acc.BillingPostalCode); 
                    //I will remove all the current members 
                    List<AccountShare> removeShare = new List<AccountShare>();
                    for(AccountShare remShare :[SELECT Id, AccountId, UserOrGroupId, 
                                                AccountAccessLevel, RowCause FROM AccountShare
                                                where AccountId =:acc.Id AND RowCause = 'Manual']){
                        
                        System.debug('AccountShare Name'+remShare.Id+' '+remShare.RowCause);
                    	
                    	removeShare.add(remShare);
                		}
                   		delete removeShare;
                    }
            
    	}
    	System.debug('zip codes in list are'+accZipCode.size());
   
    //Step 3: Getting all Territories which have the matching postal code
        //Also getting all the members in those territories
        //Creating a Map of ZIp and Territory
        Map<String, Territory__c> zipTerriMap = new Map<String, Territory__c>();
        for(Territory__c terr :[SELECT Id,Name,Zip_Code__c,
                                    (SELECT Id, Name, User__c, Territory__c FROM 
                                     Territory_Members__r) FROM Territory__c 
                                WHERE zip_Code__c IN: accZipCode]){
          //passing the values to the map
        zipTerriMap.put(terr.ZIP_Code__c, terr);
                              
    }
   		//Step 4: Getting the members of the territory and sharing using Account Sharing Obj
            
            for(Account acc2 : Trigger.new){
                List <AccountShare> accShareList = new List <AccountShare>(); 
              //Checking the values of the users
                if(zipTerriMap.get(acc2.BillingPostalCode)<>null){
                System.debug('user in the'+zipTerriMap.get(acc2.BillingPostalCode).Name); 
                    for(Territory_Member__c terriMember :[SELECT Id, Name, User__c, Territory__c FROM Territory_Member__c
                                  where Territory__c =: 
                                    zipTerriMap.get(acc2.BillingPostalCode).Id]){
                                        AccountShare accShare = new AccountShare();
                                        accShare.AccountId = acc2.Id;
                                        accShare.AccountAccessLevel = 'Edit';
                                        accShare.UserOrGroupId = terriMember.User__c ; 
                                        accShare.OpportunityAccessLevel = 'read'	;
                                        accShareList.add(accShare);
                                    }
            		  //Step 5: Buklyfying the code		
                    upsert accShareList;
        		}
    }
    
    
}