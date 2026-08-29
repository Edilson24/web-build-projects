-- ========================================================
-- BANCO DE DADOS: sigeigreja (Refatorado & Unificado)
-- ========================================================



CREATE DATABASE IF NOT EXISTS `sigeigreja` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sigeigreja`;

-- --------------------------------------------------------
-- 1. TABELA DE GRUPOS DA IGREJA (Jovens, Mulheres, Homens, etc.)
-- --------------------------------------------------------
CREATE TABLE `grupos` (
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

COMMIT;

