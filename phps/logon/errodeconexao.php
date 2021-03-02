<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>ConexError | WebISIS [QAPLA]</title>
	<meta charset="ISO-8859-1">
	<link rel="shortcut icon" href="/images/fqapla.ico" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
	<!-- Para uso da nova versão do fontAwesome -->
	<script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
	<script type="text/javascript" src="js/myjs.js"></script>
	<!-- Carrega font especifica a ser utilizada -->
	<!--<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap" rel="stylesheet" /> -->
	<link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body>
	<section>
		<div class="container">
			<div class="formlogin">
				<h1>Erro em WebISIS</h1>
				<p>Conexão falhou: <br><?php
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
				if ( $ln2 == "" ) {
					echo "<br>" . $ln1 . "<br>" . $ln3 . "<br>" . $ln4 . "<br><br>\n";
				} else {
					echo "<br>" . $ln1 . "<br>" . "=> " . $ln2 . "<br>" . $ln3 . "<br>" . $ln4 . "<br><br>\n";
				}
				?></p>
				<div class="link">
					Tente fazer: <a href="<? echo $pg_start ?>">login mais uma vez!</a>
				</div>
			</div>
		</div>
	</section>
</body>
</html>
