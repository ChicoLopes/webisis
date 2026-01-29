# Opcoes a implementar
# -H, --homolog HOST     Servidor de homologacao
# -o, --output NOMEARQU  Gera Arquivo com os resultados
# -p, --producao HOST    Servidor de producao
# -x  --excel            Gera uma saida excel (csv) para exportacao
# Mensagem de ajuda e tratamento de opcoes do processamento
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
AJUDA_USO="
Efetua teste comparativo [detalhado] entre os servidores de homologação e de
produção com base na lista de locais contida em testar.rol

Uso: $TREXE [-h|-V|--changelog] [-d NIVEL] [-c ARQU] [-H serverofi4.bireme.br] [-p db02dx.bireme.br] [<INDEX>]

OPCOES:
 --changelog         Exibe o historico de alteracoes e para a execucao
 -c, --config ARQU   Configuracao em ARQV
 -d, --debug NIVEL   Define nivel de depuracao com valor numerico positivo
 -h, --help          Exibe este texto de ajuda e para a execucao
 -V, --version       Exibe a versao corrente e para a execucao

PARAMETROS:
 INDEX  [opcional] Nome da instancia a testar em detalhes (vide OBS.)

OBS.: Deve haver um arquivo de configuração correspondente disponível, por
	exemplo, para a chamada $TREXE regional, é esperada a existência
	do arquivo regional.conf
"

# -------------------------------------------------------------------------- #
# Tratamento das opcoes de linha de comando (qdo houver alguma)
while test -n "$1"
do
	case "$1" in

		-c | --config)
			shift
			CONFIG="$1"
			if [ ! -s "$PATH_EXEC/tabs/$CONFIG" ]; then
				echo "Arquivo de configuracao $CONFIG nao localizado ou vazio"
				exit 1
			fi
			;;

		-H | --homolog)
			shift
			SRVHOM="$1"
			[ -z $SRVHOM ] && SRVHOM="serverofi4.bireme.br"
			echo "[viahx]            - Testa contra o servidor de homologacao: $SRVHOM"
			;;

		-p | --producao)
			shift
			SRVPRD="$1"
			[ -z $SRVPRD ] && SRVPRD="db02dx.bireme.br"
			echo "[viahx]            - Testa contra o servidor de producao: $SRVPRD"
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

