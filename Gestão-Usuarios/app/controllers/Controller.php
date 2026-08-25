<?php
/**
 * Controller Base da Arquitetura MVC
 */
abstract class Controller {
    /**
     * Renderiza uma View localizada em app/views/
     *
     * @param string $view Caminho relativo da view (ex: 'user/profile')
     * @param array $data Dados a serem passados para a interface
     */
    protected function render(string $view, array $data = []): void {
        // Transforma as chaves do array em variáveis na view ($user, $avatarUrl, $socialLinks)
        extract($data);

        $viewFile = __DIR__ . "/../views/{$view}.php";

        if (file_exists($viewFile)) {
            require $viewFile;
        } else {
            die("Erro: A View '{$view}' não foi encontrada em {$viewFile}");
        }
    }
}