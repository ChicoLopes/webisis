<!DOCTYPE html>
<html lang="pt-br">
<head>
  <title>ConexError | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="iso-8859-1">
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
  <!-- Para uso da versao 5 do Font Awesome -->
  <script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/js/myjs.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- errodeconexao.php -->
  <section>
    <div class="container">
      <div class="formlogin">
        <h1>Erro em <?php echo APLICACAO;?></h1>
        <p>Conex&atilde;o falhou: <br><?php
        // Efetua o parse da mensagem de erro recebida
        $pos1 = strripos ( $ERRMSG , "]" ) + 1;
         $ln1 = substr( $ERRMSG , 0 , $pos1 );
         $lnN = substr( $ERRMSG, $pos1 );
        $pos2 = strpos ( $lnN , "'" );
         $ln2 = substr( $lnN , 0 , $pos2 );
         $lnN = substr( $lnN , $pos2 );
        $pos3 = strpos ( $lnN , "(" );
         $ln3 = substr( $lnN , 0 , $pos3 );
         $ln3 = str_replace ( "'" , "" , $ln3 );
         $ln4 = substr ( $lnN, $pos3 );
        // Exibe a mensagem de erro conforme o erro
        if ( $ln2 == "" ) {
          // Não conseguiu conexão com o servidor
          echo "<br>" . $ln1 . "<br>" . $ln3 . "<br>" . $ln4 . "<br><br>\n";
        } else {
          // Autenticação falhou ao conectar
          echo "<br>" . $ln1 . "<br>" . "=> " . $ln2 . "<br>" . $ln3 . "<br>" . $ln4 . "<br><br>\n";
        }
?></p>
        <div class="link">
          Tente fazer <a href="<? echo $pg_wilogin ?>">login mais<br>uma vez!</a>
        </div>
      </div>
    </div>
  </section>
</body>
</html>
