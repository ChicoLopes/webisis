#!/bin/bash

# -------------------------------------------------------------------------- #
# detoxbase.sh - Procedimento de limpeza e remontagem de base de dados
# -------------------------------------------------------------------------- #
# PARM1		Nome da base de dados a processar
# PARM2		Caminho para a base de dados, se omitido conforme arquivo de
#              configuração da base de dados em etc (etc/<PARM1>.cfg)
# Opcoes de execucao:
#     --changelog        Exibe o historico de alteracoes e para a execucao
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -d, --debug NIVEL      Define nivel de depuracao entre 0-255
# -e, --erro             Ignora detecção de erros de processamento
#     --fake             Execucao simulada nao efetua alteracoes em bases e arquivos
# -h, --help             Exibe este texto de ajuda e para a execucao
#     --stop             Libera a verificacao de parada pelo operador com 'pare' ou 'q'
# -V, --version          Exibe a versao corrente e para a execucao
#    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
#     Chamada:           shs/detoxbase.sh [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2]
#    exemplos:           shs/detoxbase.sh edi
#                        shs/detoxbase.sh --fake fot
#   Objetivos:           Limpar a base de dados para processamento posterior
# Comentários:           Operacao basica descrita a seguir:
#		Lê arquivos de configuração e prepara o ambiente de execução
#		Apaga presente base no destino (se houver)
#		Efetua uma copia limpa da base de dados para uma base de trabalho (temp/?)
#		Remonta a base de dados eliminando registros apagados
#		Coloca relatorio de execução na pasta relatorios/<PARM1>
#		Elimina o lixinho temporario
#		Fim da tarefa
# -------------------------------------------------------------------------- #
# QAPLA Comercio e Servicos de Informatica Ltda-ME
# CNPJ: 05.129.080/0001-01          QAPLA (p) 2020
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 20200513, FJLopes
	- Edicao original
vrs:  0.10 20200611, FJLopes
	- Movimentação de relatório de processamento
vrs:  0.11 20200616, FJLopes
	- Correção de diversos erros menores
vrs:  0.20 20200621, FJLopes
	- Mudança do nome do relatório de processamento e unifomização de documentação interna
HISTORICO

# ========================================================================== #
# BIBLIOTECAS
# ========================================================================== #
# Incorpora a biblioteca bibliteca
# source	$PATH_EXEC/inc/bibliteca.inc
# A biblioteca conta com as funcoes:
# rdLIV		--	--	Retorna informacoes sobre a bibliteca
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
source	${PRGDIR}/inc/detoxbase.lddefault.inc
# Incorpora dump de debug
source	${LIBS}/common.debug.inc
source	${PRGDIR}/inc/detoxbase.debug.inc
# Incorpora HELP e tratador de opcoes
source	${PRGDIR}/inc/detoxbase.mhelp_opc.inc

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
		RESP=1
		chkError $RESP "Arquivo de configuracao ${CONFIG} nao encontrado!"
		exit 2
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
	# Efetua a leitura do arquivo de configuracao
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

echo "[${PRGNAM}]  1.01.03.03 - Configura nome da base de dados para desintoxicação"
if [ -z ${PARM2} ] ; then
	PATH_IN=$(rdConfig "PATH_BASE_IN_")
else
	PATH_IN=${PARM2}
fi

# Debug time
#echo "PATH_IN : $PATH_IN"
#rdBreak

echo "[${PRGNAM}]  1.01.04    - Finaliza a configuração"
PATH_OUT="temp/${PARM1}"		# Destino dos arquivos de trabalho
BASE_IN="$PATH_IN/$PARM1"		# PATH mais NOME da base de dados
dump_config

# ==== Processamento ====
echo "[${PRGNAM}]  1.02       - Prepara ambiente de processamento"
echo "[${PRGNAM}]  1.02.01    - Garante existência de diretório para uso temporário"
mkdir -p ${PATH_REL}				# Garante existência do diretorio para os rascunhos

echo "[${PRGNAM}]  1.02.02    - Garante existencia de diretório para o resultado do processamento"
[ ${FAKE} -eq 0 ] && mkdir -p ${PATH_OUT}

echo "[${PRGNAM}]  1.02.03    - Elimina arquivo mestre antigo se houver"
[ ${FAKE} -eq 0 ] && del ${PARM1}.* # Se não é processamento fake apaga base no destino (se houver)

# Ponto de interrupcao se permitida
rdBreak

# Efetua uma copia limpa da base de dados para uma base de trabalho
echo "[${PRGNAM}]  2          - Processamento efetivo da base de dados"
echo "[${PRGNAM}]  2.01       - Efetua copia limpa da base de dados"

# Separa segmento do relatorio de execução
#              1         2         3         4         5         6         7         8
#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "=============================================================================="                               >> $PATH_REL/$DTISO.dtx.log
echo "Processamento de desintoxicação da base de dados ${PARM1} do dia: $HRINI"                                     >> $PATH_REL/$DTISO.dtx.log
echo "Desintoxicação executada com o comando a seguir:"                                                             >> $PATH_REL/$DTISO.dtx.log
echo "- ${CISIS_DIR}/mxcp ${BASE_IN} create=temp/${PARM1} clean period=. repeat=% log=temp/${PARM1}-clean.log" >> $PATH_REL/$DTISO.dtx.log
echo "==== Relatório de limpeza ===================================================="                               >> $PATH_REL/$DTISO.dtx.log

# Toma a base de dados para iniciar limpeza
echo "[${PRGNAM}]  2.01.01    - ${CISIS_DIR}/mxcp ${BASE_IN} create=temp/${PARM1} clean period=. repeat=% log=temp/${PARM1}-clean.log"
[ ${FAKE} -eq 0 ] &&            ${CISIS_DIR}/mxcp ${BASE_IN} create=temp/${PARM1} clean period=. repeat=% log=temp/${PARM1}-clean.log
RESP=$?; [ ${NOERRO} -eq 1 ] && RESP=0 || [ ${FAKE} -eq 1 ] && RESP=0
chkError ${RESP} "Erro ao efetuar copia limpa"

echo "[${PRGNAM}]  2.01.02    - Consolida relatório de limpeza no relatório de processamento"
[ -f temp/${PARM1}-clean.log ] && cat temp/${PARM1}-clean.log                                             >> $PATH_REL/$DTISO.dtx.log

echo "[${PRGNAM}]  2.01.03    - Calcula o fator de tell em função da quantidade de registros"
echo "[${PRGNAM}]  2.01.03.01 - Determina quantidade de registros na base de dados"
# determina a quantidade de registros da base de dados e determina o fator de tell
[ ${FAKE} -eq 0 ] && qtderegs=$(qregs temp/${PARM1} ${CISIS_DIR})
## echo "Quantidade de registros na base $PARM1 é: $qtderegs"

echo "[${PRGNAM}]  2.01.03.02 - Estipula o fator em função do tamanho da base em registros"
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

echo "==== Relatório de reconstrução da base de dados =============================="                               >> $PATH_REL/$DTISO.dtx.log
echo "Reconstrução executada com o comando a seguir:"                                                               >> $PATH_REL/$DTISO.dtx.log
echo "- ${CISIS_DIR}/mx temp/${PARM1} append=${PARM1} -all now tell=0${TELLFAC}"                                    >> $PATH_REL/$DTISO.dtx.log
echo "[${PRGNAM}]  2.01.04    - Reconstroi a base de dados limpa para processamento efetivo"
# Remonta a base de dados eliminando registros apagados
echo "[${PRGNAM}]  2.01.04    - ${CISIS_DIR}/mx temp/${PARM1} append=${PARM1} -all now tell=0${TELLFAC}"
[ ${FAKE} -eq 0 ] &&            ${CISIS_DIR}/mx temp/${PARM1} append=${PARM1} -all now tell=0${TELLFAC}            &>> $PATH_REL/$DTISO.dtx.log
RESP=$?; [ ${NOERRO} -eq 1 ] && RESP=0 || [ ${FAKE} -eq 1 ] && RESP=0
chkError ${RESP} "Erro ao reconstruir a base de dados"

# Limpa area de trabalho
echo "[${PRGNAM}]  3          - Finaliza a execucao de ${PRGMAN}"
echo "[${PRGNAM}]  3.01       - Coloca relatórios na pasta \"relatorios\""
echo "[${PRGNAM}]  3.01.01    - Garante existência do diretório de destino"
[ ${FAKE} -eq 0 ] && mkdir -p relatorios/${PARM1}
echo "[${PRGNAM}]  3.01.02    - Efetiva a movimentação do relatório"
[ ${FAKE} -eq 0 ] && mv $PATH_REL/$DTISO.dtx.log relatorios/${PARM1}

echo "[${PRGNAM}]  3.02       - Elimina arquivos residuais"
del temp/${PARM1}.*
del temp/${PARM1}-clean.log


# Tarefa finalizada
# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	$LIBS/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

  detoxbase.sh - Desintoxica base de dados
         onde:
       PARM1            Nome da base de dados a processar
       PARM2            Caminho para a base de dados, se omitido conforme arquivo de
                           configuração da base de dados em etc (etc/<PARM1>.cfg)
      Opções:
     --changelog        Exibe o histórico de alterações e para a execução
 -c, --config NOMEARQU  Utilizar configurações do arquivo NOMEARQU
 -d, --debug NIVEL      Define nível de depuração entre 0-255
 -e, --erro             Ignora detecção de erros de processamento
     --fake             Execução simulada não efetua alterações em bases e arquivos
 -h, --help             Exibe este texto de ajuda e para a execução
     --stop             Libera a verificação de parada pelo operador com 'pare' ou 'q'
 -V, --version          Exibe a versão corrente e para a execução
    corrente:           work em /home/www/webisis/bases/wrk (absoluto) ou webisis/bases/wrk (no relativo)
     Chamada:           shs/detoxbase.sh [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2]
    exemplos:           shs/detoxbase.sh edi
                        shs/detoxbase.sh --fake fot ../fot
   Objetivos:           Limpar a base de dados para processamento posterior
 Comentários:           Operação básica descrita a seguir:
		Lê arquivos de configuração e prepara o ambiente de execução
		Apaga base presente no destino (wrk/) deste processamento (se houver)
		Efetua uma cópia limpa da base de dados para uma base de trabalho (temp/?)
		Remonta a base de dados eliminando registros apagados
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

Assim se faz uma mensagem de tempo de debug (controlada pelo nível de depuração)
[ ${DEBUG} -gt 0 ] && echo "[${PRGNAM}]  0.00.00.00 - Efetua cópia limpa da base de dados"
        onde o 0 é o último nível de depuração que a mensagem NÃO é exibida

COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200513 Versão e edição originais do processamento de limpeza da bases de dados
20200611 Acréscimo da movimentação de relatório de limpeza para o diretório relatorios/<PARM1>
20200616 Correção de erros de semântica de comandos bash e inclusão de testes de situações de erro
20200621 Alteração na denominação do relatório de processamento
         Conferência e uniformização de comentários
SPICEDHAM

