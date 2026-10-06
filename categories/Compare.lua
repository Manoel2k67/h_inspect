return {
    Id = "Compare",
    Label = "Comparar",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Snapshot A → estado atual",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "SnapshotScope", Id = "snapshot_scope", Label = "Escopo do snapshot", Options = { "Tudo relevante", "Vidros e mapa", "Interface", "Jogador e itens" }, Default = "Tudo relevante", UseList = true },
                { Kind = "Input", Setting = "SnapshotFilter", Id = "snapshot_filter", Label = "Filtro opcional", Placeholder = "glass, bridge, fabricante...", Default = "" },
                { Kind = "Slider", Setting = "SnapshotLimit", Id = "snapshot_limit", Label = "Limite de objetos", Min = 500, Max = 10000, Default = 5000, Step = 500 },
                { Kind = "Button", Setting = "CaptureBaseline", Id = "capture_baseline", Label = "Salvar snapshot A", Description = "Faça isto antes de mudar de cargo, receber o item ou entrar na fase da ponte.", ButtonText = "Salvar A" },
                { Kind = "Button", Setting = "CompareSnapshot", Id = "compare_snapshot", Label = "Comparar com o estado atual", Description = "Mostra objetos adicionados, removidos e propriedades alteradas.", ButtonText = "Comparar" },
                { Kind = "Button", Setting = "ClearBaseline", Id = "clear_baseline", Label = "Apagar snapshot A", ButtonText = "Apagar" },
            },
        },
        {
            Title = "Diferenças",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "compare_status", Label = "Snapshot A não salvo", Description = "Escolha o escopo e salve uma base primeiro.", Height = 68 },
                { Kind = "Paragraph", Id = "compare_report", Label = "Prévia das diferenças", Description = "Mudanças relevantes aparecerão aqui.", Height = 360 },
            },
        },
    },
}
