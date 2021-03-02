#!/bin/bash

export DEBUG="0"
# BIT mapped variable
# BIT0 wait for a <ENTER> key
# BIT1 Display debug messages
# BIT2 Verbose debug mode

# ------------------------------------------------------------------------- #
# genmyKeys.sh - Gera minhas chaves RSA e DSA (nesta maquina)
# ------------------------------------------------------------------------- #
#     Entrada	Nenhuma
#  Parametros	1 se presente nao envia chave publica para FTP
#      Opcoes	-h | --help	Exibe mensagem de ajuda
#		-V | --version	Mostra a versao do programa
#		--changelog	Mostra o historico de alteracoes
#       Saida	Chaves geradas em ~/.ssh
#     Exemplo	genmyKey noxtm<ENTER>
#    Corrente	
# Objetivo(s)	Gerar ou sobre-escrever as chaves rsa
# Comentarios	
# Observacoes	EFETUAR CONFIGURACAO PROXIMO A MENSAGEM DE AJUDA
#       Notas	
# ------------------------------------------------------------------------- #
#  Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde
#     é um centro especialidado da Organização Pan-Americana da Saúde,
#           escritório regional da Organização Mundial da Saúde
#                        BIREME / OPS / OMS (P)2012
# ------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#       - Descricao
cat > /dev/null <<HISTORICO
vrs:  1.0.0 20120619, FJLopes
        - Edicao original
vrs:  1.0.1 20140214, FJLopes FLBrito
	- Correcao de sintaxe do codigo
HISTORICO

# =======
# FUNCOES
# =======
# PegaValor - Obtem valor de uma clausula
# PARM $1 - Item de configuracao a ser lido
# Obs: O arquivo a ser lido eh o contido na variavel CONFIG
#
PegaValor () {
        if [ -f "$CONFIG" ]; then
                grep "^$1" $CONFIG > /dev/null
                RETORNO=$?
                if [ $RETORNO -eq 0 ]; then
                        RETORNO=$(grep $1 $CONFIG | tail -n "1" | cut -d "=" -f "2")
                        echo $RETORNO
                else
                        false
                fi
        else
                false
        fi
        return
}
#
# =======

HINIC=$(date '+%s')
HRINI=$(date '+%Y.%m.%d %H:%M:%S')
TREXE=$(basename $0)
PRGDR=$(dirname $0)
LCORI=$*

# ------------------------------------------------------------------------- #
# CONFIGURACAO DEFAULT

TP_TRANSFER="ftp"
SERVERNAME="ftp"
FOLDERNAME="keys"
USERNAME="aot"
PASSWORD="13aot100"

# ------------------------------------------------------------------------- #
# Texto de ajuda de utilizacao do comando

AJUDA_USO="
Uso: $TREXE [OPCOES] [PARM1]

OPCOES:
 -h, --help           Exibe este texto de ajuda e para a execucao
 -V, --version        Exibe a versao corrente do comando e para a execucao
 --changelog          Exibe o historico de alteracoes

 -r, --rsa            Gera somente as chaves RSA
 -d, --dsa            Gera somente as chaves DSA

 --debug N            N = nivel de DEBUG [0-255]

 --transf ftp|scp|cp  Por FTP, SCP ou copia simples
 --server SERVERNAME  Nome de rede do servidor destino das chaves
 --folder DIR_NAME    Path para o diretorio com as chaves
 --user   USER_NAME   Nome de usuario para login
 --pass   PASSWORD    Senha para o login do usuario

PARAMETROS:
 PARM1   Qqr bloquea o envio da chave publica ao aot@ftp.bireme.br/keys
"

# ------------------------------------------------------------------------- #
# Texto de sintaxe do comando

SINTAXE="

Uso: $TREXE [OPCOES] [<noxmt>]

"

RSA="TRUE"
DSA="TRUE"

# -------------------------------------------------------------------------- #
# Tratamento das opcoes de linha de comando (qdo houver alguma)

while test -n "$1"
do
        case "$1" in

                -h | --help)
                        echo "$AJUDA_USO"
                        exit 0
                ;;
		
                -V | --version)
                        echo -e -n "\n$TREXE "
                        grep '^vrs: ' $PRGDR/$TREXE | tail -1
                        echo
                        exit 0
                ;;
		
		--debug)
			shift
			DBG="$1"
			DEBUG="$1"
		;;
		
		--transf)
			shift
			TP_TRANSFER=""
			[ "$1" = "ftp" ] && TP_TRANSFER="ftp"
			[ "$1" = "FTP" ] && TP_TRANSFER="ftp"
			[ "$1" = "scp" ] && TP_TRANSFER="scp"
			[ "$1" = "SCP" ] && TP_TRANSFER="scp"
			[ "$1" = "cp" ]  && TP_TRANSFER="cp"
			[ "$1" = "CP" ]  && TP_TRANSFER="cp"
		;;
		
		--server)
			shift
			SERVERNAME=""
			[ -n "$1" ] && SERVERNAME="$1"
		;;
		
		--folder)
			shift
			FOLDERNAME=""
			[ -n "$1" ] && FOLDERNAME="$1"
		;;
		
		--user)
			shift
			USERNAME=""
			[ -n "$1" ] && USERNAME="$1"
		;;
		
		--pass)
			shift
			PASSWORD=""
			[ -n "$1" ] && PASSWORD="$1"
		;;
		
		-r | --rsa)
			DSA="FALSE"
		;;
		
		-d | --dsa)
			RSA="FALSE"
		;;
		
                --changelog)
                        TOTLN=$(wc -l $0 | awk '{ print $1 }')
                        INILN=$(grep -n "<SPICEDHAM" $0 | tail -1 | cut -d ":" -f "1")
                        LINHAI=$(expr $TOTLN - $INILN)
                        LINHAF=$(expr $LINHAI - 2)
                        echo -e -n "\n$TREXE - "
                        tail -$LINHAI $0 | head -$LINHAF
                        echo
                        exit 0
                ;;
		
                *)
                        if [ $(expr index $1 "-") -eq 0 ]; then
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

# Verific se ha username e password para ftp
[ "$TP_TRANSFER" = "ftp" ] && [ -z "$USERNAME" ] && TP_TRANSFER=""
[ "$TP_TRANSFER" = "ftp" ] && [ -z "$PASSWORD" ] && TP_TRANSFER=""

# Ajusta o nome do diretorio em conjunto com o tipo de transferencia
if [ "$TP_TRANSFER" = "scp" ]; then
	A=$FOLDERNAME
	FOLDERNAME="/${A}"
fi

# Analisa o tipo de transferencia
if [ "$TP_TRANSFER" != "ftp" -a "$TP_TRANSFER" != "scp" -a "$TP_TRANSFER" != "cp" ]; then
	$TP_TRANSFER=""
	$SERVERNAME=""
	$FOLDERNAME=""
	$USERNAME=""
	$PASSWORD=""
fi

# ------------------------------------------------------------------------- #
#
#if [ -s "$CONFIG" ]; then
#        # Valores sao opcionais
#        TEMP=$(PegaValor PY);         [ -n "$TEMP" ] &&  USEPYTHON=$TEMP
#fi
#
# ------------------------------------------------------------------------- #
if [ "$DEBUG" -gt 1 ]; then
        echo "= DISPLAY DE VALORES INTERNOS ="
        echo "==============================="

        test -n "$PARM1" && echo "PARM1 = $PARM1"
        test -n "$PARM2" && echo "PARM2 = $PARM2"
        test -n "$PARM3" && echo "PARM3 = $PARM3"
        test -n "$PARM4" && echo "PARM4 = $PARM4"
        test -n "$PARM5" && echo "PARM5 = $PARM5"
        test -n "$PARM6" && echo "PARM6 = $PARM6"
        test -n "$PARM7" && echo "PARM7 = $PARM7"
        test -n "$PARM8" && echo "PARM8 = $PARM8"
        test -n "$PARM9" && echo "PARM9 = $PARM9"
        echo
	echo     "                DEBUG = $DEBUG"
	echo     "Tipo de transferencia = $TP_TRANSFER"
        echo     "     Nome do servidor = $SERVERNAME"
        echo     "            Diretorio = $FOLDERNAME"
	echo     "      Nome de usuario = $USERNAME"
	echo     "                Senha = $PASSWORD"

        echo "==============================="
        echo
fi

echo "[TIME-STAMP] $HRINI [:INI:] $TREXE $LCORI"
echo "[gmk]  1   - Gera chaves"

if [ "$RSA" = "TRUE" ]; then
	echo "[gmk]  2.01- Gera o par de chaves RSA"
	ssh-keygen -t rsa
	echo "[gmk]  2.02- Normaliza nome da chave publica para utilizacao"
	cp ~/.ssh/id_rsa.pub "${USER}-${HOSTNAME}-rsa.pub"
else
	echo "[gmk]  2.01- Nao gera chaves RSA"
fi

if [ "$DSA" = "TRUE" ]; then
	echo "[gmk]  3.01- Gera o par de chaves DSA"
	ssh-keygen -t dsa
	echo "[gmk]  3.02- Normaliza nome da chave publica para utilizacao"
	cp ~/.ssh/id_dsa.pub "${USER}-${HOSTNAME}-dsa.pub"
else
	echo "[gmk]  3.01- Nao gera chaves DSA"
fi

if [ -z "$PARM1" ]; then
	if [ "$DEBUG" -gt 1 ]; then
		echo "* Prepara o envio da chave publica"
	fi
	if [ "$RSA" = "TRUE" -o "$DSA" = "TRUE" ]; then
		if [ "$TP_TRANSFER" = "ftp" ]; then
			
			[ $(($DEBUG & 4)) ] && 	echo "* Envio por FTP"
			
			echo "[gmk]  4   - Envia para o servidor de FTP"
		        echo "[gmk]  4.01- Script de controle de sessao"
			echo "user ${USERNAME} ${PASSWORD}"                                            >  key.ftp
			echo "bin"                                                                     >> key.ftp
			echo "cd ${FOLDERNAME}"                                                        >> key.ftp
			[ -f "${USER}-${HOSTNAME}-rsa.pub" ] && echo "put ${USER}-${HOSTNAME}-rsa.pub" >> key.ftp
			[ -f "${USER}-${HOSTNAME}-dsa.pub" ] && echo "put ${USER}-${HOSTNAME}-dsa.pub" >> key.ftp
			echo "bye"                                                                     >> key.ftp
			
			echo "[gmk]  4.02- Envio efetivo iniciado"
			ftp -n -i -v ${SERVERNAME}                                                     <  key.ftp
		
			echo "[gmk]  5   - Limpa area de trabalho"
			rm key.ftp
		fi
		if [ "$TP_TRANSFER" = "scp" ]; then
			
			[ $(($DEBUG & 4)) ] && 	echo "* Envio por SCP"
			
			if [ -n "$USERNAME" ]; then
				[ -f "${USER}-${HOSTNAME}-rsa.pub" ] && scp "${USER}-${HOSTNAME}-rsa.pub" $USERNAME@$SERVERNAME:$FOLDERNAME
				[ -f "${USER}-${HOSTNAME}-dsa.pub" ] && scp "${USER}-${HOSTNAME}-dsa.pub" $USERNAME@$SERVERNAME:$FOLDERNAME
			else
				[ -f "${USER}-${HOSTNAME}-rsa.pub" ] && scp "${USER}-${HOSTNAME}-rsa.pub" $SERVERNAME:$FOLDERNAME
				[ -f "${USER}-${HOSTNAME}-dsa.pub" ] && scp "${USER}-${HOSTNAME}-dsa.pub" $SERVERNAME:$FOLDERNAME
			fi
		fi
		if [ "$TP_TRANSFER" = "cp" ]; then
			
			[ $(($DEBUG & 4)) ] && 	echo "* Envio por CP"
			
			[ -f "${USER}-${HOSTNAME}-rsa.pub" ] && cp "${USER}-${HOSTNAME}-rsa.pub" $FOLDERNAME
			[ -f "${USER}-${HOSTNAME}-dsa.pub" ] && cp "${USER}-${HOSTNAME}-dsa.pub" $FOLDERNAME
		fi
	else
		[ $(($DEBUG & 4)) ] && echo "* Sem chave para enviar"
	fi
else
	if [ "$DEBUG" -gt 1 ]; then
		echo "* Nao havera envio de chave publica"
	fi
fi

HRFIM=$(date '+%Y.%m.%d %H:%M:%S')
HFINI=$(date '+%s')
TPROC=$(expr $HFINI - $HINIC)

echo "[TIME-STAMP] $HRFIM [:FIM:] $TREXE $LCORI"
# ------------------------------------------------------------------------- #
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
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20120619 Versao inicial do gterador de chave publica (e privada) RSA
20120621 Inclusao das opcoes de envio de chaves para "colecao"
20140214 Correcao de codigo com erro de sintaxe na linha 227 da versao 1.0.0
SPICEDHAM

