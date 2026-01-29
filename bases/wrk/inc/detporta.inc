# -------------------------------------------------------------------------- #
# Determina porta a ser usada para operacao com servidores
# -------------------------------------------------------------------------- #
# ATENCAO:	A cada novo servidor que deva receber tratamento
#		diferenciado este arquivo deve ser atualizado

# Experimenta se deve comunicar por porta alternativa
case "$B_EXT" in

# Servidores que requerem portas alternativas
	*pr20dx*)
		PORTA="-P 8022"
	;;

	*pr10vm*)
		PORTA="-P 8022"
	;;

	*db01dx*)
		PORTA="-P 8022"
	;;

	*db02dx*)
		PORTA="-P 8022"
	;;

# Nao requer porta alternativa
	*)
		PORTA=""
	;;

esac
