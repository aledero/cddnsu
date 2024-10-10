#!/bin/bash

### CONFIGURACIONES ###

## NO es necesario tocar WEB_OBTENER_IP o FICHERO_IP ya que deberian servirle 
# Web para saber nuestra IP
WEB_OBTENER_IP="ifconfig.me/ip"
# Fichero donde almacenaremos nuestra ultima IP asociada a la DNS
FICHERO_IP="/home/cddnsu_latest_ip.txt"

## SI es necesario que utilice sus datos de su cuenta de cloudflare en las siguientes configuraciones (Ej: miserver.midominio.com)
# CF_DNS_ZONE es el dominio de cloudflare (Ej: midominio.com)
CF_DNS_ZONE="DOMINIO"
# CF_DNS_RECORD es el registro que se quiere actualizar (debe ser un registro A y sin protección) (Ej: miserver)
CF_DNS_RECORD="REGISTRODNS"
# Credenciales de Cloudflare (API KEY)
CF_AUTH_API_KEY="CLOUDFLAREAPIKEY"