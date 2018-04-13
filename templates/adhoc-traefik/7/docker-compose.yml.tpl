version: '2'
services:
    traefik-master:
        tty: true
        stdin_open: true
        command:
            - --api.dashboard
            - --checknewversion=false
            - --rancher
            - --rancher.domain=${domain}
            - --rancher.metadata
            - --rancher.enableservicehealthfilter=${EnableServiceHealthFilter}
            - --logLevel=INFO
            - --defaultentrypoints=http,https
            - --insecureskipverify=true
            - --entryPoints=Name:http Address::80 Redirect.EntryPoint:https
            - --entryPoints=Name:https Address::443 TLS Compress:on
        {{- if eq .Values.acme_enable "true"}}
            - --acme
            - --acme.acmelogging
            - --acme.entrypoint=https
            - --acme.email=${acme_email}
            - --acme.onhostrule=${acme_onhostrule}
            - --acme.storage=/secrets/acme.json
            - --acme.httpChallenge.entryPoint=http
            - --acme.domains=*.${domain}
            # - --acme.dnschallenge
            # - --acme.dnschallenge.provider=route53
        {{- end}}
        labels:
            io.rancher.scheduler.affinity:host_label: ${host_label}
            traefik.enable: 'true'
            traefik.port: 8080
            traefik.frontend.auth.basic: "${auth_users}"
            traefik.frontend.rule: "Host:tr.${domain}"
        image: traefik:1.6-alpine
        volumes:
            - traefik-secrets:/secrets
    traefik-slave:
        tty: true
        stdin_open: true
        ports:
            - ${admin_port}:8080/tcp
            - ${http_port}:80/tcp
            - ${https_port}:443/tcp
        command:
            - --api.dashboard
            - --checknewversion=false
            - --rancher
            - --rancher.domain=${domain}
            - --rancher.metadata
            - --rancher.enableservicehealthfilter=${EnableServiceHealthFilter}
            - --logLevel=INFO
            - --defaultentrypoints=http,https
            - --insecureskipverify=true
            - --entryPoints=Name:http Address::80 Redirect.EntryPoint:https
            - --entryPoints=Name:https Address::443 TLS Compress:on
        {{- if eq .Values.acme_enable "true"}}
            - --acme
            - --acme.acmelogging
            - --acme.entrypoint=https
            - --acme.email=${acme_email}
            - --acme.onhostrule=False
            - --acme.storage=/secrets/acme.json
        {{- end}}
        labels:
            # por ahora no lo hacemos global y lo manejamos con scale y host distinto
            io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
            io.rancher.scheduler.global: 'false'
            io.rancher.scheduler.affinity:host_label: ${host_label}
            traefik.enable: 'true'
            traefik.port: 8080
            traefik.frontend.auth.basic: "${auth_users}"
            traefik.frontend.rule: "Host:tr.${domain}"
        image: traefik:1.6-alpine
        volumes:
            - traefik-secrets:/secrets:ro
volumes:
    traefik-secrets:
        driver: rancher-nfs
        external: true
