trigger LeadConvert on Lead (after update) {
 
  // no bulk processing; will only run from the UI
  if (Trigger.new.size() == 1) {
 
    if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) {
 
      // if a new account was created
      if (Trigger.new[0].ConvertedAccountId != null) {
 
        // update the converted account with some text from the lead
        Account a = [Select a.Id, a.Description From Account a Where a.Id = :Trigger.new[0].ConvertedAccountId];
        a.Description = Trigger.new[0].Name;
        update a;
       }          
 
      // if a new contact was created
      if (Trigger.new[0].ConvertedContactId != null) {
 
        // update the converted contact with some text from the lead
        Contact c = [Select c.Id, c.Description, c.Name From Contact c Where c.Id = :Trigger.new[0].ConvertedContactId];
        c.Description = Trigger.new[0].Name;
        update c;
 
        // insert a custom object associated with the contact
        MyObject__c obj = new MyObject__c();
        obj.Name = c.Name;
        obj.contact__c = Trigger.new[0].ConvertedContactId;
        insert obj;
 
      }
 
      // if a new opportunity was created
      if (Trigger.new[0].ConvertedOpportunityId != null) {
 
        // update the converted opportunity with some text from the lead
        Opportunity opp = [Select o.Id, o.Description from Opportunity o Where o.Id = :Trigger.new[0].ConvertedOpportunityId];
        opp.Description = Trigger.new[0].Name;
        update opp;
 
        // add an opportunity line item
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 100.00;
        oli.PricebookEntryId = [Select p.Id From PricebookEntry p Where ProductCode = 'GC1060' And IsActive = true limit 1].Id;
        insert oli;
 
      }         
 
    }
 
  }     
 
}