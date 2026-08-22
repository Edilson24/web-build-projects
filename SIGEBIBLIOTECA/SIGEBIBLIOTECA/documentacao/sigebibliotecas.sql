-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 01-Ago-2026 às 19:43
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `sigebibliotecas`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `devolucoes`
--

CREATE TABLE `devolucoes` (
  `iddevolucao` int(11) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `edicao` varchar(10) NOT NULL,
  `volume` int(11) NOT NULL,
  `autor` varchar(250) NOT NULL,
  `nome_leitor` varchar(50) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `tipo_leitor` varchar(10) NOT NULL,
  `curso` varchar(150) DEFAULT NULL,
  `turma` varchar(10) DEFAULT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `emprestimos`
--

CREATE TABLE `emprestimos` (
  `idemprestimo` int(11) NOT NULL,
  `titulo_livro` varchar(150) NOT NULL,
  `edicao` varchar(10) NOT NULL,
  `valume` int(11) DEFAULT NULL,
  `autor` varchar(250) NOT NULL,
  `nome_leitor` varchar(50) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `tipo_leitor` varchar(10) NOT NULL,
  `curso` varchar(50) DEFAULT NULL,
  `turma` varchar(10) DEFAULT NULL,
  `data_emprestimo` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `leitores`
--

CREATE TABLE `leitores` (
  `idleitor` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `tipo_leitor` varchar(10) NOT NULL,
  `curso` varchar(150) DEFAULT NULL,
  `turma` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `livros`
--

CREATE TABLE `livros` (
  `idlivro` int(11) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `autor` varchar(250) NOT NULL,
  `editor` varchar(25) NOT NULL,
  `edicao` varchar(10) NOT NULL,
  `volume` int(11) DEFAULT NULL,
  `ano_publicacao` date NOT NULL,
  `local-publicacao` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `multas`
--

CREATE TABLE `multas` (
  `idmulta` int(11) NOT NULL,
  `nome_leitor` varchar(50) NOT NULL,
  `tipo_leitor` varchar(10) NOT NULL,
  `curso` varchar(150) DEFAULT NULL,
  `turma` varchar(10) DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `edicao` varchar(10) NOT NULL,
  `volume` int(11) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `devolucoes`
--
ALTER TABLE `devolucoes`
  ADD PRIMARY KEY (`iddevolucao`);

--
-- Índices para tabela `emprestimos`
--
ALTER TABLE `emprestimos`
  ADD PRIMARY KEY (`idemprestimo`);

--
-- Índices para tabela `leitores`
--
ALTER TABLE `leitores`
  ADD PRIMARY KEY (`idleitor`);

--
-- Índices para tabela `livros`
--
ALTER TABLE `livros`
  ADD PRIMARY KEY (`idlivro`);

--
-- Índices para tabela `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`idmulta`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `devolucoes`
--
ALTER TABLE `devolucoes`
  MODIFY `iddevolucao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `emprestimos`
--
ALTER TABLE `emprestimos`
  MODIFY `idemprestimo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `leitores`
--
ALTER TABLE `leitores`
  MODIFY `idleitor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `livros`
--
ALTER TABLE `livros`
  MODIFY `idlivro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `multas`
--
ALTER TABLE `multas`
  MODIFY `idmulta` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
