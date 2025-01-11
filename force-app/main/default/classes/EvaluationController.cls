public with sharing class EvaluationController {
    //ver cual es el status del presupuesto
    @AuraEnabled
    public static String getBBQStatus(Id recordId) {
        //consulta el estado del presupuesto asociado al registro dado
        BBQ_Budget__c budget = [SELECT Status__c FROM BBQ_Budget__c WHERE Id = :recordId LIMIT 1];
        return budget.Status__c;
    }

    //conecta los componentes con la lógica de Apex para guardar una evaluación
    @AuraEnabled
    public static void saveEvaluation(Id recordId, Integer score, String observations) {
        //crear una nueva evaluación para el presupuesto
        Assessment__c evaluation = new Assessment__c();
        evaluation.BBQ_Budget__c = recordId; 
        evaluation.Score__c = score; 
        evaluation.Observations__c = observations; 
        insert evaluation; 
    }
    
    //verificar si ya existe una evaluación para el presupuesto dado
    @AuraEnabled
    public static Boolean checkIfAssessmentExists(Id recordId) {
        //realiza una consulta para contar las evaluaciones relacionadas con el presupuesto
        Integer assessmentCount = [
            SELECT COUNT()
            FROM Assessment__c
            WHERE BBQ_Budget__c = :recordId
        ];
        //true si ya existe al menos una evaluación, false en caso contrario
        return assessmentCount > 0;
    }
}
