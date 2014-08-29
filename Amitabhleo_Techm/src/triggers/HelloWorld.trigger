/**		@author Amitabh Sharma
		updating Hello custom field without calling another class
**/
//had to change this to before delete for the contact trigger to work
trigger HelloWorld on Account (before insert, before update) {
    
//will change the different fields on insert and update 
    Account[] acc1 = Trigger.new;
    
    //Method 1 called from HelloUpdateAccount Class
    HelloUpdateAccount.updateAcct(acc1);
    
    //Method 2 Called from Another Account ContactFrom Oppp Class
    AccountContactFromOpp.createContactFromOpp(acc1);
     
}