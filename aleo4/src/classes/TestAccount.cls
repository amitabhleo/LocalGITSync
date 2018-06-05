public with sharing class TestAccount
{

    public void DeleteSelectedcontacts() {
     List<WrapCls> tempwraplist = new List<WrapCls>();
     delcon=new list<contact>();
    For(WrapCls tempvar :Movetoright)
     {
         if (tempvar.Checkedcontact==true)
         {
        
         tempvar.Checkedcontact=false;
         system.debug('ggggggggg'+Movetoright);
         //deleteCheckContact.add(tempvar);
         delcon.add(tempvar.con);
         }
         else
         {
         tempwraplist.add(tempvar);
         }
   
     
     }
       Movetoright= tempwraplist;
       
       delete delcon;
       
   
        
    }


   

  

    

   

  public list<contact> delcon{get;set;} 
public boolean displayPopup {get; set;}
public List<WrapCls > Movetoright {get;set;}
     public String selectedAccoutID{get;set;}
     public Account SelectedAccount {get;set;}
     public List<Contact> SelectedContact {get;set;}
     public List<WrapCls > SelectedCheckContact {get;set;}
     public List<WrapCls > deleteCheckContact {get;set;}
     public boolean showAccountDeatils{get;set;}
     public boolean showNonEditAccountDeatils{get;set;}
      public boolean showblock{get;set;}
      public boolean showButton{get;set;}
      public contact newcontact{get;set;}
       public contact temp{get;set;}
      
      public TestAccount()
        {
            
            showAccountDeatils = false;
            showNonEditAccountDeatils=false;
            showblock=false;
            showButton=false;
            Movetoright =new List<WrapCls>();
        }
    public void closePopup() {
        displayPopup = false;
        system.debug('hh=='+newcontact);
        insert newcontact;
        contact TempCon = [select id,name,email,mobilephone,OwnerId from contact where id =:newcontact.id];
       WrapCls  temp = new WrapCls();
       temp.con = TempCon;
       temp.Checkedcontact = false;
        SelectedCheckContact.add(temp);
        //DoSomeMagic();
        
    }
    
     public void cancelPopup() {
     displayPopup = false;
      
    }


    public void AddnewContact() {
    
        displayPopup = true;
        newcontact  = new contact(accountid=selectedAccoutID);
       /* temp.Firstname=newcontact.Firstname;
        temp.lastname=newcontact.lastname;
        temp.email=newcontact.email;
        temp.MobilePhone=newcontact.MobilePhone;
        temp.accountid=selectedAccoutID;*/
        
    }
      
        /*public Void AddNewContact() {
   // displayPopup =true;
        newcontact= new contact();
        newcontact.Firstname='test';
        newcontact.lastname='test';
        newcontact.email='test@test.com';
        newcontact.MobilePhone='9876543211';
        newcontact.accountid=selectedAccoutID;
        insert newcontact;
        
                             }*/

     
      
    public List<SelectOption> getAccountList() {
   
     List<SelectOption> lso = new List<SelectOption>();
     List<Account> lsa = new List<Account>();
    
     
     lsa = [Select id,Name from Account];
     
     for(Account acc :lsa)
     {
     lso.add(new SelectOption(acc.id,acc.name));
     }
     
     
        return lso;
    }

    
   
    
    public void DoSomeMagic()
    {
        system.debug('$%&^$&!$@&#'+selectedAccoutID);
        //showAccountDeatils =true;
        SelectedAccount=new Account();
        SelectedAccount=[Select id,name, Industry,Type from Account where id=:selectedAccoutID];
        system.debug('tap'+SelectedAccount);
        //SelectedContact =new List<Contact>();
        //SelectedContact =[select id,name,email,mobilephone,ownerid from Contact where Accountid =: selectedAccoutID];
        SelectedCheckContact = new List<WrapCls >();
         Movetoright = new List<WrapCls>();
        list<contact> tempcon= new list<contact>();
        tempcon =[select id,name,email,mobilephone,ownerid from Contact where Accountid =: selectedAccoutID];
        
        For(Contact tempConObj : tempcon)
        {
        
            WrapCls TempWrepInstact = new WrapCls();
            TempWrepInstact.con = tempConObj;
           
               TempWrepInstact.Checkedcontact=false;
   
            SelectedCheckContact.add(TempWrepInstact);
        }
        showNonEditAccountDeatils=true;
        showAccountDeatils=false;
        showblock=true;
    }
    public void EditAccount() {
        showNonEditAccountDeatils=False;
        showAccountDeatils=true;
         showblock=true;
        
       
    }
    
     public Void cancel() {
        showNonEditAccountDeatils=true;
        showAccountDeatils=false;
    }


    public Void SaveAccount() {
    showNonEditAccountDeatils=true;
        showAccountDeatils=false;
        
        update SelectedAccount;
    }
    
    Public class WrapCls {
    
    public Contact con {get;set;}
    public boolean Checkedcontact{get;set;}
    
    
    }
    
    public void MovetoLeft() {
    
    List<WrapCls> tempwraplist = new List<WrapCls>();
    For(WrapCls tempvar :Movetoright)
     {
         if (tempvar.Checkedcontact==true)
         {
        
         tempvar.Checkedcontact=false;
         system.debug('ggggggggg'+Movetoright);
         SelectedCheckContact .add(tempvar);
         }
         else
         {
         tempwraplist.add(tempvar);
         }
   
     
     }
       Movetoright= tempwraplist;
    }

    
    
     public void Movetoright() {
     
     system.debug('aaaaaaaaa'+SelectedCheckContact );
     List<WrapCls> tempwraplist = new List<WrapCls>();
     For(WrapCls tempvar :SelectedCheckContact)
     {
         if (tempvar.Checkedcontact==true)
         {
          tempvar.Checkedcontact=false;
         system.debug('ggggggggg'+Movetoright);
         Movetoright.add(tempvar);
         }
         else
         {
         tempwraplist.add(tempvar);
         }
   
     
     }
      
         SelectedCheckContact =tempwraplist; 
    }

}