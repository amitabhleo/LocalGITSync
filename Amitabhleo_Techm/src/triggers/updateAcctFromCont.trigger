/**
	@author Amitabh
	Date Feb 22, 2012
	Objective is to update the correspondig parent Account from a contact.
	althought this can be done from a workflow but sometimes this works for a trigger
**/
trigger updateAcctFromCont on Contact (before delete) {
 
    Contact[] cont = Trigger.new;
    UpdateAccountFromContact.updateAcct(cont);
    
}