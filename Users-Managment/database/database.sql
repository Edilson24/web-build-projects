CREATE DATABASE IF NOT EXISTS sistema_gestao_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_gestao_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS solicitacoes_suporte;
DROP TABLE IF EXISTS tokens_recuperacao;
DROP TABLE IF EXISTS usuario_redes_sociais;
DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    username VARCHAR(50) NULL UNIQUE,
    foto VARCHAR(255) NULL,
    bio TEXT NULL,
    musica_url VARCHAR(255) NULL,
    tema VARCHAR(20) DEFAULT 'claro',
    perfil ENUM('admin', 'user') DEFAULT 'user',
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    primeiro_acesso TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE usuario_redes_sociais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    plataforma VARCHAR(50) NOT NULL,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tokens_recuperacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    token VARCHAR(100) NOT NULL,
    expiracao DATETIME NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE solicitacoes_suporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    mensagem TEXT NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;