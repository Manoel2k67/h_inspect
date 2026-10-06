return {
    Id = "Players",
    Label = "Jogadores",
    Icon = "users",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Coleta de jogadores",
            Icon = "users",
            Controls = {
                { Kind = "Toggle", Setting = "IncludePlayerAttributes", Id = "include_player_attributes", Label = "Incluir atributos e valores", Description = "Procura sinais como role, cargo, class, team, status e valores do leaderstats.", Default = true },
                { Kind = "Toggle", Setting = "IncludePlayerTools", Id = "include_player_tools", Label = "Incluir ferramentas", Description = "Lista Tools no personagem e na mochila; os detalhes completos ficam em Itens.", Default = true },
                { Kind = "Toggle", Setting = "LivePlayerScan", Id = "live_player_scan", Label = "Atualização automática", Description = "Repete a coleta de jogadores no intervalo selecionado.", Default = false },
                { Kind = "Slider", Setting = "ScanInterval", Id = "scan_interval", Label = "Intervalo da atualização", Min = 2, Max = 15, Default = 5, Step = 1 },
                { Kind = "Button", Setting = "ScanPlayers", Id = "scan_players", Label = "Varrer jogadores agora", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "players_status", Label = "Nenhuma varredura", Description = "Os possíveis sinais de cargo aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "players_report", Label = "Prévia dos jogadores", Description = "A prévia será preenchida depois da primeira coleta.", Height = 280 },
            },
        },
    },
}
