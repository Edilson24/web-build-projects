<?php
class Database {
    private static $host = '127.0.0.1';
    private static $db   = 'sistema_gestao_db';
    private static $user = 'root';
    private static $pass = 'root';
    private static $instance = null;

    public static function getConnection() {
        if (!self::$instance) {
            try {
                self::$instance = new PDO(
                    "mysql:host=" . self::$host . ";dbname=" . self::$db . ";charset=utf8mb4",
                    self::$user,
                    self::$pass,
                    [
                        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                        PDO::ATTR_EMULATE_PREPARES => false
                    ]
                );
            } catch (PDOException $e) {
                error_log("[" . date('Y-m-d H:i:s') . "] DB Connection Error: " . $e->getMessage() . "\n", 3, __DIR__ . '/../logs/error.log');
                die("Erro interno ao conectar ao banco de dados.");
            }
        }
        return self::$instance;
    }
}