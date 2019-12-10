version: '2'
services:
    odoo:
        tty: true
        stdin_open: true
        image: $strImageName:$strImageTag
        labels:
            io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
            io.rancher.scheduler.affinity:host_label: ${host_label}
            traefik.enable: true
            traefik.port: 8069
            traefik.backend.loadbalancer.stickiness: true
            traefik.backend.loadbalancer.method: drr
            {{- if ne .Values.strGCECloudsqlConnectionName "" }}
            io.rancher.sidekicks: gce-psql-proxy
            {{- end}}
        {{- if eq .Values.intWorkers "0"}}
            traefik.frontend.rule: Host:$strTraefikDomains
            traefik.frontend.redirect.regex: $strTraefikRedirectRegex
            traefik.frontend.redirect.replacement: $strTraefikRedirectReplacement
            traefik.frontend.redirect.permanent: true
        {{- else}}
            traefik.odoo.port: 8069
            traefik.odoo.frontend.rule: Host:$strTraefikDomains
            traefik.odoo.frontend.redirect.regex: $strTraefikRedirectRegex
            traefik.odoo.frontend.redirect.replacement: $strTraefikRedirectReplacement
            traefik.odoo.frontend.redirect.permanent: true
            traefik.longpolling.port: 8072
            traefik.longpolling.frontend.rule: Host:$strTraefikDomains;PathPrefix:/longpolling/
            traefik.longpolling.frontend.redirect.regex: $strTraefikRedirectRegex
            traefik.longpolling.frontend.redirect.replacement: $strTraefikRedirectReplacement
            traefik.longpolling.frontend.redirect.permanent: true
        {{- end}}
        volumes:
            - $strOdooFilestoreVolumeName:$strOdooDataFilestore
            {{- if eq .Values.enumSessionsStore "filestore" }}
            - $strOdooSessionsVolumeName:$strOdooDataSessions
            {{- end}}
        environment:
            # database parameters
            - PGUSER=$strPgUser
            - PGPASSWORD=$strPgPassword
            - PGHOST=$strPgHost
            - PGPORT=$strPgPort
            - PGDATABASE=$strDatabase
            - DATABASE=$strDatabase
            - DBFILTER=$strDbFilter
            - LIST_DB=$boolListDb
            - DB_MAXCONN=$intDbMaxconn
            # TODO, este podria volver a ser un booleano y tmb podriamos
            # re simplificar el entry point, ahora modificamos a odoo para que
            # no cree bd si se manda el db_name, y estamos haciendo eso, mandar
            # db_name
            - FIXDBS=$strFixDbs
            - FIX_DB_WEB_DISABLED=True
            - SMTP_SERVER=$strSmtpServer
            - SMTP_PORT=$intSmtPort
            - SMTP_SSL=$boolSmtpSsl
            - SMTP_USER=$strSmtpUser
            - SMTP_PASSWORD=$strSmtPassword
            - AEROO_DOCS_HOST= aeroo-docs.adhoc-aeroo-docs
            - ADMIN_PASSWORD=$strAdminPassword
            - WORKERS=$intWorkers
            - UNACCENT=True
            - PROXY_MODE=True
            - WITHOUT_DEMO=True
            - WAIT_PG=True
            - MAX_CRON_THREADS=$intMaxCronThreads
            - SERVER_MODE=$strServerMode
            - DISABLE_SESSION_GC=$strDisableSessionGC
            - MAIL_CATCHALL_DOMAIN=$strMailCatchallDomain
            - REPOS_YML=$strReposYml
            - LIMIT_MEMORY_HARD=$intLimitMemoryHard
            - LIMIT_MEMORY_SOFT=$intLimitMemorySoft
            - LIMIT_TIME_CPU=$intLimiteTimeCpu
            - LIMIT_TIME_REAL=$intLimiteTimeReal
            - LIMIT_TIME_REAL_CRON=$intLimiteTimeRealCron
            - ODOO_VERSION=$strImageTag
            - SERVER_WIDE_MODULES=$strServerWideModules
            - FILESTORE_COPY_HARD_LINK=True
            - FILESTORE_OPERATIONS_THREADS=3
            {{- if eq .Values.enumSessionsStore "redis" }}
            - ENABLE_REDIS=True
            - REDIS_HOST=$strRedisHost
            - REDIS_PORT=6379
            - REDIS_PASS=$strRedisPass
            - REDIS_DBINDEX=1
            {{- end}}
    {{- if ne .Values.strGCECloudsqlConnectionName "" }}
    gce-psql-proxy:
        image: gcr.io/cloudsql-docker/gce-proxy:1.11
        network_mode: container:odoo
        command:
            - /cloud_sql_proxy
            - -instances=$strGCECloudsqlConnectionName=tcp:5432
        # labels:
        #    io.rancher.scheduler.affinity:container_label: io.rancher.stack_service.name=$${stack_name}/odoo
    {{- end}}
volumes:
  {{- if eq .Values.enumSessionsStore "filestore" }}
  $strOdooSessionsVolumeName:
    driver: rancher-nfs
    external: true
  {{- end}}
  $strOdooFilestoreVolumeName:
    driver: rancher-nfs
    external: true
