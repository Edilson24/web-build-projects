<?php
/**
 * Front Controller - Ponto de Entrada Único
 */

session_start();

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../app/controllers/Router.php';
require_once __DIR__ . '/../app/controllers/HomeController.php';
require_once __DIR__ . '/../app/controllers/AuthController.php';
require_once __DIR__ . '/../app/controllers/UserController.php';
require_once __DIR__ . '/../app/controllers/SupportController.php';
require_once __DIR__ . '/../app/controllers/AdminController.php';

$router = new Router();

// Rotas Landing Page
$router->add('GET', '/', [HomeController::class, 'index']);

// Rotas Autenticação
$router->add('GET', '/register', [AuthController::class, 'showRegister']);
$router->add('POST', '/register', [AuthController::class, 'register']);
$router->add('GET', '/login', [AuthController::class, 'showLogin']);
$router->add('POST', '/login', [AuthController::class, 'login']);
$router->add('GET', '/logout', [AuthController::class, 'logout']);

// Rotas do Perfil do Utilizador
$router->add('GET', '/perfil', [UserController::class, 'profile']);
$router->add('POST', '/perfil/atualizar', [UserController::class, 'updateProfile']);
$router->add('POST', '/perfil/social/adicionar', [UserController::class, 'addSocial']);
$router->add('GET', '/perfil/social/remover', [UserController::class, 'removeSocial']);

// Rotas de Suporte Técnico
$router->add('GET', '/suporte', [SupportController::class, 'index']);
$router->add('POST', '/suporte/novo', [SupportController::class, 'store']);
$router->add('GET', '/suporte/ver', [SupportController::class, 'view']);
$router->add('POST', '/suporte/responder', [SupportController::class, 'reply']);

// Rotas do Painel Administrativo
// Rotas de Gestão de Utilizadores pelo Admin
$router->add('POST', '/admin/usuario/criar', [AdminController::class, 'storeUser']);
$router->add('POST', '/admin/usuario/editar', [AdminController::class, 'updateUser']);
$router->add('GET', '/admin/usuario/eliminar', [AdminController::class, 'deleteUser']);

// Executar o roteamento
$router->dispatch($_SERVER['REQUEST_URI'], $_SERVER['REQUEST_METHOD']);