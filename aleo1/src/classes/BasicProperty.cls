/*
* Apex property is like a variable 
Property definitions include one or two code blocks, representing a get accessor and a set accessor:
The code in a get accessor executes when the property is read.
The code in a set accessor executes when the property is assigned a new value.
*
*/
public class BasicProperty {
//defining the first property which will retun an Integer
    public Integer readOnlyProp {get;}
    public Double myReadWriteProp {get;set;}
    public String myWriteOnlyProp {set;}
        
    
}