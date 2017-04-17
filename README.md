# AdHoc Rancher Catalog
Rancher catalog adhoc-rancher for Odoo ERP Docker based hosting.

## Status
Scheduled March 1 Beta realease is on track. Almost all work so far is non Rancher related, it is custom Docker container work for automation of node services (*a la* genbot etc) in the base stack. Rancher/Docker areas thart could beneifit from expert help maybe are: SSL cert store, Service backup and other Rancher/Docker architecture issues.
### Open issues
* Manual SSL cert install for alternative host names.
* No backup mechanism in place for Odoo stack.
* LetsEncrypt cluster is based on simplistic cron driven rsync
```
root@host0:~# crontab -l
*/5 * * * * ps -ef | grep certbot | grep -v grep > /dev/null 2>&1 || rsync -az /etc/letsencrypt/ host1:/etc/letsencrypt/ > /tmp/rsync.log 2>&1;
```


## AdHoc Odoo Hosting for Rancher
Use this catalog to host AdHoc Odoo services with the awesome Rancher!

To use this, do the following:

* Go to the admin tab, then click on settings
* In the catalog section, click "Add Catalog"
* In the Name box, enter `AdHoc`
* In the URL box, enter `https://github.com/unxs0/adhoc-rancher`
* Set to branch `master`

# Catalog Entries Summary

## AdHoc Base Stack
Every rancher host that will be running the *AdHoc Odoo Hosting* system needs to have this stack installed.

This stack provides:

* An automated nginx proxy that picks-up new Odoo web and chat ports. Supports Letsencrypt and alternative host names.
* An automated postfix outgoing mail proxy for Odoo instances that supports on stack install relayhost configuration.
* An Aeroo reporting engine container for Odoo PDF reports.
* An automated DNS agent for Google Cloud DNS. This agent creates A records for new Odoo instances. Using the alternative hostname feature external DNS domains are supported. SSL certs for the alternative domains should be able to be placed in the node /etc/letsencrypt config dirs for certbot override.

## AdHoc Simple Odoo Stack
Will create only one db/odoo stack.

This stack provides:

* Odoo container(*1).
* PostgreSQL db container.
* Backup Odoo container.
* PostgreSQL db backup container on different host.

(*1) Uses 2 sidekicks for stack scoped storage for Odoo data and DB data.

# Known Issues

## Postfix
The postfix proxies may need to have different names. Or only one should be active via a loadbalancer at the region level and not at the host level. This requires that the proxies inform all other proxies of mail destination. This requires service discovery probably via a simple DNS SRV record setup.

## Nginx
SSL certs for non LetsEncrypt is handled manually at the node level external to Rancher.

## Base Stack Install

## Reboot Rancher System
You should always start up the rancher cluster by starting the nodes first and then the rancher controller. On shutdown the reverse should be executued: First power off Rancher then the nodes.

In many cases the affintity rules regarding backup Odoo and DB fail on reboot. E.g. the primary and the backup stack parts end up on the same node.

## DNS subsystem
You will need to manually cleanup unused A records in Google Cloud DNS.
