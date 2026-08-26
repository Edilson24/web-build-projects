

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


--
-- Banco de dados: `sigeigreja`
--

-- --------------------------------------------------------


create database sigeigreja;
use sigeigreja;

CREATE TABLE `batismos` (
  `idbatismo` int(11) NOT NULL,
  `data` date NOT NULL,
  `quantidade` int(11) NOT NULL,
  `local` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cargos`
--

CREATE TABLE `cargos` (
  `idcargo` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `comunidades`
--

CREATE TABLE `comunidades` (
  `idcomunidade` int(11) NOT NULL,
  `nome` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crentes`
--

CREATE TABLE `crentes` (
  `idcrente` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `data_nascimento` date NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `estado_civil` varchar(25) NOT NULL,
  `conjus` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `detalhe_batismo`
--

CREATE TABLE `detalhe_batismo` (
  `iddetalhe` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `padrinho` varchar(100) DEFAULT NULL,
  `madrinha` varchar(100) DEFAULT NULL,
  `idbatismo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `dispesas`
--

CREATE TABLE `dispesas` (
  `iddispesa` int(11) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `horariocultos`
--

CREATE TABLE `horariocultos` (
  `idhorario` int(11) NOT NULL,
  `dia` date NOT NULL,
  `hora` time NOT NULL,
  `dirigente_culto` varchar(150) NOT NULL,
  `local` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ofertorios`
--

CREATE TABLE `ofertorios` (
  `idofertorio` int(11) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `data` date NOT NULL,
  `observacao` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `funcao` varchar(50) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `senha` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `batismos`
--
ALTER TABLE `batismos`
  ADD PRIMARY KEY (`idbatismo`);

--
-- Índices para tabela `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`idcargo`);

--
-- Índices para tabela `comunidades`
--
ALTER TABLE `comunidades`
  ADD PRIMARY KEY (`idcomunidade`);

--
-- Índices para tabela `crentes`
--
ALTER TABLE `crentes`
  ADD PRIMARY KEY (`idcrente`);

--
-- Índices para tabela `detalhe_batismo`
--
ALTER TABLE `detalhe_batismo`
  ADD PRIMARY KEY (`iddetalhe`);

--
-- Índices para tabela `dispesas`
--
ALTER TABLE `dispesas`
  ADD PRIMARY KEY (`iddispesa`);

--
-- Índices para tabela `horariocultos`
--
ALTER TABLE `horariocultos`
  ADD PRIMARY KEY (`idhorario`);

--
-- Índices para tabela `ofertorios`
--
ALTER TABLE `ofertorios`
  ADD PRIMARY KEY (`idofertorio`);

--
-- Índices para tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `batismos`
--
ALTER TABLE `batismos`
  MODIFY `idbatismo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cargos`
--
ALTER TABLE `cargos`
  MODIFY `idcargo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `comunidades`
--
ALTER TABLE `comunidades`
  MODIFY `idcomunidade` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `crentes`
--
ALTER TABLE `crentes`
  MODIFY `idcrente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `detalhe_batismo`
--
ALTER TABLE `detalhe_batismo`
  MODIFY `iddetalhe` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `dispesas`
--
ALTER TABLE `dispesas`
  MODIFY `iddispesa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `horariocultos`
--
ALTER TABLE `horariocultos`
  MODIFY `idhorario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ofertorios`
--
ALTER TABLE `ofertorios`
  MODIFY `idofertorio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
