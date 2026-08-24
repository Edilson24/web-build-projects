<?php
/**
 * Front Controller - Ponto de Entrada Único
 */

// Iniciar sessão
session_start();

// Carregar arquivos de infraestrutura e controllers
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../app/controllers/Router.php';
require_once __DIR__ . '/../app/controllers/HomeController.php';

// Instanciar o roteador
$router = new Router();

// Definir as rotas do sistema
$router->add('GET', '/', [HomeController::class, 'index']);

// Executar o roteamento da requisição atual
$router->dispatch($_SERVER['REQUEST_URI'], $_SERVER['REQUEST_METHOD']);