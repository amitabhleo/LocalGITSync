//I want to run this only once so I am using a static variable in a 
//SingleRun class so that the code does not go into recursion
public class PrintAccountList{
	//method call here the values will come from the trigger
	//we can also make this method static if we do not want to instantiate it
    public void printAccounts(List<Account> acc){
        
        for(Account a : acc){
            //calling the static variable to run this only once
            if(SingleRun.firstRun){
              System.debug('account Name from PrintAccounts : '+ a.Name);  
              SingleRun.firstRun = False;  
            }
        	
        }
        //another class sfdc property being called for testing
        sfdc_property proptest = new sfdc_property();
        	proptest.prop =5; //calls the set accessor
        System.assertEquals(proptest.prop, 5); //calls the get accessor
        System.debug('propTest should be 5 :' +proptest.prop);
        proptest.writeOnlyProp = 'write only';
        System.debug('readOnly'+propTest.readOnlyProp );
        proptest.acct = acc;
        //System.debug('from sfdc property'+proptest.acct);
        //List<Account> fromPropTest = new List<Account>();
        //fromPropTest = propTest.acct;
        System.debug('new Account object length: '+PropTest.acct.size());
        for(Account accObj :  proptest.acct ){
            System.debug('account Name'+ accObj.name);
        }
    }
    
}