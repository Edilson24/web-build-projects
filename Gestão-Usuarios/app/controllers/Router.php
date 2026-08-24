<?php
/**
 * Gerenciador de Rotas do Sistema
 */
class Router {
    private array $routes = [];

    /**
     * Cadastra uma rota no sistema
     */
    public function add(string $method, string $path, array $handler): void {
        $this->routes[] = [
            'method'  => strtoupper($method),
            'path'    => $path,
            'handler' => $handler
        ];
    }

    /**
     * Executa a busca e o roteamento da URL requisitada
     */
    public function dispatch(string $requestUri, string $requestMethod): void {
        $parsedUrl = parse_url($requestUri, PHP_URL_PATH);

        foreach ($this->routes as $route) {
            if ($route['method'] === strtoupper($requestMethod) && $route['path'] === $parsedUrl) {
                [$controllerClass, $method] = $route['handler'];

                if (class_exists($controllerClass)) {
                    $controller = new $controllerClass();
                    if (method_exists($controller, $method)) {
                        $controller->$method();
                        return;
                    }
                }
            }
        }

        // Página 404 caso a rota não seja encontrada
        http_response_code(404);
        echo "<div style='text-align:center; padding:50px; font-family:sans-serif;'>";
        echo "<h1>404 - Página Não Encontrada</h1>";
        echo "<p>A rota que tentou acessar não existe.</p>";
        echo "<a href='/'>Voltar para a Página Inicial</a>";
        echo "</div>";
    }
}