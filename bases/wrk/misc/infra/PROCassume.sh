#!/bin/bash

# ------------------------------------------------------------------------- #
# PROCassume - Agrega um estado em um marcador de processo identificado
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#		PARM2- Estado a ser assumido
#       saida:	${MYSELF}$1 com o novo estado gravado
# Observacoes:	Estado validos para assuncao:
#			$_RUNNING_  - em execucao
#			$_ERROR_    - erro detectado
#			$_COMPLETE_ - tarefa finda de forma normal
#			$_ABORTED_  - tarefa interrompida externamente
#			$_ABORT_    - solicitacao de interrupcao
#		O novo estado passa por um OR com o estado corrente no
#		marcador de processo indicado e eh entao gravado

PROCwrite.sh $1 $(expr $(PROCread.sh $1) + $2)

