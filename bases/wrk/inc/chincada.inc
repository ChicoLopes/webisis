# -------------------------------------------------------------------------- #
# Biblioteca de funcoes de trap

# Lista de funcoes
cat > /dev/null <<COMMENT
	clean_term	armadilha do sinal 15 (SIGTERM)	morte "branca"
	clean_hup	armadilha do sinal  1 (SIGHUP)	Processo de controle morreu
	clean_int	armadilha do sinal  2 (SIGINT)	Interrupcao via teclado (CTRL-C)
	clean_kill	armadilha do sinal  9 (SIGKILL)	morte "negra"
	clean_exit	armadilha do sinal  0 (SIGEXIT)	fim normal de processo
	clean_up	armadilha demais sinais 	
	leF		Efetua a leitura do FLAG de profundidade
	contaF		Adiciona um nivel ao FLAG de profundidade
	descontaF	Desconta um nivel do FLAG de profundidade
	resetF		Reinicia o FLAG de profundidade

Comentarios gerais:

       Signal     Value     Action   Comment
       ──────────────────────────────────────────────────────────────────────
       SIGHUP        1       Term    Hangup detected on controlling terminal
                                     or death of controlling process
       SIGINT        2       Term    Interrupt from keyboard
       SIGQUIT       3       Core    Quit from keyboard
       SIGILL        4       Core    Illegal Instruction
       SIGABRT       6       Core    Abort signal from abort(3)
       SIGFPE        8       Core    Floating point exception
       SIGKILL       9       Term    Kill signal
       SIGSEGV      11       Core    Invalid memory reference
       SIGPIPE      13       Term    Broken pipe: write to pipe with no
                                     readers
       SIGALRM      14       Term    Timer signal from alarm(2)
       SIGTERM      15       Term    Termination signal
       SIGUSR1   30,10,16    Term    User-defined signal 1
       SIGUSR2   31,12,17    Term    User-defined signal 2
       SIGCHLD   20,17,18    Ign     Child stopped or terminated
       SIGCONT   19,18,25    Cont    Continue if stopped
       SIGSTOP   17,19,23    Stop    Stop process
       SIGTSTP   18,20,24    Stop    Stop typed at tty
       SIGTTIN   21,21,26    Stop    tty input for background process
       SIGTTOU   22,22,27    Stop    tty output for background process

       The signals SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.

COMMENT

# Armadilha para o sinal 15 (SIGTERM)
clean_term() {
	#[ -f "$1" ] && FLAG=$(cat $1)
	#FLAG=$(expr $FLAG - 1)
	#echo $FLAG > $1
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
        echo "         x.xx.xx.xx -Execucao terminada por SIGKILL"
        exit
}

# Armadilha para  sinal 0 (SIGEXIT)
clean_exit() {
        [ -f "$1" ] && FLAG=$(cat $1)
        FLAG=$(expr $FLAG - 1)
	[ $FLAG -lt 0 ] && echo "         x.xx.xx.xx -Execucao terminada anormalmente"
	[ $FLAG -eq 0 ] && echo "         x.xx.xx.xx -Execucao terminada normalmente"
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

