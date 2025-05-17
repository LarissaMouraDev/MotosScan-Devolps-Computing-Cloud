 <?php
 $mysqli = new mysqli("saes-sql", "viniuser", "vini123", "saes-db");
 if ($mysqli->connect_error) {
 die("Erro na conexão: " . $mysqli->connect_error);
 }
 echo "Conectado com sucesso ao Banco de Dados  saes-db!";
 ?>