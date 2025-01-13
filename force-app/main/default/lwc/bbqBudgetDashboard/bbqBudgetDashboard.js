import { LightningElement } from 'lwc';
import BBQ_Logo from '@salesforce/resourceUrl/BBQ_Logo';


export default class BbqBudgetDashboard extends LightningElement {
    // Maneja el evento para crear un nuevo presupuesto
    handleCreateBudget() {
        window.open('/lightning/o/BBQ_Budget__c/new', '_self');
    }

    // Maneja el evento para agregar un nuevo producto
    handleNewProduct() {
        window.open('/lightning/o/Product2/new', '_self');
    }

    // Maneja el evento para registrar un nuevo cliente
    handleNewCustomer() {
        window.open('/lightning/o/Contact/new', '_self');
    }
}