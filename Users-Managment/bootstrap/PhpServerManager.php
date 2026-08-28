<?php
class PhpServerManager {
    public static function start($host = '127.0.0.1', $startPort = 8000) {
        $port = $startPort;
        while (self::isPortInUse($host, $port)) {
            $port++;
        }
        $url = "http://{$host}:{$port}";
        echo "Servidor rodando em: {$url}\n";

        // Tentativa de abertura automatica no navegador
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            pclose(popen("start {$url}", "r"));
        } else {
            exec("xdg-open {$url} > /dev/null 2>&1 &");
        }

        passthru("php -S {$host}:{$port} -t public");
    }

    private static function isPortInUse($host, $port) {
        $connection = @fsockopen($host, $port, $errno, $errstr, 1);
        if (is_resource($connection)) {
            fclose($connection);
            return true;
        }
        return false;
    }
}