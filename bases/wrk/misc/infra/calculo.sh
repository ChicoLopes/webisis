#!/bin/sh
# Autor: Daniel Angst
# Data: 09 de Fevereiro de 2006
# Calcula a diferenca de data
#

# Funcionamento:
# Esse script verifica a diferenca entre as datas passadas. Se houver 
# diferenca, ele analisa aonde esta a diferenca, ou seja,
# se eh de minutos, horas, dias, meses e anos.
# O calculo eh feito baseado em minutos. Ou seja, as datas passadas sao 
# convertidas em minutos, e a diferenca
# eh convertida em anos, dias , horas, minuto


# Formato da Data:
# DDMMAAAAhhmm

# Meses com 31 dias
# 1,3,5,7,8,10,12
# Meses com 30 dias
# 4,6,9,11
# Mes de fevereiro
# 2


# Essa funcao testa os valoes passados para ver se estao OK.
testa_consistencia()
{
# teste 1
# Verifica se a data 2 eh maior que a data1. Ate pode se igual, mas nao menor.
# Obrigatoriamente, a data 2 deve ser maior que a data 1. Caso nao seja, nao calcula
    dia1=`echo $1 | cut -c1,2`
    mes1=`echo $1 | cut -c3,4`
    ano1=`echo $1 | cut -c5-8`
    hora1=`echo $1 | cut -c9,10`
    minuto1=`echo $1 | cut -c11,12`

    dia2=`echo $2 | cut -c1,2`
    mes2=`echo $2 | cut -c3,4`
    ano2=`echo $2 | cut -c5-8`
    hora2=`echo $2 | cut -c9,10`
    minuto2=`echo $2 | cut -c11,12`

TPR="start"
. log

INFO=" $MOSTRA_MASTER mais novo que arquivo $MOSTRA_INV"

    # Faz a consistencia para ver se as datas informadas estao Ok
    if [ $ano1 -gt $ano2 ] ; then  # Ano 1 nao pode ser maior que ano 2
	TPR="iffatal"
	MSG=$INFO
        [ ! $ano1 -gt $ano2 ]
	. log
    fi

    if [ $ano1 = $ano2 ]  && [ $mes1 -gt $mes2 ] ; then
       # Se eh o mesmo ano, o mes 2 nao pode ser menor que mes 1
        TPR="fatal"
        MSG=$INFO
        [ ! $mes1 -gt $mes2 ]
	. log
    fi
    if [ $ano1 = $ano2 ] && [ $mes1 = $mes2 ] ; then
#       if [ $dia1 -gt $dia2 ] ; then
          # Se o ano e mes sao o mesmo, o dia1 nao pode ser maior que o dia2
	  TPR="iffatal"
          MSG=$INFO
          [ ! $dia1 -gt $dia2 ]
          . log
#       fi
    fi

    if [ $ano1 = $ano2 ] && [ $mes1 = $mes2 ] && [ $dia1 = $dia2 ] ; then
#       if [ $hora1 -gt $hora2 ] ; then
          # Se o ano,mes e dia sao o mesmo, a hora1 nao pode ser maior que a hora2
          TPR="iffatal"
          MSG=$INFO
	  [ !  $hora1 -gt $hora2 ]
	  . log
#       fi
    fi

    if [ $ano1 = $ano2 ] && [ $mes1 = $mes2 ] && [ $dia1 = $dia2 ] && [ $hora1 = $hora2 ] ; then
#       if [ $minuto1 -gt $minuto2 ] ; then
          # Se o ano,mes,dia e hora sao o mesmo,o minuto1 nao pode ser maior que o minuto2
          TPR="iffatal"
          MSG=$INFO
	  [ ! $minuto1 -gt $minuto2 ]
	  . log
#       fi
    fi

TPR="end"
. log


# Teste 2
# Verifica se os valores informados para dia, mes, hora e minuto estao Ok

# Executa varios testes para ver se a data foi passada correta
for data in "$1" "$2"
do
 # Testa se o nro de valores passados esta correto
 tamanhotmp=`echo $data | wc -c`
 tamanho=`echo $tamanhotmp \- 1 | bc`
 if [ $tamanho != 12 ] ; then
     echo "O Formato da data esta errado. Deve ser informado no seguinte formado: DDMMAAAAhhmm"
     echo "Data informada errada: $data"
     echo "Saindo do script"
     exit
 fi

 line=$data
 dia=`echo $line | cut -c1,2`
 mes=`echo $line | cut -c3,4`
 hora=`echo $line | cut -c9,10`
 minuto=`echo $line | cut -c11,12`

 if [ $minuto -gt 59 ] ; then
    echo "A data passada, $data, esta errada."
    echo "O numero de minutos nao pode ser superior a 59 min."
    echo "Saindo do script."
    exit
 fi

 if [ $hora -gt 23 ] ; then
    echo "A data passada, $data, esta errada."
    echo "A hora passada nao pode ser maior que 23h."
    echo "Saindo do script."
    exit
 fi

 if [ $dia = 00 ] ; then
    echo "A data passada, $data, esta errada."
    echo "O dia nao pode ser zero."
    echo "Saindo do script."
    exit
 fi

 if [ $dia -gt 31 ] ; then
    echo "A data passada, $data, esta errada."
    echo "O dia passado nao pode ser maior que 31."
    echo "Saindo do script."
    exit
 fi

 if [ $mes = 00 ] ; then
    echo "A data passada, $data, esta errada."
    echo "O mes passado nao pode ser zero."
    echo "Saindo do script."
    exit
 fi

 if [ $mes -gt 12 ] ; then
    echo "A data passada, $data, esta errada."
    echo "O mes passado nao pode ser maior que 12."
    echo "Saindo do script."
    exit
 fi
 # Testa , caso o mes seja fevereiro e o dia 29, se o ano eh bisexto
 if [ $dia = 29 ] && [ $mes = 02 ] ; then
  ano=`echo $data | cut -c5-8`
  cal 2 $ano | grep 29 > /dev/null
  resposta=`echo $?`
  if [ $resposta != 0 ] ; then
     # bisexto=nao
     echo "A data passada, $data, esta errada."
     echo "O ano de $ano nao era bisexto."
     echo "Saindo do script."
     exit
  fi
 fi

done

} # Fim funcao testa_consistencia ()




# Inicio do shell

# Antes de mais nada, verifica se foi passado no minimo 2 datas como parametros
if [ "$1" = "" ] || [ "$2" = "" ] ; then
   echo "   ERRO:  # de parametros incorreto"
   echo "Sintaxe:  calc_date.sh <data1> <data2>"
   echo "          formato da data: ddmmyyyyHHMM"
   exit
fi

# testa se o formato de data passado esta OK
testa_consistencia "$1" "$2"

#
# Fim do script
#

