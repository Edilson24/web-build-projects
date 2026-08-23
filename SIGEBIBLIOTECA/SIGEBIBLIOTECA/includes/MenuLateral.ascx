<%@ Control Language="VB" AutoEventWireup="false" CodeFile="MenuLateral.ascx.vb" Inherits="SIGEBIBLIOTECA.MenuLateral" %>

<style>
    /* Estilos do Menu Lateral */
    .sidebar {
        width: 250px;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        background-color: #1e293b;
        color: #fff;
        transition: all 0.3s ease;
        z-index: 1000;
        overflow-x: hidden;
    }

    /* Estado Retraído */
    .sidebar.collapsed {
        width: 70px;
    }

    .sidebar.collapsed .nav-link span,
    .sidebar.collapsed .user-info-text {
        display: none !important;
    }

    .sidebar.collapsed .nav-link {
        justify-content: center;
        padding: 12px 0;
    }

    .sidebar .nav-link {
        color: #94a3b8;
        padding: 12px 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        white-space: nowrap;
        text-decoration: none;
        transition: background-color 0.2s ease, color 0.2s ease;
    }

    .sidebar .nav-link:hover, 
    .sidebar .nav-link.active {
        background-color: #2563eb;
        color: #ffffff !important;
        font-weight: 500;
        border-left: 4px solid #60a5fa;
    }

    .toggle-btn {
        background: none;
        border: none;
        color: white;
        font-size: 1.2rem;
        padding: 15px 20px;
        cursor: pointer;
        width: 100%;
        text-align: right;
    }

    .sidebar.collapsed .toggle-btn {
        text-align: center;
    }
</style>

<div id="sidebar" class="sidebar">
    <button type="button" class="toggle-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="px-3 py-2 border-bottom border-secondary mb-3 user-info-text">
        <small class="text-uppercase text-white-50">
            Olá, <strong class="text-white"><asp:Literal ID="litNomeUsuario" runat="server"></asp:Literal></strong>
        </small>
    </div>

    <nav class="nav flex-column">
        <a href="<%= ResolveUrl("/Dashboard.aspx") %>" class="nav-link <%= ObterClasseAtiva("Dashboard.aspx") %>">
            <i class="fas fa-chart-line"></i> <span>Dashboard</span>
        </a>

        <asp:PlaceHolder ID="phMenuAdmin" runat="server">
            <a href="<%= ResolveUrl("~/views/Categorias.aspx") %>" class="nav-link <%= ObterClasseAtiva("Categorias.aspx") %>">
                <i class="fas fa-tags"></i> <span>Categorias</span>
            </a>
            <a href="<%= ResolveUrl("~/views/Livros.aspx") %>" class="nav-link <%= ObterClasseAtiva("Livros.aspx") %>">
                <i class="fas fa-book"></i> <span>Acervo de Livros</span>
            </a>
            <a href="<%= ResolveUrl("~/views/Leitores.aspx") %>" class="nav-link <%= ObterClasseAtiva("Leitores.aspx") %>">
                <i class="fas fa-address-book"></i> <span>Leitores</span>
            </a>
            <a href="<%= ResolveUrl("~/views/Usuarios.aspx") %>" class="nav-link <%= ObterClasseAtiva("Usuarios.aspx") %>">
                <i class="fas fa-user-shield"></i> <span>Usuários do Sistema</span>
            </a>
        </asp:PlaceHolder>

        <a href="<%= ResolveUrl("~/views/Emprestimos.aspx") %>" class="nav-link <%= ObterClasseAtiva("Emprestimos.aspx") %>">
            <i class="fas fa-exchange-alt"></i> <span>Empréstimos</span>
        </a>

        <asp:PlaceHolder ID="phLogsAdmin" runat="server">
            <a href="<%= ResolveUrl("~/views/Logs.aspx") %>" class="nav-link <%= ObterClasseAtiva("Logs.aspx") %>">
                <i class="fas fa-history"></i> <span>Logs de Auditoria</span>
            </a>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phRelatoriosAdmin" runat="server">
            <a href="<%= ResolveUrl("~/views/Relatorios.aspx") %>" class="nav-link <%= ObterClasseAtiva("Relatorios.aspx") %>">
                <i class="fas fa-history"></i> <span>Relatórios</span>
            </a>
        </asp:PlaceHolder>
        
        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="nav-link text-danger mt-4" CausesValidation="false">
            <i class="fas fa-sign-out-alt"></i> <span>Sair</span>
        </asp:LinkButton>
    </nav>
</div>

<script>
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var mainContent = document.querySelector('.main-content');

        sidebar.classList.toggle('collapsed');

        if (mainContent) {
            if (sidebar.classList.contains('collapsed')) {
                mainContent.style.marginLeft = '70px';
            } else {
                mainContent.style.marginLeft = '250px';
            }
        }
    }
</script>