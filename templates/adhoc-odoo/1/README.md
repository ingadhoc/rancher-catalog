## ADHOC Odoo 9.0

Deploy Odoo

### Provides

Production Odoo instance with Rancher health checks.

### Configuration Items

 * strServerMode: set env variable SERVER_MODE. default empty
 * intWorkers: set env variable WORKERS (better if integer validation). Default=0. Required
 * strAdminPassword: set env variable ADMIN_PASSWORD. Default 'admin', required
 * boolWithoutDemo: set env variable WITHOUT_DEMO, default True
