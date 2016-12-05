# AdHoc Odoo Hosting for Rancher

Use this catalog to host AdHoc Odoo services.

To use this, do the following:

* Go to the admin tab, then click on settings
* In the catalog section, click "Add Catalog"
* In the Name box, enter `AdHoc`
* In the URL box, enter `https://github.com/unxs0/rancher`

Contact us at soporte@adhoc.com.ar if you have any questions.
Stay informed via [Adhoc News](http://news.adhoc.com.ar)

# Catalog Entries Summary

## AdHoc Base Stack

Every rancher host that will be running the *AdHoc Odoo Hosting* system needs to have this stack installed.

This stack provides:

* An automated nginx proxy that picks-up new Odoo web and chat ports.
* An Aeroo reporting engine container for Odoo PDF reports.

Planned additions:

* Automated mail gateway container for */opt/odoo/openerp_mailgate.py* Odoo port 1921 mail.

## AdHoc Simple Odoo Stack

Will create only one db/odoo stack.

This stack provides:

* Odoo container.
* PostgreSQL db container.

## AdHoc Multiple Odoo Stack

Will create three db/odoo stacks for a given customer:
* Production stack
* Train stack
* Test stack

This stack provides the same services as the *Simple Odoo Stack* but times 3 as mentioned above.
