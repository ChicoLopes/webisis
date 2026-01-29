#!/bin/bash

# -------------------------------------------------------------------------- #
# pubdaily.sh - Processamento para publicar base de dados diariamente na Web
# -------------------------------------------------------------------------- #
# PARM1		Nome da base de dados
# Opcoes de execucao:
# --changelog            Mostrar o histórico de alteracoes
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -D, --debug N          Nivel de depuracao
# -h, --help             Mostra o HELP
# -V, --version          Mostra a versao do programa
#    corrente:           N/A
#     Chamada:           .
#     exemplo:           .
#   Objetivos:           Limpar a base de dados e gerar invertido de busca via Web
# Comentarios:           Operacao basica descrita a seguir:
#		Apaga base no destino (se houver)
#		Efetua uma copia limpa da base de dados para uma base de trabalho
#		Remonta a base de dados eliminando registros apagados
#		Inverte a base segundo a FST de publicacao Web
#		Garante disponibilidade de local para o resultado
#		Converte para LINUX
#		Coloca a FST na area de publicacao
#		Elimina o lixinho temporario
#		Fim da tarefa
#   Alguns simbolos previamente definidos criados na instalacao:
#    QAPLA  Local de instalacao do pacote de software
#    INFRA  Local de rotinas comuns de infraestrutura
#     LIBS  Local das bibliotecas utilizadas nos processamentos
#     ISIS  Local do pacote CISIS versao 1030
# ISIS1660  Local do pacote CISIS versao 1660
#   _BIT0_  Constante mascara do bit 0
#   _BIT1_  Constante mascara do bit 1
#   _BIT2_  Constante mascara do bit 2
#   _BIT3_  Constante mascara do bit 3
#   _BIT4_  Constante mascara do bit 4
#   _BIT5_  Constante mascara do bit 5
#   _BIT6_  Constante mascara do bit 6
#   _BIT7_  Constante mascara do bit 7
#   wish list:           .
# -------------------------------------------------------------------------- #
# QAPLA Comercio e Servicos de Informatica Ltda-ME
# CNPJ: 05.129.080/0001-01          QAPLA (p) 2020
# -------------------------------------------------------------------------- #
# Historico
# versao data, Responsavel
#	- Descricao
cat > /dev/null <<HISTORICO
vrs:  0.00 20200413, FJLopes
	- Edicao original
HISTORICO

# ========================================================================== #
# BIBLIOTECAS
# ========================================================================== #
# Incorpora a biblioteca bibliteca
#source	$PATH_EXEC/inc/bibliteca.inc
# A biblioteca conta com as funcoes:
# rdLIV		--	--	Retorna informacoes sobre a bibliteca
# rdVERSION	PARM1	x	Versao do qualquer coisa

# Incorpora a biblioteca de controle basico de processamento
source	$LIBS/infoini.inc
# A biblioteca conta com as funcoes:
#    void | chkError ARGUMENTO1 ARGUMENTO2
#    void | del ARGUMENTO1 ARGUMENTO2 ... ARGUMENTOn
#  string | hms ARGUMENTO
# boolean | isNumber ARGUMENTO
#    void | iVersao
# boolean | parseLine ARGUMENTO1 ARGUMENTO2 ARGUMENTO_OPCIONAL
#    void | rdBreak
#  string | rdConfig ARGUMENTO
#    void | timemark
#
# Esta biblioteca estabelece as variaveis:
# DIRINI Diretorio corrente no momento da carga
# HINIC  Tempo inicial em segundo desde 01/01/1970
# HRINI  Hora de inicio no formato YYYYMMDD hh:mm:ss
# _dow_  Dia da semana abreviado
# _DOW_  Dia da semana 0 (domingo) a 6 (sabado)
# _DIA_  Dia calendario no formato DD
# _MES_  Mes calendaroi no formato MM
# _ANO_  Ano calendario no formato YYYY
# DTISO  Data calendario no formato YYYYMMDD
# PRGEXE Nome do programa em execucao
# PRGNAM Denominacao do programa em execucao (exclui a extensao)
# PRGDIR Path para o programa em execucao
# ARG_IN Linha de comando original da chamada
# CTSTOP Controle de parada pelo operador (pare<ENTER)
# DEBUG  Nivel de depuracao (default 0)
# FAKE   Flag de execucao falsa (default Off)

# Incorpora carregador de valores criticos default
source	$PRGDIR/inc/pubdaily.lddefault.inc
# Incorpora dump de debug
source	$LIBS/common.debug.inc
source	$PRGDIR/inc/pubdaily.debug.inc
# Incorpora HELP e tratador de opcoes
source	$PRGDIR/inc/pubdaily.mhelp_opc.inc
# Assume as configurações padrao do programa
source	$PRGDIR/inc/pubdaily.config.inc

# Ponto de interrupcao se permitida
rdBreak

# Le arquivo de configuracao para processamento da base e outros ajustes
CONFIG=$(echo "etc/$PARM1.cfg")
PATH_IN=$(rdConfig "PATH_BASE_IN")
PATH_OUT=$(rdConfig "PATH_BASE_OUT")
PATH_WEB=$(rdConfig "PATH_BASE_WEB")

BASE_IN="$PATH_IN/$PARM1"
BASE_OUT="$PATH_OUT/$PARM1"
BASE_WEB="$PATH_WEB/$PARM1"
dump_config

# Verifica condicoes de processamento
# Base disponivel
BASE_INok=$( ([[ -f "$BASE_IN.xrf" ]] && [[  -f "$BASE_IN.mst" ]]) && echo TRUE || echo FALSE )
#BASE_INok=$( [[ -f "$BASE_IN.xrf" ] -a [  -f "$BASE_IN.mst" ]] && echo TRUE || echo FALSE )
# Verifica disponibilidade de fst e stw
FST_ADMok=$( [[ -f "fsts/${PARM1}.fst" ]]     && echo TRUE || echo FALSE )
STW_ADMok=$( [[ -f "fsts/${PARM1}.stw" ]]     && echo TRUE || echo FALSE )
FST_WEBok=$( [[ -f "fsts/${PARM1}.web.fst" ]] && echo TRUE || echo FALSE )
STW_WEBok=$( [[ -f "fsts/${PARM1}.web.stw" ]] && echo TRUE || echo FALSE )
dump_previas



sleep 1

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	$LIBS/infofim.inc
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


@echo off
if exist edi.xrf del edi.xrf
if exist edi.mst del edi.mst
cisis\1660\mxcp ..\edi\edi create=work clean log=edi.clean
cisis\1660\mx work append=edi -all now tell=1000 "proc=('Ggizmos\gansmi,120')"
if exist work.xrf del work.*
cisis\1660\mx edi "fst=@fsts\edi.fst" actab=tabs\ac850.tab uctab=tabs\uc850.tab fullinv=edi tell=5000
if not exist bases         mkdir bases
if not exist bases\iah     mkdir bases\iah
if not exist bases\iah\fst mkdir bases\iah\fst
if not exist bases\iah\edi mkdir bases\iah\edi
if not exist linux         mkdir linux
if not exist linux\iah     mkdir linux\iah
if not exist linux\iah\fst mkdir linux\iah\fst
if not exist linux\iah\edi mkdir linux\iah\edi
cisis\1660\crunchmf edi linux\iah\edi\edi 
cisis\1660\crunchif edi linux\iah\edi\edi 
# Coloca base na area de publicacao Web
move edi.xrf bases\iah\edi > nul
move edi.mst bases\iah\edi > nul
move edi.cnt bases\iah\edi > nul
move edi.ifp bases\iah\edi > nul
move edi.l0? bases\iah\edi > nul
move edi.n0? bases\iah\edi > nul
copy fsts\edi.fst bases\iah\fst > nul
copy fsts\edi.fst linux\iah\fst > nul
echo Tecle ENTER para fechar esta janela
pause > nul

COMMENT
# ------------------------------------------------------------------------- #
cat > /dev/null <<SPICEDHAM
CHANGELOG
20200313 Versao e edicao originais do processamento de bases de dados
SPICEDHAM

