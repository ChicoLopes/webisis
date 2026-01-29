<?php
  include('conf/webisis.ini.php');
  //include('phps/loginDemo.inc.php');
  include('phps/login.inc.php');
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title><?php echo isset($_REQUEST['Logon']) ? "Cadastro" : "Login"; ?> | WebISIS [QAPLA]</title>
  <meta charset="iso-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <!--<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap" rel="stylesheet" /> -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- index.php -->
  <section>
    <div class="container">
      <div class="formlogin">
<?php if (! isset($_REQUEST['Logon'])) {		// Se eh operacao de Login monta o formulario de login
	// Logon sera setado com FALSE quando for um cadastro rapido, montando o formulario mais abaixo ?>
        <form class="formulario" id="frmLogin" method="post" action="#" accept-charset="ISO-8859-1">
          <input type="hidden" name="origem" value="login">
          <h1><?php echo APLICACAO;?></h1>
          <div class="input-single">
            <label>Nome:</label><br /><input type="text" name="login" placeholder="Seu user name" required="" autofocus="" />
          </div><!-- input-single -->
          <div class="input-single">
            <label>Senha:</label><br /><input type="password" name="senha" placeholder="Sua senha" required="" />
          </div><!-- input-single -->
          <div class="input-single">
            <!-- label>E-mail:</label><br /><input type="email" name="email" placeholder="Seu e-mail" / -->
          </div><!-- input-single -->
          <div class="input-single">
            <input type="submit" name="envia" value="Logar" />
          </div><!-- input-single -->
        </form>
        <div class="link">
          N&atilde;o tem senha? <a href="/index.php?Logon=false">v&aacute; para o <i class="fas fa-bolt"></i> cadastro r&aacute;pido</a>
        </div>

<?php } else { 		// Se nao eh login eh solicitacao de pre-cadastro, monta o formulario de pre-cadastramento ?>

	<form class="formulario" id="frmNwcad" method="post" action="#" accept-charset="ISO-8859-1">
          <input type="hidden" name="origem" value="nwcad">
          <h1><?php echo APLICACAO;?></h1>
          <div class="input-single">
            <label>Nome:</label><br /><input type="text" name="login" placeholder="Seu user name" required="" autofocus="" />
          </div><!-- input-single -->
          <div class="input-single">
            <label>Senha:</label><br /><input type="password" name="senha" placeholder="Sua senha" required="" />
          </div><!-- input-single -->
          <div class="input-single">
            <label>E-mail:</label><br /><input type="email" name="email" placeholder="Seu e-mail" required="" />
          </div><!-- input-single -->
          <div class="input-single">
            <input type="submit" name="envia" value="Cadastrar" />
          </div><!-- input-single -->
        </form>
        <div class="link">
          J&aacute; &eacute; cadastrado? <a href="/index.php">seguir para login! <i class="fas fa-door-open"></i></a>
        </div> <!-- link -->
<?php }	?>
      </div><!-- formlogin -->
    </div><!-- container -->
  </section>
<?php ($DEBUG & _BIT6_) ? $dbgmsg="Formulario de login - index.php\n" : $dbgmsg=""; echo $dbgmsg; ?>
</body>
</html>
