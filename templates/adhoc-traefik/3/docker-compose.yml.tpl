version: '2'
services:
    traefik:
        ports:
            - ${admin_port}:8080/tcp
            - ${http_port}:80/tcp
            - ${https_port}:443/tcp
            # log_driver: ''
        command:
            - --web
            - --checkNewVersion=false
            - --rancher
            - --rancher.domain=${domain}
            - --rancher.endpoint=${Endpoint}
            - --rancher.accesskey=${AccessKey}
            - --rancher.secretkey=${SecretKey}
            # para v1.4
            # - --rancher.api.endpoint=${Endpoint}
            # - --rancher.api.accesskey=${AccessKey}
            # - --rancher.api.secretkey=${SecretKey}
            # por ahora agregamos esto porque si no da error al restaurar backups. Luego, si queremos actualizar online, tal vez tengamos que desactivarlo
            - --rancher.EnableServiceHealthFilter=${EnableServiceHealthFilter}
            # parameter para loglevel? (INFO, ERROR otra opcion)
            - --logLevel=INFO
            # para investigar...
            # - --docker.constraints="tag==web"
            # config entrypoints
            - --defaultentrypoints=http,https
            - --InsecureSkipVerify=true
            - --entryPoints='Name:http Address::80 Redirect.EntryPoint:https Compress:on'
            - --EntryPoints="Name:https Address::443 TLS:/secrets/domain.crt,/secrets/domain.key Compress:on" 
            # acme config
            # - --acme.domains=${domain}
        {{- if eq .Values.acme_enable "true"}}
            - --acme=${acme_enable}
            - --acme.entrypoint=https
            - --acme.email=${acme_email}
            - --acme.ondemand=${acme_ondemand}
            - --acme.onhostrule=${acme_onhostrule}
            - --acme.storage=/secrets/acme.json
        {{- end}}
        labels:
            io.rancher.scheduler.global: 'true'
            io.rancher.scheduler.affinity:host_label: ${host_label}
        # TODO
        # to enable stats dashboard, also enable web backend in traefik.toml
        #      - traefik.enable=true
        #      - traefik.docker.network=traefik-proxy
        #      - traefik.port=8080
        #      - traefik.frontend.rule=Host:traefik.domain.com
        tty: true
        image: traefik:1.3.8-alpine
        volumes:
            - traefik-secrets:/secrets
volumes:
    traefik-secrets:
        driver: rancher-nfs
        external: true
