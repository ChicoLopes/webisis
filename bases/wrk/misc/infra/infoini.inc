# -------------------------------------------------------------------------- #
# Anota dados de inicio de execucao
HINIC=$(date '+%s');			# Hora de inicio em segundos desde 1/1/1970
HRINI=$(date '+(%w) %F %T');		# Hora de inicio no formato (DOW) YYYY-mm-dd hh:mm:ss
_DOW_=$(date '+%u');			# dia da semana de 0(domingo) a 6(sabado)
_DIA_=$(date '+%d');			# Dia corrente (dd)
_MES_=$(date '+%m');			# Mes corrente (mm)
_ANO_=$(date '+%Y');			# Ano corrente (YYYY)
TREXE=$(basename $0);			# Denominacao do programa em execucao
PRGDR=$(dirname $0);			# Path para o programa em execucao
LCORI=$*;				# Linha de comando original da chamada
DTISO=${_ANO_}-${_MES_}-${_DIA_};	# Data calendario no formato YYYY-MM-DD
N_DEB=0

# ========================================================================== #
# Funcoes de uso geral podem ser colocadas aqui
# ========================================================================== #

# isNumber	Determina se o parametro eh (TRUE) ou nao (FALSE) numerico
# -------------------------------------------------------------------------- #
# PARM $1	String a verificar se eh ou nao numerica
# Observ.	Baseado no fato que `-eq` soh funciona bem com numeros
#		 testa se o parametro eh numericamente igual a asi proprio
#		 descarta a eventual mensagem de erro (/dev/null) e
#		 devolve o resultado do proprio teste
#
isNumber() {
	[ "$1" -eq "$1" ] 2> /dev/null
	return $?
}

# rdConfig	Le o item de configuracao indicado no parametro
# -------------------------------------------------------------------------- #
# PARM $1	Item de configuracao a ser lido
# Observ.	O arquivo a ser lido eh o contido na variavel CONFIG com
#		 regras de caminho (corrente/relativo/absoluto) do S.O.
#
rdConfig () {
        if [ -f "$CONFIG" ]; then
                grep "^$1" $CONFIG > /dev/null
                RETORNO=$?
                if [ $RETORNO -eq 0 ]; then
                        RETORNO=$(grep "^$1" $CONFIG | tail -n "1" | cut -d "=" -f "2")
                        echo $RETORNO
                else
                        false
                fi
        else
                false
        fi
        return
}

# rdBreak
# -------------------------------------------------------------------------- #
# Verifica se deve interromper a execucao
# Observ	Atrelado com BIT7 da variavel DEBUG
# 
function rdBreak {
	[ $(($DEBUG & $_BIT0_)) -eq 1 ] && read -p "==> ATENCAO: Tecle \"pare<ENTER>\" para interromper a execucao): " LIDO
	[ "$LIDO" = "pare" ]            && echo    "==> execucao interrompida pelo operador" && exit 255
}

# hms
# -------------------------------------------------------------------------- #
# PARM $1	Numero de segundos a ser convertido
# Observ.	Converte segundos em horas minutos e segundos

function hms {
	seg=$(($1 % 3600))
	hor=$(( $(($1 - $seg)) / 3600))
	sec=$(($seg % 60))
	min=$(( $(($seg - $sec)) / 60))
	printf "%02d:%02d:%02d" $hor $min $sec
}

# chkError	
# -------------------------------------------------------------------------- #
# PARM $1	Mensagem de erro a ser exibida no STDOUT
# Observ.	
#
# OLD VERSION
#function chkError {
#        LSTERR=$?
#        [ ${LSTERR} -ne 0 ] && echo "fatal: ${1} (${LSTERR})" && exit ${LSTERR}
#}
# NEW VERSION
#   PARM1 com o codigo de retorno a ser testado
#   PARM2 com o texto para exibicao em caso de erro
# $NOERRO com o flag de nao parar por erro (variavel global para o ambiente)
# Retorno com o codigo de erro recebido e mensagem no STDOUT

# Chamada  chkError <ERR_COD> <FAIL_MSG>
# Exemplo  chkError $? "Indexing lil_regional.xml"
#          chkError $RSP "Indexing lil_regional.xml"

function chkError {
	if [ -z "$NOERRO" -o "$NOERRO" = "0" ]; then
	        if [ "${1}" -ne "0" ]; then
	                echo "*** FAIL +++ ${2}  *** EXIT CODE (${1}) ***"
	                exit ${1}
	        fi
	else
	        [ "${1}" -ne "0" ] && echo "*** WARNING +++ ${2}  *** RETURN CODE (${1}) ***"
	fi
}

# ========================================================================== #
echo "[TIME-STAMP] $HRINI [:INI:] $TREXE $LCORI"

