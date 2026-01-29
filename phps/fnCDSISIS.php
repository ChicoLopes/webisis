<?php
/*	ALGUMAS RECOMENDACOES IMPORTANTES
 *
 * Esta biblioteca PHP é para interfacear a linguagem PHP com uma base no padrao CDS/ISIS
 * Como tal deve se restringir a utilizar o encoding ISO-8859-1, pois o UTF-8 NÃO é suportado no CDS/ISIS
 */
require_once("../conf/webisis.ini.php");

/* Este bloco de código em PHP verifica se existe uma sessão ativa.
 *  Se houver recupera o nome do operador para uso no sistema
 */
session_cache_expire(180);	// Tornar configuravel
session_start();
 
if((!isset ($_SESSION['login']) == true) and (!isset ($_SESSION['senha']) == true)) {
  unset($_SESSION['login']);
  unset($_SESSION['senha']);
		//die("Retorno do teste de login é NEGATIVO");
  header('location:'.$pg_start);	//<= Tentar passar para configuracao
}
 
$usuario = $_SESSION['login'];

/*
 * Funcao:	normDatabase
 * Parametros:
 *	1 - String do nome da base + caminho a ser normalizada
 * Retorno:
 *	string do caminho+nome da base de dados normalizada
 */
function normDatabase($nomebase) {
	// Normaliza o nome da base de dados a operar
	$pathbase=dirname($nomebase);		// Obtem o path da base
	$basename=basename($nomebase);		// Obtem o nome da base
	if ((strlen($pathbase) == 1) && ($pathbase == "/")) $database =  $pathbase . $basename; else $database = $pathbase . "/" . $basename;
	return $database;
}	
 
/*									RETIRAR SE NAO FOR ADERENTE MESMO
 * Funcao: strToHex
 * Parametros:
 *	1 - String a ser convertida em valores hexadecimais
 * Retorno:
 *	string de codigos hexadecinal
 */
function strToHex($string){
    $hex = '';
    for ($i=0; $i<strlen($string); $i++) {
        $ord = ord($string[$i]);
        $hexCode = dechex($ord);
        $hex .= substr('0'.$hexCode, -2);
    }
    return strToUpper($hex);
}

/*
 * Funcao: STATUS
 * Parametros:
 *	1 - caminho e nome da base de dados				(passado por valor)
 *	2 - array com o registro de controle da base	(passado por referencia)
 * Retorno:
 *  bit mapped:	7 6 5 4  3 2 1 0
 *              | | | |  | | | |
 *              | | | |  | | | +-- M/F not found
 *              | | | |  | | +---- I/F not found
 *              | | | |  | +------ M/F read only
 *              | | | |  +-------- I/F read only
 *              | | | +----------- Directory not found
 *              | | +------------- Directory read only
 *              | +--------------- not defined
 *              +----------------- Error reading control register
 *       M/F I/F       M/F I/F   	   M/F I/F DIR	   M/F I/F DIR	   M/F I/F DIR	   M/F I/F DIR	
 *     0- p   p      8- p  r/o   	16- X   X   a	24- X   X   a	32- p   p  r/o	40- p  r/o r/o	
 *     1- a   p      9- a  r/o   	17- X   X   a	25- X   X   a	33- a   p  r/o	41- a  r/o r/o	
 *     2- p   a     10- p   -    	18- X   X   a	26- X   X   a	34- p   a  r/o	42- p   -  r/o	
 *     3- a   a     11- a   -    	19- X   X   a	27- X   X   a	35- a   a  r/o	43- a   -  r/o	
 *     4-r/o  p     12-r/o r/o   	20- X   X   a	28- X   X   a	36-r/o  p  r/o	44-r/o r/o r/o	
 *     5- -   p     13- -  r/o      21- X   X   a	29- X   X   a	37- -   p  r/o	45- -  r/o r/o	
 *     6-r/o  a     14-r/o  -    	22- X   X   a	30- X   X   a	38-r/o  a  r/o	46-r/o  -  r/o	
 *     7- -   a     15- -   -    	23- X   X   a	31- X   X   a	39- -   a  r/o	47- -   -  r/o	
 *     M/F I/F FLG	   M/F I/F FLG		[p = presente / ñp = não presente / r/o = read only]
 *  64- p   p  ñp 	72- p  r/o ñp	
 *  65- a   p  ñp 	73- a  r/o ñp	
 *  66- p   a  ñp 	74- p   -  ñp	
 *  67- a   a  ñp 	75- a   -  ñp	
 *  68-r/o  p  ñp 	76-r/o r/o ñp	
 *  69- -   p  ñp 	77- -  r/o ñp	
 *  70-r/o  a  ñp 	78-r/o  -  ñp	
 *  71- -   a  ñp 	79- -   -  ñp	
 *	Control register
 * array["nxtmfn"] próximo mfn a ser criado
 * array["mfcxx2"] Bloqueio de entrada
 * array["mfcxx3"] Bloqueio de leitura exclusiva
 * Algoritmo da operacao:
 *	 1-obtem caminho
 *	 2-verifica existencia do caminho
 *	 3-verifica direitos de escrita no diretorio
 *	 4-obtem nome
 *	 5-testa se existe XRF
 *	 6-testa se existe M/F
 *	 7-testa se existe CNT
 *	 8-testa se existe IFP
 *	 9-testa se existe L01
 *	10-testa se existe L02
 *	11-testa se existe N01
 *	12-testa se existe N02
 *	13-Verifica se tem direito de escrita no XRF
 *	14-Verifica se tem direito de escrita no M/F
 *	15-Verifica se tem direito de escrita no CNT
 *	16-Verifica se tem direito de escrita no IFP
 *	17-Verifica se tem direito de escrita no L01
 *	18-Verifica se tem direito de escrita no L02
 *	19-Verifica se tem direito de escrita no N01
 *	20-Verifica se tem direito de escrita no N02
 *	21-Le o CONTROL REGISTER da base
 */
function STATUS ($nomebase, &$CONTROL) {
	// Inicia variaveis internas da funcao STATUS
	global $cisisDir, $cisisTab, $cisisGiz;
	$returnCode = 0;
	$Control = array();
	
	// Normaliza o nome da base de dados a operar
	$pathbase=dirname($nomebase);		// Obtem o path da base
	$basename=basename($nomebase);		// Obtem o nome da base
	$database = normDatabase($nomebase);
/*
	echo "CISIS DIR: $cisisDir<br>\n";
	echo "CISIS TAB: $cisisTab<br>\n";
	echo "CISIS GIZ: $cisisGiz<br>\n";
	echo "PATH BASE: $pathbase<br>\n";
	echo "BASE NAME: $basename<br>\n";
	echo "DATA BASE: $database<br>\n";
	die();
 */
	// Se não há nome da base retorna com código de erro 192 ou 0b11000000
	if (strlen($basename) == 0) {
		echo "Basename &eacute; vazio!<br>";
		$CONTROL["nxtmfn"] = "";
		$CONTROL["mfcxx2"] = "";
		$CONTROL["mfcxx3"] = "";
		return 128+64;
	}
	
	//  Verifica existencia do diretorio
	if (!file_exists($pathbase)) {
		// Diretorio não existente retorna com código de erro 16 ou 0b00010000
		//echo "Diretório não existe!<br>";
		$returnCode |= 16;
	} else {
		// Existindo o caminho para a base podemos continuar
		// Verifica se podemos escrever no diretorio
		if (! is_writable($pathbase)) { echo "Diret&oacute;rio R/O<br>"; $returnCode |= 32; }	// Nao podendo ajusta codigo de retorno
		
		// Verifica existencia da base
		if ((! file_exists($pathbase . "/" . $basename . ".xrf")) || (! file_exists($pathbase . "/" . $basename . ".mst"))) {
			// Se não existe o MST ou XRF ajusta código de retorno com erro de inexistenca de M/File 1 ou 0b00000001
			//echo "Não existe a base de dados!<br>";
			$returnCode |= 1;
		} else {
			// Base existe, verifica se temos direito de escrita
			//echo "XRF: " . $pathbase . "/" . $basename . ".xrf";
		       	//echo ": " . is_writable($pathbase . "/" . $basename . ".xrf") . "<br>";
			//echo "MST: " . $pathbase . "/" . $basename . ".mst";
			//echo ": " . is_writable($pathbase . "/" . $basename . ".mst") . "<br>";
			if ((! is_writable($pathbase . "/" . $basename . ".xrf")) || (! is_writable($pathbase . "/" . $basename . ".mst"))) {
				// Se o Master File é só de leitura ajusta codigo de retorno com 4 ou 0b00000100 
				//echo "Base é R/O<br>";
				$returnCode |= 4;
			}
		}
		//die("Return Code: $returnCode<br>\n");

		// Verifica a existencia do Invertido
		if ((! file_exists($pathbase . "/" . $basename . ".cnt")) ||
			(! file_exists($pathbase . "/" . $basename . ".ifp")) ||
			(! file_exists($pathbase . "/" . $basename . ".l01")) ||
			(! file_exists($pathbase . "/" . $basename . ".l02")) ||
			(! file_exists($pathbase . "/" . $basename . ".n01")) ||
			(! file_exists($pathbase . "/" . $basename . ".n02")) ) {
			// Se não existe o Invertido ajusta código de retorno com inexistencia de I/F 2 ou 0b00000010
			$returnCode |= 2;
		} else {
			// Temos invertido verifica se temos direito de escrita
			if ((! is_writable($pathbase . "/" . $basename . ".cnt")) ||
				(! is_writable($pathbase . "/" . $basename . ".ifp")) ||
				(! is_writable($pathbase . "/" . $basename . ".l01")) ||
				(! is_writable($pathbase . "/" . $basename . ".l02")) ||
				(! is_writable($pathbase . "/" . $basename . ".n01")) ||
				(! is_writable($pathbase . "/" . $basename . ".n02")) ) {
				// Se o Inverted File é só de leitura ajusta código de retorno com 8 ou 0b00001000
				$returnCode |= 8;
			}
		}
		//die("Return Code: $returnCode<br>\n");
		
		// Le registro de controle
		$tmp = $returnCode & bindec(10010001);	// Filtra bit de sinalizacao de erro fatal
		//die("tmp: $tmp<br>\n");
		if ($tmp == 0) {
			unset($resposta);
			//die("$cisisDir/mx "  . $database . " +control count=0, $resposta, $retorno");
			exec("$cisisDir/mx " . $database . " +control count=0", $resposta, $retorno);
			//die("Retorno do MX:" . $retorno);
			// Prepara valores de retorno
			if (isset($resposta[0])) {
				// Se teve retorno pode ler o registro de controle
				$control = explode(" ",$resposta[2]);
				foreach($control as $chnome => $vlnome) {
					if ($vlnome!="" ) { array_push($Control, $vlnome);}
				}
				$CONTROL["nxtmfn"] = $Control[0];
				$CONTROL["mfcxx2"] = $Control[6];
				$CONTROL["mfcxx3"] = $Control[7];
				unset ($Control[0], $Control[1], $Control[2], $Control[3], $Control[4], $Control[5], $Control[6], $Control[7], $Control[8] );
			}
			// Prepara o retorno da funcao
			if ($retorno != 0) { $returnCode |= 128; }
		} else {
			// Tivemos um erro fatal prévio, simula valores para o retorno do registro de controle
			$CONTROL["nxtmfn"] = "";
			$CONTROL["mfcxx2"] = "";
			$CONTROL["mfcxx3"] = "";
		}
	}
	//die("Return Code: $returnCode<br>\n");
	return $returnCode;
}

/*
 * Funcao: CREATE
 * Parametros:
 *	1 - caminho e nome da base de dados
 *	2 - Flag de sobrescrever base existente (true|"true"|1|false|"false"|0)
 * Retorno:
 *	bit mapped: 7 6 5 4 3 2 1 0
 *				| | | | | | | |
 *				| | | | | | | +-- M/F not found
 *				| | | | | | +---- I/F not found
 *				| | | | | +------ M/F read only
 *				| | | | +-------- I/F read only
 *				| | | +---------- Directory not found
 *				| | +------------ Directory read only
 *				| +-------------- Overwrite not permited
 *				+---------------- undefined error
 *	  M/F I/F    	   M/F I/F   	   M/F I/F DIR	   M/F I/F DIR	   M/F I/F DIR	   M/F I/F DIR	
 *	 0- p   p    	 8- p  r/o   	16- X   X   a	24- X   X   a	32- p   p  r/o	40- p  r/o r/o	
 *	 1- a   p    	 9- a  r/o   	17- X   X   a	25- X   X   a	33- a   p  r/o	41- a  r/o r/o	
 *	 2- p   a    	10- p   -    	18- X   X   a	26- X   X   a	34- p   a  r/o	42- p   -  r/o	
 *	 3- a   a    	11- a   -    	19- X   X   a	27- X   X   a	35- a   a  r/o	43- a   -  r/o	
 *	 4-r/o  p    	12-r/o r/o   	20- X   X   a	28- X   X   a	36-r/o  p  r/o	44-r/o r/o r/o	
 *	 5- -   p    	13- -  r/o   	21- X   X   a	29- X   X   a	37- -   p  r/o	45- -  r/o r/o	
 *	 6-r/o  a    	14-r/o  -    	22- X   X   a	30- X   X   a	38-r/o  a  r/o	46-r/o  -  r/o	
 *	 7- -   a    	15- -   -    	23- X   X   a	31- X   X   a	39- -   a  r/o	47- -   -  r/o	
 *     M/F I/F FLG	   M/F I/F FLG	
 *  64- p   p  ñp 	72- p  r/o ñp	
 *  65- a   p  ñp 	73- a  r/o ñp	
 *  66- p   a  ñp 	74- p   -  ñp	
 *  67- a   a  ñp 	75- a   -  ñp	
 *  68-r/o  p  ñp 	76-r/o r/o ñp	
 *  69- -   p  ñp 	77- -  r/o ñp	
 *  70-r/o  a  ñp 	78-r/o  -  ñp	
 *  71- -   a  ñp 	79- -   -  ñp	
 * Operacao:
 *	1 - toma status da base de dados
 *  2 - tenta criar base de dados
 */
function CREATE ($nomebase, $sobrescreve) {
	// Inicia variaveis da funcao CREATE
	global $cisisDir, $cisisTab, $cisisGiz;
	$returnCode = 0;
	
	// massageia para normalizar valor
	switch ($sobrescreve) {
		case "true":
		case "1":
		case true:
			$sobrescreve = true;
			break;
		case "false":
		case "0":
		case false:
			$sobrescreve = false;
			break;
		default:
			$sobrescreve = true;
	}
	
	$controle = array();
	$retSTS = STATUS($nomebase, $controle);
	// retSTS = 0, 1, 2, 3 condicoes previas liberadas para criar a base
	// retSTS > 4 nem tenta criar e retorna com o status recebido

	$retSTS &= 55;	//	Bits relevantes apenas
	//	TRY:
	//   0 - base existe
	//   1 - base não existe
	//   2 - Invertido não existe
	//   3
	//	FAIL:
	//   4 - base existe e esta protegida contra escrita
	//  16 - diretorio não existe
	//	32 - diretorio esta protegido contra escrita
	//  52
	
	if ($retSTS > 3) {
		// Sem condicoes de tentar criar a base
		$returnCode = ($retSTS & 52);
	} else {
		if (($retSTS & 1) == 0) {
			// M/F da base existe
			if ($sobrescreve == false) {
				// Se usuario nao quer sobrescrever obedece
				$returnCode = 64;
			} else {
				// Se usuario deixa sobrescrever manda ver
				$returnCode = 0;
			}
		} else {
			// M/F da base não existe, ta liberado
			$returnCode = 0;
		}
	}
	
	// Tenta criar a base de dados
	// Normaliza o nome da base de dados a operar
	$basename=basename($nomebase);		// Obtem o nome da base
	$database = normDatabase($nomebase);
	
	if (strlen($basename) == 0) {
		$returnCode = 64;
	}
	
	if ($returnCode == 0) {
		// Cria base de dados solicitada
		unset($resposta);
		exec("$cisisDir/mx null \"proc='<1 0>criado com webisis</1>'\" create=" . $database . " count=0 \"fst=1 0 v1/\" fullinv=" . $database, $resposta, $retorno);
		// Prepara valores de retorno
		if (isset($resposta[1])) {
			// Se teve retorno contem mensagem de erro
			echo "$resposta[1]";
		}
		if ($retorno != 0) {
			$returnCode |= 128;
		}
	}
	return $returnCode;
}

/*
 * Funcao: SEARCH
 * Parametros:
 *	1 - caminho e nome da base de dados
 *	2 - expression search
 *	3 - array para alista de resultados
 * Retorno:
 *	bit mapped:		7 6 5 4 3 2 1 0
 *				| | | | | | | |
 *				| | | | | | | +-- M/F not found			(N/R)
 *				| | | | | | +---- I/F not found
 *				| | | | | +------ M/F read only			(N/R)
 *				| | | | +-------- I/F read only			(N/R)
 *				| | | +---------- Directory not found
 *				| | +------------ Directory read only	(N/R)
 *				| +-------------- invalid expression
 *				+---------------- Undeterminated error
 *				  0- Ok
 *				  2- I/F not found
 *				 16- Directory not found
 *				 64- MFN out of range (MFN > Max)
 *				128- Error reading register
 * Operacao:
 *	1 - toma status do invertido
 *	2 - testa se a expressao é nula
 *	3 - nao sendo efetua a busca
 *	4 - monta o array com a lista de mfns
 */
function SEARCH ($nomebase, $expressao, &$BUFFER) {
	// Inicia variaveis da funcao READ
	global $cisisDir, $cisisTab, $cisisGiz;
	$returnCode = 0;
	$Control = array();
	
	// Testa se deve ler o registro de controle
	$retSTS = STATUS($nomebase, $Control);
	// retSTS = 2, 16, 64 ou 128 nem tenta ler e retorna com o status recebido
	
	//$retSTS &= 210;	//	Bits relevantes apenas (11010010)
	//	TRY:
	//    0 - invertido existe
	//    8 - invertido existe e esta protegido contra escrita
	//	FAIL:
	//    2 - invertido não existe
	//   16 - diretorio não existe
	//	 64 - nome nao indicado
	//	128 - Erro não especifico
	//  210
	
	$z = 0;
	$tmp = $retSTS & bindec('11010010');
	if ($tmp != 0) {
		// Condicoes negativas para realizar a pesquisa
		$returnCode = $tmp;
	} else {
		// Existem condicoes de efetuar a busca
		if (strlen($expressao) == 0) {
			// Expressao nula nao pode ser executada
			$returnCode |= 64;
		} else {
			// Expressao em condicoes de execucao
			// Normaliza o nome da base de dados a operar
			$database = normDatabase($nomebase);
			
			// Executa a busca segundo expressao
			unset($rb_buffer);
			// 20210523 - Adicionado o tratamento de UPPER case na expressao de busca
			// actab=$cisisTab/acans.tab uctab=$cisisTab/ucans.tab	
			exec("$cisisDir/mx " . $database . " btell=0 \"" . $expressao . "\" pft=mfn/ now", $rd_buffer, $retorno);
			if ($retorno != 0) {
				$returnCode |= 128;
			} else {
				$z = count($rd_buffer);						// numero de resultados da busca
				// Cada entrada do array eh um MFN
				if ($z > 0) {
					for($i = 0; $i < $z; $i++) {
						$BUFFER[$i] = (int) $rd_buffer[$i];
					}
				}
			}
		}
	}
	return $returnCode;
}

/*
 * Funcao: DELETE
 * Parametros:
 *	1 - caminho e nome da base de dados
 *	2 - numero do registro a ser deletado (MFN)
 * Retorno:
 *	bit mapped: 7 6 5 4 3 2 1 0
 *				| | | | | | | |
 *				| | | | | | | +-- M/F not found
 *				| | | | | | +---- I/F not found			(N/R)
 *				| | | | | +------ M/F read only
 *				| | | | +-------- I/F read only			(N/R)
 *				| | | +---------- Directory not found
 *				| | +------------ Directory read only
 *				| +-------------- invalid MFN			-+- I/F update error
 *				+---------------- unspecified error		-+
 *				  0- Ok
 *				  1- M/F not found
 *				  4- M/F read-only
 *				 16- Directory not found
 *				 32- Directory read-only
 *				 64- MFN out of range (1 > MFN >= nxtmfn)
 *				128- Error reading register
 *				192- I/F update error
 * Operacao:
 *	1 - verifica se existe a base a operar
 *	2 - verifica se MFN é valido (0 < MFN < nxtmfn)
 *	3 - apaga o registro logicamente
 */
function DELETE ($nomebase, $registro) {
	// Inicia variaveis da funcao DELETE
	global $cisisDir, $cisisTab, $cisisGiz;
	$returnCode = 0;
	$Control = array();
	
	// Testa se deve ler o registro de controle
	$retSTS = STATUS($nomebase, $Control);
	// retSTS = 1, 4, 16 ou 128 nem tenta apagar e retorna com o status recebido
	// retSTS = 2, 8 ou 32 nao atualiza o invertido
	
	//$retSTS &= 213;	//	Bits relevantes apenas (11010101)
	//	TRY:
	//    0 - invertido existe
	//    8 - invertido existe e esta protegida contra escrita
	//	FAIL:
	//    1 - base não existe
	//	  4 - base read-only
	//   16 - diretorio não existe
	//	 64 - MFN fora de faixa
	//	128 - Erro de leitura
	//  213
	$maxmfn = $Control["nxtmfn"];
	$tmp = $retSTS & bindec('11010101');
	if ($tmp != 0) {
		// Condicoes negativas para realizar a delecao
		$returnCode = $tmp;
	} else {
		// Garante que 0 < MFN < nxtmfn (MFN esta na base)
		if (($Control["nxtmfn"] <= $registro) || ($registro == 0)) {
			// MFN para delecao fora da faixa
			$returnCode |= 64;
		} else {
			// Base da condicoes de execucao
			// Normaliza o nome da base de dados a operar
			$pathbase=dirname($nomebase);		// Obtem o path da base
			$basename=basename($nomebase);		// Obtem o nome da base
			$database = normDatabase($nomebase);
			
			// Executa a busca segundo expressao
			unset($rd_buffer);
			exec("$cisisDir/mx " . $database . " \"from=" . $registro . "\" \"proc='d.'\" copy=\"" . $database . "\" count=1 -all now",$rd_buffer, $retorno);
			if ($retorno != 0) {
				$returnCode |= 128;
			}
			
			// Atualiza invertido
			unset($rd_buffer);
			exec("$cisisDir/ifupd full " . $database . " from=" . $registro . " \"fst=@" . $database . ".fst\"  actab=$cisisTab/acans.tab uctab=$cisisTab/ucans.tab",$rd_buffer, $retorno);
			if ($retorno != 0) {
				$returnCode |= 128+64;
			}
		}
	}
	return $returnCode;
}

/*
 * Funcao: READ
 * Parametros:
 *	1 - caminho e nome da base de dados
 *	2 - Número do registro a ser lido (MFN)
 *	3 - array {bidimensional} para o registro lido (conforme o leiaute abaixo)
 *			$buffer["vsts"][0]=> booleano indicando registro ativo (true) / apagado (false)
 *			$buffer["v44"][0] => "Methodology of plant eco-physiology: proceedings of the Montpellier Symposium"
 *			$buffer["v50"][0] => "Incl. bibl."
 *			$buffer["v69"][0] => "Paper on: <hygrometers><plant transpiration><moisture><water balance>"
 *			$buffer["v26"][0] => "^c1965"
 *			$buffer["v30"][0] => "^ap. 247-257^billus."
 *			$buffer["v70"][0] => "Grieve, B.J."
 *			$buffer["v70"][1] => "Went, F.W."
 *			$buffer["v24"][0] => "<An> Electric hygrometer apparatus for measuring water-vapour ... in the field"
 *	4 - Variavel do tipo int para receber a quantidade de campos lidos do registro (incluindo o Status do registro)
 * Retorno:
 *	bit mapped:	7 6 5 4 3 2 1 0
 *			| | | | | | | |
 *			| | | | | | | +-- M/F not found
 *			| | | | | | +---- I/F not found			(N/R)
 *			| | | | | +------ M/F read only			(N/R)
 *			| | | | +-------- I/F read only			(N/R)
 *			| | | +---------- Directory not found
 *			| | +------------ Directory read only		(N/R)
 *			| +-------------- MFN out of range		-+- Null base name
 *			+---------------- Error reading register	-+
 *				  0- Ok
 *				  1- M/F not found
 *				 16- Directory not found
 *				 64- MFN out of range (MFN > Max)
 *				128- Error reading register
 *				192- Null base name
 * Operacao:
 *	1 - toma status da base de dados
 *	2 - Se MFN=0 retona com STATUS
 *	3 - testa se o MFN está na faixa válida
 *	4 - tenta ler o registro
 *	5 - monta o array bidimensional com os dados dos campos do registro
 */
function READ ($nomebase, $registro, &$BUFFER, &$FIELDS) {
	// Inicia variaveis da funcao READ
	global $cisisDir, $cisisTab, $cisisGiz;
	$returnCode = 0;
	$Control = array();
			
	// Testa se deve ler o registro de controle
	$retSTS = STATUS($nomebase, $Control);
	// retSTS = 0, 2, 4, 8 condicoes previas liberadas para ler a base
	// retSTS = 1 ou > 4 nem tenta ler e retorna com o status recebido

	//$retSTS &= 209;	//	Bits relevantes apenas (11010001)
	//	TRY:
	//    0 - base existe
	//	  2 - I/F não existe
	//    4 - M/F esta protegido contra escrita
	//	  8 - I/F esta protegido contra escrita
	//	 32 - Directory R/O
	//	FAIL:
	//    1 - base não existe
	//   16 - diretorio não existe
	//	 64 - nome nao especificado
	//	128 - Erro de leitura
	
	//$x = $Control["nxtmfn"];
	if (($retSTS & decbin(11010001)) == 0) {
		if ($registro == 0) {
			// Solicitou Control Register
			$returnCode = $retSTS;
			$BUFFER = $Control;
		} else {
			// Solicitou registro de dados
			if ($registro >= $Control["nxtmfn"]) {
				// Se esta fora da faixa de existentes retorna com erro
				$returnCode |= 64;
			} else {
				// Registro dentro da faixa valida
				// Normaliza o nome da base de dados a operar
				$pathbase=dirname($nomebase);		// Obtem o path da base
				$basename=basename($nomebase);		// Obtem o nome da base
				$database = normDatabase($nomebase);
				
				// Cria le registro solicitado da base de dados indicada
				unset($rd_buffer);
				exec("$cisisDir/mx " . $database . " from=" .$registro . " count=1 now", $rd_buffer, $retorno);
				if ($retorno != 0) {
					$returnCode |= 128;
				} else {
					$z=count($rd_buffer);						// numero de entradas de diretorio lidas no registro
					
					// Monta o status do registro lido
					if (strrpos($rd_buffer[0], 'DELETED') != 0) { $BUFFER["vsts"][0] = FALSE; } else { $BUFFER["vsts"][0] = TRUE; }
					
					// Campo a campo obtem o dado do campo ($val) e o campo lido ($idx)
					for( $i=0; $i < $z; $i++) {
						// Retira espacos dos extremos da string, retira as aspas extremas da string, troca < e > por entidades HTML
						$val = preg_replace("/>/","&gt;",preg_replace("/</","&lt;",substr(substr(trim(substr((string) $rd_buffer[$i],4,strlen((string) $rd_buffer[$i])-4)),0,-1),1)));
						// Retira espacos dos extremos da string
						$idx = trim(substr((string) $rd_buffer[$i],0,4));
						if ( (int) $idx != 0 ) {
							// Eh campo de dado valido
							$idx = "v" . $idx;				// Prefixa com a notacao de campo do CDS/ISIS
							if (isset($BUFFER[$idx][0])) {
								// Jah existe uma ocorrencia desse campo coloca dado na próxima
								if (isset($occ[$idx])) {
									// Jah nao eh a primeira ocorrencia avanca contador de ocorrencia
									++$occ[$idx];
								} else {
									$occ[$idx]= 1;
								}
								// Coloca dado da ocorrencia no array
								$BUFFER[$idx][$occ[$idx]] = $val;
							} else {
								// Esta eh a primeira ocorrencia do campo
								$BUFFER[$idx][0] = $val;
								$occ[$idx] = 0;
							}
						}
					}
				}
			}
		}
	} else {
	$returnCode = $retSTS;
	}
	$FIELDS = count($BUFFER);
	return $returnCode;
}

/* Funcao: UPDATE
 * Parametros:
 *	1 - caminho e nome da base de dados
 *	2 - numero do registro a ser deletado (MFN)
 *  3 - Array com os dados a serem gravados (conforme leiaute abaixo)
 *		array (
 *			["v44"][0] => "Methodology of plant eco-physiology: proceedings of the Montpellier Symposium"
 *			["v50"][0] => "Incl. bibl."
 *			["v69"][0] => "Paper on: <hygrometers><plant transpiration><moisture><water balance>"
 *			["v26"][0] => "^c1965"
 *			["v30"][0] => "^ap. 247-257^billus."
 *			["v70"][0] => "Grieve, B.J."
 *			["v70"][1] => "Went, F.W."
 *			["v24"][0] => "<An> Electric hygrometer apparatus for measuring water-vapour loss from plants in the field"
 *		)
 *
 * Retorno:
 *	bit mapped: 7 6 5 4 3 2 1 0
 *				| | | | | | | |
 *				| | | | | | | +-- M/F not found
 *				| | | | | | +---- I/F not found
 *				| | | | | +------ M/F read only
 *				| | | | +-------- I/F read only
 *				| | | +---------- 
 *				| | +------------ Error Indexing
 *				| +-------------- Error Writing
 *				+---------------- Register blocked
 *				  0- Ok
 *				  1- M/F not found
 *				  2- I/F not found
 *				  4- M/F read-only
 *				  8- I/F read-only
 *				 16- 
 *				 32- Error indexing
 *				 64- Error writing
 *				128- Registro bloqueado para gravacao
 * Operacao:
 *	1 - Monta a PROC que reescreve dados nos campos do registro
 *		1.1 - Monta a serie de deleções de campos do registro
 *		1.2 - Monta as adicoes de campos do registro
 *	2 - Monta o arquivo de execucao em lote para o MX
 *		2.1 - Monta a parte independente do registro ser editado ou novo
 *		2.2 - Monta a parte de edicao de registro especifico ou append de novo registro
 *	3 - Inicializa o controle de colisao de escrita
 *	4 - Normaliza o numero do registro (numerico ou vazio para novo reg)
 *	5 - Garante a existencia do arquivo de controle de bloqueio (se não existir cria um vazio)
 *	6 - Se o arquivo foi alterado até um segundo atras temporiza 2 segundos
 *	7 - Monta  conteúdo da trava (USER; BASE; REG; TIME)
 *	8 - Procura uma trava com os mesmos base+registro, se achar temporiza e retenta mais uma vez
 *	9 - Se nao tem trava presente para o par base+reg, grava a trava montada
 *	10- Se pode travar para o par, efeuta a gravação do registro e atualizacao do invertido
 *		10.1- Efetua a gravacao
 *		10.2- Se Nok sinaliza erro de gravacao (codigo 64)
 *		10.3- Se Ok efetua a atualizacao do invertido
 *		10.4- Efeuta a atualizacao do invertido
 *		10.5- Se Nok sinaliza erro de inversao (codigo 32)
 *		10.6- Se Ok prossegue normal
 *	11- Elimina a trava desta operacao no arquivo de controle de bloqueio
 *	12- Se tem trava previa sinaliza colisao (codigo 128)
 */
function UPDATE ($nomebase, $register, &$wr_dtbuff) {
	// Inicia variaveis da funcao UPDATE
	global $cisisDir, $cisisTab, $cisisGiz, $filebloq, $usuario;
	$returnCode = 0;
	$controle = array();
	
	// Determina numero de registro a gravar ou EMPTY se for novo 
	$REGISTER = (($register == "NEW") || ($register == 0)) ? "" : (int) $register;

	// Normaliza o nome da base de dados a operar
	$pathbase=dirname($nomebase);		// Obtem o path da base
	$basename=basename($nomebase);		// Obtem o nome da base
	$database = normDatabase($nomebase);
	
	// toma o status da base
	$retSTS = STATUS ($database, $controle);
	// Verifica se M/F e I/F são gravaveis (and com 63)
	$tmp = $retSTS & bindec('00111111');
	if ($tmp == 0) {
		
		// Monta o arquivo PROC da operacao
		$filename[$usuario]=$usuario . ".prc";				// $filename	do usuario desta sessao
		$fileproc[$usuario]=$usuario . ".prc";				// $filename	do usuario desta sessao
		$fh[$usuario] = fopen($filename[$usuario], 'w');	// $fh			do usuario desta sessao
		
		// Monta as delecoes de campos
		fwrite($fh[$usuario], "'d*',");
		fwrite($fh[$usuario], "\n");
		// Monta as adicoes de campos
		foreach($wr_dtbuff as $idx => $arr) {
			foreach($arr as $occ => $value) {
				$cpo = (int) substr($idx,1);
				if ($cpo == 0) { continue; }
				// preg_replace("/[\r]/", "", $arr[$occ]); <= Eliminar retorno de carro entrado no "textarea"
				if ($arr[$occ] != "") {	fwrite($fh[$usuario], "'<$cpo 0>','" . preg_replace("/[\r\n]/", "", $arr[$occ]) . "','</$cpo>'\n"); }
			}
		}
		fclose($fh[$usuario]);
	
		// Monta o arquivo de controle da operacao
		$filename[$usuario]=$usuario . ".in";							// $filename	desta sessao
		$fh[$usuario] = fopen($filename[$usuario], 'w');				// $fh			desta sessao
		fwrite($fh[$usuario], "db=$database\n");						// Base de dados
		fwrite($fh[$usuario], "count=1\n");								// Quantidade de registros
		fwrite($fh[$usuario], "proc=@" . $fileproc[$usuario] . "\n");	// Adição de dados nos campos
		fwrite($fh[$usuario], "proc='s'\n");							// Ordena os campos no registro
		// Determina se appenda ou regrava registro
		if ($REGISTER == "") {
			fwrite($fh[$usuario], "append=$database\n");
		} else {
			fwrite($fh[$usuario], "from=$register\n");
			fwrite($fh[$usuario], "copy=$database\n");
		}
		fwrite($fh[$usuario], "-all\nnow\n");							// nao verboso (-all) e imediato (now)
		fclose($fh[$usuario]);
		
		// Inicia o controle de colisao
		// Garante existencia do arquivo de controle de bloqueio
		if (!file_exists($filebloq)) {
			$fh = fopen($filebloq, 'w');
			fclose($fh);
		}
		
		// Preparo para gravação, agora é hora de criar os mecanismos de bloqueio contra  escrita multipla
		$momento = time();						// Toma a hora atual
		$lastbloq = fileatime($filebloq);		// Toma a hora do arquivo de controle de bloqueio
		if ($momento - $lastbloq <= 1 ) {		// Verifica se alguem acabouy de operar o arquivo
			sleep(2);							// Espera um pouco alguém andou por aqui
		}
		// Monta a trava de bloqueio
		$momento = time();
		$trava = $usuario . ";" . $database . ";" . $REGISTER . ";" . time() . "";	// Trava de bloqueio
		for ($retry = 0; $retry <= 1; $retry++) {
			// Abre o controle de bloqueio
			$FH = fopen($filebloq, 'r+');
			$lntrava = 0;
			while (($data = fgetcsv($FH,0,";")) !== FALSE) {
				if (($data[1] == $database) && ($data[2] == $register)) {
					$bloq=$lntrava;
					break;
				}
				$lntrava++;
			}
			fclose($FH);
			
			// Se nao houver bloqueio previo prossegue, senao tenta novamente apos dois segundos
			if (!isset($bloq)) {
				break;
			} else {
				sleep(2);
			}
		}
		
		// Estando realmente liberado toma para si gravando a trava
		if (!isset($bloq)) {
			$FH = fopen($filebloq, 'a');
			fwrite($FH, $trava . "\n");
			fclose($FH);
		}
		
		// Se travou para esta operação, faz a gravacao e a atualizacao do invertido
		if (!isset($bloq)) {
			// Grava
			$retorno = 0;
			unset($rd_buffer);
			exec("$cisisDir/mx in=" . $usuario . ".in", $rd_buffer,  $retorno);
			// Se voltou com retorno != 0 deu merda avalia
			if ($retorno == 0) {
				if (file_exists($database . ".fst"))  {
					// Aguarda um pouco e Inverte
					unset($rd_buffer);
					exec("$cisisDir/ifupd full " . $database . " \"fst=@" . $database . ".fst\" actab=$cisisTab/acans.tab uctab=$cisisTab/ucans.tab", $rd_buffer, $retorno);
					if ($retorno != 0) {
						$returnCode |= 32;		//echo "Inversão falhou!<br>\n";
					}
				}
			} else {
				$returnCode |= 64;				// Ocorreu erro ao gravar
			}
			
			// Operacao concluida - Elimina trava da linha $lntrava
			$arr = file($filebloq);		// Lê todo o arquivo para um vetor
			unset($arr[($lntrava)]);	// Elininando a linha
			
			// Reescrevendo o arquivo
			file_put_contents($filebloq, $arr);
		} else {
			$returnCode |= 128;
		}
	} else {
		// Nao tinha condicoes minimas de escrever na base de dados por algum motivo
		$returnCode = $retSTS & bindec('00001111');
	}
	return $returnCode;
}
?>
