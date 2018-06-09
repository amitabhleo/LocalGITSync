public class LeadCtr {
@AuraEnabled
    public static void saveLead(Lead objLead){
        insert objLead;
    }
}