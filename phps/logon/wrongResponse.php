<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>ErrResposta | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="ISO-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <!-- <meta http-equiv="refresh" content="<?php echo TIMO;?>; url=<?php echo HOMESITE . substr($pg_veruser,0) . "/login=" . substr($nomeoper,null); ?>"> -->
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">	
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- wrongResponse.php -->
  <?php
	
  ?>
  <section>
    <div class="container">
      <div class="formlogin">
        <h1>Erro de login em <?php echo APLICACAO;?></h1>
        <div class="link">
          <p>Resposta incorreta!</p>
          <p>Tentar <br><br><a href="/<?php echo $pg_veruser?origem=mudas&login=$operadorNome ?>" accesskey="R">esponder novamente!</a></p>
	  <p>Esqueceu a resposta?<br><br>
          Contate o administrador do sistema.</p>
<!--      <a href="<?php echo $pg_veruser . "?origem=wrgps&login=" . $operadorNome; ?>" accesskey="C">riar nova senha!</a></p> -->
        </div>
      </div>
    </div>
  </section>
</body>
</html>
