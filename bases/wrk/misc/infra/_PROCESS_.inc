# SIMBOLOS E CONTROLES COMUNS DE PROCESSOS

#		VALOR     BIT
export    _DUMMY_=0
export  _RUNNING_=1	# 1 execucao
export    _ERROR_=2	# 2 erro
export _COMPLETE_=4	# 3 completamento
export  _ABORTED_=8	# 4 interrompido
export    _ABORT_=16	# 5 ABORTAR
export	_STOPPED_=32	# 6 parada
			# 8 -

# Funcoes de controle de processo disponiveis em $PROCS
# ------------------------------------------------------------------------- #
#     Arquivo : PROCread - Leitura de status de processo
# PARAMETRO 1 : identificacao do processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCwrite - Escrita de status de processo
# PARAMETRO 1 : identificacao do processo
# PARAMETRO 2 : estado a ser assumido pelo processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCassume - Assume um estado
# PARAMETRO 1 : identificacao do processo
# PARAMETRO 2 : estado a ser incorporado pelo processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROClibera - Libera estado de processo
# PARAMETRO 1 : identificacao do processo
# PARAMETRO 2 : estado a ser liberado no processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCinic - Inicializa processo
# PARAMETRO 1 : identificacao do processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCstart - Dispara processo
# PARAMETRO 1 : identificacao do processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCstop - Finda execucao de processo
# PARAMETRO 1 : identificacao do processo
#
# ------------------------------------------------------------------------- #
#     Arquivo : PROCcrack - Quebra processamento (termino com erro)
# PARAMETRO 1 : identificacao do processo
#
