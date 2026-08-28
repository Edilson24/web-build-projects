
# Sistema de Gestão de Utilizadores (UserSystem)

Aplicação web desenvolvida em PHP utilizando o padrão arquitetural **MVC (Model-View-Controller)**, focada no gerenciamento de perfis, controle de permissões de acesso, suporte técnico e gestão administrativa.

---

## 🛠️ Tecnologias Utilizadas

- **Backend:** PHP 8.x (Programação Orientada a Objetos e PDO)
- **Frontend:** HTML5, CSS3 (com suporte a temas Dark/Light) e JavaScript
- **Base de Dados:** MySQL Server
- **Servidor:** PHP Built-in Server
- **Segurança:** Prepared Statements (PDO), `password_hash()`, `htmlspecialchars()` e Tokens de Sessão/Cookie

---

### 1. Pré-requisitos

Antes de iniciar a aplicação, certifique-se de que tem instalado no seu ambiente:PHP (versão 8.0 ou superior)MySQL Server / MariaDB (via XAMPP, WAMP ou instalação autônoma)Navegador Web moderno (Chrome, Edge, Firefox, Brave)🗄️ Configuração da Base de DadosInicie o serviço do MySQL.Abra a sua ferramenta de gestão SQL (phpMyAdmin, MySQL Workbench ou DBeaver).  Execute o script SQL localizado em database/database.sql para criar a base de dados e a tabela usuarios.Verifique as credenciais no ficheiro config/database.php e ajuste conforme o seu ambiente local:PHPdefine('DB_HOST', 'localhost');
define('DB_NAME', 'sistema_gestao_db');
define('DB_USER', 'root');
define('DB_PASS', '');

### 2. Como Executar o Projeto

Abra o terminal na pasta raiz do projeto.Inicie o servidor embutido do PHP apontando para a pasta pública public/:Bash "php -S localhost:8000 -t public"
Acesse a aplicação no navegador através do endereço: http://localhost:8000
### Acesso de Administrador
Para conceder permissões administrativas a uma conta registada, execute o seguinte comando no MySQL alterando o id para o ID do utilizador desejado:SQLUPDATE usuarios SET tipo_perfil = 'admin' WHERE id = 1;
### Recursos de Segurança Implementados
Proteção contra SQL Injection: Consultas executadas com PDO::prepare() e Binding de parâmetros.Proteção contra XSS: Sanitização de saídas para o navegador utilizando htmlspecialchars().  Criptografia de Senhas: Senhas armazenadas com hash seguro via password_hash().  Gestão de Sessões & Cookies: Controle de expiração de acessos e funcionalidade "Lembrar-me" por 7 dias.Registo de Logs: Captura de exceções e salvamento interno no diretório logs/error.

## 3. Estrutura do Projeto

```text
projeto/
│
├── app/
│   ├── controllers/      # Controladores da aplicação (Auth, User, Admin, Support, Router)
│   ├── models/           # Lógica de negócio e comunicação PDO com a BD (User, Support)
│   └── views/            # Interfaces de navegação (Admin, Perfil, Auth, Suporte)
│
├── bootstrap/
│   └── PhpServerManager.php # Gerenciador de inicialização do servidor embutido
│
├── config/
│   └── database.php      # Configuração e conexão PDO com MySQL
│
├── database/
│   └── database.sql      # Script de criação das tabelas e esquemas de dados
│
├── logs/
│   └── error.log         # Registo interno de exceções e falhas do sistema
│
├── public/               # Raiz exposta pelo servidor HTTP
│   ├── index.php         # Front Controller (Ponto de entrada único)
│   ├── css/              # Estilos visuais e temas dinâmicos
│   ├── js/               # Scripts para interatividade no cliente
│   └── uploads/          # Diretório para armazenamento de fotos de perfil
│
└── README.md             # Instruções de instalação, execução e documentação
=======
# Sistema de Gestão de Utilizadores (UserSystem)

Aplicação web desenvolvida em PHP utilizando o padrão arquitetural **MVC (Model-View-Controller)**, focada no gerenciamento de perfis, controle de permissões de acesso, suporte técnico e gestão administrativa.

---

## 🛠️ Tecnologias Utilizadas

- **Backend:** PHP 8.x (Programação Orientada a Objetos e PDO)
- **Frontend:** HTML5, CSS3 (com suporte a temas Dark/Light) e JavaScript
- **Base de Dados:** MySQL Server[cite: 1, 5]
- **Servidor:** PHP Built-in Server[cite: 1, 3]
- **Segurança:** Prepared Statements (PDO), `password_hash()`, `htmlspecialchars()` e Tokens de Sessão/Cookie

---

## 📁 Estrutura do Projeto

```text
projeto/
│
├── app/
│   ├── controllers/      # Controladores da aplicação (Auth, User, Admin, Support, Router)
│   ├── models/           # Lógica de negócio e comunicação PDO com a BD (User, Support)
│   └── views/            # Interfaces de navegação (Admin, Perfil, Auth, Suporte)
│
├── bootstrap/
│   └── PhpServerManager.php # Gerenciador de inicialização do servidor embutido
│
├── config/
│   └── database.php      # Configuração e conexão PDO com MySQL
│
├── database/
│   └── database.sql      # Script de criação das tabelas e esquemas de dados
│
├── logs/
│   └── error.log         # Registo interno de exceções e falhas do sistema
│
├── public/               # Raiz exposta pelo servidor HTTP
│   ├── index.php         # Front Controller (Ponto de entrada único)
│   ├── css/              # Estilos visuais e temas dinâmicos
│   ├── js/               # Scripts para interatividade no cliente
│   └── uploads/          # Diretório para armazenamento de fotos de perfil
│
└── README.md             # Instruções de instalação, execução e documentação

