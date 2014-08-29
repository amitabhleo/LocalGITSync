//calling the  Estimate to mins class to convert Week,Days and min to min.

//trigger UpdateEstimateinMins on Task (after insert) {
    
      trigger UpdateEstimateinMins on Task (before insert,before update) {
    Task[] tsk = Trigger.new;
    //passing the task list to the method convertEstimate      
    EstimateToMins.convertEstimate(tsk);
}