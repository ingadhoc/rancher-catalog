version: '2'
services:
    odoo:
        tty: true
        stdin_open: true
        image: $strImageName:$strImageTag
        labels:
            io.rancher.container.pull_image: always
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
            # TODO, este podria volver a ser un booleano y tmb podriamos
            # re simplificar el entry point, ahora modificamos a odoo para que
            # no cree bd si se manda el db_name, y estamos haciendo eso, mandar
            # db_name
            - REPOS_YML=$strReposYml
            - FIXDBS=$strFixDbs
            - SMTP_SERVER=$strSmtpServer
            - SMTP_PORT=$intSmtPort
            - SMTP_SSL=$boolSmtpSsl
            - SMTP_USER=$strSmtpUser
            - SMTP_PASSWORD=$strSmtPassword
            - AEROO_DOCS_HOST= aeroo-docs.adhoc-aeroo-docs
            - DATABASE=$strDatabase
            - DBFILTER=$strDbFilter
            - SERVER_MODE=$strServerMode
            - DISABLE_SESSION_GC=$strDisableSessionGC
            - WORKERS=$intWorkers
            - MAX_CRON_THREADS=$intMaxCronThreads
            - ADMIN_PASSWORD=$strAdminPassword
            - MAIL_CATCHALL_DOMAIN=$strMailCatchallDomain
            - FIX_DB_WEB_DISABLED=True
            - LIST_DB=$boolListDb
            - DB_MAXCONN=$intDbMaxconn
            - LIMIT_MEMORY_HARD=$intLimitMemoryHard
            - LIMIT_MEMORY_SOFT=$intLimitMemorySoft
            - LIMIT_TIME_CPU=$intLimiteTimeCpu
            - LIMIT_TIME_REAL=$intLimiteTimeReal
            - LIMIT_TIME_REAL_CRON=$intLimiteTimeRealCron
            - ODOO_VERSION=$strImageTag
            - SERVER_WIDE_MODULES=$strServerWideModules
            {{- if eq .Values.enumSessionsStore "redis" }}
            - ENABLE_REDIS=True
            - REDIS_HOST=$strRedisHost
            - REDIS_PASS=$strRedisPass
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
