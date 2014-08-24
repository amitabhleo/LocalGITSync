trigger HelloWorld on Account (before update) {
    
    

	Account[] accs = Trigger.new;
    //calling method 1 from one class
	HelloWorld.updateHello(accs);
    
    //calling another method from second class
    AccountContactFromOpp.accountContactFrmOpp(accs);
}