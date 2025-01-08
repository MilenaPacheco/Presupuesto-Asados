public with sharing class EvaluationController {
    //Ver cual es el status del presupuesto
    @AuraEnabled
    public static String getBBQStatus(Id recordId){
        BBQ_Budget__c budget = [SELECT Status__c FROM BBQ_Budget__c WHERE Id = :recordId LIMIT 1];
        return budget.Status__c;
    }

    //conecta los componentes con la lógica de Apex
    @AuraEnabled
    public static void saveEvaluation(Id recordId, Integer score, String observations){
        Assessment__c evaluation = new Assessment__c();
        evaluation.BBQ_Budget__c = recordId;
        evaluation.Score__c = score;
        evaluation.Observations__c = observations;
        insert evaluation;
    }
    
}