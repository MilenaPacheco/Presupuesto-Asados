import { createElement } from 'lwc/createElement';
import EvaluationComponent from 'c/evaluationComponent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import checkIfAssessmentExists from '@salesforce/apex/EvaluationController.checkIfAssessmentExists';
import getBBQStatus from '@salesforce/apex/EvaluationController.getBBQStatus';
import saveEvaluation from '@salesforce/apex/EvaluationController.saveEvaluation';

jest.mock('@salesforce/apex/EvaluationController.checkIfAssessmentExists', () => ({
    default: jest.fn()
}));
jest.mock('@salesforce/apex/EvaluationController.getBBQStatus', () => ({
    default: jest.fn()
}));
jest.mock('@salesforce/apex/EvaluationController.saveEvaluation', () => ({
    default: jest.fn()
}));

describe('c-evaluation-component', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('should display the component if BBQ is completed and no assessment exists', async () => {
        checkIfAssessmentExists.mockResolvedValue(false);
        getBBQStatus.mockResolvedValue('Completed');

        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        await Promise.resolve();

        expect(element.showComponent).toBe(true);
    });

    it('should not display the component if BBQ is not completed', async () => {
        checkIfAssessmentExists.mockResolvedValue(false);
        getBBQStatus.mockResolvedValue('Not Completed');

        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        await Promise.resolve();

        expect(element.showComponent).toBe(false);
    });

    it('should show error toast if BBQ is not completed', async () => {
        checkIfAssessmentExists.mockResolvedValue(false);
        getBBQStatus.mockResolvedValue('Not Completed');

        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        await Promise.resolve();

        const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'The BBQ must be completed before scoring.',
            variant: 'error'
        });
        expect(element.dispatchEvent).toHaveBeenCalledWith(toastEvent);
    });

    it('should save the evaluation successfully', async () => {
        checkIfAssessmentExists.mockResolvedValue(false);
        getBBQStatus.mockResolvedValue('Completed');
        saveEvaluation.mockResolvedValue({});

        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        await Promise.resolve();

        element.score = '8';
        element.observations = 'Good BBQ';
        element.handleSave();

        await Promise.resolve();

        expect(saveEvaluation).toHaveBeenCalledWith({
            recordId: element.recordId,
            score: '8',
            observations: 'Good BBQ'
        });

        const successToastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Assessment saved successfully!',
            variant: 'success'
        });
        expect(element.dispatchEvent).toHaveBeenCalledWith(successToastEvent);
    });

    it('should show error toast if fields are empty', async () => {
        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        element.handleSave();

        const errorToastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'All fields are required.',
            variant: 'error'
        });
        expect(element.dispatchEvent).toHaveBeenCalledWith(errorToastEvent);
    });

    it('should show error toast if score is out of range', async () => {
        const element = createElement('c-evaluation-component', {
            is: EvaluationComponent
        });
        document.body.appendChild(element);

        element.score = '11';
        element.handleSave();

        const errorToastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'Score must be between 0 and 10.',
            variant: 'error'
        });
        expect(element.dispatchEvent).toHaveBeenCalledWith(errorToastEvent);
    });
});