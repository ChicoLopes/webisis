<?php
	/*
	 *******************************************************
	 *                                                     *
	 * Declaração de constantes de configuração do WebISIS *
	 *                                                     *
	 *******************************************************
	 */
	define("HOMESITE","http://wisis.local/");
	define("DEFAULT_USER_LEVEL", 9);
	define("LOCATION", 'America/Sao_Paulo');
	define("ENTGESTORA",'QAPLA');
	define("SUPERUSER",'adm_qapla');

	/*
	 *******************************************************
	 *                                                     *
	 * Declaração de constantes de configuração do WebISIS *
	 *                                                     *
	 *******************************************************
	 */
	// Diretorio raiz do site da aplicacao
	$rootDir = '/home/www/wisis';
	
	// Biblioteca de funçoes CDS/ISIS
	$bibCISIS = $rootDir . "/phps/fnCDSISIS.php";
	
	// Paginas principais do sistema
	$pg_start = "/index.php";				// Página de Login Demo
	$pg_hwork = "phps/menu.php";				// Página de Trabalho efetivo
	
	// Paginas de sinalização do Login
	$pg_dberror = "phps/logon/errodeconexao.php";	// Página que informa problemas ao conectar no banco de dados
	$pg_usrnotf	= "phps/logon/user_notfound.php";	// Página que informa usuário não encontrado e da alternativas
	$pg_usrnofd	= "phps/logon/userDnotfound.php";	// Página que informa usuário não encontrado e da alternativas
	$pg_wrongps = "phps/logon/wrongPassword.php";	// Página que informa erro na senha e da alternativas
	$pg_wrongdp = "phps/logon/wrongDPasswrd.php";	// Página que informa erro na senha e da alternativas
	$pg_wrongsu = "phps/logon/wrongPasswdSU.php";	// Ppágina que informa erro na senha do SU e da alternativas
	$pg_loginok = "phps/logon/loginokpremnu.php";	// Página que sinaliza login ok e desvia para a tarefa do sistema após login
	$pg_suerror = "phps/logon/su_user_error.php";	// Página que sinaliza logn de SuperUsuário com erro na senha (deu boo-boo)

	$pg_userfnd = "phps/logon/nml_userfound.php";	// Página que sinaliza cadastro nok por usuário já existente
	$pg_cadasok = "phps/logon/cadast_userok.php";	// Página que sinaliza cadastro ok e desvia para login

	// Diretorio onde se encontra o pacote CISIS
	//$cisisDir = $rootDir . '/cgi-bin/isis';
	  $cisisDir = $rootDir . '/cgi-bin/isis1660';
	//$cisisDir = $rootDir . '/cgi-bin/BigIsis';
	  $cisisTab = $rootDir . '/tabs';
	  $cisisGiz = $rootDir . '/gizmos';

	// Diretorio raiz das bases de dados
	$basesDir = $rootDir . '/bases';

	// Nome do arquivo de controle de bloqueio da base de dados
	$filebloq = "ctrlbloq.txt";

?>
