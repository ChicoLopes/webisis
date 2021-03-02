# dump_env - Mostra todo o ambiente de execução
# -------------------------------------------------------------------------- #
# PARM --	Nao necessita de parametros de chamada
# Observ.	
#
function dump_env {
if [ ${DEBUG} -gt 0 ] ; then
	echo    "==> PTO DUMP_ENV"
        #                 1         2         3         4         5         6         7         8
        #        12345678901234567890123456789012345678901234567890123456789012345678901234567890
	echo    "+-----------------------------------------------------------------------------+"
	echo    "| Momento inicial .............. HINIC: ${HINIC}"
	echo    "| Hora de início ............... HRINI: ${HRINI}"
	echo    "| Dia da semana abreviado ...... _dow_: ${_dow_}"
	echo    "| Dia da semana numérico ....... _DOW_: ${_DOW_}"
	echo    "| Dia do mês ................... _DIA_: ${_DIA_}"
	echo    "| Mês .......................... _MES_: ${_MES_}"
	echo    "| Ano (YYYY) ................... _ANO_: ${_ANO_}"
	echo    "| Data formato ISO ............. DTISO: ${DTISO}"
	echo    "| Programa .................... PRGEXE: ${PRGEXE}"
	echo    "| Nome do programa ............ PRGNAM: ${PRGNAM}"
	echo    "| Diretório do programa ....... PRGDIR: ${PRGDIR}"
	echo    "| Diretório corrente .......... DIRINI: ${DIRINI}"
	echo    "| Linha de comando ............ ARG_IN: ${ARG_IN}"
	echo -n "| Arquivo de configuração ... CFG_FILE: "
	if [ -z ${CFG_FILE} ] ; then
       		echo "default"
    else
       		echo ${CFG_FILE}
    fi
	echo -n "| Indice com nome da FST ..... BASEFST: "; [ ${BASEFST} -eq 1 ] && echo "ATIVO" || echo "inativo"
	echo    "| Conjunto de caracteres ..... CHARSET: ${CHARSET}"
	echo -n "| Ponto de parada permitido ... CTSTOP: "; [ ${CTSTOP} -eq 1 ]  && echo "ATIVO" || echo "inativo"
	echo    "| Texto de parada permitida . OPC_STOP: ${OPC_STOP}"
	echo    "| Nível DEBUG .................. DEBUG: ${DEBUG}"
	echo -n "| Ignora erros ................ NOERRO: "; [ ${NOERRO} -eq 1 ]  && echo "ATIVO" || echo "inativo"
	echo    "| Texto de ignorar erros .... OPC_ERRO: ${OPC_ERRO}"
	echo -n "| Execução simulada ............. FAKE: "; [ ${FAKE} -eq 1 ]    && echo "ATIVA" || echo "inativa"
	echo    "| Texto de exec. simulada ... OPC_FAKE: ${OPC_FAKE}"
	echo    "| Tabela de Seleção de Campos .... FST: ${FST}"
	echo -n "| Ignora arquivo Stop Words .... NOSTW: "; [ ${NOSTW} -eq 1 ]   && echo "ATIVA" || echo "inativa"
	echo -n "| Indexação para WEB ............. WEB: "; [ ${WEB} -eq 1 ]     && echo "ATIVA" || echo "inativa"
	echo    "+-----------------------------------------------------------------------------+"
	[ ! -z ${PARM1} ] && echo "= Argumentos de chamada ====================="

	[ ! -z ${PARM1} ] && echo "             PARM1: ${PARM1}"
	[ ! -z ${PARM2} ] && echo "             PARM2: ${PARM2}"
	[ ! -z ${PARM3} ] && echo "             PARM3: ${PARM3}"
	[ ! -z ${PARM4} ] && echo "             PARM4: ${PARM4}"
	[ ! -z ${PARM5} ] && echo "             PARM5: ${PARM5}"
	[ ! -z ${PARM6} ] && echo "             PARM6: ${PARM6}"
	[ ! -z ${PARM7} ] && echo "             PARM7: ${PARM7}"
	[ ! -z ${PARM8} ] && echo "             PARM8: ${PARM8}"
	[ ! -z ${PARM9} ] && echo "             PARM9: ${PARM9}"
	[ ! -z ${PARM1} ] && echo "============================================="
fi
}

function dump_config {
if [ ${DEBUG} -gt 1 ] ; then
	echo    "==> PTO DUMP_CONFIG"
	#                 1         2         3         4         5         6         7         8
	#        12345678901234567890123456789012345678901234567890123456789012345678901234567890
	echo    "+-----------------------------------------------------------------------------+"
	echo    "| Arquivo de configuração do programa ....... CFG_FILE: ${CFG_FILE}"
	echo	"| Identificação do arquivo de configuração . CONF_FILE: ${CONF_FILE}"
	echo	"| Caminho para gravar os relatórios ......... PATH_REL: ${PATH_REL}"
	echo    "+-----------------------------------------------------------------------------+"
	echo    "| Arquivo de configuração da base de dados .... CONFIG: ${CONFIG}"
	echo    "| Compilação de CISIS para uso com a base .. CISIS_DIR: ${CISIS_DIR}"
	echo    "| Caminho para o resultado da indexação ..... PATH_OUT: ${PATH_OUT}"
	echo    "| Base a indexar ............................. BASE_IN: ${BASE_IN}"
	echo    "| Nome do índice a gerar .................... BASE_OUT: ${BASE_OUT}"
	echo	"| Tabela de Seleção de Campos a utilizar ......... FST: ${FST}"
	echo	"| Arquiv de Stop Words a utilizar ................ STW: ${STW}"
	echo    "+-----------------------------------------------------------------------------+"
fi
}

function dump_previas {
if [ ${DEBUG} -gt 0 ] ; then
    echo    "==> PTO DUMP_PREVIAS"
    #                 1         2         3         4         5         6         7         8
    #        12345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo    "+-----------------------------------------------------------------------------+"
    echo    "| Base de entrada encontrada ....... BASE_INok: ${BASE_INok} (${BASE_IN})"
    echo    "| FST a utilizar encontrada ........... FST_ok: ${FST_ok} (${FST})"
    echo    "| STW administrativa encontrada ....... STW_ok: ${STW_ok} (${STW})"
    echo    "+-----------------------------------------------------------------------------+"
fi
}
