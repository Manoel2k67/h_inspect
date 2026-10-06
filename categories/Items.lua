return {
    Id = "Items",
    Label = "Itens",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Mão, hotbar e mochila",
            Icon = "search",
            Controls = {
                { Kind = "Toggle", Setting = "IncludeToolDescendants", Id = "include_tool_descendants", Label = "Detalhar conteúdo dos itens", Description = "Inclui Handle, valores, animações, sons, scripts e objetos de rede dentro de cada Tool.", Default = true },
                { Kind = "Toggle", Setting = "IncludeAccessories", Id = "include_accessories", Label = "Incluir acessórios e objetos anexados", Description = "Ajuda quando o jogo representa um item na mão fora de uma Tool comum.", Default = true },
                { Kind = "Button", Setting = "ScanItems", Id = "scan_items", Label = "Varrer itens agora", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "items_status", Label = "Nenhuma varredura", Description = "Itens equipados e guardados aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "items_report", Label = "Prévia dos itens", Description = "A prévia será preenchida depois da primeira coleta.", Height = 320 },
            },
        },
    },
}
