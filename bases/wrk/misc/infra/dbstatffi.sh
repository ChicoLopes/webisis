#!/bin/bash
# ------------------------------------------------------------------------- #
# Procedimento para gerar relatorios estatisticos das bases de dados
# ------------------------------------------------------------------------- #
# chamada: dbstat <base_in> [conj_char]
#   parm1: Nome (e caminho) da base de dados
#   parm2: conjunto de caracteres empregado na base de dados podendo valer
#            ASC    - Utilizado no DOS, com CODE PAGE 850
#            ASCII  - Utilizado no DOS, com CODE PAGE 850
#            ANSI   - Utilizado no ambiente WEB
#            EBCDIC - Utilizado nas fitas do Medline
#            FLAT   - Nao associa simbolos, so frequencia e codigos
#   saida: Arquivo BASE_IN.sta com o relatorio da analise
# ANTECAO: NAO USO O CISIS DO PATH
# ------------------------------------------------------------------------- #
# Data      Resp         Comentario
# 19931121  Renato       Edicao original
# 19940119  Renato       Atualizacao
# 20001030  fjlopes      Insercao do parametro de conjunto de caracteres
# 20040425  fjlopes      Alteracao de legenda no banner
# 20080331  FJLopes/EB   Ajuste para oprar com versao corrente de CISIS FFI
#

TPR="start"
RST="$1.sta"
. log

if [ "$#" -lt 1 -o "$#" -gt 2 ]
then
  TPR="fatal"
  MSG="use: dbsta <dbn> [ascii/ansi/ebcdic/flat]"
  . log
fi

# ------------------------------------------------------------------- #
# Verifica se o arquivo existe            

if [ ! -f "$1.xrf" ]
then
  TPR="fatal"
  MSG="error: $1.xrf not found"
  . log
fi

if [ ! -f "$1.mst" ]
then
  TPR="fatal"
  MSG="error: $1.mst not found"
  . log
fi

# ------------------------------------------------------------------- #
# Gera base de dados estatistica

. scrmaxffi
TPR="iffatal"
MSG="error: mxf0 can not create database"
#$FFI/mxf0 $1 create=stat $MAXMFN noedit
$FFI/mxf0 $1 create=stat 0 noedit
. log

# ------------------------------------------------------------------- #
# Gera formato de distribuicao de TAG


echo "'BIREME/OPS/OMS - OFI                          Data Base Statistical Analisys',/,"> 1.pft
echo "'                      Tag Distribution Analisys - TDA',/#,">> 1.pft
echo "'-----------------------------------------------------------------------------',/#,">> 1.pft
echo "if p(v1001) then" >> 1.pft
echo " | Data Base name : |v1001" >> 1.pft
echo "fi," >> 1.pft
echo "if p(v1003) then" >> 1.pft
echo " c45," >> 1.pft
echo " 'Analisys Date : ',v1003*6.2,'/',v1003*4.2,'/',v1003*0.4,/," >> 1.pft
echo "fi,/," >> 1.pft
echo "'   Total Records : 'v1009,/#," >> 1.pft
echo "'-----------------------------------------------------------------------------',/," >> 1.pft
echo "'   TAG  Presence Percent   Ocorr. Rep     Length         Total',/,">> 1.pft
echo "'   (#)    (abs)    (%)     (abs)  (R)   min    max       Carac.',/,'">> 1.pft
echo "'-----------------------------------------------------------------------------'/#," >> 1.pft
echo "(">> 1.pft
echo " c3,">> 1.pft
echo " f(val(v1020^t),4,0),">> 1.pft
echo " c9,">> 1.pft
echo " f(val(v1020^d),7,0),">> 1.pft
echo " c19,">> 1.pft
echo " f(100*val(v1020^d)/val(v1009[1]),5,1),">> 1.pft
echo " c26,">> 1.pft
echo " f(val(v1020^o),7,0),">> 1.pft
echo " c36,">> 1.pft
echo " select val(v1020^o)/val(v1020^d)">> 1.pft
echo "  case 1: '  '">> 1.pft
echo "  elsecase 'R '">> 1.pft
echo " endsel,">> 1.pft
echo " c39,">> 1.pft
echo " f(val(v1020^l),5,0),">> 1.pft
echo " c46,">> 1.pft
echo " f(val(v1020^u),5,0),">> 1.pft
echo " c53,">> 1.pft
echo " f(val(v1020^n),10,0),/">> 1.pft
echo ")/##">> 1.pft

# ------------------------------------------------------------------- #
# Gera os arquivos relatorios

TPR="iffatal"
MSG="error: mx can't create report $1.sta with TAG analisys format"
$FFI/mx stat pft=@1.pft -all now > $1.sta
. log

if [ "$#" -eq 2 ]
then

  echo "">>$1.sta

# ------------------------------------------------------------------- #
# Define conjunto de caracteres para analise

  if [ "$2" = "ANSI" -o "$2" = "ansi" ]
  then
        # Conjunto de caracteres ANSI (WINDOWS)
        echo "'BIREME/OPS/OMS - OFI                          Data Base Statistical Analisys',/,"> 1.pft
        echo "'                   ANSI Character Distribution Analisys',/,">>1.pft
        echo "'-----------------------------------------------------------------------------',/#,">> 1.pft
        echo "if p(v1001) then" >> 1.pft
        echo " |  Data Base name : |v1001" >> 1.pft
        echo "fi," >> 1.pft
        echo "if p(v1003) then" >> 1.pft
        echo " c45," >> 1.pft
        echo " '  Analisys Date : ',v1003*6.2,'/',v1003*4.2,'/',v1003*0.4,/," >> 1.pft
        echo "fi,/," >> 1.pft
        echo "'   Total Records : 'v1009,/#," >> 1.pft
        echo "'-----------------------------------------------------------------------------',/,">>1.pft
        echo "'  Char                     Occurences',/,">>1.pft
        echo "'HEX  DEC',/,">>1.pft
        echo "'-------------------------------------',/#,">>1.pft
        echo "(">>1.pft
        echo " c02,">>1.pft
        echo " v1030^x,">>1.pft
        echo " select v1030^x">>1.pft
        #REM                       123456789012345678
        echo "  case '00': '   00  NUL'">>1.pft
        echo "  case '01': '   01  SOH'">>1.pft
        echo "  case '02': '   02  STX'">>1.pft
        echo "  case '03': '   03  ETX'">>1.pft
        echo "  case '04': '   04  EOT'">>1.pft
        echo "  case '05': '   05  ENQ'">>1.pft
        echo "  case '06': '   06  ACK'">>1.pft
        echo "  case '07': '   07  BEL'">>1.pft
        echo "  case '08': '   08  BS'">>1.pft
        echo "  case '09': '   09  HT'">>1.pft
        echo "  case '0a': '   10  LF'">>1.pft
        echo "  case '0b': '   11  VT'">>1.pft
        echo "  case '0c': '   12  FF'">>1.pft
        echo "  case '0d': '   13  CR'">>1.pft
        echo "  case '0e': '   14  SO'">>1.pft
        echo "  case '0f': '   15  SI'">>1.pft
        echo "  case '10': '   16  DLE'">>1.pft
        echo "  case '11': '   17  DC1'">>1.pft
        echo "  case '12': '   18  DC2'">>1.pft
        echo "  case '13': '   19  DC3'">>1.pft
        echo "  case '14': '   20  DC4'">>1.pft
        #REM                       123456789012345678
        echo "  case '15': '   21  NAK'">>1.pft
        echo "  case '16': '   22  SYN'">>1.pft
        echo "  case '17': '   23  ETB'">>1.pft
        echo "  case '18': '   24  CAN'">>1.pft
        echo "  case '19': '   25  EM'">>1.pft
        echo "  case '1a': '   26  SUB'">>1.pft
        echo "  case '1b': '   27  ESCAPE'">>1.pft
        echo "  case '1c': '   28  FS'">>1.pft
        echo "  case '1d': '   29  GS'">>1.pft
        echo "  case '1e': '   30  RS'">>1.pft
        echo "  case '1f': '   31  US'">>1.pft
        echo "  case '20': '   32  SPACE'">>1.pft
        echo "  case '21': '   33  EXCLAMACAO'">>1.pft
        echo "  case '22': '   34  ASPAS'">>1.pft
        echo "  case '23': '   35  #'">>1.pft
        echo "  case '24': '   36  CIFRAO'">>1.pft
        echo "  case '25': '   37  PERCENT'">>1.pft
        echo "  case '26': '   38  E COMERCIAL'">>1.pft
        echo "  case '27': '   39  APOSTROFE'">>1.pft
        echo "  case '28': '   40  ('">>1.pft
        echo "  case '29': '   41  )'">>1.pft
        #REM                       123456789012345678
        echo "  case '2a': '   42  ASTERISCO'">>1.pft
        echo "  case '2b': '   43  +'">>1.pft
        echo "  case '2c': '   44  VIRGULA'">>1.pft
        echo "  case '2d': '   45  HIFEN'">>1.pft
        echo "  case '2e': '   46  PONTO FINAL'">>1.pft
        echo "  case '2f': '   47  /'">>1.pft
        echo "  case '30': '   48  DIGITO 0'">>1.pft
        echo "  case '31': '   49  DIGITO 1'">>1.pft
        echo "  case '32': '   50  DIGITO 2'">>1.pft
        echo "  case '33': '   51  DIGITO 3'">>1.pft
        echo "  case '34': '   52  DIGITO 4'">>1.pft
        echo "  case '35': '   53  DIGITO 5'">>1.pft
        echo "  case '36': '   54  DIGITO 6'">>1.pft
        echo "  case '37': '   55  DIGITO 7'">>1.pft
        echo "  case '38': '   56  DIGITO 8'">>1.pft
        echo "  case '39': '   57  DIGITO 9'">>1.pft
        echo "  case '3a': '   58  :'">>1.pft
        echo "  case '3b': '   59  ;'">>1.pft
        echo "  case '3c': '   60  MENOR'">>1.pft
        echo "  case '3d': '   61  ='">>1.pft
        echo "  case '3e': '   62  MAIOR'">>1.pft
        #REM                       123456789012345678
        echo "  case '3f': '   63  ?'">>1.pft
        echo "  case '40': '   64  @'">>1.pft
        echo "  case '41': '   65  A'">>1.pft
        echo "  case '42': '   66  B'">>1.pft
        echo "  case '43': '   67  C'">>1.pft
        echo "  case '44': '   68  D'">>1.pft
        echo "  case '45': '   69  E'">>1.pft
        echo "  case '46': '   70  F'">>1.pft
        echo "  case '47': '   71  G'">>1.pft
        echo "  case '48': '   72  H'">>1.pft
        echo "  case '49': '   73  I'">>1.pft
        echo "  case '4a': '   74  J'">>1.pft
        echo "  case '4b': '   75  K'">>1.pft
        echo "  case '4c': '   76  L'">>1.pft
        echo "  case '4d': '   77  M'">>1.pft
        echo "  case '4e': '   78  N'">>1.pft
        echo "  case '4f': '   79  O'">>1.pft
        echo "  case '50': '   80  P'">>1.pft
        echo "  case '51': '   81  Q'">>1.pft
        echo "  case '52': '   82  R'">>1.pft
        echo "  case '53': '   83  S'">>1.pft
        #REM                       123456789012345678
        echo "  case '54': '   84  T'">>1.pft
        echo "  case '55': '   85  U'">>1.pft
        echo "  case '56': '   86  V'">>1.pft
        echo "  case '57': '   87  W'">>1.pft
        echo "  case '58': '   88  X'">>1.pft
        echo "  case '59': '   89  Y'">>1.pft
        echo "  case '5a': '   90  Z'">>1.pft
        echo "  case '5b': '   91  ['">>1.pft
        echo "  case '5c': '   92  \\'">>1.pft
        echo "  case '5d': '   93  ]'">>1.pft
        echo "  case '5e': '   94  CIRCUNFLEXO'">>1.pft
        echo "  case '5f': '   95  _'">>1.pft
        echo "  case '60': '   96  AGUDO'">>1.pft
        echo "  case '61': '   97  a'">>1.pft
        echo "  case '62': '   98  b'">>1.pft
        echo "  case '63': '   99  c'">>1.pft
        echo "  case '64': '  100  d'">>1.pft
        echo "  case '65': '  101  e'">>1.pft
        echo "  case '66': '  102  f'">>1.pft
        echo "  case '67': '  103  g'">>1.pft
        echo "  case '68': '  104  h'">>1.pft
        #REM                       123456789012345678
        echo "  case '69': '  105  i'">>1.pft
        echo "  case '6a': '  106  j'">>1.pft
        echo "  case '6b': '  107  k'">>1.pft
        echo "  case '6c': '  108  l'">>1.pft
        echo "  case '6d': '  109  m'">>1.pft
        echo "  case '6e': '  110  n'">>1.pft
        echo "  case '6f': '  111  o'">>1.pft
        echo "  case '70': '  112  p'">>1.pft
        echo "  case '71': '  113  q'">>1.pft
        echo "  case '72': '  114  r'">>1.pft
        echo "  case '73': '  115  s'">>1.pft
        echo "  case '74': '  116  t'">>1.pft
        echo "  case '75': '  117  u'">>1.pft
        echo "  case '76': '  118  v'">>1.pft
        echo "  case '77': '  119  w'">>1.pft
        echo "  case '78': '  120  x'">>1.pft
        echo "  case '79': '  121  y'">>1.pft
        echo "  case '7a': '  122  z'">>1.pft
        echo "  case '7b': '  123  {'">>1.pft
        echo "  case '7c': '  124  PIPE'">>1.pft
        echo "  case '7d': '  125  }'">>1.pft
        #REM                       123456789012345678
        echo "  case '7e': '  126  TIL'">>1.pft
        echo "  case '7f': '  127  DELETE'">>1.pft
        echo "  case '80': '  128'">>1.pft
        echo "  case '81': '  129'">>1.pft
        echo "  case '82': '  130'">>1.pft
        echo "  case '83': '  131'">>1.pft
        echo "  case '84': '  132'">>1.pft
        echo "  case '85': '  133'">>1.pft
        echo "  case '86': '  134'">>1.pft
        echo "  case '87': '  135'">>1.pft
        echo "  case '88': '  136'">>1.pft
        echo "  case '89': '  137'">>1.pft
        echo "  case '8a': '  138'">>1.pft
        echo "  case '8b': '  139'">>1.pft
        echo "  case '8c': '  140'">>1.pft
        echo "  case '8d': '  141'">>1.pft
        echo "  case '8e': '  142'">>1.pft
        echo "  case '8f': '  143'">>1.pft
        echo "  case '90': '  144'">>1.pft
        echo "  case '91': '  145'">>1.pft
        echo "  case '92': '  146'">>1.pft
        #REM                       123456789012345678
        echo "  case '93': '  147'">>1.pft
        echo "  case '94': '  148'">>1.pft
        echo "  case '95': '  149'">>1.pft
        echo "  case '96': '  150'">>1.pft
        echo "  case '97': '  151'">>1.pft
        echo "  case '98': '  152'">>1.pft
        echo "  case '99': '  153'">>1.pft
        echo "  case '9a': '  154'">>1.pft
        echo "  case '9b': '  155'">>1.pft
        echo "  case '9c': '  156'">>1.pft
        echo "  case '9d': '  157'">>1.pft
        echo "  case '9e': '  158'">>1.pft
        echo "  case '9f': '  159'">>1.pft
        echo "  case 'a0': '  160  ESPACO'">>1.pft
        echo "  case 'a1': '  161  EXCLAMACAO INV'">>1.pft
        echo "  case 'a2': '  162  CENTS'">>1.pft
        echo "  case 'a3': '  163  LIBRAS'">>1.pft
        echo "  case 'a4': '  164'">>1.pft
        echo "  case 'a5': '  165  YENE'">>1.pft
        echo "  case 'a6': '  166'">>1.pft
        echo "  case 'a7': '  167  PARAGRAFO'">>1.pft
        #REM                       123456789012345678
        echo "  case 'a8': '  168  TREMA'">>1.pft
        echo "  case 'a9': '  169  COPYRIGHT'">>1.pft
        echo "  case 'aa': '  170  ORDINAL FEM'">>1.pft
        echo "  case 'ab': '  171'">>1.pft
        echo "  case 'ac': '  172'">>1.pft
        echo "  case 'ad': '  173'">>1.pft
        echo "  case 'ae': '  174  REGISTRADA'">>1.pft
        echo "  case 'af': '  175'">>1.pft
        echo "  case 'b0': '  176  GRAUS'">>1.pft
        echo "  case 'b1': '  177  +/-'">>1.pft
        echo "  case 'b2': '  178  A SEGUNDA'">>1.pft
        echo "  case 'b3': '  179  A TERCEIRA'">>1.pft
        echo "  case 'b4': '  180'">>1.pft
        echo "  case 'b5': '  181'">>1.pft
        echo "  case 'b6': '  182'">>1.pft
        echo "  case 'b7': '  183'">>1.pft
        echo "  case 'b8': '  184'">>1.pft
        echo "  case 'b9': '  185  A PRIMEIRA'">>1.pft
        echo "  case 'ba': '  186  ORDINAL MASC'">>1.pft
        echo "  case 'bb': '  187'">>1.pft
        echo "  case 'bc': '  188  UM QUARTO'">>1.pft
        #REM                       123456789012345678
        echo "  case 'bd': '  189  MEIO'">>1.pft
        echo "  case 'be': '  190  TRES QUARTOS'">>1.pft
        echo "  case 'bf': '  191  INTERROGACAO INV'">>1.pft
        echo "  case 'c0': '  192  A grave'">>1.pft
        echo "  case 'c1': '  193  A agudo'">>1.pft
        echo "  case 'c2': '  194  A circunflexo'">>1.pft
        echo "  case 'c3': '  195  A til'">>1.pft
        echo "  case 'c4': '  196  A trema'">>1.pft
        echo "  case 'c5': '  197  A bola'">>1.pft
        echo "  case 'c6': '  198  AE'">>1.pft
        echo "  case 'c7': '  199  C cedilha'">>1.pft
        echo "  case 'c8': '  200  E grave'">>1.pft
        echo "  case 'c9': '  201  E agudo'">>1.pft
        echo "  case 'ca': '  202  E circunflexo'">>1.pft
        echo "  case 'cb': '  203  E trema'">>1.pft
        echo "  case 'cc': '  204  I grave'">>1.pft
        echo "  case 'cd': '  205  I agudo'">>1.pft
        echo "  case 'ce': '  206  I circunflexo'">>1.pft
        echo "  case 'cf': '  207  I trema'">>1.pft
        echo "  case 'd0': '  208'">>1.pft
        echo "  case 'd1': '  209  N til'">>1.pft
        #REM                       123456789012345678
        echo "  case 'd2': '  210  O grave'">>1.pft
        echo "  case 'd3': '  211  O agudo'">>1.pft
        echo "  case 'd4': '  212  O circunflexo'">>1.pft
        echo "  case 'd5': '  213  O til'">>1.pft
        echo "  case 'd6': '  214  O trema'">>1.pft
        echo "  case 'd7': '  215  VERSUS'">>1.pft
        echo "  case 'd8': '  216'">>1.pft
        echo "  case 'd9': '  217  U grave'">>1.pft
        echo "  case 'da': '  218  U agudo'">>1.pft
        echo "  case 'db': '  219  U circunflexo'">>1.pft
        echo "  case 'dc': '  220  U trema'">>1.pft
        echo "  case 'dd': '  221  Y agudo'">>1.pft
        echo "  case 'de': '  222'">>1.pft
        echo "  case 'df': '  223  BETA'">>1.pft
        echo "  case 'e0': '  224  a grave'">>1.pft
        echo "  case 'e1': '  225  a agudo'">>1.pft
        echo "  case 'e2': '  226  a circunflexo'">>1.pft
        echo "  case 'e3': '  227  a til'">>1.pft
        echo "  case 'e4': '  228  a trema'">>1.pft
        echo "  case 'e5': '  229  a bola'">>1.pft
        echo "  case 'e6': '  230  ae'">>1.pft
        #REM                       123456789012345678
        echo "  case 'e7': '  231  c cedilha'">>1.pft
        echo "  case 'e8': '  232  e grave'">>1.pft
        echo "  case 'e9': '  233  e agudo'">>1.pft
        echo "  case 'ea': '  234  e circunflexo'">>1.pft
        echo "  case 'eb': '  235  e trema'">>1.pft
        echo "  case 'ec': '  236  i grave'">>1.pft
        echo "  case 'ed': '  237  i agudo'">>1.pft
        echo "  case 'ee': '  238  i circunflexo'">>1.pft
        echo "  case 'ef': '  239  i trema'">>1.pft
        echo "  case 'f0': '  240'">>1.pft
        echo "  case 'f1': '  241  n til  '">>1.pft
        echo "  case 'f2': '  242  o grave'">>1.pft
        echo "  case 'f3': '  243  o agudo'">>1.pft
        echo "  case 'f4': '  244  o circunflexo'">>1.pft
        echo "  case 'f5': '  245  o til'">>1.pft
        echo "  case 'f6': '  246  o trema'">>1.pft
        echo "  case 'f7': '  247  DIVISAO'">>1.pft
        echo "  case 'f8': '  248'">>1.pft
        echo "  case 'f9': '  249  u grave'">>1.pft
        echo "  case 'fa': '  250  u agudo'">>1.pft
        echo "  case 'fb': '  251  u circunflexo'">>1.pft
        #REM                       123456789012345678
        echo "  case 'fc': '  252  u trema'">>1.pft
        echo "  case 'fd': '  253  y agudo'">>1.pft
        echo "  case 'fe': '  254'">>1.pft
        echo "  case 'ff': '  255  y trema'">>1.pft
        echo " endsel,">>1.pft
        echo " c28,">>1.pft
        echo " f(val(v1030^n),10,0),">>1.pft
        echo " /">>1.pft
        echo ")">>1.pft
  else
  if [ "$2" = "ASCII" -o "$2" = "ascii" -o "$2" = "ASC2" -o "$2" = "asc2" -o "$2" = "ASC" -o "$2" = "asc" ]
  then
        # Conjunto de caracteres ASCII
        echo "'BIREME/OPS/OMS - OFI                          Data Base Statistical Analisys',/,"> 1.pft
        echo "'               ASCII (850) Character Distribution Analisys',/,">>1.pft
        echo "'-----------------------------------------------------------------------------',/#,">> 1.pft
        echo "if p(v1001) then" >> 1.pft
        echo " |  Data Base name : |v1001" >> 1.pft
        echo "fi," >> 1.pft
        echo "if p(v1003) then" >> 1.pft
        echo " c45," >> 1.pft
        echo " '  Analisys Date : ',v1003*6.2,'/',v1003*4.2,'/',v1003*0.4,/," >> 1.pft
        echo "fi,/," >> 1.pft
        echo "'   Total Records : 'v1009,/#," >> 1.pft
        echo "'-----------------------------------------------------------------------------',/,">>1.pft
        echo "'  Char                     Occurences',/,">>1.pft
        echo "'HEX  DEC',/,">>1.pft
        echo "'-------------------------------------',/#,">>1.pft
        echo "(">>1.pft
        echo " c02,">>1.pft
        echo " v1030^x,">>1.pft
        echo " select v1030^x">>1.pft
        #REM                       123456789012345678
        echo "  case '00': '   00  NUL'">>1.pft
        echo "  case '01': '   01  SOH'">>1.pft
        echo "  case '02': '   02  STX'">>1.pft
        echo "  case '03': '   03  ETX'">>1.pft
        echo "  case '04': '   04  EOT'">>1.pft
        echo "  case '05': '   05  ENQ'">>1.pft
        echo "  case '06': '   06  ACK'">>1.pft
        echo "  case '07': '   07  BEL'">>1.pft
        echo "  case '08': '   08  BS'">>1.pft
        echo "  case '09': '   09  HT'">>1.pft
        echo "  case '0a': '   10  LF'">>1.pft
        echo "  case '0b': '   11  VT'">>1.pft
        echo "  case '0c': '   12  FF'">>1.pft
        echo "  case '0d': '   13  CR'">>1.pft
        echo "  case '0e': '   14  SO'">>1.pft
        echo "  case '0f': '   15  SI'">>1.pft
        echo "  case '10': '   16  DLE'">>1.pft
        echo "  case '11': '   17  DC1'">>1.pft
        echo "  case '12': '   18  DC2'">>1.pft
        echo "  case '13': '   19  DC3'">>1.pft
        echo "  case '14': '   20  DC4'">>1.pft
        #REM                       123456789012345678
        echo "  case '15': '   21  NAK'">>1.pft
        echo "  case '16': '   22  SYN'">>1.pft
        echo "  case '17': '   23  ETB'">>1.pft
        echo "  case '18': '   24  CAN'">>1.pft
        echo "  case '19': '   25  EM'">>1.pft
        echo "  case '1a': '   26  SUB'">>1.pft
        echo "  case '1b': '   27  ESCAPE'">>1.pft
        echo "  case '1c': '   28  FS'">>1.pft
        echo "  case '1d': '   29  GS'">>1.pft
        echo "  case '1e': '   30  RS'">>1.pft
        echo "  case '1f': '   31  US'">>1.pft
        echo "  case '20': '   32  SPACE'">>1.pft
        echo "  case '21': '   33  EXCLAMACAO'">>1.pft
        echo "  case '22': '   34  ASPAS'">>1.pft
        echo "  case '23': '   35  #'">>1.pft
        echo "  case '24': '   36  CIFRAO'">>1.pft
        echo "  case '25': '   37  PERCENT'">>1.pft
        echo "  case '26': '   38  E COMERCIAL'">>1.pft
        echo "  case '27': '   39  APOSTROFE'">>1.pft
        echo "  case '28': '   40  ('">>1.pft
        echo "  case '29': '   41  )'">>1.pft
        #REM                       123456789012345678
        echo "  case '2a': '   42  ASTERISCO'">>1.pft
        echo "  case '2b': '   43  +'">>1.pft
        echo "  case '2c': '   44  VIRGULA'">>1.pft
        echo "  case '2d': '   45  HIFEN'">>1.pft
        echo "  case '2e': '   46  PONTO FINAL'">>1.pft
        echo "  case '2f': '   47  /'">>1.pft
        echo "  case '30': '   48  DIGITO 0'">>1.pft
        echo "  case '31': '   49  DIGITO 1'">>1.pft
        echo "  case '32': '   50  DIGITO 2'">>1.pft
        echo "  case '33': '   51  DIGITO 3'">>1.pft
        echo "  case '34': '   52  DIGITO 4'">>1.pft
        echo "  case '35': '   53  DIGITO 5'">>1.pft
        echo "  case '36': '   54  DIGITO 6'">>1.pft
        echo "  case '37': '   55  DIGITO 7'">>1.pft
        echo "  case '38': '   56  DIGITO 8'">>1.pft
        echo "  case '39': '   57  DIGITO 9'">>1.pft
        echo "  case '3a': '   58  :'">>1.pft
        echo "  case '3b': '   59  ;'">>1.pft
        echo "  case '3c': '   60  MENOR'">>1.pft
        echo "  case '3d': '   61  ='">>1.pft
        echo "  case '3e': '   62  MAIOR'">>1.pft
        #REM                       123456789012345678
        echo "  case '3f': '   63  ?'">>1.pft
        echo "  case '40': '   64  @'">>1.pft
        echo "  case '41': '   65  A'">>1.pft
        echo "  case '42': '   66  B'">>1.pft
        echo "  case '43': '   67  C'">>1.pft
        echo "  case '44': '   68  D'">>1.pft
        echo "  case '45': '   69  E'">>1.pft
        echo "  case '46': '   70  F'">>1.pft
        echo "  case '47': '   71  G'">>1.pft
        echo "  case '48': '   72  H'">>1.pft
        echo "  case '49': '   73  I'">>1.pft
        echo "  case '4a': '   74  J'">>1.pft
        echo "  case '4b': '   75  K'">>1.pft
        echo "  case '4c': '   76  L'">>1.pft
        echo "  case '4d': '   77  M'">>1.pft
        echo "  case '4e': '   78  N'">>1.pft
        echo "  case '4f': '   79  O'">>1.pft
        echo "  case '50': '   80  P'">>1.pft
        echo "  case '51': '   81  Q'">>1.pft
        echo "  case '52': '   82  R'">>1.pft
        echo "  case '53': '   83  S'">>1.pft
        #REM                       123456789012345678
        echo "  case '54': '   84  T'">>1.pft
        echo "  case '55': '   85  U'">>1.pft
        echo "  case '56': '   86  V'">>1.pft
        echo "  case '57': '   87  W'">>1.pft
        echo "  case '58': '   88  X'">>1.pft
        echo "  case '59': '   89  Y'">>1.pft
        echo "  case '5a': '   90  Z'">>1.pft
        echo "  case '5b': '   91  ['">>1.pft
        echo "  case '5c': '   92  \\'">>1.pft
        echo "  case '5d': '   93  ]'">>1.pft
        echo "  case '5e': '   94  CIRCUNFLEXO'">>1.pft
        echo "  case '5f': '   95  _'">>1.pft
        echo "  case '60': '   96  AGUDO'">>1.pft
        echo "  case '61': '   97  a'">>1.pft
        echo "  case '62': '   98  b'">>1.pft
        echo "  case '63': '   99  c'">>1.pft
        echo "  case '64': '  100  d'">>1.pft
        echo "  case '65': '  101  e'">>1.pft
        echo "  case '66': '  102  f'">>1.pft
        echo "  case '67': '  103  g'">>1.pft
        echo "  case '68': '  104  h'">>1.pft
        #REM                       123456789012345678
        echo "  case '69': '  105  i'">>1.pft
        echo "  case '6a': '  106  j'">>1.pft
        echo "  case '6b': '  107  k'">>1.pft
        echo "  case '6c': '  108  l'">>1.pft
        echo "  case '6d': '  109  m'">>1.pft
        echo "  case '6e': '  110  n'">>1.pft
        echo "  case '6f': '  111  o'">>1.pft
        echo "  case '70': '  112  p'">>1.pft
        echo "  case '71': '  113  q'">>1.pft
        echo "  case '72': '  114  r'">>1.pft
        echo "  case '73': '  115  s'">>1.pft
        echo "  case '74': '  116  t'">>1.pft
        echo "  case '75': '  117  u'">>1.pft
        echo "  case '76': '  118  v'">>1.pft
        echo "  case '77': '  119  w'">>1.pft
        echo "  case '78': '  120  x'">>1.pft
        echo "  case '79': '  121  y'">>1.pft
        echo "  case '7a': '  122  z'">>1.pft
        echo "  case '7b': '  123  {'">>1.pft
        echo "  case '7c': '  124  PIPE'">>1.pft
        echo "  case '7d': '  125  }'">>1.pft
        #REM                       123456789012345678
        echo "  case '7e': '  126  TIL'">>1.pft
        echo "  case '7f': '  127  DELETE'">>1.pft
        echo "  case '80': '  128  C cedilha'">>1.pft
        echo "  case '81': '  129  u trema'">>1.pft
        echo "  case '82': '  130  e agudo'">>1.pft
        echo "  case '83': '  131  a circun.'">>1.pft
        echo "  case '84': '  132  a trema'">>1.pft
        echo "  case '85': '  133  a grave'">>1.pft
        echo "  case '86': '  134  a bola'">>1.pft
        echo "  case '87': '  135  c cedilha'">>1.pft
        echo "  case '88': '  136  e circunflexo'">>1.pft
        echo "  case '89': '  137  e trema'">>1.pft
        echo "  case '8a': '  138  e agudo'">>1.pft
        echo "  case '8b': '  139  i trema'">>1.pft
        echo "  case '8c': '  140  i circunflexo'">>1.pft
        echo "  case '8d': '  141  i agudo'">>1.pft
        echo "  case '8e': '  142  A trema'">>1.pft
        echo "  case '8f': '  143  A bola'">>1.pft
        echo "  case '90': '  144  E agudo'">>1.pft
        echo "  case '91': '  145  ae'">>1.pft
        echo "  case '92': '  146  AE'">>1.pft
        #REM                       123456789012345678
        echo "  case '93': '  147  o circun.'">>1.pft
        echo "  case '94': '  148  o trema'">>1.pft
        echo "  case '95': '  149  o grave'">>1.pft
        echo "  case '96': '  150  u circun.'">>1.pft
        echo "  case '97': '  151  u grave'">>1.pft
        echo "  case '98': '  152  y trema'">>1.pft
        echo "  case '99': '  153  O trema'">>1.pft
        echo "  case '9a': '  154  U trema'">>1.pft
        echo "  case '9b': '  155  fi'">>1.pft
        echo "  case '9c': '  156  LIBRA'">>1.pft
        echo "  case '9d': '  157  FI'">>1.pft
        echo "  case '9e': '  158  VERSUS'">>1.pft
        echo "  case '9f': '  159'">>1.pft
        echo "  case 'a0': '  160  a agudo'">>1.pft
        echo "  case 'a1': '  161  i agudo'">>1.pft
        echo "  case 'a2': '  162  o agudo'">>1.pft
        echo "  case 'a3': '  163  u agudo'">>1.pft
        echo "  case 'a4': '  164  n til'">>1.pft
        echo "  case 'a5': '  165  N til'">>1.pft
        echo "  case 'a6': '  166  ORDINAL MASC'">>1.pft
        echo "  case 'a7': '  167  ORDINAL FEM'">>1.pft
        #REM                       123456789012345678
        echo "  case 'a8': '  168  INTERROGACAO INV'">>1.pft
        echo "  case 'a9': '  169  REGISTRADA'">>1.pft
        echo "  case 'aa': '  170'">>1.pft
        echo "  case 'ab': '  171  MEIO'">>1.pft
        echo "  case 'ac': '  172  UM QUARTO'">>1.pft
        echo "  case 'ad': '  173  EXCLAMACAO INV'">>1.pft
        echo "  case 'ae': '  174  DUPLO MENOR'">>1.pft
        echo "  case 'af': '  175  DUPLO MAIOR'">>1.pft
        echo "  case 'b0': '  176'">>1.pft
        echo "  case 'b1': '  177'">>1.pft
        echo "  case 'b2': '  178'">>1.pft
        echo "  case 'b3': '  179'">>1.pft
        echo "  case 'b4': '  180'">>1.pft
        echo "  case 'b5': '  181  A agudo'">>1.pft
        echo "  case 'b6': '  182  A circunflexo'">>1.pft
        echo "  case 'b7': '  183  A grave'">>1.pft
        echo "  case 'b8': '  184  COPYRIGHT'">>1.pft
        echo "  case 'b9': '  185'">>1.pft
        echo "  case 'ba': '  186'">>1.pft
        echo "  case 'bb': '  187'">>1.pft
        echo "  case 'bc': '  188'">>1.pft
        #REM                       123456789012345678
        echo "  case 'bd': '  189  CENTS'">>1.pft
        echo "  case 'be': '  190  YENE'">>1.pft
        echo "  case 'bf': '  191'">>1.pft
        echo "  case 'c0': '  192'">>1.pft
        echo "  case 'c1': '  193'">>1.pft
        echo "  case 'c2': '  194'">>1.pft
        echo "  case 'c3': '  195'">>1.pft
        echo "  case 'c4': '  196'">>1.pft
        echo "  case 'c5': '  197'">>1.pft
        echo "  case 'c6': '  198  a til'">>1.pft
        echo "  case 'c7': '  199  A til'">>1.pft
        echo "  case 'c8': '  200'">>1.pft
        echo "  case 'c9': '  201'">>1.pft
        echo "  case 'ca': '  202'">>1.pft
        echo "  case 'cb': '  203'">>1.pft
        echo "  case 'cc': '  204'">>1.pft
        echo "  case 'cd': '  205'">>1.pft
        echo "  case 'ce': '  206'">>1.pft
        echo "  case 'cf': '  207'">>1.pft
        echo "  case 'd0': '  208'">>1.pft
        echo "  case 'd1': '  209'">>1.pft
        #REM                       123456789012345678
        echo "  case 'd2': '  210  E circunflexo'">>1.pft
        echo "  case 'd3': '  211  E trema'">>1.pft
        echo "  case 'd4': '  212  E grave'">>1.pft
        echo "  case 'd5': '  213'">>1.pft
        echo "  case 'd6': '  214  I agudo'">>1.pft
        echo "  case 'd7': '  215  I circunflexo'">>1.pft
        echo "  case 'd8': '  216  I trema'">>1.pft
        echo "  case 'd9': '  217'">>1.pft
        echo "  case 'da': '  218'">>1.pft
        echo "  case 'db': '  219'">>1.pft
        echo "  case 'dc': '  220'">>1.pft
        echo "  case 'dd': '  221'">>1.pft
        echo "  case 'de': '  222  I grave'">>1.pft
        echo "  case 'df': '  223'">>1.pft
        echo "  case 'e0': '  224  O agudo'">>1.pft
        echo "  case 'e1': '  225'">>1.pft
        echo "  case 'e2': '  226  O circunflexo'">>1.pft
        echo "  case 'e3': '  227  O grave'">>1.pft
        echo "  case 'e4': '  228  o til'">>1.pft
        echo "  case 'e5': '  229  O til'">>1.pft
        echo "  case 'e6': '  230  micro minusc'">>1.pft
        #REM                       123456789012345678
        echo "  case 'e7': '  231'">>1.pft
        echo "  case 'e8': '  232'">>1.pft
        echo "  case 'e9': '  233  U agudo'">>1.pft
        echo "  case 'ea': '  234  U circunflexo'">>1.pft
        echo "  case 'eb': '  235  U grave'">>1.pft
        echo "  case 'ec': '  236  y agudo'">>1.pft
        echo "  case 'ed': '  237  Y agudo'">>1.pft
        echo "  case 'ee': '  238'">>1.pft
        echo "  case 'ef': '  239  AGUDO'">>1.pft
        echo "  case 'f0': '  240'">>1.pft
        echo "  case 'f1': '  241  +/-'">>1.pft
        echo "  case 'f2': '  242'">>1.pft
        echo "  case 'f3': '  243  TRES QUARTOS'">>1.pft
        echo "  case 'f4': '  244'">>1.pft
        echo "  case 'f5': '  245  PARAGRAFO'">>1.pft
        echo "  case 'f6': '  246  DIVIDIR'">>1.pft
        echo "  case 'f7': '  247'">>1.pft
        echo "  case 'f8': '  248  GRAU'">>1.pft
        echo "  case 'f9': '  249  TREMA'">>1.pft
        echo "  case 'fa': '  250'">>1.pft
        echo "  case 'fb': '  251  A PRIMEIRA'">>1.pft
        #REM                       123456789012345678
        echo "  case 'fc': '  252  A TERCEIRA'">>1.pft
        echo "  case 'fd': '  253  A SEGUNDA'">>1.pft
        echo "  case 'fe': '  254'">>1.pft
        echo "  case 'ff': '  255'">>1.pft
        echo " endsel,">>1.pft
        echo " c28,">>1.pft
        echo " f(val(v1030^n),10,0),">>1.pft
        echo " /">>1.pft
        echo ")">>1.pft
  else
  if [ "$2" = "EBCDIC" -o "$2" = "ebcdic" ]
  then
        # Conjunto de caracteres EBCDIC (Main Frame)
        echo "'BIREME/OPS/OMS - OFI                          Data Base Statistical Analisys',/,"> 1.pft
        echo "'                  EBCDIC Character Distribution Analisys',/,">>1.pft
        echo "'-----------------------------------------------------------------------------',/#,">> 1.pft
        echo "if p(v1001) then" >> 1.pft
        echo " |  Data Base name : |v1001" >> 1.pft
        echo "fi," >> 1.pft
        echo "if p(v1003) then" >> 1.pft
        echo " c45," >> 1.pft
        echo " '  Analisys Date : ',v1003*6.2,'/',v1003*4.2,'/',v1003*0.4,/," >> 1.pft
        echo "fi,/," >> 1.pft
        echo "'   Total Records : 'v1009,/#," >> 1.pft
        echo "'-----------------------------------------------------------------------------',/,">>1.pft
        echo "'  Char                     Occurences',/,">>1.pft
        echo "'HEX  DEC',/,">>1.pft
        echo "'-------------------------------------',/#,">>1.pft
        echo "(">>1.pft
        echo " c02,">>1.pft
        echo " v1030^x,">>1.pft
        echo " select v1030^x">>1.pft
        #REM                       123456789012345678
        echo "  case '00': '   00  NUL'">>1.pft
        echo "  case '01': '   01  SOH'">>1.pft
        echo "  case '02': '   02  STX'">>1.pft
        echo "  case '03': '   03  ETX'">>1.pft
        echo "  case '04': '   04  PF'">>1.pft
        echo "  case '05': '   05  HT'">>1.pft
        echo "  case '06': '   06  LC'">>1.pft
        echo "  case '07': '   07  DEL'">>1.pft
        echo "  case '08': '   08'">>1.pft
        echo "  case '09': '   09'">>1.pft
        echo "  case '0a': '   10  SMM'">>1.pft
        echo "  case '0b': '   11  VT'">>1.pft
        echo "  case '0c': '   12  FF'">>1.pft
        echo "  case '0d': '   13  CR'">>1.pft
        echo "  case '0e': '   14  SO'">>1.pft
        echo "  case '0f': '   15  SI'">>1.pft
        echo "  case '10': '   16  DLE'">>1.pft
        echo "  case '11': '   17  DC1'">>1.pft
        echo "  case '12': '   18  DC2'">>1.pft
        echo "  case '13': '   19  TM'">>1.pft
        echo "  case '14': '   20  RES'">>1.pft
        #REM                       123456789012345678
        echo "  case '15': '   21  NL'">>1.pft
        echo "  case '16': '   22  BS'">>1.pft
        echo "  case '17': '   23  IL'">>1.pft
        echo "  case '18': '   24  CAN'">>1.pft
        echo "  case '19': '   25  EM'">>1.pft
        echo "  case '1a': '   26  CC'">>1.pft
        echo "  case '1b': '   27  CU1'">>1.pft
        echo "  case '1c': '   28  IFS'">>1.pft
        echo "  case '1d': '   29  IGS'">>1.pft
        echo "  case '1e': '   30  IRS'">>1.pft
        echo "  case '1f': '   31  IUS'">>1.pft
        echo "  case '20': '   32  DS'">>1.pft
        echo "  case '21': '   33  SOS'">>1.pft
        echo "  case '22': '   34  FS'">>1.pft
        echo "  case '23': '   35'">>1.pft
        echo "  case '24': '   36  BYP'">>1.pft
        echo "  case '25': '   37  LF'">>1.pft
        echo "  case '26': '   38  ETB'">>1.pft
        echo "  case '27': '   39  ESC'">>1.pft
        echo "  case '28': '   40'">>1.pft
        echo "  case '29': '   41'">>1.pft
        #REM                       123456789012345678
        echo "  case '2a': '   42  SM'">>1.pft
        echo "  case '2b': '   43  CU2'">>1.pft
        echo "  case '2c': '   44'">>1.pft
        echo "  case '2d': '   45  ENQ'">>1.pft
        echo "  case '2e': '   46  ACK'">>1.pft
        echo "  case '2f': '   47  BEL'">>1.pft
        echo "  case '30': '   48'">>1.pft
        echo "  case '31': '   49'">>1.pft
        echo "  case '32': '   50  SYN'">>1.pft
        echo "  case '33': '   51'">>1.pft
        echo "  case '34': '   52  PN'">>1.pft
        echo "  case '35': '   53  RS'">>1.pft
        echo "  case '36': '   54'">>1.pft
        echo "  case '37': '   55  EOT'">>1.pft
        echo "  case '38': '   56'">>1.pft
        echo "  case '39': '   57'">>1.pft
        echo "  case '3a': '   58'">>1.pft
        echo "  case '3b': '   59  CU3'">>1.pft
        echo "  case '3c': '   60  DC4'">>1.pft
        echo "  case '3d': '   61  NAK'">>1.pft
        echo "  case '3e': '   62'">>1.pft
        #REM                       123456789012345678
        echo "  case '3f': '   63  SUB'">>1.pft
        echo "  case '40': '   64  SPACE'">>1.pft
        echo "  case '41': '   65'">>1.pft
        echo "  case '42': '   66'">>1.pft
        echo "  case '43': '   67'">>1.pft
        echo "  case '44': '   68'">>1.pft
        echo "  case '45': '   69'">>1.pft
        echo "  case '46': '   70'">>1.pft
        echo "  case '47': '   71'">>1.pft
        echo "  case '48': '   72'">>1.pft
        echo "  case '49': '   73'">>1.pft
        echo "  case '4a': '   74  CEDILHA'">>1.pft
        echo "  case '4b': '   75  PONTO FINAL'">>1.pft
        echo "  case '4c': '   76  MENOR'">>1.pft
        echo "  case '4d': '   77  ('">>1.pft
        echo "  case '4e': '   78  +'">>1.pft
        echo "  case '4f': '   79  PIPE'">>1.pft
        echo "  case '50': '   80  E COMERCIAL'">>1.pft
        echo "  case '51': '   81  /SV/ '">>1.pft
        echo "  case '52': '   82  /EV/ '">>1.pft
        echo "  case '53': '   83  /SS/ '">>1.pft
        #REM                       123456789012345678
        echo "  case '54': '   84'">>1.pft
        echo "  case '55': '   85'">>1.pft
        echo "  case '56': '   86'">>1.pft
        echo "  case '57': '   87'">>1.pft
        echo "  case '58': '   88'">>1.pft
        echo "  case '59': '   89'">>1.pft
        echo "  case '5a': '   90  EXCLAMACAO'">>1.pft
        echo "  case '5b': '   91  CIFRAO'">>1.pft
        echo "  case '5c': '   92  ASTERISCO'">>1.pft
        echo "  case '5d': '   93  )'">>1.pft
        echo "  case '5e': '   94  ;'">>1.pft
        echo "  case '5f': '   95  NOT'">>1.pft
        echo "  case '60': '   96  HIFEN'">>1.pft
        echo "  case '61': '   97  /'">>1.pft
        echo "  case '62': '   98'">>1.pft
        echo "  case '63': '   99'">>1.pft
        echo "  case '64': '  100'">>1.pft
        echo "  case '65': '  101'">>1.pft
        echo "  case '66': '  102'">>1.pft
        echo "  case '67': '  103'">>1.pft
        echo "  case '68': '  104'">>1.pft
        #REM                       123456789012345678
        echo "  case '69': '  105'">>1.pft
        echo "  case '6a': '  106'">>1.pft
        echo "  case '6b': '  107  VIRGULA'">>1.pft
        echo "  case '6c': '  108  PERCENT'">>1.pft
        echo "  case '6d': '  109  _'">>1.pft
        echo "  case '6e': '  110  MAIOR'">>1.pft
        echo "  case '6f': '  111  INTERROGACAO'">>1.pft
        echo "  case '70': '  112'">>1.pft
        echo "  case '71': '  113'">>1.pft
        echo "  case '72': '  114'">>1.pft
        echo "  case '73': '  115'">>1.pft
        echo "  case '74': '  116'">>1.pft
        echo "  case '75': '  117'">>1.pft
        echo "  case '76': '  118'">>1.pft
        echo "  case '77': '  119'">>1.pft
        echo "  case '78': '  120'">>1.pft
        echo "  case '79': '  121'">>1.pft
        echo "  case '7a': '  122  :'">>1.pft
        echo "  case '7b': '  123  #'">>1.pft
        echo "  case '7c': '  124  @'">>1.pft
        echo "  case '7d': '  125  APOSTROFE'">>1.pft
        #REM                       123456789012345678
        echo "  case '7e': '  126  ='">>1.pft
        echo "  case '7f': '  127  * ASPAS'">>1.pft
        echo "  case '80': '  128  NLM'">>1.pft
        echo "  case '81': '  129  a'">>1.pft
        echo "  case '82': '  130  b'">>1.pft
        echo "  case '83': '  131  c'">>1.pft
        echo "  case '84': '  132  d'">>1.pft
        echo "  case '85': '  133  e'">>1.pft
        echo "  case '86': '  134  f'">>1.pft
        echo "  case '87': '  135  g'">>1.pft
        echo "  case '88': '  136  h'">>1.pft
        echo "  case '89': '  137  i'">>1.pft
        echo "  case '8a': '  138  NLM'">>1.pft
        echo "  case '8b': '  139'">>1.pft
        echo "  case '8c': '  140'">>1.pft
        echo "  case '8d': '  141'">>1.pft
        echo "  case '8e': '  142  NLM'">>1.pft
        echo "  case '8f': '  143'">>1.pft
        echo "  case '90': '  144'">>1.pft
        echo "  case '91': '  145  j'">>1.pft
        echo "  case '92': '  146  k'">>1.pft
        #REM                       123456789012345678
        echo "  case '93': '  147  l'">>1.pft
        echo "  case '94': '  148  m'">>1.pft
        echo "  case '95': '  149  n'">>1.pft
        echo "  case '96': '  150  o'">>1.pft
        echo "  case '97': '  151  p'">>1.pft
        echo "  case '98': '  152  q'">>1.pft
        echo "  case '99': '  153  r'">>1.pft
        echo "  case '9a': '  154'">>1.pft
        echo "  case '9b': '  155'">>1.pft
        echo "  case '9c': '  156'">>1.pft
        echo "  case '9d': '  157'">>1.pft
        echo "  case '9e': '  158'">>1.pft
        echo "  case '9f': '  159  CIRCUNFLEXO'">>1.pft
        echo "  case 'a0': '  160  REGISTRADA'">>1.pft
        echo "  case 'a1': '  161  ANGSTROM'">>1.pft
        echo "  case 'a2': '  162  s'">>1.pft
        echo "  case 'a3': '  163  t'">>1.pft
        echo "  case 'a4': '  164  u'">>1.pft
        echo "  case 'a5': '  165  v'">>1.pft
        echo "  case 'a6': '  166  w'">>1.pft
        echo "  case 'a7': '  167  x'">>1.pft
        #REM                       123456789012345678
        echo "  case 'a8': '  168  y'">>1.pft
        echo "  case 'a9': '  169  z'">>1.pft
        echo "  case 'aa': '  170'">>1.pft
        echo "  case 'ab': '  171  TREMA'">>1.pft
        echo "  case 'ac': '  172  TIL'">>1.pft
        echo "  case 'ad': '  173  ['">>1.pft
        echo "  case 'ae': '  174'">>1.pft
        echo "  case 'af': '  175  GRAVE'">>1.pft
        echo "  case 'b0': '  176'">>1.pft
        echo "  case 'b1': '  177'">>1.pft
        echo "  case 'b2': '  178'">>1.pft
        echo "  case 'b3': '  179'">>1.pft
        echo "  case 'b4': '  180'">>1.pft
        echo "  case 'b5': '  181'">>1.pft
        echo "  case 'b6': '  182'">>1.pft
        echo "  case 'b7': '  183'">>1.pft
        echo "  case 'b8': '  184'">>1.pft
        echo "  case 'b9': '  185  * AGUDO'">>1.pft
        echo "  case 'ba': '  186'">>1.pft
        echo "  case 'bb': '  187  NLM'">>1.pft
        echo "  case 'bc': '  188  AGUDO'">>1.pft
        #REM                       123456789012345678
        echo "  case 'bd': '  189  ]'">>1.pft
        echo "  case 'be': '  190'">>1.pft
        echo "  case 'bf': '  191  MACRON '">>1.pft
        echo "  case 'c0': '  192'">>1.pft
        echo "  case 'c1': '  193  A'">>1.pft
        echo "  case 'c2': '  194  B'">>1.pft
        echo "  case 'c3': '  195  C'">>1.pft
        echo "  case 'c4': '  196  D'">>1.pft
        echo "  case 'c5': '  197  E'">>1.pft
        echo "  case 'c6': '  198  F'">>1.pft
        echo "  case 'c7': '  199  G'">>1.pft
        echo "  case 'c8': '  200  H'">>1.pft
        echo "  case 'c9': '  201  I'">>1.pft
        echo "  case 'ca': '  202'">>1.pft
        echo "  case 'cb': '  203'">>1.pft
        echo "  case 'cc': '  204'">>1.pft
        echo "  case 'cd': '  205'">>1.pft
        echo "  case 'ce': '  206'">>1.pft
        echo "  case 'cf': '  207'">>1.pft
        echo "  case 'd0': '  208'">>1.pft
        echo "  case 'd1': '  209  J'">>1.pft
        #REM                       123456789012345678
        echo "  case 'd2': '  210  K'">>1.pft
        echo "  case 'd3': '  211  L'">>1.pft
        echo "  case 'd4': '  212  M'">>1.pft
        echo "  case 'd5': '  213  N'">>1.pft
        echo "  case 'd6': '  214  O'">>1.pft
        echo "  case 'd7': '  215  P'">>1.pft
        echo "  case 'd8': '  216  Q'">>1.pft
        echo "  case 'd9': '  217  R'">>1.pft
        echo "  case 'da': '  218'">>1.pft
        echo "  case 'db': '  219'">>1.pft
        echo "  case 'dc': '  220'">>1.pft
        echo "  case 'dd': '  221'">>1.pft
        echo "  case 'de': '  222'">>1.pft
        echo "  case 'df': '  223'">>1.pft
        echo "  case 'e0': '  224'">>1.pft
        echo "  case 'e1': '  225'">>1.pft
        echo "  case 'e2': '  226  S'">>1.pft
        echo "  case 'e3': '  227  T'">>1.pft
        echo "  case 'e4': '  228  U'">>1.pft
        echo "  case 'e5': '  229  V'">>1.pft
        echo "  case 'e6': '  230  W'">>1.pft
        #REM                       123456789012345678
        echo "  case 'e7': '  231  X'">>1.pft
        echo "  case 'e8': '  232  Y'">>1.pft
        echo "  case 'e9': '  233  Z'">>1.pft
        echo "  case 'ea': '  234'">>1.pft
        echo "  case 'eb': '  235'">>1.pft
        echo "  case 'ec': '  236'">>1.pft
        echo "  case 'ed': '  237'">>1.pft
        echo "  case 'ee': '  238'">>1.pft
        echo "  case 'ef': '  239'">>1.pft
        echo "  case 'f0': '  240  DIGITO 0'">>1.pft
        echo "  case 'f1': '  241  DIGITO 1'">>1.pft
        echo "  case 'f2': '  242  DIGITO 2'">>1.pft
        echo "  case 'f3': '  243  DIGITO 3'">>1.pft
        echo "  case 'f4': '  244  DIGITO 4'">>1.pft
        echo "  case 'f5': '  245  DIGITO 5'">>1.pft
        echo "  case 'f6': '  246  DIGITO 6'">>1.pft
        echo "  case 'f7': '  247  DIGITO 7'">>1.pft
        echo "  case 'f8': '  248  DIGITO 8'">>1.pft
        echo "  case 'f9': '  249  DIGITO 9'">>1.pft
        echo "  case 'fa': '  250'">>1.pft
        echo "  case 'fb': '  251'">>1.pft
        #REM                       123456789012345678
        echo "  case 'fc': '  252'">>1.pft
        echo "  case 'fd': '  253'">>1.pft
        echo "  case 'fe': '  254'">>1.pft
        echo "  case 'ff': '  255'">>1.pft
        echo " endsel,">>1.pft
        echo " c28,">>1.pft
        echo " f(val(v1030^n),10,0),">>1.pft
        echo " /">>1.pft
        echo ")">>1.pft
  else
        # Conjunto de caracteres generico
        echo "'BIREME/OPS/OMS - OFI                          Data Base Statistical Analisys',/,"> 1.pft
        echo "'                     Character Distribution Analisys',/,">>1.pft
        echo "'-----------------------------------------------------------------------------',/#,">> 1.pft
        echo "if p(v1001) then" >> 1.pft
        echo " |  Data Base name : |v1001" >> 1.pft
        echo "fi," >> 1.pft
        echo "if p(v1003) then" >> 1.pft
        echo " c45," >> 1.pft
        echo " '  Analisys Date : ',v1003*6.2,'/',v1003*4.2,'/',v1003*0.4,/," >> 1.pft
        echo "fi,/," >> 1.pft
        echo "'   Total Records : 'v1009,/#," >> 1.pft
        echo "'-----------------------------------------------------------------------------',/,">>1.pft
        echo "'  Char                     Occurences',/,">>1.pft
        echo "'HEX  DEC',/,">>1.pft
        echo "'-------------------------------------',/#,">>1.pft
        echo "(">>1.pft
        echo " c02,">>1.pft
        echo " v1030^x,">>1.pft
        echo " select v1030^x">>1.pft
        #REM                       123456789012345678
        echo "  case '00': '   00'">>1.pft
        echo "  case '01': '   01'">>1.pft
        echo "  case '02': '   02'">>1.pft
        echo "  case '03': '   03'">>1.pft
        echo "  case '04': '   04'">>1.pft
        echo "  case '05': '   05'">>1.pft
        echo "  case '06': '   06'">>1.pft
        echo "  case '07': '   07'">>1.pft
        echo "  case '08': '   08'">>1.pft
        echo "  case '09': '   09'">>1.pft
        echo "  case '0a': '   10'">>1.pft
        echo "  case '0b': '   11'">>1.pft
        echo "  case '0c': '   12'">>1.pft
        echo "  case '0d': '   13'">>1.pft
        echo "  case '0e': '   14'">>1.pft
        echo "  case '0f': '   15'">>1.pft
        echo "  case '10': '   16'">>1.pft
        echo "  case '11': '   17'">>1.pft
        echo "  case '12': '   18'">>1.pft
        echo "  case '13': '   19'">>1.pft
        echo "  case '14': '   20'">>1.pft
        #REM                       123456789012345678
        echo "  case '15': '   21'">>1.pft
        echo "  case '16': '   22'">>1.pft
        echo "  case '17': '   23'">>1.pft
        echo "  case '18': '   24'">>1.pft
        echo "  case '19': '   25'">>1.pft
        echo "  case '1a': '   26'">>1.pft
        echo "  case '1b': '   27'">>1.pft
        echo "  case '1c': '   28'">>1.pft
        echo "  case '1d': '   29'">>1.pft
        echo "  case '1e': '   30'">>1.pft
        echo "  case '1f': '   31'">>1.pft
        echo "  case '20': '   32'">>1.pft
        echo "  case '21': '   33'">>1.pft
        echo "  case '22': '   34'">>1.pft
        echo "  case '23': '   35'">>1.pft
        echo "  case '24': '   36'">>1.pft
        echo "  case '25': '   37'">>1.pft
        echo "  case '26': '   38'">>1.pft
        echo "  case '27': '   39'">>1.pft
        echo "  case '28': '   40'">>1.pft
        echo "  case '29': '   41'">>1.pft
        #REM                       123456789012345678
        echo "  case '2a': '   42'">>1.pft
        echo "  case '2b': '   43'">>1.pft
        echo "  case '2c': '   44'">>1.pft
        echo "  case '2d': '   45'">>1.pft
        echo "  case '2e': '   46'">>1.pft
        echo "  case '2f': '   47'">>1.pft
        echo "  case '30': '   48'">>1.pft
        echo "  case '31': '   49'">>1.pft
        echo "  case '32': '   50'">>1.pft
        echo "  case '33': '   51'">>1.pft
        echo "  case '34': '   52'">>1.pft
        echo "  case '35': '   53'">>1.pft
        echo "  case '36': '   54'">>1.pft
        echo "  case '37': '   55'">>1.pft
        echo "  case '38': '   56'">>1.pft
        echo "  case '39': '   57'">>1.pft
        echo "  case '3a': '   58'">>1.pft
        echo "  case '3b': '   59'">>1.pft
        echo "  case '3c': '   60'">>1.pft
        echo "  case '3d': '   61'">>1.pft
        echo "  case '3e': '   62'">>1.pft
        #REM                       123456789012345678
        echo "  case '3f': '   63'">>1.pft
        echo "  case '40': '   64'">>1.pft
        echo "  case '41': '   65'">>1.pft
        echo "  case '42': '   66'">>1.pft
        echo "  case '43': '   67'">>1.pft
        echo "  case '44': '   68'">>1.pft
        echo "  case '45': '   69'">>1.pft
        echo "  case '46': '   70'">>1.pft
        echo "  case '47': '   71'">>1.pft
        echo "  case '48': '   72'">>1.pft
        echo "  case '49': '   73'">>1.pft
        echo "  case '4a': '   74'">>1.pft
        echo "  case '4b': '   75'">>1.pft
        echo "  case '4c': '   76'">>1.pft
        echo "  case '4d': '   77'">>1.pft
        echo "  case '4e': '   78'">>1.pft
        echo "  case '4f': '   79'">>1.pft
        echo "  case '50': '   80'">>1.pft
        echo "  case '51': '   81'">>1.pft
        echo "  case '52': '   82'">>1.pft
        echo "  case '53': '   83'">>1.pft
        #REM                       123456789012345678
        echo "  case '54': '   84'">>1.pft
        echo "  case '55': '   85'">>1.pft
        echo "  case '56': '   86'">>1.pft
        echo "  case '57': '   87'">>1.pft
        echo "  case '58': '   88'">>1.pft
        echo "  case '59': '   89'">>1.pft
        echo "  case '5a': '   90'">>1.pft
        echo "  case '5b': '   91'">>1.pft
        echo "  case '5c': '   92'">>1.pft
        echo "  case '5d': '   93'">>1.pft
        echo "  case '5e': '   94'">>1.pft
        echo "  case '5f': '   95'">>1.pft
        echo "  case '60': '   96'">>1.pft
        echo "  case '61': '   97'">>1.pft
        echo "  case '62': '   98'">>1.pft
        echo "  case '63': '   99'">>1.pft
        echo "  case '64': '  100'">>1.pft
        echo "  case '65': '  101'">>1.pft
        echo "  case '66': '  102'">>1.pft
        echo "  case '67': '  103'">>1.pft
        echo "  case '68': '  104'">>1.pft
        #REM                       123456789012345678
        echo "  case '69': '  105'">>1.pft
        echo "  case '6a': '  106'">>1.pft
        echo "  case '6b': '  107'">>1.pft
        echo "  case '6c': '  108'">>1.pft
        echo "  case '6d': '  109'">>1.pft
        echo "  case '6e': '  110'">>1.pft
        echo "  case '6f': '  111'">>1.pft
        echo "  case '70': '  112'">>1.pft
        echo "  case '71': '  113'">>1.pft
        echo "  case '72': '  114'">>1.pft
        echo "  case '73': '  115'">>1.pft
        echo "  case '74': '  116'">>1.pft
        echo "  case '75': '  117'">>1.pft
        echo "  case '76': '  118'">>1.pft
        echo "  case '77': '  119'">>1.pft
        echo "  case '78': '  120'">>1.pft
        echo "  case '79': '  121'">>1.pft
        echo "  case '7a': '  122'">>1.pft
        echo "  case '7b': '  123'">>1.pft
        echo "  case '7c': '  124'">>1.pft
        echo "  case '7d': '  125'">>1.pft
        #REM                       123456789012345678
        echo "  case '7e': '  126'">>1.pft
        echo "  case '7f': '  127'">>1.pft
        echo "  case '80': '  128'">>1.pft
        echo "  case '81': '  129'">>1.pft
        echo "  case '82': '  130'">>1.pft
        echo "  case '83': '  131'">>1.pft
        echo "  case '84': '  132'">>1.pft
        echo "  case '85': '  133'">>1.pft
        echo "  case '86': '  134'">>1.pft
        echo "  case '87': '  135'">>1.pft
        echo "  case '88': '  136'">>1.pft
        echo "  case '89': '  137'">>1.pft
        echo "  case '8a': '  138'">>1.pft
        echo "  case '8b': '  139'">>1.pft
        echo "  case '8c': '  140'">>1.pft
        echo "  case '8d': '  141'">>1.pft
        echo "  case '8e': '  142'">>1.pft
        echo "  case '8f': '  143'">>1.pft
        echo "  case '90': '  144'">>1.pft
        echo "  case '91': '  145'">>1.pft
        echo "  case '92': '  146'">>1.pft
        #REM                       123456789012345678
        echo "  case '93': '  147'">>1.pft
        echo "  case '94': '  148'">>1.pft
        echo "  case '95': '  149'">>1.pft
        echo "  case '96': '  150'">>1.pft
        echo "  case '97': '  151'">>1.pft
        echo "  case '98': '  152'">>1.pft
        echo "  case '99': '  153'">>1.pft
        echo "  case '9a': '  154'">>1.pft
        echo "  case '9b': '  155'">>1.pft
        echo "  case '9c': '  156'">>1.pft
        echo "  case '9d': '  157'">>1.pft
        echo "  case '9e': '  158'">>1.pft
        echo "  case '9f': '  159'">>1.pft
        echo "  case 'a0': '  160'">>1.pft
        echo "  case 'a1': '  161'">>1.pft
        echo "  case 'a2': '  162'">>1.pft
        echo "  case 'a3': '  163'">>1.pft
        echo "  case 'a4': '  164'">>1.pft
        echo "  case 'a5': '  165'">>1.pft
        echo "  case 'a6': '  166'">>1.pft
        echo "  case 'a7': '  167'">>1.pft
        #REM                       123456789012345678
        echo "  case 'a8': '  168'">>1.pft
        echo "  case 'a9': '  169'">>1.pft
        echo "  case 'aa': '  170'">>1.pft
        echo "  case 'ab': '  171'">>1.pft
        echo "  case 'ac': '  172'">>1.pft
        echo "  case 'ad': '  173'">>1.pft
        echo "  case 'ae': '  174'">>1.pft
        echo "  case 'af': '  175'">>1.pft
        echo "  case 'b0': '  176'">>1.pft
        echo "  case 'b1': '  177'">>1.pft
        echo "  case 'b2': '  178'">>1.pft
        echo "  case 'b3': '  179'">>1.pft
        echo "  case 'b4': '  180'">>1.pft
        echo "  case 'b5': '  181'">>1.pft
        echo "  case 'b6': '  182'">>1.pft
        echo "  case 'b7': '  183'">>1.pft
        echo "  case 'b8': '  184'">>1.pft
        echo "  case 'b9': '  185'">>1.pft
        echo "  case 'ba': '  186'">>1.pft
        echo "  case 'bb': '  187'">>1.pft
        echo "  case 'bc': '  188'">>1.pft
        #REM                       123456789012345678
        echo "  case 'bd': '  189'">>1.pft
        echo "  case 'be': '  190'">>1.pft
        echo "  case 'bf': '  191'">>1.pft
        echo "  case 'c0': '  192'">>1.pft
        echo "  case 'c1': '  193'">>1.pft
        echo "  case 'c2': '  194'">>1.pft
        echo "  case 'c3': '  195'">>1.pft
        echo "  case 'c4': '  196'">>1.pft
        echo "  case 'c5': '  197'">>1.pft
        echo "  case 'c6': '  198'">>1.pft
        echo "  case 'c7': '  199'">>1.pft
        echo "  case 'c8': '  200'">>1.pft
        echo "  case 'c9': '  201'">>1.pft
        echo "  case 'ca': '  202'">>1.pft
        echo "  case 'cb': '  203'">>1.pft
        echo "  case 'cc': '  204'">>1.pft
        echo "  case 'cd': '  205'">>1.pft
        echo "  case 'ce': '  206'">>1.pft
        echo "  case 'cf': '  207'">>1.pft
        echo "  case 'd0': '  208'">>1.pft
        echo "  case 'd1': '  209'">>1.pft
        #REM                       123456789012345678
        echo "  case 'd2': '  210'">>1.pft
        echo "  case 'd3': '  211'">>1.pft
        echo "  case 'd4': '  212'">>1.pft
        echo "  case 'd5': '  213'">>1.pft
        echo "  case 'd6': '  214'">>1.pft
        echo "  case 'd7': '  215'">>1.pft
        echo "  case 'd8': '  216'">>1.pft
        echo "  case 'd9': '  217'">>1.pft
        echo "  case 'da': '  218'">>1.pft
        echo "  case 'db': '  219'">>1.pft
        echo "  case 'dc': '  220'">>1.pft
        echo "  case 'dd': '  221'">>1.pft
        echo "  case 'de': '  222'">>1.pft
        echo "  case 'df': '  223'">>1.pft
        echo "  case 'e0': '  224'">>1.pft
        echo "  case 'e1': '  225'">>1.pft
        echo "  case 'e2': '  226'">>1.pft
        echo "  case 'e3': '  227'">>1.pft
        echo "  case 'e4': '  228'">>1.pft
        echo "  case 'e5': '  229'">>1.pft
        echo "  case 'e6': '  230'">>1.pft
        #REM                       123456789012345678
        echo "  case 'e7': '  231'">>1.pft
        echo "  case 'e8': '  232'">>1.pft
        echo "  case 'e9': '  233'">>1.pft
        echo "  case 'ea': '  234'">>1.pft
        echo "  case 'eb': '  235'">>1.pft
        echo "  case 'ec': '  236'">>1.pft
        echo "  case 'ed': '  237'">>1.pft
        echo "  case 'ee': '  238'">>1.pft
        echo "  case 'ef': '  239'">>1.pft
        echo "  case 'f0': '  240'">>1.pft
        echo "  case 'f1': '  241'">>1.pft
        echo "  case 'f2': '  242'">>1.pft
        echo "  case 'f3': '  243'">>1.pft
        echo "  case 'f4': '  244'">>1.pft
        echo "  case 'f5': '  245'">>1.pft
        echo "  case 'f6': '  246'">>1.pft
        echo "  case 'f7': '  247'">>1.pft
        echo "  case 'f8': '  248'">>1.pft
        echo "  case 'f9': '  249'">>1.pft
        echo "  case 'fa': '  250'">>1.pft
        echo "  case 'fb': '  251'">>1.pft
        #REM                       123456789012345678
        echo "  case 'fc': '  252'">>1.pft
        echo "  case 'fd': '  253'">>1.pft
        echo "  case 'fe': '  254'">>1.pft
        echo "  case 'ff': '  255'">>1.pft
        echo " endsel,">>1.pft
        echo " c28,">>1.pft
        echo " f(val(v1030^n),10,0),">>1.pft
        echo " /">>1.pft
        echo ")">>1.pft
      fi
    fi
  fi

  TPR="iffatal"
  MSG="error: mx can't create report $1.sta with char analisys format"
  $FFI/mx stat pft=@1.pft -all now >> $1.sta
  . log

fi

# ------------------------------------------------------------------- #
# Apaga os arquivos de trabalho

rm stat.mst
rm stat.xrf
rm 1.pft

TPR="end"
. log
