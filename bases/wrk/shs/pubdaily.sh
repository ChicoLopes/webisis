#!/bin/bash

# -------------------------------------------------------------------------- #
# pubdaily.sh - Processamento para publicar base de dados diariamente na Web
# -------------------------------------------------------------------------- #
# PARM1  Nome da base de dados a ser publicada
# PARM2  Caminho destino da base de dados a publicar seja no administrativo, na intranet, ou na internet conforme arquivo de configuração da base
#
# Opções de execução:
#     --changelog        Exibe o histórico de alterações e para a execução
# -c, --config NOMEARQU  Utilizar configurações do arquivo NOMEARQU
# -d, --debug NIVEL      Define nível de depuração entre 0-255
# -e, --erro             Ignora detecção de erros de processamento
#     --fake             Execução simulada (não executa alterações em bases e arquivos)
# -h, --help             Exibe este texto de ajuda e para a execução
# -p, --producao         NÃO envia resutado para a produção
#     --stop             Libera a verificação de parada pelo operador com 'pare' ou 'q'
# -V, --version          Exibe a versão corrente e para a execução
#    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
#     Chamada:           shs/pubdaily.sh [-h|-V|--changelog] [-d N] [-e|--erro] [--fake] [-p|--producao] [--stop] <PARM1> [PARM2]
#     exemplo:           shs/pubdaily.sh edi
#                        shs/pubdaily.sh -d 4 --stop fot
#   Objetivos:           Coordenar todo o processamento de base de dados até a publicação
# Comentários:           Operação básica descrita a seguir:
#		Lê arquivos de configuração e prepara o ambiente de execução
#		Garante condicoes operativas (base de dados; FSTs; STWs)
#		Chama DETOXBASE para efetuar uma copia limpa da base de dados
#		Chama INDEXBASE para efetuar o processamento de base indexação da base de dados para ADM (administração de dados)
#		Chama TRNFRBASE para colocar resultado do processamento na área de ADM (administração de dados)
#		Chama PUBLCBASE para publicar a base de dados e índice na ADM (administração de dados)
#		Se permitido (vide flag -p) processa a base para Intranet e Internet
#		-Chama INDEXBASE para efetuar o processamento de indexação com a FST de WEB
#		-Chama TRNFRBASE para transferir base e índice para o servidor de Intranet
#		-Chama PUBLCBASE para publicar base e índice na Intranet
#		-Chama TRNFRBASE para transferir base e índice para o servidor de Internet
#		-Chama PUBLCBASE para publicar base e índice na Internet
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
vrs:  0.10 20200612, FJLopes
	- Aprimoramentos nas opções de chamada
vrs:  0.11 20200621, FJLopes
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




# Incorpora carregador de valores criticos default
source	${PRGDIR}/inc/pubdaily.lddefault.inc
# Incorpora dump de debug
source	${LIBS}/common.debug.inc
source	${PRGDIR}/inc/pubdaily.debug.inc
# Incorpora HELP e tratador de opcoes
source	${PRGDIR}/inc/pubdaily.mhelp_opc.inc

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

# Le arquivo de configuracao de operacao do programa
if [ ! -z ${CONFIG} ] ; then
	# Efetua a leitura do arquivo de configuracao ja que ele não é vazio
	echo "[${PRGNAM}]  1.01.02    - Efetua a leitura do arquivo de configuração"
    CONF_FILE=$(rdConfig "CONF_FILE")
    PATH_REL=$(rdConfig "RELAT_DIR")
fi

echo "[${PRGNAM}]  1.01.03    - Efetua leitura do arquivo de configuração da base de dados"
# Le arquivo de configuracao da base para processamento
CONFIG=$(echo "etc/${PARM1}.cfg")
PATH_IN=$(rdConfig "PATH_BASE_IN_")
PATH_OUT=$(rdConfig "PATH_BASE_ADM")
PATH_WEB=$(rdConfig "PATH_BASE_WEB")

echo "[${PRGNAM}]  1.01.04    - Finaliza a configuração"
PATH_OUT="temp/${PARM1}"		# Destino dos arquivos de trabalho
BASE_IN="${PATH_IN}/${PARM1}"
BASE_OUT="${PATH_OUT}/${PARM1}"
BASE_WEB="${PATH_WEB}/${PARM1}"
dump_config

echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"
mkdir -p ${PATH_OUT}				# Cria o diretorio para os rascunhos
[ ${FAKE} -eq 0 ] && del ${PARM1}.* # Se não é processamento fake apaga base no destino (se houver)

# ==== Processamento ====
echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"

# Verifica condicoes de processamento
echo "[${PRGNAM}]  2          - Processamento efetivo da base de dados"
echo "[${PRGNAM}]  2.01       - Verifica condições de processamento"

# Testa se a base esta disponivel
echo "[${PRGNAM}]  2.01.01    - Verifica disponibilidade da base de dados"
BASE_INok=$( ([[ -f "${BASE_IN}.xrf" ]] && [[  -f "${BASE_IN}.mst" ]]) && echo TRUE || echo FALSE )

# Verifica disponibilidade de fst e stw <== REVISAR ESTA PARTE DA BRINCADEIRA
echo "[${PRGNAM}]  2.01.02    - Verifica disponibilidade da fst administrativa (webisis)"
FST_ADMok=$( [[ -f "fsts/${PARM1}.fst" ]]     && echo TRUE || echo FALSE )
echo "[${PRGNAM}]  2.01.03    - Verifica disponibilidade do Stop Words administrativo (webisis)"
STW_ADMok=$( [[ -f "fsts/${PARM1}.stw" ]]     && echo TRUE || echo FALSE )
echo "[${PRGNAM}]  2.01.04    - Verifica disponibilidade da fst de publicação na web (iAH)"
FST_WEBok=$( [[ -f "fsts/${PARM1}.web.fst" ]] && echo TRUE || echo FALSE )
echo "[${PRGNAM}]  2.01.05    - Verifica disponibilidade do Stop Words de publicação na web (iAH)"
STW_WEBok=$( [[ -f "fsts/${PARM1}.web.stw" ]] && echo TRUE || echo FALSE )
dump_previas

# Ponto de interrupcao se permitida
rdBreak

echo "[${PRGNAM}]  2.01.06    - Avalia se tem condições de operação"
if [ ${BASE_INok} ] && [ ${FST_ADMok} ] && [ ${STW_ADMok} ] || [ ${NOERRO} -eq 1 ]; then
	echo "[${PRGNAM}]  2.01.06.01 - Condições mínimas de operação ok!"
else
	echo "[${PRGNAM}]  2.01.06.01 - Não reune as condições mínimas de operação, aborta execução"
	echo " - BASE_INok: ${BASE_INok}  $([   ${BASE_INok} ] && echo TRUE || echo FALSE)"
	echo " - FST_ADMok: ${FST_ADMok}  $([   ${FST_ADMok} ] && echo TRUE || echo FALSE)"
	echo " - STW_ADMok: ${STW_ADMok}  $([   ${STW_ADMok} ] && echo TRUE || echo FALSE)"
	echo " -    NOERRO: ${NOERRO}  "
	echo "*** FAIL +++ Não pode prosseguir por falta de algum elemento fundamental ***"
	HRFIM=$(date '+(%w) %F %T');                    # Hora de fim de execucao no formato YYYYMMDD hh:mm:ss
	timemark
	echo "Tempo de execucao de $PRGEXE $LCORI de $HRINI ate $HRFIM = $(printf "%7d" $TPROC)[s] ou $THUMAN"
	echo "[TIME-STAMP] $HRFIM [:FIM:] $PRGEXE $ARG_IN"
	# Limpa ambiente de execucao
	[ -f "${VARS}/run/${PRGNAM}" ] && rm -f ${VARS}/run/${PRGNAM}
	exit 201
	# BUG present
	#chkError FALSE "Não reune as condições mínimas de operação, aborta execução"
fi

if [ ${STW_ADMok} ] && [ ${STW_WEBok} ] ; then
	# Condições acessorias alcancadas
	echo "[${PRGNAM}]  2.01.06.02 - Condições plenas de operação ok!"
else
	echo "*** WARNING +++ Não operará em condições plenas, falta ao menos um arquivo Stop Words  ***"
fi

# Chama o procedimento de desintoxicacao de base de dados
echo "[${PRGNAM}]  2.02       - Promove a desintoxicação da base de dados"
echo "[${PRGNAM}]             - ${PRGDIR}/detoxbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
                   ${PRGDIR}/detoxbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}
				   chkError $? "O processo detoxbase retornou erro!"

# Chama indexação da base de dados para administração de dados
echo "[${PRGNAM}]  2.03       - Promove a indexação da base para administração de dados"
echo "[${PRGNAM}]             - ${PRGDIR}/indexbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} \"fsts/${PARM1}.fst\" \"fsts/${PARM1}.stw\""
                   ${PRGDIR}/indexbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} "fsts/${PARM1}.fst" "fsts/${PARM1}.stw"
				   chkError $? "O processo indexbase ADM retornou erro!"

# Chama a transferencia da base de dados para administração de dados
echo "[${PRGNAM}]  2.04       - Transfere base e indice para a area de administração de dados"
echo "[${PRGNAM}]             - ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
                   ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}
				   chkError $? "O processo trnfrbase ADM retornou erro!"

# Efetiva base processada na administração de dados
echo "[${PRGNAM}]  2.04       - Coloca base na area de administração de dados"
echo "[${PRGNAM}]             - ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
                   ${PRGDIR}/publcbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}
				   chkError $? "O processo publcbase ADM retornou erro!"

echo "[${PRGNAM}]  2.05       - Avalia se deve publicar na web ou é só rotina de manutenção"
if [ ${NOPROD} -eq 0 ] ; then

	# Chama indexação da base de dados para publicação web
	echo "[${PRGNAM}]  2.06       - Promove a indexação da base para publicação web"
	echo "[${PRGNAM}]             - ${PRGDIR}/indexbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} \"fsts/${PARM1}.web.fst\" \"fsts/${PARM1}.web.stw\""
	                     ${PRGDIR}/indexbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} "fsts/${PARM1}.web.fst" "fsts/${PARM1}.web.stw"
						 chkError $? "O processo indexbase WEB retornou erro!"

	# Chama a transferencia da base de dados para as areas de publicação de bases
	echo "[${PRGNAM}]  2.06.01    - Transfere base e indice para a area de dados a INTRANET"
	echo "[${PRGNAM}]             - ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
	                     ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} INTRA
						 chkError $? "O processo trnfrbase INTRA retornou erro!"

	# Efetiva a publicação da base de dados na WEB
	echo "[${PRGNAM}]  2.06.02    - Efetiva a publicação na INTRANET"
	echo "[${PRGNAM}]             - ${PRGDIR}/publcbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
	                   ${PRGDIR}/publcbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} INTRA
					   chkError $? "O processo de publcbase na INTRANET retornou erro!"

	echo "[${PRGNAM}]  2.06.03    - Transfere base e indice para a area de dados da WEB"
	echo "[${PRGNAM}]             - ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
	                     ${PRGDIR}/trnfrbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} WEB
						 chkError $? "O processo trnfrbase WEB retornou erro!"

	# Efetiva a publicação da base de dados na WEB
	echo "[${PRGNAM}]  2.06.04    - Efetiva a publicação na INTERNET"
	echo "[${PRGNAM}]             - ${PRGDIR}/publcbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1}"
	                   ${PRGDIR}/publcbase.sh -d ${DEBUG} ${OPC_FAKE} ${OPC_STOP} ${PARM1} WEB
					   chkError $? "O processo publcbase na INTERNET retornou erro!"

else
	echo "[${PRGNAM}]  2.06       - Evento de manutenção o ciclo de produção não foi executado"
fi

# Limpa lixinho
echo "[${PRGNAM}]  3          - Limpa área de trabalho"
echo "[${PRGNAM}]             - rm -f ${PARM1}.[mx][sr][tf]"
[ ${FAKE} -eq 0 ] &&            rm -f ${PARM1}.[mxciln][srnf0][tfp12]

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	${LIBS}/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

  pubdaily.sh [-h|-V|--changelog] [-d N] [-e|--erro] [--fake] [--stop] <PARM1>
         onde:
       PARM1            Nome da base de dados a ser publicada
       PARM2            Caminho destino da base de dados a publicar seja no administrativo, na intranet, ou na internet conforme arquivo de configuração da base

      Opções:
     --changelog        Exibe o histórico de alterações e para a execução
 -c, --config NOMEARQU  Utilizar configurações do arquivo NOMEARQU
 -d, --debug NIVEL      Define nível de depuração entre 0-255
 -e, --erro             Ignora detecção de erros de processamento
     --fake             Execução simulada (não executa alterações em bases e arquivos)
 -h, --help             Exibe este texto de ajuda e para a execução
 -p, --producao         NÃO envia resutado para a produção
     --stop             Libera a verificação de parada pelo operador com 'pare' ou 'q'
 -V, --version          Exibe a versão corrente e para a execução
    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
     Chamada:           shs/pubdaily.sh [-h|-V|--changelog] [-d N] [-e|--erro] [--fake] [-p|--producao] [--stop] <PARM1> [PARM2]
     exemplo:           shs/pubdaily.sh edi
                        shs/pubdaily.sh -d 4 --stop fot
   Objetivos:           Coordenar todo o processamento de base de dados até a publicação
 Comentários:           Operação básica descrita a seguir:
		Lê arquivos de configuração e prepara o ambiente de execução
		Garante condicoes operativas (base de dados; FSTs; STWs)
		Chama DETOXBASE para efetuar uma copia limpa da base de dados
		Chama INDEXBASE para efetuar o processamento de base indexação da base de dados para ADM (administração de dados)
		Chama TRNFRBASE para colocar resultado do processamento na área de ADM (administração de dados)
		Chama PUBLCBASE para publicar a base de dados e índice na ADM (administração de dados)
		Se permitido (vide flag -p) processa a base para Intranet e Internet
		-Chama INDEXBASE para efetuar o processamento de indexação com a FST de WEB
		-Chama TRNFRBASE para transferir base e índice para o servidor de Intranet
		-Chama PUBLCBASE para publicar base e índice na Intranet
		-Chama TRNFRBASE para transferir base e índice para o servidor de Internet
		-Chama PUBLCBASE para publicar base e índice na Internet
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
    wish list:	        1- Avaliar no arquivo de configuração se há processamento para WEB e automatizar a execução

Assim se faz uma mensagem de tempo de debug (controlada pelo invel de depuracao)
[ ${DEBUG} -gt 0 ] && echo "[${PRGNAM}]  0.00.00.00 - Efetua copia limpa da base de dados"
        onde o 0 é o último nível de depuração que a mensagem NÃO é exibida

Versão simplificada de processamento para ambiente Windows (só base EDI):
@echo off
if exist edi.xrf del edi.xrf
if exist edi.mst del edi.mst
cisis\1660\mxcp ..\edi\edi create=work clean log=edi.clean
cisis\1660\mx work append=edi -all now tell=1000 "proc=('Ggizmos\gansmi,120')"
if exist work.xrf del work.*
cisis\1660\mx edi "fst=@fsts\edi.fst" actab=tabs\ac850.tab uctab=tabs\uc850.tab fullinv=edi tell=5000
if not exist bases         mkdir bases
if not exist bases\iah     mkdir bases\iah
if not exist bases\iah\fst mkdir bases\iah\fst
if not exist bases\iah\edi mkdir bases\iah\edi
if not exist linux         mkdir linux
if not exist linux\iah     mkdir linux\iah
if not exist linux\iah\fst mkdir linux\iah\fst
if not exist linux\iah\edi mkdir linux\iah\edi
cisis\1660\crunchmf edi linux\iah\edi\edi 
cisis\1660\crunchif edi linux\iah\edi\edi 
# Coloca base na area de publicacao Web
move edi.xrf bases\iah\edi > nul
move edi.mst bases\iah\edi > nul
move edi.cnt bases\iah\edi > nul
move edi.ifp bases\iah\edi > nul
move edi.l0? bases\iah\edi > nul
move edi.n0? bases\iah\edi > nul
copy fsts\edi.fst bases\iah\fst > nul
copy fsts\edi.fst linux\iah\fst > nul
echo Tecle ENTER para fechar esta janela
pause > nul

COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200313 Versão e edição originais do processamento de bases de dados
20200621 Conferência e uniformização de comentários
SPICEDHAM

