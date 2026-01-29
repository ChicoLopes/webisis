#!/bin/bash
# ------------------------------------------------------------------------- #
# delif - Apaga cnt; iyp; ifp; l0?; ly?; e n0? do invertido indicado
# ------------------------------------------------------------------------- #
#     Entrada : PARM1 com o nome do arquivo invertido a ser 'eliminado'
#       Saida : Arquivos apagados caso existam
#    Corrente : Diretorio com os componentes a serem apagados
#     Chamada : delif.sh <BASE_IF>
#     Exemplo : delif.sh contav30
# Observacoes : delif.sh deve estar gravado em diretorio contido no PATH
#     ATENCAO : Apaga componentes de LIND ou nao LIND indiferentemente
#                 e os intermediarios .ln1 e .ln2
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis               Comentarios
# 20090300  Rogerio Mugnaini           Edicao original
# 20091019  MMBottura/FLBrito/FJLopes  Adaptacao para uso em $PROCS
#

if [ $# -ne "1" ]
then
	echo "nothing to do"
	exit
fi

[ -f $1.cnt ] && rm $1.cnt
[ -f $1.n01 ] && rm $1.n01
[ -f $1.n02 ] && rm $1.n02
[ -f $1.l01 ] && rm $1.l01
[ -f $1.l01 ] && rm $1.l02
[ -f $1.ly1 ] && rm $1.ly1
[ -f $1.ly2 ] && rm $1.ly2
[ -f $1.ln1 ] && rm $1.ln1
[ -f $1.ln2 ] && rm $1.ln2
[ -f $1.ifp ] && rm $1.ifp
[ -f $1.iyp ] && rm $1.iyp

#
