# AdHoc Rancher Catalog
Rancher catalog adhoc-rancher for Odoo ERP Docker based hosting.

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

* An automated nginx proxy that picks-up new Odoo web and chat ports.
* An automated postfix incoming mail proxy for Odoo that supports on stack install relayhost configuration.
* An Aeroo reporting engine container for Odoo PDF reports.
* An automated DNS agent for Google Cloud DNS. This agent creates A records for new Odoo instances.

## AdHoc Simple Odoo Stack

Will create only one db/odoo stack.

This stack provides:

* Odoo container.
* PostgreSQL db container.
* PostgreSQL db backup container on different host.

Uses 2 sidekicks for stack scoped storage for Odoo data and DB data.

# Known Issues

The postfix proxies may need to have different names. Or only one should be active via a loadbalancer at the region level and not at the host level. This requires that the proxies inform all other proxies of mail destination. This requires service discovery probably via a simple DNS SRV record setup.

### Base Stack Install

You must supply a postfix hostname.
If you do not supply the postfix hostname 'hostname -f' fails in the postfix-dockprox container configuration.
