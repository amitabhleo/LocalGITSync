public class HelloUpdateAccount {
    //SOQL query a  specific account and updating
    
       
    public static void updateAcct(Account[] acc){
       
        for(Account a: acc){
                if(a.hello__c <> 'World!'){
                a.hello__c = 'Wonderful World!';
                       
            //Working on Trigger context did not work on before insert inside the if
            if(Trigger.isinsert){
                a.hello__c = 'World!';
            //inserting a new contact on new account
                Contact cont = new Contact();
                cont.LastName = 'AutoContact insert';
                cont.AccountId = a.Id;
                upsert cont;
            }
            if(Trigger.isUpdate){
                //a.hello__c = 'updated World!';
                //inserting a new contact on new account
                Contact cont = new Contact();
                cont.LastName = 'AutoContact update';
                cont.AccountId = a.Id;
                upsert cont;
            }
           }else{
               a.hello__c = 'not ABC Corpn';
           }
       }
        //Update the user Company from here should have been done in another class
        for(Account a :acc){
            List<Contact> cont = [SELECT lastName, Id, accountId FROM Contact WHERE account.Id =: a.Id ];
            
            if(cont.size()>0 ){
                //not bulkified dont this this is required
                //a.addError('This Account has Contacts');  
                for(Contact c:cont){
                c.title = 'from Account';
                    upsert c;
                }
            }
            
         }
    } 
}