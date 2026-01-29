<?php
date_default_timezone_set(LOCATION);	// Configura o fuso horario padrao das funcoes de data e hora (vide webisis.ini.php)

// Conecta ao banco de dados antevendo autenticacao do usuario
$host    = 'localhost';			// Endereço do servidor (localhost ou IP)
$dbname  = 'webisis';			// Nome do banco de dados
$user    = 'adm_WebISIS';		// Usuário do banco de dados
$pass    = 'U55_r3l1@nt';		// Senha do usuario
$charset = 'latin1';			// Conjunto de caracteres usado na tabela
$dsn = "mysql:host=$host;dbname=$dbname;charset=$charset";

// Opcoes adicionais para seguranca e desempenho
$options = [
	PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,	// Dispara exception em caso de erro
	PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,	// Retorna resultados como array associativo
	PDO::ATTR_EMULATE_PREPARES   => false,			// Usar prepared statments reais
];

// Efetua a tentativa de conexao com o banco de dados
try {							// Tenta conectar ao servidor de banco de dados
	// Criando uma nova conexao PDO
	$pdo = new PDO($dsn, $user, $pass,  $options);
} catch (PDOException $e) {				// Tentativa falhou da tratativa
	$ERRMSG=$e->getMessage();
	// die("Problemas de conexao com o banco de dados<br>\n");	// <==
	include ($pg_dberror);
	exit();
}
//* Conexao estabelecida ou mensagem de erro emitida */

/* Verifica se vem do formulario de Login ou de Cadastro  */
if (isset($_REQUEST['envia'])){
	if ($_REQUEST['envia'] == "Cadastrar") { // Se vem do form de cadastramento de usuario toma dados de cadastro
		$emailOper = $_REQUEST['email'];
		$fone_Oper = "";
		$nivelOper = DEFAULT_USER_LEVEL; // Nivel default para novos usuarios
		$pergSecre = "";
		$respSecre = "";
	}
	if ($_REQUEST['envia'] == "Buscar") {    // Se vem do form de recuperacao toma apenas e-mail (desativado no momento)
		$emailOper = $_REQUEST['email'];
	}
	// Sempre precisa de username e password, seja para autenticar ou cadastrar
	$nome_Oper = $_REQUEST['login'];
	$senhaOper = md5($_REQUEST['senha']);

	// Procura pelo UserName informado na tabela de usuarios
	$sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");
	$sql->execute();
	$info = $sql->fetchAll();
	// Aqui ja se sabe se o UserName esta ou nao no Banco de Dados

	// Se for Login espera que exista o UserName ($nome_Oper), se for cadastro espera que NAO exista
	if (! isset($_REQUEST['Logon'])) {
	/* *************************************************** *
	 *  Se Logon esta setado, eh login (setado com false)  *
	 *  ************************************************** */
		// Operacao de LOGIN - Aqui achar o nome eh legal
		if (count($info) == 0) {			// UserName nao localizado
			//die("Usuario nao encontrado<br>\n");					// <==
			include ($pg_usrnofd);			// Da tratamento para Nome de Usuario nao encontrado
			die();
		} else {							// UserName localizado
			foreach ($info as $key => $value) {
				$operadorNome  = $value['nome_Operador'];	// Toma username        do banco de dados
				$operadorSenha = $value['senhaOperador'];	// Toma senha           do banco de dados
				$operadorNivel = $value['nivelOperador'];	// Toma nivel de acesso do banco de dados
				// Verifica se a senha esta correta
				if ($senhaOper != $operadorSenha) {		// Senha incorreta
					//die("Senha incorreta<br>\n");						// <==
					include ($pg_wrongdp);	// Da tratamento para senha errada
					die();
				} else {								// Senha Correta
					// Login efetuado com sucesso
					//echo "Login ok!<br>\n";
					// Inicia a sessao de trabalho do operador logado
					session_start();
					session_destroy();
					session_start();
					if(! isset($_SESSION['login'])) {	// Isto testa a existencia prévia da sessão
						$_SESSION['login'] = $operadorNome;
						$_SESSION['nivel'] = $operadorNivel;
					}
					// Segue para o MENU de funcoes (Alternativa montar 1 tela temporizada com a mensagem de Ok)
					//die("Entrada do sistema<br>\n");					// <==
					include ($pg_loginok);	// Executa a tarefa principal do sistema
					header('Location: ' . $pg_hwork);
					die();
				}
			}
		}	// Final do tratamento de Login
	} else {
	/* ******************************************** *
	 *  Se Logon nao esta setado, eh cadastramento  *
	 *  ******************************************* */
		// Operacao de CADASTRO - Aqui nao achar o nome eh legal
		if (count($info) != 0){
			//die("Usuario ja existe, tente outro username!<br>\n");				// <==
			include ($pg_userfnd);  // Da tratamento para Nome de Usuario encontrado (volta para cadastro ou login)
			die();
		} else {
			// Registro de operador autorizado
			$sql = $pdo->prepare("INSERT INTO operadores(nome_Operador, emailOperador, senhaOperador, nivelOperador) VALUES (?, ?, ?, ?)");
			$sql->bindParam(1, $nome_Oper);
			$sql->bindParam(2, $emailOper);
			$sql->bindParam(3, $senhaOper);
			$sql->bindParam(4, $nivelOper);
			$sql->execute();
			//die("Cadastro efetuado com sucesso!<br>\n");				// <==
			include ($pg_cadasok);	// Dá tratamento para o cadastramento Positivo (volta para login)
			die();
		}
	}
}
?>
