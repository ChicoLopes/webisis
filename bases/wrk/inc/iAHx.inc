
# ========================================================================== #
#                                  FUNCOES
# ========================================================================== #
# Abortar - Interrompe a execucao de um shell por erro sinalizado
# PARM $1 - Nivel de erro a ser sinalizado
# Obs.:   -
#
abEND() {
	echo "[p_inbox]  1.01.01   - Nao ha dados no INBOX para processar agora"
	exit $1
}

# ========================================================================== #
# isNumber - Determina se o parametro eh numerico
# PARM $1  - String a verificar se eh numerica ou nao
# Obs.:   `-eq` soh opera bem com numeros portanto se nao for numero da erro
#
isNumber() {
	[ "$1" -eq "$1" ] 2> /dev/null
	return $?
}
#

# ========================================================================== #
# readANY - Le o ID oficial do indice
# PARM $1 - ID ou nlquer item tabelado para o indice
# Obs.:   - Atencao para nao usar substring de indice nao desejado
#
readANY() {
	TMPR=$(grep "^${1}\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo  $TMPR | awk '{ print $1 }'
	else
		TMPR=$(grep "\b${1}\b" $PATH_EXEC/tabs/iAHx.tab)
		if [ $? -eq 0 ]; then
			echo $TMPR | awk '{ print $1 }'
		else
			false
		fi
	fi
}

# ========================================================================== #
# readIDX - Le o nome oficial do indice
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - Nome oficial do indice eh aquele que o SOLR conhece
#
readIDX() {
	TMPR=$(grep "^${1}\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo  $TMPR | awk '{ print $2 }'
	else
		false
	fi
}

# readINS - Le o nome da instancia
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - 
#
readINS() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $3 }'
	else
		false
	fi
}

# readDIR - Le o caminho de execucao
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - Caminho relativo a $PATH_EXEC
#
readDIR() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $4 }'
	else
		false
	fi
}

# readCMM - Le o caminho comum nos servidores (raiz dos indices)
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - 
#
readCMM() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $5 }'
	else
		false
	fi
}

# readHOM - Le o nome do servidor de homologacao
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - 
#
readHOM() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $6 }'
	else
		false
	fi
}

# readPRO - Le o nome do servidor de producao
# PARM $1 - ID do indice a recuperar dados
# Obs.:   - 
#
readPRO() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $7 }'
	else
		false
	fi
}
								
# readINB - Le o diretorio de INBOX em $PATH_INPUT
# PARM $1 - ID do indice a recuperar dados
# Obs.:   -
#
readINB() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $8 }'
	else
		false
	fi
}

# readURL - Le o URL padrao para acesso a interface de busca
# PARM $1 - ID do indice a recuperar dados
# Obs.:   -
#
readURL() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $9 }' | tr "^" "\012"
	else
		false
	fi
}
								
# readLDW - Le o path para bases de LILDBI-Web
# PARM $1 - ID do indice a recuperar dados
# Obs.:   -
#
readLDW() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $10 }' | tr "^" "\012"
	else
		false
	fi
}

# readDUM - Funcao dummy
# PARM $1 - ID do indice a recuperar dados
# Obs.:   -
#
readDUM() {
	TMPR=$(grep "^$1\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo $TMPR | awk '{ print $11 }'
	else
		false
	fi
}
# ========================================================================== #

