trigger DuplicateItem on BBQ_Budget_Items__c (before insert, before update) {
    //recolectar los ids de presupuestos registrados
    Set<Id> budgetIds = new Set<Id>();
    for (BBQ_Budget_Items__c item : Trigger.new) {
        if (item.BBQ_Budget__c != null) {
            budgetIds.add(item.BBQ_Budget__c);
        }
    }

    //consultar los productos que existen en los presupuestos,, gurdar la consulta en una lista para iterar
    Map<Id, Set<Id>> existingBudgetProductMap = new Map<Id, Set<Id>>();
    List<BBQ_Budget_Items__c> existingItems = [
        SELECT Id, BBQ_Budget__c, Product__c
        FROM BBQ_Budget_Items__c
        WHERE BBQ_Budget__c IN :budgetIds
    ];

    //crear el mapa de productos por presupuesto
    for (BBQ_Budget_Items__c existingItem : existingItems) {
        if (!existingBudgetProductMap.containsKey(existingItem.BBQ_Budget__c)) {
            existingBudgetProductMap.put(existingItem.BBQ_Budget__c, new Set<Id>());
        }
        existingBudgetProductMap.get(existingItem.BBQ_Budget__c).add(existingItem.Product__c);
    }

    //validar duplicados excluyendo el registro actual
    for (BBQ_Budget_Items__c item : Trigger.new) {
        if (item.BBQ_Budget__c != null && item.Product__c != null) {
            //verificar si el producto ya existe en el presupuesto
            if (existingBudgetProductMap.containsKey(item.BBQ_Budget__c) &&
                existingBudgetProductMap.get(item.BBQ_Budget__c).contains(item.Product__c)) {
                //sacar el registro actual en caso de actualización
                Boolean isDuplicate = false;
                for (BBQ_Budget_Items__c existingItem : existingItems) {
                    if (existingItem.BBQ_Budget__c == item.BBQ_Budget__c &&
                        existingItem.Product__c == item.Product__c &&
                        existingItem.Id != item.Id) {
                        isDuplicate = true;
                        break;
                    }
                }

                //mostrar error solo si es duplicado
                if (isDuplicate) {
                    item.addError('An item with this product already exists in the budget.');
                }
            }
        }
    }
}
