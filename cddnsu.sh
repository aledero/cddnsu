#!/bin/bash

# LICENCIA:
#
#    CDDNSU (Cloudflare Dynamic DNS Updater) 
#    Copyright © 2024 Alejandro Delgado Rodriguez - www.aledero.com
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# INFORMACIÓN DEL SCRIPT
NOMBRE_SCRIPT="CDDNSU (Cloudflare Dynamic DNS Updater)"
AUTOR_SCRIPT="Alejandro Delgado Rodriguez (aledero)"
WEB_AUTOR_SCRIPT="www.aledero.com"
VERSION_SCRIPT="v0.2"
IDIOMA_SCRIPT="ES"
SO_VALIDOS="Debian Based OS"
COPYRIGHT_INFO="2024 $AUTOR_SCRIPT - $WEB_AUTOR_SCRIPT"

# MENSAJE DE BIENVENIDA
clear
echo "#################################################################################"
echo "#                 $NOMBRE_SCRIPT $VERSION_SCRIPT $IDIOMA_SCRIPT               #"
echo "#################################################################################"
echo ""
echo "
$NOMBRE_SCRIPT Copyright © $COPYRIGHT_INFO
This program comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type 'show c' for details.
"
echo ""
echo "Bienvenido a / Welcome to $NOMBRE_SCRIPT $VERSION_SCRIPT $IDIOMA_SCRIPT"
echo ""
echo "[INFO] Sistemas operativos validos / Valid SOs: $SO_VALIDOS"
echo ""

# SALIENDO
function closeScript(){
echo "Saliendo..."
echo ""
exit 1
}

# FINAL
function finaltotal(){
echo ""
echo "¡Muchas Gracias por usar $NOMBRE_SCRIPT!"
echo ""
}

# ERROR AL ACTUALIZAR IPS
function errorUpdateIP(){
    echo "[ERROR] Se ha producido un error y no se puede continuar."
    echo "[INFO] No se han actualizado las IPs"
    closeScript
}

# IMPORTAMOS LAS VARIABLES DE CONFIGURACIÓN
echo "[INFO] Importando variables de configuración..."
source ./config.sh
if [ -z "$WEB_OBTENER_IP" ] || [ -z "$FICHERO_IP" ] || [ -z "$CF_DNS_ZONE" ] || [ -z "$CF_DNS_RECORD" ] || [ -z "$CF_AUTH_API_KEY" ] 
then
   echo ""
   echo "[ERROR] No se han obtenido correctamente los valores requiridos de configuración o no se ha especificado algun valor requerido"
   closeScript
fi
echo ""
echo "[SUCCESS] Se han obtenido correctamente los valores requiridos de configuración"

# TRAE IP ACTUAL
echo ""
echo "[INFO] Obteniendo IP publica actual..."
IP_ACTUAL=$(curl -s $WEB_OBTENER_IP)
if [ $? -eq 0 ] 
then
    echo "[SUCCESS] Tu IP pública actual es: $IP_ACTUAL"
else
    echo "[ERROR] No hemos podido obtener tu IP actual"
   closeScript
fi

# ACTUALIZA IP EN EL FICHERO
function updateIPFile(){
echo "[INFO] Actualizando IP en el fichero $FICHERO_IP"
echo "$IP_ACTUAL" > $FICHERO_IP
if grep -q "$IP_ACTUAL" "$FICHERO_IP" 
then
    echo ""
    echo "[INFO] Fichero actualizado correctamente"
    echo ""
    finaltotal
else 
    echo ""
    echo "[ERROR] No se ha podido actualizar el fichero local!"
    echo "[INFO] ¡IMPORTANTE! Actualice manualmente el contenido del fichero $FICHERO_IP con la IP actual:"
    echo "$IP_ACTUAL"
    echo ""
    echo "[INFO] Si no lo hace, la proxima vez que se ejecute se volverá a intentar actualizar tanto en Cloudflare como en el fichero local"
    finaltotal
fi
}

# ACTUALIZA IP EN CLOUDFLARE
function updateIPCloudflare(){
CF_INT_FULLRECORD="$CF_DNS_RECORD.$CF_DNS_ZONE"
echo ""
echo "[INFO] Actualizando IP en Cloudflare"
# get the zone id for the requested zone
CF_INT_ZONEID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$CF_DNS_ZONE&status=active" \
    -H "Authorization: Bearer $CF_AUTH_API_KEY" \
    -H "Content-Type:application/json" | jq -r '{"result"}[] | .[0] | .id')

if [ -z "$CF_INT_ZONEID" ] 
then
    echo ""
    echo "[ERROR] No hemos podido obtener la id temporal de la zona"
    errorUpdateIP
fi
echo ""
echo "[SUCCESS] Se ha obtenido correctamente la id temporal de la zona ($CF_INT_ZONEID)"

# get the dns record id
CF_INT_RECORDID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_INT_ZONEID/dns_records?type=A&name=$CF_INT_FULLRECORD" \
    -H "Authorization: Bearer $CF_AUTH_API_KEY" \
    -H "Content-Type:application/json" | jq -r '{"result"}[] | .[0] | .id')

if [ -z "$CF_INT_RECORDID" ] 
then
    echo ""
    echo "[ERROR] No hemos podido obtener la id temporal del registro DNS"
    errorUpdateIP
fi
echo ""
echo "[SUCCESS] Se ha obtenido correctamente la id temporal del registro DNS ($CF_INT_RECORDID)"

# update the record
CF_INT_UPDATE_RES=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_INT_ZONEID/dns_records/$CF_INT_RECORDID" \
    -H "Authorization: Bearer $CF_AUTH_API_KEY" \
    -H "Content-Type:application/json" \
    --data "{\"id\":\"$CF_INT_RECORDID\",\"type\":\"A\",\"name\":\"$CF_INT_FULLRECORD\",\"content\":\"$IP_ACTUAL\",\"ttl\":3600,\"proxied\":false}" | jq -r '.result | .content' )

if [ -z "$CF_INT_UPDATE_RES" ] 
then
    echo ""
    echo "[ERROR] No hemos podido actualizar la IP en Cloudflare ($CF_INT_UPDATE_RES != $IP_ACTUAL)"
    errorUpdateIP
fi
echo ""
echo "[SUCCESS] IP actualizada en Cloudflare correctamente"
}

# ACTUALIZA IP
function updateIP(){
updateIPCloudflare
updateIPFile
}

# COMPROBAR SI LA IP ESTÁ ACTUALIZADA
function checkSameIP(){
echo "[INFO] Comprobando si es necesario actualizar la IP..."
if grep -q "$IP_ACTUAL" "$FICHERO_IP"  
then
    echo ""
    echo "[SUCCESS] Tu IP pública actual está actualizada!"
    echo "[INFO] Aquí no hay nada más que hacer"
    closeScript
else
    echo ""
    echo "[INFO] La IP almacenada no coincide con la IP publica actual!"
    echo ""
    echo "[INFO] Actualizamos la IP antigua con la actual..."
    updateIP
fi
}

# COMPROBANDO SI YA SE HA EJECUTADO EL SCRIPT CON ANTERIORIDAD
echo "[INFO] Comprobando si el script se ha ejecutado previamente..."
if [ -f $FICHERO_IP ] 
then
    echo ""
    echo "[INFO] No es la primera vez que se ejecuta"
    echo ""
    checkSameIP
else 
    echo ""
    echo "[INFO] Es la primera vez que se ejecuta (o al menos no hemos encontrado el fichero de IP)"
    echo ""
    echo "[INFO] Comenzamos el procedimiento..."
    updateIP
fi

exit 0

# CDDNSU Copyright © 2024 AlexDR15