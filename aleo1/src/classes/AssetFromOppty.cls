//This class is used to populate new assets from an opportunity
//The real challange is to populate the assets as the line items in an opportunity
public class AssetFromOppty {
    //the Oppty list of the Oppty should come to this method
    Set<Id> opId = new Set<ID>();
    public void getOppty (List <Opportunity> oppty){
        for(Opportunity op1:oppty){
            
            if (op1.IsClosed == True){
                //AssetFromOppty astOpty = new AssetFromOppty();
                opId.add(op1.Id);
                System.debug('value of oppty'+op1.Name);  
            }
        }
        //Iterating thru the Set to get the Opportunity Names first
        
        List <Asset> ast = new List<Asset>();
        For(OpportunityLineItem oli :  [SELECT Id, OpportunityId, Product2Id,Opportunity.accountid,product2.name, 
                                        Name, Quantity,OpportunityLineItem.ListPrice, TotalPrice FROM OpportunityLineItem 
                                        where OpportunityId IN: opId]){
                                            //Creating a new Asset and then passing it in a list and the Update all in one
                                            
                                            Asset a = new Asset();
                                            a.Name = 'Asset' + '::'+oli.product2.name;
                                            a.AccountId = oli.Opportunity.accountid;
                                            a.Product2Id = oli.Product2Id;                        
                                            a.Quantity = oli.Quantity;
                                            a.Price = oli.ListPrice; 
                                            a.PurchaseDate = System.today();
                                            
                                            ast.add(a);
                                        }
        //testing the Try catch block
        Try{
            upsert ast;   
        }
        Catch(Exception e){
            
            System.debug('Exception'+e.getMessage());
        }
    }
}