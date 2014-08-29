trigger channel_manager_opp_share on Opportunity(After Insert)
{
       if(trigger.isInsert)
        {
            if(trigger.isAfter)
            {
                List<OpportunityShare> jobShares = new List<OpportunityShare>();
                List<Id> lstIds = new List<Id>();
                for(Opportunity opp : trigger.new)
                    {
                        if(opp.Channel_Account__c != null)
                            lstIds.add(opp.Channel_Account__c);
                    }
                Account acc;
                User u;
                if(!lstIds.isEmpty())
                    {
                        acc = [SELECT Id,Name,OwnerId FROM Account WHERE Id IN : lstIds];
                        System.debug('***Account Details***'+acc);
                        u = [SELECT Id FROM User WHERE Id=:acc.OwnerId];
                        System.debug('****User Details****'+u);
                    }
                for(Opportunity opp : trigger.new)
                    {
                        if(opp.Channel_Account__c != null)
                        {
                            OpportunityShare channelManagerShare = new OpportunityShare();
                            channelManagerShare.OpportunityId = opp.Id;
                            channelManagerShare.UserOrGroupId = u.Id;
                            channelManagerShare.OpportunityAccessLevel = 'edit';
                            jobShares.add(channelManagerShare);
                        }
                    }
                Database.SaveResult[] jobShareInsertResult = Database.insert(jobShares,false);
                System.debug('***jobShareInsertResult***'+jobShareInsertResult);
            }
        }
}