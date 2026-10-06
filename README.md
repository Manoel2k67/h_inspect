# H Inspect

Inspetor geral em Luau para coletar informações que o cliente Roblox recebeu. A base preserva o menu, pesquisa, favoritos, temas, janela arrastável e atalho por `RightShift`, sem carregar as antigas funções de combate, farm, teleporte ou alteração do jogador.

As operações do H Inspect são somente de leitura: ele não abre portas, não move o personagem, não dispara remotes e não altera objetos do jogo.

## O que é coletado

- **Jogadores:** nome, UserId, time, atributos, `ValueBase`, `leaderstats`, personagem e ferramentas.
- **Itens:** `Tool` equipada ou na mochila, `Handle`, `Grip`, textura, atributos, valores, animações, sons, scripts e objetos de rede internos.
- **Interface:** textos e imagens do `PlayerGui`, inclusive elementos invisíveis, com caminho, visibilidade, posição, tamanho, tags e atributos.
- **Mapa:** portas, saídas, prompts, detectores, vidros, pontes, peças de material `Glass` e pistas visuais como `Highlight`, `SelectionBox`, decal, textura, `SurfaceAppearance`, `Beam` e GUI de mundo.
- **Estrutura:** busca livre em `ReplicatedStorage`, `Workspace`, `PlayerGui` ou personagem. Sem filtro, prioriza Values, Tools, remotes, módulos, prompts, tags e atributos.
- **Comparação:** snapshot A e estado atual, destacando objetos adicionados, removidos ou alterados.
- **Sessão:** `PlaceId`, `GameId`, `JobId` e horário UTC.

Os relatórios podem ser vistos no menu, enviados ao console ou copiados quando o executor oferece `setclipboard`/`toclipboard`.

Na categoria **Jogadores**, a inspeção individual permite selecionar **Meu personagem** ou qualquer jogador do servidor. A lista destaca `GlassMaker`, `GlassVision`, Frontman e guardas quando esses sinais estão disponíveis. O relatório individual inclui atributos, Character, Humanoid, leaderstats, Backpack, Tools, acessórios e sinais anexados, e pode ser copiado separadamente sem gerar um snapshot completo.

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

1. Em **Comparar**, selecione **Vidros e mapa** e deixe o filtro vazio. Isso inclui nomes relacionados e peças cujo material é `Glass`.
2. Antes de receber a visão especial ou entrar na ponte, clique em **Salvar snapshot A**.
3. Quando o cargo de fabricante de vidro estiver ativo ou a ponte for carregada, clique em **Comparar**.
4. Procure mudanças em `Color`, `Material`, `Transparency`, `LocalTransparencyModifier`, colisão, tags e atributos, além de `Highlight`, decal, textura, `SelectionBox` ou `SurfaceGui`.
5. Repita em **Interface** com `fabricante`, `glass` e `vidro` para descobrir indicadores locais.

Se o servidor nunca replica a informação real/falso para o cliente, nenhum executor consegue lê-la diretamente. Se o fabricante recebe cor, destaque, atributo, valor ou interface local diferente, o snapshot deve revelar essa diferença.

## Categorias

1. **Início**
2. **Jogadores**
3. **Itens**
4. **Interface**
5. **Mapa**
6. **Estrutura**
7. **Comparar**
8. **Relatórios**
9. **Configurações**

## Arquitetura

```text
Loader.lua                    entrada pública direta e download do bundle
HInspect.lua                  janela, controles, navegação, temas e ciclo de vida
HInspectConfig.lua            identidade, tema, tamanho, atalhos e categorias
HInspectSchema.lua            contratos das definições
categories/                   páginas declarativas do inspetor
runtime/Inspector.lua         coleta, comparação e exportação
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
git commit -m "H Inspect 2.3.1 - inspeção individual"
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
