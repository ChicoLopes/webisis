# -------------------------------------------------------------------------- #
# Anota hora de termino e calcula duracao em segundos e humana
echo "-Procedimentos terminados"
HRFIM=$(date '+%Y%m%d %H:%M:%S');	# Hora de fim de execucao no formato YYYYMMDD hh:mm:ss
HFINI=$(date '+%s');			# Hora de fim de execucao em segundos desde 1/1/1970
TPROC=$(expr $HFINI - $HINIC);		# Tempo de processamento em segundos
MTPROC=$(expr $TPROC % 3600);		# 
HTPROC=$(expr $TPROC - $MTPROC);	# 
HTPROC=$(expr $HTPROC / 3600);		# Horas de processamento
STPROC=$(expr $MTPROC % 60);		# Segundos de processamento
MTPROC=$(expr $MTPROC - $STPROC);	# 
MTPROC=$(expr $MTPROC / 60);		# Minutos de processamento
THUMAN=$(printf "%02d:%02d:%02d" $HTPROC $MTPROC $STPROC);	# Horas : Minutos : Segundos de processamento
echo
echo "Tempo de execucao de $TREXE em $HRINI: $TPROC [s] ou $THUMAN"
echo "[TIME-STAMP] $HRFIM [:FIM:] $TREXE $LCORI"

unset	HRINI	HRFIM	HINIC	HFINI
unset	TPROC	HTPROC	MTPROC	STPROC	THUMAN
unset	_DIA_	_MES_	_ANO_	DTFJL
unset	CURRD	TREXE	PRGDR	LCORI
