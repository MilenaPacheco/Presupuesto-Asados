trigger CalculateBudgetItemValue on BBQ_Budget_Items__c (before insert, before update) {
    //obtener los precios de los servicios desde el Custom Metadata
    Map<String, Decimal> servicePriceMap = new Map<String, Decimal>();
    for (Service_Price_Table__mdt service : [SELECT Service_Type__c, Price_Per_Hour__c FROM Service_Price_Table__mdt]) {
        servicePriceMap.put(service.Service_Type__c, service.Price_Per_Hour__c);
    }

    //ubicar los Ids de los presupuesto 
    Set<Id> budgetIds = new Set<Id>();
    for (BBQ_Budget_Items__c item : Trigger.new) {
        if (item.BBQ_Budget__c != null) {
            budgetIds.add(item.BBQ_Budget__c);
        }
    }

    //consultar los presupuestos relacionados
    Map<Id, BBQ_Budget__c> budgetMap = new Map<Id, BBQ_Budget__c>([
        SELECT Id, Start__c, End__c FROM BBQ_Budget__c WHERE Id IN :budgetIds
    ]);

    //iterar sobre los ítems
    for (BBQ_Budget_Items__c item : Trigger.new) {
        //verificar si existe el presupuesto relacionado
        if (item.BBQ_Budget__c != null && budgetMap.containsKey(item.BBQ_Budget__c)) {
            BBQ_Budget__c relatedBudget = budgetMap.get(item.BBQ_Budget__c);

            //validar que las fechas de inicio y fin estén presentes
            if (relatedBudget.Start__c != null && relatedBudget.End__c != null) {
                //calcular la duración en horas y redondear hacia arriba
                Decimal duration = (relatedBudget.End__c.getTime() - relatedBudget.Start__c.getTime()) / (60 * 60 * 1000);
                Decimal roundedDuration = Math.ceil(duration);

                //verificar si es un producto o servicio
                if (item.Product__c != null) {
                    Product2 relatedProduct = [
                        SELECT RecordType.Name, Service__c, Amount__c 
                        FROM Product2 
                        WHERE Id = :item.Product__c 
                        LIMIT 1
                    ];

                    if (relatedProduct.RecordType.Name == 'Product') {
                        //calcular el valor para productos
                        if (relatedProduct.Amount__c != null && item.Quantity__c != null) {
                            item.Amount__c = relatedProduct.Amount__c * item.Quantity__c;
                        } else {
                            item.addError('The Amount or Quantity is missing for this product.');
                        }
                    } else if (relatedProduct.RecordType.Name == 'Service') {
                        //calcular el valor para servicios
                        if (relatedProduct.Service__c != null && servicePriceMap.containsKey(relatedProduct.Service__c)) {
                            Decimal pricePerHour = servicePriceMap.get(relatedProduct.Service__c);
                            item.Amount__c = roundedDuration * pricePerHour;
                        } else {
                            item.addError('The service type "' + relatedProduct.Service__c + '" does not have a price in the table.');
                        }
                    }
                } else {
                    item.addError('The Product field cannot be empty.');
                }
            } else {
                item.addError('The Start and End fields are required in the related Budget record.');
            }
        } else {
            item.addError('The related BBQ Budget record is missing.');
        }
    }
}