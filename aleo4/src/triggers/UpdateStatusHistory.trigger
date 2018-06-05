trigger UpdateStatusHistory on Case (after insert, after update) {
	// repurposed from CalculateBusinessHoursAges.trigger
	
	DateTime currTime = System.now();
    if (Trigger.isInsert) {
    	// insert new Status History record
    	List<Status_History__c> updateStatusHist = new List<Status_History__c>();
        for (Case c:System.Trigger.new) {
            updateStatusHist.add(new Status_History__c(Case__c=c.Id, Name=c.Status, StartDate__c=currTime));
        }
        if (updateStatusHist!=null)
        	insert updateStatusHist;
    }
    else {
		Status_History__c oSH = new Status_History__c();
    	List<Status_History__c> updateStatusHist = new List<Status_History__c>();
        for (Case c:System.Trigger.new) {
            Case oldCase = System.Trigger.oldMap.get(c.Id);
            if (oldCase.Status!=c.Status) {
				// The status has changed
		        // need to update the old status record with an end date and an elapsed time
		        // also need to create a new record for the new status
		        oSH = [Select Id, StartDate__c, Name, EndDate__c, Elapsed_Time__c, Case__c
									  From Status_History__c
									  Where Case__c = :c.Id and Name = :oldCase.Status and EndDate__c = null limit 1];
				if (oSH!=null){
					// the diff method comes back in milliseconds, so we divide by 60,000 to get minutes.
					if (c.BusinessHoursId != null)
						oSH.Elapsed_Time__c = BusinessHours.diff(c.BusinessHoursId, oSH.StartDate__c, currTime)/60000.0;
					else
						oSH.Elapsed_Time__c = (currTime.getTime() - oSH.StartDate__c.getTime())/60000.0;
					
					oSH.EndDate__c = currTime;
					updateStatusHist.add(oSH);
					updateStatusHist.add(new Status_History__c(Case__c=c.Id, Name=c.Status, StartDate__c=currTime));
				}
			} // end if
		} // end for
		if (updateStatusHist!=null)
			upsert updateStatusHist;
	} // end else
}