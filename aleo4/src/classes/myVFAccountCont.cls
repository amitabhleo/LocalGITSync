public with sharing class myVFAccountCont {
//setting the apex properties
	
    public Account myAcct{
        get{ return  myAcct;     
           // return myAcct = [SELECT Id, Name,Site FROM Account
            //WHERE Id = :ApexPages.currentPage().getParameters().get('id')];	
        	
        }
        set{
            myAcct = [SELECT Id, Name,Site FROM Account
            WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        	
        }
    }
}