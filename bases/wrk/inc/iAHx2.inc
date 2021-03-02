
# ========================================================================== #
#                                  FUNCOES
# ========================================================================== #
cat > /dev/null <<COMMENT

	rdLIB		-		[Ok]		Retorna informacoes sobre a biblioteca iAHx.inc
readANY	rdANYTHING	PARM1		[Ok]	1	Retorna o ID do indice, por qualquer item
readIDX	rdINDEX		PARM1		[Ok]	2	Retorna o nome do indice
readINS	rdINSTANCIA	PARM1		[Ok]	3	Retorna o nome da instancia
readDIR	rdDIRETORIO	PARM1		[Ok]	4	Retorna o diretorio de processamento
	rdINDEXFILE	PARM1		[Ok]	5	Retorna o caminho relativo do indice
readCMM	rdINDEXROOT	PARM1		[Ok]	6	Retorna o caminho da raiz dos indices
	rdTESTE		PARM1		[Ok]	7	Retorna o nome do servidor de teste
readHOM	rdHOMOLOG	PARM1		[Ok]	9	Retorna o nome do servidor de homologacao de dados
readPRO	rdPRODUCAO	PARM1		[Ok]	10	Retorna o nome do servidor de producao
readINB	rdINBOX		PARM1		[Ok]	12	Retorna o diretorio de dados no INBOX
readLDW	rdLILDBIWEB	PARM1		[Ok]	13	Retorna o caminho para bases externas em LilDBI-Web
	rdPORT		PARM1		[Ok]		Obtem o numero do iahx-server configurado para o indice
	rdSERVER	PARM1		[Ok]	11	Obtem o numero do iahx-server solicitado para o indice
	rdSTATUS	PARM1		[Ok]	14	Status da instancia (Ativo / Desativo /?)
	rdPROCESSA	PARM1		[Ok]	15	Obtem situacao do processamento 
	rdINFO		PARM1		[Ok]	ALL	retorna informacoes do indice/instancia
	rdTYPE		PARM1		[Ok]	26	Retorna o tipo de processamento (MANUAL / PROGRAMADO)
	rdPERIOD	PARM1		[Ok]	27	Frequencia de processamento (0 pedido/1 diar/2 alternado/3 2Xsem/4 semanal/5 quinzenal/6 mensal)
	rdALL		PARM1		[Ok]	1/3	Retorna pares ID Instancia no arquivo de PARM1
	rdTODAS		PARM1		[Ok]	3	Retorna com a lista de instancias no arquivo de PARM1
	rdPORTAL	PARM1		[Ok]	28	Nome do portal
	rdURLOK		PARM1		[Ok]	29	URL publicamente disponivel (P / H / PH / -)
readURL	rdURL		PARM1		[Ok]	30	URL (parte fixa)
	rdOBJETO	PARM1		[Ok]	31	Documento a ser acessado
	rdHOMAPPL	PARM1		[Ok]	8	Retorna o nome do servidor de homologacao de aplicacao
	rdVERSION	PARM1		[Ok]	33	Versão do iAHx
	rdLANG		PARM1		[Ok]	32	Obtem lista de idiomas da interface
	rdOBSERVATION	PARM1		[Ok]	34	Observacoes sobre a Instancia
	rdCONSULTA	PARM1		[Ok]	36	Indice consultado
	rdTIMEHOMOL	PARM1		[Ok]	(6,5)	Ultima atualizacao em homologacao
	rdTIMEPROD	PARM1		[Ok]	(6,5)	Ultima atualizacao em producao
	rdBASES		PARM1 PARM2	[]		Bases participantes do indice
	rdQSERVER	PARM1		[Ok]	(11)	QTDE de instancias do srviahx #
	rdRECORTE	PARM1		[Ok]	16	Dados da instancia obtidos por recorte?
	rdMDLEMANOS	PARM1		[Ok]	17	Modo de indexar dados do Medline (bloco [F] ou anos [T])
	rdFILTRO	PARM1		[Ok]	18	Expressão para initial_filter do config.xml
	rdSIMULTANEOS	-			--	Le marcador de processos paralelos

Obtem os srviahx usados (numero do server linha-a-linha da tabela [sendo branco para não designado])
tail -$(expr $(wc -l /bases/iahx/exec/tabs/iAHx.tab | awk '{ print $1 }') - 2) /bases/iahx/exec/tabs/iAHx.tab | awk -F "\t" '{ print $11 }'


COMMENT
# ========================================================================== #
# rdANYTHING	Le o ID oficial do indice
# PARM $1	ID ou qualquer item tabelado para o indice
# Observacao	Retorna o primeiro encontrado qdo houver mais de um
#		Antiga funcao readANY
#
rdANYTHING() {
	TMPR=$(grep -i "^${1}\b" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		# Perguntou usando o proprio identificador
		echo  "$TMPR" | awk -F "\t" '{ print $1 }' | head -1
	else
		# Perguntou usando outro elemento de dado
		TMPR=$(grep -i "\b${1}\b" $PATH_EXEC/tabs/iAHx.tab)
		TMPR=$(cut -f "1-5,12,13,31" $PATH_EXEC/tabs/iAHx.tab | grep -i "\b${1}\b")
		if [ $? -eq 0 ]; then
			echo "$TMPR" | awk -F "\t" '{ print $1 }' | head -1
		else
			#  Nao encontrou correspondencia
			false
		fi
	fi
}

# rdINDEX	Le o nome do indice como o SOLR conhece
# PARM $1	ID do indice a recuperar dados
# Observacao	Antiga funcao readIDX
#
rdINDEX() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo  "$TMPR" | awk -F "\t" '{ print $2 }'
	else
		false
	fi
}

# rdINSTANCIA	Obtem o nome da instancia como o usuario conhece
# PARM $1	ID do indice a recuperar dados
# Observacao	Complemento da URL para acesso a pesquisa
#		Antiga funcao readINS
#
rdINSTANCIA() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $3 }'
	else
		false
	fi
}

# rdDIRETORIO	Le o diretorio de processamento
# PARM $1 	ID do indice a recuperar dados
# Observacao	Diretorio corrente para tempo de processamento
#		Antiga funcao readDIR
#
rdDIRETORIO() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $4 }'
	else
		false
	fi
}

# rdINDEXFILE	Obtem o caminho relativo especifico do indice
# PARM $1	ID do indice a gravar dados
# Observacao	Topo da arvore dos indices no iahx-server
#
rdINDEXFILE() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $5 }'
	else
		false
	fi
}

# rdINDEXROOT	Obtem o caminho comum nos servidores (raiz dos indices)
# PARM $1	ID do indice a recuperar/gravar dados
# Observacao	Topo da arvore dos indices no iahx-server
#		Antiga funcao readCMM
#
rdINDEXROOT() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $6 }'
	else
		false
	fi
}

# rdTESTE	Le o nome do servidor de teste
# PARM $1	ID do indice a recuperar dados
# Observacao	hostname do servidor de teste
#
rdTESTE() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $7 }'
	else
		false
	fi
}

# rdHOMOLOG	Le o nome do servidor de homologacao
# PARM $1	ID do indice a recuperar dados
# Observacao	hostname do servidor de homologacao
#		Antiga funcao readHOM
#
rdHOMOLOG() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $9 }'
	else
		false
	fi
}

# rdPRODUCAO	Le o nome do servidor de producao
# PARM $1	ID do indice a recuperar dados
# Observacao	hostname do servidor de producao
#		Antiga funcao readPRO
#
rdPRODUCAO() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $10 }'
	else
		false
	fi
}
								
# rdINBOX	Obtem o diretorio de INBOX em $PATH_INPUT
# PARM $1	ID do indice a recuperar dados
# Observacao	Antiga funcao readINB
#
rdINBOX() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $12 }'
	else
		false
	fi
}

# rdLILDBIWEB	Obtem o endereco da bases de LILDBI-Web
# PARM $1	ID do indice a recuperar dados
# Observacao	O endereco deve incluir hostname e caminho completo ate a base de dados
#		Antiga funcao readLDW
#
rdLILDBIWEB() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $13 }' | tr "^" "\012"
	else
		false
	fi
}

# rdPORT	Obtem o numero do iahx-server efetivo para o indice
# PARM $1	ID do indice a recurerar o iahx-server
# Observacao	No retorno se o codigo for TRUE o numero retornado eh valido
#
rdPORT() {
	INDX=$(rdINDEX $1)
	#INSTANCIAS="${PATH_IAHX}/../instances/"
	INSTANCIAS=$(echo ${PATH_IAHX} | sed 's/bin/instances/')
	for instance in $(ls --color=no $INSTANCIAS)
	do
		if [ -f "${INSTANCIAS}/${instance}/conf/Catalina/localhost/${INDX}.xml" ]; then
			echo ${instance}
			break
		fi
		false
	done
}

# rdSERVER	Obtem o numero do iahx-server solicitado para o indice
# PARM $1	ID do indice a recuperar o iahx-server
# Observacao	No retorno o numero do servidor
#
rdSERVER() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $11 }'
	else
		false
	fi
}

# rdSTATUS	Obtem o status da instancia
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde como ATIVO / INATIVO / DESATIVADO / HOMOLOGACAO / ?
#
rdSTATUS() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $14 }'
	else
		false
	fi
}

# rdPROCESSA	Obtem estado do processamento do indice LIBERADO ou NAO
# PARM $1 	ID do indice a saber se esta em processamento
# Observacao	Responde como SIM / NAO
#
rdPROCESSA() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $15 }' | tr [:lower:] [:upper:]
	else
		false
	fi
}

# rdINFO	Exibe as informacoes da instancia/indice
# PARM $1	ID do indice a saber as informacoes
# Observacao	.
#
rdINFO() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "=============="
			echo "[rdANYTHING]                        ID_INDEX: $(rdANYTHING  $TMPR)"
			echo "[rdINDEX]                           NM_INDEX: $(rdINDEX     $TMPR)"
			echo "[rdINSTANCIA]                   NM_INSTANCIA: $(rdINSTANCIA $TMPR)"
			echo "[rdPORTAL]                            PORTAL: $(iconv -f ISO-8859-1 -t UTF8 <<< $(rdPORTAL    $TMPR))"
			echo "[rdDIRETORIO]                    DIR_PROCESS: $(rdDIRETORIO $TMPR)"
			echo "[rdINDEXFILE]                    LOCAL_INDEX: $(rdINDEXROOT $TMPR)/$(rdINDEXFILE $TMPR)"
		if [ -z $(rdTESTE $TMPR) -o "$(rdTESTE $TMPR)" = "." ]; then
			echo "[rdTESTE]                         Serv Teste: (nao tem)"
			NOTST=1
		else
			echo "[rdTESTE]                         Serv Teste: $(rdTESTE $TMPR)"
			NOTST=0
		fi
		if [ ! $(rdHOMOLOG $TMPR) = "." ]; then
			echo "[rdHOMOLOG]                     Serv Homolog: $(rdHOMOLOG   $TMPR)"
		else
			echo "[rdHOMOLOG]                     Serv Homolog: no processamento"
		fi
			echo "[rdPRODUCAO]                   Serv Producao: $(rdPRODUCAO  $TMPR)"
			echo "[rdPORT]                                PORT: 898$(rdPORT   $TMPR) no iahx-server $(echo "$TMPR" | awk -F "\t" '{ print $11 }')"
			echo "[rdINBOX]                          DIR_INBOX: $(rdINBOX     $TMPR)"
			echo "[rdSTATUS]                          SITUACAO: $(rdSTATUS    $TMPR)  <=="
		     echo -e "[rdPROCESSA rdTYPE rdPERIOD]       PROCESSAR: $(rdPROCESSA  $TMPR) em modo: \033[31m$(rdTYPE $TMPR)\033[m com frequencia: \033[31m$(rdPERIOD $TMPR)\033[m"
		URL=$(rdURL $TMPR)
		if [ ! "$(rdMDLEMANOS $TMPR)" = "true" ]; then
			echo "[rdMDLEMANOS]                  MDL ano-a-ano: nunca"
		else
			echo "[rdMDLEMANOS]                  MDL ano-a-ano: $(rdMDLEMANOS $TMPR)   <== (quando nao incremental)"
		fi
			echo "[rdRECORTE]                      Por recorte: $(rdRECORTE   $TMPR)  <=="
		if [ ! -z "$URL" -a ! "$URL" = "-" ]; then
			echo "[rdURL/rdOBJETO]               URL de acesso: http://$(rdURL $TMPR)/$(rdOBJETO $TMPR)"
		fi
		if [ $NOTST -eq 1 ]; then
			echo "[rdTESTE:rdPORT/rdINDEX]      URL SOLR (TST): = sem servidor de teste ="
		else
			echo "[rdTESTE:rdPORT/rdINDEX]      URL SOLR (TST): http://$(rdTESTE $TMPR).bireme.br:898$(rdPORT $TMPR)/$(rdINDEX $TMPR)/admin"
		fi
		if [ ! $(rdHOMOLOG $TMPR) = "." ]; then
			echo "[rdHOMOLOG:rdPORT/rdINDEX]    URL SOLR (HOM): http://$(rdHOMOLOG $TMPR).bireme.br:898$(rdPORT $TMPR)/$(rdINDEX $TMPR)/admin"
			echo "[rdTIMEHOMOL]             (data hora) indice: $(rdTIMEHOMOL $TMPR)"
		fi
			echo "[rdPRODUCAO:rdPORT/rdINDEX]   URL SOLR (PRD): http://$(rdPRODUCAO $TMPR).bireme.br:898$(rdPORT $TMPR)/$(rdINDEX $TMPR)/admin"
			echo "[rdTIMEPROD]              (data hora) indice: $(rdTIMEPROD $TMPR)"
		echo "=============="
	else
		false
	fi
}

# rdTYPE	Obtem o tipo de processamento do indice
# PARM $1	ID do indice a recuperar dados
# Observacao	Tipos suportados MANUAL / AUTOMATICO
#
rdTYPE() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $26 }'
	else
		false
	fi
}

# rdPERIOD	Obtem a periodicidade de processamento/atualizacao
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com um text (anual / weekly / annual / bi-semanal / ...)
#
rdPERIOD() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $27 }'
	else
		false
	fi
}

# rdALL		Le a chave primaria de todas as instancias e seus nomes
# PARM $1	caminho e nome do arquivo para conter a lista
# Observacao	Grava no arquivo indicado a lista colunas separadas por pipe
#
rdALL () {
	if [ -z "$1" ]; then
		awk -F "\t" '{ print $1 "|" $3 }' $PATH_EXEC/tabs/iAHx.tab
	else
		awk -F "\t" '{ print $1 "|" $3 }' $PATH_EXEC/tabs/iAHx.tab > $1
	fi
}

# rdTODAS	Le o nome de todas as instancias
# PARM $1       caminho e nome do arquivo para conter a lista
# Observacao    Grava no arquivo indicado a lista com as instancias cadastradas
#
rdTODAS() {
	if [ -z "$1" ]; then
		awk -F "\t" '{ print $3 }' $PATH_EXEC/tabs/iAHx.tab
	else
		awk -F "\t" '{ print $3 }' $PATH_EXEC/tabs/iAHx.tab > $1
	fi
}

# rdPORTAL	Obtem o nome do portal servido pelo indice
# PARM $1	ID do indice a recuperar dados
# Observacao	Nome humano do portal
#
rdPORTAL() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $28 }'
	else
		false
	fi
}

# rdURLOK	Obtem o nivel de disponibilidade do indice
# PARM $1	ID do indice a recuperar dados
# Observacao	Tipo de disponibilidade publica (P / H / PH / -)
#
rdURLOK() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $29 }'
	else
		false
	fi
}

# rdURL		Obtem a URL de chamada da interface OPAC sem parametros (parte fixa)
# PARM $1	ID do indice a recuperar dados
# Observacao	URL base da interface de pesquisa sem a identificacao do indice
#		Antiga funcao readURL
#
rdURL() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $30 }'
	else
		false
	fi
}

# rdOBJETO	Obtem o parametro de acesso a URL
# PARM $1	ID do indice a recuperar dados
# Observacao	Complemento da URL para pesquisa
#
rdOBJETO() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $31 }'
	else
		false
	fi
}

# rdHOMAPP	Obtem o servidor da homologacao da aplicacao
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com o nome do servidor de homologacao da aplicacao
#
rdHOMAPP() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $8 }'
	else
		false
	fi
}

# rdVERSION	Obtem a versao do iAHx aplicado
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com o numero da versao
#
rdVERSION() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $33 }'
	else
		false
	fi
}

# rdLANG	Obtem lista de idiomas da interface
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com o texto cadastrado
#
rdLANG() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $32 }'
	else
		false
	fi
}

# rdOBSERVATION	Obtem notas sobre a instancia
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com o texto cadastrado
#
rdOBSERVATION() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $34 }'
	else
		false
	fi
}

# rdCONSULTA	Obtem o nome do indice fisico consultado
# PARM $1	ID do indice a recuperar dados
# Observacao	
function rdCONSULTA {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		echo "$TMPR" | awk -F "\t" '{ print $36 }'
	else
		false
	fi
}

# rdTIMEHOMOL	Obtem a versao do iAHx aplicado
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com data e hora no formato YYYYMMDD hh:mm:ss
#
rdTIMEHOMOL() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		INDEXROOT=$(rdINDEXROOT $1)
		IDXSOLR=$(rdINDEXFILE $1 | tr "-" "/")
		[ "$IDXSOLR" = "portal/org" ] && IDXSOLR="portalorg/main"
		SERVER=$(rdHOMOLOG $1)
		if [ -z "$SERVER" -o "$SERVER" = "." ]; then
			# Homologacao inexistente
			#echo "0000-00-00 00:00:00"
			# Homologacao no processamento
			ls -l --time-style full-iso $INDEXROOT/$IDXSOLR/data/index/segments.gen | awk '{ print $6 " " $7 }'
		else
			# Homologacao remota
			ssh transfer@$SERVER ls -l --time-style full-iso $INDEXROOT/$IDXSOLR/data/index/segments.gen | awk '{ print $6 " " $7 }'
		fi
	else
		false
	fi
}

# rdTIMEPROD	Obtem a versao do iAHx aplicado
# PARM $1	ID do indice a recuperar dados
# Observacao	Responde com data e hora no formato YYYYMMDD hh:mm:ss
#
rdTIMEPROD() {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		INDEXROOT=$(rdINDEXROOT $1)
		IDXSOLR=$(rdINDEXFILE $1 | tr "-" "/")
		[ "$IDXSOLR" = "portal/org" ] && IDXSOLR="portalorg/main"
		SERVER=$(rdPRODUCAO $1)
		if [ -z "$SERVER" -o "$SERVER" = "." ]; then
			# Producao inexistente
			echo "0000-00-00 00:00:00"
			# Producao no processamento
			#ls -l --time-style full-iso $INDEXROOT/$IDXSOLR/data/index/segments.gen | awk '{ print $6 " " $7 }'| cut -d "." -f "1"
		else
			# Producao remota
			ssh -p 8022 transfer@$SERVER "ls -l --time-style full-iso $INDEXROOT/$IDXSOLR/data/index/segments.gen" | awk '{ print $6 " " $7 }'| cut -d "." -f "1"
		fi
	else
		false
	fi
}

# rdBASES	Obtem lista de bases participantes do indice
# PARM $1	ID do indice
# PARM $2	Caminho
# Observacao	
#rdBASES() {
#}

# rdLIB		Obtem informacoes da library
# Observacao	
rdLIB() {
	T_LN=$(wc -l $PATH_EXEC/inc/iAHx2.inc | awk '{ print $1 }')
	I_LN=$(grep -n "<LIB_INFORMATION" $PATH_EXEC/inc/iAHx2.inc | tail -1 | cut -d ":" -f "1")
	LN_I=$(expr $T_LN - $I_LN)
	LN_F=$(expr $LN_I - 2)
	tail -n "$LN_I" $PATH_EXEC/inc/iAHx2.inc | head -$LN_F
}

# rdQSERVER	Le qtas instancias usam um servidor
# PARM $1	numero do servidor a perguntasr sobre
# Observacao	Se nao tem o servidor# perguntado volta ZERO
#
function rdQSERVER {
	[ -z $1 ] && echo 0 && return
	tail -$(expr $(wc -l /bases/iahx/exec/tabs/iAHx.tab | \
	awk '{ print $1 }') - 2) /bases/iahx/exec/tabs/iAHx.tab | \
	awk -F "\t" '{ print $11 }' | \
	grep "$1" | wc -l | awk '{ print $1 }'
}

# rdRECORTE	Le se os dados da instancia sao recorte ou processamento
# PARM $1	ID do indice a verificar
# Observacao	Retorna true quando os dados sao por recorte
#
rdRECORTE() {
        TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
        if [ $? -eq 0 ]; then
                echo  "$TMPR" | awk -F "\t" '{ print $16 }'
        else
                false
        fi
}

# rdMDLEMANOS	Le se a instancia indexa MDL ano a ano ou em bloco
# PARM $1	ID do indice a consultar
# Observacao	Retorna true  quando os dados de MDL sao ANO a ANO
#		Retorna false quando os dados de MDL sao em bloco
#
function rdMDLEMANOS {
        TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
        if [ $? -eq 0 ]; then
                MDLAA=$(echo  "$TMPR" | awk -F "\t" '{ print $17 }')
		case "$MDLAA" in

			true | TRUE | True | sim | SIM | Sim | x | X)
				echo "true"
				true
			;;

			*)
				echo ""
				false
			;;

		esac
        else
                false
        fi
}

# rdFILTRO	Le o filtro inicial a ser aplicado a instancia
# PARM $1	ID do indice a consultar
# Observacao	Dado na coluna 18
#		Retorna true  quando há filtro aplicável
#		Retorna false quando nao há filtro aplicável
#
function rdFILTRO {
	TMPR=$(grep "^${1}	" $PATH_EXEC/tabs/iAHx.tab)
	if [ $? -eq 0 ]; then
		FILTRO=$(echo  "$TMPR" | awk -F "\t" '{ print $18 }')
		if [ -z $FILTRO ]; then
			false
		else
			echo $FILTRO
			true 
		fi
        else
                false
        fi
}

# rdSIMULTANEOS	Le a quantidade de processos simultaneos em execucao
# PARM	--	N/A
# Observacao	Se nao existe o arquivo cria um com zero e retorna
#
rdSIMULTANEOS() {
	[ -f "mdl_iAHx.qtde" ] || echo 0>mdl_iAHx.qtde
	echo $(<mdl_iAHx.qtde)
}

# ========================================================================== #
cat > /dev/null <<LIB_INFORMATION
+----------------------------------------------------------------------------+
| Library: iAHx2.inc versao: 2.05 20150508                                   |
|                                                                            |
| 20140812 Adequacao ao novo layout da tabela iAHx.tab                       |
| 20140815 Implementacao das funcoes rdINFO e rdLIB                          |
| 20140828 Definicoes de periodicidade melhoradas                            |
| 20150202 Criacao das funcoes rdMDL e rdRECORTE                             |
| 20150209 Eliminado bug devido a colorizacao da saida do 'ls' em rdPORT     |
| 20150209 Criacao da funcao rdSIMULTANEOS para indexacao do Medline         |
| 20150220 Criacao da funcao rdMDLEMANOS para indexacao Medline FULL         |
| 20150306 Limitando rdANYTHING as colunas 1-5,12,13, e 31                   |
|          Implementada a funcao rdCONSULTA                                  |
| 20150427 As funcoes rdALL e rdTODAS qdo sem paramêtro gravam em STDOUT     |
| 20150508 Implementada a funcao rdFILTRO                                    |
| 20150518 Corrigidas as funcoes rdTIMEHOMOL e rdTIMEPROD                    |
|                                                                            |
| Relacao de funcoes:                                                        |
|          rdALL           rdANYTHING      rdCONSULTA      rdDIRETORIO       |
|          rdHOMAPPL       rdHOMOLOG       rdINBOX         rdINDEX           |
|          rdINDEXFILE     rdINDEXROOT     rdINFO          rdINSTANCIA       |
|          rdLANG          rdLIB           rdLILDBIWEB     rdMDLEMANOS       |
|          rdOBJETO        rdOBSERVATION   rdPERIOD        rdPORT            |
|          rdPORTAL        rdPROCESSA      rdPRODUCAO      rdQSERVER         |
|          rdRECORTE       rdSERVER        rdSIMULTANEOS   rdSTATUS          |
|          rdTESTE         rdTIMEHOMOL     rdTIMEPROD      rdTODAS           |
|          rdTYPE          rdURL           rdURLOK         rdVERSION         |
|	   rdFILTRO
+----------------------------------------------------------------------------+
LIB_INFORMATION

