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
            - --rancher
            - --rancher.domain=${domain}
            - --rancher.endpoint=${Endpoint}
            - --rancher.accesskey=${AccessKey}
            - --rancher.secretkey=${SecretKey}
            # parameter para loglevel? (INFO otra opcion)
            - --logLevel=DEBUG
            # config entrypoints
            - --defaultentrypoints=http,https
            - --entryPoints='Name:http Address::80'
            # - --entryPoints='Name:http Address::80 Redirect.EntryPoint:https'
            # - --entryPoints='Name:https Address::443 TLS compress'
            # para investigar...
            # - --docker.constraints="tag==web"
            - --InsecureSkipVerify=true
            # - --entryPoints='Name:https Address::443 TLS:/ssl/domain.crt,/ssl/domain.key'
            # - --entrypoints="Name:http Address::80 Redirect.EntryPoint:https"
            # - --entryPoints="Name:https Address::443 TLS:/ssl/traefik.crt,/ssl/traefik.key"
            # - --entryPoints="Name:https Address::443 TLS insecureskipverify"
{{- if eq .Values.https_enable "true"}}
            - --entryPoints='Name:https Address::443 TLS'
            insecureskipverify
{{- end}}
            # acme config
{{- if eq .Values.acme_enable "true"}}
            - --acme=${acme_enable}
            - --acme.domains=${domain}
            - --acme.entrypoint=https
            - --acme.email=${acme_email}
            - --acme.ondemand=${acme_ondemand}
            - --acme.onhostrule=${acme_onhostrule}
            - --acme.storage=/ssl/acme.json
{{- end}}
        labels:
            io.rancher.scheduler.global: 'true'
        # TODO
        # to enable stats dashboard, also enable web backend in traefik.toml
        #      - traefik.enable=true
        #      - traefik.docker.network=traefik-proxy
        #      - traefik.port=8080
        #      - traefik.frontend.rule=Host:traefik.domain.com
        # tty: true
        # log_opt: {}
        # image: traefik:1.3.2
        # alpine nos permite conectarnos, el otro no
        image: traefik:1.3.2-alpine
        # environment:
        volumes:
            - traefik:/data
            - sslcerts:/ssl
            # - /opt/traefik/acme
            # - db_data:/var/lib/postgresql/data/pgdata
volumes:
    traefik:
        driver: rancher-nfs
        external: false
    sslcerts:
        driver: rancher-nfs
        external: false
# volumes:
#   sslcerts:
#     driver: local
#   traefik:
#     driver: local
