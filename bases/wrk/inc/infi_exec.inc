# -------------------------------------------------------------------------- #
# Anota dados de inicio de execucao
CURRD=$(pwd);				# Diretorio corrente
HINIC=$(date '+%s');			# Hora de inicio em segundos desde 1/1/1970
HRINI=$(date '+%Y%m%d %H:%M:%S');	# Hora de inicio no formato YYYYmmdd hh:mm:ss
_DIA_=$(date '+%d');			# Dia corrente (dd)
_MES_=$(date '+%m');			# Mes corrente (mm)
_ANO_=$(date '+%Y');			# Ano corrente (YYYY)
TREXE=$(basename $0);			# Denominacao do programa em execucao
PRGDR=$(dirname $0);			# Path para o programa em execucao
LCORI=$*;				# Linha de comando original da chamada
DTFJL=${_ANO_}${_MES_}${_DIA_};		# Data calendario no formato YYYYMMDD (depreciar)
DTISO=${_ANO_}${_MES_}${_DIA_};		# Data calendario no formato YYYYMMDD

# ========================================================================== #
# Funcoes de uso geral podem ser colocadas aqui
# ========================================================================== #
# isNumber	Determina se o parametro eh (TRUE) ou nao (FALSE) numerico
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

