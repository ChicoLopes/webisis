<?php
	/*
	 *******************************************************
	 *                                                     *
	 * Declara��o de constantes de configura��o do WebISIS *
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
	 * Declara��o de constantes de configura��o do WebISIS *
	 *                                                     *
	 *******************************************************
	 */
	// Diretorio raiz do site da aplicacao
	$rootDir = '/home/www/wisis';
	
	// Biblioteca de fun�oes CDS/ISIS
	$bibCISIS = $rootDir . "/phps/fnCDSISIS.php";
	
	// Paginas principais do sistema
	$pg_start = "/index.php";				// P�gina de Login Demo
	$pg_hwork = "phps/menu.php";				// P�gina de Trabalho efetivo
	
	// Paginas de sinaliza��o do Login
	$pg_dberror = "phps/logon/errodeconexao.php";	// P�gina que informa problemas ao conectar no banco de dados
	$pg_usrnotf	= "phps/logon/user_notfound.php";	// P�gina que informa usu�rio n�o encontrado e da alternativas
	$pg_usrnofd	= "phps/logon/userDnotfound.php";	// P�gina que informa usu�rio n�o encontrado e da alternativas
	$pg_wrongps = "phps/logon/wrongPassword.php";	// P�gina que informa erro na senha e da alternativas
	$pg_wrongdp = "phps/logon/wrongDPasswrd.php";	// P�gina que informa erro na senha e da alternativas
	$pg_wrongsu = "phps/logon/wrongPasswdSU.php";	// Pp�gina que informa erro na senha do SU e da alternativas
	$pg_loginok = "phps/logon/loginokpremnu.php";	// P�gina que sinaliza login ok e desvia para a tarefa do sistema ap�s login
	$pg_suerror = "phps/logon/su_user_error.php";	// P�gina que sinaliza logn de SuperUsu�rio com erro na senha (deu boo-boo)

	$pg_userfnd = "phps/logon/nml_userfound.php";	// P�gina que sinaliza cadastro nok por usu�rio j� existente
	$pg_cadasok = "phps/logon/cadast_userok.php";	// P�gina que sinaliza cadastro ok e desvia para login

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
