document.addEventListener('DOMContentLoaded', () => {
    const themeToggleBtn = document.getElementById('theme-toggle');
    const sunIcon = document.getElementById('sun-icon');
    const moonIcon = document.getElementById('moon-icon');
    const themeText = document.getElementById('theme-text');

    // Tenta obter o tema da sessão/banco injetado via HTML data-attribute ou localStorage
    const savedTheme = localStorage.getItem('lifter_theme') || document.documentElement.getAttribute('data-theme') || 'dark';
    applyTheme(savedTheme);

    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            applyTheme(newTheme);
            localStorage.setItem('lifter_theme', newTheme);
            
            // Notifica o backend via Fetch para salvar a preferência no perfil do utilizador (se logado)
            fetch('/user/salvar-tema', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `tema=${newTheme}`
            }).catch(() => {});
        });
    }

    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        fetch('/user/salvar-tema', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `tema=${theme}`
        }).catch(() => {
            // Ignora o erro silenciosamente para visitantes não autenticados
        });
        if (sunIcon && moonIcon && themeText) {
            if (theme === 'light') {
                sunIcon.style.display = 'none';
                moonIcon.style.display = 'inline-block';
                themeText.textContent = 'Modo Escuro';
            } else {
                sunIcon.style.display = 'inline-block';
                moonIcon.style.display = 'none';
                themeText.textContent = 'Modo Claro';
            }
        }
    }
});