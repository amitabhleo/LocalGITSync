/*
	@amitabh Nov 19, 2014, we will be using only one triggerfor account
	this is a best practice also promoted by salesforce.com
*/
trigger AccountTrigger on Account (before update) {
	
		List<Account> acc = Trigger.new;
    //now let us call an apex class and pass the list in it
        PrintAccountList pal = new PrintAccountList();
        pal.printAccounts(acc);
        //Can be used we make the method in the class as static to directly access it
        //PrintAccountList.printAccounts(acc);
 //running another class
 		sfdc_iterable sfItr = new sfdc_iterable();
    	sfItr.customIterable(acc);
}