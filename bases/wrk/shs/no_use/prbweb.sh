#!/bin/bash

# -------------------------------------------------------------------------- #
# prbweb.sh - Processamento diario para publicacao Web de base de dados
# -------------------------------------------------------------------------- #
# VIDE A SESSAO COMMENT na porcao final do arquivo para detalhamento completo
# PARM1		Nome da base de dados
# Opcoes de execucao:
#     --changelog        Exibe o histórico de alteracoes e para a execucao
# -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
# -d, --debug NIVEL      Define nivel de depuracao com valor numerico positivo
#     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
# -h, --help             Exibe este texto de ajudae para a execucao
#     --stop             Habilita a verificacao de parada pelo operador com "pare<ENTER>"
# -V, --version          Exibe a versao corrente e para a execucao
#   Chamada geral:       ./prbweb.sh -opcoes <parm1>
# Chamada exemplo:       ./prbweb.sh -d 1 --stop edi
#       Objetivos:       Limpar a base de dados e gerar invertido de busca via Web
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
# 'orpora a biblioteca bibliteca
#source	$PATH_EXEC/inc/bibliteca.inc
# A biblioteca conta com as funcoes:
# rdLIV		--	--	Retorna informacoes sobre a biblioteca
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

# Incorpora carregador de valores default
source	$PRGDIR/inc/prbweb.lddefault.config.inc
# Incorpora HELP e tratador de opcoes
source	$PRGDIR/inc/prbweb.mhelp_opc.config.inc

# Ponto de interrupcao se permitida
rdBreak
echo "Olá!"

#--------------------------------------------------------------------------- #
# Testa condições de operação
[ -f "saida/$PARM1/$PARM1.mst" ] && rm saida/$PARM1/$PARM1.mst
[ -f "saida/$PARM1/$PARM1.xrf" ] && rm saida/$PARM1/$PARM1.xrf
[ -f "saida/$PARM1/$PARM1.cnt" ] && rm saida/$PARM1/$PARM1.cnt
[ -f "saida/$PARM1/$PARM1.ifp" ] && rm saida/$PARM1/$PARM1.ifp
[ -f "saida/$PARM1/$PARM1.l01" ] && rm saida/$PARM1/$PARM1.l01
[ -f "saida/$PARM1/$PARM1.l02" ] && rm saida/$PARM1/$PARM1.l02
[ -f "saida/$PARM1/$PARM1.n01" ] && rm saida/$PARM1/$PARM1.n01
[ -f "saida/$PARM1/$PARM1.n02" ] && rm saida/$PARM1/$PARM1.n02

sleep 5

# Incorpora a biblioteca de controle basico de processamento contabilizacao de fim de execucao
source	$LIBS/infofim.inc
# -------------------------------------------------------------------------- #
cat > /dev/null <<COMMENT

        Entrada : PARM1  nome do arquivo (e caminho) com lista de URL a testar
                Opcoes de execucao
                     --changelog        Exibe o histórico de alteracoes e para a execucao
                 -c, --config NOMEARQU  Utilizar configuracoes do arquivo NOMEARQU
                 -d, --debug NIVEL      Define nivel de depuracao com valor numerico positivo
                     --fake             Execucao simulada nao executa alteracoes em bases e arquivos
                 -h, --help             Exibe este texto de ajudae para a execucao
                     --stop             Habilita a verificacao de parada pelo operador com "pare<ENTER>"
                 -V, --version          Exibe a versao corrente e para a execucao
          Saida : Base de dados limpa e indexada no diretorio ./saida
  Dir. corrente :       qualquer
  Chamada geral :       ./prbweb.sh -opcoes <parm1>
Chamada exemplo :       ./prbweb.sh -d 1 --stop edi
    Objetivo(s) :       Limpar a base de dados e gerar invertido de busca via Web
    Comentarios : Operacao basica descrita a seguir:
                  1-Apaga base no destino (se houver)
                  2-Efetua uma copia limpa da base de dados para uma base de trabalho
                  3-Remonta a base de dados eliminando registros apagados
                  4-Inverte a base segundo a FST de publicacao Web
                  5-Garante disponibilidade de local para o resultado
                  6-Converte para LINUX
                  7-Coloca a FST na area de publicacao
                  8-Elimina o lixinho temporario
                  9-Fim da tarefa
    Observacoes : DEBUG eh uma variavel numerica de 0 (sem debug) a x
          Notas : Deve ser executado como usuario 'isis'
      wish list : 1- fazer isso
                  2- fazer aquilo
                  3- aceitar padrao tal ou qual
   Dependencias : Variaveis de ambiente que devem estar previamente ajustadas:
                  profil_qapla      QAPLA  Local de instalacao do pacote de software
                  profil_qapla      INFRA  Local de rotinas comuns de infraestrutura
                  profil_here        LIBS  Local das bibliotecas utilizadas nos processamentos
                  profil_here        CRON  Local das rotinas de ambientacao de cromtab
                  profil_here      _BIT0_  Constante mascara do bit 0
                  profil_here      _BIT1_  Constante mascara do bit 1
                  profil_here      _BIT2_  Constante mascara do bit 2
                  profil_here      _BIT3_  Constante mascara do bit 3
                  profil_here      _BIT4_  Constante mascara do bit 4
                  profil_here      _BIT5_  Constante mascara do bit 5
                  profil_here      _BIT6_  Constante mascara do bit 6
                  profil_here      _BIT7_  Constante mascara do bit 7
                  profil_isis        ISIS  Local do pacote CISIS versao 1030
                  profil_isis *     ISISG  Local do pacote CISIS versao isisG
                  profil_isis    ISIS1660  Local do pacote CISIS versao 1660
                  profil_isis *      LIND  Local do pacote CISIS versao Lind
                  profil_isis *   LIND512  Local do pacote CISIS versao Lind512
                  profil_isis *       FFI  Local do pacote CISIS versao FFI
                  profil_isis *    FFI512  Local do pacote CISIS versao FFI512
                  profil_isis *   BIGISIS  Local do pacote CISIS versao BigIsis
                  profil_isis *    LINDG4  Local do pacote CISIS versao LindG4
                  profil_isis * LIND512G4  Local do pacote CISIS versao Lind512G4
                  profil_isis *     FFIG4  Local do pacote CISIS versao FFIG4
                  profil_isis *  FFI512G4  Local do pacote CISIS versao FFI512G4
                  profil_isis        TABS  Path para as tabelas de uso geral
                  profil_isis      GIZMOS  Path para as bases de conversao
                  profil_isis       BASES  Path para as bases ISO3166 e ISO-639
                  -----------  -----------------------------------------------------------
                  geral             MISC - Path para o diretorio de miscelaneas da BIREME
                  geral         TRANSFER - Usuario para troca de arquivos entre servidores
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
                  Tabela wxyz.tab deve estar presente em $PATH_EXEC/tabs
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

