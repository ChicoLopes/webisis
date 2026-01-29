# ------------------------------------------------------------------------- #
# profile.sh - Ajustes de ambiente usuais para servidores OFI
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis        Comentarios
# 20090514  MBottura/FJLopes    Edicao original
# 20091015  FJLopes             Adicao da variavel BIREME (=OFI)
# 20120712  FJLopes             Inclusao de $MISC no PATH padrao

. /usr/local/bireme/misc/profil_isis

. /usr/local/bireme/misc/profil_java

# Nao instalado
#. /usr/local/bireme/misc/profil_mongo

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
