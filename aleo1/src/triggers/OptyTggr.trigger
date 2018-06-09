//Will be creating an Asset from a closed won opportunity with the values of the Oppty line items.
    //Will be using the trigger to pass the values of the Opportunity then the rest of the functionality will be done in the respective Class
    //THERE SHOULD BE ONLY ONE TRIGGER PER OBJECT
    
trigger OptyTggr on Opportunity (after insert,after update) {
    //I should have used an Array / list to populate the value of trigger.new
    //earlier i used an opportunity only
    List <Opportunity> o = Trigger.New;
    //Calling the Class Asset from Oppty and passing the trigger.new 
    AssetFromOppty asstOpty = new AssetFromOppty();
    asstOpty.getOppty(o);
}