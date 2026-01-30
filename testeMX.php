<?php
/* **************************************************************************** *
 * Programa para comprovar funcionamento do mx com EXEC e detalhes de exibicao  *
 * **************************************************************************** */

echo "<html>";
echo "<head><title>TESTE</title></head>\n";
echo "<body>\n";
unset($retorno);
exec("ls -l cgi-bin/isis1660/mx", $retorno, $resposta);
echo "<p>ls -l cgi-bin/isis1660/mx [";
if ($resposta != 0) {
	echo "Nok! (Valor retornado: $resposta)]<br>\n";
} else {
	echo "Ok!]<pre>\n";
	var_dump($retorno);
  echo "</pre>";
  foreach ($retorno as $linha)
    echo $linha . "<br>\n";
}
echo "\n----\n</p>";

unset($retorno);
exec("cgi-bin/isis1660/mx what", $retorno, $resposta);
echo "<p>cgi-bin/isis1660/mx what [";
if ($resposta != 0) {
	echo"Nok! (Valor retornado: $resposta)]<br>\n";
} else {
	echo "Ok!]<pre>\n";
	var_dump($retorno);
  echo "</pre>\n";
  foreach ($retorno as $what)
    echo $what . "<br>\n";
}
echo "\n----\n</p>";

unset($retorno);
exec("ls -l bases/cds/", $retorno, $resposta);
echo "<p>ls -l bases/cds/ [";
if ($resposta != 0) {
  echo "Nok! (Valor retornado: $resposta)]<br>\n";
} else {
  //echo "Ok!]<pre>\n";
  //var_dump($retorno);
  //echo "</pre>\n";
  echo "Ok!]<br><br>\n";
  foreach ($retorno as $files)
    echo $files . "<br>\n";
}
echo "\n----\n</p>";

unset($retorno);
exec("cgi-bin/isis1660/mx bases/cds/cds count=1 +control now", $retorno, $resposta);
echo "<p>cgi-bin/isis1660/mx bases/cds/cds count=1 +control now [";
if ($resposta != 0) {
  echo"Nok! (Valor retornado: $resposta)]<br>\n";
} else {
  echo "Ok!]<pre>\n";
  var_dump($retorno);
  echo "</pre>\n";
  echo "$retorno[0]<br>\n";
  echo "$retorno[1]<br>\n";
  echo "$retorno[2]<br>\n";
}
echo "\n----\n</p>";

echo "</body>";
echo "</html>";
?>
