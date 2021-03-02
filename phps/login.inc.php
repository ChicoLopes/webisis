<?php
	/* Conecta ao banco de dados antevendo autenticação do usuário */
	date_default_timezone_set(LOCATION);	// Configura o fuso horário padrão utilizado por todas as funções de data e hora (vide webisis.ini.php)
	try {									// Tenta conectar ao servidor de banco de dados
		$pdo = new PDO('mysql:host=localhost;dbname=webisis','adm_WebISIS','&&@l2z%&js#%LtLe#2x^XHMur5vOyJokGC567yvk');
	} catch (PDOException $e) {				// Tentativa falhou dá tratativa
		$ERRMSG=$e->getMessage();
		include ($pg_dberror);
		die();
	}
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	/* Conexao estabelecida ou mensagem de erro emitida */
	
	/* Verifica se há dados de formulário disponiveis */
	if (isset($_REQUEST['envia'])){
		$nome_Oper = $_REQUEST['login'];
		$senhaOper = md5($_REQUEST['senha']);

		/* Procura pelo UserName informado na tabela de usuários */
		$sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");	// Busca o UserName informado para login
		$sql->execute();
		$info = $sql->fetchAll();
		/* Aqui já se sabe se o UserName está ou não no Banco de Dados */
		
		if (count($info) == 0) {			// UserName não localizado
			include ($pg_usrnotf);			// Dá tratamento para Nome de Usuário não encontrado
			die();
		} else {							// UserName localizado
			foreach ($info as $key => $value) {
				$operadorNome  = $value['nome_Operador'];	// Toma username        do banco de dados
				$operadorSenha = $value['senhaOperador'];	// Toma senha           do banco de dados
				$operadorNivel = $value['nivelOperador'];	// Toma nivel de acesso do banco de dados
				// Verifica se a senha está correta
				if ($senhaOper != $operadorSenha) {					// Senha incorreta
					if ( $nome_Oper == SUPERUSER) {					// Tratamento de Super User com erro na senha
						die("Senha incorreta!");
						include ( $pg_suerror );
						die();
					} else {
						die("Senha incorreta, tente novamente<br>\n");	// Dá tramamento para Senha incorreta
					}
				} else {											// Senha Correta
					// Login efetuado com sucesso
					// Inicia a sessao de trabalho do operador logado
					session_start ();
					session_destroy ();
					session_start ();
					if (! isset($_SESSION['login'])) {	// Isto testa a existencia prévia da sessão
						$_SESSION['login'] = $operadorNome;
						$_SESSION['nivel'] = $operadorNivel;
					}
					
					if ( $operadorNome == SUPERUSER ) {
						// Segue para o MENU de funções administrativas
						die ("Avança para o menu administrativo!<br>\n");
						include ($pg_loginok);	// Executa a tarefa principal do sistema
						header ('Location: mnuAdm.php');
						die ();
					} else {
						// Segue para o MENU de funções (A Alternativa é montar uma tela temporizada com a mensagem de Ok)
						die ("Avança para o menu principal!<br>\n");
						include ($pg_loginok);	// Executa a tarefa principal do sistema
						header ('Location: menu.php');
						die ();
					}
				}
			}
		}	// Final do tratamento de Login
	}
?>
