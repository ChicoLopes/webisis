# ------------------------------------------------------------------------- #
# profile.sh - Ajustes de ambiente usuais para servidores OFI
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis        Comentarios
# 20090514  MBottura/FJLopes    Edicao original
# 20091015  FJLopes             Adicao da variavel BIREME (=OFI)
# 20120712  FJLopes             Inclusao de $MISC no PATH padrao
# 20150316  FJLopes		Inclusao das 'constantes' de bit
# 20150824  FBrito              Inclusao de SENDER_MAIL - usuario permitido para enviar e-mail via sendmail
#

# Nao instalado
#. /usr/local/bireme/misc/profil_mongo

. /usr/local/bireme/misc/profil_isis

. /usr/local/bireme/misc/profil_java

. /usr/local/bireme/misc/profil_here

# Localizacao de bases, tabelas e dados auxiliares gerais
export	     OFI="/usr/local/bireme"
export	  BIREME="$OFI"
export	    TABS="$OFI/tabs"
export	    MISC="$OFI/misc"
export	    CRON="$OFI/cron"
export	   PROCS="$OFI/procs"

export	TRANSFER="transfer"

export	SENDER_MAIL="serverofi"

