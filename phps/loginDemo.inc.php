<?php
	/* Conecta ao banco de dados antevendo autenticação do usuário */
	date_default_timezone_set(LOCATION);	// Configura o fuso horário padrão utilizado por todas as funções de data e hora (vide webisis.ini.php)
	try {									// Tenta conectar ao servidor de banco de dados
		$pdo = new PDO('mysql:host=localhost;dbname=webisis','adm_WebISIS','&&@l2z%&js#%LtLe#2x^XHMur5vOyJokGC567yvk');
	} catch (PDOException $e) {				// Tentativa falhou dá tratativa
		$ERRMSG=$e->getMessage();
		//die("Problemas de conexão com o banco de dados<br>\n");					// <==
		include ($pg_dberror);
		die();
	}
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	/* Conexao estabelecida ou mensagem de erro emitida */
	
	/* Verifica se vem do formulário de Login ou de Cadastro  */
	if (isset($_REQUEST['envia'])){
		if ($_REQUEST['envia'] == "Cadastrar") {	// Se vem do form de cadastramento de usuário toma dados de cadawstro
			$emailOper = $_REQUEST['email'];
			$fone_Oper = "";
			$nivelOper = DEFAULT_USER_LEVEL;		// Nivel default para novos usuarios
			$pergSecre = "";
			$respSecre = "";
		}
		if ($_REQUEST['envia'] == "Buscar") {		// Se vem do form de recuperacao toma apenas e-mail (desativado no momento)
			$emailOper = $_REQUEST['email'];
		}
													// Sempre precisa de username e password, seja para autenticar ou cadastrar
		$nome_Oper = $_REQUEST['login'];
		$senhaOper = md5($_REQUEST['senha']);

		/* Procura pelo UserName informado na tabela de usuários */
		$sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");	// Busca o UserName informado para login
		$sql->execute();
		$info = $sql->fetchAll();
		/* Aqui já se sabe se o UserName está ou não no Banco de Dados */
		
			/* Se for Login espera que exista o UserName, se for cadastro espera que NÃO exista */
			if (! isset($_REQUEST['Logon'])) {		// Se Logon esta setado, é login
// Operação de LOGIN - Aqui achar o nome é legal
				if (count($info) == 0) {			// UserName não localizado
					//die("Usuário não encontrado<br>\n");					// <==
					include ($pg_usrnofd);			// Dá tratamento para Nome de Usuário não encontrado
					die();
				} else {							// UserName localizado
					foreach ($info as $key => $value) {
						$operadorNome  = $value['nome_Operador'];	// Toma username        do banco de dados
						$operadorSenha = $value['senhaOperador'];	// Toma senha           do banco de dados
						$operadorNivel = $value['nivelOperador'];	// Toma nivel de acesso do banco de dados
						// Verifica se a senha está correta
						if ($senhaOper != $operadorSenha) {		// Senha incorreta
							//die("Senha incorreta<br>\n");						// <==
							include ($pg_wrongdp);	// Dá tratamento para senha errada
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

							// Segue para o MENU de funções (A Alternativa é montar uma tela temporiuzada com a mensagem de Ok)
							//die("Entrada do sistema<br>\n");						// <==
							include ($pg_loginok);	// Executa a tarefa principal do sistema
							header('Location: ' . $pg_hwork);
							die();
						}
					}
				}	// Final do tratamento de Login
			} else {								// Se Logon não esta setado, é cadastramento
// Operação de CADASTRO - Aqui não achar o nome é legal
				if (count($info) != 0){
					//die("Usuário já existe, tente outro username!<br>\n");					// <==
					include ($pg_userfnd);			// Dá tratamento para Nome de Usuário encontrado (volta para cadastro ou login)
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
