#!/bin/bash
# ------------------------------------------------------------------------- #
# PROClibera - Perde um estado em um marcador de processo identificado
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#		PARM2- Estado a ser liberado
#       saida:	${MYSELF}$1 sem o estado gravado
# Observacoes:	Estado validos para liberacao:
#			$_RUNNING_  - em execucao
#			$_ERROR_    - erro detectado
#			$_COMPLETE_ - tarefa finda de forma normal
#			$_ABORTED_  - tarefa interrompida externamente
#			$_ABORT_    - solicitacao de interrupcao
#		O inverso do estado passa por um NAND com o estado corrente
#		no marcador de processo indicado e eh entao gravado

PROCwrite.sh $1 $(expr $(($((~ $2)) & $(PROCread.sh $1))))

