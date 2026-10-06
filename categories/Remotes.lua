return {
    Id = "Remotes",
    Label = "Remotes",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Inventário de rede",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "RemoteScope", Id = "remote_scope", Label = "Escopo", Options = { "ReplicatedStorage", "Workspace", "Tudo replicado" }, Default = "ReplicatedStorage", UseList = true },
                { Kind = "Input", Setting = "RemoteFilter", Id = "remote_filter", Label = "Filtro do caminho", Placeholder = "GameStateUpdate, ReplicaSet, Notify...", Default = "" },
                { Kind = "Input", Setting = "RemotePayloadFilter", Id = "remote_payload_filter", Label = "Filtro dos argumentos", Placeholder = "glass, rope, bounty, reward...", Default = "" },
                { Kind = "Slider", Setting = "MaxRemoteResults", Id = "max_remote_results", Label = "Máximo de remotes", Min = 20, Max = 300, Default = 150, Step = 10 },
                { Kind = "Button", Setting = "ScanRemotes", Id = "scan_remotes", Label = "Varrer remotes", Description = "Lista RemoteEvent, UnreliableRemoteEvent e RemoteFunction sem chamar o servidor.", ButtonText = "Varrer" },
                { Kind = "Button", Setting = "CopyRemoteReport", Id = "copy_remote_report", Label = "Copiar inventário", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Eventos recebidos",
            Icon = "info",
            Controls = {
                { Kind = "Slider", Setting = "MaxRemoteLog", Id = "max_remote_log", Label = "Máximo de eventos no histórico", Min = 20, Max = 300, Default = 120, Step = 10 },
                { Kind = "Button", Setting = "StartRemoteMonitor", Id = "start_remote_monitor", Label = "Iniciar monitor passivo", Description = "Conecta pelos caminhos escolhidos e pode filtrar o conteúdo recebido sem enviar nada ao servidor.", ButtonText = "Iniciar" },
                { Kind = "Button", Setting = "StopRemoteMonitor", Id = "stop_remote_monitor", Label = "Parar monitor", ButtonText = "Parar" },
                { Kind = "Button", Setting = "CopyRemoteLog", Id = "copy_remote_log", Label = "Copiar eventos recebidos", ButtonText = "Copiar" },
                { Kind = "Button", Setting = "ClearRemoteLog", Id = "clear_remote_log", Label = "Limpar histórico", ButtonText = "Limpar" },
                { Kind = "Paragraph", Id = "remote_status", Label = "Monitor parado", Description = "Faça o inventário ou inicie a observação passiva.", Height = 72 },
                { Kind = "Paragraph", Id = "remote_report", Label = "Prévia dos remotes", Description = "Caminhos e eventos recebidos aparecerão aqui.", Height = 280 },
            },
        },
    },
}
