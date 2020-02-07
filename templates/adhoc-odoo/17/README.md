## Odoo SaaS 12.0

Deploy Odoo

### Provides

Production Odoo instance with Rancher health checks.

### Configuration Items

 * strServerMode: set env variable SERVER_MODE. default empty
 * intWorkers: set env variable WORKERS (better if integer validation). Default=0. Required
 * strAdminPassword: set env variable ADMIN_PASSWORD. Default 'admin', required
 * boolWithoutDemo: set env variable WITHOUT_DEMO, default True


SOBRE EL SIDEKICK
    # agregamos esto de las sesiones para que cuando actualizamos la gente no quede deslogeada
    # no lo montamos a todo el data directamente porque en teoría las sesiones deberian tener buena performance

# image: alpine:3.6
        # image: adhoc/odoo-ar-e:9.0
        # TODO, habria que mejorarlo para nodar permiso 777
        # bash -c "chown -R www-data. application; chown -R www-data. packages; sleep 2m; php -f concrete/bin/concrete5.php c5:install --db-server=mysql --db-username=${db_username} --db-password=${db_password} --db-database=${db_name} --site=${cms_sitename} --admin-email=${cms_admin_email} --admin-password=${cms_admin_password} -n -vvv"
        # alpine no tiene el bash, va sh
        # command: sh -c "adduser -S -D odoo; chown -R odoo.odoo /opt/odoo/data/sessions"
        # probe como hace rawmind y distintas maneras pero no consegui permiso de escritura en la carpeta sessions
        # la unica fue esta del command

                # command: bash -c "chmod 777 -R /opt/odoo/data/sessions"
        # command: chmod 777 -R /opt/odoo/data/sessions
