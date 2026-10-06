return {
    Id = "Home",
    Label = "Início",
    Icon = "home",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "H Inspect",
            Icon = "overview",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "welcome",
                    Label = "Base limpa para investigação",
                    Description = "Colete sinais visíveis no cliente — jogadores, itens, interface, mapa e estrutura replicada — antes de criar módulos específicos. Nenhuma ação é executada no jogo.",
                    Height = 72,
                },
                {
                    Kind = "Button",
                    Setting = "ScanAll",
                    Id = "scan_all_home",
                    Label = "Criar snapshot completo",
                    Description = "Varre jogadores, itens equipados, textos da interface, portas, interações e vidros.",
                    ButtonText = "Coletar",
                },
                {
                    Kind = "Paragraph",
                    Id = "home_status",
                    Label = "Aguardando coleta",
                    Description = "Use o snapshot completo ou abra uma categoria para fazer uma varredura direcionada.",
                    Height = 78,
                },
            },
        },
        {
            Title = "Fluxo recomendado",
            Icon = "info",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "workflow_help",
                    Label = "1. Colete a base  •  2. Mude de fase/cargo  •  3. Compare",
                    Description = "Para o fabricante de vidro, salve o snapshot A antes da informação aparecer e compare quando o cargo ou a fase estiver ativo. O diff destaca propriedades e textos alterados.",
                    Height = 72,
                },
            },
        },
    },
}
