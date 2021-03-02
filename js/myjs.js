// Fun��o para alertar que o Login Name n�o est� dispon�vel
function inv_login_name(){
	alert("       Nome de login j� existe!\nEscolha outro nome para fazer login.");
	window.location.href = "quick.php";
}

// Funcao para abrir um POP-UP contendo o HTML informado no par�metro
function abrir(URL) {

  var width = 150;
  var height = 250;

  var left = 99;
  var top = 99;

  window.open(URL,'janela', 'width='+width+', height='+height+', top='+top+', left='+left+', scrollbars=yes, status=no, toolbar=no, location=no, directories=no, menubar=no, resizable=no, fullscreen=no');

}

// Fun��o para emitir mensagems temporizadas
// Codigo obtido em: http://blog.conradosaud.com.br/artigo/38
function mostrarDialogo(mensagem, tipo, tempo){
    
    // se houver outro alert desse sendo exibido, cancela essa requisi��o
    if($("#message").is(":visible")){
        return false;
    }

    // se n�o setar o tempo, o padr�o � 2 segundos
    if(!tempo){
        var tempo = 2000;
    }

    // se n�o setar o tipo, o padr�o � alert-info
    if(!tipo){
        var tipo = "info";
    }

    // monta o css da mensagem para que fique flutuando na frente de todos elementos da p�gina
    var cssMessage = "display: block; position: fixed; top: 0; left: 20%; right: 20%; width: 60%; padding-top: 10px; z-index: 9999";
    var cssInner = "margin: 0 auto; box-shadow: 1px 1px 5px black;";

    // monta o html da mensagem com Bootstrap
    var dialogo = "";
    dialogo += '<div id="message" style="'+cssMessage+'">';
    dialogo += '    <div class="alert alert-'+tipo+' alert-dismissable" style="'+cssInner+'">';
    dialogo += '    <a href="#" class="close" data-dismiss="alert" aria-label="close">�</a>';
    dialogo +=          mensagem;
    dialogo += '    </div>';
    dialogo += '</div>';

    // adiciona ao body a mensagem com o efeito de fade
    $("body").append(dialogo);
    $("#message").hide();
    $("#message").fadeIn(200);

    // contador de tempo para a mensagem sumir
    setTimeout(function() {
        $('#message').fadeOut(300, function(){
            $(this).remove();
        });
    }, tempo);  // milliseconds

}
