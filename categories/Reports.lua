return {
    Id = "Reports",
    Label = "Relatórios",
    Icon = "info",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Saída",
            Icon = "sliders",
            Controls = {
                { Kind = "Dropdown", Setting = "ReportDetail", Id = "report_detail", Label = "Nível de detalhe", Options = { "Resumido", "Detalhado" }, Default = "Detalhado", UseList = true },
                { Kind = "Button", Setting = "ScanAll", Id = "scan_all_reports", Label = "Atualizar relatório completo", Description = "Inclui jogadores, itens, interface e mapa. Estrutura, remotes e diff são coletados separadamente.", ButtonText = "Atualizar" },
                { Kind = "Button", Setting = "CopyReport", Id = "copy_report", Label = "Copiar relatório", Description = "Copia o texto completo quando o executor oferece área de transferência.", ButtonText = "Copiar" },
                { Kind = "Button", Setting = "PrintReport", Id = "print_report", Label = "Enviar ao console", ButtonText = "Imprimir" },
                { Kind = "Button", Setting = "ClearReport", Id = "clear_report", Label = "Limpar sessão", ButtonText = "Limpar" },
            },
        },
        {
            Title = "Último relatório",
            Icon = "overview",
            Controls = {
                { Kind = "Paragraph", Id = "report_status", Label = "Nenhum relatório disponível", Description = "Crie uma coleta para liberar a exportação.", Height = 68 },
                { Kind = "Paragraph", Id = "report_preview", Label = "Prévia", Description = "O conteúdo mais recente aparecerá aqui.", Height = 320 },
            },
        },
    },
}
