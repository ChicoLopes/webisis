<?php
  include('../../conf/webisis.ini.php');
  include('../login.inc.php');
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>CheckUser | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="iso-8859-1">
  <link rel="shortcut icon" href="css/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- verifica_User.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <form class="formulario" id="frmVerif" method="get" action="#" accept-charset="ISO-8859-1">
          <input type="hidden" name="origem" value="pergs">
          <input type="hidden" name="login"  value="<?=$nome_Oper?>">
          <h1><?php echo APLICACAO;?></h1>
          <p><strong><?=$operadorPerg?>?</strong></p>
          <div class="input-single">
            <label>Sua resposta <strong><?=$nome_Oper?></strong>:</label><br /><input type="text" name="respSecreta" placeholder="Resposta secreta" required="" autofocus="" />
          </div><!-- input-single -->
          <div class="input-single">
            <input type="submit" name="envia" value="Enviar resposta" />
          </div><!-- input-single -->
        </form>
        <div class="aviso">
          Voltar para o formul&aacute;rio e fazer <a href="<?php echo $pg_wilogin ?>" accesskey="L">ogin</a>
        </div>
      </div><!-- formlogin -->
    </div><!-- container -->
  </section>
</body>
</html>
