public class UpdateAccountFromContact{

    public static void updateAcct(Contact[]cont ){   
        for(Contact c:cont){
    	//now i have to go the corresponding Account
        List<Account> acc =[SELECT Id,Name from Account WHERE Id = : c.accountId];
            for(Account acc1: acc){
                acc1.Industry = 'Agriculture';
                update acc1;
            }
        }      	
	}
}