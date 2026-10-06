# H Inspect — Dossiê do Squid Game X

Este documento reúne o que o **H Inspect** conseguiu observar no jogo **Squid Game X** e transforma a coleta bruta em uma referência para desenvolver menus específicos depois.

> Estado atual: análise em andamento, com **dois snapshots únicos**. Os dois primeiros arquivos enviados eram cópias idênticas; o relatório de `15:53:09Z` é uma nova amostra. As coletas mostram estados do Red Light, Green Light e áreas comuns, mas ainda não contêm as peças da ponte de vidro.

## Identificação da amostra

| Amostra | UTC | PlaceId | JobId | Destaque |
|---|---|---|---|---|
| A | `2026-10-06T15:46:00Z` | `7559074529` | `44d99d26-74eb-445c-8854-df3ccb9b77e5` | `Workspace.Map.RedLightGreenLight` carregado |
| B | `2026-10-06T15:53:09Z` | `7559074529` | `083a3d85-b7c4-4abb-b2b4-4980c119b7c8` | Glass Maker, Frontman/Officer, armas e evidências do detetive |
| C | `2026-10-06T16:09:10Z` | `7559074529` | `083a3d85-b7c4-4abb-b2b4-4980c119b7c8` | Fase Glass ativa e estado especial do Frontman |

O `GameId` permaneceu `2936053166` e o `SourcePlaceId` observado nos jogadores permaneceu `7554888362`.

O `SourcePlaceId` provavelmente aponta para o lobby ou lugar anterior do universo, mas isso ainda precisa ser confirmado em outra coleta.

## Legenda de confiança

- **Confirmado:** apareceu diretamente no relatório, com caminho, atributo ou valor observável.
- **Provável:** interpretação forte baseada no nome e no contexto, mas que ainda precisa de comparação.
- **Desconhecido:** o relatório atual não contém evidência suficiente.

## Como o jogo parece organizar os cargos

O jogo usa uma combinação de `Team`, atributos no objeto `Player`, ferramentas e elementos de interface. Para detectar cargos de forma estável, é melhor usar vários sinais juntos em vez de depender apenas da roupa ou da posição do personagem.

| Cargo/capacidade | Evidências observadas | Confiança |
|---|---|---|
| Jogador comum | `Team="Player"`, `PlayingRLGL=true` e ferramenta `Push` | Confirmado |
| Guarda | `Team="Guard"`, `IsGuard=true`, `GuardRank` e `ChatTag` | Confirmado |
| Guarda Círculo | `GuardRank="Circle"`, `ChatTag="CIRCLE GUARD"` | Confirmado |
| Guarda Triângulo | `GuardRank="Triangle"`, `ChatTag="TRIANGLE GUARD"` | Confirmado |
| Frontman/Officer | `IsFrontman=true` como sinal principal; `GlassVision` e estados `FRONTMAN_*` como sinais adicionais | Confirmado; time e atributos de guarda variam por fase |
| Visão de vidro | `GlassVision=true` | Atributo confirmado; efeito exato ainda provável |
| Glass Maker | `GlassMaker=true` em um único jogador e UI `Main.Chances.Glassmaker` | Identificação do sorteado confirmada; somente ele vê os vidros na final |
| Detetive | Interface `PlayerGui.DetectivePick.DetectivePick` e evidências em `Workspace.Data.Detective` | Mecânica confirmada; atributo do jogador desconhecido |

### Guardas encontrados

Foram observados vários exemplos úteis:

- Guarda Círculo: `Team="Guard"`, `IsGuard=true`, `GuardRank="Circle"`, `LockerRoom="Room2"`, `SafeCharacter=true` e item `MPS-5`.
- Guarda Triângulo: `Team="Guard"`, `IsGuard=true`, `GuardRank="Triangle"`, `LockerRoom="Room4"`, `SafeCharacter=true` e item `MPS-5`.
- Officer/Frontman: `Team="Guard"`, `IsGuard=true`, `GuardRank="Officer"`, `IsFrontman=true`, `ChatTag="FRONTMAN"` e item `Revolver`.
- A arma exposta no personagem possui `WeaponType="BulletWeapon"`.

Na segunda amostra, guardas Círculo apareceram nos quartos `Room1`, `Room4` e `Room7`; na primeira, outro estava em `Room2`. Portanto, `LockerRoom` parece ser uma alocação de quarto, não um identificador confiável de patente. (editado pelo Manoel criador das analises> Isso mesmo o room é um quarto onde o guarda spawna.)

Também existem dados de progressão de cargo na interface local:

```text
Players.Manoel2k67.PlayerGui.Main.Chances.GuardRank.Current
  Text = "Role: Circle Guard"

Players.Manoel2k67.PlayerGui.Main.Chances.GuardRank.Label
  Text = "Next Role: 40/100 (Triangle Guard)"
```

Esses elementos estavam ocultos no momento da coleta, mas ainda existem no cliente.

### Frontman e visão de vidro

Na primeira amostra, um jogador observado tinha simultaneamente:

```text
Team = "Player"
IsFrontman = true
FRONTMAN_RLGL = true
FRONTMAN_RLGL_COOLDOWN = 0
GlassVision = true
```

Na segunda amostra, os sinais ficaram mais claros:

```text
Jogador 1: GlassMaker = true; Team = "Player"
Jogador 2: GlassVision = true; Team = "Player"
Frontman:  GlassVision = true; GlassMaker não apareceu
```

Isso confirma que `GlassMaker` e `GlassVision` são atributos distintos. Conforme a regra do jogo confirmada pelo jogador que fez a coleta, somente um participante é sorteado como fabricante de vidro e somente ele pode enxergar os vidros na final.

A interpretação mais consistente dos dois atributos é:

| Sinal | Função |
|---|---|
| `GlassMaker=true` | Identidade persistente do único jogador sorteado na rodada |
| `GlassVision=true` | Permissão/capacidade de visão especial quando disponível |

Na coleta feita antes da final, o Glass Maker já tinha `GlassMaker=true`, mas não expunha `GlassVision`. Isso sugere que a visão pode ser ativada somente quando a ponte começa. O Frontman e outro jogador possuíam `GlassVision` sem `GlassMaker`, então `GlassVision` não deve ser usado sozinho para identificar quem foi sorteado.

Uma inspeção posterior do Frontman durante a fase Glass confirmou:

```text
Team = "Player"
IsFrontman = true
GlassVision = true
PlayingGlass = true
FRONTMAN_GLASS_PAIR_SELECTION = 10
GlassMaker = ausente
IsGuard/GuardRank = ausentes nessa amostra
```

Portanto, `IsFrontman=true` deve ser o detector principal. `Team="Guard"`, `IsGuard`, `GuardRank="Officer"` e `ChatTag="FRONTMAN"` apareceram em outra amostra, mas não são garantidos em todas as fases.

Esse Frontman tinha `150/150` de vida, `JumpHeight=10.2` e `WalkSpeed=12`, enquanto o Glass Maker inspecionado anteriormente tinha `100/100`, `JumpHeight=7.2` e a mesma velocidade. Isso indica bônus de vida e pulo associado ao Frontman nessa amostra.

Também estavam simultaneamente presentes `PlayingGlass=true`, `PlayingRLGL=true`, `FRONTMAN_RLGL=true` e `HONEYCOMB_SHAPE="Triangle"`. Alguns atributos de fases anteriores permanecem no jogador; o menu não deve considerar `PlayingRLGL` ou o prefixo da habilidade isoladamente como prova da fase atual. Quando `PlayingGlass=true`, ele é o sinal mais específico para a ponte.

Segundo a observação direta da rodada, o Glass Maker é sorteado no lobby principal, antes da primeira partida. Uma inspeção individual feita posteriormente, durante Red Light, Green Light, confirmou que esse estado permanece no jogador:

```text
Player.GlassMaker = true
Player.PlayingRLGL = true
GlassVision = ausente

Workspace.<jogador>.Head.Glassmaker
class = BillboardGui
enabled = true
size = {7.5, 1}, {1.5, 1}
studsOffset = (0.00, 5.00, 0.00)
tags = {HideFromPlayer}
```

Portanto, o Glass Maker é definido no lobby e pode ser detectado antes mesmo do início dos minigames. O atributo continua presente durante Red Light, Green Light. O `BillboardGui` fornece um segundo sinal além do atributo. A tag `HideFromPlayer` sugere que o jogo controla quem pode enxergar esse marcador, mas seu significado exato ainda precisa ser testado.

O personagem inspecionado tinha estatísticas normais (`100/100` de vida e `WalkSpeed=12`), indicando que o cargo não aplicava bônus físico evidente naquele momento.

O melhor momento para investigar a atribuição do cargo é no lobby: salvar um snapshot antes do sorteio, comparar imediatamente depois e inspecionar o jogador marcado antes do teleporte para a primeira partida. Isso pode revelar o evento, interface ou objeto que concede `GlassMaker=true`.

A estrutura da interface também contém missões de Battle Pass específicas:

```text
Players.Manoel2k67.PlayerGui.Main.BattlepassQuests.PossibleQuests.ScrollingFrame.GlassmakerWin
Players.Manoel2k67.PlayerGui.Main.BattlepassQuests.PossibleQuests.ScrollingFrame.KillTheGlassmaker
```

Os textos visíveis indicam objetivos de vencer como Glass Maker e matar o Glass Maker durante a parte final. Isso reforça que o cargo permanece relevante até a final, mas esses elementos são apenas missões da interface e não revelam a lógica dos painéis.

A interface também contém:

```text
Players.Manoel2k67.PlayerGui.Main.Chances.Glassmaker.Label
  Visible = true
  Text observado = "Glass Maker Luck: 1%" e, depois, "Glass Maker Luck: 3%"

Players.Manoel2k67.PlayerGui.BuyExtraLife.BuyExtraLife.Screen.Frontman.Use.UseText
  Text = "Continue as the FRONTMAN"
```

### Detetive

Nenhum jogador do snapshot foi confirmado como detetive. Porém, o cliente contém a escolha narrativa:

```text
Players.Manoel2k67.PlayerGui.DetectivePick.DetectivePick
```

Texto observado:

```text
The players are staging an escape. You are trapped on the island.
What do you want to do?

Yes: Betray your brother and help them!
No:  Join forces with your brother and stop them!
```

Isso indica dois caminhos possíveis para o detetive, mas os atributos que representam cada escolha ainda são desconhecidos.

A segunda amostra revelou 15 evidências geradas em caminhos como:

```text
Workspace.Data.Detective.Evidence.Instances.<UUID>.PPart.ProximityPrompt
```

Cada prompt observado tinha ação `Collect`, distância `4` e estava `Enabled=false` para o jogador local. Isso confirma uma mecânica de coleta de evidências. O uso de UUIDs indica que o código futuro deve enumerar `Instances` dinamicamente, sem salvar os nomes encontrados no snapshot.

## Mapas das fases

Cada minigame fica em um modelo próprio dentro de `Workspace.Map`:

| Fase | Caminho | Confiança |
|---|---|---|
| Red Light, Green Light | `Workspace.Map.RedLightGreenLight` | Confirmado |
| Ponte de vidro | `Workspace.Map.Glass` | Confirmado |
| Cadeiras Musicais | `Workspace.Map.MusicalChairs` | Confirmado |

## Red Light, Green Light

A fase estava em:

```text
Workspace.Map.RedLightGreenLight
```

Estados relevantes encontrados nos jogadores:

| Atributo | Interpretação de trabalho |
|---|---|
| `PlayingRLGL` | Participando da fase |
| `IsInsideRLGL` | Jogador local dentro da área/estado da fase |
| `RLGL_IsSafe` | Jogador em condição segura |
| `RLGL_WINNERS` | Marcado como vencedor/concluiu a etapa |
| `RLGL_HitTracker` | Registro de penalidade ou acerto |
| `SPEED_DEBUFF` | Penalidade de velocidade |
| `Protection` | Proteção genérica |
| `RedLightProtection` | Proteção específica dessa fase |
| `Protected` | Outro marcador de proteção |
| `FRONTMAN_RLGL` | Estado especial do Frontman nessa fase |
| `FRONTMAN_RLGL_COOLDOWN` | Recarga da habilidade correspondente |
| `PlayingGlass` | Participando da fase da ponte de vidro |
| `GlassVision` | Tem visão especial dos vidros |
| `FRONTMAN_GLASS_PAIR_SELECTION` | Índice do par selecionado pelo Frontman na ponte |

Os nomes dos atributos são confirmados. A descrição funcional é uma interpretação e deve ser validada observando quando cada valor muda.

## Itens, mão e hotbar

### Resumo rápido dos itens

| Item | Quem usa | Onde aparece | Dados |
|---|---|---|---|
| `Push` | Jogador comum | `Backpack` ou `Character` | - |
| `MPS-5` | Guardas | `Character` dos guardas | `AmmoCapacity=30`, `HitDamage=10`, `Automatic` |
| `Revolver` | Frontman/Officer | `Backpack` ou `Character` | `AmmoCapacity=6`, `HitDamage=40` |
| `Fork` | Fase do jantar | `Backpack` ou `Character` | - |

Regra de item equipado versus guardado:

- `Players.<nome>.Backpack.<Tool>` → guardado na mochila.
- `Workspace.<nome>.<Tool>` → equipado na mão.

O relatório distingue item guardado de item equipado pelo pai da ferramenta:

- Em `Players.<nome>.Backpack.<Tool>`: item na mochila/hotbar, não equipado.
- Em `Workspace.<nome>.<Tool>` ou no `Character`: item atualmente equipado.

### Push

Ferramenta comum dos jogadores:

```text
Players.Manoel2k67.Backpack.Push
Players.Manoel2k67.Backpack.Push.Script
Players.Manoel2k67.Backpack.Push.whoosh
```

Som observado:

```text
SoundId = "rbxassetid://3755636638"
Tags = {GamemodeSound, Sound}
```

Na amostra, o `Push` do jogador local estava no `Backpack`. Em outros jogadores, quando apareceu dentro do personagem, estava equipado.

### MPS-5

Usada pelos guardas:

```text
Workspace.<guarda>.MPS-5
Workspace.<guarda>.MPS-5.WeaponType = "BulletWeapon"
```

Configuração observada na segunda amostra:

| Propriedade | Valor |
|---|---|
| `AmmoCapacity` | `30` |
| `FireMode` | `Automatic` |
| `HitDamage` | `10` |
| `ShotCooldown` | `0.2` |
| `MaxSpread` | `0.6` |
| `Handling` | `-2` |

### Revolver

O Officer/Frontman carregava:

```text
Players.<frontman>.Backpack.Revolver
WeaponType = "BulletWeapon"
IsGun = true
```

| Propriedade | Valor |
|---|---|
| `AmmoCapacity` | `6` |
| `CurrentAmmo` no snapshot | `4` |
| `HitDamage` | `40` |
| `ShotCooldown` | `0.75` |
| `MaxSpread` | `2` |
| `Handling` | `0` |

Esses valores são configuração exposta no cliente e podem mudar em futuras versões do jogo.

Para menus futuros, o detector de item deve informar pelo menos: nome, dono, classe, caminho, equipado ou guardado e atributos/filhos relevantes.

## Portas de forma e rotas

Foram encontrados acessos diretos por forma:

```text
Workspace.Data.DoorAccess.Square+.TouchInterest
Workspace.Data.DoorAccess.Triangle+.TouchInterest
```

Esses caminhos são a melhor evidência atual para portas liberadas por cargo/formato. `TouchInterest` representa um `TouchTransmitter`, ou seja, a interação parece ocorrer por toque/contato.

Ainda falta descobrir:

- se existe `Circle+` ou se o Guarda Círculo usa outra regra;
- qual porta física corresponde a cada acesso;
- se o sinal `+` indica nível mínimo, grupo de cargos ou uma variante de acesso;
- quais portas fazem parte da rota de fuga.

Não é recomendado salvar coordenadas fixas enquanto houver um caminho de instância confiável. Coordenadas quebram facilmente quando o mapa é recriado ou movido.

## Outras interações do mapa

| Função | Caminho/sinal confirmado |
|---|---|
| Abrir elevador da ilha | `Workspace.Data.Elevator.Island.OpenDoorPrompt.ProximityPrompt` |
| Abrir elevador por fora | `Workspace.Data.Elevator.Island.OpenDoorPromptOutside.ProximityPrompt` |
| Abrir elevador do lobby | `Workspace.Data.Elevator.Lobby.OpenDoorPrompt.ProximityPrompt` |
| CCTV | `Workspace.Data.CCTV.Prompts.Part.ProximityPrompt` com ação `Watch CCTV` |
| Incineração | `Workspace.Data.IncinerationRoom.Burn.Burn` com ação `Interact` |
| Pegar caixão | `Workspace.Data.IncinerationRoom.PickupCoffins.Coffin1..7.Main.Pickup` com ação `Pick Up` |
| Pegar sniper | `Workspace.Map.RedLightGreenLight.SniperRoom.Bags.Bag.ProximityPrompt` com ação `Pickup Sniper` |
| Trocar roupa de guarda | `Workspace.Data.WardrobeTriggers.OpenGuardWardrobe.ProximityPrompt` |
| Carregar jogador | `Workspace.<jogador>.HumanoidRootPart.CarryPrompt` com ação `Carry` |
| Abrir armaria | `Workspace.Data.GuardQuarters.Armoury`, prompt com ação `Open Armoury` |

No guarda-roupa, a ação observada foi `Switch Guard Skin`, com tags `DetectiveDisabled` e `GuardSkinSwitchPrompt`. A tag `DetectiveDisabled` pode ajudar a entender restrições do detetive, mas seu efeito ainda não foi testado.

O `CarryPrompt` observado estava `Enabled=false`, com distância `5`, tempo de pressão `0.2` e tag `CarryPrompt`. Como só há uma inspeção individual desse sinal, ele não deve ser associado exclusivamente ao Glass Maker; provavelmente é uma interação geral de personagens.

## Área dos guardas

Os dados dos alojamentos ficam em:

```text
Workspace.Data.GuardQuarters
```

| Elemento | Caminho/sinal | Confiança |
|---|---|---|
| Quartos | `Room1` até `Room10` dentro de `GuardQuarters` | Confirmado |
| Armaria | `Workspace.Data.GuardQuarters.Armoury` | Confirmado |
| Prompt da armaria | ação `Open Armoury`, com a tag `DetectiveDisabled` | Confirmado |

- Os quartos correspondem ao atributo `LockerRoom` do guarda (`Room1`..`Room10`): é o quarto onde o guarda nasce.
- A tag `DetectiveDisabled` também aparece no guarda-roupa (`Switch Guard Skin`). Isso sugere que o Detetive não pode usar essas interações, mas o efeito ainda não foi testado.

## Descobertas das buscas em Estrutura

As pesquisas específicas feitas na mesma sessão da amostra B trouxeram alguns caminhos adicionais.

### Filtro `role`

A busca retornou apenas quatro resultados, incluindo:

```text
Players.Manoel2k67.PlayerGui.Main.Chances.GuardRank.Current
Players.Manoel2k67.PlayerGui.Main.Chances.GuardRank.Label
Players.Manoel2k67.PlayerGui.Main.FrontmanSelection.Bottom
ReplicatedStorage.Remotes.BuyPermanentRole
```

`BuyPermanentRole` é um `RemoteEvent`. Pelo nome, ele parece pertencer à compra de cargos permanentes, e não necessariamente ao sorteio ou à aplicação do cargo durante uma rodada. Não deve ser tratado como remote principal dos cargos sem uma comparação antes/depois.

### Filtro `door`

A busca encontrou 401 resultados. Entre os primeiros caminhos úteis estavam:

```text
ReplicatedStorage.Armoury.armrydoor
ReplicatedStorage.Armoury.armrydoor.Cube.008
ReplicatedStorage.Armoury.armrydoor.Cube.009
ReplicatedStorage.Kitchen.EntryDoor1
ReplicatedStorage.Kitchen.EntryDoor.Closed
```

Isso confirma que existem modelos de portas armazenados em `ReplicatedStorage`, incluindo a porta da armaria e estados/modelos da entrada da cozinha. Como a busca também retorna centenas de peças geométricas, o próximo passo deve ser filtrar separadamente `armrydoor`, `EntryDoor`, `DoorAccess` e o nome da área desejada.

### Filtro `player`

O filtro retornou mais de 7.800 resultados porque quase tudo sob `Players.Manoel2k67.PlayerGui` contém `Players` no caminho. A maior parte é interface, inclusive componentes do próprio H Inspect, e não representa dados de jogadores. Para essa finalidade, use a categoria **Jogadores** ou filtros específicos como `GlassMaker`, `GlassVision`, `GuardRank`, `IsFrontman` e `IsGuard`.

### Nova coleta de itens

A tela de itens encontrou 20 ferramentas e 34 acessórios/objetos anexados. Nos resultados visíveis, `Push` continuou aparecendo no `Backpack` de jogadores comuns. Não surgiu uma nova ferramenta especial nessa prévia; `Revolver` e `MPS-5` continuam sendo as descobertas específicas de cargos mais importantes.

## Ponte de vidro

As amostras atuais **não contêm as peças da ponte**. A busca de Interface por `glass` encontrou 24 elementos, mas eles são principalmente a chance do Glass Maker e telas/gamepasses; ela não examina os painéis físicos do mapa. Por isso ainda não é possível indicar com segurança:

- qual propriedade diferencia vidro real e falso;
- nomes e caminhos dos painéis;
- se a diferença está em atributo, tag, material, transparência, colisão ou script;
- como `GlassVision` altera as peças ou a interface;
- se a solução fica em `Workspace`, `ReplicatedStorage` ou é criada dinamicamente.

Os principais ganchos já encontrados são:

```text
GlassMaker = true
GlassVision = true
```

Na implementação futura, o menu deve mostrar os dois separadamente: **Fabricante sorteado** com base em `GlassMaker` e **Visão especial ativa** com base em `GlassVision`.

O filtro automático de mapa também classificou alguns modelos de guardas como `vidro/ponte`, apesar de os resultados exibidos serem personagens. Isso deve ser tratado como ruído causado por algum descendente correspondente ao filtro, não como peça da ponte.

### Amostra C — fase Glass ativa

A terceira amostra confirmou `PlayingGlass=true` nos participantes vivos da ponte. Esse é o melhor sinal de fase encontrado até agora.

O Frontman expôs um novo atributo:

```text
GlassVision = true
FRONTMAN_GLASS_PAIR_SELECTION = 10
```

`FRONTMAN_GLASS_PAIR_SELECTION` provavelmente representa o índice de um par selecionado pela mecânica do Frontman. O valor `10` não deve ser interpretado como lado seguro ou sequência da ponte sem uma comparação durante a interação.

A captura de mapa feita segundos antes do snapshot mostrou muitos resultados sob:

```text
Workspace.Data.Stairs.WorkspaceContainer.GlassGuard_Red.Animator.Touch.TouchInterest
```

Esse caminho confirma um modelo/controlador chamado `GlassGuard_Red` com interação por toque, mas não identifica os painéis reais ou falsos. A grande quantidade de resultados repetidos provavelmente veio de muitos descendentes dentro do mesmo modelo.

No snapshot completo de `16:09:10Z`, a seção `MAPA — Vidros e ponte` retornou `Candidatos: 0`. Portanto, a estrutura observada segundos antes pode ter sido removida ou alterada durante a transição/final da fase. O relatório não preservou as peças da ponte.

O jogador que tinha `GlassMaker=true` na amostra B não estava mais entre os 11 jogadores da amostra C. Assim, ainda não existe uma captura simultânea do fabricante e dos painéis.

A interface mostrou novamente a chance dinâmica:

```text
Glass Maker Luck: 9%
```

Já foram observados `1%`, `3%` e `9%`, reforçando que esse número não é constante.

### Coleta recomendada para descobrir os vidros

Na versão 2.4.0, a aba **Mapa** possui **Copiar relatório do mapa** e agrupa candidatos por assinatura (`G001`, `G002`...), pai/par, posição ordenada entre irmãos e filhos diretos. Isso permite comparar painéis sem depender de screenshots ou da prévia truncada.

1. Entrar na fase da ponte com um jogador comum.
2. Antes de pisar, salvar um snapshot de **Mapa** usando os filtros `glass`, `bridge`, `tile`, `panel` e `pane`.
3. Salvar uma varredura de **Estrutura** em `ReplicatedStorage` com os mesmos filtros.
4. Se possível, salvar o estado no Comparar como amostra A.
5. Repetir como Glass Maker ou com `GlassVision=true` e salvar a amostra B.
6. Comparar atributos, tags, cores, materiais, transparência, colisão, nomes e filhos de cada painel.
7. Coletar novamente depois que um vidro quebrar para identificar a mudança de estado.

Para essa fase, aumente o limite da coleta de mapa para cerca de 200 resultados. O relatório atual exibiu apenas os primeiros 80 candidatos de 489, então objetos importantes podem ter ficado fora do texto.

## Jump Rope — fase da corda

Uma busca por `rope` confirmou que a fase possui interface própria:

```text
Players.Manoel2k67.PlayerGui.JumpRopeUI
Players.Manoel2k67.PlayerGui.JumpRopeUI.Info
Players.Manoel2k67.PlayerGui.JumpRopeUI.LocalScript
Players.Manoel2k67.PlayerGui.JumpRopeUI.Timer
```

O texto observado em `JumpRopeUI.Info` seguia o formato:

```text
You are in Position: #1. Waiting time: 0:00
```

Em outra coleta, a mesma informação apareceu localizada na tela:

```text
está em Posição: #6, Tempo de Espera: 00:16
```

Isso confirma dois valores úteis para um módulo da fase: **posição na fila** e **tempo de espera**. Como o idioma pode variar, o código deve priorizar o caminho `JumpRopeUI.Info` e extrair os números, sem depender apenas das palavras em inglês ou português.

Também existe um contador visual em `JumpRopeUI.Timer`. Isso permite que um menu futuro detecte a interface da fase, posição na fila e tempo exibido.

A busca genérica retornou 2.576 resultados porque `RopeConstraint` é usado em muitos modelos que não pertencem necessariamente à fase, inclusive objetos em `ReplicatedStorage.Maps.HoneycombMapSwings`. Portanto, `RopeConstraint` sozinho não identifica a corda principal.

Nas próximas coletas dessa fase, use filtros mais específicos:

```text
JumpRope
JumpRopeUI
Jump Rope
Position:
Waiting time
```

Também é útil comparar a estrutura antes da fase, durante a espera e enquanto a corda está girando. Isso pode revelar o modelo principal, atributos de velocidade, direção, contador de pulos e estados de eliminação.

### Estado dos itens durante a corda

Uma coleta feita durante a espera encontrou:

```text
0 Tools | 29 acessórios/objetos anexados
```

O `Push` não estava presente, embora apareça normalmente em outras fases. Isso sugere que as ferramentas são removidas ou desabilitadas na fila/fase da corda. Um futuro menu não deve interpretar a ausência de `Push` nesse momento como falha do detector.

Para investigar o mapa da corda, use o foco **Tudo** ou **Interações**. O foco **Vidros e ponte** não é adequado para essa fase.

### Falsos positivos relacionados a vidro

Durante a fase da corda, a varredura de mapa classificou acessórios como `Y2K Cyberstar Glasses` na categoria de vidro/ponte porque o nome contém `Glasses`. Esses resultados são acessórios de avatar e devem ser ignorados.

Uma varredura posterior repetiu o problema com 70 candidatos, incluindo acessórios `NerdGlasses`. Portanto, resultados sob `Workspace.<jogador>.<acessório>` devem ser descartados pelo futuro analisador de ponte, mesmo quando o nome contém `glass`.

O caminho abaixo também apareceu:

```text
Workspace.Stairs.gm.TPs.Glass
```

Pelo contexto e pelo trecho `TPs`, ele provavelmente representa um destino/teleporte para a fase Glass, não um painel real ou falso da ponte. Essa interpretação ainda deve ser confirmada.

## Jantar e combate com garfo

Depois da ponte de vidro, os sobreviventes participam de um jantar e entram em uma fase de combate entre jogadores. A ferramenta observada foi:

```text
Players.<jogador>.Backpack.Fork
```

O relatório mostrou `Fork` como `Tool`, tanto na mochila quanto potencialmente equipada pelo personagem. Entre seus descendentes apareceram:

```text
Fork.Script
Fork.Main
Fork.GripAttachment
Fork.Main.WeldConstraint
Fork.Swing
Fork.Hit
```

`Swing` e `Hit` são objetos `Sound`, reforçando que a ferramenta possui estados distintos para ataque executado e golpe acertado. O caminho do pai permite aplicar a mesma regra já usada nos outros itens:

- `Players.<jogador>.Backpack.Fork`: garfo guardado na hotbar/mochila.
- `Workspace.<jogador>.Fork`: garfo atualmente equipado.

A coleta registrou 11 ferramentas e 7 jogadores restantes. Isso confirma a presença dos garfos, mas a prévia não mostrou todos os itens suficientes para afirmar que cada sobrevivente recebe exatamente um.

A varredura de mapa também encontrou um prompt anexado a um personagem:

```text
Workspace.<jogador>.HumanoidRootPart.Clean
class = ProximityPrompt
action = "Clean Up"
enabled = false
```

Ele pode representar a interação para remover/limpar um corpo depois de uma eliminação. Como estava desativado, essa função ainda precisa ser confirmada observando o prompt em um jogador morto e verificando para quais cargos ele fica habilitado.

### Líder e recompensa

Durante essa fase apareceu a mensagem:

```text
O líder colocou uma recompensa em <jogador>!
```

Isso confirma uma mecânica em que o Líder escolhe ou marca um alvo. Ainda não foi localizado o atributo, objeto de interface ou remote correspondente à recompensa.

Para mapear essa função, as próximas buscas devem usar, uma por vez:

```text
Fork
Dinner
Night
Bounty
Reward
Target
Leader
recompensa
```

O melhor teste é salvar um snapshot antes da mensagem e comparar logo depois que o Líder selecionar o alvo. Também vale executar **Jogadores** imediatamente após a marcação para procurar um atributo novo no Líder e na vítima.

A varredura de mapa em foco `Tudo` retornou centenas de interações gerais, principalmente elevadores e CCTV, sem identificar a arena do jantar. Para essa fase, buscas estruturais específicas e comparação antes/depois serão mais úteis que a varredura genérica do mapa.

## Observações importantes

- `PlayingRLGL` pode continuar `true` mesmo depois da fase. Para detectar a ponte, prefira `PlayingGlass`.
- `GlassMaker` é definido no lobby e permanece no jogador.
- `GlassVision` e `GlassMaker` são atributos distintos.
- O filtro genérico `glass` no H Inspect traz muitos falsos positivos (óculos de avatar, cones etc.). Os filtros `Glasses` ou `Pair` são mais limpos.
- A tag `Hidden` aparece nos painéis da ponte, mas **não diferencia painel real de falso**.

## Arquitetura sugerida para um menu específico

Com base no que já foi confirmado, um futuro menu para o Squid Game X pode ser dividido assim:

1. **Cargos** — listar time, `IsGuard`, `GuardRank`, `IsFrontman`, `GlassMaker`, `GlassVision` e o futuro sinal de detetive.
2. **Estado da fase** — mostrar `PlayingRLGL`, `IsInsideRLGL`, segurança, vencedor, penalidades, proteção e cooldowns.
3. **Itens** — informar ferramentas na mão e na mochila, incluindo `Push`, `MPS-5` e `Revolver`.
4. **Portas** — registrar `DoorAccess`, forma exigida, prompts e caminho físico correspondente.
5. **Ponte de vidro** — identificar painéis e diferenças entre estado normal e `GlassVision` após a coleta A/B.
6. **Interações** — catálogo de elevadores, CCTV, incinerador, guarda-roupa e pickups.
7. **Diagnóstico** — exibir caminho completo, classe, atributos, tags e alterações em tempo real.

Uma regra importante: cada módulo deve procurar instâncias e atributos por nome/caminho em tempo de execução. Não deve depender de um único jogador, `JobId` ou posição capturada neste relatório.

## Filtros úteis para as próximas coletas

Em **Estrutura**, pesquisar individualmente:

```text
Glass
GlassVision
Bridge
Tile
DoorAccess
Role
Guard
Detective
Frontman
Push
MPS-5
RLGL
armrydoor
EntryDoor
```

Em **Interface**, pesquisar:

```text
glass
maker
guard
detective
frontman
role
```

Evite depender apenas do snapshot completo: as amostras tiveram mais de 1.500 elementos de interface e centenas de candidatos no mapa, mas a prévia foi limitada. Filtros específicos produzem relatórios menores e mais úteis.

Use o filtro na categoria correta:

- **Interface + `glass`** encontra chance, botões e gamepasses, não os vidros físicos.
- **Interface + `guard`** retornou 244 itens, muitos deles cosméticos/eventos; priorize `Main.Chances.GuardRank`.
- **Mapa + `glass/bridge/tile/panel`** deve ser usado durante a ponte.
- **Estrutura + os mesmos termos** ajuda a encontrar modelos e configurações antes de serem colocados no mapa.
- Evite o termo genérico **`player`** em Estrutura: como o caminho raiz é `Players`, ele inclui milhares de elementos de interface.

## O que já pode ser usado e o que ainda falta

### Pronto para protótipo

- detector de Guarda Círculo/Triângulo;
- detector de Frontman/Officer;
- detector separado de `GlassMaker` e `GlassVision`;
- estado do Red Light, Green Light;
- item equipado versus item na mochila;
- leitura das configurações de `MPS-5` e `Revolver`;
- registro das portas `Square+` e `Triangle+`;
- registro dinâmico das evidências do Detetive;
- catálogo das interações já encontradas.

### Precisa de novas amostras

- regra real/falso da ponte;
- confirmação do funcionamento de `GlassVision`;
- momento exato em que o jogo concede `GlassVision` ao jogador com `GlassMaker=true`;
- atributos e escolhas do Detetive;
- acesso do Guarda Círculo;
- remotes usados pelas fases e interações;
- sequência completa das rotas de fuga.

## Modelo para acrescentar novas descobertas

Ao enviar outra coleta, registre junto:

```text
Data/hora:
PlaceId e JobId:
Fase:
Cargo do jogador local:
Item na mão:
Filtro usado:
Ação feita antes da coleta:
O que mudou depois:
```

Para cada descoberta, guarde o caminho completo, classe da instância, atributos, tags e valores antes/depois. Isso permite transformar evidência em lógica sem confundir nomes sugestivos com comportamento realmente confirmado.

---

Última análise deste documento: `2026-10-06`. Fonte: dois snapshots únicos do H Inspect. Os dois primeiros arquivos recebidos eram duplicados; a coleta de `15:53:09Z` é uma segunda amostra independente.