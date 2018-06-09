public class AccountRootClass {
    //will be called from the AccountRoot trigger
    //not calling any constructor from here
    public void getchild(List<Account> accts){
        //passing the value of the parent account to check the child
        List <account> acctsUpdate = new List<account>();
        ID rootActId;
        for (Account a:accts){
            if (a.parentId == null){
                rootActId = a.Id;
                //pass this id to the getAcctswithParent method
                //List<Account> accts2 = getAcctswithParent(a.Id);
            //passing all the accounts in this list to the accout update
            for (Account a2 : getAcctswithParent(a.Id)){
                a2.Root_Account__c = rootActId ;
                acctsUpdate.add(a2);
            }
            
            //pass the values in a list as there can be multiple account with that parent
            //List<Account> acctsWithParent = [Select Id,name,parentId from Account where parentId =: a.ParentId];
            //a.root_account__c = a.ParentId; 
        }  
            else{
                for (Account a3 : getAcctswithParent(a.Id)){
                    a3.Root_Account__c = '0017000000Leor6' ;
                acctsUpdate.add(a3);
                }
            }
        }
        upsert acctsUpdate;
        System.debug('value of acctsUpdate'+ acctsUpdate); 
        
    }
    //creating a new method which on receiving an account will return
    //the list of all accounts which have that account as parent
    public List<Account> getAcctswithParent(Id parentAcctId){
        List<Account> acctswithParent = [Select Id, Name, ParentId from Account where parentId =: parentAcctId];
        Return acctswithParent;
    }
}