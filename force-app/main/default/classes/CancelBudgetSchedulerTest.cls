@isTest
private class CancelBudgetSchedulerTest {

    @testSetup
    static void setup() {
        // Crear datos de prueba
        List<BBQ_Budget__c> budgets = new List<BBQ_Budget__c>();
        for (Integer i = 0; i < 10; i++) {
            budgets.add(new BBQ_Budget__c(
                Status__c = 'Active',
                End__c = Date.today().addDays(-i - 1)
            ));
        }
        insert budgets;
    }

    @isTest
    static void testScheduler() {
        // Programar el trabajo
        String jobId = System.schedule('Test CancelBudgetScheduler', '0 0 0 15 8 ? 2022', new CancelBudgetScheduler());

        // Ejecutar el trabajo programado
        Test.startTest();
        System.abortJob(jobId);
        Test.stopTest();

        // Verificar que los presupuestos han sido cancelados
        for (BBQ_Budget__c budget : [SELECT Status__c FROM BBQ_Budget__c]) {
            System.assertEquals('Cancelled', budget.Status__c);
        }
    }
}