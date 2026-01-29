# Mensagem de ajuda e tratamento de opcoes do processamento
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
AJUDA_USO="
Uso: ${PRGEXE} [-h|-V|--changelog] [-d N] [--fake] [--stop] <PARM1> [PARM2] 

OPCOES:
     --changelog        Exibe o histórico de alterações e para a execução
 -c, --config NOMEARQU  Utilizar configurações do arquivo NOMEARQU
 -d, --debug NIVEL      Define nível de depuração entre 0-255
     --fake             Execucao simulada (não efetua alterações em bases e arquivos)
 -h, --help             Exibe este texto de ajuda e para a execução
     --stop             Libera a verificação de parada pelo operador com 'pare' ou 'q'
 -V, --version          Exibe a versão corrente e para a execução

PARAMETROS:
 PARM1  Identificador único da base de dados a ser preprocessada
 PARM2  Caminho destino da base de dados a publicar seja no administrativo,
          na intranet, ou na internet conforme aquivo de configuração da base
"

# -------------------------------------------------------------------------- #
# Tratamento das opcoes de linha de comando (qdo houver alguma)
while test -n "${1}"
do
        case "${1}" in

                --changelog)
                        TOTLN=$(wc -l ${0} | awk '{ print $1 }')
                        INILN=$(grep -n "<SPICEDHAM" ${0} | tail -1 | cut -d ":" -f "1")
                        LINHAI=$(expr ${TOTLN} - ${INILN})
                        LINHAF=$(expr ${LINHAI} - 2)
                        echo -e -n "\n${PRGEXE} "
                        grep '^vrs: ' ${PRGDIR}/${PRGEXE} | tail -1
                        echo -n "==> "
                        tail -${LINHAI} ${0} | head -${LINHAF}
                        echo
                        exit
                        ;;

                -c | --config)
						shift
						if [ -f ${1} ]; then
							CFG_FILE=${1}
						else
							echo "Arquivo de configuração ${1} não encontrado!"
							echo "Assumindo as configurações padrão!"
							CFG_FILE=${PRGDIR}/inc/${PRGNAM}.cnf
						fi
                        ;;

                -d | --debug)
                        shift
                        isNumber ${1}
                        [ $? -ne 0 ] && echo -e "\n${PRGEXE}: O argumento da opcao DEBUG deve existir e ser numerico.\n${AJUDA_USO}" && exit 2
                        DEBUG=${1}
						if [ ${FAKE} -eq 0 ] ; then
							FAKE=$(expr $((${DEBUG} & _BIT7_)) / 128 )
							if [ ${FAKE} -eq 1 ] ; then
								OPC_FAKE="--fake"
							else
								OPC_FAKE=""
							fi
						fi
						;;
						
                --fake)
						FAKE=1
						OPC_FAKE="--fake"
                        ;;

                -h | --help)
                        echo -e -n "\n${PRGEXE} "
                        grep '^vrs: ' ${PRGDIR}/${PRGEXE} | tail -1
                        echo "${AJUDA_USO}"
                        exit
                        ;;

                --stop)
                        CTSTOP=1
						OPC_STOP="--stop"
                        ;;

                -V | --version)
                        echo -e -n "\n${PRGEXE} "
                        grep '^vrs: ' ${PRGDIR}/${PRGEXE} | tail -1
                        echo
                        exit
                        ;;

                *)
                        if [ $(expr index ${1} "-") -ne 1 ]; then
                                if test -z "${PARM1}"; then PARM1=${1}; shift; continue; fi
                                if test -z "${PARM2}"; then PARM2=${1}; shift; continue; fi
                                if test -z "${PARM3}"; then PARM3=${1}; shift; continue; fi
                                if test -z "${PARM4}"; then PARM4=${1}; shift; continue; fi
                                if test -z "${PARM5}"; then PARM5=${1}; shift; continue; fi
                                if test -z "${PARM6}"; then PARM6=${1}; shift; continue; fi
                                if test -z "${PARM7}"; then PARM7=${1}; shift; continue; fi
                                if test -z "${PARM8}"; then PARM8=${1}; shift; continue; fi
                                if test -z "${PARM9}"; then PARM9=${1}; shift; continue; fi
                        else
                                echo "Opção não válida! (${1})"
                        fi
                        ;;
        esac
        # Argumento tratado, desloca os parametros e trata o proximo
        shift
done
# Para DEBUG assume valor DEFAULT antecipadamente
isNumber ${DEBUG}
[ $? -ne 0 ]           && DEBUG="0"
[ ${DEBUG} -ne 0 ] && OPC_DEBUG="-d ${DEBUG}"
# -------------------------------------------------------------------------- #
# Avalia nivel de depuracao
[ $((${DEBUG} & $_BIT3_)) -ne 0 ] && set -v
[ $((${DEBUG} & $_BIT4_)) -ne 0 ] && set -x

# Argumento de chamada numero um eh obrigatorio
test -z "${PARM1}" && echo -e "\n${PRGEXE}: O argumento #1 eh obrigatório.\n${AJUDA_USO}" && exit 2

# Primeiro ponto de depuracao mostrando TODO o ambiente de execucao
dump_env
