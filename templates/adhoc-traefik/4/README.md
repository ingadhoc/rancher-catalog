## ADHOC Traefik Active Load Balanceer

IMPORTANTE: esta versión no anduvo por algo en como se pasan los certificados. Probamos con la 1.4.3 y no anduvo (la 1.4.4 todavía está no estable). Si llegamos a implementar la idea es unsar rancher.metadata=true y desactivar rancher.api=false

### Configuration Items

Hay que crear volumen externo llamado "secrets"

Por ahora hace falta subir a mano al volumen certificados en /secrets/domain.crt  y /secrets/domain.key
También hay que crear un archivo limpio /secrets/acme.json y ponerle permisos "600"

Para que ande hay que modificar el arranque la primera vez y sacar lo de https, se crea el directorio, se agrega lo anteror y luego se actualiza
