//public class ConvertToMins{
//@author Amitabh 21/9/2012
//This class will have a method which will convert
//a text field 3d or 6h or 20 mins to mins
//also tying to work back while creating a total project in days, weeks and 
//Needs to handle if a field is left blank then null pointer exception should not show.
public class ConvertToMin {
    //Converts days, hours and mins to minutes and Minutes to days and Weeks
    
    Integer WEEK = 2400;
    Integer DAY = 480;
    Integer HOUR = 60;
    public Integer ConvertToMins(String str){
        //handling null
        if(str != Null && str != ''){
                    Integer len = str.length();
                    String strExtract = str.substring(0,len-1);
                    Integer intVal = Integer.valueof(strExtract);
                    Integer returnVal;
                    if(str.endswith('d') ){
                       
                       returnVal = intVal *480;
                        
                    }else
                     if (str.endswith('h')){
                            returnVal = intVal * 60;
                            
                    }else
                     if (str.endswith('m')){
                            returnVal = intVal;
                             
                    }
                    return returnVal;
         }
         return null;
        
    }//endMethod
    //Convert Min to week, days mins
    //@author amitabh on May 1, 2013
    //This test is updating all Tasks in Mins to week days mins
    public String convertMinToWeek(Integer mins){
        
        if( mins != NULL){
                Integer weeks = mins/WEEK;
                Integer remainderWeek = math.mod(mins,WEEK);
                Integer days = remainderWeek/DAY;
                Integer remainderDay = math.mod(mins,DAY);
                Integer hours = remainderDay/HOUR;
                Integer remainderHour = math.mod(remainderDay,HOUR);
            	//String noOdays;
            
                String noOfDays = String.valueOf(weeks) +'w'+','+String.valueOf(days) +'d'+','+
                                    String.valueOf(hours) +'h'+','+remainderHour+'m';
            	return noOfDays;
    }else
         return'0m';
    }
    public String logMintoHours(Integer min){
    //will be used only in logging time
       if( min <= 480 || min != NULL){
               	if( min < 60){
         		Integer remainderMins = min;
                return String.valueOf(remainderMins)+'m';    
                }else
                {
         	    Integer remainderHour = min/HOUR;
                return String.valueOf(remainderHour)+'h'; 
                    
       			} 
       		}else
           		return '0m';
    	}
}