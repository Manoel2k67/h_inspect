return {
    Id = "Interface",
    Label = "Interface",
    Icon = "sliders",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Textos e imagens locais",
            Icon = "search",
            Controls = {
                { Kind = "Input", Setting = "GuiFilter", Id = "gui_filter", Label = "Filtro da interface", Placeholder = "fabricante, guarda, glass...", Default = "" },
                { Kind = "Toggle", Setting = "IncludeHiddenGui", Id = "include_hidden_gui", Label = "Incluir elementos ocultos", Description = "Muitos jogos deixam textos de cargos e fases carregados, mas invisíveis.", Default = true },
                { Kind = "Slider", Setting = "MaxGuiResults", Id = "max_gui_results", Label = "Máximo de resultados", Min = 50, Max = 500, Default = 200, Step = 50 },
                { Kind = "Button", Setting = "ScanGui", Id = "scan_gui", Label = "Varrer PlayerGui agora", Description = "Coleta textos, imagens, visibilidade, posição, tamanho, tags e atributos.", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "gui_status", Label = "Nenhuma varredura", Description = "Textos como cargos, chances e avisos de fase aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "gui_report", Label = "Prévia da interface", Description = "A prévia será preenchida depois da primeira coleta.", Height = 320 },
            },
        },
    },
}
