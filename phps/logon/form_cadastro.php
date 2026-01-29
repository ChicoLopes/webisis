<?php
  include_once('../../conf/webisis.ini.php');
  include_once('../login.inc.php');
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<title>Cadastro | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="iso-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- form_cadastro.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <form class="formulario" id="frmCadast" method="post" action="#" accept-charset="ISO-8859-1">
          <input type="hidden" name="origem" value="mudas">
          <input type="hidden" name="identOper" value="<?=$identOper?>">
          <h1><?php echo APLICACAO;?></h1>
          <div class="display-single">
            Nome: <strong><?=$nome_Oper?></strong>
          </div><!-- display-single -->
          <div class="input-single">
            <label>Senha:</label><br /><input type="password" name="senha" placeholder="Sua senha" required="" autofocus="" />
          </div><!-- input-single -->
          <div class="input-single">
            <label>Confirme a senha:</label><br /><input type="password" name="passe" placeholder="Sua senha novamente" required="" />
          </div><!-- input-single -->
          <div class="input-single">
            <label>E-mail:</label><br /><input type="email" name="email" placeholder="Seu e-mail" required="" value="<?=$emailOper?>"/>
          </div><!-- input-single -->
          <div class="input-single">
            <label>Fone:</label><br /><input type="text" name="phone" placeholder="Seu n&uacute;mero telef&ocirc;nico" required="" value="<?=$fone_Oper?>"/>
          </div><!-- input-single -->
          <div class="input-single">
            <label>Pergunta secreta:</label><br /><input type="text" name="pergSecreta" placeholder="Sua pergunta secreta" required="" value="<?=$pergSecreta?>"/>
          </div><!-- input-single -->
          <div class="input-single">
            <label>Resposta secreta:</label><br /><input type="text" name="respSecreta" placeholder="Sua resposta &agrave; pergunta" required="" value="<?=$respSecreta?>"/>
          </div><!-- input-single -->
          <div class="input-single">
            <input type="submit" name="envia" value="Cadastrar" />
          </div><!-- input-single -->
        </form>
      </div><!-- formlogin -->
    </div><!-- container -->
  </section>
</body>
</html>
