version: '2'
services:
    traefik:
        tty: true
        stdin_open: true
        ports:
            - ${admin_port}:8080/tcp
            - ${http_port}:80/tcp
            - ${https_port}:443/tcp
        {{- if and (eq .Values.acme_http_challenge "false") (ne .Values.acme_dns_challenge "gcloud")}}
        command: sh -c "traefik storeconfig --api.dashboard --checknewversion=false --rancher --rancher.domain=${domain} --rancher.metadata --rancher.enableservicehealthfilter=${EnableServiceHealthFilter} --logLevel=INFO --defaultentrypoints=http,https --insecureskipverify=true '--entryPoints=Name:http Address::80 Redirect.EntryPoint:https' '--entryPoints=Name:https Address::443 TLS Compress:on' --acme --acme.acmelogging --acme.entrypoint=https --acme.httpChallenge.entryPoint= --acme.dnschallenge.provider= --acme.email=${acme_email} --acme.onhostrule=${acme_onhostrule} --acme.storage=traefik/acme/account --consul.endpoint=${ConsulEndpoint} && traefik --consul --consul.endpoint=${ConsulEndpoint}"
        {{- end}}
        {{- if eq .Values.acme_http_challenge "true"}}
        command: sh -c "traefik storeconfig --api.dashboard --checknewversion=false --rancher --rancher.domain=${domain} --rancher.metadata --rancher.enableservicehealthfilter=${EnableServiceHealthFilter} --logLevel=INFO --defaultentrypoints=http,https --insecureskipverify=true '--entryPoints=Name:http Address::80 Redirect.EntryPoint:https' '--entryPoints=Name:https Address::443 TLS Compress:on' --acme --acme.acmelogging --acme.entrypoint=https --acme.email=${acme_email} --acme.onhostrule=${acme_onhostrule} --acme.storage=traefik/acme/account --acme.httpChallenge --acme.httpChallenge.entryPoint=http --consul.endpoint=${ConsulEndpoint} && traefik --consul --consul.endpoint=${ConsulEndpoint}"
        {{- end}}
        {{- if eq .Values.acme_dns_challenge "gcloud"}}
        command: sh -c "traefik storeconfig --api.dashboard --checknewversion=false --rancher --rancher.domain=${domain} --rancher.metadata --rancher.enableservicehealthfilter=${EnableServiceHealthFilter} --logLevel=INFO --defaultentrypoints=http,https --insecureskipverify=true '--entryPoints=Name:http Address::80 Redirect.EntryPoint:https' '--entryPoints=Name:https Address::443 TLS Compress:on' --acme --acme.acmelogging --acme.entrypoint=https --acme.email=${acme_email} --acme.onhostrule=${acme_onhostrule} --acme.storage=traefik/acme/account --acme.dnschallenge --acme.domains=*.${domain} --acme.dnschallenge.provider=gcloud --acme.dnschallenge.delaybeforecheck=180 --consul.endpoint=${ConsulEndpoint} && traefik --consul --consul.endpoint=${ConsulEndpoint}"
        {{- end}}
        {{- if eq .Values.acme_dns_challenge "cloudflare"}}
        command: sh -c "traefik storeconfig --api.dashboard --checknewversion=false --rancher --rancher.domain=${domain} --rancher.metadata --rancher.enableservicehealthfilter=${EnableServiceHealthFilter} --logLevel=INFO --defaultentrypoints=http,https --insecureskipverify=true '--entryPoints=Name:http Address::80 Redirect.EntryPoint:https' '--entryPoints=Name:https Address::443 TLS Compress:on' --acme --acme.acmelogging --acme.entrypoint=https --acme.email=${acme_email} --acme.onhostrule=${acme_onhostrule} --acme.storage=traefik/acme/account --acme.dnschallenge --acme.domains=*.${domain} --acme.dnschallenge.provider=cloudflare --acme.dnschallenge.delaybeforecheck=180 --consul.endpoint=${ConsulEndpoint} && traefik --consul --consul.endpoint=${ConsulEndpoint}"
        {{- end}}
        # por ahora traefik no soporta los dos challenge a la vez pero puede ser que mas adelante si, ver acá https://github.com/containous/traefik/issues/3378
        {{- if eq .Values.acme_dns_challenge "cloudflare"}}
        environment:
            CF_API_KEY: ${acme_dns_challenge_CF_API_KEY}
            CF_API_EMAIL: ${acme_dns_challenge_CF_API_EMAIL}
        {{- end}}
        {{- if eq .Values.acme_dns_challenge "gcloud"}}
        environment:
            GCE_PROJECT: ${acme_dns_challenge_GCE_PROJECT}
            GCE_SERVICE_ACCOUNT_FILE: ${acme_dns_challenge_GCE_SERVICE_ACCOUNT_FILE}
        {{- end}}
        labels:
            # por ahora no lo hacemos global y lo manejamos con scale y host distinto
            # io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
            # io.rancher.scheduler.global: 'false'
            io.rancher.scheduler.global: 'true'
            io.rancher.scheduler.affinity:host_label: ${host_label}
            # publish traefik admin
            traefik.enable: 'true'
            traefik.port: 8080
            traefik.frontend.auth.basic.users: "${auth_users}"
            traefik.frontend.rule: "Host:tr.${domain}"
        image: traefik:1.7.24-alpine
        volumes:
            - traefik-secrets:/secrets
volumes:
    traefik-secrets:
        driver: rancher-nfs
        external: true
