#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCwrite - Grava estado em um marcador de processo identificado
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#		PARM2- Estado a ser gravado
#       saida:	${MYSELF}$1 com o novo estado gravado
# Observacoes:	Estado validos para gravacao:
#			$_DUMMY_    - simulacao para inicializacao
#			$_RUNNING_  - em execucao
#			$_ERROR_    - erro detectado
#			$_COMPLETE_ - tarefa finda de forma normal
#			$_ABORTED_  - tarefa interrompida externamente
#			$_ABORT_    - solicitacao de interrupcao

echo $2 > $PATHPRD/${MYSELF}$1

