global class ScheduleJobWidgetsNesting implements Schedulable  {
    global void execute(SchedulableContext ctx){
        list<Widget__c> widgetsToModify = [select Id,Name,valueNestedText__c, isProperlyNested__c from Widget__c];

        for (Widget__c wid : widgetsToModify){
            if(wid.isProperlyNested__c ==  true){
                wid.valueNestedText__c = ''; // logica ficti 
            } else {
                //send an email to the widget owner
                sendMail();
            }
        }
    }

    public void sendMail(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {'judarogu1@hotmail.com'}; 
        //String[] ccAddresses = new String[] {'smith@gmail.com'};  

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);

        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('support@acme.com');

        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Support');

        // Specify the subject line for your email address.
        mail.setSubject('Your Widget needs to be properly saved');

        // Specify the text content of the email.
        mail.setPlainTextBody('Your Widget:  does not have the "is properly nested" field checked.');

        mail.setHtmlBody('Your Widget:<b> </b>has been created.<p>'+
            'To view your case <a href=https://wise-raccoon-vdxmcw-dev-ed.my.salesforce.com/> click here.</a>');

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}
