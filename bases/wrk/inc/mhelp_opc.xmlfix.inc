# Mensagem de ajuda e tratamento de opcoes do processamento
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
AJUDA_USO="
Uso: $TREXE [-h|-V|--changelog] [-d N] [-c] <FILENAME> [INSTANCIA]

OPCOES:
 --changelog        Exibe o historico de alteracoes e para a execucao
 -d, --debug NIVEL  Define nivel de depuracao com valor numerico positivo
 -c, --config       Ignora detecao de erros
 -h, --help         Exibe este texto de ajuda e para a execucao
 -V, --version      Exibe a versao corrente e para a execucao

PARAMETROS:
 FILENAME   Nome do arquivo XML a ser reformado (sem extensao)
 INSTANCIA  Identificador unico do indice a ser preprocessado

SAIDA:
 Oferece um arquivo com o resultado do reparo/modificacao adicionando
 ao nome o sufixo '_good', seja no diretorio de origem (conforme PARM1),
 seja no diretorio do INBOX (xml-inbox/INSTANCIA), seja no diretorio
 corrente para as opção de arquivos de configuração (schem ou solrconfig)

"

# -------------------------------------------------------------------------- #
   FOUND="0"
   INBOX="0"
  NODATA="0"
OPC_CONF=""

# Tratamento das opcoes de linha de comando (qdo houver alguma)
while test -n "$1"
do
	case "$1" in

		-c | --config)
			  NODATA="1"
			OPC_CONF="-c"
			;;

		-h | --help)
			echo -e -n "\n$TREXE "
			grep '^vrs: ' $PRGDR/$TREXE | tail -1
			echo "$AJUDA_USO"
			exit
			;;

		-V | --version)
			echo -e -n "\n$TREXE "
			grep '^vrs: ' $PRGDR/$TREXE | tail -1
			echo
			exit
			;;

		-d | --debug)
			shift
			isNumber $1
			[ $? -ne 0 ] && echo -e "\n$TREXE: O argumento da opcao DEBUG deve existir e ser numerico.\n$AJUDA_USO" && exit 2
			DEBUG=$1
			N_DEB=$(expr $(($DEBUG & 6)) / 2)
			FAKE=$(expr $(($DEBUG & _BIT7_)) / 128)
			;;

		--changelog)
			TOTLN=$(wc -l $0 | awk '{ print $1 }')
			INILN=$(grep -n "<SPICEDHAM" $0 | tail -1 | cut -d ":" -f "1")
			LINHAI=$(expr $TOTLN - $INILN)
			LINHAF=$(expr $LINHAI - 2)
			echo -e -n "\n$TREXE "
			grep '^vrs: ' $PRGDR/$TREXE | tail -1
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

