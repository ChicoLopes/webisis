#!/bin/bash
# ------------------------------------------------------------------------- #
# PROCstart - Coloca em execucao no marcador de processo identificado
# ------------------------------------------------------------------------- #
#     entrada:	PARM1- Identificador de processo (sem o prefixo em $MYSELF)
#       saida:	${MYSELF}$1 com o novo estado gravado
# Observacoes:	Se estiver marcado para ABORTAR nao coloca em execucao
#		Completo e abortado eh um estado nao valido

MEUSTS=$(PROCread.sh $1)
if [ $(($MEUSTS & $_ABORT_)) -eq $_ABORT_ ]; then
	PROCwrite.sh $1 $(expr $(($MEUSTS & $_ERROR_)) + $_ABORTED_)
	TPR="fatal"
	MSG="SILLBORN"
	source $PRGDR/logging
else
	if [ $(($MEUSTS & $_RUNNING_)) -eq 0 ]; then
		if [ $(($MEUSTS & $_COMPLETE_)) -eq $_COMPLETE_ ] && [ $(($MEUSTS & $_ABORTED_)) -eq $_ABORTED_ ]; then
			exit
		else
			PROCwrite.sh $1 $_RUNNING_
		fi
	else
		exit
	fi
fi
