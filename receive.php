<!DOCTYPE html>
<html lang="pt-BR">
 <head>
  <title>DADOS RECEBIDOS</title>
  <meta charset="utf-8">
  <script>
function goBack() {
    window.history.back();
}
  </script>
  <style>
body {
	font-family: monospace, sans-serif;
      font-size: 14px;
}

h1,h2,h3,h4,h5,h6 {
	font-family: sans-serif;
}
  </style>
 </head>

 <body>
  <h2>.: Inspetor de conte&uacute;do de vari&aacute;veis de formul&aacute;rios :.</h2>
<?php

foreach ($_REQUEST as $key => $value) {
	echo "{$key} => {$value} ";
	echo "<br>\n";
}

echo "<br>\n";
?>
à esquerda o nome do dado no formulário<br>
à direita o valor informado

  <p>&nbsp;</p>
  <p><button onclick="goBack()">voltar &agrave; p&aacute;gina anterior</button></p>
  <p>&nbsp;</p>
  <h6>Este recurso tem o patrocínio de QAPLA CSI</h6>
 </body>
</html>
