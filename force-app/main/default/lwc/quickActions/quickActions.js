import { LightningElement } from 'lwc';

export default class QuickActions extends LightningElement {
    handleAction1() {
        window.open('/lightning/o/BBQ_Budget__c/new', '_self');
    }
    handleAction2() {
        window.open('/lightning/o/Product2/new', '_self');
    }
    handleAction3() {
        window.open('/lightning/o/Contact/new', '_self');
    }
}