<?php
	header('Content-Type: text/html; charset=ISO-8859-1');
	require_once("../conf/webisis.ini.php");
	//die("Chegou a form.php<br>\n");
	
	/*	RECOMENDACOES IMPORTANTES
	 *
	 * Esta biblioteca PHP � para interfacear a linguagem PHP com uma base no padrao CDS/ISIS
	 * Portanto est� restrita a o encoding ISO-8859-1, pois o UTF-8 N�O � suportado no CDS/ISIS
	 */
	// Inclusao da biblioteca de fun��es CISIS
	require_once($bibCISIS);

	// Verifica o status da base de dados a operar
	// Inicalizacao de variaveis
	//die("Cheguei em form.php!");
	$rasc       = array();			// Array para os dados vindo de formul�rio
	$reg_buffer = array();			// Array para os dados dos campos do registro a gravar
	$controlreg = array();			// Array para o registro de controle da base de dados
	$retorno = 0;					// Valor default para o ststua de retorno da operacao UPDATED
	$registry = 0;					// Situacao padrao adicionar novo registro
	$f_mfn=true;					// Buffer com a leitura do status do MFN (ativo ou deletado)

	if (isset($_REQUEST['acao'])) {
		$acao = $_REQUEST['acao'];
	} else {
		$acao = "";
	}

	if (isset($_REQUEST['expressao'])) {
		$buscar = $_REQUEST['expressao'];
	} else {
		$budsca = "";
	}
	
	// Avalia se deve adicionar registro (registry == 0) ou editar um existente (registry != 0)
	if (isset($_REQUEST["registro"])) {
		$registry = $_REQUEST["registro"];
	} else {
		$registry = 1;
	}
	
	// Processa caminho e nome da base de dados
	$BASE = $_REQUEST['base'];	// Caminho pode ser por configura��o em breve
	// Obtem o path e o nome da base
	$BASE = $basesDir . "/" . $BASE . "/" . $BASE;
	//die("Base: $BASE");
	$pathbase=dirname($BASE);
	$basename=basename($BASE);
	//echo "PATHBASE: $pathbase<br>";
	//echo "BASENAME: $basename<br>";

//echo "<br>/form.php?registro=" . $_REQUEST['registro'] . "&acao=" . $_REQUEST['acao'] . "&base=" . $_REQUEST['base'] . "<br>";

	// Uniformiza o nome do masterfile
	if (($pathbase[0] == "/") || (($pathbase[0] == ".") && (strlen($pathbase) == 1))) {
		$BASE = $pathbase . "/" . $basename;
	} else {
		$BASE = "./" . $pathbase . "/" . $basename;
	}
	//echo "BASE: $BASE<br>";

	/* Aqui com o nome da base inclundo caminho at� a mesma */
	// Inicializa as vari�veis poss�veis de um registro
	$texto=""; for ($i = 1; $i < 1000; $i++) { $texto .= "\$v" . substr( "000" . substr($i,0,strlen($i)),-3,3) . "=''; "; }; eval ($texto);
	// Determina nome do arquivo de inclusao
	$planilha = '../fmts/' . $basename . '.fmt.php';	// Determina qual a planilha de entrada a utilizar
	$resultad = '../pfts/' . $basename . '.pft.php';	// Determina qual o formato de exibi��o a utilizar
	//echo "Planilha da base: $planilha<br>";
	//echo "Formato da base: $resultad<br>";

	// Verifica se a base de dados existe e pode ser escrita
	//      Falta verificar se:
	//              a base pode ser escrita
	//              a base pode ter o indice atualizado
	$dbstatus = STATUS($BASE, $controlreg);
	//echo "DB Status: bindec($dbstatus)";
	//die();
	//die("form.php 73 - Status da base lido: $dbstatus<br>\n");
	if (($dbstatus & bindec('00111111')) > 0 ) {
		// N�o pode editar a base por algum motivo, sinaliza a condi��o
		?>
		<!DOCTYPE html>
		<html lang="pt-br">
		<head>
			<title>Ok | WebISIS [QAPLA]</title>
			<meta charset="iso-8859-1">
			<link rel="shortcut icon" href="css/fqapla.ico" />
			<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0" />
			<!-- Para uso da nova vers�o do fontAwesome -->
			<script src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
			<!-- Carrega font especifica a ser utilizada -->
			<link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet">
			<link rel="stylesheet" type="text/css" href="css/estilo.css" />
		</head>

		<body>
			<section>
				<div class="container">
					<div class="formlogin">
						<h1>WebISIS</h1>
						&nbsp;<br>
						&nbsp;<br>
						<div class="link">
							<p>Base de dados inating�vel!</p>
							<p>Status: <?php echo substr('0000000' . decbin($dbstatus), -8) . "b"?></p>
						</div><!-- link -->
						&nbsp;<br>
						&nbsp;<br>
						<div class="link">
							Retornar ao <a href="menu.php"><i class="fas fa-bars"></i>&nbsp;&nbsp; menu<br />principal</a>
						</div><!-- link -->
					</div><!-- formlogin -->
				</div><!-- container -->
			</section>
		</body>
		</html>
		<?php
		die();
	}

	$name_op = $_SESSION['login'];
	if (isset($_REQUEST['creg'])) {
		$registry = $_REQUEST['creg'];
	} else {
		$registr = 1;
	}

	// D� tratamento � a��es solicitadas pelos controles do formul�rio
	if (isset($_REQUEST["action"])) { $acao = $_REQUEST["action"]; }
	switch($acao) {
		
		// Navega��o na base de dados
		case	"primer":
			$registry = 1;
			break;
			
		case	"anter":
			$registry -= 1;
			($registry < 1) ? $registry = 1 : $registry = $registry;
			break;
			
		case	"proxi":
			$registry += 1;
			($registry > $controlreg["nxtmfn"] - 1) ? $controlreg["nxtmfn"] - 1 : $registry = $registry;
			break;
			
		case	"ultimo":
			$registry = $controlreg["nxtmfn"] - 1;
			break;
			
		case	"goto":
			break;
			
		// A��es sobre a base de dados
		case	"gravar":
			// Toma os campos e dados do formul�rio
			foreach($_REQUEST as $idx => $valor) {
				if (($idx != "BASE") && ($idx != "action") & ($idx != "registro") & ($idx != "expressao")) {
					// Monta o array com os dados a gravar
					$rasc[$idx] = $valor;
				}
			}

			// Efetua ultimo ajuste em campos administrativos
			$rasc["v610"] = substr($rasc["v610"] . "^n$usuario",0, strlen($usuario)+10+2);
			//echo "<pre><br>";
			//print_r($rasc);
			//echo "</pre><br />";
			//die("Parei!");

			// Coloca os Dados no array de campos
			foreach($rasc as $idx => $valor) {
				//echo "Valor de $idx vale: $valor<br>\n";
				//echo "Valor de $idx em hexa: " . strToHex($valor) . "<br>\n";
				$valor = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $valor);
				//echo "Valor de $idx em hexa: " . strToHex($valor) . "<br>\n";
				if ($valor != "") { 
				$valor = str_replace("\n", "%", $valor);
				//echo "Tam d valor de $idx: " . strlen($valor) . "<br>\n";
				$valor_arr = explode('%', $valor);
				$reg_buffer[$idx] = $valor_arr;
				}
			}
			
			// Monta a chamada a funcao de atualizacao de base de dados
			$tmp = $dbstatus & bindec('00111111');
			//echo "Status da base de dados: " . substr('0000000' . decbin($dbstatus),-8) . "<br>\n";
			if ($tmp == 0) {
				// Chama a funcao de update se n�o tem impedimento por direitos
				//die("Vamos gravar");
				$retorno = UPDATE($BASE, $registry, $reg_buffer);
			} else {
				echo "<b>Warning</b>: N�o foi poss�vel atualizar a base <b>$basename</b>. ";
				$retorno = bindec('11000000') | $tmp;
				//die("N�o vamos gravar");
			}

			// Avalia o retorno de UPDATE
			$tmpupdt = $retorno & bindec('11110101');
			if ($tmpupdt != 0) {
				// Aconteceu algum codigo de erro
				echo "C�digo de erro retornado: " . substr('00000000' . decbin($retorno),-8) . "b<br>\n";
			}
			break;

		case	"eliminar":
			// Delecao l�gica de de registro
			$retorno = DELETE($BASE, $registry);
			//echo "<br>DELE��O do registro $registry da base $basename<br><br>\n";
			$tmp = $retorno & bindec('11110101');
			if ($tmp != 0) {
				// Aconteceu algum codigo de erro
				echo "<b>Warning</b>: N�o foi poss�vel apagar o registro n�mero <b>$registry</b> da base <b>$basename</b>. C�digo de erro retornado: " . substr('0000000' . decbin($retorno),-8) . "b<br>\n";
			} else {
				// Correu bem a operacao
				echo "Registro $registry de <b>" . basename($BASE) . "</b> eliminado com sucesso!<br>\n";
			}
			break;
			
		// Busca de registros da base de dados
		case	"search":
			if (isset($_REQUEST['expressao'])) {
				$buscar=$_REQUEST['expressao'];
			} else {
				$buscar="$";
			}
			include('resul.php');
			break;
		// Recebeu um valor desconhecido
		default:
	}

	// Se n�o for a cria��o de um novo registro, l� registro corrente para exibi��o
	if ($registry !=0 ) {

		// Leitura de registro da base de dados
		$leitura=array();		// Buffer para reter dados lidos
		$qtdfld = 0;			// Quantidade de campos lidos
		$retorno = READ($BASE, $registry, $leitura, $qtdfld);	// Fun��o efetiva de leitura
		if ($retorno != 0) {
			// Aconteceu algum codigo de erro
			echo "C�digo de erro retornado: $retorno<br>\n";
		}
		//var_dump($leitura);
		//echo "<br>Base de dados => $BASE<br>V001 = " . $leitura["v1"][0] . "<br>\n";
		//die();
		
		$f_mfn = $leitura['vsts'][0];
		for ($i = 0; $i < $qtdfld; $i++) {	// Campo a campo (primeiro indice do array sao os campos)
			$dado=current($leitura);		// Obt�m o array do campo
			$occ=count($dado);				// Obt�m numero de ocorr�ncias do campo
			$campo=key($leitura);			// Obt�m identifica��o de campo (primeiro �ndice do array)
			if ($campo != "vsts") { $campo="v" . substr("000" . substr($campo,1,strlen($campo)-1),-3,3); }
			for ($j = 0; $j<$occ; $j++) {	// Ocorr�ncia por ocorr�ncia do campo (segundo �ndice s�o as ocorr�ncias)
				$linha = $j + 1;			// Prepara o n�mero da ocorr�ncia
				$occcampo = $dado[$j];		// Obt�m dado da ocorr�ncia
				if ($campo != "vsts") { $$campo .= $occcampo . "\n"; }
			}
			next($leitura);					// Avan�a para o pr�ximo campo
		}
		//echo "<br>V001 = " . $leitura["v1"][0] . "<br>\n";
	}
	?>
<!DOCTYPE html>
<html lang="pt-br">
	<head>
		<title>Base <?php echo strtoupper(trim($basename));?> | WebISIS [QAPLA]</title>
		<meta charset="ISO-8859-1" />
		<link rel="shortcut icon" href="/images/fqapla.ico" />
		<!-- Meta tags para fins de SEO -->
		<meta name="robots" content="noindex, nofollow" />
		<meta name="author" content="QAPLA Com�rcio e Servi�os de Inform�tica Ltda-ME" />
		<meta name="keywords" content="Editor de bases, CDS/ISIS, Bases de dados textuais" />
		<meta name="description" content="Sistema Web (64 bits) para manuten��o de dados em bases CDS/ISIS" />
		<!-- Estiliza��o e responsividade -->
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<!-- Para uso da nova vers�o do fontAwesome -->
		<script src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
		<!-- Carrega font especifica a ser utilizada -->
		<link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet" />
		<link rel="stylesheet" type="text/css" href="/css/estilo.css" />
	</head>

	<body>
		<!-- Cabe�alho das p�ginas abrigando logo marca e menu de fun��es -->
		<header>
			<div class="container">
				<div class="LogoMarca">
					<h1>WebISIS</h1>
				</div><!-- LogoMarca -->
				<div id="menu">
					<!-- Controle de exibi��o de menu em dispositivos mobile -->
					<input type="checkbox" id="bt_menu" />
					<label for="bt_menu"><i class="fas fa-bars"></i></label>
					<h1>WebISIS</h1>
					<!-- Menu de fun��es -->
					<nav class="menu">
						<ul>
							<li><a href="menu.php">Home</a></li>
							<!--<li><a href="#">Editar Base</a></li>-->
							<li><p>Edita <?php echo strtoupper(trim($basename));?></p></li>
							<li><a href="#">Relat�rios</a>
								<ul>
<?php include("relatorios.inc"); ?>
								</ul>
							</li>
							<li><a href="#">Ferramentas</a>
								<ul>
<?php include("tools.inc"); ?>
								</ul>
							</li>
						</ul>
					</nav><!-- menu -->
				</div><!-- menu -->
				<div class="clear"></div>
			</div><!-- container -->
		</header>
		<!-- Formul�rio de edic�o de campos de registro -->
		<section>
			<div class="container">
				<form method="post" action="#">
					<!-- Identifica��o de base de dados e registro em edi��o -->
					<div class="w50">
						<div class="w50Mod">
							<h2 class="pri">Base de dados: </h2>
						</div>
						<div class="w50Mod">
							<h2 class="seg"><?php echo "$basename"; ?></h2>
						</div>
					</div><!-- NomBase -->
					<div class="w50">
						<div class="w50Mod">
							<h2 class="pri">Registro #</h2>
						</div>
						<div class="w50Mod">
						<h2 class="seg"><?php
	if ($f_mfn == true) {
		echo $registry == '' ? "0" : "$registry";
	} else {
		echo "*<s>($registry)</s>*";
	}
?></h2>
						</div>
					</div><!-- RegEdit -->
					<div class="clear"></div>
					<!-- [:INI:] Planilha de edi��o de campos -->
					<?php include("$planilha"); ?>
					<!-- [:FIM:] Planilha de edi��o de campos -->
					<!-- Controles do formul�rio -->
					<div class="controles">
						<div class="functions">
							<button type="submit" name="action" value="goto">Ir para</button>
					  		<button type="submit" name="action" value="gravar">Salvar</button>
					  		<button type="submit" name="action" value="eliminar">Eliminar</button>
					  	</div><!-- functions -->
					  	<div class="nav">
					  		<!-- <button type="submit" name="action"   value="primer">|&lt;</button> -->
					  		<button type="submit" name="action"   value="primer"><i class="fas fa-fast-backward" style="font-size: 12px;"></i></button>
					  		<button type="submit" name="action"   value="anter"><i class="fas fa-step-backward" style="font-size: 12px;"></i></button>
					  		<input  type="text"   name="registro" value="<?php echo $registry;?>" size="8">
					  		<button type="submit" name="action"   value="proxi"><i class="fas fa-step-forward" style="font-size: 12px;"></i></button>
					  		<button type="submit" name="action"   value="ultimo"><i class="fas fa-fast-forward" style="font-size: 12px;"></i></button>
					  	</div><!-- nav -->
					  	<div class="search">
					  		<input  type="text"   name="expressao" value="" size="58">
					 		<button type="submit" name="action"    value="search">procurar</button>
					 	</div><!-- search -->
					 	<div class="clear"></div>
					</div><!-- controles -->
				</form>
			</div>
		</section><!-- container | Formul�rio de edic�o de campos de registro -->
		<!-- Rodap� da p�gina -->
		<footer class="container">
			<h4 class="info">QAPLA CSI - CNPJ 05.129.080/0001-01 - qapla@qaplaweb.com.br - www.qapla.com.br</h4>
			<h3>Todos os direitos reservados -- QAPLA <i class="far fa-registered"></i></h3>
		</footer>
	</body>
</html>
