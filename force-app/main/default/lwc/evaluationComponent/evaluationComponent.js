import { LightningElement, api, track } from 'lwc';
import saveEvaluation from '@salesforce/apex/EvaluationController.saveEvaluation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBBQStatus from '@salesforce/apex/EvaluationController.getBBQStatus';
import checkIfAssessmentExists from '@salesforce/apex/EvaluationController.checkIfAssessmentExists';

export default class EvaluationComponent extends LightningElement {
    @api recordId;
    @track score = "";
    @track observations = "";
    @track showComponent = false;
    @track assessmentExists = false;

    connectedCallback() {
        //verificar si ya existe una evaluación
        checkIfAssessmentExists({ recordId: this.recordId })
            .then(assessmentExists => {
                this.assessmentExists = assessmentExists;
                if (!assessmentExists) {
                    // Verificar el estado del BBQ
                    getBBQStatus({ recordId: this.recordId })
                        .then(status => {
                            if (status === 'Completed') {
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
                        });
                }
            })
            .catch(error => {
                console.error('Error checking assessment existence:', error);
            });
    }

    handleScoreChange(event) {
        this.score = event.target.value;
    }

    handleObservationsChange(event) {
        this.observations = event.target.value;
    }

    handleSave() {
        //validar que todos los campos estén llenos
        if (!this.score || !this.observations) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'All fields are required.',
                    variant: 'error'
                })
            );
            return;
        }

        //validar que el puntaje esté entre 0 y 10
        const scoreValue = parseFloat(this.score);
        if (isNaN(scoreValue) || scoreValue < 0 || scoreValue > 10) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Score must be between 0 and 10.',
                    variant: 'error'
                })
            );
            return;
        }

        //guardar la evaluación
        saveEvaluation({
            recordId: this.recordId,
            score: this.score,
            observations: this.observations
        })
            .then(() => {
                //mostrar mensaje de éxito
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Assessment saved successfully!',
                        variant: 'success'
                    })
                );

                //limpiar los campos después de guardar
                this.score = '';
                this.observations = '';
                this.showComponent = false; // Ocultar el formulario si ya se hizo una evaluación
                this.assessmentExists = true; //si ya existe una evaluación
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'There was a problem saving the review.',
                        variant: 'error'
                    })
                );
                console.error(error);
            });

        console.log('Score:', this.score);
        console.log('Observations:', this.observations);
    }
}