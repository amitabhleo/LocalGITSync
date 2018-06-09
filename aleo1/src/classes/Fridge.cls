public class Fridge implements KitchenUtility {
    
    private String modelNumber;
    private Integer numberInStock;
    //defining an a static variable which is not an instance variable 
    public Static Integer stockThreshold = 5;
    //now defining  constructors it will have the name of the class and no return type.
    //let us start with a blank constructor
    public Fridge(){
        this.modelNumber = 'XX-XX';
        this.numberInStock = 0;
    }
    //Overloading a constructor
    public Fridge(String theModelNumber, Integer theNumberInStock){
        this.modelNumber = theModelNumber;
        this.numberInStock = theNumberInStock;
    }
    //defining Salesforce.com properties of getters and setters
    public Integer ecoRating{
        get{return ecoRating;}
        set{ecoRating = value; 
            if (ecoRating <0){
                ecoRating = 0;}    
           }
    }
    //defining a static method using the Constructor
    public static void toDebug(Fridge aFridge){
        
        System.debug('ModelNumber'+aFridge.ModelNumber);	
        System.debug('ModelNumberMethod'+aFridge.getModelNumber());
    }
    //defining the methods
    public void  setModelNumber(String theModelNumber){
        
        this.modelNumber = theModelNumber;
    }
  	
    public String getModelNumber(){
        
        return 'T'+ this.modelNumber;
    }

    public void updateStock(Integer justSold){
        
        numberInStock = numberInStock - justSold;
    }
}