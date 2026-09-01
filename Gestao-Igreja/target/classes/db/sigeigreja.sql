-- ========================================================
-- BANCO DE DADOS: sigeigreja (Refatorado & Unificado)
-- ========================================================



CREATE DATABASE IF NOT EXISTS 'sigeigreja' DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sigeigreja`;

-- --------------------------------------------------------
-- 1. TABELA DE GRUPOS DA IGREJA (Jovens, Mulheres, Homens, etc.)
-- --------------------------------------------------------
CREATE TABLE 'grupos' (
  `idgrupo` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `descricao` VARCHAR(150) DEFAULT NULL,
  PRIMARY KEY (`idgrupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data Inicial de Grupos Padrão
INSERT INTO `grupos` (`nome`) VALUES ('Jovens'), ('Mulheres'), ('Homens'), ('Geral');

-- --------------------------------------------------------
-- 2. TABELA DE MEMBROS (CRENTES)
-- --------------------------------------------------------
CREATE TABLE `crentes` (
  `idcrente` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `endereco` VARCHAR(100) DEFAULT NULL,
  `estado_civil` ENUM('Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)') NOT NULL,
  `status_batismo` ENUM('NÃO_BATIZADO', 'AGUARDANDO_BATISMO', 'BATIZADO') NOT NULL DEFAULT 'NÃO_BATIZADO',
  `data_entrada` DATE NOT NULL,
  `idgrupo` INT(11) NOT NULL,
  `foto_url` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`idcrente`),
  CONSTRAINT `fk_crente_grupo` FOREIGN KEY (`idgrupo`) REFERENCES `grupos` (`idgrupo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 3. TABELA DE USUÁRIOS DO SISTEMA (Com vínculo opcional com Membro)
-- --------------------------------------------------------
CREATE TABLE `usuarios` (
  `idusuario` INT(11) NOT NULL AUTO_INCREMENT,
  `idcrente` INT(11) DEFAULT NULL, -- Vinculado se o usuário for um pastor/membro
  `nome` VARCHAR(150) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `senha` VARCHAR(255) NOT NULL, -- Recomendado armazenamento com Hash
  `funcao` ENUM('ADMINISTRADOR', 'SECRETARIO', 'TESOUREIRO', 'PASTOR') NOT NULL,
  `foto_url` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`idusuario`),
  CONSTRAINT `fk_usuario_crente` FOREIGN KEY (`idcrente`) REFERENCES `crentes` (`idcrente`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 4. TABELA DE PARENTESCOS (Relacionamento N:N entre Membros)
-- --------------------------------------------------------
CREATE TABLE `parentescos` (
  `idparentesco` INT(11) NOT NULL AUTO_INCREMENT,
  `idcrente_1` INT(11) NOT NULL,
  `idcrente_2` INT(11) NOT NULL,
  `tipo_vinculo` VARCHAR(50) NOT NULL, -- Ex: Pai, Mãe, Cônjuge, Filho, Irmão
  PRIMARY KEY (`idparentesco`),
  CONSTRAINT `fk_parentesco_crente1` FOREIGN KEY (`idcrente_1`) REFERENCES `crentes` (`idcrente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_parentesco_crente2` FOREIGN KEY (`idcrente_2`) REFERENCES `crentes` (`idcrente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 5. TABELA DE CERIMÔNIAS DE BATISMO
-- --------------------------------------------------------
CREATE TABLE `batismos` (
  `idbatismo` INT(11) NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `local` VARCHAR(100) NOT NULL,
  `idpastor` INT(11) NOT NULL, -- Pastor responsável (Usuário com função PASTOR)
  PRIMARY KEY (`idbatismo`),
  CONSTRAINT `fk_batismo_pastor` FOREIGN KEY (`idpastor`) REFERENCES `usuarios` (`idusuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 6. TABELA DETALHE DO BATISMO (Candidatos por Cerimônia - Máx 10)
-- --------------------------------------------------------
CREATE TABLE `detalhe_batismo` (
  `iddetalhe` INT(11) NOT NULL AUTO_INCREMENT,
  `idbatismo` INT(11) NOT NULL,
  `idcrente` INT(11) NOT NULL,
  `padrinho` VARCHAR(100) DEFAULT NULL,
  `madrinha` VARCHAR(100) DEFAULT NULL,
  `confirmado` TINYINT(1) NOT NULL DEFAULT 0, -- 0 = Aguardando, 1 = Batizado (Confirmado pelo Pastor)
  PRIMARY KEY (`iddetalhe`),
  UNIQUE KEY `uk_batismo_membro` (`idbatismo`, `idcrente`),
  CONSTRAINT `fk_detalhe_batismo` FOREIGN KEY (`idbatismo`) REFERENCES `batismos` (`idbatismo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detalhe_crente` FOREIGN KEY (`idcrente`) REFERENCES `crentes` (`idcrente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 7. TABELA UNIFICADA DE MOVIMENTAÇÕES FINANCEIRAS
-- --------------------------------------------------------
CREATE TABLE `movimentacoes_financeiras` (
  `idmovimentacao` INT(11) NOT NULL AUTO_INCREMENT,
  `tipo_movimentacao` ENUM('ENTRADA', 'SAIDA') NOT NULL,
  `categoria` ENUM('DIZIMO', 'ACAO_DE_GRACA', 'OFERTORIO_COLETIVO', 'DESPESA') NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `data` DATE NOT NULL,
  `idcrente` INT(11) DEFAULT NULL, -- NULL se for visitante, anônimo ou oferta coletiva/despesa
  `tipo_contribuidor` ENUM('MEMBRO', 'VISITANTE_INDIVIDUAL', 'VISITANTE_GRUPO', 'ANONIMO') DEFAULT 'MEMBRO',
  `nome_contribuidor_externo` VARCHAR(150) DEFAULT NULL, -- Nome do visitante/grupo se idcrente for NULL
  `observacao_nota` TEXT DEFAULT NULL, -- Oportunidade/motivo da ação de graça ou descrição obrigatória de despesa
  `idusuario_registro` INT(11) NOT NULL, -- Tesoureiro que registrou
  PRIMARY KEY (`idmovimentacao`),
  CONSTRAINT `fk_mov_crente` FOREIGN KEY (`idcrente`) REFERENCES `crentes` (`idcrente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_mov_usuario` FOREIGN KEY (`idusuario_registro`) REFERENCES `usuarios` (`idusuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 8. TABELA DE HORÁRIO DE CULTOS
-- --------------------------------------------------------
CREATE TABLE `horariocultos` (
  `idhorario` INT(11) NOT NULL AUTO_INCREMENT,
  `dia_semana` VARCHAR(20) NOT NULL, -- Ex: Domingo, Quarta-feira
  `hora` TIME NOT NULL,
  `dirigente_culto` VARCHAR(150) NOT NULL,
  `local` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idhorario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 9. TABELA DE LOGS DE AUDITORIA (Restrito ao Administrador)
-- --------------------------------------------------------
CREATE TABLE `logs` (
  `idlog` INT(11) NOT NULL AUTO_INCREMENT,
  `idusuario` INT(11) NOT NULL,
  `departamento` ENUM('SECRETARIA', 'TESOURARIA', 'PASTORAL', 'SISTEMA') NOT NULL,
  `acao` VARCHAR(255) NOT NULL,
  `data_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idlog`),
  CONSTRAINT `fk_log_usuario` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1. INSERT DE CRENTES (MEMBROS)
INSERT INTO crentes (nome, data_nascimento, sexo, estado_civil, profissao, telefone, email, endereco, status_batismo, data_cadastro) VALUES
('Mateus Cândido', '1995-04-12', 'M', 'SOLTEIRO', 'Engenheiro Informático', '+258 84 123 4567', 'mateus.candido@gmail.com', 'Bairro Central, Nacala-Porto', 'BATIZADO', '2026-01-10'),
('Ana Paula Silva', '1998-08-23', 'F', 'CASADO', 'Professora', '+258 82 987 6543', 'ana.silva@hotmail.com', 'Bairro Triângulo, Nacala-Porto', 'NAO_BATIZADO', '2026-02-15'),
('Lucas Gabriel', '2001-11-05', 'M', 'SOLTEIRO', 'Estudante', '+258 86 555 1212', 'lucas.gabriel@outlook.com', 'Bairro Mahelane, Nacala-Porto', 'NAO_BATIZADO', '2026-03-01'),
('Esperança Mondlane', '1990-02-18', 'F', 'CASADO', 'Contabilista', '+258 84 333 9988', 'esperanca.m@gmail.com', 'Bairro Alto da Bela Vista, Nacala-Porto', 'BATIZADO', '2026-03-20'),
('Gerson Chocho', '1997-06-30', 'M', 'SOLTEIRO', 'Técnico de Redes', '+258 87 777 4411', 'gerson.chocho@sigeigreja.com', 'Bairro Mathia, Nacala-Porto', 'BATIZADO', '2026-04-05'),
('Anifa Armando', '2000-09-14', 'F', 'SOLTEIRO', 'Designer', '+258 84 888 2233', 'anifa.armando@gmail.com', 'Bairro Central, Nacala-Porto', 'NAO_BATIZADO', '2026-05-12'),
('Manuel Zeferino', '1993-12-01', 'M', 'CASADO', 'Gestor de Recursos Humanos', '+258 82 111 6655', 'm.zeferino@gmail.com', 'Bairro Ontupaia, Nacala-Porto', 'BATIZADO', '2026-06-18'),
('Renildo Cândido', '1999-03-27', 'M', 'SOLTEIRO', 'Desenvolvedor Software', '+258 86 444 3322', 'renildo.candido@gmail.com', 'Bairro Triângulo, Nacala-Porto', 'BATIZADO', '2026-07-02'),
('Anércia Mondlane', '2002-07-19', 'F', 'SOLTEIRO', 'Estudante', '+258 84 999 1100', 'anercia.m@outlook.com', 'Bairro Mahelane, Nacala-Porto', 'NAO_BATIZADO', '2026-07-25'),
('Robson Muadica', '1994-10-10', 'M', 'CASADO', 'Administrador de Redes', '+258 85 222 8899', 'robson.muadica@gmail.com', 'Bairro Central, Nacala-Porto', 'BATIZADO', '2026-08-10');


-- 2. INSERT DE BATISMOS (CERIMÔNIAS E AGENDAMENTOS)
-- Nota: Certifique-se de ter a tabela de batismos configurada ou ajuste conforme suas colunas
INSERT INTO batismos (data_cerimonia, local_cerimonia, observacao, status) VALUES
('2026-09-15', 'Praia de Fernão Veloso, Nacala', 'Cerimônia Trimestral de Batismos nas Águas', 'AGENDADO'),
('2026-09-28', 'Tanque Batismal da Igreja Central', 'Batismo Especial de Primavera', 'AGENDADO'),
('2026-06-10', 'Praia de Fernão Veloso, Nacala', 'Cerimônia de Inverno', 'REALIZADO');


-- 3. INSERT DE VÍNCULO CRENTE <-> BATISMO (CANDIDATOS INSCRITOS)
-- Insere os crentes não batizados como candidatos aos batismos futuros
INSERT INTO batismo_candidatos (idbatismo, idcrente, status_candidato) VALUES
(1, 2, 'INSCRITO'), -- Ana Paula Silva no batismo de 15/SET
(1, 3, 'INSCRITO'), -- Lucas Gabriel no batismo de 15/SET
(1, 6, 'INSCRITO'), -- Anifa Armando no batismo de 15/SET
(2, 9, 'INSCRITO'); -- Anércia Mondlane no batismo de 28/SET

COMMIT;

