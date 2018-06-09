/*
Description: Mobile Registration - Create CRM Id
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          16-June-2017                    Amitabh Sharma              Initial Version
--------------------------------------------------------------------------------------
*/

@RestResource(urlMapping='/mobileregistration')
global with sharing class MobileRegistrationWebService 
{
    @HttpPost
    global static CreateCRMIdWrapper DoPost(string mobile_number, string device_id, string mpin)
    {
        try
        {
            if(string.isNotBlank(mobile_number)) 
            {
                Lead objlead = new Lead();
                objlead.MobilePhone = mobile_number;
                objlead.LastName = mobile_number;
               // objlead.IVL_Device_Id__c = device_id;
                //objlead.IVL_MPIN__c = mpin;
                objlead.Company = 'Hyatt UPDATED';
                objlead.Status = 'Contacted';
                insert objlead;
                
                list<Lead> lstLead = [select id,Lead_Id__c from Lead where id =: objlead.id];

                CreateCRMIdWrapper objResponse = new CreateCRMIdWrapper();
                objResponse.success = True;
                objResponse.lead_id = lstLead[0].Lead_Id__c;
                
                return objResponse;
             
            }
            else
            {
                CreateCRMIdWrapper objResponse = new CreateCRMIdWrapper();
                objResponse.success = False;           
                objResponse.error_message = 'please provide mobile number!';
                
                return objResponse;
            }
        }
        Catch(exception ex)
        {
            CreateCRMIdWrapper objResponse = new CreateCRMIdWrapper();
            objResponse.success = False;           
            objResponse.error_message = ex.getMessage();

            return objResponse;
            
        }
    }
    global class CreateCRMIdWrapper
    {
        public boolean success;
        public string error_message;
        public string lead_id;
        
        global CreateCRMIdWrapper() {
            success = false;
        }
        
    }
}