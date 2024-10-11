# CDDNSU (Cloudflare Dynamic DNS Updater)
## Actualizador de DNS dinámica en Cloudflare

Licenciado con GPLv3

Este pequeño script permite actualizar un registro tipo A de su preferencia en Cloudflare apuntando a la IP actual del servidor donde se esté ejecutando.

Una vez se ejeucta, crea un fichero con la ultima IP registrada y las siguientes veces, comproborá que coincida con la actual del servidor y, en caso contrario, la actualizará automaticamente. 

### Pasos:
1. Copiar cddnsu.sh y config.sh al servidor/equipo donde se requiera
2. Actualizar permisos a 777 en ambos ficheros: chmod 777 cddnsu.sh config.sh
3. Actualizar config.sh con sus propios datos
4. Ejecutar cddnsu.sh: ./cddnsu.sh
5. (OPCIONAL) Puede crear una tarea programada (crontab -e) para que se ejecute cada hora y 
así asegurar que esté actualizado siempre: 0 * * * * /home/USER/cddnsu.sh

### Screenshots:
```
################################################################################
#                 CDDNSU (Cloudflare Dynamic DNS Updater) v0.2 ES              #
################################################################################


CDDNSU (Cloudflare Dynamic DNS Updater) Copyright © 2024 Alejandro Delgado Rodrguez (aledero) - www.aledero.com
This program comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type 'show c' for details.


Bienvenido a / Welcome to CDDNSU (Cloudflare Dynamic DNS Updater) v0.2 ES

[INFO] Sistemas operativos validos / Valid SOs: Debian Based OS

[INFO] Importando variables de configuración...

[SUCCESS] Se han obtenido correctamente los valores requiridos de configuración

[INFO] Obteniendo IP publica actual...
[SUCCESS] Tu IP pública actual es: 0.0.0.0
[INFO] Comprobando si el script se ha ejecutado previamente...

[INFO] Es la primera vez que se ejecuta (o al menos no hemos encontrado el fichro de IP)

[INFO] Comenzamos el procedimiento...

[INFO] Actualizando IP en Cloudflare

[SUCCESS] Se ha obtenido correctamente la id temporal de la zona (0a0a0a0a0a0a0a0a0a00a0a0a0a0a0a0a0a0)

[SUCCESS] Se ha obtenido correctamente la id temporal del registro DNS (0b0b0b0b0b00b0b0b0b0b0b0b0b0b00b0b0bb00)

[SUCCESS] IP actualizada en Cloudflare correctamente
[INFO] Actualizando IP en el fichero /home/USER/cddnsu_latest_ip.txt

[INFO] Fichero actualizado correctamente


¡Muchas Gracias por usar CDDNSU (Cloudflare Dynamic DNS Updater)!
```

### TODO for v0.3:
- Version en Inglés
- Arreglar error que permite valores de cloudflare irreales