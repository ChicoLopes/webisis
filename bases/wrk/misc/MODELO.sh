#!/bin/bash
export DEBUG="0"; # 0-Sem debug / 1-Aguarda tecla <ENTER> / 2-Mostra valores
# ------------------------------------------------------------------------- #
# Shell_name.sh - Descricao de uma linha para o arquivo shell
# ------------------------------------------------------------------------- #
#      Entrada : Parametros e arquivos de entrada do shell
#        Saida : Saidas geradas pelo shell
#     Corrente : diretorio corrente para inicio de execucao
#      Chamada : path/Shell_name.sh parm1 parm2 parm3 parm4 ...
#      Exemplo : Linha de comando exemplo de chamada
#  Objetivo(s) : Gerar contagem, lista ou qqr coisa
#  Comentarios : Todo e qualquer comentario sobre algoritmo, metodos,
#                 descricao de arquivos e etc.
#  Observacoes : Observacoes relevantes para o processamento
#                Descricao breve de fluxo da execucao
#        Notas : A estrutura de diretorios esperada eh mostrada a seguir:
#                  /bases
#                  /bases/yyy.nnn               ; raiz do processamento
#                  /bases/yyy.nnn/tpl.yyy       ; arquivos de script
#                  /bases/yyy.nnn/outs          ; mensagens de saida
#                  /bases/yyy.nnn/tabs          ; arquivos Tab diversos
#                  /bases/yyy.nnn/yyy.yyy       ; diretorio de processamento
#                  /bases/yyy.nnn/temp          ; Temporario local
#
#                      nnn em geral valera 000
# Dependencias : Relacoes de dependencia para execucao, como arquivos
#                  auxiliares esperados, estrutura de diretorios, etc.
#                NECESSARIAMENTE entre o servidor de trigramas e esta maquina
#                  deve haver uma CHAVE PUBLICA DE AUTENTICACAO, de forma que
#                  seja dispensada a interacao com operador para os processos
#                  de transferencia de arquivos.
# ------------------------------------------------------------------------- #
#  Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde
#     é um centro especialidado da Organização Pan-Americana da Saúde,
#           escritório regional da Organização Mundial da Saúde
#                        BIREME / OPS / OMS (P)2011
# ------------------------------------------------------------------------- #
# Historico
# versao data, Responbsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 20110825, MBottura/HBarbieri/FLBrito/FJLopes
	- Edicao original
HISTORICO

# ========================================================================= #
#                                  Funcoes                                  #
# ========================================================================= #

## ========================================================================= #
## function_name - Finalidade da funcao em texto resumido
## PARM $1 - Descricao do parametro 1
## PARM $N - Descricao do parametro N
#
#funcao1 () {
#}
#
## ========================================================================= #

# ------------------------------------------------------------------------- #
# Para permitir disparar remotamente (de outro servidor) uma rotina, deve-se
# estabelecer o ambiente operacional antes da chamada de recursos 
# que dependam de, por exemplo, PATH.
# ATENCAO: O script chamado remotamente pode estar em qqr lugar do F.S., mas
#          o diretorio corrente sera o $HOME do usuario da chamada
#
# Enquanto a 'sessao' durar a maquina remota (chamadora) sera o CONSOLE OUT
# o que implica em termos lah as saidas dos echos daqui
# ------------------------------------------------------------------------- #
#. /usr/local/bireme/misc/profile.sh
#export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$LINDG4:$MISC:$PROCS
# ------------------------------------------------------------------------- #

TPR="start"
source log

if [ "$DEBUG" -gt 1 ]; then
	clear
	echo "*****"
	echo "** Chave de depuracao (\$DEBUG) esta ativa nesta execucao"
	echo "*****"
	echo
fi

HINIC=$(date '+%s')
HRINI=$(date '+%Y.%m.%d %H:%M:%S')
TREXE=$(basename $0)
PRGDR=$(dirnamer $0)
echo "[TIME-STAMP] $HRINI [:INI:] $TREXE $1 $2 $3 $4 $5"

# ------------------------------------------------------------------------- #
# Ajustes de ambiente

# Determina caminho absoluto para escrever o arquivo de parametros do CISIS
# (/bases/yyy.nnn/...)
# ($LGRAIZ/$LGPRD/...)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Se nao existe cria diretorio para OUTs diversos
[ -d $LGRAIZ/$LGPRD/outs/ ] || mkdir $LGRAIZ/$LGPRD/outs/

#export CIPAR=$TABS/GBASE.cip

unset	LGDTC	LGRAIZ	LGPRD

## -------------------------------------------------------------------------- #
## Detecta e extrai opcao de chamada

unset OPCAO
OPTERR=0
## Neste exemplo soh avalia a opcao X, novas opcoes basta acrescentar na cadeia
while getopts 'xX' OPT_LETTER
do
        OPCAO=$OPT_LETTER
done

USED_UP=$(expr $OPTIND - 1)
shift $USED_UP

echo

## Opcao informada eh desconhecida, neste exemplo mostramos a sintaxe
if [ ".$OPCAO" = ".?" ]; then
        TPR="fatal"
        MSG="SINTAXE: $TREXE [-X|]     (-X causes not send results to other servers)"
        source log
        echo
fi

## Neste exemplo a caixa nao nos interessa
OPCAO=$(echo $OPCAO | tr [:lower:] [:upper:])

## Neste exemplo torna explicito o efeito da opcao informada
echo "==========================================================="

if [ ".$OPCAO" = ".X" ]; then
        echo "= ATENCAO: As bases NAO serao enviadas para a homologacao ="
else
        echo "= ATENCAO: As bases  SERAO  enviadas para a homologacao   ="
fi

echo "==========================================================="
echo

## Aa saida o parametro 1 pode ser coletado como $1 normalmente e assim por diante

## ------------------------------------------------------------------------- #
## Emite e-mail lembrete de OS:: Atualizacao ao OFI
#cat >mensagem.txt <<!
#Mande o email OS:: Atualizacao do XXXXXX
#!
#
#mail -s "OS:: [XXXXXX] $(date '+%d/%m/%y') - XXXXXX.br - Liberar teste.xxxxxx.br" nome.sobrenome@bireme.org < mensagem.txt
#rm mensagem.txt
#
## ------------------------------------------------------------------------- #

#### COMECO DO SHELL
#     12345678901234567890
echo "[sh_ID]  n         - Texto alusivo ao que esta sendo feito no momento"
echo "[sh_ID] nn.nn.nn.nn- Texto alusivo ao que esta sendo feito no momento"

sleep 5

# ------------------------------------------------------------------------- #
# Limpa area de trabalho
[ -f "arquivo.x" ] && rm -f arquivo.x

#### TERMINO DO SHELL

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:FIM:] $TREXE $1 $2 $3 $4 $5"
# ------------------------------------------------------------------------- #
# Gera relatorio de processamento

#       12345678901234567890
# echo "[shell_ID] nn      - Gera relatorio de dados de processamento"
# tpl.yyy/statis.sh

# ------------------------------------------------------------------------- #
#unset CIPAR
# Contabiliza tempo de processamento e gera relato da ultima execucao

HRFIM=$(date '+%Y.%m.%d %H:%M:%S')
HFINI=$(date '+%s')
TPROC=$(expr $HFINI - $HINIC)

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=$(pwd)
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/$(echo "$LGDTC" | cut -d/ -f2)
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=$(expr "$LGDTC" : '/[^/]*/\([^/]*\)')

echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]" >> $LGRAIZ/$LGPRD/outs/$TREXE.tim
echo -n "[$TREXE] Tempo decorrido: "

[ -z "$TPROC" ] && TPROC=0

MTPROC=$(expr $TPROC % 3600)
HTPROC=$(expr $TPROC - $MTPROC)
HTPROC=$(expr $HTPROC / 3600)
STPROC=$(expr $MTPROC % 60)
MTPROC=$(expr $MTPROC - $STPROC)
MTPROC=$(expr $MTPROC / 60)

         printf "%02d:%02d:%02d" $HTPROC $MTPROC $STPROC
THUMAN=$(printf "%02d:%02d:%02d" $HTPROC $MTPROC $STPROC)

echo " ou  $TPROC [s]"

## Registro opcional. Fragmento XML relatando inicio fim e duracao (tudo em segundos)
# echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HINIC}</INICIO_PROC>"  > $LGRAIZ/$LGPRD/outs/time_$TREXE.txt
# echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HFINI}</FIM_PROC>"       >> $LGRAIZ/$LGPRD/outs/time_$TREXE.txt
# echo " <DURACAO_PROC UNIT=\"SEC\">${TPROC}</DURACAO_PROC>"                         >> $LGRAIZ/$LGPRD/outs/time_$TREXE.txt
# echo " <DURACAO_PROC UNIT=\"HUMAN\">${THUMAN}</DURACAO_PROC>"                      >> $LGRAIZ/$LGPRD/outs/time_$TREXE.txt

## ------------------------------------------------------------------------- #
## Emite e-mail de DOC:: Atualizacao ao OFI
#cat >mensagem.txt <<!
#Termino de execucao ...
#
#Nao foram relatados erros conhecidos durante o processamento.
#
#Obs: Tempo de execucao de $TREXE em $HRINI: $TPROC [s] ou $THUMAN
#!
#
#mail -s "DOC:: [xxxxxxx] Geracao de qualquer coisa ai - `date '+%d/%m/%y'` - blablabla" nome.sobrenome@bireme.org < ./mensagem.txt
#rm mensagem.txt
## ------------------------------------------------------------------------- #

unset	HINIC	HFINI	TREXE	TPROC
unset	MTPROC	HTPROC	STPROC	THUMAN
unset	LGDTC	LGRAIZ	LGPRD

TPR="end"
source log
# ------------------------------------------------------------------------- #

