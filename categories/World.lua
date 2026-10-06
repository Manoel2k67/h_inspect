return {
    Id = "World",
    Label = "Mapa",
    Icon = "map",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Coleta do mapa",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "WorldFocus", Id = "world_focus", Label = "Foco da varredura", Options = { "Tudo", "Portas e saídas", "Vidros e ponte", "Interações" }, Default = "Tudo", UseList = true },
                { Kind = "Input", Setting = "WorldFilter", Id = "world_filter", Label = "Filtro adicional", Placeholder = "glass, bridge, door, nome...", Default = "" },
                { Kind = "Slider", Setting = "MaxWorldResults", Id = "max_world_results", Label = "Máximo de resultados", Min = 20, Max = 200, Default = 80, Step = 10 },
                { Kind = "Button", Setting = "ScanWorld", Id = "scan_world", Label = "Varrer mapa agora", Description = "Lê cor, material, transparência local, colisão, tags, atributos e prompts.", ButtonText = "Varrer" },
                { Kind = "Button", Setting = "CopyWorldReport", Id = "copy_world_report", Label = "Copiar relatório do mapa", Description = "Copia a coleta completa, incluindo assinaturas, pais, irmãos e filhos dos candidatos.", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "world_status", Label = "Nenhuma varredura", Description = "Portas, vidros e interações candidatas aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "world_report", Label = "Prévia do mapa", Description = "A prévia será preenchida depois da primeira coleta.", Height = 300 },
            },
        },
    },
}
