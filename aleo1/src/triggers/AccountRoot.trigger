/*
* 	@author amitabh date 25/5/2017
*	The objective is to mimimc the functionality of Asset hierarchy created by salesforce on Accounts
*	all accounts with blank parent will have root Account as the same value
*	else the root Account will be the parent account / or the grand parent account if exists.
* 	Salesforce in Asset mantains up to 15 levels let us see how much we can achieve
*/
trigger AccountRoot on Account (before insert,before update,after update) {
//calling a class to update the root account
	List<Account> accs =Trigger.new;
    system.debug('accs' + accs);
    AccountRootClass arc = new AccountRootClass();
    arc.getChild(accs);
    
}