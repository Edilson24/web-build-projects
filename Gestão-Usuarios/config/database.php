<?php
/**
 * Conexão com a Base de Dados MySQL via PDO
 */

class Database {
    private static string $host = 'localhost';
    private static string $port = '3306';
    private static string $dbname = 'sistema_gestao_db';
    private static string $username = 'root'; 
    private static string $password = 'root';     
    private static ?PDO $instance = null;

    /**
     * Retorna uma instância única da conexão PDO (Pattern Singleton)
     */
    public static function getConnection(): PDO {
        if (self::$instance === null) {
            try {
                $dsn = "mysql:host=" . self::$host . ";port=" . self::$port . ";dbname=" . self::$dbname . ";charset=utf8mb4";
                
                $options = [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ];

                self::$instance = new PDO($dsn, self::$username, self::$password, $options);
            } catch (PDOException $e) {
                // Regista o erro no log interno do sistema
                self::logError($e->getMessage());
                
                // Exibe mensagem amigável ao utilizador sem expor dados técnicos
                die("Erro interno ao conectar com a base de dados. Por favor, tente novamente mais tarde.");
            }
        }

        return self::$instance;
    }

    /**
     * Regista mensagens de erro no ficheiro logs/error.log
     */
    public static function logError(string $message): void {
        $logDir = __DIR__ . '/../logs';
        if (!is_dir($logDir)) {
            mkdir($logDir, 0777, true);
        }

        $logFile = $logDir . '/error.log';
        $timestamp = date('Y-m-d H:i:s');
        $formattedMessage = "[{$timestamp}] " . $message . PHP_EOL;

        file_put_contents($logFile, $formattedMessage, FILE_APPEND);
    }
}