## ADHOC Grafana Monitoring

IMPORTANTE: Antes de hacer el deploy crear los volumenes para el storage.

Luego del deploy hacer lo siguiente:
* Configurar data source con:
    * name: influxDB
    * type: influxDB
    * url: http://influxdb:8086
    * database: telegraf
    * user: admin
    * password: admin
* Create a dashboard and load from json stored on "dashboard" folder
