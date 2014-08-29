public Class Utility
{
    private void Test() 
    {
    }
    public static testMethod void tstUtility()
    {
        Utility test = new Utility();
        test.Test();
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name='Test';
        opp.CloseDate = System.today();
        opp.StageName='Prospecting';
        opp.Channel_Account__c = acc.Id;
        insert opp;     
    }
}