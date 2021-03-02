#!/bin/bash
# ------------------------------------------------------------------------- #
# chkMxI.sh - Confere se master eh mais antigo que arquivo invertido
# ------------------------------------------------------------------------- #
#      Entrada: <arquivo_master> <arquivo_invertido> iy0
#        Saida: fatal
#     Corrente: 
#      Chamada: chkMF_IF.sh <arquivo_master> <arquivo_invertido> iy0
#      Exemplo: chkMF_IF.sh teste1 teste2 iy0
#  Comentarios: o terceiro parametro eh necessario se o arquivo invertido for iy0,
#               se estiver ausente, sera considerado arquivo com extensao cnt
#  Observacoes: Observacoes relevantes para o processamento
# Dependencias: Relacoes de dependencia para execucao, como arquivos
#                 auxiliares esperados, estrutura de diretorios, etc.
#               NECESSARIAMENTE entre o servidor de trigramas e esta maquina
#                 deve haver uma CHAVE PUBLICA DE AUTENTICACAO, de forma que
#                 seja dispensada a interacao com operador para os processos
#                 de transferencia de arquivos.
#
#              --> chkMxI.sh
#                          |
#                          + calc_date.sh
#
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis             Comentarios
# 20090721  Fabio Brito              Edicao original
#
# ------------------------------------------------------------------------- #

TPR="start"
. log

# HINIC=`date '+%s'`
# HRINI=`date '+%Y.%m.%d %H:%M:%S'`
# echo "[TIME-STAMP] Em `date '+%Y.%m.%d %H:%M:%S'`  iniciando  $0 $1 $2 $3 $4 $5"

# # Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
# #  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
# LGDTC=`pwd`
# # Determina o primeiro diretorio da arvore do diretorio corrente
# LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# # Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
# LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# # Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
# LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# # Se nao existe cria diretorio para OUTs diversos
# [ -d $LGRAIZ/$LGPRD/outs/ ] || mkdir $LGRAIZ/$LGPRD/outs/

# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
#               S E U   C O D I G O   P A R T E   D A Q U I                 #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #


# Verifica a passagem do parametro
if [ "$#" -ne 3 ]
then 
	if [ "$#" -ne 2 ]
	then
		echo "Use"
		echo "comando: ./chk_mst_inv.sh <MF> <IF> iy0"
		echo "   onde: <MF> corresponde ao arquivo da base com extensao mst"
		echo "         <IF> corresponde ao arquivo com extensao cnt"
		echo "         iy0 - indica se o arquivo invertido a ser observado eh iy0, se"
		echo "               ausente eh considerado cnt"
		exit 1
	fi
fi

if [ "$#" != 3 ] # Verifica a existencia do 3o. parametro
then
	# Verifica a existencia do arquivo MST
	if [ ! -s "$1".mst ]
	then
		echo "Nao existe o arquivo $1.mst"
		exit 1
	fi
        # Verifica a existencia do arquivo CNT
        if [ ! -s "$2".cnt ]
        then
                echo "Nao existe o arquivo $2.cnt"
                exit 1
        fi
else
        # Verifica a existencia do arquivo IY0
        if [ ! -s "$2".iy0 ]
        then
                echo "Nao existe o arquivo $2.iy0"
                exit 1
        fi
fi

# Dados do MASTER #########################################################################
echo `ls -l $1.mst` > tmpmst
ARQ_MST=`more tmpmst`
rm tmpmst

MES_MST=`echo $ARQ_MST | cut -d" " -f "6"`
DIA_MST=`echo $ARQ_MST | cut -d" " -f "7"`

if [ $DIA_MST -lt 10 ] #Formatando dia para 2 caracteres
then
	DIA_MST="0$DIA_MST"
fi

HORA_MST=`echo $ARQ_MST | cut -d" " -f "8"`

case $MES_MST in
        Jan) MES_MST=01;;
        Feb) MES_MST=02;;
        Mar) MES_MST=03;;
        Apr) MES_MST=04;;
        May) MES_MST=05;;
        Jun) MES_MST=06;;
        Jul) MES_MST=07;;
        Aug) MES_MST=08;;
        Sep) MES_MST=09;;
        Oct) MES_MST=10;;
        Nov) MES_MST=11;;
        Dec) MES_MST=12;;
esac

DOIS_PONTOS=`echo $HORA_MST | cut -c3-3` # Procura : na posicao da hora, se nap houver sera considerado ano

if [ $DOIS_PONTOS != ":" ]
then
	ANO=$HORA_MST	
	HORA="00"
	MINUTO="00"
else
	ANO="`date '+%Y'`"
	HORA=`echo $HORA_MST | cut -c0-2`
	MINUTO=`echo $HORA_MST | cut -c4-6`
fi

# Montando a data para MASTER
DT_MST="$DIA_MST$MES_MST$ANO$HORA$MINUTO"

MOSTRA_MASTER="Arquivo $1.mst:($DIA_MST/$MES_MST/$ANO $HORA:$MINUTO)"

export MOSTRA_MASTER

unset DOIS_PONTOS
unset ANO
unset HORA
unset MINUTO

# Dados do arquivo invertido #############################################################
if [ "$#" != 3 ]
then # Se eh CNT------------------------------

	echo `ls -l $2.cnt` > tmpcnt
	ARQ_CNT=`more tmpcnt`
	rm tmpcnt

	MES_CNT=`echo $ARQ_CNT | cut -d" " -f "6"`
	DIA_CNT=`echo $ARQ_CNT | cut -d" " -f "7"`

	if [ $DIA_CNT -lt 10 ] #Formatando dia para 2 caracteres
	then
	        DIA_CNT="0$DIA_CNT"
	fi

	HORA_CNT=`echo $ARQ_CNT | cut -d" " -f "8"`

	case $MES_CNT in
	        Jan) MES_CNT=01;;
	        Feb) MES_CNT=02;;
	        Mar) MES_CNT=03;;
	        Apr) MES_CNT=04;;
	        May) MES_CNT=05;;
	        Jun) MES_CNT=06;;
	        Jul) MES_CNT=07;;
	        Aug) MES_CNT=08;;
	        Sep) MES_CNT=09;;
	        Oct) MES_CNT=10;;
	        Nov) MES_CNT=11;;
	        Dec) MES_CNT=12;;
	esac

	DOIS_PONTOS=`echo $HORA_CNT | cut -c3-3` # Procura : na posicao da hora, se nap houver sera considerado ano

	if [ $DOIS_PONTOS != ":" ]
	then
	        ANO=$HORA_CNT
	        HORA="00"
	        MINUTO="00"
	else
	        ANO="`date '+%Y'`"
	        HORA=`echo $HORA_CNT | cut -c0-2`
	        MINUTO=`echo $HORA_CNT | cut -c4-6`
	fi

	# Montando a data para INVERTIDO CNT
	DT_CNT="$DIA_CNT$MES_CNT$ANO$HORA$MINUTO"

	MOSTRA_INV="$2.cnt:($DIA_CNT/$MES_CNT/$ANO $HORA:$MINUTO)"

	export MOSTRA_INV

        unset DOIS_PONTOS
        unset ANO
        unset HORA
        unset MINUTO

else # Se eh IY0----------------------------------------

        echo `ls -l $2.iy0` > tmpiy0
        ARQ_IY0=`more tmpiy0`
        rm tmpiy0

        MES_IY0=`echo $ARQ_IY0 | cut -d" " -f "6"`
        DIA_IY0=`echo $ARQ_IY0 | cut -d" " -f "7"`

        if [ $DIA_IY0 -lt 10 ] #Formatando dia para 2 caracteres
        then
                DIA_IY0="0$DIA_IY0"
        fi

        HORA_IY0=`echo $ARQ_IY0 | cut -d" " -f "8"`

        case $MES_IY0 in
                Jan) MES_IY0=01;;
                Feb) MES_IY0=02;;
                Mar) MES_IY0=03;;
                Apr) MES_IY0=04;;
                May) MES_IY0=05;;
                Jun) MES_IY0=06;;
                Jul) MES_IY0=07;;
                Aug) MES_IY0=08;;
                Sep) MES_IY0=09;;
                Oct) MES_IY0=10;;
                Nov) MES_IY0=11;;
                Dec) MES_IY0=12;;
        esac

        DOIS_PONTOS=`echo $HORA_IY0 | cut -c3-3` # Procura : na posicao da hora, se nao houver sera considerado ano

        if [ $DOIS_PONTOS != ":" ]
        then
                ANO=$HORA_IY0
                HORA="00"
                MINUTO="00"
        else
                ANO="`date '+%Y'`"
                HORA=`echo $HORA_IY0 | cut -c0-2`
                MINUTO=`echo $HORA_IY0 | cut -c4-6`
        fi

        # Montando a data para INVERTIDO IY0
        DT_IY0="$DIA_IY0$MES_IY0$ANO$HORA$MINUTO"

        # echo "Data INVERTIDO ($2.iy0): $DIA_IY0/$MES_IY0/$ANO $HORA:$MINUTO"

        MOSTRA_INV="$2.iy0:($DIA_IY0/$MES_IY0/$ANO $HORA:$MINUTO)"

	export MOSTRA_INV

        unset DOIS_PONTOS
        unset ANO
        unset HORA
        unset MINUTO
fi

# Verificacao
if [ "$#" != 3 ]
then # Se eh CNT------------------------------
	calc_date.sh $DT_MST $DT_CNT
else
	calc_date.sh $DT_MST $DT_IY0
fi



# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
#              S E U   C O D I G O   T E R M I N A   A Q U I                #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
# Gera relatorio de processamento

## #     12345678901
## echo "13       - Gera relatorio de dados de processamento"
## tpl.org/statis.sh

# ------------------------------------------------------------------------- #
# Contabiliza tempo de processamento e gera relato da ultima execucao
# echo ""
# echo "[TIME-STAMP] Em `date '+%Y.%m.%d %H:%M:%S'` terminando  $0 $1 $2 $3 $4 $5"
# HRFIM=`date '+%Y.%m.%d %H:%M:%S'`
# HFINI=`date '+%s'`
# TPROC=`expr $HFINI - $HINIC`
# echo "Tempo decorrido: $TPROC"

# # Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
# #  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
# LGDTC=`pwd`
# # Determina o primeiro diretorio da arvore do diretorio corrente
# LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# # Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
# LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# # Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
# LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# # Determina o nome do Shell chamado (sem o eventual path)
# LGPRC=`expr "/$0" : '.*/\(.*\)'`

# echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]">>$LGRAIZ/$LGPRD/outs/$LGPRC.tim
# echo "Tempo transcorrido: $TPROC [s]"

# echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HINIC}</INICIO_PROC>"  > $LGRAIZ/$LGPRD/time_ldd_${1}.txt
# echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HFINI}</FIM_PROC>"       >> $LGRAIZ/$LGPRD/time_ldd_${1}.txt
# echo " <DURACAO_PROC UNIT=\"SEC\">${TPROC}</DURACAO_PROC>"                         >> $LGRAIZ/$LGPRD/time_ldd_${1}.txt

# unset HINIC
# unset HFINI
# unset TPROC

TPR="end"
. log

