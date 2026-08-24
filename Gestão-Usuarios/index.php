<?php
/**
 * Ponto de entrada para execução do servidor via CLI (Terminal)
 */

require_once __DIR__ . '/bootstrap/PhpServerManager.php';

$server = new PhpServerManager('localhost', 8000);
$server->run();