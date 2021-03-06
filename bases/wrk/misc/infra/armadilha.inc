# -------------------------------------------------------------------------- #
# Biblioteca de funcoes de trap
# Conta com as funcoes:
#  clean_term   PARM1   Trata interrupcao por SIGTERM	Termina execucao de forma controlada
#  clean_hup    PARM1   Trata interrupcao por SIGHUP	Reinicia programa
#  clean_int    PARM1   Trata interrupcao por SIGINT	Interrompe a execucao (tipo CTRL-C)
#  clean_kill   PARM1   Trata interrupcao por SIGKILL	Termino forcado de execucao
#  clean_exit   PARM1   Trata interrupcao por SIGEXIT	
#		PARM1	Trata interrupcao por SIGSTOP	Interrompe suspende (tipo ctrl-Z)
#  clean_up     PARM1   Trata os demais sinais
#  leF          PARM1   Le nivel corrente do flag
#  contaF       PARM1   Sobe um nivel de execucao
#  descontaF    PARM1   Desce um nivel de execucao
#  resetF       PARM1   Limpa nivel de execucao

# Armadilha para o sinal 15 (SIGTERM)
clean_term() {
	#[ -f "$1" ] && FLAG=$(cat $1)
	#FLAG=$(expr $FLAG - 1)
	#echo $FLAG > $1
	[ -f "$MISC/runs/$TRNAM.pid" ] && rm -f $MISC/runs/$TRNAM.pid
	echo "         x.xx.xx.xx -Execucao terminada por SIGTERM"
	exit
}

# Armadilha para o sinal 1 (SIGHUP)
clean_hup() {
	#[ -f "$1" ] && FLAG=$(cat $1)
	#FLAG=$(expr $FLAG - 1)
	#echo $FLAG > $1
	echo "         x.xx.xx.xx -Execucao terminada por SIGHUP"
	exit
}

# Armadilha para o sinal 2 (SIGINT)
clean_int() {
        #[ -f "$1" ] && FLAG=$(cat $1)
        #FLAG=$(expr $FLAG - 1)
        #echo $FLAG > $1
        echo "         x.xx.xx.xx -Execucao terminada por SIGINT"
        exit
}

# Armadilha para o sinal 9 (SIGKILL)
clean_kill() {
        [ -f "$1" ] && FLAG=$(cat $1)
        FLAG=$(expr $FLAG - 1)
        echo $FLAG > $1
	[ -f "$MISC/runs/$TRNAM.pid" ] && rm -f $MISC/runs/$TRNAM.pid
        echo "         x.xx.xx.xx -Execucao terminada por SIGKILL"
        exit
}

# Armadilha para  sinal 0 (SIGEXIT)
clean_exit() {
        [ -f "$1" ] && FLAG=$(cat $1)
        FLAG=$(expr $FLAG - 1)
	[ $FLAG -lt 0 ] && echo "         x.xx.xx.xx -Execucao terminada anormalmente"
	[ $FLAG -eq 0 ] && echo "         x.xx.xx.xx -Execucao terminada normalmente"
	# Pode ou nao ja ter sido morto, depende de como chegou ao fim, com ou sem erro
	[ -f "$MISC/runs/$TRNAM.pid" ] && rm -f $MISC/runs/$TRNAM.pid
        echo $FLAG > $1
        exit
}

# Armadilha para os demais sinais
clean_up() {
        [ -f "$1" ] && FLAG=$(cat $1)
        FLAG=$(expr $FLAG - 1)
        echo $FLAG > $1
        echo "         x.xx.xx.xx -Recebido um sinal X"
        exit
}

# Le nivel atual do FLAG
#	Correcao de erro: --
leF() {
	[ -f "$1" ] || FLAG=0
	[ -f "$1" ] && FLAG=$(cat $1)
}

# Conta mais um nivel em FLAG
#	Correcao de erro: falta do arquivo do flag
contaF() {
	[ -f "$1" ] || FLAG=0
	[ -f "$1" ] && FLAG=$(cat $1)
	FLAG=$(expr $FLAG + 1)
	echo $FLAG > $1
}

# Desconta um nivel de FLAG
#	Correcao de erro: valor negativo de flag
descontaF() {
	[ -f "$1" ] && FLAG=$(cat $1)
	FLAG=$(expr $FLAG - 1)
	[ $FLAG -lt 0 ] && FLAG=0
	echo $FLAG > $1
}

# Reset do FLAG
#	Correcao de erro: falta do arquivo do flag
resetF() {
	FLAG=0
	echo $FLAG > $1
}

