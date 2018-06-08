/*
The author and the date of edit needs to be added here.
These changes are in the Master branch
*/

public class MyController {
    public final Account account{get;set;}
    public MyController() {
        account = [SELECT Id, Name,Site FROM Account
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
    }
    //public Account getAccount() {
       // return account;
    //}
    public void save(){//PageReference save() {
        update account;
      // return null;
    }
}
