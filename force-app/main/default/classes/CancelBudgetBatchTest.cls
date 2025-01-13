@isTest
public class CancelBudgetBatchTest {
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
    static void testBatchable() {
        // Ejecutar el batch
        Test.startTest();
        CancelBudgetBatch batch = new CancelBudgetBatch();
        Database.executeBatch(batch, 5);
        Test.stopTest();

        // Verificar que los presupuestos han sido cancelados
        for (BBQ_Budget__c budget : [SELECT Status__c FROM BBQ_Budget__c]) {
            System.assertEquals('Cancelled', budget.Status__c);
        }
    }

    @isTest
    static void testFinishMethod() {
        // Ejecutar el batch
        Test.startTest();
        CancelBudgetBatch batch = new CancelBudgetBatch();
        Database.executeBatch(batch, 5);
        Test.stopTest();

        // Verificar que el método finish se ejecutó correctamente
        // (Esto se verifica implícitamente al no lanzar errores)
    }
}