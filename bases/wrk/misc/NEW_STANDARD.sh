#!/bin/bash

# -------------------------------------------------------------------------- #
# readSCIs.sh - Le SciELOs disponiveis                                       #
# -------------------------------------------------------------------------- #
#    Corrente :	/bases/orgG4
#     Chamada :	readSCIs.sh [-h|-V|--changelog] [-d N] <PARM1>
#     Exemplo :	nohup shel/readSCIs.sh &> logs/20140416.rSCIs.txt &
# Objetivo(s) :	1- Fazer isso
#		2- Fazer aquilo
#  IMPORTANTE :	deve ser executado com user do grupo operacao
# -------------------------------------------------------------------------- #
#   Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde
#      é um centro especialidado da Organização Pan-Americana da Saúde,
#            escritório regional da Organização Mundial da Saúde
#                       BIREME / OPS / OMS (P)2014-15
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#       - Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 YYYYMMDD, FJLopes
	- Edicao original
HISTORICO
# ========================================================================== #
#                                BIBLIOTECAS                                 #
# ========================================================================== #
# Incorpora biblioteca de controle de multiprocessamento
source	$MISC/infra/_PROCESS_.inc
# Conta com as funcoes:
#	PROCread	processID		Le status do processo
#	PROCwrite	processID novoEstado	Escreve status do processo
#	PROCassume	processID Estado	Assume status
#	PROClibera	processID Estado	Libera status
#	PROCinic	processID		Inicializa processo
#	PROCstart	processID		Dispara processo
#	PROCstop	processID		Finda processo
#	PROCcrack	processID		Quebra processamento
#	PROCfreeze	processID		Para execucao		(nao implementado)
#	PROCunfreeze	processID		Retoma execucao		(nao implementado)
# Define as constantes (de estado):
#	NOME		BIT
#	_DUMMY_
#	_RUNNING_	1	execucao
#	_ERROR_		2	erro
#	_COMPLETE_	3	completado
#	_ABORTED_	4	interrompido
#	_ABORT_		5	ABORTAR
#	_STOPPED_	6	parada

# Incorpora biblioteca de captura de sinais
source	$MISC/infra/armadilha.inc
# Conta com as funcoes:
#	clean_EXIT	Armadilha para o termino normal de processo
#	clean_KILL	Armadilha para o sinal KILL
#	leF		Le FLAG indicado
#	contaF		Soma um nivel ao FLAG indicado
#	descontaF	Subtrai um nivel ao FLAG indicado
#	resetF		Reinicia FLAG indicado
	
# Incorpora biblioteca de controle basico de processamento
source	$MISC/infra/infoini.inc
# Conta com as funcoes:
#	isNumber  PARM1	; Testa se eh numero
#	rdConfig  PARM1	; Le item no arquivo de configuracao 
#	rdBreak   -	; Le teclado por interrupcao de execucao
#	chkError  PARM1	; Testa condicao de erro e exibe mensagem
# Ajusta as variaveis:
#	HINIC	; Tempo inicial (em segundo desde 19700101
#	HRINI	; Hora inicial  (desde 19700101)
#	_DOW_	; Dia da semana (0-domingo)
#	_DIA_	; Dia do mes
#	_MES_	; Mes do ano
#	_ANO_	; Ano (com 4 algarismos)
#	DTISO	; Data no formato YYYY-MM-DD
#	TREXE	; Nome do programa (script)
#	TRNAM	; Nome sem extensao
#	PRGDR	; Path para o programa em execucao
#	LCORI	; Linha de comando original
#	N_DEB	; Nivel de DEBUG
#	FAKE	; Operacao em modo fake (qdo = 1)

source	VALORES_DEFAULT.inc
	# Subsistema de envio de e-mail
	EMAILSRV="esmeralda.bireme.br"
	EMAILFRM="scieloorg@bireme.org"
	ASSUNTO="Leitura de SciELOs ativos"
	MENSAGEM="Termino de teste"
	PARA="francisco.lopes@bireme.org"
	COMCOPIA="baba@bireme.org"
	ANEXO="baba.txt"
source	TRATA_OPCOES_E_HELP.inc

# -------------------------------------------------------------------------- #
# Pede controle de processo
[ -d $MISC/runs ] || mkdir -p $MISC/runs
echo $$ > $MISC/runs/$TRNAM.pid
# -------------------------------------------------------------------------- #
# Controle de antireentrancia

# Poderia usar a denominacao "$TRNAM.flg"
F_FLAG="$HOME/nome_flag.flg"
leF $F_FLAG;	# Carrega valor atual da profundidade de execucao
[ $N_DEB -gt 0 ] && echo "[explo]  0.00.00.00- Arquivo de flag: $F_FLAG contendo: $FLAG"

# Verifica se o valor autoriza a execucao
if [ $FLAG -gt 0 ]; then
	echo
	echo "[explo]  0.00.00.00- Execucao não autorizada pela pre-existencia de outra igual."
	echo
	# Envia e-mail sinalizando que encavalou o processo
	exit 128
fi

# Conta mais uma execucao
contaF $F_FLAG
[ $N_DEB -gt 0 ] && echo "[explo]  0.00.00.00- Arquivo de flag: $F_FLAG agora com: $FLAG"

# Liga armadilha de interrupcao de execucao (e desconto de FLAG)
trap "[ -f $F_FLAG ] && FLAG=$(< $F_FLAG) && FLAG=$(expr $FLAG - 1) && echo $FLAG > $F_FLAG" 0 1 2 3 9 15
# --------------------------------------------------------------------------- #
# ----- #
# DEBUG #
# ----- #
rdBreak
# ----- #
# --------------------------------------------------------------------------- #

# Subsistema de envio de e-mail
# Usando a solucao do ITI
echo "Simulando um anexo" > $ANEXO
# sendemail -f "$EMAILFRM" -s "$EMAILSRV" -u "$ASSUNTO" -m "$MENSAGEM" -t "$PARA" -cc "$COMCOPIA" -a "$ANEXO" >> logs/seila.txt
  sendemail -f "$EMAILFRM" -s "$EMAILSRV" -u "$ASSUNTO" -m "$MENSAGEM" -t "$PARA"                 -a "$ANEXO" >> logs/seila.txt
[ -f $ANEXO ] && rm -f $ANEXO
#
echo "[BLABLA]  1         - Texto de inicio"

# Variaveis que se nao iniciadas assumem valores default
while [ ${QMDL:-0} -ge ${MAXPARALELO:-8} ]
do
	sleep 1
done
#
echo "Geracao de XML de termino de processamento com:
	Hora de inicio, hora de fim, e duracao
	Chamada da Linha de Comando"
#
echo "[BLABLA]  n         - Texto de fim"

# Usando recursos do Java na solucao do Vinicius
TEXTO=texto.txt
echo $MENSSAGEM > $TEXTO
echo "Simulando um anexo" > $ANEXO
java -jar $PATH_EXEC/EnviadorDeEmail.jar -to "$PARA" -subject "$ASSUNTO" -messagefile "$TEXTO" -attach "$ANEXO" >> logs/seila.txt
[ -f $ANEXO ] && rm -f $ANEXO
[ -f $TEXTO ] && rm -f $TEXTO
unset TEXTO
#
echo "Tratamento de FLAGs de tarefa liberada (+log BIREME)"

# Se pediu registro de processo tem de apaga-lo
[ -f "$MISC/runs/$TRNAM.pid" ] && rm -f $MISC/runs/$TRNAM.pid
source $MISC/infra/infofim.inc
exit
# --------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

     Entrada :	Parametros e arquivos de entrada do shell
		Opcoes de execucao:
		 --changelog           Mostra historico de alteracoes
		 -d N, --debug N       Nivel de depuracao
		 -h, --help            Mostra o help
		 -V, --version         Mostra a versao
       Saida :	Saidas geradas pelo shell
    Corrente :	diretorio corrente para inicio de execucao
     Chamada :	path/Shell_name.sh opcoes parm1 parm2 parm3 parm4 ...
     Exemplo :	Linha de comando exemplo de chamada
 Objetivo(s) :	Gerar contagem, lista ou qqr coisa
 Comentarios :	Todo e qualquer comentario sobre algoritmo, metodos,
		 descricao de arquivos e etc.
 Observacoes :	DEBUG eh uma variavel mapeada por bit conforme
		_BIT0_	Aguarda tecla <ENTER>
		_BIT1_	Mostra mensagens de DEBUG
		_BIT2_	Modo verboso
		_BIT3_	Modo debug de linha -v
		_BIT4_	Modo debug de linha -x
		_BIT7_	Execucao FAKE
       Notas :	Especificacao de usuario para execucao
Dependencias :	Relacoes de dependencia para execucao, como arquivos
		auxiliares esperados, estrutura de diretorios, etc.
		NECESSARIAMENTE entre o servidor de trigramas e esta maquina
		deve haver uma CHAVE PUBLICA DE AUTENTICACAO, de forma que
		seja dispensada a interacao com operador para os processos
		de transferencia de arquivos.
		Variaveis de ambiente que devem estar previamente ajustadas:
		geral	    BIREME - Path para o diretorio com especificos de BIREME
		geral	      CRON - Path para o diretorio com rotinas de crontab
		geral	      MISC - Path para o diretorio de miscelaneas de BIREME
		geral	     PROCS - Path para as subrotinas de processamento tradicionais
		geral	      TABS - Path para as tabelas de uso geral da BIREME
		geral	  TRANSFER - Usuario para troca arquivos entre servidores
		geral	    _BIT0_ - 00000001b
		geral	    _BIT1_ - 00000010b
		geral	    _BIT2_ - 00000100b
		geral	    _BIT3_ - 00001000b
		geral	    _BIT4_ - 00010000b
		geral	    _BIT5_ - 00100000b
		geral	    _BIT6_ - 01000000b
		geral	    _BIT7_ - 10000000b
		geral	MDL_ANOCORRENTE2DIGITOS - Ano corrente para efeito de processamento
		geral	MDL_ANOCORRENTE4DIGITOS - Ano corrente para efeito de processamento
		geral	   MDL_BASELINE2DIGITOS - Lista de anos do Medline
		geral	   MDL_BASELINE4DIGITOS - Lista de anos do Medline
		iAHx	     ADMIN - e-mail ofi@bireme.br
		iAHx	 PATH_IAHX - Path para o cerne de iAHx
		iAHx	 PATH_EXEC - Path para os executaveis gerais de iAHx
		iAHx	PATH_INPUT - Path para o deposito de entrada do iAHx
		iAHx	INDEX_ROOT - Path para o topo da arvore de indices de iAHx
		iAHx	 PATH_PROC - Path para a raiz de processamento iAHx
		iAHx	SHiAHx    SRVHOM - Nome do servidor de homologacao de iAHx
		iAHx	SPiAHx    SRVPRC - Nome do servidor de producao do iAHx
		iAHx	STiAHx    SRVTST - Nome do servidor de teste do iAHx
		ISIS	      ISIS - WXISI      - Path para pacote CISIS compilado em 10/30 normal
		ISIS	  ISIS1660 - WXIS1660   - Path para pacote CISIS compilado em 16/60 normal
		ISIS	     ISISG - WXISG      - Path para pacote CISIS compilado em 10/30 BIG-FILES
		ISIS	      LIND - WXISL      - Path para pacote CISIS compilado em Lind 16/10 normal
		ISIS	   LIND512 - WXISL512   - Path para pacote CISIS compilado em Lind 16/512 normal
		ISIS	    LINDG4 - WXISLG4    - Path para pacote CISIS compilado em Lind 16/60 BIG-FILES 4G registros
		ISIS	 LIND512G4 - WXISL512G4 - Path para pacote CISIS compilado em Lind 16/512 BIG-FILES 4G registros
		ISIS	       FFI - WXISF      - Path para pacote CISIS compilado em FFI Lind 16/60
		ISIS	   FFI1660 - WXISF1660  - Path para pacote CISIS compilado em FFI 16/60
		ISIS	    FFI512 - WXISF512   - Path para pacote CISIS compilado em FFI Lind 16/512
		ISIS	     FFIG4 - WXISFG4    - Path para pacote CISIS compilado em FFI Lind 16/60 BIG-FILES 4G registros
		ISIS	    FFI4G4 - WXISF4G4   - Path para pacote CISIS compilado em FFI 4M Lind 16/60 BIG-FILES 4G registros
		ISIS	    FFI256 - WXISF256   - Path para pacote CISIS compilado em FFI 16/256 BIG-FILES
		ISIS	  FFI512G4 - WXISF512G4 - Path para pacote CISIS compilado em FFI Lind 16/512 BIG-FILES 4G registros
COMMENT
# --------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
YYYYMMDD Bla blablabla blab la blablab la bla blabla.
SPICEDHAM

