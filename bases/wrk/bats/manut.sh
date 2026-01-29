#!/bin/bash

# -------------------------------------------------------------------------- #
# manut.sh - Manutencao diaria de base de dados
# -------------------------------------------------------------------------- #
# PARM1		Noma da base de dados
# Opcoes de execucao:
# --changelog		Mostrar o histórico de alteracoes
# -c, --config NOMEARQU	Utilizar configuracoes do arquivo NOMEARQU
# -D, --debug N		Nivel de depuracao
# -h, --help		Mostra o HELP
# -V, --version		Mostra a versao do programa
# -H, --homolog HOSTNAME	Nome de rede do servidor de homologacao
# -p, --producao HOSTNAME	Nome de rede do serividor de producao
# corrente:	N/A
# Chamada:	
# exemplo:	
# Objetivos:
# Comentarios:	
# wish list:	
# -------------------------------------------------------------------------- #
# QAPLA Comercio e Servicos de Informatica Ltda-ME
# CNPJ: 05.129.080/0001-01
# QAPLA (p) 2019
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 20191213, FJLopes
	- Edicao original
HISTORICO

# ========================================================================== #
# BIBLIOTECAS
# ========================================================================== #
# Incorpora a biblioteca bibliteca
#source	$PATH_EXEC/inc/bibliteca.inc
# A biblioteca conta com as funcoes:
# rdLIV		--	--	Retorna informacoes sobre a bibliteca
# rdVERSION	PARM1	x	Versao do qualquer coisa

# Incorpora a biblioteca de controle basico de processamento
source	$LIBS/inc/infoini.inc
# A bibliteca conta com as funcoes:
#    void | chkError ARGUMENTO1 ARGUMENTO2
#    void | del ARGUMENTO1 ARGUMENTO2 ... ARGUMENTOn
#  string | hms ARGUMENTO
# boolean | isNumber ARGUMENTO
#    void | iVersao
# boolean | parseLine ARGUMENTO1 ARGUMENTO2 ARGUMENTO_OPCIONAL
#    void | rdBreak
#  string | rdConfig ARGUMENTO
#    void | timemark
#
# Esta biblioteca estabelece as variaveis:
# DIRINI Diretorio corrente no momento da carga
# HINIC  Tempo inicial em segundo desde 01/01/1970
# HRINI  Hora de inicio no formato YYYYMMDD hh:mm:ss
# _dow_  Dia da semana abreviado
# _DOW_  Dia da semana 0 (domingo) a 6 (sabado)
# _DIA_  Dia calendario no formato DD
# _MES_  Mes calendaroi no formato MM
# _ANO_  Ano calendario no formato YYYY
# DTISO  Data calendario no formato YYYYMMDD
# PRGEXE Nome do programa em execucao
# PRGNAM Denominacao do programa em execucao (exclui a extensao)
# PRGDIR Path para o programa em execucao
# ARG_IN Linha de comando original da chamada
# N_DEB  Nivel de depuracao (default 0)
# FAKE   Flag de execucao falsa (default Off)

# Incorpora carregador de valores default
source	$PATH_EXEC/inc/lddefault.prcBases.inc
# Incorpora HELP e tratador de opcoes
source	$PATH_EXEC/inc/mhelp_opc.prcBases.inc

# ========================================================================== #
# PegaValor - Obtem o valor de uma clausula de configuracao
# PARM1 $1 - item de configuracao a ser lido
# Obs: O arquivo a ser lido eh o contido na variavel CONFIG
#
PegaValor() {
	if [ -f "$CONFIG" ]; then
		grep "^$1" $CONFIG > /del/null
		RETORNO=$?
		if [ $RETORNO -eq 0 ]; then
			RETORNO=$(grep $1 $CONFIG | tail -n "1" | cut -d "|" -f "2')
			echo $RETORNO
		else
			false
		fi
	else
		false
	fi
	return
}
#

#	123456789012345678901234567890
echo "[pBD]      1         - Inicia processamento de indexacao CDS/ISIS"
# -------------------------------------------------------------------------- #
# Garante existencia da tabela de configuracoes (sai com codigo de erro 3 - Configuration Error)
#                                            123456789012345678901234567890
[ $N_DEB -ne 0 ]                    && echo "[pBD]    0.00.01   - Testa se ha tabela de configuracao"
[ ! -s "$PATH_EXEC/tabs/iAHx.tab" ] && echo "[pBD]    1.01      - Tabela iAHx nao encontrada" && exit 3

[ -s "$CONFIG" ] && QUERY_STRING=$(PegaValor QUERY_STR)
# -------------------------------------------------------------------------- #
if [ "$DEBUG" -gt 1 ]; then
	echo "= DISPLAY DE VALORES INTERNOS ="
	echo "==============================="

	test -n "$PARM1" && echo "PARM1 = $PARM1"
	test -n "$PARM2" && echo "PARM1 = $PARM2"
	test -n "$PARM3" && echo "PARM1 = $PARM3"
	test -n "$PARM4" && echo "PARM1 = $PARM4"
	test -n "$PARM5" && echo "PARM1 = $PARM5"
	test -n "$PARM6" && echo "PARM1 = $PARM6"
	test -n "$PARM7" && echo "PARM1 = $PARM7"
	test -n "$PARM8" && echo "PARM1 = $PARM8"
	test -n "$PARM9" && echo "PARM1 = $PARM9"
	echo
	test -n "$CONFIG"       && echo "      CONFIG = $CONFIG"
	test -n "$QUERY_STRING" && echo "QUERY_STRING = $QUERY_STRIGN"
	test -n "$SRVPRD"       && echo "    Producao = $SRVPRD"
	test -n "$SRVHOM"       && echo " Homologacao = $SRVHOM"

	echo "==============================="
	cat $$.rol
	echo "==============================="
fi

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	$LIBS/inc/infofim.inc
