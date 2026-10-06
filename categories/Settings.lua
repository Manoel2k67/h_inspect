return {
    Id = "Settings",
    Label = "Configurações",
    Icon = "settings",
    Bookmarked = false,
    RuntimeModule = "runtime/Settings.lua",
    Sections = {
        {
            Title = "Aparência",
            Icon = "palette",
            Controls = {
                { Kind = "Dropdown", Setting = "MenuTheme", Id = "menu_theme", Label = "Tema do menu", Description = "Mantém os temas visuais da base original.", Options = { "Default", "Purple", "Orange" }, Default = "Default", UseList = true },
            },
        },
        {
            Title = "Atalhos",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "shortcut_help", Label = "RightShift mostra ou oculta o H Inspect", Description = "A barra superior continua arrastável; os botões — e X apenas ocultam a janela.", Height = 68 },
            },
        },
    },
}
