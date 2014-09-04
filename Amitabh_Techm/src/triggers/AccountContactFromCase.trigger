/*
	@author Amitabh Sharma
	@date March 3, 2014
	@details:	creating contacts for all accounts with the case number and also bulkifying
				using set and no map as will be querying the accountId from the case
*/
trigger AccountContactFromCase on Account (after insert, before update) {
	Set<ID> accId = new Set<ID>();
    //using Trigger.old as want to capture all the after update context becase we 
    //want to check the spam accounts which will come only after update
    //acc.Spam_account__c is not working to check
    for(Account acc:Trigger.new){
        if(Trigger.isbefore){
        	accId.add(acc.Id);
            System.debug('value of accId '+acc.Id);
        }
    }
    //Quering all the cases under these Accounts and adding them to a list
    //1.making all cases under this account as spam
    //2.adding the case numbers to the contact as a new contact
    List<Case> caseList = new List<Case>();
    List<Contact> contList = new List <Contact>();
    for(Case cs :[SELECT Id, CaseNumber, AccountId, Spam__c FROM Case where AccountId IN :accId]){
    //iterating thru the list cs and add to the contact
        Case cs1 = new Case();
        cs1.Spam__c = True;
        cs1.Id = cs.Id;
        System.debug('Cases added :'+cs1.CaseNumber);
        caseList.add(cs1);
        
        //creating a new contact with accountId
        Contact cont = new Contact();
        //cont.LastName = cs.CaseNumber;
        //cont.AccountId = cs.AccountId;
        contList.add(cont);
    }
    upsert caseList;
}