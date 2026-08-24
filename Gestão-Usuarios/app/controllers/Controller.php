<?php
/**
 * Controller Base da Arquitetura MVC
 */
abstract class Controller {
    /**
     * Renderiza uma View localizada em app/views/
     *
     * @param string $view Caminho relativo da view (ex: 'user/landing')
     * @param array $data Dados a serem passados para a interface
     */
    protected function render(string $view, array $data = []): void {
        extract($data);
        $viewFile = __DIR__ . "/../views/{$view}.php";

        if (file_exists($viewFile)) {
            require_once $viewFile;
        } else {
            die("Erro: A View '{$view}' não foi encontrada em {$viewFile}");
        }
    }
}