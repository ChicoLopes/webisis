# -------------------------------------------------------------------------- #
# Assume valores default do processamento

FAKE=0;		# Modo FAKE para similar o fluxo apenas
N_DEB=0;	# Nivel de mensagens de depuracao
DEBUG="0";	# Modo de DEBUG

NOXMT="0";	# FLAG de execucao
OPC_XMT="";	# Opcao de chamada

NOERRO="0";	# FLAG de execucao
OPC_ERRO="";	# Opcao de chamada

[ -f "instancias.rol" ] && rm -f instancias.rol
