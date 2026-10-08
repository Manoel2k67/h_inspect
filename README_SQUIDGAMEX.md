# H Inspect — Dossiê do Squid Game X

Este documento reúne o que o **H Inspect** conseguiu observar no jogo **Squid Game X** e transforma a coleta bruta em uma referência para desenvolver menus específicos depois.

> Estado atual: análise em andamento. Além dos snapshots iniciais, uma coleta complementar confirmou a estrutura física da ponte e a diferença replicada entre vidro real e falso.

## Identificação da amostra

| Amostra | UTC | PlaceId | JobId | Destaque |
|---|---|---|---|---|
| A | `2026-10-06T15:46:00Z` | `7559074529` | `44d99d26-74eb-445c-8854-df3ccb9b77e5` | `Workspace.Map.RedLightGreenLight` carregado |
| B | `2026-10-06T15:53:09Z` | `7559074529` | `083a3d85-b7c4-4abb-b2b4-4980c119b7c8` | Glass Maker, Frontman/Officer, armas e evidências do detetive |
| C | `2026-10-06T16:09:10Z` | `7559074529` | `083a3d85-b7c4-4abb-b2b4-4980c119b7c8` | Fase Glass ativa e estado especial do Frontman |
| D | `2026-10-07T01:38:54Z` | `7559074529` | `8efc68c6-7257-468c-928f-61f8f8956fcf` | Hide and Seek, time vermelho e ferramenta `Knife` |
| E | `2026-10-07T19:45:59Z` | `7559074529` | `9ceb5503-2f61-494c-9154-1f0d5dcbca95` | Dois pickups do bebê, estrutura `Workspace.BabyPickup` e `PickupPrompt` confirmados |

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
| Visão de vidro | `GlassVision=true` | Atributo confirmado; é separado de `GlassMaker` |
| Glass Maker | `GlassMaker=true` em um único jogador e UI `Main.Chances.Glassmaker` | Identificação do sorteado confirmada; somente ele vê os vidros na final |
| Portador do bebê | `HasBaby=true`, `BabyType` e acessório `BabyBack` | Confirmado |
| Detetive | Interface `PlayerGui.DetectivePick.DetectivePick` e evidências em `Workspace.Data.Detective` | Mecânica confirmada; atributo do jogador desconhecido |
| Hide and Seek — time vermelho | `PlayingHideNSeek=true`, `HideNSeek_Team="red"`, `HideNSeek_Equipment=true` e `Knife` | Conjunto observado diretamente em uma amostra; a relação exata entre time e equipamento ainda precisa de comparação |

### Guardas encontrados

Foram observados vários exemplos úteis:

- Guarda Círculo: `Team="Guard"`, `IsGuard=true`, `GuardRank="Circle"`, `ChatTag="CIRCLE GUARD"`, `SafeCharacter=true` e item `MPS-5`.
- Guarda Triângulo: `Team="Guard"`, `IsGuard=true`, `GuardRank="Triangle"`, `LockerRoom="Room4"`, `SafeCharacter=true` e item `MPS-5`.
- Officer/Frontman: `Team="Guard"`, `IsGuard=true`, `GuardRank="Officer"`, `IsFrontman=true`, `ChatTag="FRONTMAN"` e item `Revolver`.
- A arma exposta no personagem possui `WeaponType="BulletWeapon"`.

Guardas Círculo apareceram em `Room1`, `Room2`, `Room4`, `Room7` e `Room9`. Portanto, `LockerRoom` é o quarto onde o guarda nasce e não deve ser usado como identificador de patente.

Os atributos físicos variaram entre amostras. Um Guarda Círculo foi observado com `100/100` de vida e `JumpHeight=7.2`; outra amostra apresentou `110/110` e aproximadamente `8.2`. O menu deve exibir os valores atuais, sem assumir que vida ou pulo identificam o cargo. A `MPS-5` confirmou `AmmoCapacity=30`, `HitDamage=10` e `ShotCooldown=0.2`.

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

Esse Frontman tinha `150/150` de vida, `JumpHeight=10.2` e `WalkSpeed=12`. O Glass Maker apareceu com `100/100` em uma amostra e `130/130` em outra. Esses valores podem refletir bônus, progressão ou estado da rodada; não devem substituir `IsFrontman` e `GlassMaker` como detectores.

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

### Ordem dos seis jogos

A partida possui **seis jogos**. Segundo a observação recorrente confirmada pelo jogador que fez as coletas, duas posições são fixas e as demais podem mudar de ordem:

| Posição | Jogo | Regra |
|---|---|---|
| 1º | Red Light, Green Light | Sempre é o primeiro jogo |
| 2º–4º | Outros minigames | A ordem pode variar entre partidas |
| 5º | Ponte de vidro (`Glass`) | Sempre é o quinto jogo |
| 6º | Outro minigame | Faz parte da ordem variável dos demais |

Portanto, o menu pode usar a posição `1` como confirmação adicional de Red Light, Green Light e a posição `5` como confirmação adicional da ponte. Para os outros jogos, não deve associar uma fase a um número fixo. O detector principal ainda deve usar sinais específicos do estado atual, porque atributos de fases anteriores podem permanecer no jogador.

No **lobby da partida**, a escada possui destinos/entradas que encaminham os jogadores para as fases:

```text
Workspace.Staircase.TPs.Glass.Teleport
Workspace.Staircase.TPs.MusicalChairs.Teleport
```

Esses caminhos pertencem ao lobby. Eles não fazem parte dos mapas físicos das fases e, em especial, `Workspace.Staircase.TPs.MusicalChairs.Teleport` não representa nenhuma cadeira nem a mecânica de sentar das Cadeiras Musicais.

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
| `Knife` | Participante do Hide and Seek; time vermelho na amostra | `Backpack` ou `Character` | tag `HideNSeekTool`, sons `Swing` e `Hit` |
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

O `Push` da primeira fase e o soco/arma de outras situações devem ser tratados como `Tool`s diferentes até uma captura provar que compartilham o mesmo remote. O H Inspect 2.8.0 possui a aba **Combate** para fazer essa comparação. A coleta recomendada é:

1. iniciar antes de equipar o item;
2. equipar somente o `Push`, usar uma vez e tentar novamente durante a recarga;
3. encerrar e copiar;
4. repetir em outro relatório com o soco ou arma equipável.

A captura relaciona `Tool.Activated`, clique de ataque, `Tool.Enabled`, atributos/Values e chamadas `FireServer`/`InvokeServer`. Nenhuma dessas chamadas é criada pelo inspetor. Se a tentativa durante a recarga não produzir chamada, o bloqueio ocorre antes do remote; se produzir a mesma chamada sem efeito, a recarga provavelmente é validada pelo servidor.

### Knife do Hide and Seek

A amostra D confirmou uma `Tool` chamada `Knife` na mochila do jogador local durante Hide and Seek:

```text
Players.Manoel2k67.Backpack.Knife
  tags = {HideNSeekTool}

Players.Manoel2k67.Backpack.Knife.Hit
  class = Sound
  SoundId = "rbxassetid://4678745096"
  tags = {GamemodeSound, Sound}

Players.Manoel2k67.Backpack.Knife.Swing
  class = Sound
  SoundId = "rbxassetid://9116197044"
  tags = {GamemodeSound, Sound}

Players.Manoel2k67.Backpack.Knife.Knife
  class = Script

Players.Manoel2k67.Backpack.Knife.Knife.Knife
  class = Part
  size = (0.62, 0.60, 3.37)
  transparency = 1
  anchored = true
  CanCollide = false
  CanTouch = true
  tags = {CanTouchRequired}
```

A ferramenta estava guardada, não equipada. Os atributos simultâneos do `Player` eram:

```text
PlayingHideNSeek = true
HideNSeek_Team = "red"
HideNSeek_Equipment = true
```

O `Character` também possuía `RAGDOLL_FORCE_DISABLE=true`. Isso pode estar relacionado à fase ou a outro estado do personagem; uma única amostra não permite associá-lo diretamente à faca.

Na mesma coleta, o Humanoid tinha `130/130` de vida, `WalkSpeed=25`, `JumpPower=50` e `JumpHeight≈15.64`. O `Player` expunha `Player_Jump_Height=9.2`. Esses valores são estado observado, não configuração confirmada da `Knife` ou do time vermelho.

Ainda não foram observados alcance, dano, cooldown, remote de ataque ou mudança causada ao alvo. Para confirmar o comportamento, é necessário comparar uma amostra com a faca guardada, outra equipada e uma terceira imediatamente após um ataque acertar.

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

### Estrutura confirmada dos painéis

O contêiner principal é:

```text
Workspace.Map.Glass.Glasses
```

Dentro dele existem dez pares, com dois lados em cada par. Cada painel é um `BasePart` filho direto de `Glasses`, e o próprio `Name` contém `Pair`. A notação observada foi:

```text
Pair1/1   Pair1/2
Pair2/1   Pair2/2
...
Pair10/1  Pair10/2
```

Assim, o caminho lógico é `Workspace.Map.Glass.Glasses.<PairN/lado>`. O código funcional usa `Glasses:GetChildren()`, mantém apenas objetos `BasePart` cujo nome contém `Pair` e aplica a regra em cada peça diretamente. Não é necessário procurar um Model intermediário chamado `Pair1`. A enumeração deve continuar dinâmica para tolerar atualizações do jogo.

### Regra real/falso confirmada

| Propriedade | Vidro real/seguro | Vidro falso/quebrável |
|---|---|---|
| `CanCollide` | `true` | `false` |
| `Size.Z` | maior, observado em `0.50+` | observado em `0.05` |
| Material/cor | iguais | iguais |
| `Transparency` | aproximadamente `0.55` | aproximadamente `0.55` |

A classificação principal é:

```text
CanCollide == true  -> vidro real/seguro
CanCollide == false -> vidro falso/quebrável
```

`Size.Z` deve ser usado como confirmação adicional, não como única regra. Material, cor, transparência e a tag `Hidden` não diferenciaram os lados.

Quando um lado quebra, ele pode ser movido para uma coordenada `Y` muito baixa, como `-11000`, e perder o `TouchInterest`. O menu deve distinguir três estados:

- **real intacto:** `CanCollide=true`;
- **falso intacto:** `CanCollide=false`, `Size.Z` próximo de `0.05` e ainda na região da ponte;
- **removido/quebrado:** posição `Y` muito baixa, ausência do `TouchInterest` ou objeto removido.

Outros caminhos confirmados da fase:

```text
Workspace.Map.Glass.Map.KillSecure
Workspace.Map.Glass.NotCutscene.PassPart.GlassmakerPrompt
Workspace.Staircase.TPs.Glass.Teleport
```

`KillSecure` é uma zona de morte. `GlassmakerPrompt` pertence à passagem fora da cutscene. Já `Workspace.Staircase.TPs.Glass.Teleport` fica na escada do lobby e encaminha para a fase; ele não faz parte da ponte. `PlayingGlass=true` continua sendo o melhor atributo observado para detectar participantes da ponte.

### Relação com Glass Maker e Frontman

O menu deve mostrar separadamente:

- **Fabricante sorteado:** `GlassMaker=true`;
- **Visão especial ativa:** `GlassVision=true`;
- **Fase da ponte:** `PlayingGlass=true`;
- **Seleção do Frontman:** `FRONTMAN_GLASS_PAIR_SELECTION`.

`FRONTMAN_GLASS_PAIR_SELECTION` representa um índice de par observado, mas não deve ser usado como lado seguro. A regra física `CanCollide` é a evidência direta para classificar os painéis.

### Implementação recomendada

1. Aguardar `Workspace.Map.Glass.Glasses` existir.
2. Enumerar os filhos diretos com `Glasses:GetChildren()`.
3. Manter somente `BasePart` cujo `Name` contém `Pair`.
4. Classificar primeiro por `CanCollide` e validar com `Size.Z`.
5. Atualizar quando filhos forem adicionados/removidos ou quando `CanCollide` mudar.
6. Não salvar coordenadas ou referências entre rodadas, pois o mapa pode ser recriado.

O H Inspect 2.4.0 pode confirmar essa estrutura usando **Mapa → Vidros e ponte** e os filtros `Glasses, Pair`. O botão **Copiar relatório do mapa** preserva `CanCollide`, tamanho, caminho, pai/par e filhos diretos.

Buscas genéricas por `glass` ainda encontram óculos e outros falsos positivos. Os filtros `Glasses` e `Pair` são mais específicos para a ponte.

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

Pelo contexto e pelo trecho `TPs`, ele pertence ao sistema de encaminhamento do lobby para a fase Glass, não a um painel real ou falso da ponte e nem ao interior do mapa Glass. O caminho usa a forma antiga `Workspace.Stairs.gm`; a relação exata com `Workspace.Staircase.TPs.Glass.Teleport` ainda precisa ser confirmada.

## Cadeiras Musicais

O modelo confirmado da fase é:

```text
Workspace.Map.MusicalChairs
```

Uma coleta durante a disputa registrou duas notificações decisivas:

| UTC | Remote | Mensagem | Estado interpretado |
|---|---|---|---|
| `22:57:43` | `ReplicatedStorage.Remotes.Notify` | `TAKE A SEAT!` | janela para procurar e ocupar uma cadeira |
| `22:58:04` | `ReplicatedStorage.Remotes.Notify` | `Waiting for guards to clean up..` | disputa encerrada; limpeza dos eliminados |

As mensagens ficaram separadas por aproximadamente `21` segundos nessa amostra. Isso não deve ser tratado como duração fixa até ser confirmado com `Remotes.Timer` em outras rodadas.

Estados que um menu futuro pode representar:

1. **Aguardando/música:** ainda não surgiu `TAKE A SEAT!`.
2. **Sentar agora:** mensagem `TAKE A SEAT!` recebida; jogador sem cadeira corre risco de eliminação.
3. **Sentado:** verificar no personagem local `Humanoid.Sit=true` e `Humanoid.SeatPart` diferente de `nil`.
4. **Limpeza:** mensagem `Waiting for guards to clean up..` recebida.

`Humanoid.Sit` e `SeatPart` são sinais recomendados da API do Roblox, mas ainda precisam ser registrados nesta experiência para confirmar se as cadeiras usam objetos `Seat` normais. Se usarem, cada cadeira também pode ser classificada como livre quando `Seat.Occupant=nil` ou ocupada quando `Occupant` aponta para um `Humanoid`.

Coleta recomendada para confirmar as cadeiras físicas:

- em **Estrutura**, usar escopo `Workspace` e filtros `MusicalChairs`, `chair`, `seat` e `occupant`;
- inspecionar o próprio jogador antes e depois de sentar;
- monitorar `Notify`, `Timer`, `GameStateUpdate` e `GamemodeAction` desde o começo da música até a limpeza;
- copiar uma coleta quando a cadeira estiver livre e outra quando estiver ocupada.

Com os dados atuais, já é possível planejar alertas de **SENTE AGORA**, estado local sentado/não sentado, contagem observada e indicação de cadeiras livres ou próximas quando a estrutura física for confirmada. A coleta não mostrou um remote específico de sentar.

## Sistema de teleporte observado

Há dois tipos de evidência relacionados às transições entre áreas.

### Destinos físicos na escada do lobby

```text
Workspace.Staircase.TPs.Glass.Teleport
Workspace.Staircase.TPs.MusicalChairs.Teleport
```

Essas peças ficam no **lobby da partida** e parecem representar destinos ou gatilhos usados para encaminhar jogadores às fases. Elas não pertencem ao interior de `Workspace.Map.Glass` ou `Workspace.Map.MusicalChairs`.

O caminho `Workspace.Staircase.TPs.MusicalChairs.Teleport` não tem relação com as cadeiras utilizadas durante o evento. As cadeiras reais, a ocupação dos assentos e a eliminação de quem não sentar devem ser investigadas separadamente dentro de `Workspace.Map.MusicalChairs`.

Como ainda não foram coletadas todas as propriedades e interações dessas peças do lobby, não está confirmado se o contato com elas inicia o teleporte ou se funcionam somente como marcadores de destino para scripts do servidor.

### Remote recebido `SafeTP`

O cliente recebeu chamadas como:

```text
ReplicatedStorage.Remotes.SafeTP(CFrame(8022.59, 90.83, 3730.97))
ReplicatedStorage.Remotes.SafeTP(CFrame(-12604.93, -787.37, -2901.25))
```

O primeiro destino foi observado no retorno ao lobby; o segundo, antes do início de Red Light, Green Light. Isso mostra que o servidor envia ao cliente um `CFrame` de destino durante transições seguras.

Fluxo observado:

```text
SetLighting(<fase>)
→ SafeTP(<CFrame de destino>)
→ GameStateUpdate("StartGamemode", <fase>)
```

No encerramento também apareceu:

```text
GameStateUpdate("EndGamemode", <fase>)
→ SetLighting("Lobby")
→ SafeTP(<CFrame do lobby>)
```

Essa é evidência de um comando **servidor → cliente**. Ela não revela o remote que o cliente eventualmente usa para solicitar entrada em uma fase e não confirma que uma chamada criada pelo cliente seria aceita. Para continuar a inspeção, monitorar `SafeTP`, `GameStateUpdate`, `SetLighting` e `GamemodeAction` ao entrar e sair de cada mapa, registrando o nome da fase e o `CFrame` recebido. Coordenadas devem permanecer como evidência de amostra, não como destinos fixos, pois os mapas podem ser recriados ou movidos.

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
- Nos painéis intactos observados, `CanCollide` diferencia os lados: `true` é real e `false` é falso; `Size.Z` ajuda a confirmar.
- Um painel quebrado pode ser movido para `Y=-11000` e perder o `TouchInterest`, então deve ser marcado como removido em vez de reclassificado apenas pela colisão.

## Coleta passiva de remotes

O H Inspect 2.5.2 possui uma categoria **Remotes**. Ela separa duas tarefas:

- **Varrer remotes:** cataloga `RemoteEvent`, `UnreliableRemoteEvent` e `RemoteFunction`, com caminho, classe, atributos, tags e contexto do pai.
- **Monitor passivo:** registra somente `OnClientEvent`, ou seja, mensagens que o servidor já enviou ao cliente. Não chama `FireServer` ou `InvokeServer`.

Fluxo recomendado para mapear uma mecânica:

1. Escolher **ReplicatedStorage** e varrer com o filtro vazio para obter o inventário geral.
2. Em **Filtro do caminho**, usar nomes observados como `GameStateUpdate`, `GamemodeAction`, `ReplicaSet`, `ReplicaWrite`, `Notify`, `SafeTP` e `SetLighting`, ou deixar vazio.
3. Em **Filtro dos argumentos**, usar termos da mecânica, como `glass, bridge`, `rope`, `bounty, reward`, `detective`, `door` ou `fork, dinner`.
4. Iniciar o monitor imediatamente antes da ação ou mudança de fase.
5. Executar a ação normalmente, parar o monitor e copiar os eventos recebidos.
6. Registrar junto o estado antes/depois, pois o nome do remote e seus argumentos precisam ser correlacionados com uma mudança observável.

Limitação: esse monitor não mostra chamadas que um `LocalScript` faz do cliente para o servidor e não substitui `OnClientInvoke` de `RemoteFunction`, pois isso alteraria o comportamento do jogo. Mesmo sem esses hooks, o inventário e os eventos recebidos podem revelar anúncios de fase, alvos, recompensas, estado da ponte e atualizações de interface.

### Amostra remota — encerramento do Pentathlon

Uma coleta feita no final da partida revelou esta sequência:

| Horário UTC | Remote | Argumentos relevantes |
|---|---|---|
| `22:27:49` | `Remotes.GamemodeAction` | `"CleanupGamemode"` |
| `22:27:49` | `RemoteEvents.ReplicaSet` | `CompletedMaps`, `Pentathlon`, `count`, valor `0` |
| `22:27:49` | `RemoteEvents.ReplicaSet` | `Gameplay`, `glassMakerChance`, valor `0` |
| `22:27:49` | `RemoteEvents.ReplicaSet` | `Gameplay`, `babyChance`, valor `0` |
| `22:28:00` | `Remotes.GameStateUpdate` | `"EndGamemode"`, `"Pentathlon"` |
| `22:28:01` | `Remotes.SetLighting` | `"Lobby"` |
| `22:28:01` | `Remotes.SafeTP` | `CFrame(8022.59, 90.83, 3730.97)` |

Isso indica um fluxo observável de limpeza da fase, atualização do estado final, restauração da iluminação e teleporte seguro ao lobby. `ReplicaSet` aparenta atualizar uma árvore de dados do jogador; `Gameplay.glassMakerChance` é especialmente útil para acompanhar a chance mostrada na interface. O valor `0` foi observado no encerramento e não deve ser interpretado como valor permanente.

`Notify` disparou cinco vezes, mas a primeira versão do serializador truncou `messages` em `{...}`. Desde a versão 2.5.1, tabelas internas e slots `nil` são preservados. A versão 2.5.2 também exibe corretamente booleanos `false` e compacta eventos idênticos recebidos em sequência.

### Amostras remotas — seleção e queda do bebê

O bebê é concedido a um participante no lobby da partida, durante a seleção de cargos. Se o portador vencer levando o bebê, a recompensa final é multiplicada por `2x`.

Uma coleta feita quando o jogador local morreu registrou:

| Horário UTC | Remote | Argumentos relevantes |
|---|---|---|
| `22:29:32` | `Remotes.Notify` | mensagem ainda truncada na versão antiga |
| `22:29:53` | `RemoteEvents.ReplicaSet` | caminho `SprintSpeed`, valor `0` |
| `22:29:54` | `Remotes.BabyAction` | `"dropBaby"`, `CFrame(-1234.34, 208.52, 7.08)`, identificador `"186"` |
| `22:29:57` | `Remotes.BabyAction` | `"cleanUp"` |
| `22:30:00` | `Remotes.SetLighting` | `"MusicalChairsDark"` |

Uma coleta posterior acompanhou o sorteio desde o lobby. A sequência observada foi:

| Horário UTC | Remote | Argumentos relevantes |
|---|---|---|
| `22:33:25` | `Remotes.GamemodeAction` | `"StartBabyTransferAnimation"` |
| `22:33:26` | `Remotes.Notify` | `"We have a newborn! an extra Player 367"` |
| `22:33:38` | `Remotes.GamemodeAction` | `"EndBabyTransferAnimation"` |
| `22:33:38` | `Remotes.Notify` | `"Win the games with the baby to double your earnings!"` |
| `22:33:48` | `Remotes.Screenshot` | retrato usado na etapa da foto |
| `22:33:57` | `Remotes.SetLighting` | `"RedLightGreenLight"` |
| `22:33:57` | `Remotes.SafeTP` | destino da primeira fase |
| `22:34:01` | `Remotes.GameStateUpdate` | `"StartGamemode"`, `"RedLightGreenLight"` |
| `22:34:15` | `Remotes.BabyAction` | `"dropBaby"`, posição, identificador `"367"` |
| `22:34:16` | `Remotes.BabyAction` | `"cleanUp"` |

Uma inspeção posterior do portador resolveu o significado mais provável desse número. A notificação anunciou `extra Player 256`, e o jogador que carregava o bebê tinha `leaderstats.Id="256"`. Portanto, o terceiro argumento de `dropBaby` corresponde ao número de jogador (`leaderstats.Id`) do portador que soltou o bebê, não ao `UserId` e não a um ID persistente do bebê. Os valores `367`, `143` e `256` podem representar portadores diferentes.

`BabyAction` já permite implementar um rastreador passivo:

- `dropBaby` abre o estado **bebê derrubado**, fornece a posição e um identificador da instância/entidade;
- `cleanUp` remove a representação caída; quando ocorre logo após o jogador pegar o bebê, funciona como confirmação de pickup;
- o `CFrame` permite mostrar a última posição conhecida do bebê;
- o terceiro argumento pode ser associado ao jogador procurando `leaderstats.Id` com o mesmo valor.

Uma ação controlada de soltar e pegar novamente confirmou:

| Ação | ReplicaSet | BabyAction |
|---|---|---|
| Soltou | `SprintSpeed=21` | `dropBaby`, posição `(7971.75, 88.79, 3642.63)`, ID `"143"` |
| Pegou novamente, 2 s depois | `SprintSpeed=16.6` | `cleanUp` |

Nessa amostra, carregar o bebê reduziu `SprintSpeed` de `21` para `16.6`, uma diferença de `4.4`. O valor absoluto pode variar com bônus e estados da fase, então a implementação deve observar a mudança da velocidade, não exigir exatamente esses números.

`SprintSpeed=0` ocorreu perto da morte, mas ainda pode representar imobilização, transição ou espectador. `MusicalChairsDark` identifica o estado de iluminação da fase, porém também não prova morte isoladamente. Para um detector confiável, combinar `Humanoid.Died`, atributo `Dead` e `BabyAction("dropBaby")` quando o jogador era o portador.

Não apareceu um comando remoto recebido com nome explícito `pickupBaby`; a coleta controlada mostrou que o pickup é confirmado por `cleanUp` junto da redução de `SprintSpeed`. A amostra E identificou posteriormente a interação física responsável: `Workspace.BabyPickup.Trigger.PickupPrompt`.

O portador pode ser identificado diretamente pelos dados replicados do `Player`:

```text
HasBaby = true
BabyType = "FRONT"
leaderstats.Id = "256"
Character possui o acessório BabyBack
```

Ordem recomendada para o detector:

1. `Player:GetAttribute("HasBaby") == true` como sinal principal;
2. `BabyType` para mostrar a variante/posição, sem assumir ainda o significado completo de `FRONT`;
3. acessório `BabyBack` como confirmação visual;
4. `leaderstats.Id` para relacionar o portador ao terceiro argumento de `dropBaby`.

Na amostra, o portador tinha `WalkSpeed=12`, `JumpHeight=6.2` e o `Push` equipado. Esses números podem sofrer penalidades ou bônus e não devem substituir `HasBaby` como detector.

### Pickup físico confirmado — amostra E

A coleta guiada da amostra E permaneceu ativa durante a morte de um portador informado como Javier, o primeiro pickup do bebê deixado por ele, um drop manual do jogador local e o segundo pickup. Apesar do ruído causado pela duração de aproximadamente 11 minutos, os dois pickups convergiram para a mesma estrutura e para a mesma interação.

O bebê derrubado aparece como:

```text
Workspace.BabyPickup
├─ Parts
│  ├─ Main
│  ├─ Plane
│  ├─ Plane.001
│  ├─ Collisions
│  ├─ Head
│  └─ Cylinder.001
└─ Trigger
   ├─ Main
   ├─ PickupPrompt
   ├─ WeldConstraint
   └─ BillboardGui
```

O modelo `Workspace.BabyPickup` foi observado com a tag `SERVER_HANDLED`. O objeto de interação confirmado é:

```text
Workspace.BabyPickup.Trigger.PickupPrompt
class = ProximityPrompt
ActionText = "Pick up"
ObjectText = "Baby"
Enabled = true
MaxActivationDistance = 5
HoldDuration = 0.5
RequiresLineOfSight = false
KeyboardKeyCode = E
```

O `Trigger` é uma peça transparente de aproximadamente `(1.20, 1.79, 1.20)`, com `CanCollide=false`, `CanTouch=false` e `CanQuery=false`. Portanto, o pickup não depende de tocar fisicamente nessa peça; a evidência direta é o `ProximityPrompt`.

#### Primeiro pickup — bebê deixado pelo portador morto

| Tempo relativo | Sinal observado |
|---|---|
| `+632.814s` | `BabyAction("dropBaby", CFrame(7998.13, 93.61, 3766.49), "370")` |
| `+633.118s` | `PickupPrompt` ficou visível para o jogador local |
| `+633.954s` | `ProximityPromptService.PromptTriggered`, prompt acionado por `Players.Manoel2k67` |
| `+633.998s` | `ReplicaSet` alterou `SprintSpeed` para `16.6` |
| `+634.045s` | `BabyAction("cleanUp")` confirmou a remoção do bebê do chão |

O identificador `"370"` pertence ao portador que derrubou o bebê nessa sequência. Como nas amostras anteriores, ele deve ser tratado como `leaderstats.Id`, não como `UserId`.

#### Segundo pickup — drop do próprio jogador

O jogador local tinha `leaderstats.Id="217"`. A sequência foi:

| Tempo relativo | Sinal observado |
|---|---|
| `+651.192s` | `HasBaby` foi removido |
| `+651.193s` | `SprintSpeed` voltou para `21` |
| `+651.204s` | `BabyType` foi removido e chegou `dropBaby`, posição `(7984.56, 131.37, 3705.43)`, ID `"217"` |
| `+651.427s` | `Workspace.BabyPickup` foi adicionado, cerca de `0.22s` depois do remote |
| `+651.434s` | `PickupPrompt` ficou visível |
| `+652.534s` | `PromptTriggered` foi disparado por `Players.Manoel2k67` |
| `+652.583s` | `HasBaby=true` e `SprintSpeed=16.6` |
| `+652.592s` | `BabyType="BACK"` e `BabyAction("cleanUp")` |

Depois do pickup, também foram observados:

```text
BABY_POSITIONING_RESTRICTION = true
CURRENT_IDLE_ANIM = "rbxassetid://90000209271852"
CURRENT_WALK_ANIM = "rbxassetid://99289169949891"
Character.BabyBack = Accessory
Character.RightHand.BabyFront = Model
```

`HasBaby=true` continua sendo o detector principal. `BabyType`, `BabyBack`, `BabyFront`, as animações e a restrição de posicionamento são sinais complementares. A presença simultânea de `BabyType="BACK"` e um modelo chamado `BabyFront` mostra que o nome visual não deve substituir o atributo na identificação da variante.

#### Movimento do objeto no chão

O `CFrame` de `dropBaby` é a posição inicial conhecida, mas o modelo pode cair ou se acomodar fisicamente antes do pickup. No segundo teste:

```text
dropBaby:              Y = 131.37
prompt quando exibido: Y = 130.76
prompt no pickup:      Y = 128.87
```

Assim, um rastreador deve usar o `CFrame` somente enquanto `Workspace.BabyPickup` ainda não existir. Depois que o modelo for replicado, deve acompanhar a posição atual de `BabyPickup.Trigger` ou do próprio `PickupPrompt`.

#### Implicações para pickup automático sem teleporte

Já está confirmado que o alvo correto é o `ProximityPrompt`; não há motivo para procurar um `TouchTransmitter` ou `ClickDetector` do bebê. Uma implementação experimental pode:

1. observar `Workspace.ChildAdded` ou aguardar `Workspace:FindFirstChild("BabyPickup")` após `BabyAction("dropBaby")`;
2. resolver dinamicamente `BabyPickup.Trigger.PickupPrompt`;
3. ignorar a tentativa se o jogador local já tiver `HasBaby=true`;
4. usar uma trava para não acionar o mesmo prompt várias vezes simultaneamente;
5. quando o executor disponibilizar `fireproximityprompt`, tentar o prompt normalmente;
6. considerar sucesso somente quando surgir `HasBaby=true`, chegar `cleanUp` ou `Workspace.BabyPickup` for removido;
7. liberar a trava após sucesso, remoção do modelo ou timeout.

Ainda **não está confirmado** que `fireproximityprompt` funciona a mais de `5` studs. `MaxActivationDistance=5` e a tag `SERVER_HANDLED` indicam que pode existir validação de distância no servidor. O teste decisivo deve ser feito parado a mais de `5` studs, sem mover o personagem, acionando apenas o prompt e observando se `HasBaby`, `SprintSpeed`, `cleanUp` e a remoção do modelo confirmam o pickup.

Se essa tentativa for rejeitada, não se deve concluir que outro remote conhecido resolve o problema. Nesta amostra, `hookmetamethod/getnamecallmethod` estavam indisponíveis e nenhuma chamada cliente → servidor pôde ser observada. Nesse cenário, pickup realmente distante e sem teleporte continuará não confirmado até surgir outra interface aceita pelo servidor.

Uma opção de menu segura para protótipo deve oferecer separadamente:

- **Pegar bebê agora** — uma tentativa no `PickupPrompt` atual;
- **Auto Pickup Baby** — tenta automaticamente quando `Workspace.BabyPickup` aparece;
- **Estado do auto pickup** — aguardando, prompt encontrado, tentativa enviada, confirmado ou timeout;
- **Sem teleporte** — não mover o personagem como fallback quando essa opção estiver ativa.

### Linha do tempo do lobby da partida

A coleta desde o encerramento da seleção de times até a contagem da primeira fase revelou:

1. `GameStateUpdate("TeamSelectionEnd")` e `CanSprint=false`.
2. `GamemodeAction("PlayTutorial")` e progresso de `SkipCutscene("InitialTutorial", "(N/21)")`.
3. `GamemodeAction("StartShowGlassMaker", ...)` e iluminação `Glass`.
4. `Notify` informa textualmente o Glass Maker escolhido e explica vidro real/falso.
5. `GamemodeAction("EndShowGlassMaker", true)` e iluminação `Lobby`.
6. `GamemodeAction("ShowSymbols", true)` enquanto os minigames são escolhidos.
7. `StartBabyTransferAnimation`, anúncio do novo portador e `ToggleDoors=true`.
8. `EndBabyTransferAnimation`, `ToggleDoors=false`, `CanSprint=true` e tutorial da recompensa `2x`.
9. Timers de `9` e `12` segundos, foto, escada e preparação para o próximo minigame.

Há uma divergência importante: `StartShowGlassMaker` recebeu `"Manoel2k67"`, mas a notificação informou que o escolhido era `owertresmil1`. Portanto, o segundo argumento de `StartShowGlassMaker` não deve ser usado como identidade do Glass Maker. Para isso, preferir `GlassMaker=true`, o BillboardGui e o nome exibido em `Notify`.

### Coleta guiada de drop e pickup

O H Inspect 2.7.0 adiciona a categoria **Bebê** para concentrar em um único relatório o teste controlado de soltar e pegar novamente. O fluxo é iniciar a coleta ainda carregando, executar as duas ações normalmente e copiar o resultado.

A coleta registra:

- estado inicial e final do jogador, incluindo atributos, `leaderstats`, Humanoid e objetos relacionados ao bebê;
- todos os `OnClientEvent` recebidos durante o intervalo;
- instâncias adicionadas e removidas no `Workspace`;
- objetos, prompts e detectores próximos ao `CFrame` de `dropBaby` em três momentos;
- quando suportado pelo executor, chamadas `FireServer` e `InvokeServer` feitas pelo próprio jogo durante o pickup.

Esse último item é observação passiva e não dispara remotes. Ele serve para distinguir pickup por `ProximityPrompt`, `TouchTransmitter` ou `ClickDetector` de uma solicitação explícita cliente → servidor. Se o executor não fornecer os hooks necessários, o relatório registra essa limitação em vez de concluir incorretamente que não houve chamada.

## Arquitetura sugerida para um menu específico

Com base no que já foi confirmado, um futuro menu para o Squid Game X pode ser dividido assim:

1. **Cargos** — listar time, `IsGuard`, `GuardRank`, `IsFrontman`, `GlassMaker`, `GlassVision` e o futuro sinal de detetive.
2. **Estado da fase** — mostrar `PlayingRLGL`, `IsInsideRLGL`, segurança, vencedor, penalidades, proteção e cooldowns.
3. **Itens** — informar ferramentas na mão e na mochila, incluindo `Push`, `Knife`, `MPS-5` e `Revolver`.
4. **Portas** — registrar `DoorAccess`, forma exigida, prompts e caminho físico correspondente.
5. **Ponte de vidro** — listar os pares, marcar lado real/falso por `CanCollide`, validar com `Size.Z` e acompanhar painéis quebrados.
6. **Interações** — catálogo de elevadores, CCTV, incinerador, guarda-roupa e pickups.
7. **Bebê** — portador por `HasBaby`, tipo, número de jogador, multiplicador `2x`, última posição de `dropBaby`, modelo `Workspace.BabyPickup`, `PickupPrompt`, pickup/limpeza por `cleanUp` e protótipo de pickup automático sem teleporte.
8. **Diagnóstico** — exibir caminho completo, classe, atributos, tags e alterações em tempo real.

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
Knife
HideNSeek
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
- detector da fase e do time de Hide and Seek por `PlayingHideNSeek` e `HideNSeek_Team`;
- detector da `Knife` pela Tool e pela tag `HideNSeekTool`;
- leitura das configurações de `MPS-5` e `Revolver`;
- registro das portas `Square+` e `Triangle+`;
- registro dinâmico das evidências do Detetive;
- catálogo das interações já encontradas.
- detector da fase Glass por `PlayingGlass`;
- resolução dos pares da ponte por `CanCollide`, com confirmação por `Size.Z`;
- detecção de painel quebrado por posição muito baixa, remoção ou perda de `TouchInterest`.
- rastreador do bebê no chão por `BabyAction("dropBaby")` e `Workspace.BabyPickup`;
- resolução dinâmica de `Workspace.BabyPickup.Trigger.PickupPrompt`;
- confirmação de pickup por `PromptTriggered`, `HasBaby=true`, redução de `SprintSpeed`, `cleanUp` e remoção do modelo.

### Precisa de novas amostras

- efeito visual exato aplicado por `GlassVision` no cliente;
- momento exato em que o jogo concede `GlassVision` ao jogador com `GlassMaker=true`;
- atributos e escolhas do Detetive;
- dano, alcance, cooldown e remote de ataque da `Knife`;
- confirmação da relação entre time vermelho, `HideNSeek_Equipment` e recebimento da `Knife`;
- acesso do Guarda Círculo;
- remotes usados pelas fases e interações;
- sequência completa das rotas de fuga.
- confirmação de que `fireproximityprompt` consegue pegar o bebê a mais de `5` studs sem teleporte;
- comportamento do servidor quando o `PickupPrompt` é acionado fora de `MaxActivationDistance`;

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

Última análise deste documento: `2026-10-07`. As descobertas combinam os snapshots do H Inspect, a coleta complementar da ponte e a inspeção individual da fase Hide and Seek.
