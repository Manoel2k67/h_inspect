return {
    Id = "Explorer",
    Label = "Estrutura",
    Icon = "search",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Busca geral",
            Icon = "overview",
            Controls = {
                { Kind = "Dropdown", Setting = "StructureScope", Id = "structure_scope", Label = "Escopo", Options = { "Tudo relevante", "ReplicatedStorage", "Workspace", "PlayerGui", "Personagem" }, Default = "Tudo relevante", UseList = true },
                { Kind = "Input", Setting = "StructureFilter", Id = "structure_filter", Label = "Nome ou caminho", Placeholder = "role, glass, door, remote...", Default = "" },
                { Kind = "Slider", Setting = "MaxStructureResults", Id = "max_structure_results", Label = "Máximo de resultados", Min = 50, Max = 500, Default = 200, Step = 50 },
                { Kind = "Button", Setting = "ScanStructure", Id = "scan_structure", Label = "Varrer estrutura", Description = "Sem filtro, prioriza Values, Tools, remotes, módulos, prompts, tags e atributos.", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "structure_status", Label = "Nenhuma busca", Description = "Use palavras do jogo para localizar dados replicados.", Height = 68 },
                { Kind = "Paragraph", Id = "structure_report", Label = "Prévia da estrutura", Description = "A prévia será preenchida depois da busca.", Height = 340 },
            },
        },
    },
}
