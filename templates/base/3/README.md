## AdHOC Odoo Rancher GCE base stack.

Latest version of our base stack has support via nginxssl-dockprox for automated LetsEncrypt SSL cert management.

Base stack picks up changes and provides and configures the following:

Postfix email proxy, Aeroo reports, Nginx proxy with LetsEncrypt SSL management and GC DNS automation.

## nginxssl-dockprox: Some Preliminary Notes

Make sure you have the same /etc/letsencrypt dir content on all of your Rancker controlled hosts or you may
exceed the permitted CertBOT weekly certificates number!
