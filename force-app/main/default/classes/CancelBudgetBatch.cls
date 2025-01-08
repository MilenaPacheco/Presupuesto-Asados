public with sharing class CancelBudgetBatch implements Database.Batchable<SObject>{
    // Query inicial para obtener presupuestos no realizados y vencidos
    public Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, End__c
            FROM BBQ_Budget__c
            //WHERE Status__c = 'Cancelled' AND End__c < TODAY 
            WHERE End__c < TODAY 

        ]);
    }

    //Procesar los registros por lotes y cambiar estado a Cancelled
    public void execute(Database.BatchableContext bc, List<BBQ_Budget__c> scope){
        for (BBQ_Budget__c presupuesto : scope){
            presupuesto.Status__c = 'Cancelled';
        }
        update scope;
    }

    // Finalizar el batch
    public void finish(Database.BatchableContext bc){
        System.debug('End Batch. cancelled Budget');
    }
}