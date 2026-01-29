<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>ErrCadastro | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="ISO-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <meta http-equiv="refresh" content="<?php echo TIMO;?>; url=<?php if($identOper > 1) {echo HOMESITE . $pg_hwork;} else {echo HOMESITE . $pg_admin;} ?>?origem=logok">
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- loginokpremnu.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <h1>Sucesso no login em <?php echo APLICACAO;?></h1>
        <div class="link">
          <p>Bem-vindo(a)<br><br><strong><?php echo $nome_Oper;?></strong><br><br>Tenha um bom trabalho !</p>
          <p><a href="<?php if($nome_Oper != "adm_qapla") {echo HOMESITE . $pg_hwork;} else {echo HOMESITE . $pg_admin;} ?>" accesskey="a">van&ccedil;ar...</a></p>
        </div>
      </div>
    </div>
  </section>
</body>
</html>
