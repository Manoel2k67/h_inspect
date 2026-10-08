# H Inspect

Inspetor geral em Luau para coletar informações que o cliente Roblox recebeu. A base preserva o menu, pesquisa, favoritos, temas, janela arrastável e atalho por `RightShift`, sem carregar as antigas funções de combate, farm, teleporte ou alteração do jogador.

As operações do H Inspect são somente de leitura: ele não abre portas, não move o personagem, não dispara remotes e não altera objetos do jogo.

## O que é coletado

- **Jogadores:** nome, UserId, time, atributos, `ValueBase`, `leaderstats`, personagem e ferramentas.
- **Itens:** `Tool` equipada ou na mochila, `Handle`, `Grip`, textura, atributos, valores, animações, sons, scripts e objetos de rede internos.
- **Interface:** textos e imagens do `PlayerGui`, inclusive elementos invisíveis, com caminho, visibilidade, posição, tamanho, tags e atributos.
- **Mapa:** portas, saídas, prompts, detectores, vidros, pontes, peças de material `Glass` e pistas visuais como `Highlight`, `SelectionBox`, decal, textura, `SurfaceAppearance`, `Beam` e GUI de mundo. A coleta agrupa objetos por assinatura e por pai/par, registra irmãos e filhos e pode ser copiada diretamente na aba.
- **Estrutura:** busca livre em `ReplicatedStorage`, `Workspace`, `PlayerGui` ou personagem. Sem filtro, prioriza Values, Tools, remotes, módulos, prompts, tags e atributos.
- **Remotes:** inventário de `RemoteEvent`, `UnreliableRemoteEvent` e `RemoteFunction`, além de monitor passivo de eventos recebidos por `OnClientEvent`. O inspetor não chama `FireServer` nem `InvokeServer`.
- **Combate:** captura guiada e passiva para comparar `Push`, soco e outras armas equipáveis. Registra equipamento, tentativas de ativação, `Tool.Enabled`, atributos, Values e, quando o executor permite, as chamadas `FireServer`/`InvokeServer` feitas pelo próprio jogo.
- **Bebê:** coleta guiada para soltar e pegar o bebê, reunindo estado local, eventos recebidos, objetos temporários próximos ao `dropBaby` e, quando o executor permite, observação passiva das chamadas que o próprio jogo envia durante o pickup.
- **Comparação:** snapshot A e estado atual, destacando objetos adicionados, removidos ou alterados.
- **Sessão:** `PlaceId`, `GameId`, `JobId` e horário UTC.

Os relatórios podem ser vistos no menu, enviados ao console ou copiados quando o executor oferece `setclipboard`/`toclipboard`.

Na categoria **Jogadores**, a inspeção individual permite selecionar **Meu personagem** ou qualquer jogador do servidor. A lista destaca `GlassMaker`, `GlassVision`, Frontman, guardas e o portador do bebê (`HasBaby`/`BabyType`) quando esses sinais estão disponíveis. O relatório individual inclui atributos, Character, Humanoid, leaderstats, Backpack, Tools, acessórios e sinais anexados, e pode ser copiado separadamente sem gerar um snapshot completo.

## Fluxo para cargos, itens e fabricante de vidro

### Descobrir cargos

1. Abra **Jogadores** e faça uma varredura.
2. Abra **Interface**, use filtros como `guarda`, `detetive`, `líder`, `fabricante`, `glass` ou `vidro` e faça novas varreduras em cada tela/fase.
3. Em **Estrutura**, pesquise os mesmos termos em **Tudo relevante** e depois diretamente em **ReplicatedStorage**.

Isso encontra tanto cargos salvos em atributos/time quanto cargos exibidos apenas pela interface local.

### Descobrir um item na mão ou no hotbar

1. Faça uma varredura em **Itens** antes de receber ou equipar o item.
2. Equipe o item e varra novamente.
3. Uma `Tool` dentro do personagem está equipada; dentro de `Backpack` está guardada/hotbar.
4. Use **Comparar → Jogador e itens** para ver exatamente o que entrou, saiu ou mudou.

### Comparar vidros reais e falsos

No Squid Game X, a estrutura observada fica em `Workspace.Map.Glass.Glasses`. Cada par possui dois lados, e a coleta confirmou esta regra para painéis intactos: `CanCollide=true` indica vidro real/seguro; `CanCollide=false` indica vidro falso/quebrável. `Size.Z` maior (`0.50+`) ou fino (`0.05`) serve como confirmação adicional. Um painel já quebrado pode ser movido para `Y=-11000` e perder o `TouchInterest`.

1. Em **Comparar**, selecione **Vidros e mapa** e deixe o filtro vazio. Isso inclui nomes relacionados e peças cujo material é `Glass`.
2. Antes de receber a visão especial ou entrar na ponte, clique em **Salvar snapshot A**.
3. Quando o cargo de fabricante de vidro estiver ativo ou a ponte for carregada, clique em **Comparar**.
4. Procure mudanças em `Color`, `Material`, `Transparency`, `LocalTransparencyModifier`, colisão, tags e atributos, além de `Highlight`, decal, textura, `SelectionBox` ou `SurfaceGui`.
5. Repita em **Interface** com `fabricante`, `glass` e `vidro` para descobrir indicadores locais.

Na aba **Mapa**, selecione **Vidros e ponte**, faça a varredura e use **Copiar relatório do mapa**. Os IDs `G001`, `G002` etc. representam grupos com as mesmas propriedades e filhos diretos. Se os painéis reais e falsos tiverem diferenças replicadas, eles devem aparecer em grupos distintos ou com contexto/filhos diferentes.

Essa regra é específica da estrutura atualmente observada no Squid Game X e deve ter fallback: se o caminho ou as propriedades mudarem, o menu deve parar de classificar e solicitar uma nova coleta, em vez de apresentar um resultado possivelmente incorreto.

## Categorias

1. **Início**
2. **Jogadores**
3. **Itens**
4. **Combate**
5. **Bebê**
6. **Interface**
7. **Mapa**
8. **Estrutura**
9. **Remotes**
10. **Comparar**
11. **Relatórios**
12. **Configurações**

## Captura guiada de Push, soco e armas

Faça uma coleta por ferramenta para o relatório não misturar mecanismos diferentes:

1. Na primeira fase, abra **Combate** e nomeie o teste, por exemplo `Push — Red Light/Green Light`.
2. Clique em **Iniciar antes de equipar**, equipe o `Push`, use uma vez e tente usar novamente enquanto ele ainda estiver em recarga.
3. Clique em **Analisar** e em **Copiar**.
4. Limpe a captura e repita com o soco ou outra arma equipável, usando outro nome.

O relatório relaciona cada clique/`Tool.Activated` com os remotes enviados logo depois. Se a segunda tentativa não enviar nada, o bloqueio acontece no cliente; se o mesmo remote for enviado novamente mas o golpe não funcionar, a validação provavelmente acontece no servidor. A captura não equipa, não ativa e não dispara remotes por conta própria.

## Coleta guiada do bebê

1. Abra **Bebê** enquanto ainda estiver carregando e clique em **Iniciar**.
2. Solte o bebê e pegue-o novamente da forma normal.
3. Clique em **Analisar** ou diretamente em **Copiar**.

O relatório combina `BabyAction`, mudanças de `SprintSpeed`, atributos e objetos do jogador, instâncias adicionadas/removidas no `Workspace` e uma varredura ao redor do `CFrame` de `dropBaby`. Quando `hookmetamethod` e `getnamecallmethod` estão disponíveis, também registra passivamente `FireServer` e `InvokeServer` executados pelo próprio jogo durante o teste. A coleta não dispara nenhuma dessas chamadas.

## Como coletar remotes

1. Abra **Remotes** e comece com o escopo **ReplicatedStorage**.
2. Para inventariar tudo, deixe **Filtro do caminho** vazio. Para reduzir a lista, use nomes de remotes, como `GameStateUpdate, GamemodeAction, ReplicaSet, ReplicaWrite, Notify, SafeTP`.
3. Clique em **Varrer remotes** e depois em **Copiar inventário**.
4. Para observar uma fase, deixe o caminho vazio ou selecione os remotes genéricos acima. Em **Filtro dos argumentos**, use termos da mecânica, como `glass, rope, bounty, reward, detective, door, fork, dinner`.
5. Execute normalmente a ação no jogo, como entrar na ponte, receber recompensa ou começar uma fase.
6. Clique em **Parar monitor** e depois em **Copiar eventos recebidos**.

O monitor registra caminho, horário e argumentos de mensagens `OnClientEvent` enviadas pelo servidor ao cliente. O filtro do caminho decide a quais eventos conectar; o filtro dos argumentos é aplicado depois que a mensagem chega. Ele lista `RemoteFunction`, mas não substitui `OnClientInvoke` e não intercepta chamadas feitas pelo cliente ao servidor. Filtros menores reduzem ruído e custo durante fases movimentadas.

## Arquitetura

```text
Loader.lua                    entrada pública direta e download do bundle
HInspect.lua                  janela, controles, navegação, temas e ciclo de vida
HInspectConfig.lua            identidade, tema, tamanho, atalhos e categorias
HInspectSchema.lua            contratos das definições
categories/                   páginas declarativas do inspetor
runtime/Inspector.lua         coleta, comparação e exportação
runtime/AttackCapture.lua     captura guiada de Push, soco e armas equipáveis
runtime/Baby.lua              investigação guiada de drop e pickup do bebê
runtime/Settings.lua          seleção do tema
theme/wallpapers/             assets opcionais dos temas
dist/HInspect.bundle.lua      artefato gerado usado no executor
tools/Build-Bundle.ps1        gerador determinístico do bundle
tools/Test-Project.ps1        validações de release, estrutura e sintaxe
```

## Build e validação

Depois de alterar qualquer módulo:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\Build-Bundle.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\Test-Project.ps1
```

Para validar também com o compilador oficial do Luau:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\Test-Project.ps1 `
  -LuauCompiler "C:\caminho\para\luau-compile.exe"
```

O bundle é gerado e não deve ser editado manualmente. Todos os textos permanecem em UTF-8 sem BOM.

## Publicar no GitHub

As URLs atuais usam o repositório público `Manoel2k67/h_inspect`, branch `main`.

```powershell
git init
git branch -M main
git add .
git commit -m "H Inspect 2.8.0 - captura guiada de combate"
git remote add origin https://github.com/Manoel2k67/h_inspect.git
git push -u origin main
```

Se o usuário ou nome do repositório for diferente, altere `REPOSITORIES` em `Loader.lua`. Confirme que estes endereços abrem como texto:

- `https://raw.githubusercontent.com/Manoel2k67/h_inspect/main/VERSION`
- `https://raw.githubusercontent.com/Manoel2k67/h_inspect/main/dist/HInspect.bundle.lua`

## Rodar no executor

O carregamento é direto. Não existe chave, senha, API de licença ou tela de validação:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Manoel2k67/h_inspect/main/Loader.lua", true))()
```

O `Loader.lua` lê a versão publicada, tenta GitHub Raw e jsDelivr, baixa o bundle e abre o H Inspect imediatamente.
