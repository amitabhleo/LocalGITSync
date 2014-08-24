public with sharing class HelloWorld {
	
		public static void updateHello(Account[] acct){
		
			for(Account a:acct){
			
				if (a.Hello__c != 'World'){
					a.Hello__c ='World, here i come!!';
					
				}
			}
		}
}