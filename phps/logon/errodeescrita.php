 p<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>ErrCadastro | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="ISO-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <meta http-equiv="refresh" content="<?php echo TIMO;?>; url=<?php echo HOMESITE . substr($pg_wilogin,1) ?>?Logon=false">
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- errodeescrita.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <h1>Erro em <?php echo APLICACAO;?></h1>
        <form method="post">
          <input type="hidden" name="envia" value="Cadastrar">
          <input type="hidden" name="respSecreta" value="<?=$respSecreta?>">
        </form>
        <div class="link">
          <p>N&atilde;o pode gravar no<br>Banco de Dados!<br><br><a href="<? echo "../../" . $pg_frmpass ?>?origem=cadnk&envia=envia&respSecreta=<?=$respSecreta?>&login=<?=$nome_Oper?>">Repetir opera&ccedil;&atilde;o!</a></p>
        </div>
        <div class="link">
          <p>Fazer<br><br>
          <a href="<?php echo $pg_wilogin ?>">novo<br>login!</a></p>
        </div>
      </div>
    </div>
  </section>
</body>
</html>
