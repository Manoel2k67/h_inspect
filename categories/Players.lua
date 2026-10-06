return {
    Id = "Players",
    Label = "Jogadores",
    Icon = "users",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Inspeção individual",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "SelectedPlayer", Id = "selected_player", Label = "Jogador alvo", Description = "Abra a lista para atualizar os jogadores disponíveis. Meu personagem fica sempre no topo.", OptionsSource = "PlayerTargets", Default = "Meu personagem", UseList = true },
                { Kind = "Toggle", Setting = "InspectToolDescendants", Id = "inspect_tool_descendants", Label = "Detalhar ferramentas do alvo", Description = "Inclui scripts, valores, sons, animações e peças úteis de Knife, Fork e outras Tools.", Default = true },
                { Kind = "Button", Setting = "InspectSelectedPlayer", Id = "inspect_selected_player", Label = "Inspecionar jogador selecionado", Description = "Lê Player, Character, Humanoid, Backpack, atributos, valores, ferramentas e acessórios.", ButtonText = "Inspecionar" },
                { Kind = "Button", Setting = "CopySelectedPlayer", Id = "copy_selected_player", Label = "Copiar inspeção individual", Description = "Copia somente o relatório deste jogador, sem o snapshot completo.", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Resultado individual",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "selected_player_status", Label = "Nenhum jogador inspecionado", Description = "Escolha Meu personagem ou outro jogador e clique em Inspecionar.", Height = 68 },
                { Kind = "Paragraph", Id = "selected_player_report", Label = "Prévia individual", Description = "O relatório focado aparecerá aqui.", Height = 400 },
            },
        },
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
