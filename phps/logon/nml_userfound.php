<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>ErrCadastro | WebISIS [QAPLA]</title>
	<meta charset="ISO-8859-1">
	<link rel="shortcut icon" href="/images/fqapla.ico" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
	<meta http-equiv="refresh" content="5; url=<?php echo HOMESITE . substr($pg_start,1) ?>?Logon=false">
	<!-- Para uso da nova vers�o do fontAwesome -->
	<script type="text/javascript" src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
	<script type="text/javascript" src="js/myjs.js"></script>
	<!-- Carrega font especifica a ser utilizada -->
	<link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body>
	<section>
		<div class="container">
			<div class="formlogin">
				<h1>Erro de Cadastro em WebISIS</h1>
				<div class="link">
					<p>
					Usu�rio j� existe!<br><br><a href="<? echo $pg_start ?>?Logon=false">Tentar novamente!</a></p>
				</div>
				<div class="link">
					<p>Voltar ao in�cio<br><br>
					<a href="<?php echo $pg_start ?>">Novo<br>Login!</a></p>
				</div>
			</div>
		</div>
	</section>
</body>
</html>
