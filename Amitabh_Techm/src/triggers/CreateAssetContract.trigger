trigger CreateAssetContract on Opportunity (before insert, before update) {
	/*
		The objective of this trigger is to create a new Contract whan an Opportunity is closed won
		and also create Assets for all the Product Line items in a closed won Opportunity
	*/
	//Firtly I will attempt to create a trigger.new and create a new Contract later
	//I will try with creating the Assets
	//List <Opportunity> Opp = Trigger.new;
	
	//iterating thru this trigger.new to get all Opp with status closedwon.
	Set <ID> OppId = new Set<ID>();
	for(Opportunity opp1:Trigger.new){
	
		if (Opp1.StageName =='Closed Won'){
			//pasing the value in the Set
			OppId.add(opp1.Id);
			//Also Creating a new Contract
		Contract contra = new Contract(name=opp1.Name);
		contra.AccountId = opp1.AccountId;
		insert contra;
		}
		//Creating a Map of ID and Oppline item for all ID which we passed in the Set
		Map<ID,OpportunityLineItem> myOliMap = new Map <ID,OpportunityLineItem>();
		//Creatinga collection for Asset which can be upserted in one go
		List <Asset> asst_list = new List <Asset>();
		//Passing the values in the Map
		for(OpportunityLineItem oli :[Select Quantity,Description,PricebookEntryId, PricebookEntry.Name, 
                                                        PricebookEntry.Product2Id,PricebookEntry.ProductCode,OpportunityId,
                                                           PricebookEntry.product2.Family, Id 
                                                        From OpportunityLineItem Where OpportunityId IN : OppId]){
		//[Select Quantity, PricebookEntryId, OpportunityId, Id, Description From OpportunityLineItem  where OpportunityId IN : OppId]){
				myOliMap.put(oli.OpportunityId,oli);
											}
		//Passing thru the trigger again
		for(Opportunity opp : Trigger.new){
			if (Opp1.StageName =='Closed Won'){
			Asset asset1 = new Asset();
			asset1.Name = myOliMap.get(opp.Id).PricebookEntry.Name;
			asset1.AccountId = opp.AccountId;
			asset1.Product2Id = myOliMap.get(opp.Id).PricebookEntry.Product2Id;
			asst_list.add(asset1);
			}
		}
		upsert asst_list;									
	}
	
}