# -------------------------------------------------------------------------- #
# Anota hora de termino e calcula duracao em segundos e humana
[ "$N_DEB" != "0" ] && echo " = = =>  -Procedimentos terminados"
HRFIM=$(date '+(%w) %F %T');					# Hora de fim de execucao no formato YYYYMMDD hh:mm:ss
HFINI=$(date '+%s');						# Hora de fim de execucao em segundos desde 1/1/1970
TPROC=$(expr $HFINI - $HINIC);					# Tempo de processamento em segundos
THUMAN=$(hms $TPROC)
echo "Tempo de execucao de $TREXE $LCORI de $HRINI ate $HRFIM = $(printf "%7d" $TPROC)[s] ou $THUMAN"
echo "[TIME-STAMP] $HRFIM [:FIM:] $TREXE $LCORI"

#unset	HRINI	HRFIM	HINIC	HFINI
#unset	TPROC	HTPROC	MTPROC	STPROC	SRPTOC	THUMAN
#unset	_DIA_	_MES_	_ANO_	DTISO
#unset	TREXE	PRGDR	LCORI

