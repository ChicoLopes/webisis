#!/bin/bash

# -------------------------------------------------------------------------- #
# modelo.sh - programa para (declarar a finalidade do programa)
# -------------------------------------------------------------------------- #
# VIDE A SESSAO COMMENT na porcao final do arquivo para detalhamento completo
# PARM1 - parametro de chamada numero 1
# PARM2 - parametro de chamada numero 2
# PARMn - parametro de chamada numero n
# Opções de execucao:
#	--changelog		Exibe o histórico de alteracoes do programa
#	-c, --config NOMEARQU	Utilizar o arquivo de configuracao NOMEARQU
#	-D, --debug n		Ajusta o nivel de depuracao para execucao (dafault=0)
#	-h, --help		Exibe o texto de help para o programa
#	-V, --version		Exibe a versao do programa
#    diretorio corrente:	Nao eh relevante
#      chamada generica:	./modelo.sh -opcoes <PARM1> [PARM2] [PARM3]
#    exemplo de chamada:	./modelo.sh -c teste.cfg EDI
# Objetivos do programa:	Fazer a montagem de um arquivo para tais propositos: A, B, e C
# -------------------------------------------------------------------------- #
#             QAPLA Comercio e Servicos de Informatica Ltda-ME
# CNPJ: 05.129.080/0001-1         CCM: x.xxx.xxx-x         I.E.: 999.999.999
# http://www.qapla.com.br  qapla@qaplaweb.com.br  Fone: +55 (11) 9.9999-9999
#                             QAPLA (P) 2002-2020
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00.2020010130000
	- Edicao original
HISTORICO

# ===
# BIBLIOTECAS
# ===
# Incorpora biblioteca especifica de bases CDM
source $PATH_EXEC/inc/CMSP.inc
# Que conta com as seguintes funcoes
# rdLIB		--	--	Retorna informacoes sobre a biblioteca
# rdANYTHING	PARM1	1	Retorna o ID, por qualquer item
# rdINDEX	PARM1	2	Retorna o nome do indice
# rdHOMOLOGACAO	PARM1		Retorna o nome de rede do servidor de homologacao
# rdPRODUCAO	PARM1		Retorna o nome de rede do servidor de producao
# rdTIMEHOMOL	PARM1		Exibe data e hora da ultima atualizacao em homologacao
# rdTIMEPROD	PARM1		Exibe data e hora da ultima atualizacao em producao
# rdURL		PARM1		Retorna URL de producao

# Incorpora carregador de defaults padrao
source $PATH_EXEC/inc/lddefault.viahx.inc

# Incorpora HELP e tratador de opcoes
source $PATH_EXEC/inc/mhelp_opc.viahx.inc

# Incorpora a biblioteca de armadilha (chincada) de sinais
source $PATH_EXEC/inc/chincada.inc
# Que conta com as funcoes:
#  clean_term   PARM1   Trata interrupcao por SIGTERM
#  clean_hup    PARM1   Trata interrupcao por SIGHUP
#  clean_int    PARM1   Trata interrupcao por SIGINT
#  clean_kill   PARM1   Trata interrupcao por outros sinais
#  clean_exit   PARM1   Trata interrupcao por SIGEXIT
#  leF          PARM1   Le nivel corrente do flag
#  contaF       PARM1   Sobe um nivel de execucao
#  descontaF    PARM1   Desce um nivel de execucao
#  resetF       PARM1   Limpa nivel de execucao

# Incorpora biblioteca de controle basico de processamento
source  $PATH_EXEC/inc/infoini.inc
# Quec conta com as funcoes:
#  isNumber     PARM1   Retorna FALSE se PARM1 nao for numerico
#  rdConfig     PARM1   Item de configuracao a ser lido
# Estabelece as variaveis:
#       CURRDIR   Diretorio corrente no momento da carga
#       HINICIO   Tempo inicial em segundos desde 01/01/1970
#       HRINICI   Hora de inicio no formato YYYYMMDD hh:mm:ss
#       __DIA__   Dia calendario no formato DD
#       __MES__   Mes calendario no formato MM
#       __ANO__   Ano calendario no formato YYYY
#       PROGEXE   Demoninacao do programa em execucao
#       PROGDIR   Path para o programa em execucao
#       LCMDORI   Linha de comando original da chamada
#       DATAISO   Data calendario no formato YYYYMMDD

# ========================================================================= #
# PegaValor - Obtem valor de uma clausula
# PARM $1 - Item de configuracao a ser lido
# Obs: O arquivo a ser lido eh o contido na variavel CONFIG
#
PegaValor () {
        if [ -f "$CONFIG" ]; then
                grep "^$1" $CONFIG > /dev/null
                RETORNO=$?
                if [ $RETORNO -eq 0 ]; then
                        RETORNO=$(grep $1 $CONFIG | tail -n "1" | cut -d "|" -f "2")
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
# -------------------------------------------------------------------------- #
#     1234567890123456789012345
echo "[vwxyz]  1         - Inicia processamento de indexacao solr"
# -------------------------------------------------------------------------- #
# Garante existencia da tabela de configuracao (sai com codigo de erro 3 - Configuration Error)
#                                            1234567890123456789012345
[ $N_DEB -ne 0 ]                    && echo "[vwxyz]  0.00.04   - Testa se ha tabela de configuracao"
[ ! -s "$PATH_EXEC/tabs/iAHx.tab" ] && echo "[vwxyz]  1.01      - Tabela iAHx nao encontrada" && exit 3

[ -s "$CONFIG" ] && QUERY_STRING=$(PegaValor QUERY_STR)
# -------------------------------------------------------------------------- #
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
        test -n "$CONFIG"       && echo "      CONFIG = $CONFIG"
        test -n "$QUERY_STRING" && echo "QUERY_STRING = $QUERY_STRING"
        test -n "$SRVPRD"       && echo "    Producao = $SRVPRD"
        test -n "$SRVHOM"       && echo " Homologacao = $SRVHOM"

        echo "==============================="
        cat $$.rol
        echo "==============================="
fi

# ----- #
# DEBUG #
[ $(($DEBUG & $_BIT0_)) -eq 1 ] && echo -n "==> Aguardando intervencao do operador (Tecle \"pare<ENTER>\" para interromper a execucao): "
[ $(($DEBUG & $_BIT0_)) -eq 1 ] && read LIDO
[ "$LIDO" = "pare" ] && echo "==> execucao interrompida manualmente pelo operador" && exit
# ----- #

#     12345678901234567890
echo "[vwxyz]  1         - Garante condicoes de execucao"
if [ "$USER" != "tomcat" ]; then
        echo "*** FAIL *** User not authorized. Must be \"tomcat\". Is: $USER *** EXIT CODE (1) ***"
        exit 1
fi

echo "[vwxyz]  1.01      - Limpa resultados anteriores"
[ -f relato.txt ] && rm -f relato.txt

echo "[vwxyz]  2         - Determina instancias a testar quando em lote"
echo "[vwxyz]  2.01      - Elimina restos do ultimo processamento"
[ -f $$.tmp ] && rm -f $$.tmp
ITERACAO=1
echo "[vwxyz]  2.02      - Gera uma nova lista de cadidatos a testar"
for i in $(ls $INDEX_ROOT/../instances/?/conf/Catalina/localhost/*.xml | egrep -v "previousterm.xml|manager.xml")
do

        INDICE=$(basename $i | cut -d "." -f "1" )
        echo -n "[vwxyz]  2.02."; printf "%02d" $ITERACAO; echo -n "   - Levanta dados de $INDICE "
        IDIDX=$(rdANYTHING $INDICE)
        echo "UID: $IDIDX"
        [ "$(rdPROCESSA $IDIDX)" = "SIM" ] && echo -e "$(rdHOMOLOG $IDIDX)\t$(rdPORT $IDIDX)\t$INDICE\t($IDIDX)\t$(iconv -f iso8859-1 -t utf8 <<< $(rdPORTAL $IDIDX))" | tr " " "_" >> $$.tmp
        ITERACAO=$(expr $ITERACAO + 1)

done

echo "[vwxyz]  2.03      - Monta a lista efetiva de teste"
awk '{ printf "%s:898%s/%s\t|%s\t%s\n", $1, $2, $3, $4, $5 }' $$.tmp | awk '{ printf "%50s%-18s%s\n",$1,$2,$3}' | tr "_" " " > $PATH_EXEC/tabs/testar.rol

# -------------------------------------------------------------------------- #
echo "[vwxyz]  3         - Determina o tipo de teste a realizar (em lote / detalhado)"

# CABECALHO (porcao comum)
echo "[vwxyz]  3.01      - Prepara o cabecalho do relatorio da verificacao"
PROGVRS="$TREXE - $(grep '^vrs: ' $PRGDR/$TREXE | tail -1)"
QTDE=$(expr 91 - $(echo ${#PROGVRS}))
iconv -f utf8 -t iso8859-1 <<< "$PROGVRS$(printf "%${QTDE}c" " ")OFI-Operação de Fontes de Informação" > $$.txt
echo >> $$.txt


# CABECALHO (porcao comum)
echo "[vwxyz]  3.01      - Prepara o cabecalho do relatorio da verificacao"
PROGVRS="$TREXE - $(grep '^vrs: ' $PRGDR/$TREXE | tail -1)"

echo "[vwxyz]  4         - Finaliza o relatorio com o rodape institucional"
echo >> relato.txt
echo "==============================================================================================================================
=" >> relato.txt
echo "           Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde - BIREME / OPS / OMS (P)2012-15" >> relato.t
xt
echo "     É um centro especialidado da Organização Pan-Americana da Saúde, escritório regional da Organização Mundial da Saúde" >>
relato.txt

echo "[vwxyz]  4.01      - Armazena historicamente o relatorio"
[ -d $PATH_PROC/logs ]                       || mkdir -p $PATH_PROC/logs
[ -d $PATH_PROC/$(rdDIRETORIO $PARM1)/logs ] || mkdir -p $PATH_PROC/$(rdDIRETORIO $PARM1)/logs
AGORA=$(date '+%Y%m%d-%H%M%S')
[   -z "$PARM1" ] && cp -p _h$$_.txt ${_DOW_}H-LOTE-$AGORA.txt && mv ${_DOW_}H-LOTE-$AGORA.txt "$PATH_PROC/logs"
[   -z "$PARM1" ] && cp -p _p$$_.txt ${_DOW_}P-LOTE-$AGORA.txt && mv ${_DOW_}P-LOTE-$AGORA.txt "$PATH_PROC/logs"
[   -z "$PARM1" ] && cp -p relato.txt relato-LOTE.$AGORA.txt   && mv relato-LOTE.$AGORA.txt    "$PATH_PROC/logs"
[ ! -z "$PARM1" ] && cp -p relato.txt relato-$PARM1.$AGORA.txt && mv relato-$PARM1.$AGORA.txt  "$PATH_PROC/$(rdDIRETORIO $PARM1)/logs"

# ------------------------------------------------------------------------- #
# Limpa area de trabalho
[ -f "$$.tmp" ]    && rm -f $$.tmp
[ -f "$$.txt" ]    && rm -f $$.txt
[ -f "$$.rol" ]    && rm -f $$.rol
[ -f "$$.log" ]    && rm -f $$.log
[ -f "$$.err" ]    && rm -f $$.err
[ -f "_$$_.txt" ]  && rm -f _$$_.txt
[ -f "_h$$_.txt" ] && rm -f _h$$_.txt
[ -f "_p$$_.txt" ] && rm -f _p$$_.txt
[ -f "homologa" ]  && rm -f homologa
[ -f "producao" ]  && rm -f producao

source  $PATH_EXEC/inc/clean_wrk.dummy.inc
source  $PATH_EXEC/inc/infofim.inc
echo -e "\n\n"; cat relato.txt; echo
[ -f relato.txt ] && rm relato.txt
exit
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

      Entrada : Arquivo de URL de teste (testar.rol)
                PARM1  nome do arquivo (e caminho) com lista de URL a testar
                Opcoes de execucao
                 --changelog              Mostra historico de alteracoes
                 -c, --config NOMEARQU    Nome do arquivo com as configuracoes
                 -o, --output NOMEARQU    Nome do arquivo com as instancias aprovadas (N/I)
                 -d, --debug N            Nivel de depuracao
                 -h, --help               Mostra o help
                 -H, --homolog HOSTNAME   Nome de rede do servidor de homologacao (N/I)
                 -p, --producao HOSTNAME  Nome de rede do servidor de producao (N/I)
                 -s, --server             Hostname do servidor de producao
                 -V, --versao             Mostra a versao
                 -x, --excel              Gera saida CSV para carga em planilha (N/I)
        Saida : Arquivo com a lista de instancias aprovadas se houver PARM1
     Corrente : qualquer
      Chamada : v_wxyz.sh <TESTAR.lst> [-h|-V|--changelog] [-d N] [-s <servername>] [-c <config_file>] [-o <output_file>]
      Exemplo : v_wxyz.sh transfere.lst
  Objetivo(s) : Testar resultados totais das instancdias
  Comentarios : testar.rol eh montado dinamicamente pelo programa
                vwxyz.conf deve estar no mesmo diretorio deste arquivo
                Com a linha de comando a seguir é possível converter o relatório em arquivo de dados:
                Dados de homologacao:
                 cat relato-LOTE.20150311-112247.txt | iconv -f utf-8 -t iso8859-1 | cut -c -16,84-92 | tr -d " " | tr -d "(" | tr ")" "\t" | sed '1,6d' | sed '/^=/Q' > h.txt
                Dados de producao:
                 cat relato-LOTE.20150311-112247.txt | iconv -f utf-8 -t iso8859-1 | cut -c -16,97-105 | tr -d " " | tr -d "(" | tr ")" "\t" | sed '1,6d' | sed '/^=/Q' > p.txt
  Observacoes : DEBUG eh uma variavel mapeada por bit conforme
                _BIT0_  Aguarda tecla <ENTER>
                _BIT1_  Mostra mensagens de DEBUG
                _BIT2_  Modo verboso
                _BIT3_  Modo debug de linha -v
                _BIT4_  Modo debug de linha -x
                _BIT7_  Opera em modo FAKE
        Notas : Deve ser executado como usuario 'xxxxxx'
 Dependencias : Tabela wxyz.tab deve estar presente em $PATH_EXEC/tabs
                COLUNA  NOME                    COMENTARIOS
                 1      ID_INDICE               ID do indice                    (Identificador unico do indice para processamento)
                 2      NM_INDICE               nome do indice conforme o SOLR  (nome oficial do indice)
                 3      NM_INSTANCIA            nome interno da instancia
                 4      DIR_PROCESSAMENTO       diretorio de processamento      (caminho relativo a $PATH_PROC)
                 5      DIR_INDICE              caminho do indice               (caminho relativo)
                 6      RAIZ_INDICES            caminho comum dos indices       (caminho absoluto)
                 7      SRV_TESTE               HOSTNAME do servidor de teste de palicacao
                 8      SRV_HOMOLOG APP         HOSTNAME do servidor de homologacao de aplicacao
                 9      SRV_HOMOLOG DATA        HOSTNAME do servidor de homologacao de dados
                10      SRV_PRODUCAO            HOSTNAME do servidor de producao
                11      IAHX_SERVER             numero do IAHx-server utilizado (Teste/Homolog/Prod)
                12      DIR_INBOX               nome do diretorio dos dados de entrada
                13      NM_LILDBI               qualificacao total das bases de dados LILDBI-Web, separadas pelo sinal '^'
                14      SITUACAO                estado do indice                (HOMOLOGACAO / ATIVO / INATIVO / ...)
                15      PROCESSA                liberado para processar         (em operacao)
                16-25   RESERVA_DE_OFI                                          (USO DE OPERACAO DE FONTE DE INFORMACAO)
                26      TIPOPROC                escalacao do processamento      (manual / automatica)
                27      PERIODICIDADE           intervalo entre processamento   (0/pedido 1/diario 2/alternado 3/bisemanal 4/semanal 5/quinzenal 6/mensal)
                28      NM_PORTAL               nome oficial do portal
                29      URL_DISPONIVEL          URL de aplicacao funcional      (P / H / PH / -)
                30      URL                     Universal Resource Locator
                31      PARAMETRO_URL           complemento de URL para acesso web
                32      IDIOMAS                 versoes idiomaticas de interface
                33      VERSAO_APP              versao do OPAC
                34      OBSERVACAO              informações relevantes diversas
                35      WIKI_EXPRESSAO          URL do wiki com a expressao de selecao de registros
                36      LST_FISIDX              lista de FIs indexadas neste indice
                        -Periodicidades:
                                0 - a pedido
                                1 - diario
                                2 - dias alternados
                                3 - 2 vezes na semana
                                4 - semanal
                                5 - quinzenal
                                6 - mensal
                        -URL funcionais
                                P - Producao
                                H - Homologacao
                                - - none
                Variaveis de ambiente que devem estar previamente ajustadas:
                geral           BIREME - Path para o diretorio com especificos da BIREME
                geral             CRON - Path para o diretorio com rotinas de crontab
                geral             MISC - Path para o diretorio de miscelaneas da BIREME
                geral             TABS - Path para as tabelasde uso geral da BIREME
                geral         TRANSFER - Usuario para troca de arquivos entre servidores
                geral           _BIT0_ - 00000001b
                geral           _BIT1_ - 00000010b
                geral           _BIT2_ - 00000100b
                geral           _BIT3_ - 00001000b
                geral           _BIT4_ - 00010000b
                geral           _BIT5_ - 00100000b
                geral           _BIT6_ - 01000000b
                geral           _BIT7_ - 10000000b
                iAHx             ADMIN - e-mail ofi@bireme.br
                iAHx         PATH_IAHX - caminho para os executaveis do pcte
                iAHx         ROOT_IAHX - topo da arvore de processamento
                iAHx         PATH_PROC - caminho para a area de processamento
                iAHx         PATH_EXEC - caminho para os executaveis de processamento
                iAHx        PATH_INPUT - caminho para os dados de entrada
                iAHx        INDEX_ROOT - Raiz dos indices de busca
                iAHx            STiAHx - Hostname do servidor de teste
                iAHx            SHiAHx - Hostname do servidor de homologacao
                iAHx            SPiAHx - Hostname do servidor de producao
                ISIS         ISIS - WXISI      - Path para pacote
                ISIS     ISIS1660 - WXIS1660   - Path para pacote
                ISIS        ISISG - WXISG      - Path para pacote
                ISIS         LIND - WXISL      - Path para pacote
                ISIS      LIND512 - WXISL512   - Path para pacote
                ISIS       LINDG4 - WXISLG4    - Path para pacote
                ISIS    LIND512G4 - WXISL512G4 - Path para pacote
                ISIS          FFI - WXISF      - Path para pacote
                ISIS      FFI1660 - WXISF1660  - Path para pacote
                ISIS       FFI512 - WXISF512   - Path para pacote
                ISIS        FFIG4 - WXISFG4    - Path para pacote
                ISIS       FFI4G4 - WXISF4G4   - Path para pacote
                ISIS       FFI256 - WXISF256   - Path para pacote
                ISIS     FFI512G4 - WXISF512G4 - Path para pacote
    wish list :	1- fazer isso
		2- fazer aquilo
		3- aceitar padrao tal ou qual
COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200101 Texto que descreve todas as alteracoes implementada ate esta data,
         desde a ultima 'publicacao" de versao. Observe que aqui o texto
         deve ter a largura limitada e nao deve utilizar TAB no recuo da
         linha, pois eh a base da formatacao da saida.
SPICEDHAM

