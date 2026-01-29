<?php

// Funcao de imprimir valor em base 2
// Argumentos de chamada
//  1: valor a ser impresso em base binaria
function showBinary ( $value ) {
	// servico da funcao
	$returnCode = substr('0000000' . decbin($value), -8);
	return $returnCode;
}

// Funcao de anotar em Log de Operacao
// Argumentos de chamada
//  1: Nome do arquivo fonte PHP que emitiu a chamada
//  2: Mensagem a ser gravada no Log
function fnLogOper ( $filephp, $logmsg ) {

  $fhLOG = fopen( LOG_OPR, 'a' );
  if ( $fhLOG == false ) die( "Problemas com a criacao/abertura do arquivo " . LOG_OPR . " - " . $filephp );
  $texto = date( 'D\-W\(z\) Y/m/d H:i:s 0', $_SERVER['REQUEST_TIME'] ) . " " . $logmsg . "\n";
  fwrite( $fhLOG, $texto );
  fclose( $fhLOG );
}

// Funcao de anotar em Log de Seguranca
// Argumentos de chamada
//  1: Nome do arquivo fonte PHP que emitiu a chamada
//  2: Mensagem a ser gravada no Log
function fnLogSegr (  $filephp, $logmsg ) {

	$fhLOGS = fopen( LOG_SEG, 'a' );
	if ( $fhLOGS == false ) die( "Problemas com a criacao/abertura do arquivo LOG_SEG - " . $filephp );
	$texto = date( 'D\-W\(z\) Y/m/d H:i:s 0', $_SERVER['REQUEST_TIME'] ) . " " . $logmsg . "\n";
	fwrite( $fhLOGS, $texto );
	fclose( $fhLOGS );
}

?>
