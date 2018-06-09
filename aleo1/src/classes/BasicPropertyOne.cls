//Testing by creating an apex property of account by getting and setting.
public class BasicPropertyOne {
    public List<Account> a {get;set;}
    public Integer i {get;set;}
    
    //constructor
    public BasicPropertyOne(){
        //Setting the value of the property we can also fetch the id 
        //of the apex page and then compute the 
        a = [Select Id, Name from Account limit 10];
        i = 10;
        //getting the value of return
        
    }
    
    
}