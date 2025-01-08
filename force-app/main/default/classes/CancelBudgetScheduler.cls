public with sharing class CancelBudgetScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        CancelBudgetBatch batchJob = new CancelBudgetBatch();
        Database.executeBatch(batchJob, 50);
    }
}