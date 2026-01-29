# -------------------------------------------------------------------------- #
# emailme - Envia email para enderecos conforme lista de controle
# -------------------------------------------------------------------------- #
# Entrada      : Parm 1 com o Assunto da mensagem
#                Parm 2 com o arquivo do texto a ser enviada como mensagem
# Saida        : True se enviou Ok
#              : False se o envio nao funcionou
# Dependencias : arquivo uadm (usuarios administradores) em ../tabs
# Fluxo        : Inicio
#                  Se nao tem UADM (em ../tabs) FIM
#                  Se nao tem parametro 2 de entrada gera arquivo vazio
#                  Se nao tem parametro 1 de entrada gera assunto padrao
#                  Le relogio/calendario do servidor
#                  Le arquivo de controle (UADM)
#                  Gera o shell "externo" (zemail.sh)
#                  Executa o shell "externo"
#                  Limpa area de trabalho
#                Fim
# Procs        : WDAY.PRC - Nomeia dias para envio de e-mail primario
#                ODAY.PRC - Nomeia dias para envio de e-mail alternativo
# Formatos     : WEMAIL.PFT - Formato para montar shell de envio primario
#                OEMAIL.PFT - Formato para montar shell de envio alternativo
# Comentarios  : O arquivo de controle, chamado uadm.txt, deve estar
#                  localizado no diretorio tabs do processamento.
#                Caso o arquivo uadm.txt nao exista nao havera qqr envio
#                A formacao do arquivo eh a seguinte:
#                  Linhas contendo o caracater * contem dados de controle
#                  Os campos na linha sao separados pelo caracter pipe
#                  O primeiro campo eh posicional e cada posicao representa
#                    um dia na semana. Posicoes com * estao marcando o dia,
#                    por exemplo:
#                        *-*-*--, indica segunda, quarta e sexta
#                        **-**--, indica segunda, terca, quinta e sexta
#                        -----**, indica sabado e domingo
#                  O segundo campo contem o endereco de e-mail padrao
#                  O terceiro campo contem o endereco de e-mail alternativo
#                  O quarto campo contem a hora+minuto de inicio de validade
#                    do endereco padrao de e-mail
#                  O quinto campo contem a hora+minuto de termino de validade
#                    do endereco padrao de e-mail
#                  Os dados do controle operam da seguinte maneira:
#                    E-mails para o endereco padrao so sao enviados nos dias
#                      da semana marcados
#                    Se existir endereco alternativo de e-mail, nos dias nao
#                      marcados, os e-mails sao enviados para ele
#                    Se existir hora de inicio (deve existir hora de fim) o
#                      endereco de e-mail padrao so sera usado dentro do 
#                      intervalo definido, fora dele utiliza-se o endereco
#                      alternativo
#
# Exemplos     : *****--|johndoe@nowhere.com|johndoe@anywhere.com|0800|1700
#                  de segunda a sexta, das 08h00 as 17h00 johndoe@nowhere.com
#                  receberah os e-mails, nos demais dias e horarios,
#                  johndos@anywhere.com os recebera
#                *******|bob@nowhere.com
#                  em qualquer dia e hora bob@nowhere.com receberah os e-mails
#                *****--|mary@nowhere.com
#                  de segunda a sexta em qualquer hora, e em mais nenhum outro
#                  momento mary@nowhere.com receberah os e-mails
#                *****--|
#
# -------------------------------------------------------------------------- #
# Verifica se ha o controle de envio para o processamento
if [ ! -f ../tabs/uadm.txt ]
then
  echo "Sem envio de e-mail!"
  exit 0
fi

TPR="start"
. log

# -------------------------------------------------------------------------- #
# Avalia os parametros de entrada
if [ "$#" -gt 2 ]
then
  TPR="fatal"
  MSG="Sintaxe: emailme.sh [subject] [text_file]"
  . log
fi

# -------------------------------------------------------------------------- #
# Cria, se necessario, arquivo vazio para envio na mensagem sem corpo

[ "$#" -lt 2 ] && touch nulo.txt

# -------------------------------------------------------------------------- #
# Trata o parametro 1 (se houver)
if [ "$#" -ge 1 ]
then
  SUBJ=$1
else
  SUBJ="Mensagem de `uname -n`"
fi

# -------------------------------------------------------------------------- #
# Determina valores de relogio para verificacao de regras de envio

WDAY=`date|cut -d" " -f1`
HOUR=`date|cut -c12-13`
MINU=`date|cut -c15-16`

# Apoio a depuracao (para operacao comentar)
# echo "Hoje eh: "$WDAY", e agora sao: "$HOUR$MINU

# -------------------------------------------------------------------------- #
# Forma a base de dados de controle de envio

[ -f uadm.xrf ] && rm uadm.*
mx seq=../tabs/uadm.txt create=work -all now
mx work "proc=if v1:'*' then else 'd*' fi" append=uadm -all now
[ -f  work.xrf ] && rm work.*

# -------------------------------------------------------------------------- #
# Monta a PROC que cria V6 com WORK DAYS
# Monta a PROC que cria V6 com DAYS OFF

echo "if v1*0.1='*' then 'a6~Mon~' fi,">wday.prc
echo "if v1*0.1='-' then 'a6~Mon~' fi,">oday.prc
echo "if v1*1.1='*' then 'a6~Tue~' fi,">>wday.prc
echo "if v1*1.1='-' then 'a6~Tue~' fi,">>oday.prc
echo "if v1*2.1='*' then 'a6~Wed~' fi,">>wday.prc
echo "if v1*2.1='-' then 'a6~Wed~' fi,">>oday.prc
echo "if v1*3.1='*' then 'a6~Thu~' fi,">>wday.prc
echo "if v1*3.1='-' then 'a6~Thu~' fi,">>oday.prc
echo "if v1*4.1='*' then 'a6~Fri~' fi,">>wday.prc
echo "if v1*4.1='-' then 'a6~Fri~' fi,">>oday.prc
echo "if v1*5.1='*' then 'a6~Sat~' fi,">>wday.prc
echo "if v1*5.1='-' then 'a6~Sat~' fi,">>oday.prc
echo "if v1*6.1='*' then 'a6~Sun~' fi,">>wday.prc
echo "if v1*6.1='-' then 'a6~Sun~' fi,">>oday.prc

# -------------------------------------------------------------------------- #
# Formato que implementa a regra para WORK DAY

echo "(">wemail.pft
echo " if v6='$WDAY' then ">>wemail.pft
if [ "$#" -eq 2 ]
then
  echo "  if v4[1]='' then 'mail -s \"$SUBJ\" ',v2[1]' <$2',/, fi,">>wemail.pft
  echo "  if val('$HOUR$MINU')>=val(v4[1]) and val('$HOUR$MINU')<=val(v5[1]) then">>wemail.pft
  echo "    'mail -s \"$SUBJ\" 'v2[1],' <$2',/,">>wemail.pft
  echo "  else if v3[1]>'' then">>wemail.pft
  echo "    'mail -s \"$SUBJ\" 'v3[1],' <$2',/,">>wemail.pft
else
  echo "  if v4[1]='' then 'mail -s \"$SUBJ\" ',v2[1]' <nulo.txt',/, fi,">>wemail.pft
  echo "  if val('$HOUR$MINU')>=val(v4[1]) and val('$HOUR$MINU')<=val(v5[1]) then">>wemail.pft
  echo "    'mail -s \"$SUBJ\" 'v2[1],' <nulo.txt',/,">>wemail.pft
  echo "  else if v3[1]>'' then">>wemail.pft
  echo "    'mail -s \"$SUBJ\" 'v3[1],' <nulo.txt',/,">>wemail.pft
fi
echo "  fi,">>wemail.pft
echo "  fi,">>wemail.pft
echo " fi,">>wemail.pft
echo "),">>wemail.pft

# -------------------------------------------------------------------------- #
# Formato que implementa a regra para DAY OFF

echo "if p(v3) then ">oemail.pft
echo " (">>oemail.pft
echo "  if v6='$WDAY' then">>oemail.pft
if [ "$#" -eq 2 ]
then
  echo "    'mail -s \"$SUBJ\" 'v3[1],' <$2',/,">>oemail.pft
else
  echo "    'mail -s \"$SUBJ\" 'v3[1],' <nulo.txt',/,">>oemail.pft
fi
echo "  fi,">>oemail.pft
echo " ),">>oemail.pft
echo "fi,">>oemail.pft

# -------------------------------------------------------------------------- #
# Cria o shell de envio de e-mail

mx uadm lw=99999 "proc=@wday.prc" "pft=@wemail.pft" now -all>zemail.sh
mx uadm lw=99999 "proc=@oday.prc" "pft=@oemail.pft" now -all>>zemail.sh

# -------------------------------------------------------------------------- #
# Prepara para execucao efetiva, e executa

if [ -s zemail.sh ]
then
  chmod 755 zemail.sh

  TPR="iffatal"
  MSG="Enviando mensagem automatica por emailme.sh"
  ./zemail.sh
  . log

  rm zemail.sh
fi

# -------------------------------------------------------------------------- #
# Limpa area de trabalho

[ -f uadm.xrf ] && rm uadm.mst uadm.xrf
[ -f wday.prc ] && rm wday.prc
[ -f oday.prc ] && rm oday.prc
[ -f nulo.txt ] && rm nulo.txt
[ -f wemail.pft ] && rm wemail.pft
[ -f oemail.pft ] && rm oemail.pft

TPR="end"
. log
