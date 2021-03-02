#!/bin/bash

# -------------------------------------------------------------------------- #
# publcbase.sh - Publicação de dados e base de dados em servidores
# -------------------------------------------------------------------------- #
# PARM1     Nome da base de dados
# PARM2     Servidor a ter a base publicada <ADM|INTRA|WEB> se omitido adota ADM
#
# Opcoes de execucao:
#     --changelog        Exibe o historico de alteracoes e para a execucao
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -d, --debug N          Define nivel de depuracao entre 0-256
#     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
# -h, --help             Exibe este texto de ajuda e para a execucao
# -r, --rollback         Desfaz a última atualização
#     --stop             Libera a verificacao de parada pelo operador com pare ou q
# -V, --version          Exibe a versao corrente e para a execucao
#    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
#     Chamada:           shs/trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [-r|--rollback] [--stop] <PARM1> [PARM2]
#     exemplo:           shs/trnfrbase.sh edi
#                        shs/trnfrbase.sh -d 4 --stop fot INTRA
#   Objetivos:           Efetivar a publicação/uso da base de dados e índices processados
# Comentários:           Operação básica descrita a seguir:
#		Le arquivos de configuração e prepara o ambiente de execução
#		Determina se é atualização ou rollback
#		Atualização:
#		-Garante disponibilidade dos dados no servidor
#		-Monta em relatório a situação inicial de arquivos do servidor
#		-Renomeia diretório .old temporariamente
#		-Renomeia o diretório corrente para .old
#		-Renomeia o diretório .new para corrente
#		-Elimina o diretório temporário
#		-Garante disponibilidade do diretório para futura base de dados e índice
#		-Monta em relatório a situação final de arquivos do servidor
#		Rollback:
#		-Garante disponibilidade dos dados antigos
#		-Monta em relatório a situação inicial de arquivos do servidor
#		-Elimina diretório .new
#		-Renomeia o diretório corrente para .new
#		-Renomeia 0 diretório .old para corrente
#		-Garante disponibilidade do diretório para futura base de dados e índice desativados
#		-Monta em relatório a situação final de arquivos do servidor
#		Coloca relatório de execução na pasta relatorios/<PARM1>
#		Elimina lixinho temporário
#		Fim da tarefa
# -------------------------------------------------------------------------- #
# QAPLA Comercio e Servicos de Informatica Ltda-ME
# CNPJ: 05.129.080/0001-01          QAPLA (p) 2020
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 20200413, FJLopes
	- Edicao original
vrs:  0.10 20200614, FJLopes
	- Aprimoramentos nas opções de chamada
vrs:  0.11 20200616, FJLopes
	- Correção de diversos erros menores
vrs:  0.20 20200620, FJLopes
	- Inclusão de Rollback
vrs:  0.21 20200621, FJLopes
	- Uniformização de documentação interna
HISTORICO

# ========================================================================== #
# BIBLIOTECAS
# ========================================================================== #
# Incorpora a biblioteca bibliteca
# source	$PATH_EXEC/inc/bibliteca.inc
# A biblioteca conta com as funcoes:
# rdLIV		--	--	Retorna informacoes sobre a biblioteca
# rdVERSION	PARM1	x	Versao do qualquer coisa

# Incorpora a biblioteca de controle basico de processamento
source	${LIBS}/infoini.inc
# A biblioteca conta com as funcoes:
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
# CTSTOP Controle de parada pelo operador (pare<ENTER)
# DEBUG  Nivel de depuracao (default 0)
# FAKE   Flag de execucao falsa (default Off)

# Incorpora funções de manpulação de bases CDS/ISIS comuns
source	${LIBS}/common.CISIS.inc
# Incorpora carregador de valores criticos default
source	${PRGDIR}/inc/publcbase.lddefault.inc
# Incorpora dump de debug
source	${LIBS}/common.debug.inc
source	${PRGDIR}/inc/publcbase.debug.inc
# Incorpora HELP e tratador de opcoes
source	${PRGDIR}/inc/publcbase.mhelp_opc.inc

# Ponto de interrupcao se permitida
rdBreak

# ==== Pre-Processamento ====

# Ajusta nome do arquivo de configuracao de operacao do programa
echo "[${PRGNAM}]  1.01       - Configuração da execução"
echo "[${PRGNAM}]  1.01.01    - Prepara leitura do arquivo de configuração"
if [ ! -z ${CFG_FILE} ] ; then
	# Se foi apontado algum arquivo de configuracao leremos este arquivo
	CONFIG=${CFG_FILE}
	if [ ! -f ${CONFIG} ] ; then
		echo "Arquivo de configuração ${CONFIG} não encontrado. Abortando a execução!"
		# Anota hora de termino e calcula duracao em segundos e humana
		[ ${DEBUG} -ne 0 ] && echo " ==>    -Procedimentos concluídos"
		HRFIM=$(date '+(%w) %F %T');                             # Hora de fim de execucao no formato YYYYMMDD hh:mm:ss
		timemark
		echo "Tempo de execucao de $PRGEXE $LCORI de $HRINI ate $HRFIM = $(printf "%7d" $TPROC)[s] ou $THUMAN"
		echo "[TIME-STAMP] $HRFIM [:FIM:] $PRGEXE $ARG_IN"
		unset TPROC     THUMAN
		# Elimina o registro de numero do processo em execução
		[ -f "${VARS}/run/${PRGNAM}" ] && rm -f ${VARS}/run/${PRGNAM}
		# Sai com código de erro x
		exit 203
	fi
else
	# se existir arquivo default (mesmo nome do programa .cnf)
	if [ -f "${PRGDIR}/inc/${PRGNAM}.cnf" ] ; then
		CONFIG=$(echo "${PRGDIR}/inc/${PRGNAM}.cnf")
	fi
fi
CFG_FILE=${CONFIG}

#echo "CONFIG = $CONFIG"
#echo "CFG_FILE = $CFG_FILE"
#rdBreak

# Le arquivo de configuracao de operacao do programa
if [ ! -z ${CFG_FILE} ] ; then
	# Efetua a leitura do arquivo de configuracao já que não é vazio
	echo "[${PRGNAM}]  1.01.02    - Efetua a leitura do arquivo de configuração"
    CONF_FILE=$(rdConfig "CONF_FILE")
    PATH_REL=$(rdConfig "RELAT_DIR")
fi

echo "[${PRGNAM}]  1.01.03    - Efetua leitura do arquivo de configuração da base de dados"
echo "[${PRGNAM}]  1.01.03.01 - Ajusta o nome do arquivo de configuração de base de dados"
# Le arquivo de configuracao da base para processamento
CONFIG=$(echo "etc/${PARM1}.cfg")
if [ -f ${CONFIG} ] ; then
	CONFIG=${CONFIG}
else
	chkError $? "Arquivo de configuração da base de dados não localizado"
fi

# Ponto de interrupção se permitida
#rdBreak

echo "[${PRGNAM}]  1.01.03.02 - Determina a compilação de CISIS a utilizar com a base de dados"
# Obtem o sabor de CISIS para uso com a base de dados
CISIS_DIR=$(eval "echo "\$$(rdConfig "FLAVOR")"")

echo "[${PRGNAM}]  1.01.03.03 - Determina hostname e caminho do ADMINISTRATIVO"
SERV_ADM=$(rdConfig "HOST_ADM")
PATH_ADM=$(rdConfig "PATH_BASE_ADM")
USER_ADM=$(rdConfig "USER_ADM")
echo "[${PRGNAM}]  1.01.03.04 - Determina hostname e caminho do INTRANET SERVER"
SERV_INTRA=$(rdConfig "HOST_INTRA")
PATH_INTRA=$(rdConfig "PATH_BASE_INTRA")
USER_INTRA=$(rdConfig "USER_INTRA")
echo "[${PRGNAM}]  1.01.03.05 - Determina hostname e caminho do INTERNET SERVER"
  SERV_WEB=$(rdConfig "HOST_WEB")
  PATH_WEB=$(rdConfig "PATH_BASE_WEB")
  USER_WEB=$(rdConfig "USER_WEB")

echo "[${PRGNAM}]  1.01.03.06 - Configura nome da base de dados para publicação"
# Basename da base de dados entrada do processamento
BASE_IN="${PARM1}"

[ -z ${PARM2} ] && PARM2="ADM"
PARM2=$(echo ${PARM2} | tr [:lower:] [:upper:])
dump_config

# ==== Processamento ====
echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"
if [ ${ROLLBK} -eq 0 ] ; then
	# Caminho da publicação
	if [ "${PARM2}" = "ADM" ] || [ "${PARM2}" = "INTRA" ] || [ "${PARM2}" = "WEB" ] ; then
		# Ponto de interrupção se permitida
		rdBreak
	else
		chkError $? "Local a publicar não válido ou indefinido"
	fi

	echo "[${PRGNAM}]  1.02.01    - Garante disponibilidade de diretório destino"
	case "${PARM2}" in

	adm | ADM)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_ADM)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_ADM)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_ADM)"/${PARM1}.new")
		PATH_DIS=$(echo $(dirname $PATH_ADM)"/${PARM1}.older")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na ADMINISTRACAO"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - [ -d ${PATH_ADM} ]"
		                                [ -d ${PATH_ADM} ]
		chkError $? "Diretório não disponível no servidor de ADMINISTRAÇÃO DE DADOS"
		
		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		echo "[${PRGNAM}]             - ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12]  -  ${PATH_REL}/${DTISO}.rot.${PARM2}.log"
		ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log
		
		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Renomeia diretório old para older"
		echo "[${PRGNAM}]             - mv ${PATH_OLD} ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            mv ${PATH_OLD} ${PATH_DIS} 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Transfere dados do diretório corrente para old"
		[ ${FAKE} -eq 0 ] &&            mkdir -p ${PATH_OLD}
		echo "[${PRGNAM}]             - mv ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_OLD}"
		[ ${FAKE} -eq 0 ] &&            mv ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_OLD} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório new para corrente"
		echo "[${PRGNAM}]             - mv ${PATH_NEW}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            mv ${PATH_NEW}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_CUR} || true
		chkError $? "Rotação falhou ao rotacionar o diretório novo!"
		echo "[${PRGNAM}]  1.02.02.04 - Apaga diretório older"
		echo "[${PRGNAM}]             - rm -rf ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            rm -rf ${PATH_DIS} || true
		chkError $? "Rotação falhou ao descartar o diretório mais antigo!"
		echo "[${PRGNAM}]  1.02.02.05 - Prepara receptor para próxima publicação"
		echo "[${PRGNAM}]             - mkdir -p ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            mkdir -p ${PATH_NEW} || true
		chkError $? "Criação do diretório .new falhou!"
		echo "[${PRGNAM}]  1.02.02.06 - Coleta padrão de arquivos depois da rotação"
		echo "[${PRGNAM}]             - ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] - ${PATH_REL}/${DTISO}.rot.${PARM2}.log"
		ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log
		;;

	intra | INTRA)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_INTRA)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_INTRA)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_INTRA)"/${PARM1}.new")
		PATH_DIS=$(echo $(dirname $PATH_INTRA)"/${PARM1}.older")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na INTRANET"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} [ -d ${PATH_INTRA} ]"
		                                ssh ${USER_INTRA}@${SERV_INTRA} [ -d ${PATH_INTRA} ]
		chkError $? "Diretório não disponível no servidor da INTRANET"

		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		ssh ${USER_INTRA}@${SERV_INTRA} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log

		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Renomeia diretório old para older"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_OLD} ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_OLD} ${PATH_DIS} 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Renomeia diretório corrente para old"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_CUR} ${PATH_OLD}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_CUR} ${PATH_OLD} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório new para corrente"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_NEW} ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_NEW} ${PATH_CUR} || true
		chkError $? "Rotação falhou ao rotacionar o diretório novo!"
		echo "[${PRGNAM}]  1.02.02.04 - Apaga diretório older"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} rm -rf ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} rm -rf ${PATH_DIS} || true
		chkError $? "Rotação falhou ao descartar o diretório mais antigo!"
		echo "[${PRGNAM}]  1.02.02.05 - Prepara receptor para próxima publicação"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mkdir -p ${PATH_INTRA}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mkdir -p ${PATH_NEW} || true
		chkError $? "Criação do diretório .new falhou!"

		echo "[${PRGNAM}]  1.02.02.06 - Coleta padrão de arquivos depois da rotação"
		ssh ${USER_INTRA}@${SERV_INTRA} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log
		;;

	web | WEB)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_WEB)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_WEB)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_WEB)"/${PARM1}.new")
		PATH_DIS=$(echo $(dirname $PATH_WEB)"/${PARM1}.older")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na INTERNET"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} [ -d ${PATH_WEB} ]"
		                                ssh ${USER_WEB}@${SERV_WEB} [ -d ${PATH_WEB} ]
		chkError $? "Diretório não disponível no servidor da INTRANET"

		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		ssh ${USER_WEB}@${SERV_WEB} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log

		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Renomeia diretório old para older"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_OLD} ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_OLD} ${PATH_DIS} 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Renomeia diretório corrente para old"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_CUR} ${PATH_OLD}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_CUR} ${PATH_OLD} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório new para corrente"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_NEW} ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_NEW} ${PATH_CUR} || true
		chkError $? "Rotação falhou ao rotacionar o diretório novo!"
		echo "[${PRGNAM}]  1.02.02.04 - Apaga diretório older"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} rm -rf ${PATH_DIS}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} rm -rf ${PATH_DIS} || true
		chkError $? "Rotação falhou ao descartar o diretório mais antigo!"
		echo "[${PRGNAM}]  1.02.02.05 - Prepara receptor para próxima publicação"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mkdir -p ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mkdir -p ${PATH_NEW} || true
		chkError $? "Criação do diretório .new falhou!"

		echo "[${PRGNAM}]  1.02.02.06 - Coleta padrão de arquivos depois da rotação"
		ssh ${USER_WEB}@${SERV_WEB} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.rot.${PARM2}.log
		;;
	esac

else

	# Caminho do ROLLBACK
	if [ "${PARM2}" = "ADM" ] || [ "${PARM2}" = "INTRA" ] || [ "${PARM2}" = "WEB" ] ; then
		# Ponto de interrupção se permitida
		rdBreak
	else
		chkError $? "Local a despublicar não válido ou indefinido"
	fi

	echo "[${PRGNAM}]  1.02.01    - Garante disponibilidade de diretório destino"
	case "${PARM2}" in

	adm | ADM)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_ADM)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_ADM)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_ADM)"/${PARM1}.new")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na ADMINISTRACAO"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - [ -d ${PATH_OLD} ]"
		                                [ -d ${PATH_OLD} ]
		chkError $? "Diretório não disponível no servidor de ADMINISTRAÇÂO DE DADOS para efetuar o rollback"
		
		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		echo "[${PRGNAM}]             - ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] - ${PATH_REL}/${DTISO}.desrot.${PARM2}.log"
		ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log
		
		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Elimina diretório NEW caso exista"
		echo "[${PRGNAM}]             - rm -rf ${PATH_NEW}/*"
		[ ${FAKE} -eq 0 ] &&            rm -rf ${PATH_NEW}/* 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Renomeia diretório corrente para new"
		echo "[${PRGNAM}]             - mv ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            mv ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_NEW} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório old para corrente"
		echo "[${PRGNAM}]             - mv ${PATH_OLD}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            mv ${PATH_OLD}/${PARM1}.[mxciln][srnf0][tfp12] ${PATH_CUR} || true
		chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.04 - Coleta padrão de arquivos depois da rotação"
		echo "[${PRGNAM}]             - ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] - ${PATH_REL}/${DTISO}.desrot.${PARM2}.log"
		ls -l ${PATH_CUR}/${PARM1}.[mxciln][srnf0][tfp12] &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log
		;;

	intra | INTRA)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_INTRA)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_INTRA)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_INTRA)"/${PARM1}.new")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na INTRANET"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} [ -d ${PATH_OLD} ]"
		                                ssh ${USER_INTRA}@${SERV_INTRA} [ -d ${PATH_OLD} ]
		chkError $? "Diretório não disponível no servidor da INTRANET para efetuar o rollback"

		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		ssh ${USER_INTRA}@${SERV_INTRA} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log

		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Elimina diretorio NEW caso exista"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} rm -rf ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} rm -rf ${PATH_NEW} 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Renomeia diretório corrente para new"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_CUR} ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_CUR} ${PATH_NEW} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório old para corrente"
		echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_OLD} ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mv ${PATH_OLD} ${PATH_CUR} || true
		#[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mkdir -p ${PATH_OLD}
		chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.04 - Coleta padrão de arquivos depois da rotação"
		ssh ${USER_INTRA}@${SERV_INTRA} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log
		;;

	web | WEB)
		echo "[${PRGNAM}]  1.02.01.01 - Determina participantes da rotação de diretórios"
		# Atores da rotação de diretorios
		PATH_OLD=$(echo $(dirname $PATH_WEB)"/${PARM1}.old")
		PATH_CUR=$(echo $(dirname $PATH_WEB)"/${PARM1}")
		PATH_NEW=$(echo $(dirname $PATH_WEB)"/${PARM1}.new")
		# Garante destino no servidor de intranet
		echo "[${PRGNAM}]  1.02.01.02 - Garante disponibilidade de diretório na INTERNET"
		# Avalia se a operação funcionou ao contento ou para o processo
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} [ -d ${PATH_OLD} ]"
		                                ssh ${USER_WEB}@${SERV_WEB} [ -d ${PATH_OLD} ]
		chkError $? "Diretório não disponível no servidor da INTRANET para efetuar o rollback"

		echo "[${PRGNAM}]  1.02.01.03 - Coleta padrão de arquivos antes da rotação"
		ssh ${USER_WEB}@${SERV_WEB} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log

		echo "[${PRGNAM}]  1.02.02    - Efetua a rotação de diretórios"
		echo "[${PRGNAM}]  1.02.02.01 - Elimina diretrio New caso exista"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} rm -rf ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} rm -rf ${PATH_NEW} 2> /dev/null || true
		#chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.02 - Renomeia diretório corrente para new"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_CUR} ${PATH_NEW}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_CUR} ${PATH_NEW} || true
		chkError $? "Rotação falhou ao rotacionar o diretório corrente!"
		echo "[${PRGNAM}]  1.02.02.03 - Renomeia diretório old para corrente"
		echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_OLD} ${PATH_CUR}"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mv ${PATH_OLD} ${PATH_CUR} || true
		chkError $? "Rotação falhou ao rotacionar o diretório antigo!"
		echo "[${PRGNAM}]  1.02.02.06 - Coleta padrão de arquivos depois da rotação"
		ssh ${USER_WEB}@${SERV_WEB} ls -l ${PATH_CUR} &>> ${PATH_REL}/${DTISO}.desrot.${PARM2}.log
		;;
	esac
fi
# Movimenta relatório (se houver algum)
echo "[${PRGNAM}]  1.03       - Movimenta relatório de execução"
echo "[${PRGNAM}]             - [ -f ${PATH_REL}/${DTISO}.rot.${PARM2}.log ] && mv ${PATH_REL}/${DTISO}.rot.${PARM2}.log relatorios/${PARM1}"
[ ${FAKE} -eq 0 ] &&       [ -f ${PATH_REL}/${DTISO}.rot.${PARM2}.log ]    && mv ${PATH_REL}/${DTISO}.rot.${PARM2}.log    relatorios/${PARM1}
[ ${FAKE} -eq 0 ] &&       [ -f ${PATH_REL}/${DTISO}.desrot.${PARM2}.log ] && mv ${PATH_REL}/${DTISO}.desrot.${PARM2}.log relatorios/${PARM1}

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	${LIBS}/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

  trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [-r|--rollback] [--stop] <PARM1> [PARM2]
         onde:
       PARM1            Nome da base de dados
       PARM2            Servidor a ter a base publicada <ADM|INTRA|WEB> se omitido adota ADM

      Opções:
     --changelog        Exibe o historico de alteracoes e para a execucao
 -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
 -d, --debug N          Define nivel de depuracao entre 0-256
     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
 -h, --help             Exibe este texto de ajuda e para a execucao
 -r, --rollback         Desfaz a última atualização
     --stop             Libera a verificacao de parada pelo operador com pare ou q
 -V, --version          Exibe a versao corrente e para a execucao
    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
     Chamada:           shs/trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [-r|--rollback] [--stop] <PARM1> [PARM2]
     exemplo:           shs/trnfrbase.sh edi
                        shs/trnfrbase.sh -d 4 --stop fot INTRA
   Objetivos:           Efetivar a publicação/uso da base de dados e índices processados
 Comentários:           Operação básica descrita a seguir:
		Le arquivos de configuração e prepara o ambiente de execução
		Determina se é atualização ou rollback
		Atualização:
		-Garante disponibilidade dos dados no servidor
		-Monta em relatório a situação inicial de arquivos do servidor
		-Renomeia diretório .old temporariamente
		-Renomeia o diretório corrente para .old
		-Renomeia o diretório .new para corrente
		-Elimina o diretório temporário
		-Garante disponibilidade do diretório para futura base de dados e índice
		-Monta em relatório a situação final de arquivos do servidor
		Rollback:
		-Garante disponibilidade dos dados antigos
		-Monta em relatório a situação inicial de arquivos do servidor
		-Elimina diretório .new
		-Renomeia o diretório corrente para .new
		-Renomeia 0 diretório .old para corrente
		-Garante disponibilidade do diretório para futura base de dados e índice desativados
		-Monta em relatório a situação final de arquivos do servidor
		Coloca relatório de execução na pasta relatorios/<PARM1>
		Elimina lixinho temporário
		Fim da tarefa
  Observacoes:          O usuario 'isis' em seu profile ajus       Notas:           Deve ser executado como usuário 'isis'
 Observações:           O usuário 'isis' em seu profile ajusta o caminho de busca de executáveis, incluindo $LIBS e $INFRA
                        DEBUG é uma variável mista de valor e mapeada por bit conforme:
				          valores de 0 a 7 definem a profundidade de detalhamento da depuração
                          _BIT3_  Modo debug de linha -v
                          _BIT4_  Modo debug de linha -x
                          _BIT5_  (vago)
                          _BIT6_  (vago)
                          _BIT7_  Opera em modo FAKE
Dependências:           Variáveis de ambiente previamente ajustadas
                  Símbolos previamente definidos criados na instalação
                      Criador    Criatura   Descricao breve
                    profil_env    QAPLA     Local de instalação do pacote de software
                    profil_env    INFRA     Local de rotinas comuns de infraestrutura
                    profil_here    LIBS     Local das bibliotecas utilizadas nos processamentos
                    profil_here    VARS     Local para variáveis sistêmicas de suporte
                    profil_here    CRON     Local das rotinas para execução sob crontab
                    profil_here  _BIT0_     Constante máscara do bit 0
                    profil_here  _BIT1_     Constante máscara do bit 1
                    profil_here  _BIT2_     Constante máscara do bit 2
                    profil_here  _BIT3_     Constante máscara do bit 3
                    profil_here  _BIT4_     Constante máscara do bit 4
                    profil_here  _BIT5_     Constante máscara do bit 5
                    profil_here  _BIT6_     Constante máscara do bit 6
                    profil_here  _BIT7_     Constante maácara do bit 7
                    profil_isis  TABS       Tabelas do CISIS (valid char & upper/lower case)
                    profil_isis  GIZMOS     Arquivos fonte para criação de gizmos
                    profil_isis  BASES      Bases de dados ISO-3166 e ISO-639
                    profil_isis  ISIS       Local do pacote CISIS compilação 1030
                    profil_isis  ISISG      Local do pacote CISIS compilação 1030 Giga base
                    profil_isis  BIGISIS    Local do pacote CISIS compilação BigIsis (16/256)
                    profil_isis  ISIS1660   Local do pacote CISIS compilação 1660
                    profil_isis  FFI1660    Local do pacote CISIS compilação FFI 1660
                    profil_isis  LIND       Local do pacote CISIS compilação FFI 1660
                    profil_isis  LINDG4     Local do pacote CISIS compilação FFI 1660
                    profil_isis  FFI        Local do pacote CISIS compilação FFI 1660
                    profil_isis  FFIG4      Local do pacote CISIS compilação FFI 1660
                    profil_isis  LIND512    Local do pacote CISIS compilação FFI 1660
                    profil_isis  LIND512G4  Local do pacote CISIS compilação FFI 1660
                    profil_isis  FFI512     Local do pacote CISIS compilação FFI 1660
                    profil_isis  FFI512G4   Local do pacote CISIS compilação FFI 1660
    wish list:	1- .

COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200313 Versão e edição originais do processamento de bases de dados
20200616 Correção de falhas na semântica de comandos bash
20200620 Inclusão da função Rollback
20200621 Conferência e uniformização de comentários
SPICEDHAM

