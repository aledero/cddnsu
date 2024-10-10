# CDDNSU (Cloudflare Dynamic DNS Updater)
## Actualizador de DNS dinámica en Cloudflare

Licenciado con GPLv3

Este pequeño script permite actualizar un registro tipo A de su preferencia en Cloudflare apuntando a la IP actual del servidor donde se esté ejecutando.

Una vez se ejeucta, crea un fichero con la ultima IP registrada y las siguientes veces, comproborá que coincida con la actual del servidor y, en caso contrario, la actualizará automaticamente. 

Puede crear una tarea programada (cronjob) para que se ejecute cada X horas y así asegurar que esté actualizado siempre.

TODO for v0.2:
- Version en Inglés
- Revisar si son necesarios permisos de root para la ejecución