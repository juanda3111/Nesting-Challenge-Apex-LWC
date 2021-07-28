import { LightningElement, wire } from 'lwc';
//import toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import object and fields
import WIDGET_OBJECT from "@salesforce/schema/Widget__c";
import NAME_FIELD from "@salesforce/schema/Widget__c.Name";
import VALUE_FIELD from "@salesforce/schema/Widget__c.valueNestedText__c";
import CHECKBOX_FIELD from "@salesforce/schema/Widget__c.isProperlyNested__c";
import { getFieldValue } from 'lightning/uiRecordApi';
//import profile
import Id from '@salesforce/user/Id';
import getUserInfo from '@salesforce/apex/UserDetails.getUserInfo';

export default class NestingChallenge extends LightningElement {
 

    objectApiName = WIDGET_OBJECT;
    fields = [NAME_FIELD, VALUE_FIELD, CHECKBOX_FIELD];
    
    @wire(getUserInfo, { userId: Id }) 
    userData;

    handleValidations(event){
      
      console.log('texto de salida handleValidations');
    
      //receive the information written by the user
      const typedInfo = JSON.parse(JSON.stringify(event.detail));
      

      if(typedInfo.fields.isProperlyNested__c  == false){
        
        //use the data collected in Apex (userData) and bring the name of the profile of the current user if is not an allowed user then blocks the save option.
          if(String(this.userData.data.Profile.Name) != 'System Administrator' && String(this.userData.data.Profile.Name) != 'Widget Masters'){
            event.preventDefault();
            console.log('no deja guardar nada');
          }
        console.log('deja guardar la info');
        console.log(this.userData);
        console.log(this.userData.data.LastName);     
        console.log(this.userData.data.Profile.Name);           
      
      }
          

    }

  handleSuccess(event) {
   const toastEvent = new ShowToastEvent({
      title: "Widget created",
      message: "Record ID for the Widget: " + event.detail.id,
      variant: "success"
    });
    this.dispatchEvent(toastEvent);
    console.log('texto de salida 3');
  }
}