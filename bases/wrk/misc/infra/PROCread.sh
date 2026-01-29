#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCread - Le o estado em um marcador de processo identificado
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#       saida:	estado lido em ${MYSELF}$1
# Observacoes:	O estado lido eh escrito em standard-out  
#

cat $PATHPRD/${MYSELF}$1

