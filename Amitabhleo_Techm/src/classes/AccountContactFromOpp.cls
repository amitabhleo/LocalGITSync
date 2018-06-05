/**
	@author Amitabh shrma
	date Feb 24rd, 2013
	The Objective is to get all the related Opportunity
	to an Account and create a Contact with the Opportunity Name
	When Employee number is not null
	This has to be bulkified thus using Set and Maps
**/
public class AccountContactFromOpp{
    
    public static void createContactfromOpp(Account[] acc){
        
        //Firstly creating a Set and populating all the Account Id in it
        	Set<ID> acctId = new Set<ID>();
        for(Account a : acc){
            if (a.numberOfEmployees <>Null){
        	acctId.add(a.Id);
            }
            System.debug('****'+acctId);
        }
        
        /**
			Secoundlty querying the Opportunity Table from the Account Ids
          	here the SOQL query will use IN: and not just =: as what we are
			Passing is a list and then saving this is a list
        **/
        Map<ID,Opportunity> myOppMap = new Map<ID,Opportunity>();
        //Creating a list of contacts which can be later upserted all in once
        List<Contact> myContactList = new List<Contact>();
        //passing the values of the accID in the Opportunity
        for(Opportunity thisOpp : [SELECT Id, Name,AccountId from Opportunity where AccountId IN:acctId]){
        //passing these values in the MAP
            myOppMap.put(thisOpp.AccountId,thisOpp);
            System.debug('*****'+myOppMap.size());
            //System.debug('*****'+myOppMap.get('00190000008lAhD').Name);
        //In order to bulkyfy passing all this values in a List of myContactList instantiated
            for(Account a2 : acc){
            if (a2.numberOfEmployees <>Null){
        		Contact cont = new Contact();
                cont.LastName = myOppMap.get(a2.Id).Name;
                cont.accountId = a2.Id;
                myContactList.add(cont);
             	}    
            
            }
        }
        
        //Thirdly upserting the value of the list of Opp Names as new Contacts
    	//This has to be in the scope where I have defined the contact list
    	upsert myContactList;
    }
	
}