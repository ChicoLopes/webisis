#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCinic - Inicializa o marcador de processo indicado
# ------------------------------------------------------------------------- #
#     entrada:  PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#       saida:  ${MYSELF}$1 com o estado nulo (em verdade dummy)
# Observacoes:  Estado usado na assuncao:
#                       $_DUMMY_  - sem validade
#               O novo estado eh gravado no marcador de processo indicado


PROCwrite.sh $1 $_DUMMY_

