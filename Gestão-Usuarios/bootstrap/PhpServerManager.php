<?php
/**
 * Gerenciador do Servidor HTTP Embutido do PHP
 */

class PhpServerManager {
    private string $host;
    private int $startPort;

    public function __construct(string $host = 'localhost', int $startPort = 8000) {
        $this->host = $host;
        $this->startPort = $startPort;
    }

    /**
     * Procura a primeira porta disponível no sistema a partir da porta inicial
     */
    private function findAvailablePort(): int {
        $port = $this->startPort;
        while ($port < $this->startPort + 100) {
            $connection = @fsockopen($this->host, $port);
            if (!is_resource($connection)) {
                return $port; // Porta está livre
            }
            fclose($connection);
            $port++;
        }

        throw new Exception("Nenhuma porta livre encontrada no intervalo de " . $this->startPort . " a " . ($port - 1));
    }

    /**
     * Inicia o PHP Built-in Server na pasta 'public'
     */
    public function run(): void {
        $port = $this->findAvailablePort();
        $publicDir = realpath(__DIR__ . '/../public');
        $url = "http://{$this->host}:{$port}";

        echo "========================================================\n";
        echo "   Iniciando Servidor HTTP Embutido do PHP...\n";
        echo "   Endereço: {$url}\n";
        echo "   Diretório Público: {$publicDir}\n";
        echo "========================================================\n";
        echo "Pressione Ctrl+C para encerrar o servidor.\n\n";

        // Tenta abrir o navegador automaticamente
        $this->openBrowser($url);

        // Executa o comando do PHP Built-in Server
        passthru("php -S {$this->host}:{$port} -t \"{$publicDir}\"");
    }

    /**
     * Tenta abrir a URL no navegador padrão do SO
     */
    private function openBrowser(string $url): void {
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            pclose(popen("start {$url}", "r"));
        } elseif (PHP_OS === 'Darwin') {
            pclose(popen("open '{$url}'", "r"));
        } else {
            pclose(popen("xdg-open '{$url}'", "r"));
        }
    }
}