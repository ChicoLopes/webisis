<?php
require_once($bibGenFN);

/* *************************************************************** */
/*   Conecta ao banco de dados antevendo autenticacao do usuario   */
/* *************************************************************** */
date_default_timezone_set(LOCATION);	// Fuso horario padrao utilizado (vide webisis.ini.php)

// DSN  - Data Source Name (string da conexao com o Banco de Dados)
$dsn = "mysql:host=localhost; dbname=" . DATABASE . "; charset=latin1";

// Opcoes adicionais para seguranca e desempenho
$options = [
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Lancar excecao em caso de erro
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Retornar resultados como array associativo
  PDO::ATTR_EMULATE_PREPARES   => false,                  // Usar prepared statements reais
];

try {					// Tenta conectar ao servidor de banco de dados
  $pdo = new PDO($dsn, DBUSER, DBPASS, $options);
  fnLogOper( "login.inc.php", "Conectado ao Banco de Dados." );		//Anota evento no Log de Operacao

} catch (PDOException $e) {		// Tentativa falhou da tratativa
  $ERRMSG=$e->getMessage();
  fnLogSegr( "login.inc.php", "Sem conexao com o Banco de Dados." );	// Anota evento no Log de Seguranca
  fnLogOper( "login.ini.php", "Sem conexao com o Banco de Dados." );	// Anota evento no Log de Operacao
  
  include ($pg_dberror);
  ($DEBUG & _BIT6_) ? $dbgmsg="Problemas para conectar ao BD - login.ini.php" : $dbgmsg="";
  die($dbgmsg);
}

/* ************************************************ */
/* Conexao estabelecida ou mensagem de erro emitida */
/* ************************************************ */

/* ****************************************************************************************** */
/*                      Verifica de onde esta vindo o fluxo de execucao                       */
/* Se nao estiver vindo de lugar algum nao executa qualquer funcao, mostra a pagina container */
/* ****************************************************************************************** */
if (isset($_REQUEST['origem'])) {  // Origem nao esta setado quando eh a tela de LOGIN, de outra forma tem algum valor
  $origem = $_REQUEST['origem'];
  
  if ($DEBUG & _BIT0_) echo "<!-- [:debug:] Situacao anterior: " . $origem . " [:debug:] -->\n";

  // Efetua correcao de origem para direcionar aa edicao de cadastro de usuario
  if (isset($_REQUEST['envia'])) {
    if ($_REQUEST['envia'] == "Enviar resposta") {  // Se o submit foi 'Enviar resposta' deve editar cadastro
      $origem = "mudas";                            // Mudanca de senha 
      $nome_Oper = $_REQUEST['login'];
      if ($DEBUG & _BIT0_) echo "<!-- [:debug:] Operador informado: " . $nome_Oper . " [:debug:] -->\n";
    }
//    if ($_REQUEST['envia'] == "Cadastrar" | $origem == 'nwcad') {
//      $origem = "ufail";
//    }
  }

  // Executa acao em funcao da tela (pagina) de origem ($origem)
  // echo "Origem: $origem<br>\n";
  switch ($origem) {
  
  /* ******************************************************************************* *
   *  Vindo do formulario de cadastro rapido                                         *
   *  Tarefa: Garantir o usuario nao exista no banco de dados                        *
   *   Acoes: Se usuario nao encontrado no banco de dados prepara o registr e grava  *
   *      Se usuario ja existir apresenta aviso de pre-existencia                    *
   * ******************************************************************************* */
  case 'nwcad':
    // Cadastro Rapido com 'envia' valendo Cadastrar avalia se ja existe usuario se nao existir manda gravar o cadastro
    $nome_Oper = $_REQUEST['login'];		// UserName informado
    $emailOper = $_REQUEST['email'];		// E-mail informado
    $senhaOper = md5($_REQUEST['senha']);	// Senha informada
    $nivelOper = DEFAULT_USER_LEVEL;		// Nivel de operador padrao
    $respSecreta = "X";				// Simula resposta secreta de quando nao ha pergunta secreta
    //die("User: " . $nome_Oper . "<br>\nE-mail: " . $emailOper . "<br>\nSenha: " . $senhaOper . "<br>\nNivel: " . $nivelOper . "<br>\nResposta: " . $respSecreta);
    // Busca UserName na tabela de operadores da base de dados (esperando nao encontrar)
    $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");  // Busca UserName no Bando de Dados
    $sql->execute();
    $info = $sql->fetchAll();
    if (count($info) == 0) {
      // Grava o novo registro e operador na base de dados
      $sql = $pdo->prepare("INSERT `operadores` SET `nome_Operador`=?, `emailOperador`=?, `senhaOperador`=?, `nivelOperador`=?, `respSecreta`=?");
      $sql->bindParam(1, $nome_Oper);
      $sql->bindParam(2, $emailOper);
      $sql->bindParam(3, $senhaOper);
      $sql->bindParam(4, $nivelOper);
      $sql->bindParam(5, $respSecreta);

      //$sql->bindParam(8, $identOper);

      if ($sql->execute()) {
        // Insercao de registro com novo usuario efetuada com sucesso
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . "Insercao no cadastro de usuarios: " . $nome_Oper . " E-mail: " . $emailOper . " Nivel: " . $nivelOper . " Resposta: " . $respSecreta );
	unset($Logon);
	$origem = "login";
	unset($origem);
	echo "Logon: $Logon<br>\n";
	echo "origem: $origem<br>\n";
	echo "pg_wilogin: $pg_wilogin<br>\n";
	//include ($pg_wilogin . '/');
	($DEBUG & _BIT6_) ? $dbgmsg="Cadastro rapido efetuado - login.inc.php" : $dbgmsg="";
	echo $dbgmsg;
	header("Location: /index.php");
	die();
      } else {
        die("Ferrou-se algo deu errado ao registrar no banco de dados.");
      }
    } else {
      include ($pg_usrfail);	// Da tratamento para UserName preexistente
      ($DEBUG & _BIT6_) ? $dbgmsg="Cadastro rapido com usuario que ja existe - login.inc.php" : $dbgmsg="";
      die($dbgmsg);
    }
    break;

  /* ******************************************************************************* *
   *  Vindo do formulario de login                                                   *
   *  Tarefa: Validar usuario e conferir se a senha esta correta                     *
   *   Acoes: Se usuario nao encontrado no Banco de Dados convida a fazer novo login *
   *      Se senha correta   apresenta tela de boas vindas                           *
   *      Se senha incorreta apresenta opcoes de novo login ou alterar a senha       *
   * ******************************************************************************* */	
  case 'login':
    // Coleta dados do formulario de login
    $nome_Oper = $_REQUEST['login'];        // UserName informado
    $senhaOper  = md5($_REQUEST['senha']);  // Senha informada
    if ($DEBUG & _BIT1_) echo "<!-- [:debug:] O usuario indicado eh " . $nome_Oper . " e a senha informada eh " . $senhaOper . " (" . $_REQUEST['senha'] . ")" . " [:debug:] -->\n";
    
    /* ********************************************************************** *
     *   Inicia processo de login: aceita logar com username ou com e-mail    *
     *                                                                        *
     * Busca por username ou e-mail na tabela de operadores do Banco de Dados *
     * Recupera: nome; e-mail; (mesmo tento sido informado toma do banco)     *
     *           md5 da senha; fone; nivel; pergunta e resposta secretas      *
     * ********************************************************************** */
    
    // Determina se informou username ou e-mail
    if (strpos($nome_Oper, "@") > 1) {	// Informou e-mail pois tem '@' no conteudo
      // Procura pelo e-mail informado na tabela de usuarios
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE emailOperador='$nome_Oper'");  // Busca e-mail
      $sql->execute();
      $info = $sql->fetchAll();
    } else {				// Informou username pois nao tem '@' no conteudo
      // Vai procurar o UserName informado na tabela de usuarios
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");  // Busca UserName no Bando de Dados
      $sql->execute();
      $info = $sql->fetchAll();
    }

    // Se o array $info contiver algum conjunto de dados o usuario foi encontrado no banco de dados
    if (count($info) == 0) {
      
      /* ******************************** *
       * usuario informado nao cadastrado *
       * ******************************** */
      
      // Anota ocorrencia no Log de Operacao
      $identOper = "-";
      fnLogOper( "login.ini.php", $identOper . " Usuario informado (" . $nome_Oper . ") nao cadastrado no sistema." );
      
      include ($pg_usrnotf);		// Da tratamento para UserName nao encontrado
      ($DEBUG & _BIT6_) ? $dbgmsg="Usuario nao cadastrado - login.inc.php" : $dbgmsg="";
      die($dbgmsg);
    }
    
    /* ********************************************************************************************* *
     *  Usuario informado existe no banco de dados le seu registro para confirmar correcao da senha  *
     * ********************************************************************************************* */
    foreach ($info as $key => $value) {         // Le campos do usuario na tabela de usuarios
      $identOper     = $value['idOperador'];    // Toma UID do usuario     do banco de dados
      $operadorNome  = $value['nome_Operador'];	// Toma username           do banco de dados
      $operadorSenha = $value['senhaOperador'];	// Toma senha              do banco de dados
      $operadorEmail = $value['emailOperador'];	// Toma o e-mail           do banco de dados
      $operadorFone  = $value['fone_Operador'];	// Tome o fone             do banco de dados
      $operadorNivel = $value['nivelOperador'];	// Toma nivel de acesso    do banco de dados
      $operadorPerg  = $value['pergSecreta'];   // Toma a pergunta secreta do banco de dados
      $operadorResp  = $value['respSecreta'];   // Toma a resposta secreta do banco de dados
      if ($DEBUG & _BIT2_) {			// Se este nivel de debug estiver setado "mostra" o que foi lido no banco
        echo "<!-- [:debug:]\n";
        echo "== Registro lido na tabela 'operadores' da base 'webisis' ==\n";
        echo "      Id do Operador DB: " . $identOper     . "\n";
        echo "       Nome Operador DB: " . $operadorNome  . "\n";
        echo "      Senha Operador DB: " . $operadorSenha . "\n";
        echo "     E-mail Operador DB: " . $operadorEmail . "\n";
        echo "       Fone Operador DB: " . $operadorFone  . "\n";
        echo "      Nivel Operador DB: " . $operadorNivel . "\n";
        echo "   Pergunta Operador DB: " . $operadorPerg  . "\n";
        echo "   Resposta Operador DB: " . $operadorResp  . "\n";
        echo "============================================================\n";
        echo "[:debug:] -->\n";
      }
      
      /* ****************************************************************************************************************** *
       *  Compara a senha informada coma senha registrada no banco de dados                                                 *
       *  Acoes:                                                                                                            *
       *   Se a senha coincidir exibe a tela de boas vindas                                                                 *
       *   Se a senha nao coincidir                                                                                         *
       *    e se     for o SuperUsuario pode ser uma violacao de seguranca anota no log de seguranca e exibe tela de aviso  *
       *    e se nao for o Superusuario exibe a tela de senha errada                                                        *
       * ****************************************************************************************************************** */
      if ($senhaOper != $operadorSenha) {         // Senha incorreta
        if ( $nome_Oper == SUPERUSER) {           // Tratamento de Super User com erro na senha
          // Anota ocorrencia no Log de Seguranca
          fnLogSegr( "login.ini.php", $identOper . " Falha na tentativa de logar como administrador do sistema.");
          // Anota ocorrencia no Log de Operacao
          fnLogOper( "login.ini.php", $identOper . " Falha na tentativa de logar como administrador do sistema.");
          
          include ( $pg_suerror );
          ($DEBUG & _BIT6_) ? $dbgmsg="Tentativa de locar como administrador - login.inc.php" : $dbgmsg="";
          echo $dbgmsg;
          exit(240);
        } else {                                  // Tratamento de usuario comum com erro na senha
          // Anota ocorrencia no Log de Operacao
          fnLogOper( "login.ini.php", $identOper . " Falha na tentativa de logar como " . $nome_Oper . "." );
          
          include ( $pg_wrongps);
          ($DEBUG & _BIT6_) ? $dbgmsg="Senha incorreta foi inserida - login.inc.php" : $dbgmsg="";
          die($dbgmsg);
        }
      } else {                                    // Senha Correta - Login efetuado com SUCESSO
        // Inicia a sessao de trabalho do operador logado
        session_start ();
        session_destroy ();
        session_start ();
        if (! isset($_SESSION['login'])) {        // Isto testa a existencia pravia da sessao
          $_SESSION['login'] = $operadorNome;
          $_SESSION['nivel'] = $operadorNivel;
        }
        
        // Finalizada a etapa de login na aplicacao segue para o sistema
        fnLogOper( "login.ini.php", $identOper . " Iniciando sessao. Operador: " . $nome_Oper . " Nivel: " . $operadorNivel . "." );
        
        include ($pg_loginok);                    // Executa a tarefa principal do sistema ou a tarefa administrativa
        ($DEBUG & _BIT6_) ? $dbgmsg="Identificacao positiva - login.inc.php" : $dbgmsg="";
        die($dbgmsg);
      }
    }
    break;
    
  /* *********************************************************************************** *
   *  Vinda da tela de aviso de erro na senha (wrongPassword.php)                        *
   *  Acoes:                                                                             *
   *   Obter a pergunta secreta do usuario no banco de dados                             *
   *    Se nao houver pergunta secreta assume resposta padrao (xis miusculo)             *
   * *********************************************************************************** */
  case 'wrgps':
    // Testa se tem o UserName informado disponivel (variavel login em modo hidden), se nao tiver fim de jogo
    if (isset($_REQUEST['login'])) {
      $nome_Oper = $_REQUEST['login'];
      if ($DEBUG & _BIT1_) echo "<!-- [:DEBUG:] Vamos editar cadastro do sujeito: " . $nome_Oper . " [:DEBUG:] -->\n";
      
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");  // Busca o UserName informado
      $sql->execute();
      $info = $sql->fetchAll();
      foreach ($info as $key => $value) {
        $identOper     = $value['idOperador'];     // Toma o UID do usuario   do banco de dados
        $operadorNome  = $value['nome_Operador'];  // Toma UserName           do banco de dados
        $operadorSenha = $value['senhaOperador'];  // Toma senha              do banco de dados
        $operadorEmail = $value['emailOperador'];  // Toma o e-mail           do banco de dados
        $operadorFone  = $value['fone_Operador'];  // Tome o fone             do banco de dados
        $operadorNivel = $value['nivelOperador'];  // Toma nivel de acesso    do banco de dados
        $operadorPerg  = $value['pergSecreta'];    // Toma a pergunta secreta do banco de dados
        $operadorResp  = $value['respSecreta'];    // Toma a resposta secreta
        if ($DEBUG & _BIT2_) {                     // Se este nivel de debug estiver setado "mostra" o que foi lido no banco
          echo "<!-- [:debug:]\n";
          echo "== Registro lido na tabela 'operadores' da base 'webisis' ==\n";
          echo "      Id do Operador DB: " . $identOper     . "\n";
          echo "       Nome Operador DB: " . $operadorNome  . "\n";
          echo "      Senha Operador DB: " . $operadorSenha . "\n";
          echo "     E-mail Operador DB: " . $operadorEmail . "\n";
          echo "       Fone Operador DB: " . $operadorFone  . "\n";
          echo "      Nivel Operador DB: " . $operadorNivel . "\n";
          echo "   Pergunta Operador DB: " . $operadorPerg  . "\n";
          echo "   Resposta Operador DB: " . $operadorResp  . "\n";
          echo "============================================================\n";
          echo "[:debug:] -->\n";
        }
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Validando identidade do operador " . $nome_Oper . " por Pergunta Secreta." );
      }
      if ($operadorPerg == "") {
        $operadorPerg = "Digite X na resposta";
        $operadorResp = "X";
        
        // Anota ocorrencia de falta de pergunta secreta no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Pergunta Secreta vazia ao tentar provar a identidade do usuario " . $nome_Oper );
        // Forca resposta para pergunta vazia no registro do usuario no banco de dado
	$sql = $pdo->prepare("UPDATE `operadores` SET `respSecreta`=? WHERE `idOperador` = ?");
	$sql->bindParam(1, $operadorResp);
	$sql->bindParam(2, $identOper);
	if ($sql->execute()) {
          // Atualizacao do cadastro do usuario encontrado sem pergunta secreta
          // Anota ocorrencia no Log de Operacao
          fnLogOper ("login.inc.php", $identOper . " Atualizacao da resposta da pergunta secreta ausente " . $nome_Oper . " ok! Resposta: " . $operadorResp );
        }
      }
    }
    break;
    
  /* ******************************************************************************* *
   *  Vindo do formulario de veirficacao de autenticidade de usuario                 *
   *  Tarefa: Validar resposta da pergunta secreta                                   *
   *   Acoes:                                                                        *
   *      Se resposta correta segue para formulario de cadastro                      *
   *      Se resposta incorreta sinaliza a condicao                                  *
   * ******************************************************************************* */
  case 'pergs':			// Voltando do formulario de verificacao de identidade (pergs - pergunta secreta)
    if (isset($_REQUEST['login']) | isset($_REQUEST['respSecreta'])) {
      // Recupera o que veio pelo formulario
      $nome_Oper   = $_REQUEST['login'];
      $respSecreta = $_REQUEST['respSecreta'];
      if ($DEBUG & _BIT1_) {
        echo "<!-- [:debug:]\n";
        echo "== Registro lido na tabela 'operadores' da base 'webisis' ==\n";
        echo "     Operador informado: " . $nome_Oper   . "\n";
        echo "     Resposta fornecida: " . $respSecreta . "\n";
        echo "============================================================\n";
        echo "[:debug:] -->\n";				
      }
      
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");	// Busca o UserName
      $sql->execute();
      $info = $sql->fetchAll();
      //die("Estou aqui!");
      foreach ($info as $key => $value) {
        $identOper     = $value['idOperador'];     // Toma UID do usuaro      do banco de dados
        $operadorNome  = $value['nome_Operador'];  // Toma username           do banco de dados
        $operadorSenha = $value['senhaOperador'];  // Toma senha              do banco de dados
        $operadorEmail = $value['emailOperador'];  // Toma o e-mail           do banco de dados
        $operadorFone  = $value['fone_Operador'];  // Tome o fone             do banco de dados
        $operadorNivel = $value['nivelOperador'];  // Toma nivel de acesso    do banco de dados
        $operadorPerg  = $value['pergSecreta'];    // Toma a pergunta secreta do banco de dados
        $operadorResp  = $value['respSecreta'];    // Toma a resposta secreta do banco de dados
        if ($DEBUG & _BIT2_) {                     // Se este nivel de debug estiver setado "mostra" o que foi lido no banco
          echo "<!-- [:debug:]\n";
          echo "== Registro lido na tabela 'operadores' da base 'webisis' ==\n";
          echo "      Id do Operador DB: " . $identOper     . "\n";
          echo "       Nome Operador DB: " . $operadorNome  . "\n";
          echo "      Senha Operador DB: " . $operadorSenha . "\n";
          echo "     E-mail Operador DB: " . $operadorEmail . "\n";
          echo "       Fone Operador DB: " . $operadorFone  . "\n";
          echo "      Nivel Operador DB: " . $operadorNivel . "\n";
          echo "   Pergunta Operador DB: " . $operadorPerg  . "\n";
          echo "   Resposta Operador DB: " . $operadorResp  . "\n";
          echo "============================================================\n";
          echo "[:debug:] -->\n";
        }
      }
      // Testa se respondeu corretamente
      if ($respSecreta == $operadorResp) {
        // Respondeu corretamente deve seguir para o cadatro de nova senha
        $origem = mudas;
        include ($pg_frm_pass);
      } else {
        // Respondeu errado avisa e volta a pedir a resposta secreta ou volta para login pelo link
        include ($pg_wrongas);
      }
    }
    break;
    
  /* ******************************************************************************* *
   *  Vindo do formulario de cadastro                                                *
   *   Acoes: Ler o username informado e seguir para a mudanca de senha              *
   * ******************************************************************************* */
  case 'cadnk':                                                // cadnk - cadastro nao ok
    $nome_Oper = $_REQUEST['login'];
  /* ******************************************************************************** *
   * Vindo do formulario de resposta a pergunda secreta                               *
   * Acoes:                                                                           *
   *  Ler registro do UserName na tabela de operadores do banco de dados              *
   *  Conferir se a resposta secreta esta certa e verificar se a senha foi confirmada *
   *  Se a confirmacao de senha nao conferir voltar ao formulario                     *
   *  Se a confirmacao de senha conferir gravar o registro atualizado                 *
   * ******************************************************************************** */
  case 'mudas':                                                // mudas - muda senha
    // Voltando do formulario de edicao de registro de usuario
    // Decide se prepara o formulario ou se le o formulario
    
  if ($_REQUEST['envia'] != "Cadastrar") {
      /* ******************************************************** *
       * Toma dados no banco para confirmar identidade do usuario *
       * ******************************************************** */
      $resp_Operador = $_REQUEST['respSecreta'];	// Resgata a resposta do Operador
      // Recupera dados da base
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");	// Busca o UserName
      $sql->execute();
      $info = $sql->fetchAll();
      foreach ($info as $key => $value) {
        $identOper     = $value['idOperador'];     // Toma id do registro     do banco de dados
        $operadorNome  = $value['nome_Operador'];  // Toma username           do banco de dados
        $operadorSenha = $value['senhaOperador'];  // Toma senha              do banco de dados
        $operadorEmail = $value['emailOperador'];  // Toma o e-mail           do banco de dados
        $operadorFone  = $value['fone_Operador'];  // Tome o fone             do banco de dados
        $operadorNivel = $value['nivelOperador'];  // Toma nivel de acesso    do banco de dados
        $operadorPerg  = $value['pergSecreta'];    // Toma a pergunta secreta do banco de dados
        $operadorResp  = $value['respSecreta'];    // Toma a resposta secreta do banco de dados
        if ($DEBUG & _BIT2_) {                     // Se este nivel de debug estiver setado "mostra" o que foi lido no banco
          echo "<!-- [:debug:]\n";
          echo "== Registro lido na tabela 'operadores' da base 'webisis' ==\n";
          echo "         ID Operador DB: " . $identOper     . "\n";
          echo "       Nome Operador DB: " . $operadorNome  . "\n";
          echo "      Senha Operador DB: " . $operadorSenha . "\n";
          echo "     E-mail Operador DB: " . $operadorEmail . "\n";
          echo "       Fone Operador DB: " . $operadorFone  . "\n";
          echo "      Nivel Operador DB: " . $operadorNivel . "\n";
          echo "   Pergunta Operador DB: " . $operadorPerg  . "\n";
          echo "   Resposta Operador DB: " . $operadorResp  . "\n";
          echo "============================================================\n";
          echo "[:debug:] -->\n";
        }
      }
      $emailOper = $operadorEmail;
      $fone_Oper = $operadorFone;
      $pergSecreta = $operadorPerg;
      $respSecreta = $operadorResp;
      if ($resp_Operador == $respSecreta) {
        // Resposta da Pergunta Secreta CORRETA
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Pergunta secreta respondida certo por " . $nome_Oper . ". Resposta informada: " . $resp_Operador . "." );
        
        include("../../" . $pg_frmpass);
      } else {
        // Resposta da Pergunta Secreta ERRADA
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Pergunta secreta respondida errado por " . $nome_Oper . ". Resposta informada: " . $resp_Operador . "." );
        
        include("../../" . $pg_wrongas);
      }
    } else {
      /* ********************************************** *
       * Vai efetuar o cadastro da nova senha informada *
       * ********************************************** */
      if (isset($_REQUEST['identOper'])) $identOper = $_REQUEST['identOper'];
      $nome_Oper = $_REQUEST['login'];
      $senhaOper = md5($_REQUEST['senha']);
      $passeOper = md5($_REQUEST['passe']);
      $emailOper = $_REQUEST['email'];
      $fone_Oper = $_REQUEST['phone'];
      $pergSecreta = $_REQUEST['pergSecreta'];
      $respSecreta = $_REQUEST['respSecreta'];
      
      // Garante que a senha foi corretamente fornecida
      if ($senhaOper != $passeOper) {
        // Segunda senha DIFERE da primeira
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login,inc.php", $identOper . " Confirmacao de senha de " . $nome_Oper . " com falha." );
        
        include("../../" . $pg_frmpass);	// Repoe o formulario para nova tentativa (falta msg erro!)
        ($DEBUG & _BIT6_) ? $dbgmsg="Senha de confirmacao nao coincide - login.inc.php" : $dbgmsg="";
        die($dbgmsg);
      }
			
      // Recupera nivel do operador, pois isso ele nao pode editar
      $sql = $pdo->prepare("SELECT * FROM `operadores` WHERE nome_Operador='$nome_Oper'");	// Busca o UserName
      $sql->execute();
      $info = $sql->fetchAll();
      foreach ($info as $key => $value) {
        $identOper = $value['idOperador'];	// Toma o id do registro
        $nivelOper = $value['nivelOperador'];	// Toma nivel de acesso do banco de dados
      }
      if ($DEBUG & _BIT1_) {
        echo "<!-- [:debug:]\n";
        echo "== Dados lidos no formulario de 'operadores' da base 'webisis' ==\n";
        echo "         ID Operador DB: " . $identOper . "\n";
        echo "       Nome Operador DB: " . $nome_Oper . "\n";
        echo "      Senha Operador DB: " . $senhaOper . "\n";
        echo "      Passe Operador DB: " . $passeOper . "\n";
        echo "     E-mail Operador DB: " . $emailOper . "\n";
        echo "       Fone Operador DB: " . $fone_Oper . "\n";
        echo "         Nivel Operador: " . $nivelOper . "\n";
        echo "   Pergunta Operador DB: " . $pergSecreta . "\n";
        echo "   Resposta Operador DB: " . $respSecreta . "\n";
        echo "=================================================================\n";
        echo "[:debug:] -->\n";
      }
      
      // Grava o registro na Base de Dados
      $sql = $pdo->prepare("UPDATE `operadores` SET `nome_Operador`=?, `emailOperador`=?, `fone_Operador`=?, `senhaOperador`=?, `nivelOperador`=?, `pergSecreta`=?, `respSecreta`=? WHERE `idOperador` = ?");
      $sql->bindParam(1, $nome_Oper);
      $sql->bindParam(2, $emailOper);
      $sql->bindParam(3, $fone_Oper);
      $sql->bindParam(4, $senhaOper);
      $sql->bindParam(5, $nivelOper);
      $sql->bindParam(6, $pergSecreta);
      $sql->bindParam(7, $respSecreta);
      $sql->bindParam(8, $identOper);
      
      if ($sql->execute()) {
        // Atualizacao de cadastro do usuario efetuado com sucesso
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Atualizacao de cadatro do usuario " . $nome_Oper . " ok! E-mail: " . $emailOper . " Fone: " . $fone_Oper . " Nivel: " . $nivelOper . " Pergunta: " . $pergSecreta . " Resposta: " . $respSecreta );
        
        include ("../../" . $pg_cadasok);
        ($DEBUG & _BIT6_) ? $dbgmsg="Atualizacao do BD realizado com sucesso - login.inc.php" : $dbgmsg="";
        die($dbgmsg);
      } else {
        // Atualizacao de cadastro falhou
        // Anota ocorrencia no Log de Operacao
        fnLogOper( "login.inc.php", $identOper . " Problema ao gravar o cadastro de " . $nome_Oper );
        
        include ("../../" . $pg_userfnd);
        ($DEBUG & _BIT6_) ? $dbgmsg="Problema ao atualizar o BD - login.inc.php" : $dbgmsg="";
        die($dbgmsg);
      }
    }
    ($DEBUG & _BIT6_) ? $dbgmsg="Apresentando o form de troca de senha - login.inc.php" : $dbgmsg="";
    die($dbgmsg);
    break;
    
  /* ******************************************************************************* *
   *  Vindo do formulario de login                                                   *
   *  Tarefa: Nenhuma                                                                * 
   * ******************************************************************************* */
  case 'dberr':     // Chegando da tela de sinalizacao de erro de conexao(dberr - erro de database)
  case 'usrnf':     // Chegando da tela de sinalizacao de usuario nao encontrado (pos login e verif.) (usrnf - user not found)
  case 'cadok':     // Chegando da tela de sinalizacao de edicao de registro bem sucedida (cadok - cadastro ok)
  case 'logok':     // Chegando da tela de sinalizacao de login bem sucedido (logok - login ok)
  case 'suerr':     // Chegando da tela de sinalizacao de erro de login do Super Usuario (suerr - erro no login do superuser)
    break;
    
  default:          // Caso nao previstos, anota evento no Log de Seguranca
    fnLogSegr( "login.ini.php", "Funcao solicitada desconhecida." );
  }
}

if (!isset($origem)) {
  fnLogOper( "login.inc.php", "Tela de LOGIN acessada." );	// Anota evento no Log de Operacao
}
?>
