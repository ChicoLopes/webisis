#!/bin/bash

# -------------------------------------------------------------------------- #
# indexbase.sh - Processamento para indexação de base de dados CDS/ISIS
# -------------------------------------------------------------------------- #
# PARM1		Nome da base de dados
#
# Opcoes de execucao:
#     --asc850           Utiliza o conjunto de caracteres ASCII CP850
#     --ansi_N           Utiliza o conjunto de caracteres ANSI com números
#     --ansi_X           Utiliza o conjunto de caracteres ANSI extendido
#     --ansi_U           Utiliza o conjunto de caracteres ANSI ultra-extendido
#     --changelog        Exibe o historico de alteracoes e para a execucao
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -d, --debug N          Define nivel de depuracao entre 0-256
# -e, --erro             Ignora detecção de erros de processamento
#     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
#     --fst NOMEARQU     Utiliza FST alternativa contido no arquivo NOMEARQU
#     ++fst NOMEARQU     Utiliza FST alternativa contido no arquivo NOMEARQU gerando um índice com o nome de NOMEARQU
# -h, --help             Exibe este texto de ajuda e para a execucao
#     --nostw            Ignora o arquivo de Stop Word se presente
#     --stop             Libera a verificacao de parada pelo operador com pare ou q
# -V, --version          Exibe a versao corrente e para a execucao
# -w, --web              Indexação para publicação na Web
#    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
#     Chamada:           shs/indexbase.sh [-h|-V|--changelog] [-c|--config NOMEARQU] [-d N] [-e|--erro] [--fake] [--fst|++fst NOMEARQU] [--nostw] [--stop] [-w|--web] <PARM1>
#     exemplo:           shs/indexbase.sh edi
#                        shs/indexbase.sh -d 4 --stop fot
#   Objetivos:           Gerar índice (invertido) da base de dados conforme FST default ou indicada
# Comentários:           Operação básica descrita a seguir:
#		Le arquivos de configuração e prepara o ambiente de execução
#		Apaga índice caso exista
#		Verifica disponibilidade de insumos: Base, FST e STW
#		Efetua a indexação da base
#		Coloca base e indice no diretório próprio de saída (conforme CFG, por padrão PATH_BASE_ADM)
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
vrs:  0.12 20200620, FJLopes
    - Correção da função dump_previas
vrs:  0.13 20200621, FJLopes
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
source	${PRGDIR}/inc/indexbase.lddefault.inc
# Incorpora dump de debug
source	${LIBS}/common.debug.inc
source	${PRGDIR}/inc/indexbase.debug.inc
# Incorpora HELP e tratador de opcoes
source	${PRGDIR}/inc/indexbase.mhelp_opc.inc

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
if [ ! -z ${CONFIG} ] ; then
	# Efetua a leitura do arquivo de configuracao ja que ele não é vazio
	echo "[${PRGNAM}]  1.01.02    - Efetua a leitura do arquivo de configuração"
    CONF_FILE=$(rdConfig "CONF_FILE")
    PATH_REL=$(rdConfig "RELAT_DIR")
fi

echo "[${PRGNAM}]  1.01.03    - Efetua leitura do arquivo de configuração da base de dados"
echo "[${PRGNAM}]  1.01.03.01 - Ajusta o nome do arquivo de configuração de base de dados"
# Le arquivo de configuracao da base para processamento
CONFIG=$(echo "etc/${PARM1}.cfg")

echo "[${PRGNAM}]  1.01.03.02 - Determina a compilação de CISIS a utilizar com a base de dados"
# Obtem o sabor de CISIS para uso com a base de dados
CISIS_DIR=$(eval "echo "\$$(rdConfig "FLAVOR")"")

echo "[${PRGNAM}]  1.01.03.03 - Determina diretório para o resultado do processamento"
# Determina diretorio para depositar resultado do processamento com base no destino administrativo
PATH_OUT=$(echo $(basename =$(rdConfig "PATH_BASE_ADM")))

echo "[${PRGNAM}]  1.01.03.04 - Configura nome da base de dados para indexação"
# Basename da base de dados entrada do processamento
BASE_IN="${PARM1}"

echo "[${PRGNAM}]  1.01.03.05 - Determina Tabela de Seleção de Campos a utilizar na indexação"
# Ajusta nome do índice de saída com base no flag BASEFST
if [ ${BASEFST} -eq 1 ] ; then
	BASE_OUT=$(echo ${FST} | cut -d "." -f "1")
else
	BASE_OUT=${PARM1}
fi
echo "[${PRGNAM}]  1.01.03.06 - Determina se utiliza arquivo de Stop Words na indexação"
# Ajusta uso de arquivos Stop Words co base no flag NOSTW
if [ ${NOSTW} -eq 1 ] ; then
	STW=""
else 
	[ ${WEB} -eq 0 ] && STW="fsts/${PARM1}.stw" || STW="fsts/${PARM1}.web.stw"
fi
echo "[${PRGNAM}]  1.01.03.07 - Ajusta nome da Tabela de Seleção de Campos a utilizar na indexação"
# Ajusta nome da tabela de seleção de campos. Se já estava definido permanece o nome corrente
if [ -z "${FST}" ] ; then
	[ ${WEB} -eq 1 ] && FST="fsts/${PARM1}.web.fst" || FST="fsts/${PARM1}.fst"
fi
[ ${DEBUG} -gt 0 ] && echo -e "\nFST a utilizar definida ... FST: ${FST}"
dump_config

# ==== Processamento ====
echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"
echo "[${PRGNAM}]  1.02.01    - Garante existência de diretório para uso temporário"
mkdir -p ${PATH_REL}				# Garante existência do diretorio para os rascunhos

echo "[${PRGNAM}]  1.02.02    - Garante existencia de diretório para o resultado do processamento"
[ ${FAKE} -eq 0 ] && mkdir -p ${PATH_OUT}

echo "[${PRGNAM}]  1.02.03    - Elimina índice antigo se houver"
[ ${FAKE} -eq 0 ] && del ${PATH_OUT}/${PARM1}.*	# Se não é processamento fake apaga base no destino (se houver)

# Verifica condicoes de processamento
echo "[${PRGNAM}]  2          - Processamento efetivo da base de dados"
echo "[${PRGNAM}]  2.01       - Verifica condições de processamento"

# Testa se a base esta disponivel
echo "[${PRGNAM}]  2.01.01    - Verifica disponibilidade da base de dados"
BASE_INok=$( ([[ -f "${BASE_IN}.xrf" ]] && [[  -f "${BASE_IN}.mst" ]]) && echo TRUE || echo FALSE )
# Verifica disponibilidade de fst e stw
echo "[${PRGNAM}]  2.01.02    - Verifica disponibilidade da fst a ser utilizada"
FST_ok=$( [[ -f "${FST}" ]] && echo TRUE || echo FALSE )

echo "[${PRGNAM}]  2.01.03    - Verifica disponibilidade do Stop Words administrativo (webisis)"
STW_ok=$( [[ -f "${STW}" ]] && echo TRUE || echo FALSE )
dump_previas

# Ponto de interrupcao se permitida
rdBreak

echo "[${PRGNAM}]  2.01.04    - Avalia se tem condições de operação"
if [ ${BASE_INok} = "TRUE" ] && [ ${FST_ok} = "TRUE" ] || [ ${NOERRO} -eq 1 ]; then
	echo "[${PRGNAM}]  2.01.04.01 - Condições mínimas de operação ok!"
	# Temos a base, temos a FST; Isso é mínimo. STW é um incremento
else
	echo "[${PRGNAM}]  2.01.04.01 - Não reune as condições mínimas de operação, aborta execução"
	echo "[${PRGNAM}]             - BASE_INok: ${BASE_INok}"
	echo "[${PRGNAM}]             -    FST_ok: ${FST_ok}"
	echo "*** FAIL +++ Não pode prosseguir por falta de algum elemento fundamental ***"
	HRFIM=$(date '+(%w) %F %T');                    # Hora de fim de execucao no formato YYYYMMDD hh:mm:ss
	timemark
	echo "Tempo de execucao de $PRGEXE $LCORI de $HRINI ate $HRFIM = $(printf "%7d" $TPROC)[s] ou $THUMAN"
	echo "[TIME-STAMP] $HRFIM [:FIM:] $PRGEXE $ARG_IN"
	# Limpa ambiente de execucao
	[ -f "${VARS}/run/${PRGNAM}" ] && rm -f ${VARS}/run/${PRGNAM}
	exit 201
	# BUG presente a ser estudado futuramente a chamada abaixo não funciona e desequilibra o fonte (algo fecha o que não abriu)
	# chkError FALSE "Não reune as condições mínimas de operação, aborta execução"
fi

if [ ${STW_ok} = "TRUE" ] ; then
	# Condição acessoria -I alcancada
	echo "[${PRGNAM}]  2.01.05.02 - Condições plenas de operação para processamento administrativo ok!"
else
	STW=""
	echo "*** WARNING +++ Não operará em condições plenas, falta o arquivo Stop Words administrativo ***"
fi

# Ponto de interrupção se permitida
rdBreak

# Efetua a indexação da base de dados conforme a parmetrização coletada
echo "[${PRGNAM}]  2.02       - Promove a indexação da base para administração de dados"
echo "[${PRGNAM}]  2.02.01    - Determina quantidade de registros na base de dados"
# determina a quantidade de registros da base de dados e determina o fator de tell
[ ${FAKE} -eq 0 ] && qtderegs=$(qregs ${BASE_IN} ${CISIS_DIR})

echo "[${PRGNAM}]  2.02.02    - Estipula o fator de TELL em funcao do tamanho da base em registros"
# Fator de tell é detrminado por faixas 1000 / 10000 / >10000
if [ ${qtderegs:-0} -lt 1001 ] ; then
	TELLFAC=100
else
	if [ ${qtderegs:-0} -lt 10001 ] ; then
		TELLFAC=1000
	else
		TELLFAC=2500
	fi
fi

echo "[${PRGNAM}]  2.02.03    - Ajusta parametros de chamada do MX"
FST=\"fst=@$FST\"
[ ! -z "${STW}" ] && STW=\"stw=@$STW\"

# Separa segmento do relatorio de execução
#              1         2         3         4         5         6         7         8
#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "=============================================================================="             >> $PATH_REL/$DTISO.inv.log
echo "Processamento de indexação da base de dados ${PARM1} do dia: $HRINI"                        >> $PATH_REL/$DTISO.inv.log
echo "Qtde de registros na base de dados: ${qtderegs}"                                            >> $PATH_REL/$DTISO.inv.log
echo "Indexação executada com o comando a seguir:"                                                >> $PATH_REL/$DTISO.inv.log
echo "- ${CISIS_DIR}/mx ${BASE_IN} ${FST} ${STW} ${CHARSET} fullinv=${BASE_OUT} tell=0${TELLFAC}" >> $PATH_REL/$DTISO.inv.log
echo "=============================================================================="             >> $PATH_REL/$DTISO.inv.log

echo "[${PRGNAM}]  2.02.04    - Efetiva a indexação da base de dados"
[ ${DEBUG} -gt 1 ] && echo "[${PRGNAM}]             - ${CISIS_DIR}/mx ${BASE_IN} ${FST} ${STW} ${CHARSET} fullinv=${BASE_OUT} tell=0${TELLFAC}"
[ ${FAKE} -eq 0 ] &&            ${CISIS_DIR}/mx ${BASE_IN} ${FST} ${STW} ${CHARSET} fullinv=${BASE_OUT} tell=0${TELLFAC} &>> $PATH_REL/$DTISO.inv.log

# Coloca o resultado da indexação no diretório destino
##### Movimentação de M/F e I/F para diretorio destino primário, coloca relatorio no diretorio de "relatorios"	<===
echo "[${PRGNAM}]  2.03       - Transfere base e indice para a area de administração de dados"
[ ${DEBUG} -gt 1 ] && echo "[${PRGNAM}]             - cp -p ${BASE_IN}.[mxclni][fsrn0][ptf12] ${PATH_OUT}/"
[ ${FAKE} -eq 0 ] &&            cp -p ${BASE_IN}.[mxciln][srnf0][tfp12] "${PATH_OUT}/"

# Limpa lixinho
echo "[${PRGNAM}]  2.04       - Movimenta relatorio de execução"
[ ${DEBUG} -gt 1 ] && echo "[${PRGNAM}]             - [ -f $PATH_REL/$DTISO.inv.log ] && mv $PATH_REL/$DTISO.inv.log relatorios/${PARM1}"
[ ${FAKE} -eq 0 ] && [ -f $PATH_REL/$DTISO.inv.log ] && mv $PATH_REL/$DTISO.inv.log relatorios/${PARM1}
[ ${DEBUG} -gt 1 ] && echo "[${PRGNAM}]             - rm -f ${PARM1}.[ciln][nf0][tp12]"
[ ${FAKE} -eq 0 ] &&            rm -f ${PARM1}.[ciln][nf0][tp12]


# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	${LIBS}/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

  detoxbase.sh [-h|-V|--changelog] [-c|--config NOMEARQU] [-d N] [-e|--erro] [--fake] [--fst|++fst NOMEARQU] [--nostw] [--stop] [-w|--web] <PARM1>
         onde:
       PARM1            Nome da base de dados

      Opções:
     --asc850           Utiliza o conjunto de caracteres ASCII CP850
     --ansi_N           Utiliza o conjunto de caracteres ANSI com números
     --ansi_X           Utiliza o conjunto de caracteres ANSI extendido
     --ansi_U           Utiliza o conjunto de caracteres ANSI ultra-extendido
     --changelog        Exibe o historico de alteracoes e para a execucao
 -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
 -d, --debug N          Define nivel de depuracao entre 0-256
 -e, --erro             Ignora detecção de erros de processamento
     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
     --fst NOMEARQU     Utiliza FST alternativa contido no arquivo NOMEARQU
     ++fst NOMEARQU     Utiliza FST alternativa contido no arquivo NOMEARQU gerando um índice com o nome de NOMEARQU
 -h, --help             Exibe este texto de ajuda e para a execucao
     --nostw            Ignora o arquivo de Stop Word se presente
     --stop             Libera a verificacao de parada pelo operador com pare ou q
 -V, --version          Exibe a versao corrente e para a execucao
 -w, --web              Indexação para publicação na Web
    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
     Chamada:           shs/indexbase.sh [-h|-V|--changelog] [-c|--config NOMEARQU] [-d N] [-e|--erro] [--fake] [--fst|++fst NOMEARQU] [--nostw] [--stop] [-w|--web] <PARM1>
     exemplo:           shs/indexbase.sh edi
                        shs/indexbase.sh -d 4 --stop fot
   Objetivos:           Gerar índice (invertido) da base de dados conforme FST default ou indicada
 Comentários:           Operação básica descrita a seguir:
		Le arquivos de configuração e prepara o ambiente de execução
		Apaga índice caso exista
		Verifica disponibilidade de insumos: Base, FST e STW
		Efetua a indexação da base
		Coloca base e indice no diretório próprio de saída (conforme CFG, por padrão BASE.new)
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
    wish list:	        1- .

COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200313 Versão e edição originais do processamento de bases de dados
20200616 Correção de falhas na semântica de comandos bash
20200620 Correção de testes de disponibilidade de arquivos
         Correção da função de debug dump_previas
         Alteração da transferência de resultados para PATH_OUT
20200621 Conferência e uniformização de comentários
SPICEDHAM

