public class AccountContactFromOpp {
    
     /*
        We want to populate all Opportunity Names as a new Contact in an Account
        when the field ContOpp__c is checked or is true.
    
    */
    //creating a public static method to call the 
        
    public static void accountContactFrmOpp(Account[] acc2){
   		
            //passing the ID into a Map
            Set<ID> AcctId = new Set<ID>();
            //passing the Ids in the set
            //for (Account acct : Trigger.new){
                for (Account acct :acc2){   
                if (acct.ContOpp__c ==true)
                AcctId.add(acct.Id);
            }//end for acct
            //Creating a MAP to pass the values of SET and populate the corresponding
            //Opportunity Obj in it.
            
            Map<ID,Opportunity> myOppMap = new Map<ID,Opportunity>();
            //Also creating a Contact collection which can be uploaded with one upsert
            List<Contact> contList = new List<Contact>();
            //passing the values in Map
            for (Opportunity thisOpp :[Select Id,Name, AccountId from Opportunity where AccountId IN :AcctId])
            {
            //Now populating the Id in the Map
            myOppMap.put(thisOpp.AccountId,thisOpp);
            //looping thru the trigger.new again
           
            for (Account a : acc2){
                //thru the vonditions
                if (a.ContOpp__c == true){  
                    Contact cont = new Contact();
                    //cont.RecordTypeId = '012900000005tC6';
                    //cont.LastName = myOppMap.get(a.Id).Name; // commentedd by prajnith
                    //cont.LastName ='ABC Contact';
                    //cont.AccountId = a.Id; // commentedd by prajnith
                    contList.add(cont);
                }
                
            }
            }//end for thisOpp
            //Upsert collection here
           //upsert contList; // commented by prajnith
	}//end accountContactFrmOpp method
}