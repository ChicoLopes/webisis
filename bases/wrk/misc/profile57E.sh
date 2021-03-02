# ------------------------------------------------------------------------- #
# profile.sh - Ajustes de ambiente usuais para servidores OFI
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis        Comentarios
# 20090514  MBottura/FJLopes    Edicao original
# 20091015  FJLopes             Adicao da variavel BIREME (=OFI)
# 20120712  FJLopes             Inclusao de $MISC no PATH padrao
# 20140919  FJLopes		Alteracao para comtemplar selecao de versao de CISIS

. /usr/local/bireme/misc/profil_isis57E

. /usr/local/bireme/misc/profil_java

. /usr/local/bireme/misc/profil_here

# Localizacao de bases, tabelas e dados auxiliares gerais
     OFI="/usr/local/bireme"
  BIREME="$OFI"
    TABS="$OFI/tabs"
    MISC="$OFI/misc"
    CRON="$OFI/cron"
   PROCS="$OFI/procs"

TRANSFER="transfer"

# Coloca tudo disponivel para o ambiente operativo
# ------------------------------------------------
# Ambiente basico do servidor
#	.	.	.	.	.	.    .		.
export  OFI     BIREME  TABS    MISC    PROCS   CRON TRANSFER	DECS
