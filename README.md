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
KeySystem.lua                 entrada pública, chave e download do bundle
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

As URLs atuais esperam um repositório público chamado `Manoel2k67/hinspect`, branch `main`.

```powershell
git init
git branch -M main
git add .
git commit -m "H Inspect 2.1.0"
git remote add origin https://github.com/Manoel2k67/hinspect.git
git push -u origin main
```

Se o usuário ou nome do repositório for diferente, altere `REPOSITORIES` em `KeySystem.lua` e os exemplos abaixo antes de publicar. Confirme que estes endereços abrem como texto:

- `https://raw.githubusercontent.com/Manoel2k67/hinspect/main/VERSION`
- `https://raw.githubusercontent.com/Manoel2k67/hinspect/main/dist/HInspect.bundle.lua`

## Rodar no executor

### Teste direto, sem chave

Use durante o desenvolvimento, depois que os arquivos estiverem no GitHub:

```lua
local repositories = {
    "https://raw.githubusercontent.com/Manoel2k67/hinspect/main/",
    "https://cdn.jsdelivr.net/gh/Manoel2k67/hinspect@main/",
}

local version = game:HttpGet(repositories[1] .. "VERSION?dev=" .. tostring(os.time()), true)
    :match("^%s*(%d+%.%d+%.%d+)%s*$")
assert(version, "VERSION inválida")
_G.__HINSPECT_RELEASE_VERSION = version

local source = game:HttpGet(repositories[1] .. "dist/HInspect.bundle.lua?v=" .. version, true)
local chunk, compileError = loadstring(source, "@HInspect/dist/HInspect.bundle.lua")
assert(chunk, compileError)
local bundle = chunk()
return bundle:Create({ AssetBaseUrls = repositories, AssetVersion = version })
```

### Carregamento com chave

Depois de cadastrar o produto `h-inspect` no backend de licenças:

```lua
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Manoel2k67/hinspect/main/KeySystem.lua",
    true
))()
```

O `KeySystem.lua` usa o slug `h-inspect`. Chaves do produto antigo não funcionarão até esse novo produto existir no backend. Confirme também `LICENSE_API_URL` e `GET_KEY_URL` antes da primeira release pública.

Um bundle público sempre pode ser baixado diretamente. O sistema de chave serve como controle de acesso do carregador, não como proteção absoluta do código cliente; nunca coloque segredos no script ou no repositório.
