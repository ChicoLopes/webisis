# Mensagem de ajuda e tratamento de opcoes do processamento
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
AJUDA_USO="
Uso: ${PRGEXE} [-h|-V|--changelog] [-c|--config NOMEARQU] [-d N] [-e|--erro] [--fake] [--fst|++fst NOMEARQU] [--nostw] [--stop] [-w|--web] <PARM1>

OPCOES:
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

PARAMETROS:
 PARM1  Identificador único da base de dados a ser preprocessada
"

# -------------------------------------------------------------------------- #
# Tratamento das opcoes de linha de comando (qdo houver alguma)
while test -n "${1}"
do
        case "${1}" in

                --asc850)
						CHARSET="actab=${TABS}/ac850.tab uctab=${TABS}/uc850.tab"
                        ;;

                --ansi_N)
						CHARSET="actab=${TABS}/acansn.tab uctab=${TABS}/ucansn.tab"
                        ;;

                --ansi_X)
						CHARSET="actab=${TABS}/acansXT.tab uctab=${TABS}/ucansXT.tab"
                        ;;

                --ansi_U)
						CHARSET="actab=${TABS}/acansUT.tab uctab=${TABS}/ucansUT.tab"
                        ;;

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
						CFG_FILE=${1}
						if [ ! -f ${1} ]; then
							echo "Arquivo de configuração ${1} não encontrado!"
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

				-e | --erro)
						NOERRO=1
						OPC_ERRO="-e"
						;;

                --fake)
                        FAKE=1
						OPC_FAKE="--fake"
                        ;;

                --fst)
                        shift
						FST=${1}
                        ;;

                ++fst)
                        shift
						FST=${1}
						BASEFST=1
                        ;;

                -h | --help)
                        echo -e -n "\n${PRGEXE} "
                        grep '^vrs: ' ${PRGDIR}/${PRGEXE} | tail -1
                        echo "${AJUDA_USO}"
                        exit
                        ;;

                --nostw)
                        NOSTW=1
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

                -w | --web)
						WEB=1
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
[ $? -ne 0 ]           && DEBUG=0
[ "${DEBUG}" -ne "0" ] && OPC_DEBUG="-d ${DEBUG}"
# -------------------------------------------------------------------------- #
# Avalia nivel de depuracao
[ $((${DEBUG} & $_BIT3_)) -ne 0 ] && set -v
[ $((${DEBUG} & $_BIT4_)) -ne 0 ] && set -x

# Argumento de chamada numero um eh obrigatorio
test -z "${PARM1}" && echo -e "\n${PRGEXE}: O argumento #1 eh obrigatório.\n${AJUDA_USO}" && exit 2

# Primeiro ponto de depuracao mostrando TODO o ambiente de execucao
dump_env
