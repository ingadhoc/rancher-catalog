## AOH System Simple

Single production instance of Odoo ERP.

### Provides

Production Odoo instance with backup and Rancher health checks.

### Other

Uses sidekick containers for stack scoped storage.

Provides a backup container on another host as the main app stack.

Includes basic health checks.

Provides a list of alternate server names that 
can be used by our base stack automation.

### New Configuration Items

 * strServerMode: set env variable SERVER_MODE. default empty
 * intWorkers: set env variable WORKERS (better if integer validation). Default=0. Required
 * strAdminPassword: set env variable ADMIN_PASSWORD. Default 'admin', required
 * boolWithoutDemo: set env variable WITHOUT_DEMO, default True
