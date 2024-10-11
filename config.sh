#!/bin/bash

#######################
### CONFIGURACIONES ###
#######################

## NO es necesario modificar WEB_OBTENER_IP ya que deberia servirle y estar funcional 

# Web para saber nuestra IP
WEB_OBTENER_IP="ifconfig.me/ip"

#######################

## SI es necesario que utilice su ruta de usuario y datos de su cuenta de Cloudflare aquí  
# No está permitido utilizar los valores por defecto que se muestran a continuación

# Fichero donde almacenaremos nuestra ultima IP asociada a la DNS 
# Ej: "/home/USER/cddnsu_latest_ip.txt" (cambiando USER por su nombre de usuario)
FICHERO_IP=""

## Aquí debe descomponer la dns que quiere que apunte al servidor
# Ej: miserver.midominio.com

# CF_DNS_ZONE es el dominio de cloudflare 
# Ej: "midominio.com"
CF_DNS_ZONE=""

# CF_DNS_RECORD es el registro que se quiere actualizar (debe ser un registro A y sin protección)
# Ej: "miserver"
CF_DNS_RECORD=""

## Aquí debe escribir la clave de Cloudflare para realizar modificaciones por API a su dominio
# Credenciales de Cloudflare (API KEY)
# Ej: "AAAAAAAAAA0000000000aaaaaaaaaa1111111111"
CF_AUTH_API_KEY=""