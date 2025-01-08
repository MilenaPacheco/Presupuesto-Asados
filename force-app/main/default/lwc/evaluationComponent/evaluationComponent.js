import { LightningElement, api, track } from 'lwc';
import saveEvaluation from '@salesforce/apex/EvaluationController.saveEvaluation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBBQStatus from '@salesforce/apex/EvaluationController.getBBQStatus';

export default class EvaluationComponent extends LightningElement {
    @api recordId;
    @track score = "";
    @track observations = "";
    @track showComponent = false;

    connectedCallback(){
        //this.showComponent = true;
        getBBQStatus({recordId: this.recordId})
            .then(status => {
                if (status === 'Completed'){
                    this.showComponent = true;
                } else {
                    this.showComponent = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'The BBQ must be completed before scoring.',
                            variant: 'error'
                        })
                    );
                }
            })
            .catch(error => {
                console.error('Error fetching status:', error);
            })
    }

    handleScoreChange(event) {
        this.score = event.target.value;
    }

    handleObservationsChange(event) {
        this.observations = event.target.value;
    }

    handleSave() {
        if(!this.score || !this.observations){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'All fields are required.',
                    variant: 'error'
                })
            );
            return;
        }
        saveEvaluation({
            recordId: this.recordId,
            score: this.score,
            observations: this.observations
        })
        .then(() => {
            //Mostrar mensaje de resultado favorable
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Assessmente saved successfully!',
                    variant: 'success',
                })
            );
            //borrar el contenido ingresado
            this.score = '';
            this.observations = '';
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'There was a problem saving the review.',
                    varriant: 'error'
                })
            );
            console.error(error);
        })
        console.log('Score:', this.score);
        console.log('Oservations:', this.observations);
    }
}