# Mensagem de ajuda e tratamento de opcoes do processamento
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
AJUDA_USO="
Uso: $PRGEXE [-h|-V|--changelog] [-d N] [--fake] [--stop] [-c NOMEARQU] <PARM1>

OPCOES:
     --changelog        Exibe o historico de alteracoes e para a execucao
 -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
 -d, --debug NIVEL      Define nivel de depuracao com valor numerico positivo
     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
 -h, --help             Exibe este texto de ajuda e para a execucao
     --stop             Habilita a verificacao de parada pelo operador com "pare\<ENTER\>"
 -V, --version          Exibe a versao corrente e para a execucao

PARAMETROS:
 PARM1  Identificador unico da base de dados a ser preprocessada
"

# -------------------------------------------------------------------------- #
# Tratamento das opcoes de linha de comando (qdo houver alguma)
while test -n "$1"
do
        case "$1" in

                -h | --help)
                        echo -e -n "\n$PRGEXE "
                        grep '^vrs: ' $PRGDIR/$PRGEXE | tail -1
                        echo "$AJUDA_USO"
                        exit
                        ;;

                -V | --version)
                        echo -e -n "\n$PRGEXE "
                        grep '^vrs: ' $PRGDIR/$PRGEXE | tail -1
                        echo
                        exit
                        ;;

                -d | --debug)
                        shift
                        isNumber $1
                        [ $? -ne 0 ] && echo -e "\n$PRGEXE: O argumento da opcao DEBUG deve existir e ser numerico.\n$AJUDA_USO" && exit 2
                        DEBUG=$1
                        FAKE=$(expr $(($DEBUG & _BIT7_)) / 128)
                        ;;

                     --fake)
                        FAKE=1
                        ;;

                     --stop)
                        CTSTOP=1
                        ;;

                --changelog)
                        TOTLN=$(wc -l $0 | awk '{ print $1 }')
                        INILN=$(grep -n "<SPICEDHAM" $0 | tail -1 | cut -d ":" -f "1")
                        LINHAI=$(expr $TOTLN - $INILN)
                        LINHAF=$(expr $LINHAI - 2)
                        echo -e -n "\n$PRGEXE "
                        grep '^vrs: ' $PRGDIR/$PRGEXE | tail -1
                        echo -n "==> "
                        tail -$LINHAI $0 | head -$LINHAF
                        echo
                        exit
                        ;;

                *)
                        if [ $(expr index $1 "-") -ne 1 ]; then
                                if test -z "$PARM1"; then PARM1=$1; shift; continue; fi
                                if test -z "$PARM2"; then PARM2=$1; shift; continue; fi
                                if test -z "$PARM3"; then PARM3=$1; shift; continue; fi
                                if test -z "$PARM4"; then PARM4=$1; shift; continue; fi
                                if test -z "$PARM5"; then PARM5=$1; shift; continue; fi
                                if test -z "$PARM6"; then PARM6=$1; shift; continue; fi
                                if test -z "$PARM7"; then PARM7=$1; shift; continue; fi
                                if test -z "$PARM8"; then PARM8=$1; shift; continue; fi
                                if test -z "$PARM9"; then PARM9=$1; shift; continue; fi
                        else
                                echo "Opcao nao valida! ($1)"
                        fi
                        ;;
        esac
        # Argumento tratado, desloca os parametros e trata o proximo
        shift
done
# Para DEBUG assume valor DEFAULT antecipadamente
isNumber $DEBUG
[ $? -ne 0 ]         && DEBUG="0"
[ "$DEBUG" -ne "0" ] && PARMD="-d $DEBUG"
# -------------------------------------------------------------------------- #
# Avalia nivel de depuracao
[ $(($DEBUG & $_BIT3_)) -ne 0 ] && set -v
[ $(($DEBUG & $_BIT4_)) -ne 0 ] && set -x

# Argumento de chamada numero um eh obrigatorio
test -z "$PARM1" && echo -e "\n$PRGEXE: O argumento #1 eh obrigatório.\n$AJUDA_USO" && exit 2

# Primeiro ponto de depuracao mostrando TODO o ambiente de execucao
if [ $DEBUG -gt 0 ] ; then
	echo "Hora inicial HINIC: $HINIC"
	echo "Hora inicial HRINI: $HRINI"
	echo "Dia semana   _dow_: $_dow_"
	echo "Dia semana   _DOW_: $_DOW_"
	echo "Dia do mes   _DIA_: $_DIA_"
	echo "Mes          _MES_: $_MES_"
	echo "Ano (YYYY)   _ANO_: $_ANO_"
	echo "Data ISO     DTISO: $DTISO"
	echo "Programa    PRGEXE: $PRGEXE"
	echo "Nome PRG    PRGNAM: $PRGNAM"
	echo "Diretorio   PRGDIR: $PRGDIR"
	echo "Dir corr.   DIRINI: $DIRINI"
	echo "LComendo    ARG_IN: $ARG_IN"
	echo "Pt parada   CTSTOP: $CTSTOP"
	echo "Nivel DEBUG  N_DEB: $DEBUG"
	echo "Simulacao     FAKE: $FAKE"
	[ ! -z $PARM1 ] && echo "= Argumentos de chamada ====================="

	[ ! -z $PARM1 ] && echo "             PARM1: $PARM1"
	[ ! -z $PARM2 ] && echo "             PARM2: $PARM2"
	[ ! -z $PARM3 ] && echo "             PARM3: $PARM3"
	[ ! -z $PARM4 ] && echo "             PARM4: $PARM4"
	[ ! -z $PARM5 ] && echo "             PARM5: $PARM5"
	[ ! -z $PARM6 ] && echo "             PARM6: $PARM6"
	[ ! -z $PARM7 ] && echo "             PARM7: $PARM7"
	[ ! -z $PARM8 ] && echo "             PARM8: $PARM8"
	[ ! -z $PARM9 ] && echo "             PARM9: $PARM9"

	[ ! -z $PARM1 ] && echo "============================================="
fi
