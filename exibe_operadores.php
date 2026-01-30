<?php
// --------------------------------------------
// CONFIGURACAO DE CONEXAO COM O BANCO DE DADOS
// --------------------------------------------

// Dados de conexao com o banco MariaDB
$host    = 'localhost';     // Endereco do servidor (localhost ou IP)
$dbname  = 'webisis';       // Nome do banco de dados
$user    = 'adm_WebISIS';	  // Usuario do banco de dados
$pass    = 'U55_r3l1@nt';   // Senha do usuario
$charset = 'latin1';        // Conjunto de caracteres usado na tabela

// DSN = Data Source Name (string de conexao)
$dsn = "mysql:host=$host;dbname=$dbname;charset=$charset";

// Opcoes adicionais para seguranca e desempenho
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Lançar excecao em caso de erro
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Retornar resultados como array associativo
    PDO::ATTR_EMULATE_PREPARES   => false,                  // Usar prepared statements reais
];

echo "<!doctype html>";
echo "<html>";
echo "<head>";
echo "<title>Lista Operadores</title>";
echo "<meta charset=\"iso-8859-1\">";
echo "</head>";
echo "<body>";

// --------------------------------------------
// TENTATIVA DE CONEXAO COM O BANCO DE DADOS
// --------------------------------------------

try {
    // Criando uma nova conexao PDO
    $pdo = new PDO($dsn, $user, $pass, $options);
    echo "<h2>Conexao realizada com sucesso!</h2>";
} catch (PDOException $e) {
    // Em caso de erro, mostra a mensagem e encerra
    echo "Erro ao conectar ao banco de dados: " . $e->getMessage();
    exit;
}

// --------------------------------------------
// CONSULTA A TABELA 'operadores'
// --------------------------------------------

try {
    // Comando SQL para selecionar todos os registros da tabela
    $sql = "SELECT * FROM operadores";

    // Executa a consulta
    $stmt = $pdo->query($sql);

    // Verifica se ha resultados
    if ($stmt->rowCount() > 0) {
        echo "<h3>Lista de Operadores</h3>";
        echo "<table border='1' cellpadding='5' cellspacing='0'>";
        echo "<tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Senha</th>
                <th>Email</th>
                <th>Fone</th>
                <th>Nivel</th>
                <th>Pergunta Secreta</th>
                <th>Resposta Secreta</th>
              </tr>";

        // Percorre cada linha de resultado
        foreach ($stmt as $linha) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($linha['idOperador'])      . "</td>";
            echo "<td>" . htmlspecialchars($linha['nome_Operador'])   . "</td>";
            echo "<td>" . htmlspecialchars($linha['senhaOperador'])   . "</td>";
            echo "<td>" . htmlspecialchars($linha['emailOperador'])   . "</td>";
            echo "<td>" . htmlspecialchars($linha['fone_Operador'])   . "</td>";
            echo "<td>" . htmlspecialchars($linha['nivelOperador'])   . "</td>";
            echo "<td>" . htmlspecialchars($linha['pergSecreta'])     . "</td>";
            echo "<td>" . htmlspecialchars($linha['respSecreta'])     . "</td>";
            echo "</tr>";
        }

        echo "</table>";
	echo "</body>";
	echo "</html>";
    } else {
        echo "Nenhum operador encontrado.";
	echo "</body>";
	echo "</html>";
    }
} catch (PDOException $e) {
    echo "Erro ao consultar a tabela: " . $e->getMessage();
    echo "</body>";
    echo "</html>";
    exit;
}
?>

