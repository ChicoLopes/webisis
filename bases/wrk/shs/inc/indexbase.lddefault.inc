# -------------------------------------------------------------------------- #
# Assume valores default do processamento
# de forma geral todos os valores podem ser alterados no mhelp_opc do shell

FAKE=0
DEBUG=0
CTSTOP=0

# Controle de erros
NOERRO="0"
OPC_ERRO=""

# Uso de arquivo Stop Words
NOSTW=0

# Flag relacionados com o arquivo índice
	# Quando vazio é assumido que a FST tem nome igual ao nome da base de dados
FST=""
	# Quando ajustado com 0 o arquivo de índice tem o mesmo nome da base de dados
BASEFST=0
	# Quando ajustado com 0 a indexação para administração de dados
WEB=0

# Conjunto de caracteres válido e conversão para maiúsculas
CHARSET="actab=${TABS}/acans.tab uctab=${TABS}/ucans.tab"