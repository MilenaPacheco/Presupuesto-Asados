trigger DuplicateItem on BBQ_Budget_Items__c (before insert, before update) {
    //Cada vez que se crea un artículo de asado, Apex Trigger debe comprobar si el asado ya tiene registrado un artículo con el mismo producto.
    //Debe aparecer un mensaje de error indicando que el producto ya existe en ese asado.
    BBQ_Budget_Items__c itemsCurrent = new BBQ_Budget_Items__c(); 
}