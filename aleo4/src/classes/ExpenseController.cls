public class ExpenseController {
    @AuraEnabled
    public static List<Expense__c> getExpenses() {
        return [SELECT id, name, amount__c, client__c, date__c,
                   reimbursed__c, createdDate FROM Expense__c];
    }
}