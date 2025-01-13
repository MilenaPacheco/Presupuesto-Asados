# Presupuesto Asados

## Descripción General

Este proyecto es una aplicación desarrollada en Salesforce para la gestión de presupuestos de asados. Permite a los usuarios crear y gestionar presupuestos, calificar eventos, y realizar un seguimiento de los productos y servicios utilizados. La aplicación está diseñada para ser intuitiva, eficiente y personalizable, aprovechando las capacidades nativas de Salesforce como Flows, LWC (Lightning Web Components) y Apex.

## Características

- Gestión de presupuestos de asados.
- Registro y consulta de productos y servicios asociados.
- Flujo de aprobación de presupuestos.
- Generación de reportes y dashboards para análisis.
- Evaluación de eventos con sistema de calificación.
- Notificaciones automáticas mediante correos electrónicos.

## Estructura de Objetos y Relaciones

La aplicación utiliza los siguientes objetos y relaciones:

### **1. Objeto Principal: BBQ_Budget__c**
- **Nombre:** Roasted Budget Name (Texto)
- **Estado:** Status__c (Picklist)
  - Valores: New, In Process, Approved, Completed
- **Inicio y Fin:** Start__c, End__c (Fecha/Hora)
- **Monto Total:** Total_Amount__c (Currency)
- **Relaciones:**
  - Relación con `BBQ_Budget_Items__c` (Master-Detail)
  - Relación con Contactos (Lookup)

### **2. Objeto Secundario: BBQ_Budget_Items__c**
- **Producto o Servicio:** Product__c (Lookup a Product2)
- **Cantidad:** Quantity__c (Número)
- **Monto:** Amount__c (Fórmula: Cantidad * Precio Unitario)
- **Relaciones:**
  - Relación con `BBQ_Budget__c` (Master-Detail)

### **3. Objeto: Assessment__c**
- **Calificación:** Score__c (Número: 0-10)
- **Observaciones:** Observations__c (Texto Largo)
- **Relaciones:**
  - Relación con `BBQ_Budget__c` (Lookup)

### **4. Producto/Servicio: Product2**
- **Tipo de Registro:** Producto o Servicio
- **Precio Unitario:** UnitPrice (Currency)

### Diagrama de Relaciones
![Diagrama de Relaciones](./images/diagram.png)

## Requerimientos

Para ejecutar este proyecto, necesitas:

- Una organización Salesforce activa.
- Perfil de administrador en Salesforce.
- Habilitación de Flows, Apex y LWC en tu organización.
- Herramientas CLI de Salesforce.

## Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/MilenaPacheco/Presupuesto-Asados.git
```

2. Accede al directorio:
```bash
cd Presupuesto-Asados
```

3. Autoriza una organización en Salesforce:
```bash
sfdx auth:web:login -a nombreDeTuOrg
```

4. Despliega los metadatos:
```bash
sfdx force:source:deploy -p force-app
```

5. Asigna el paquete al perfil de usuario:
```bash
sfdx force:user:permset:assign -n PresupuestoAsadosPermiso
```

6. Importa datos de ejemplo (opcional):
```bash
sfdx force:data:tree:import -f data/sample-data.json
```

## Flujos Implementados

1. **Flujo de Aprobación de Presupuestos:**
   - Ruta: `Tiene Productos o Servicios -> Aprobación o Actualización -> Notificación`

2. **Notificación por Correo:**
   - Envia correos automáticos a los clientes para informarles del estado del presupuesto.

## Reglas de Validación Implementadas

1. **Validación de Puntaje en Evaluaciones:**
   - **Regla:** Score__c >= 0 && Score__c <= 10
   - **Descripción:** Asegura que el puntaje asignado esté entre 0 y 10.
   
2. **Estado del Presupuesto:**
   - **Regla:** ISCHANGED(Status__c) && Status__c = "Completed"
   - **Descripción:** Permite cambiar el estado a "Completed" solo si se cumplen ciertas condiciones (configurables).

3. **Evitar Productos Duplicados:**
   - **Regla:** NOT(ISBLANK(Product__c)) && Product__c = "[ID Producto Existente]"
   - **Descripción:** Evita duplicar productos en una misma partida presupuestaria.

4. **Campos Obligatorios en Creación de Presupuesto:**
   - **Regla:** ISBLANK(Start__c) || ISBLANK(End__c) || ISBLANK(Client__c)
   - **Descripción:** Asegura que los campos clave estén llenos al crear un presupuesto.

## Dashboards y Reportes

- **Reporte de Productos más Vendidos:**
  - Descripción: Muestra los productos más solicitados agrupados por tipo.
  - ![Productos Más Vendidos](./images/productos_mas_vendidos.png)

- **Reporte de Calificaciones Promedio:**
  - Descripción: Permite analizar las calificaciones asignadas a los eventos.
  - ![Calificaciones Promedio](./images/calificaciones_promedio.png)

- **Dashboard de Eventos por Día:**
  - Descripción: Visualiza los eventos programados por fecha y el monto asociado.
  - ![Dashboard Eventos](./images/eventos_por_dia.png)

## Uso

### Creación de un Presupuesto
1. Dirígete a la pestaña `Presupuesto Asados`.
2. Haz clic en `Nuevo Presupuesto`.
3. Llena los campos requeridos y guarda el registro.

### Evaluación de un Evento
1. Accede a un presupuesto completado.
2. Califica el evento usando el componente de evaluación.
3. Guarda la evaluación.

### Visualización de Reportes
1. Accede a la pestaña `Reportes`.
2. Selecciona el reporte deseado.
3. Filtra los resultados según tus necesidades.

## Contribución

1. Realiza un fork de este repositorio.
2. Crea una rama para tu feature:
```bash
git checkout -b feature/nueva-feature
```
3. Realiza los cambios y haz un commit:
```bash
git commit -m "Agrega nueva funcionalidad"
```
4. Envía tus cambios:
```bash
git push origin feature/nueva-feature
```
5. Crea un Pull Request.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](./LICENSE) para más detalles.


