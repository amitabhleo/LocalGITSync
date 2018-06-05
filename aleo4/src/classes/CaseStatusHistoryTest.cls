public class CaseStatusHistoryTest {
    public static testMethod void testCaseStatusHistory() {

        Case c = new Case();
        c.Status = 'New';
        insert c;

        c.Status = 'Closed';
        update c;

        c.Status = 'New';
        update c;

        c.Status = 'Closed';
        update c;
        
        List<Status_History__c> oSH = [Select Name, StartDate__c, EndDate__c, Elapsed_Time__c From Status_History__c where Case__c=:c.Id];
        for (Status_History__c sh:oSH){
	        System.assert(sh.Name!=null);
	        System.assert(sh.StartDate__c!=null);
	        if (sh.EndDate__c!=null)
	        	System.assert(sh.Elapsed_Time__c!=null);
        }

    }
}