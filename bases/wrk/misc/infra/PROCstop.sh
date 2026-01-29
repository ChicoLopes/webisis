#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCstop - Coloca o marcador de processo identificado em estado completo
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#       saida:	${MYSELF}$1 com o estado gravado
# Observacoes:	Apenas marca como completo 

PROCwrite.sh $1 $_COMPLETE_

