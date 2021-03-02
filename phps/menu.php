<?php
	header('Content-Type: text/html; charset=ISO-8859-1');
	//die("Chegou � menu.php<br>\n");
	/*	RECOMENDACOES IMPORTANTES
	 *
	 * Esta biblioteca PHP � para interfacear a linguagem PHP com uma base no padrao CDS/ISIS
	 * Portanto est� restrita a o encoding ISO-8859-1, pois o UTF-8 N�O � suportado no CDS/ISIS
	 */

	require_once("../conf/webisis.ini.php");

	/* Este bloco de c�digo em PHP verifica se existe uma sess�o ativa.
	 *  Se houver recupera o nome do operador para uso no sistema
	 */
	session_cache_expire(180);	// Tornar configuravel
	session_start();

	if((!isset ($_SESSION['login']) == true) and (!isset ($_SESSION['nivel']) == true)) {
		// Se qualquer um dos individuos guardados na sess�o 'falhar' para tudo e recome�a
		session_destroy();
		//header('location: login.php');	//<= Tentar passar para configuracao
		header('location:' . $pg_start);
	}
	 
	$usuario = $_SESSION['login'];
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>Fun��es | WebISIS [QAPLA]</title>
	<meta charset="ISO-8859-1">
	<link rel="shortcut icon" href="css/fqapla.ico" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0" />
		<!-- Meta tags para fins de SEO -->
	<meta name="robots" content="noindex, nofollow" />
	<meta name="author" content="QAPLA Com�rcio e Servi�os de Inform�tica Ltda-ME" />
	<meta name="keywords" content="Editor de bases, CDS/ISIS, Bases de dados textuais" />
	<meta name="description" content="Sistema Web (64 bits) para manuten��o de dados em bases CDS/ISIS" />
	<!-- https://www.youtube.com/watch?v=RzctM_ZXWAo -->
	<!-- Para uso da nova vers�o do fontAwesome -->
	<script src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
	<!-- Carrega font especifica a ser utilizada -->
	<link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body>
	<header>
		<div class="container">
			<div class="LogoMarca">
				<h1>WebISIS</h1>
			</div><!-- LogoMarca -->
			<div id="menu">
				<input type="checkbox" id="bt_menu" />
				<label for="bt_menu"><i class="fas fa-bars"></i></label>
				<h1>WebISIS</h1>
				<nav class="menu">
					<ul>
						<li><a href="/phps/menu.php">Home</a></li>
						<li><a href="#">Editar Base</a>
							<ul>
								<li><a href="/phps/form.php?base=cds">CDS</a></li>
								<li><a href="/phps/form.php?base=thes">Thesaurus</a></li>
<!--
								<li><a href="/phps/form.php?base=erri">Erros</a></li>
								<li><a href="/phps/form.php?base=fjl">Rolodex FJL</a></li>
-->
							</ul>
						</li>
						<li><a href="#">Relat�rios</a>
							<ul>
<?php include("phps/relatorios.inc"); ?>
							</ul>
						</li>
						<li><a href="#">Ferramentas</a>
							<ul>
<?php include("phps/tools.inc"); ?>
							</ul>
						</li>
					</ul>
				</nav>
			</div><!-- menu -->
			<div class="clear"></div>
		</div><!-- container -->
	</header>
	<session class="container">
		<div class="tampao"></div>
	</session>
	<footer class="container">
		<h4 class="info">QAPLA CSI - CNPJ 05.129.080/0001-01 - qapla@qaplaweb.com.br - www.qapla.com.br</h4>
		<h3>Todos os direitos reservados -- QAPLA <i class="far fa-registered"></i></h3>
	</footer>
</body>
</html>
