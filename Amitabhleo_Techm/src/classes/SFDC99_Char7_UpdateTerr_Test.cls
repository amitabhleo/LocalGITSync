@isTest
public class SFDC99_Char7_UpdateTerr_Test{
    
    static testMethod void testShareTerritories(){
     	//user 20 records created
		List<User> usrList = new List<User>();
        	for(Integer i = 0;i<=20;i++){
           User usr = new User(); 
           	usr.FirstName 	= 'amitabh';
            usr.LastName 	= 'leo'+i;
            usr.Alias 		= 'aleo'+i;
           	usr.Email 		= 'amitableo'+i+'@gmail.com';
            usr.Username	= 'amitableo'+i+'@gmail.com';
            usr.LocaleSidKey= 'en_US';
            usr.TimeZoneSidKey='GMT';
            usr.ProfileId	= '00e90000001M6Vh';
            usr.EmailEncodingKey ='UTF-8';
            usr.LanguageLocaleKey ='en_US';
            usrList.add(usr);
                }
        		insert usrList;
                //User debug tested creation
                for(User usr:usrList){
                   System.debug('User no. :'+usr.Email); 
                }
      
        //Territories 200 records
        List <Territory__c> terrList = new List<Territory__c>();
        	for(Integer i=0;i<=200;i++){
            Territory__c terr = new Territory__c();
            //terr.Name = 'Territory'+i;
            terr.ZIP_Code__c = String.valueOf(1000 + i);
            terrList.add(terr);
        }
        	insert terrList;
        	//Terrtory debug test
        for(Territory__c terr: terrList){
            //System.debug('value of Territory zip :'+terr.Name+' '+terr.ZIP_Code__c);
        }
        //Territory Members 2000 records (approx 10 per territory)
     
        List<Territory_Member__c> terrMemberList = new List<Territory_Member__c>();
        	for(Integer i=0;i<=200;i++){
            //passing the random number to the Territory member
           Integer count = Integer.valueOf(Math.random()*20);
                for(Integer j=0;j<count;j++){
                    //System.debug('value of i and j: '+i+'--'+j);
                    Territory_Member__c tm = new Territory_Member__c();
            		tm.Territory__c 	= terrList[i].Id;
                    tm.User__c			= usrList[j].Id;
                    terrMemberList.add(tm);
                }                
        }
        insert terrMemberList;
        for(Territory_Member__c tm :terrMemberList){
            System.debug('Terriroty Member list'+tm.Territory__c+' '+tm.User__c);
        }
        //Accounts 200 records
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<=20;i++){
            Account acc 	= new Account();
            acc.Name 		= 'SFDC99_' + String.valueOf(i) ;
            acc.BillingPostalCode = String.valueOf(1000 + i);
            accList.add(acc);
        }
        insert accList;
        System.debug('accList size :'+accList.size());
        //Setup data has been entered
        //begin testing
        Test.startTest();
        
        for(Account acc:accList){
            System.debug('accList :'+ acc.Name+acc.BillingPostalCode);
        }
        //Principle #2 Assert your result
        //Get all accounts and their accounts
        accList = [SELECT Id,Name,BillingPostalcode, (SELECT Id,AccountAccessLevel, 
                                                   UserOrGroupId, RowCause 
                                                   FROM Shares where RowCause = 'Manual') 
                from Account];
        //Create a map of all territories and their members
        Map<String,Territory__c> terrMap = new Map<String,Territory__c>();
        terrList = [SELECT Id,Name,Zip_Code__c,
                                    (SELECT Id, Name, User__c, Territory__c FROM 
                                     Territory_Members__r) FROM Territory__c];
        for(Territory__c ter1 : terrList){
            terrMap.put(ter1.ZIP_Code__c,ter1); 
        }
        //Assert each account has the righ no of memebers
        //Test Scenario #1 insert 200 accounts with zipcode
        for(Account a : accList){
           Territory__c t = terrMap.get(a.BillingPostalCode); 
           Integer shareCount 	= a.Shares.size();
           Integer memberCount 	= t.Territory_Members__r.size();
           System.assertEquals(shareCount, memberCount);
        }
    
        //Test Scenario #2 insert 200 accounts without zipcode
        List<Account> ac2 = new List<Account>();
        for (Account a:accList){
            
            a.BillingPostalCode = null;
            ac2.add(a);
        }
        update ac2;
        accList = [SELECT Id,Name,BillingPostalcode, (SELECT Id,AccountAccessLevel, 
                                                   UserOrGroupId, RowCause 
                                                   FROM Shares where RowCause = 'Manual') 
                from Account];
        for(Account a:accList){
            Integer shareCount = a.Shares.size();
            System.assertEquals(0, shareCount);
        }
        //Test Scenario #3 update 200 accounts with Zipcode   
        
    }
 }