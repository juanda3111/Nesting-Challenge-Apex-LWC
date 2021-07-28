global class ScheduleJobWidgetsNesting implements Schedulable  {
    global void execute(SchedulableContext ctx){
        list<Widget__c> widgetsToModify = [select Id,Name,valueNestedText__c, isProperlyNested__c, Owner.Email from Widget__c];
        String email ='';
        //array that stores the nested values
        String [] stack = new List<String>();
        String check = '';
        for (Widget__c wid : widgetsToModify){
            integer x = 0;

            if(wid.isProperlyNested__c ==  true){
                //wid.valueNestedText__c = '';
                if(wid.valueNestedText__c.contains('(') ){
                    //push elements into the stack
                    stack.add('(');
                    }
                if(wid.valueNestedText__c.contains('[') ){
                    stack.add('[');
                    }
                if(wid.valueNestedText__c.contains('{')){
                    stack.add('{');
                    }
                if(stack.size() != 0){
                    
                        if(stack.get(stack.size() - 1) == ')') {
                           check = stack.get(stack.size() - 1);
                           if (check == '{' || check == '[')
                           {break;}
                        }
                        if (stack.get(stack.size() - 1) == '}') {
                            check = stack.get(stack.size() - 1);
                            if (check == '(' || check == '[')
                            {break; }
                         }    
                        if (stack.get(stack.size() - 1) == ']') {
                            check = stack.get(stack.size() - 1);
                            if (check == '(' || check == '{')
                            {break;}
                        } 
                    }

                } 
            else {
                //send an email to the widget owner
                email = wid.owner.Email;
                sendMail(email);
            }
        }
    }


    public void sendMail(String email){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Strings to hold the email addresses to which you are sending the email.
        //String[] toAddresses = new String[] {'judarogu1@hotmail.com'}; 
        String[] toAddresses = new String[] {email}; 
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

        mail.setHtmlBody('Your Widget:<b> </b>was created but does not have the "is properly nested" field checked.<p>'+
            'To view your Widget <a href=https://wise-raccoon-vdxmcw-dev-ed.my.salesforce.com/> click here.</a>');

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}
