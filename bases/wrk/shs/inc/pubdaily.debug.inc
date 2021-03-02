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
    echo    "| Ano \(YYYY\) ................... _ANO_: ${_ANO_}"
    echo    "| Data formato ISO ............. DTISO: ${DTISO}"
    echo    "| Programa .................... PRGEXE: ${PRGEXE}"
    echo    "| Nome do programa ............ PRGNAM: ${PRGNAM}"
    echo    "| Diretório do programa ....... PRGDIR: ${PRGDIR}"
    echo    "| Diretório corrente .......... DIRINI: ${DIRINI}"
    echo    "| Linha de comando ............ ARG_IN: ${ARG_IN}"
    echo -n "| Arquivo de configuração ... CFG_FILE: "
    if [ -z ${CFG_FILE} ]; then
        echo "default"
    else
        echo ${CFG_FILE}
    fi
	echo -n "| Ponto de parada permitido ... CTSTOP: "; [ ${CTSTOP} = 1 ] && echo "ATIVA" || echo "inativa"
	echo    "| Texto de parada permitida . OPC_STOP: ${OPC_STOP}"
	echo    "| Nível DEBUG .................. DEBUG: ${DEBUG}"
	echo -n "| Ignora erros ................ NOERRO: "; [ ${NOERRO} = 1 ] && echo "ATIVO" || echo "inativo"
	echo    "| Texto de ignorar erros .... OPC_ERRO: ${OPC_ERRO}"
	echo -n "| Execução simulada ............. FAKE: "; [ ${FAKE} = 1 ]   && echo "ATIVA" || echo "inativa"
	echo    "| Texto de exec. simulada ... OPC_FAKE: ${OPC_FAKE}"
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
if [ ${DEBUG} -gt 0 ] ; then
	echo    "==> PTO DUMP_CONFIG"
	#                 1         2         3         4         5         6         7         8
	#        12345678901234567890123456789012345678901234567890123456789012345678901234567890
	echo    "+- Configurações do programa -------------------------------------------------+"
	echo    "| Arquivo de configuração informado ......... CFG_FILE: ${CFG_FILE}"
	echo	"| Identificação do arquivo de configuração . CONF_FILE: ${CONF_FILE}"
	echo    "+- Configurações da Base de dados --------------------------------------------+"
	echo    "| Arquivo de configuração da base de dados .... CONFIG: ${CONFIG}"
	echo    "| Compilação de CISIS para uso com a base .. CISIS_DIR: ${CISIS_DIR}"
	echo    "| Caminho de entrada de processamento ........ PATH_IN: ${PATH_IN}"
	echo    "| Caminho de saida de processamento ......... PATH_OUT: ${PATH_OUT}"
	echo    "| Caminho de publicação da base de dados .... PATH_WEB: ${PATH_WEB}"
	echo    "| Origem dos dados ........................... BASE_IN: ${BASE_IN}"
	echo    "| Destino dos dados ......................... BASE_OUT: ${BASE_OUT}"
	echo    "| Base em publicação ........................ BASE_WEB: ${BASE_WEB}"
	echo    "+-----------------------------------------------------------------------------+"
fi
}

function dump_previas {
if [ ${DEBUG} -gt 0 ] ; then
    echo    "==> PTO DUMP_PREVIAS"
    #                 1         2         3         4         5         6         7         8
    #        12345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo    "+-----------------------------------------------------------------------------+"
    echo    "| Base de entrada encontrada ....... BASE_INok: ${BASE_INok} \(${BASE_IN}\)"
    echo    "| FST administrativa encontrada .... FST_ADMok: ${FST_ADMok} \(fsts/${PARM1}.fst\)"
    echo    "| STW administrativa encontrada .... STW_ADMok: ${STW_ADMok} \(fsts/${PARM1}.stw\)"
    echo    "| FST para busca WEB encontrada .... FST_WEBok: ${FST_WEBok} \(fsts/${PARM1}.web.fst\)"
    echo    "| STW para uso na WEB encontrada ... STW_WEBok: ${STW_WEBok} \(fsts/${PARM1}.web.stw\)"
    echo    "+-----------------------------------------------------------------------------+"
fi
}
