<html lang="pt-br">
<head>
  <title>Pesquisa Base <?php echo strtoupper(trim($basename));?> | <?php echo APLICACAO;?> [QAPLA]</title>
  <meta charset="ISO-8859-1" />
  <link rel="shortcut icon" href="/images/fqapla.ico" />
  <!-- Meta tags para fins de SEO -->
  <meta name="robots" content="noindex, nofollow" />
  <meta name="author" content="QAPLA Comercio e Servicos de Informatica Ltda-ME" />
  <meta name="keywords" content="Editor de bases, CDS/ISIS, Bases de dados textuais" />
  <meta name="description" content="Sistema Web (64 bits) para manutencao de dados em bases CDS/ISIS" />
  <!-- Estilizacao e responsividade -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <!-- Para uso da nova versao do fontAwesome -->
  <script src="https://kit.fontawesome.com/580c932869.js" crossorigin="anonymous"></script>
  <!-- Carrega font especifica a ser utilizada -->
  <link href="https://fonts.googleapis.com/css2?family=Oxygen:wght@300;400;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="/css/estilo.css" />
</head>

<body> <!-- resul.php -->
  <!-- Cabecalho das paginas abrigando logo marca e menu de funcoes -->
  <header>
    <div class="container">
      <div class="LogoMarca">
        <h1>| <?php echo APLICACAO;?></h1>
      </div><!-- LogoMarca -->
      <div id="menu">
        <!-- Controle de exibicao de menu em dispositivos mobile -->
        <input type="checkbox" id="bt_menu" />
        <label for="bt_menu"><i class="fas fa-bars"></i></label>
        <h1>| <?php echo APLICACAO;?></h1>
        <!-- Menu de funcoes -->
        <nav class="menu">
          <ul>
            <li><a href="/phps/menu.php">Home</a></li>
            <!--<li><a href="#">Editar Base</a></li>-->
            <li><p>Edita <?php echo strtoupper(trim($basename));?></p></li>
            <li><a href="#">Relat&oacute;rios</a>
              <ul>
                <li><a href="#">Tipo I</a></li>
                <li><a href="#">Tipo II</a></li>
                <li><a href="#">Tipo III</a></li>
                <li><a href="#">Tipo IV</a></li>
                <li><a href="#">Tipo V</a></li>
                <li><a href="#">Tipo VI</a></li>
              </ul>
            </li>
            <li><a href="#">Ferramentas</a>
              <ul>
                <li><a href="#">Processar</a></li>
                <li><a href="#">Publicar</a></li>
                <li><a href="#">Exportar</a></li>
                <li><a href="#">Importar</a></li>
              </ul>
            </li>
          </ul>
        </nav><!-- menu -->
      </div><!-- menu -->
      <div class="clear"></div>
    </div><!-- container -->
  </header>
  <!-- Formulario de edicao de campos de registro -->
  <section>
    <div class="container">
      <form method="post" action="#">
        <!-- Identificacao de base de dados e registro em edicao -->
        <div class="w50">
          <div class="w50Mod">
            <h2 class="pri">Base de dados: </h2>
          </div> <!-- w50Mod -->
          <div class="w50Mod">
            <h2 class="seg"><?php echo "$basename"; ?></h2>
          </div> <!-- w50Mod -->
        </div><!-- NomBase -->
        <div class="w50">
          <h2 class="search">Express&atilde;o: <span style="color: black;"><?php echo $buscar; ?></span></h2>
        </div><!-- RegEdit -->
        <div class="clear"></div>
        <!-- [:INI:] Planilha de edicao de campos -->
        <div class="campos">
          <fieldset><legend>&nbsp;Resultados:&nbsp;</legend>
            <div class="w100">
              <hr><?php
              $retorno="";
              $com_diac = "ÐÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýýþÿ";
              $sem_diac = "DAAAAAAACEEEEIIIINOOOOOOUUUUYBSaaaaaaaceeeeiiiionoooooouuuuyyby";
              $Buscar = strtoupper(trim(strtr($buscar, $com_diac, $sem_diac)));
              //$buscar = strtoupper(trim($Buscar));
              //echo "$cisisDir/mx " . $BASE . ' "btell=0" "lw=0" now "' . $buscar . '" "pft=@' . $resultad . '"';
              //die();
              exec("$cisisDir/mx " . $BASE . ' "btell=0" "lw=0" now "' . $Buscar . '" "pft=@' . $resultad . '"', $resposta, $retorno);
              $qtde = count($resposta);
              if ($qtde > 0) {
                for($i = 0; $i < $qtde; $i++){
                  echo $resposta[$i] . "\n";
                }
              }
?>
            </div><!-- w100 -->
          </fieldset>
        </div><!-- campos -->
        <!-- [:FIM:] Planilha de edicao de campos -->
        <!-- Controles do formulario -->
        <div class="controles">
          <div class="functions"><?php
            if ($qtde == 0) {echo "N&atilde;o h&aacute; registros que atendam esta busca!";}
            elseif ($qtde == 1) {echo "Um &uacute;nico registro atende esta busca!";}
            //else {echo "Resultados da busca: $qtde";}
            else {echo "$qtde registros atendem esta busca!";}
?>
            <!-- Resultados da busca: <?php echo $qtde;?> -->
          </div><!-- functions -->
          <div class="search">
            <input  type="text"   name="expressao" value="<?=$buscar?>" size="58">
            <button type="submit" name="action"    value="search">procurar</button>
          </div><!-- search -->
          <div class="nav"><?php
            $dbstatus = STATUS($BASE, $controlreg);
            if (($controlreg['nxtmfn'] - 1) == 0) {echo "Base sem qualquer registro!";}
            elseif (($controlreg['nxtmfn'] - 1) == 1) {echo "Base com apenas um registro!";}
            else {echo "Total de registros na base" . ($controlreg['nxtmfn'] - 1);}
            //echo "Total de registros na base: " . ($controlreg['nxtmfn'] - 1);
?>
          </div><!-- nav -->
          <div class="clear"></div>
        </div><!-- controles -->
      </form>
    </div>
  </section><!-- container | Formulário de edicão de campos de registro -->
  <!-- Rodapé da página -->
  <footer class="container">
    <h4 class="info">QAPLA CSI - CNPJ 05.129.080/0001-01 - qapla@qaplaweb.com.br - www.qapla.com.br</h4>
    <h3>Todos os direitos reservados -- QAPLA <i class="far fa-registered"></i></h3>
  </footer>
</body>
</html>
<?php die(); ?>
