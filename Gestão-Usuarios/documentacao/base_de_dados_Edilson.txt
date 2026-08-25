-- ============================================================================
-- Script SQL para o Sistema de Gestão de Utilizadores
-- Tecnologias: MySQL Server / PDO PHP
-- Arquitetura: Compatível com o padrão MVC
-- ============================================================================

CREATE DATABASE IF NOT EXISTS `sistema_gestao_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `sistema_gestao_db`;

-- Desativar temporariamente checagens de chave estrangeira para limpeza de tabelas
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `solicitacoes_suporte`;
DROP TABLE IF EXISTS `tokens_recuperacao`;
DROP TABLE IF EXISTS `usuario_redes_sociais`;
DROP TABLE IF EXISTS `usuarios`;
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------------
-- 1. Tabela Principal: Tabela de Utilizadores (`usuarios`)
-- ----------------------------------------------------------------------------
CREATE TABLE `usuarios` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `senha` VARCHAR(255) NOT NULL, -- Armazena hashes via password_hash()
  `tipo_perfil` ENUM('admin', 'usuario') NOT NULL DEFAULT 'usuario',
  `status` ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
  
  -- Campos opcionais do perfil do utilizador
  `user_name` VARCHAR(50) UNIQUE DEFAULT NULL,
  `foto_perfil` VARCHAR(255) DEFAULT NULL, -- Nulo usará ui-avatars.com via código
  `bio` TEXT DEFAULT NULL,
  `musica_url` VARCHAR(255) DEFAULT NULL,
  
  -- Preferências visuais e controle do sistema
  `tema_preferido` VARCHAR(20) NOT NULL DEFAULT 'dark', -- Ex: dark, light
  `primeiro_acesso` TINYINT(1) NOT NULL DEFAULT 0, -- 1 = Força troca de senha inicial
  `remember_token` VARCHAR(255) DEFAULT NULL, -- Token do cookie "Lembrar-me" (7 dias)
  
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 2. Tabela de Redes Sociais (`usuario_redes_sociais`)
-- Atende ao requisito de inserção incremental com norma de normalização 1FN/2FN
-- ----------------------------------------------------------------------------
CREATE TABLE `usuario_redes_sociais` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `usuario_id` INT NOT NULL,
  `url_link` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT `fk_redes_sociais_usuario` 
    FOREIGN KEY (`usuario_id`) 
    REFERENCES `usuarios` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 3. Tabela de Tokens de Recuperação de Senha (`tokens_recuperacao`)
-- Atende ao requisito de notificações/emails com redefinição temporária
-- ----------------------------------------------------------------------------
CREATE TABLE `tokens_recuperacao` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `usuario_id` INT NOT NULL,
  `token` VARCHAR(64) NOT NULL UNIQUE,
  `expira_em` DATETIME NOT NULL,
  `utilizado` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT `fk_tokens_usuario` 
    FOREIGN KEY (`usuario_id`) 
    REFERENCES `usuarios` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 4. Tabela de Solicitações de Suporte (`solicitacoes_suporte`)
-- Registra pedidos de assistência enviados por utilizadores desativados
-- ----------------------------------------------------------------------------
CREATE TABLE `solicitacoes_suporte` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `usuario_id` INT NOT NULL,
  `mensagem` TEXT NOT NULL,
  `status` ENUM('pendente', 'resolvido') NOT NULL DEFAULT 'pendente',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolvido_em` DATETIME DEFAULT NULL,
  
  CONSTRAINT `fk_suporte_usuario` 
    FOREIGN KEY (`usuario_id`) 
    REFERENCES `usuarios` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Dados Iniciais de Teste / Demonstração
-- ----------------------------------------------------------------------------

-- Inserção do Administrador Padrão (Senha inicial: 'admin123' criptografada)
-- O hash abaixo é um exemplo gerado via password_hash('admin123', PASSWORD_DEFAULT)
INSERT INTO `usuarios` (`nome`, `email`, `senha`, `tipo_perfil`, `status`, `user_name`, `tema_preferido`) 
VALUES (
  'Administrador do Sistema', 
  'admin@sistema.com', 
  '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe1VAnz/34.9jE6f3y2sWzXG2hI3IeB3K', -- Hash do Bcrypt
  'admin', 
  'ativo', 
  'sysadmin', 
  'dark'
);

-- Inserção de um Utilizador Padrão
INSERT INTO `usuarios` (`nome`, `email`, `senha`, `tipo_perfil`, `status`, `user_name`, `bio`, `tema_preferido`) 
VALUES (
  'Edilson Hilário', 
  'edilson@exemplo.com', 
  '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe1VAnz/34.9jE6f3y2sWzXG2hI3IeB3K', 
  'usuario', 
  'ativo', 
  'edilson24', 
  'Estudante de Informática e desenvolvedor de software.', 
  'dark'
);

-- Exemplo de rede social associada ao utilizador criado acima
INSERT INTO `usuario_redes_sociais` (`usuario_id`, `url_link`) 
VALUES 
(2, 'https://github.com/Edilson24');