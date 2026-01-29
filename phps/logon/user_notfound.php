<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>ErrUsu&aacute;rio | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="ISO-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <meta http-equiv="refresh" content="<?php echo TIMO;?>; url=<?php echo HOMESITE ?>">
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- user_notfound.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <h1>Erro de login em <?php echo APLICACAO;?></h1>
        <div class="link">
          <p>Usu&aacute;rio n&atilde;o encontrado!</p>
          <p>Fazer<br><br><a href="<?php echo $pg_wilogin . "?origem=usrnf" ?>" accesskey="L">ogin novamente!</a></p>
        </div> <!-- link -->
      </div> <!-- formlogin -->
    </div> <!-- container -->
  </section>
</body>
</html>
