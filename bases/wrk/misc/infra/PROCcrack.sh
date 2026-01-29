#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCcrack - Coloca processo em termino com erro
# ------------------------------------------------------------------------- #
#     entrada:  PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#       saida:  ${MYSELF}$1 com o estado completo e com erro
# Observacoes:  Estado usado na assuncao:
#                       $_ERROR_    - erro detectado
#                       $_COMPLETE_ - tarefa finda de forma normal
#               O novo estado eh gravado no marcador de processo indicado


PROCwrite.sh $1 $(expr $_COMPLETE_ + $_ERROR_)

