## ADHOC Traefik Active Load Balanceer

### Configuration Items

Hay que crear volumen externo llamado "secrets"

Por ahora hace falta subir a mano al volumen certificados en /secrets/domain.crt  y /secrets/domain.key
También hay que crear un archivo limpio /secrets/acme.json y ponerle permisos "600"

Para que ande hay que modificar el arranque la primera vez y sacar lo de https, se crea el directorio, se agrega lo anteror y luego se actualiza
