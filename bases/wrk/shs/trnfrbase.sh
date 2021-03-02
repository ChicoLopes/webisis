#!/bin/bash

# -------------------------------------------------------------------------- #
# trnfrbase.sh - Processamento de transporte de dados e base de dados CDS/ISIS
# -------------------------------------------------------------------------- #
# PARM1     Nome da base de dados
# PARM2     Destino de transferencia <ADM|INTRA|WEB> se omitido adota ADM
#
# Opcoes de execucao:
#     --changelog        Exibe o historico de alteracoes e para a execucao
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -d, --debug N          Define nivel de depuracao entre 0-256
#     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
# -h, --help             Exibe este texto de ajuda e para a execucao
#     --stop             Libera a verificacao de parada pelo operador com pare ou q
# -V, --version          Exibe a versao corrente e para a execucao
#    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
#     Chamada:           shs/trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2]
#     exemplo:           shs/trnfrbase.sh edi
#                        shs/trnfrbase.sh -d 4 --stop fot Intra
#   Objetivos:           Gravar a base de dados e índice no destino selecionado
# Comentários:           Operação básica descrita a seguir:
#		Le arquivos de configuração e prepara o ambiente de execução
#		Ajusta os parâmetros dos três tipos de destino possíveis (ADM / INTRA / WEB)
#		Se destino for ADM
#		-Garante existência do diretório de destino da base e índice
#		-Copia conjunto de oito arquivos (.mst; .xrf; .cnt; .ifp; .l01; .l02; .n01; .n02) para o destino, a partir o depósito de processamento
#		-Monta relatório com os arquivos resultante no destino
#		Se destino for INTRA ou WEB
#		-Determina se o destino é local ou remoto
#		-Se local
#		 Garante existência do diretório de destino da base e índice via comando direto (mkdir)
#		-Se remoto
#		 Garante existência do diretório de destino da base e índice via comando remoto (ssh mkdir)
#		-Efetua cópia segura (SCP) com usuário e servidor destino conforme arquivo CFG do conjunto de oito arquivos (.mst; .xrf; .cnt; .ifp; .l01; .l02; .n01; .n02) para o destino, a partir o depósito de processamento
#		-Monta relatório com os arquivos resultantes no destino via comando remoto (ssh ls -l)
#		Coloca relatório de execução na pasta relatorios/<PARM1>
#		Elimina o lixinho temporário
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
	- Inclusão de listagem de diretório remoto
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
source	${PRGDIR}/inc/trnfrbase.lddefault.inc
# Incorpora dump de debug
source	${LIBS}/common.debug.inc
# Incorpora HELP e tratador de opcoes
source	${PRGDIR}/inc/trnfrbase.mhelp_opc.inc
source	${PRGDIR}/inc/trnfrbase.debug.inc

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

echo "[${PRGNAM}]  1.01.03.02 - Determina a compilação de CISIS a utilizar com a base de dados"
# Obtem o sabor de CISIS para uso com a base de dados
CISIS_DIR=$(eval "echo "\$$(rdConfig "FLAVOR")"")

echo "[${PRGNAM}]  1.01.03.03 - Determina hostname e caminhos do ADM"
  SERV_ADM=$(rdConfig "HOST_ADM")
   PATH_IN=$(rdConfig "PATH_BASE_IN_")
  PATH_OUT=$(rdConfig "PATH_BASE_ADM")
  USER_ADM=$(rdConfig "USER_ADM")
echo "[${PRGNAM}]  1.01.03.04 - Determina hostname e caminho do INTRANET SERVER"
SERV_INTRA=$(rdConfig "HOST_INTRA")
PATH_INTRA=$(rdConfig "PATH_BASE_INTRA")
USER_INTRA=$(rdConfig "USER_INTRA")
echo "[${PRGNAM}]  1.01.03.05 - Determina hostname e caminho do INTERNET SERVER"
  SERV_WEB=$(rdConfig "HOST_WEB")
  PATH_WEB=$(rdConfig "PATH_BASE_WEB")
  USER_WEB=$(rdConfig "USER_WEB")

echo "[${PRGNAM}]  1.01.03.06 - Configura nome da base de dados para indexação"
# Basename da base de dados entrada do processamento
BASE_IN="${PARM1}"

[ -z ${PARM2} ] && PARM2="ADM"
PARM2=$(echo ${PARM2} | tr [:lower:] [:upper:])
dump_config

# ==== Processamento ====
echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"

echo "[${PRGNAM}]  1.02.01    - Garante disponibilidade de diretório destino"
IP_LOCAL=$(ip -4 addr show | grep inet | cut -d "/" -f "1" | cut -c "10-")
case "${PARM2}" in
	adm | ADM)
		echo "[${PRGNAM}]  1.02.01.01 - Garante disponibilidade de diretório destino na ADM de dados"
		# Garante destino no sistema de administração de dados
		echo "[${PRGNAM}]             - mkdir -p ${PATH_OUT}"
		[ ${FAKE} -eq 0 ] && mkdir -p ${PATH_OUT}
		
		echo "[${PRGNAM}]  1.02.02    - Efetua a copia dos dados para o destino"
		# Efetiva a copia dos dados
		echo "[${PRGNAM}]             - cp ${PARM1}.new/* ${PATH_OUT}"
		[ ${FAKE} -eq 0 ] &&            cp ${PARM1}.new/* ${PATH_OUT} &>> $PATH_REL/$DTISO.trf.${PARM2}.log || true
		[ ${FAKE} -eq 0 ] &&            ls -l ${PATH_OUT} &>> $PATH_REL/$DTISO.trf.${PARM2}.log || true
		# Avalia se a operação funcionou ao contento ou para o processo
		chkError $? "A transferência dos dados falhou!"
		;;

	intra | INTRA)
		# Garante destino no servidor de intranet
		echo $IP_LOCAL | grep "${SERV_INTRA}" > /dev/null
		if [ $? -eq 0 ] || [ $(hostname) = ${SERV_INTRA} ] || [ $(echo "localhost") = ${SERV_INTRA} ] ;  then
			echo "[${PRGNAM}]  1.02.01.01 - Garante disponibilidade de diretório destino na INTRA (localmente)"
			# Se o servidor for o próprio basta criar o diretório destino
			echo "[${PRGNAM}]             - mkdir -p ${PATH_INTRA}"
			[ ${FAKE} -eq 0 ] &&            mkdir -p ${PATH_INTRA} || true
		else
			echo "[${PRGNAM}]  1.02.01.01 - Garante disponibilidade de diretório destino na INTRA (remotamente)"
			# Se o servidor é remoto cria o diretório via SSH
			echo "[${PRGNAM}]             - ssh ${USER_INTRA}@${SERV_INTRA} mkdir -p ${PATH_INTRA}"
			[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} mkdir -p ${PATH_INTRA} || true
		fi
		# Avalia se a operação funcionou ao contento ou para o processo
		chkError $? "Não foi possivel garantir o diretorio destino da INTRANET"

		echo "[${PRGNAM}]  1.02.02    - Efetua a copia dos dados para o destino"
		# Efetiva a copia dos dados
		echo "[${PRGNAM}]             - scp ${PARM1}.new/* ${USER_INTRA}@${SERV_INTRA}:${PATH_INTRA} - ${PATH_REL}/${DTISO}.trf.${PARM2}.log"
		[ ${FAKE} -eq 0 ] &&            scp ${PARM1}.new/* ${USER_INTRA}@${SERV_INTRA}:${PATH_INTRA} &>  ${PATH_REL}/${DTISO}.trf.${PARM2}.log || true
		# Avalia se a operação funcionou ao contento ou para o processo
		chkError $? "A transferência dos dados falhou!"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_INTRA}@${SERV_INTRA} ls -l ${PATH_INTRA}          &>> ${PATH_REL}/${DTISO}.trf.${PARM2}.log || true
		;;

	web | WEB)
		# Garante destino no servidor de internet
		echo $IP_LOCAL | grep "${SERV_WEB}" > /dev/null
		if [ $? -eq 0 ] || [ $(hostname) = ${SERV_WEB} ] || [ $(echo "localhost") = ${SERV_WEB} ] ;  then
			echo "[${PRGNAM}]  1.02.01.01 - Garante disponibilidade de diretório destino na WEB (localmente)"
			# Se o servidor for o próprio basta criar o diretório destino
			echo "[${PRGNAM}]             - mkdir -p ${PATH_WEB}"
			[ ${FAKE} -eq 0 ] &&            mkdir -p ${PATH_WEB} || true
		else
			echo "[${PRGNAM}]  1.02.01.01 - Garante disponibilidade de diretório destino na WEB (remotamente)"
			# Se o servidor é remoto cria o diretório via SSH
			echo "[${PRGNAM}]             - ssh ${USER_WEB}@${SERV_WEB} mkdir -p ${PATH_WEB}"
			[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} mkdir -p ${PATH_WEB} || true
		fi
		# Avalia se a operação funcionou ao contento ou para o processo
		chkError $? "Não foi possivel garantir o diretorio destino da INTRANET"

		echo "[${PRGNAM}]  1.02.02    - Efetua a copia dos dados para o destino"
		# Efetiva a copia dos dados
		echo "[${PRGNAM}]             - scp ${PARM1}.new/* ${USER_WEB}@${SERV_WEB}:${PATH_WEB}"
		[ ${FAKE} -eq 0 ] &&            scp ${PARM1}.new/* ${USER_WEB}@${SERV_WEB}:${PATH_WEB} &>  ${PATH_REL}/${DTISO}.trf.${PARM2}.log || true
		# Avalia se a operação funcionou ao contento ou para o processo
		chkError $? "A transferência dos dados falhou!"
		[ ${FAKE} -eq 0 ] &&            ssh ${USER_WEB}@${SERV_WEB} ls -l ${PATH_WEB}          &>> ${PATH_REL}/${DTISO}.trf.${PARM2}.log || true
		;;
esac

# Movimenta relatório (se houver algum)
echo "[${PRGNAM}]  1.03       - Movimenta relatório de execução"
echo "[${PRGNAM}]             - [ -f ${PATH_REL}/${DTISO}.trf.${PARM2}.log ] && mv ${PATH_REL}/${DTISO}.trf.${PARM2}.log relatorios/${PARM1}"
[ ${FAKE} -eq 0 ] &&       [ -f ${PATH_REL}/${DTISO}.trf.${PARM2}.log ] && mv ${PATH_REL}/${DTISO}.trf.${PARM2}.log relatorios/${PARM1}

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	${LIBS}/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

  trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2]
         onde:
       PARM1           Nome da base de dados
       PARM2           Destino de transferencia <ADM|INTRA|WEB> se omitido adota ADM

      Opções:
     --changelog        Exibe o historico de alteracoes e para a execucao
 -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
 -d, --debug N          Define nivel de depuracao entre 0-256
     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
 -h, --help             Exibe este texto de ajuda e para a execucao
     --stop             Libera a verificacao de parada pelo operador com pare ou q
 -V, --version          Exibe a versao corrente e para a execucao
    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
     Chamada:           shs/trnfrbase.sh [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2]
     exemplo:           shs/trnfrbase.sh edi
                        shs/trnfrbase.sh -d 4 --stop fot Intra
   Objetivos:           Gravar a base de dados e índice no destino selecionado
 Comentários:           Operação básica descrita a seguir:
		Le arquivos de configuração e prepara o ambiente de execução
		Ajusta os parâmetros dos três tipos de destino possíveis (ADM / INTRA / WEB)
		Se destino for ADM
		-Garante existência do diretório de destino da base e índice
		-Copia conjunto de oito arquivos (.mst; .xrf; .cnt; .ifp; .l01; .l02; .n01; .n02) para o destino, a partir o depósito de processamento
		-Monta relatório com os arquivos resultante no destino
		Se destino for INTRA ou WEB
		-Determina se o destino é local ou remoto
		-Se local
		 Garante existência do diretório de destino da base e índice via comando direto (mkdir)
		-Se remoto
		 Garante existência do diretório de destino da base e índice via comando remoto (ssh mkdir)
		-Efetua cópia segura (SCP) com usuário e servidor destino conforme arquivo CFG do conjunto de oito arquivos (.mst; .xrf; .cnt; .ifp; .l01; .l02; .n01; .n02) para o destino, a partir o depósito de processamento
		-Monta relatório com os arquivos resultantes no destino via comando remoto (ssh ls -l)
		Coloca relatório de execução na pasta relatorios/<PARM1>
		Elimina o lixinho temporário
		Fim da tarefa
       Notas:           Deve ser executado como usuário 'isis'
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
20200620 Inclusão de listagem do diretório remoto nas transferências ADM, INTRA e WEB
20200621 Conferência e uniformização de comentários
SPICEDHAM

