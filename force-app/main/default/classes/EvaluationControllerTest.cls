@isTest
public class EvaluationControllerTest {

    @testSetup
    static void setupData() {
        // Crear datos de prueba
        BBQ_Budget__c budget = new BBQ_Budget__c(
            Name = 'Test Budget',
            Status__c = 'Completed'
        );
        insert budget;

        // Crear evaluación asociada
        Assessment__c assessment = new Assessment__c(
            BBQ_Budget__c = budget.Id,
            Score__c = 8,
            Observations__c = 'Test observation'
        );
        insert assessment;     
    }

    @isTest
    static void testGetBBQStatus() {
        // Obtener el presupuesto de prueba
        BBQ_Budget__c budget = [SELECT Id, Status__c FROM BBQ_Budget__c LIMIT 1];

        Test.startTest();
        String status = EvaluationController.getBBQStatus(budget.Id);
        Test.stopTest();

        // Verificar que el estado es el esperado
        System.assertEquals('Completed', status, 'El estado del presupuesto debería ser "Completed"');
    }

    @isTest
    static void testSaveEvaluation() {
        // Obtener el presupuesto de prueba
        BBQ_Budget__c budget = [SELECT Id FROM BBQ_Budget__c LIMIT 1];

        Test.startTest();
        EvaluationController.saveEvaluation(budget.Id, 9, 'Nueva evaluación');
        Test.stopTest();

        // Verificar que la evaluación se guardó correctamente
        Assessment__c newAssessment = [
            SELECT BBQ_Budget__c, Score__c, Observations__c
            FROM Assessment__c
            WHERE BBQ_Budget__c = :budget.Id
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        System.assertEquals(9, newAssessment.Score__c, 'El puntaje debería ser 9');
        System.assertEquals('Nueva evaluación', newAssessment.Observations__c, 'Las observaciones no coinciden');
    }

    @isTest
    static void testCheckIfAssessmentExists() {
        // Obtener el presupuesto de prueba
        BBQ_Budget__c budget = [SELECT Id FROM BBQ_Budget__c LIMIT 1];

        Test.startTest();
        Boolean exists = EvaluationController.checkIfAssessmentExists(budget.Id);
        Test.stopTest();

        // Verificar que existe al menos una evaluación
        System.assertEquals(true, exists, 'Debería existir al menos una evaluación para el presupuesto');

        // Probar con un presupuesto sin evaluaciones
        BBQ_Budget__c newBudget = new BBQ_Budget__c(
            Name = 'New Budget',
            Status__c = 'Pending'
        );
        insert newBudget;

        Test.startTest();
        Boolean noAssessment = EvaluationController.checkIfAssessmentExists(newBudget.Id);
        Test.stopTest();

        System.assertEquals(false, noAssessment, 'No debería existir una evaluación para el nuevo presupuesto');
    }
}