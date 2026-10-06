local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Inspector = {}

local ROLE_WORDS = {
    "role", "cargo", "class", "classe", "team", "time", "status",
    "job", "type", "tipo", "guard", "guarda", "detective", "detetive",
    "leader", "lider", "líder", "maker", "fabricante", "vip", "playerstate", "state",
}

local INSPECTION_WORDS = {
    "role", "cargo", "class", "team", "status", "state", "playing", "inside",
    "guard", "detective", "frontman", "leader", "maker", "glass", "vision",
    "rank", "dead", "winner", "safe", "protect", "target", "bounty", "reward",
    "cooldown", "knife", "fork", "weapon", "gun", "ammo", "damage", "hit",
}

local TOOL_PART_WORDS = {
    "handle", "blade", "knife", "fork", "hit", "hitbox", "main", "weapon",
    "tip", "edge", "grip", "trigger", "mag", "ammo",
}

local IGNORED_INSPECTION_ATTRIBUTES = {
    activepayerstatus = true,
    dailyrewardsstreak = true,
    isgameready = true,
    platformspenderstatus = true,
    playerready = true,
    teamapplied = true,
    teamselected = true,
}

local DOOR_WORDS = {
    "door", "porta", "gate", "exit", "escape", "saida", "saída",
    "circle", "triangle", "square", "shape", "symbol", "lever", "alavanca",
}

local GLASS_WORDS = {
    "glass", "vidro", "bridge", "ponte", "tile", "pane", "panel",
    "fake", "real", "safe", "break", "tempered", "quebra", "maker", "fabricante",
}

local INTERACTION_WORDS = {
    "prompt", "button", "botao", "botão", "lever", "alavanca", "switch", "interact",
}

local function containsAny(value, words)
    local lowered = string.lower(tostring(value or ""))
    for _, word in ipairs(words) do
        if string.find(lowered, word, 1, true) then return true end
    end
    return false
end

local function sortedKeys(values)
    local keys = {}
    for key in pairs(values or {}) do table.insert(keys, tostring(key)) end
    table.sort(keys)
    return keys
end

local function oneLine(value)
    return tostring(value or ""):gsub("[\r\n\t]", " ")
end

local function formatValue(value)
    local valueType = typeof(value)
    if valueType == "string" then return string.format("%q", oneLine(value)) end
    if valueType == "Vector3" then
        return string.format("(%.2f, %.2f, %.2f)", value.X, value.Y, value.Z)
    end
    if valueType == "Color3" then
        return string.format("rgb(%d, %d, %d)",
            math.floor(value.R * 255 + 0.5), math.floor(value.G * 255 + 0.5), math.floor(value.B * 255 + 0.5))
    end
    if valueType == "CFrame" then
        local position = value.Position
        return string.format("CFrame(%.2f, %.2f, %.2f)", position.X, position.Y, position.Z)
    end
    return oneLine(value)
end

local function fullName(instance)
    local ok, result = pcall(function() return instance:GetFullName() end)
    return ok and result or tostring(instance)
end

local function normalizedFilter(value)
    return string.lower(tostring(value or "")):gsub("^%s+", ""):gsub("%s+$", "")
end

local function isInspectionAttribute(attribute)
    local key = string.lower(string.match(tostring(attribute or ""), "^([^=]+)=") or tostring(attribute or ""))
    if IGNORED_INSPECTION_ATTRIBUTES[key] then return false end
    return containsAny(key, INSPECTION_WORDS)
end

local function readTags(instance)
    local ok, tags = pcall(function() return CollectionService:GetTags(instance) end)
    if not ok or type(tags) ~= "table" then return {} end
    table.sort(tags)
    return tags
end

local function readAttributes(instance)
    local ok, attributes = pcall(function() return instance:GetAttributes() end)
    if not ok or type(attributes) ~= "table" then return {}, 0 end
    local result = {}
    for _, key in ipairs(sortedKeys(attributes)) do
        table.insert(result, key .. "=" .. formatValue(attributes[key]))
    end
    return result, #result
end

local function readValueObjects(root, maximum)
    local result = {}
    if not root then return result end
    local ok, descendants = pcall(function() return root:GetDescendants() end)
    if not ok then return result end
    for _, object in ipairs(descendants) do
        if #result >= maximum then break end
        if object:IsA("ValueBase") then
            local valueOk, value = pcall(function() return object.Value end)
            if valueOk and (containsAny(object.Name, ROLE_WORDS)
                or (object.Parent and string.lower(object.Parent.Name) == "leaderstats")) then
                table.insert(result, fullName(object) .. "=" .. formatValue(value))
            end
        end
    end
    table.sort(result)
    return result
end

local function collectTools(player)
    local names = {}
    local seen = {}
    local containers = { player.Character, player:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, object in ipairs(container:GetChildren()) do
                if object:IsA("Tool") and not seen[object.Name] then
                    seen[object.Name] = true
                    table.insert(names, object.Name)
                end
            end
        end
    end
    table.sort(names)
    return names
end

local function isGuiDatum(instance)
    return instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")
        or instance:IsA("ImageLabel") or instance:IsA("ImageButton")
end

local function effectivelyVisible(instance)
    local current = instance
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") and not current.Enabled then return false end
        current = current.Parent
    end
    return true
end

local function guiDetails(instance)
    local details = {
        "class=" .. instance.ClassName,
        "visible=" .. tostring(effectivelyVisible(instance)),
    }
    if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
        table.insert(details, "text=" .. string.format("%q", oneLine(instance.Text)))
        table.insert(details, "textColor=" .. formatValue(instance.TextColor3))
    end
    if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
        table.insert(details, "image=" .. string.format("%q", oneLine(instance.Image)))
        table.insert(details, "imageColor=" .. formatValue(instance.ImageColor3))
        table.insert(details, "imageTransparency=" .. tostring(instance.ImageTransparency))
    end
    if instance:IsA("GuiObject") then
        table.insert(details, "position=" .. tostring(instance.Position))
        table.insert(details, "size=" .. tostring(instance.Size))
        table.insert(details, "zIndex=" .. tostring(instance.ZIndex))
    end
    local tags = readTags(instance)
    if #tags > 0 then table.insert(details, "tags={" .. table.concat(tags, ", ") .. "}") end
    local attributes = readAttributes(instance)
    if #attributes > 0 then table.insert(details, "attrs={" .. table.concat(attributes, "; ") .. "}") end
    return table.concat(details, " | ")
end

local function joinOrNone(values)
    return #values > 0 and table.concat(values, ", ") or "nenhum"
end

local function utcTimestamp()
    local ok, value = pcall(function() return os.date("!%Y-%m-%dT%H:%M:%SZ") end)
    return ok and value or "horário indisponível"
end

local function sessionHeader(title)
    return table.concat({
        "H INSPECT — " .. title,
        "UTC: " .. utcTimestamp(),
        "PlaceId: " .. tostring(game.PlaceId or "?"),
        "GameId: " .. tostring(game.GameId or "?"),
        "JobId: " .. tostring(game.JobId or "?"),
    }, "\n")
end

local function preview(value, maximum)
    if #value <= maximum then return value end
    return string.sub(value, 1, maximum) .. "\n... prévia truncada; copie o relatório completo."
end

local function worldPosition(instance)
    if instance:IsA("BasePart") then return instance.Position end
    if instance:IsA("Model") then
        local ok, pivot = pcall(function() return instance:GetPivot() end)
        if ok then return pivot.Position end
    end
    return nil
end

local function worldDetails(instance, detailed)
    local details = { "class=" .. instance.ClassName }
    local position = worldPosition(instance)
    if position then table.insert(details, "pos=" .. formatValue(position)) end

    if instance:IsA("BasePart") then
        table.insert(details, "size=" .. formatValue(instance.Size))
        table.insert(details, "material=" .. tostring(instance.Material))
        table.insert(details, "color=" .. formatValue(instance.Color))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
        table.insert(details, "localTransparency=" .. tostring(instance.LocalTransparencyModifier))
        table.insert(details, "reflectance=" .. tostring(instance.Reflectance))
        table.insert(details, "collide=" .. tostring(instance.CanCollide))
        table.insert(details, "touch=" .. tostring(instance.CanTouch))
        table.insert(details, "query=" .. tostring(instance.CanQuery))
        table.insert(details, "anchored=" .. tostring(instance.Anchored))
        table.insert(details, "castShadow=" .. tostring(instance.CastShadow))
        table.insert(details, "collisionGroup=" .. tostring(instance.CollisionGroup))
        table.insert(details, "materialVariant=" .. string.format("%q", oneLine(instance.MaterialVariant)))
        if instance:IsA("MeshPart") then
            table.insert(details, "meshId=" .. string.format("%q", oneLine(instance.MeshId)))
            table.insert(details, "textureId=" .. string.format("%q", oneLine(instance.TextureID)))
        end
    elseif instance:IsA("ProximityPrompt") then
        table.insert(details, "action=" .. string.format("%q", oneLine(instance.ActionText)))
        table.insert(details, "object=" .. string.format("%q", oneLine(instance.ObjectText)))
        table.insert(details, "hold=" .. tostring(instance.HoldDuration))
        table.insert(details, "distance=" .. tostring(instance.MaxActivationDistance))
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
    elseif instance:IsA("ClickDetector") then
        table.insert(details, "distance=" .. tostring(instance.MaxActivationDistance))
    end

    if detailed then
        local tags = readTags(instance)
        if #tags > 0 then table.insert(details, "tags={" .. table.concat(tags, ", ") .. "}") end
        local attributes = readAttributes(instance)
        if #attributes > 0 then table.insert(details, "attrs={" .. table.concat(attributes, "; ") .. "}") end
    end
    return table.concat(details, " | ")
end

local function specialInstanceDetails(instance, detailed)
    if isGuiDatum(instance) then return guiDetails(instance) end
    if instance:IsA("BasePart") or instance:IsA("Model")
        or instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector") then
        return worldDetails(instance, detailed)
    end

    local details = { "class=" .. instance.ClassName }
    if instance:IsA("ValueBase") then
        local ok, value = pcall(function() return instance.Value end)
        if ok then table.insert(details, "value=" .. formatValue(value)) end
    elseif instance:IsA("Tool") then
        table.insert(details, "tooltip=" .. string.format("%q", oneLine(instance.ToolTip)))
        table.insert(details, "texture=" .. string.format("%q", oneLine(instance.TextureId)))
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
        table.insert(details, "requiresHandle=" .. tostring(instance.RequiresHandle))
        table.insert(details, "canBeDropped=" .. tostring(instance.CanBeDropped))
        table.insert(details, "manualActivation=" .. tostring(instance.ManualActivationOnly))
        table.insert(details, "grip=" .. formatValue(instance.Grip))
    elseif instance:IsA("Animation") then
        table.insert(details, "animationId=" .. string.format("%q", oneLine(instance.AnimationId)))
    elseif instance:IsA("Sound") then
        table.insert(details, "soundId=" .. string.format("%q", oneLine(instance.SoundId)))
        table.insert(details, "playing=" .. tostring(instance.Playing))
    elseif instance:IsA("Highlight") then
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
        table.insert(details, "fillColor=" .. formatValue(instance.FillColor))
        table.insert(details, "fillTransparency=" .. tostring(instance.FillTransparency))
        table.insert(details, "outlineColor=" .. formatValue(instance.OutlineColor))
        table.insert(details, "outlineTransparency=" .. tostring(instance.OutlineTransparency))
        table.insert(details, "depthMode=" .. tostring(instance.DepthMode))
        table.insert(details, "adornee=" .. (instance.Adornee and fullName(instance.Adornee) or "nil"))
    elseif instance:IsA("SelectionBox") then
        table.insert(details, "visible=" .. tostring(instance.Visible))
        table.insert(details, "color=" .. formatValue(instance.Color3))
        table.insert(details, "surfaceColor=" .. formatValue(instance.SurfaceColor3))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
        table.insert(details, "surfaceTransparency=" .. tostring(instance.SurfaceTransparency))
        table.insert(details, "adornee=" .. (instance.Adornee and fullName(instance.Adornee) or "nil"))
    elseif instance:IsA("Decal") or instance:IsA("Texture") then
        table.insert(details, "texture=" .. string.format("%q", oneLine(instance.Texture)))
        table.insert(details, "color=" .. formatValue(instance.Color3))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
        table.insert(details, "face=" .. tostring(instance.Face))
    elseif instance:IsA("SurfaceAppearance") then
        table.insert(details, "colorMap=" .. string.format("%q", oneLine(instance.ColorMap)))
        table.insert(details, "normalMap=" .. string.format("%q", oneLine(instance.NormalMap)))
        table.insert(details, "roughnessMap=" .. string.format("%q", oneLine(instance.RoughnessMap)))
        table.insert(details, "metalnessMap=" .. string.format("%q", oneLine(instance.MetalnessMap)))
        table.insert(details, "alphaMode=" .. tostring(instance.AlphaMode))
    elseif instance:IsA("Beam") or instance:IsA("Trail") then
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
        table.insert(details, "color=" .. tostring(instance.Color))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
        table.insert(details, "texture=" .. string.format("%q", oneLine(instance.Texture)))
    elseif instance:IsA("SurfaceGui") then
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
        table.insert(details, "adornee=" .. (instance.Adornee and fullName(instance.Adornee) or "nil"))
        table.insert(details, "face=" .. tostring(instance.Face))
        table.insert(details, "alwaysOnTop=" .. tostring(instance.AlwaysOnTop))
        table.insert(details, "lightInfluence=" .. tostring(instance.LightInfluence))
        table.insert(details, "brightness=" .. tostring(instance.Brightness))
    elseif instance:IsA("BillboardGui") then
        table.insert(details, "enabled=" .. tostring(instance.Enabled))
        table.insert(details, "adornee=" .. (instance.Adornee and fullName(instance.Adornee) or "nil"))
        table.insert(details, "alwaysOnTop=" .. tostring(instance.AlwaysOnTop))
        table.insert(details, "size=" .. tostring(instance.Size))
        table.insert(details, "studsOffset=" .. formatValue(instance.StudsOffset))
    end
    local tags = readTags(instance)
    if #tags > 0 then table.insert(details, "tags={" .. table.concat(tags, ", ") .. "}") end
    local attributes = readAttributes(instance)
    if #attributes > 0 then table.insert(details, "attrs={" .. table.concat(attributes, "; ") .. "}") end
    return table.concat(details, " | ")
end

local function isHighSignal(instance)
    if instance:IsA("ValueBase") or instance:IsA("Tool") or instance:IsA("ModuleScript")
        or instance:IsA("RemoteEvent") or instance:IsA("RemoteFunction")
        or instance:IsA("UnreliableRemoteEvent") or instance:IsA("ProximityPrompt")
        or instance:IsA("ClickDetector") or instance:IsA("Animation") or instance:IsA("Sound")
        or instance:IsA("Highlight") or instance:IsA("SelectionBox")
        or instance:IsA("Decal") or instance:IsA("Texture") or instance:IsA("SurfaceAppearance")
        or instance:IsA("Beam") or instance:IsA("Trail")
        or instance:IsA("SurfaceGui") or instance:IsA("BillboardGui") then
        return true
    end
    local _, attributeCount = readAttributes(instance)
    return attributeCount > 0 or #readTags(instance) > 0
end

local function belongsToTool(instance)
    if instance:IsA("Tool") then return true end
    local ok, ancestor = pcall(function() return instance:FindFirstAncestorOfClass("Tool") end)
    return ok and ancestor ~= nil
end

local function playerSpecialLabels(player)
    local labels = {}
    local function addAttribute(attributeName, label)
        local ok, value = pcall(function() return player:GetAttribute(attributeName) end)
        if ok and value ~= nil and value ~= false and value ~= "" then
            table.insert(labels, label or attributeName)
        end
    end
    addAttribute("GlassMaker", "GlassMaker")
    addAttribute("GlassVision", "GlassVision")
    addAttribute("IsFrontman", "Frontman")
    local guardRank = player:GetAttribute("GuardRank")
    if guardRank ~= nil and guardRank ~= "" then
        table.insert(labels, "Guard:" .. oneLine(guardRank))
    elseif player:GetAttribute("IsGuard") == true then
        table.insert(labels, "Guard")
    end
    return labels
end

local function playerOptionLabel(player)
    local special = playerSpecialLabels(player)
    if #special > 0 then
        return "[" .. table.concat(special, ",") .. "] @" .. player.Name
    end
    return "@" .. player.Name
end

local function focusedToolDescendant(instance)
    if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript")
        or instance:IsA("ValueBase") or instance:IsA("Sound") or instance:IsA("Animation")
        or instance:IsA("RemoteEvent") or instance:IsA("RemoteFunction")
        or instance:IsA("UnreliableRemoteEvent") or instance:IsA("ProximityPrompt")
        or instance:IsA("ClickDetector") or instance:IsA("Attachment")
        or instance:IsA("Constraint") then
        return true
    end
    if instance:IsA("BasePart") and containsAny(instance.Name, TOOL_PART_WORDS) then return true end
    local _, attributeCount = readAttributes(instance)
    return attributeCount > 0 or #readTags(instance) > 0
end

function Inspector:Create(options)
    if type(_G.__HINSPECT_INSPECTOR_CLEANUP) == "function" then
        pcall(_G.__HINSPECT_INSPECTOR_CLEANUP)
    end

    local runtime = {}
    local ui = options and options.UI
    local destroyed = false
    local liveGeneration = 0
    local cleanupFunction
    local lastReport = ""
    local lastPlayersReport = ""
    local lastWorldReport = ""
    local lastItemsReport = ""
    local lastGuiReport = ""
    local lastStructureReport = ""
    local lastSelectedPlayerReport = ""
    local baseline
    local settings = {
        IncludePlayerAttributes = true,
        IncludePlayerTools = true,
        IncludeToolDescendants = true,
        IncludeAccessories = true,
        LivePlayerScan = false,
        ScanInterval = 5,
        SelectedPlayer = "Meu personagem",
        InspectToolDescendants = true,
        WorldFocus = "Tudo",
        WorldFilter = "",
        MaxWorldResults = 80,
        GuiFilter = "",
        IncludeHiddenGui = true,
        MaxGuiResults = 200,
        StructureScope = "Tudo relevante",
        StructureFilter = "",
        MaxStructureResults = 200,
        SnapshotScope = "Tudo relevante",
        SnapshotFilter = "",
        SnapshotLimit = 5000,
        ReportDetail = "Detalhado",
    }

    local function update(id, labelValue, descriptionValue)
        if ui and type(ui.SetControlText) == "function" then
            ui:SetControlText(id, labelValue, descriptionValue)
        end
    end

    local function publishReport(report, summary)
        lastReport = report
        update("report_status", "Relatório pronto", summary)
        update("report_preview", "Prévia do relatório", preview(report, 2500))
        update("home_status", "Última coleta concluída", summary)
    end

    local function playerTargetOptions()
        local optionsList = { "Meu personagem" }
        local players = Players:GetPlayers()
        table.sort(players, function(a, b) return string.lower(a.Name) < string.lower(b.Name) end)
        for _, player in ipairs(players) do
            if player ~= Players.LocalPlayer then
                table.insert(optionsList, playerOptionLabel(player))
            end
        end
        return optionsList
    end

    local function resolveSelectedPlayer()
        if settings.SelectedPlayer == "Meu personagem" then return Players.LocalPlayer end
        local username = string.match(tostring(settings.SelectedPlayer or ""), "@([%w_]+)")
        if not username then return nil end
        for _, player in ipairs(Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(username) then return player end
        end
        return nil
    end

    local function appendAttributeSection(lines, title, instance)
        local attributes = instance and readAttributes(instance) or {}
        table.insert(lines, title .. " (" .. tostring(#attributes) .. ")")
        if #attributes == 0 then
            table.insert(lines, "  nenhum")
        else
            for _, attribute in ipairs(attributes) do table.insert(lines, "  - " .. attribute) end
        end
        table.insert(lines, "")
        return attributes
    end

    local function inspectSelectedPlayer()
        local player = resolveSelectedPlayer()
        if not player then
            lastSelectedPlayerReport = ""
            update("selected_player_status", "Jogador indisponível",
                "O alvo saiu do servidor. Abra o seletor e escolha outro jogador.")
            update("selected_player_report", "Prévia individual", "Nenhum dado coletado.")
            return
        end

        update("selected_player_status", "Inspecionando " .. player.Name,
            "Lendo Player, Character, Backpack, atributos e ferramentas.")
        local character = player.Character
        local backpack = player:FindFirstChildOfClass("Backpack")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local teamName = player.Team and player.Team.Name or (player.Neutral and "Neutral" or "sem time")
        local lines = {
            sessionHeader("INSPEÇÃO INDIVIDUAL"),
            "",
            string.format("Alvo: %s | display=%q | userId=%s", player.Name,
                oneLine(player.DisplayName), tostring(player.UserId)),
            string.format("LocalPlayer: %s | team=%q | neutral=%s", tostring(player == Players.LocalPlayer),
                teamName, tostring(player.Neutral)),
            "Player: " .. fullName(player),
            "Character: " .. (character and fullName(character) or "ausente"),
            "Backpack: " .. (backpack and fullName(backpack) or "ausente"),
            "",
        }

        local playerAttributes = readAttributes(player)
        local characterAttributes = character and readAttributes(character) or {}
        local highlights = {}
        for _, attribute in ipairs(playerAttributes) do
            if isInspectionAttribute(attribute) then table.insert(highlights, "Player." .. attribute) end
        end
        for _, attribute in ipairs(characterAttributes) do
            if isInspectionAttribute(attribute) then table.insert(highlights, "Character." .. attribute) end
        end
        local specialLabels = playerSpecialLabels(player)
        if #specialLabels > 0 then table.insert(highlights, 1, "Detector=" .. table.concat(specialLabels, ", ")) end
        table.insert(lines, "DESTAQUES")
        if #highlights == 0 then
            table.insert(lines, "  nenhum sinal especial encontrado")
        else
            for _, highlight in ipairs(highlights) do table.insert(lines, "  - " .. highlight) end
        end
        table.insert(lines, "")

        table.insert(lines, "PERSONAGEM")
        if humanoid then
            local stateOk, humanoidState = pcall(function() return humanoid:GetState() end)
            table.insert(lines, string.format(
                "  Humanoid: health=%s/%s | walkSpeed=%s | jumpPower=%s | jumpHeight=%s | hipHeight=%s | rig=%s | state=%s",
                tostring(humanoid.Health), tostring(humanoid.MaxHealth), tostring(humanoid.WalkSpeed),
                tostring(humanoid.JumpPower), tostring(humanoid.JumpHeight), tostring(humanoid.HipHeight),
                tostring(humanoid.RigType), stateOk and tostring(humanoidState) or "indisponível"))
        else
            table.insert(lines, "  Humanoid: ausente")
        end
        if rootPart and rootPart:IsA("BasePart") then
            table.insert(lines, "  posição=" .. formatValue(rootPart.Position)
                .. " | velocidade=" .. formatValue(rootPart.AssemblyLinearVelocity))
        else
            table.insert(lines, "  HumanoidRootPart: ausente")
        end
        table.insert(lines, "")

        appendAttributeSection(lines, "ATRIBUTOS — PLAYER", player)
        if character then appendAttributeSection(lines, "ATRIBUTOS — CHARACTER", character) end

        local values = {}
        local roots = { player }
        if character then table.insert(roots, character) end
        if backpack then table.insert(roots, backpack) end
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        local leaderstats = player:FindFirstChild("leaderstats")
        local seenValues = {}
        for _, root in ipairs(roots) do
            if root then
                for _, object in ipairs(root:GetDescendants()) do
                    if object:IsA("ValueBase") and not seenValues[object] and not belongsToTool(object)
                        and not (playerGui and object:IsDescendantOf(playerGui)) then
                        local directLeaderstat = leaderstats and object.Parent == leaderstats
                        if directLeaderstat or containsAny(object.Name, INSPECTION_WORDS) then
                            seenValues[object] = true
                            local valueOk, value = pcall(function() return object.Value end)
                            if valueOk then table.insert(values, fullName(object) .. "=" .. formatValue(value)) end
                        end
                    end
                end
            end
        end
        table.sort(values)
        table.insert(lines, "VALORES E LEADERSTATS (" .. tostring(#values) .. ")")
        if #values == 0 then table.insert(lines, "  nenhum") end
        for _, value in ipairs(values) do table.insert(lines, "  - " .. value) end
        table.insert(lines, "")

        local tools = {}
        local containers = {
            { Name = "equipado", Instance = character },
            { Name = "mochila", Instance = backpack },
        }
        for _, container in ipairs(containers) do
            if container.Instance then
                for _, object in ipairs(container.Instance:GetChildren()) do
                    if object:IsA("Tool") then
                        table.insert(tools, { Tool = object, Location = container.Name })
                    end
                end
            end
        end
        table.sort(tools, function(a, b)
            if a.Tool.Name == b.Tool.Name then return a.Location < b.Location end
            return string.lower(a.Tool.Name) < string.lower(b.Tool.Name)
        end)
        table.insert(lines, "FERRAMENTAS (" .. tostring(#tools) .. ")")
        if #tools == 0 then table.insert(lines, "  nenhuma") end
        for _, entry in ipairs(tools) do
            local tool = entry.Tool
            table.insert(lines, string.format("  [%s] local=%s | %s", tool.Name, entry.Location, fullName(tool)))
            table.insert(lines, "    " .. specialInstanceDetails(tool, true))
            if settings.InspectToolDescendants then
                local focused = {}
                for _, object in ipairs(tool:GetDescendants()) do
                    if focusedToolDescendant(object) then table.insert(focused, object) end
                end
                table.sort(focused, function(a, b) return string.lower(fullName(a)) < string.lower(fullName(b)) end)
                local maximum = math.min(#focused, 80)
                for index = 1, maximum do
                    local object = focused[index]
                    table.insert(lines, "    - " .. fullName(object) .. " | "
                        .. specialInstanceDetails(object, true))
                end
                if maximum < #focused then
                    table.insert(lines, string.format("    ... %d descendentes úteis omitidos", #focused - maximum))
                end
            end
        end
        table.insert(lines, "")

        local accessories = {}
        if character then
            for _, object in ipairs(character:GetChildren()) do
                if object:IsA("Accessory") then table.insert(accessories, object.Name) end
            end
        end
        table.sort(accessories, function(a, b) return string.lower(a) < string.lower(b) end)
        table.insert(lines, "ACESSÓRIOS (" .. tostring(#accessories) .. ")")
        table.insert(lines, "  " .. joinOrNone(accessories))
        table.insert(lines, "")

        local characterSignals = {}
        if character then
            for _, object in ipairs(character:GetDescendants()) do
                if not belongsToTool(object) and not object:IsA("Accessory")
                    and (object:IsA("ProximityPrompt") or object:IsA("ClickDetector")
                        or object:IsA("Highlight") or object:IsA("SelectionBox")
                        or object:IsA("BillboardGui")) then
                    table.insert(characterSignals, object)
                end
            end
        end
        table.sort(characterSignals, function(a, b) return string.lower(fullName(a)) < string.lower(fullName(b)) end)
        table.insert(lines, "SINAIS ANEXADOS AO CHARACTER (" .. tostring(#characterSignals) .. ")")
        if #characterSignals == 0 then table.insert(lines, "  nenhum") end
        local signalMaximum = math.min(#characterSignals, 60)
        for index = 1, signalMaximum do
            local object = characterSignals[index]
            table.insert(lines, "  - " .. fullName(object) .. " | " .. specialInstanceDetails(object, true))
        end
        if signalMaximum < #characterSignals then
            table.insert(lines, string.format("  ... %d sinais omitidos", #characterSignals - signalMaximum))
        end

        local report = table.concat(lines, "\n")
        local summary = string.format("%s | %d atributos | %d valores | %d Tools | %d sinais anexados",
            player.Name, #playerAttributes + #characterAttributes, #values, #tools, #characterSignals)
        lastSelectedPlayerReport = report
        update("selected_player_status", "Inspeção concluída: " .. player.Name,
            summary .. " | abra o seletor novamente para atualizar a lista")
        update("selected_player_report", "Prévia de " .. player.Name, preview(report, 5200))
        publishReport(report, summary)
    end

    local function scanPlayers(shouldPublish)
        local lines = { sessionHeader("JOGADORES"), "" }
        local players = Players:GetPlayers()
        table.sort(players, function(a, b) return string.lower(a.Name) < string.lower(b.Name) end)
        local roleSignalCount = 0

        for _, player in ipairs(players) do
            local teamName = player.Team and player.Team.Name or (player.Neutral and "Neutral" or "sem time")
            table.insert(lines, string.format("[%s] display=%q | userId=%s | team=%q",
                player.Name, oneLine(player.DisplayName), tostring(player.UserId), teamName))

            local signals = {}
            if player.Team then
                roleSignalCount = roleSignalCount + 1
                table.insert(signals, "Team=" .. player.Team.Name)
            end
            if settings.IncludePlayerAttributes then
                local roots = { player, player.Character }
                for _, root in ipairs(roots) do
                    if root then
                        local attributes = readAttributes(root)
                        for _, attribute in ipairs(attributes) do
                            local key = string.match(attribute, "^([^=]+)=") or attribute
                            if containsAny(key, ROLE_WORDS) then
                                roleSignalCount = roleSignalCount + 1
                                table.insert(signals, root.Name .. "." .. attribute)
                            elseif settings.ReportDetail == "Detalhado" then
                                table.insert(signals, root.Name .. "." .. attribute)
                            end
                        end
                    end
                end
                for _, valueRoot in ipairs({ player, player.Character }) do
                    local values = readValueObjects(valueRoot, 40)
                    for _, value in ipairs(values) do
                        roleSignalCount = roleSignalCount + 1
                        table.insert(signals, value)
                    end
                end
            end
            table.insert(lines, "  sinais: " .. joinOrNone(signals))

            if settings.IncludePlayerTools then
                table.insert(lines, "  tools: " .. joinOrNone(collectTools(player)))
            end
            if settings.ReportDetail == "Detalhado" then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                table.insert(lines, "  personagem: " .. (character and "presente" or "ausente")
                    .. (humanoid and (" | health=" .. tostring(humanoid.Health)) or "")
                    .. (rootPart and (" | pos=" .. formatValue(rootPart.Position)) or ""))
            end
            table.insert(lines, "")
        end

        local summary = string.format("%d jogadores | %d sinais de cargo/estado/leaderstats encontrados",
            #players, roleSignalCount)
        local report = table.concat(lines, "\n")
        lastPlayersReport = report
        update("players_status", "Varredura de jogadores concluída", summary)
        update("players_report", "Prévia dos jogadores", preview(report, 2200))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function scanItems(shouldPublish)
        local lines = { sessionHeader("ITENS, MÃO E HOTBAR"), "" }
        local found = {}
        local accessoryCount = 0
        local toolCount = 0
        local players = Players:GetPlayers()
        table.sort(players, function(a, b) return string.lower(a.Name) < string.lower(b.Name) end)

        for _, player in ipairs(players) do
            local containers = {}
            if player.Character then table.insert(containers, { Name = "equipado", Instance = player.Character }) end
            local backpack = player:FindFirstChildOfClass("Backpack")
            if backpack then table.insert(containers, { Name = "mochila", Instance = backpack }) end

            for _, container in ipairs(containers) do
                for _, child in ipairs(container.Instance:GetChildren()) do
                    if child:IsA("Tool") and not found[child] then
                        found[child] = true
                        toolCount = toolCount + 1
                        table.insert(lines, string.format("[%s] dono=%s | local=%s | %s",
                            child.Name, player.Name, container.Name, fullName(child)))
                        table.insert(lines, "  " .. specialInstanceDetails(child, true))
                        if settings.IncludeToolDescendants then
                            local descendants = child:GetDescendants()
                            local maximum = math.min(#descendants, 80)
                            for index = 1, maximum do
                                local object = descendants[index]
                                table.insert(lines, "    - " .. fullName(object) .. " | "
                                    .. specialInstanceDetails(object, true))
                            end
                            if maximum < #descendants then
                                table.insert(lines, string.format("    ... %d descendentes omitidos", #descendants - maximum))
                            end
                        end
                        table.insert(lines, "")
                    end
                end
            end

            if settings.IncludeAccessories and player.Character then
                for _, child in ipairs(player.Character:GetChildren()) do
                    local extraObject = child:IsA("Accessory")
                        or ((child:IsA("Model") or child:IsA("Folder")) and isHighSignal(child))
                    if extraObject then
                        accessoryCount = accessoryCount + 1
                        table.insert(lines, string.format("[anexo] dono=%s | %s | %s",
                            player.Name, fullName(child), specialInstanceDetails(child, true)))
                    end
                end
            end
        end

        if toolCount == 0 and accessoryCount == 0 then
            table.insert(lines, "Nenhuma Tool ou objeto anexado foi encontrado neste momento.")
        end
        local summary = string.format("%d Tools | %d acessórios/objetos anexados", toolCount, accessoryCount)
        local report = table.concat(lines, "\n")
        lastItemsReport = report
        update("items_status", "Varredura de itens concluída", summary)
        update("items_report", "Prévia dos itens", preview(report, 2600))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function scanGui(shouldPublish)
        local localPlayer = Players.LocalPlayer
        local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
        local filter = normalizedFilter(settings.GuiFilter)
        local matches = {}
        local scanned = 0
        if playerGui then
            local descendants = playerGui:GetDescendants()
            for index, instance in ipairs(descendants) do
                if isGuiDatum(instance) then
                    local topGui = instance:FindFirstAncestorOfClass("ScreenGui")
                    local isInspector = topGui and topGui.Name == "HInspect"
                    if not isInspector and (settings.IncludeHiddenGui or effectivelyVisible(instance)) then
                        local textValue = (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox"))
                            and instance.Text or ""
                        local imageValue = (instance:IsA("ImageLabel") or instance:IsA("ImageButton"))
                            and instance.Image or ""
                        local searchable = string.lower(fullName(instance) .. " " .. oneLine(textValue) .. " " .. oneLine(imageValue))
                        if (textValue ~= "" or imageValue ~= "")
                            and (filter == "" or string.find(searchable, filter, 1, true)) then
                            table.insert(matches, { Path = fullName(instance), Instance = instance })
                        end
                    end
                end
                scanned = index
                if index % 750 == 0 then
                    update("gui_status", "Varrendo interface...", string.format("%d de %d objetos lidos", index, #descendants))
                    task.wait()
                end
            end
        end
        table.sort(matches, function(a, b) return string.lower(a.Path) < string.lower(b.Path) end)

        local maximum = math.min(settings.MaxGuiResults, #matches)
        local lines = {
            sessionHeader("INTERFACE LOCAL"),
            "",
            "Filtro: " .. (filter == "" and "(vazio)" or filter),
            string.format("Objetos lidos: %d | resultados: %d | exibindo: %d", scanned, #matches, maximum),
            "",
        }
        for index = 1, maximum do
            local entry = matches[index]
            table.insert(lines, string.format("%03d. %s", index, entry.Path))
            table.insert(lines, "     " .. guiDetails(entry.Instance))
        end
        if maximum == 0 then table.insert(lines, "Nenhum texto ou imagem corresponde ao filtro atual.") end
        if maximum < #matches then
            table.insert(lines, string.format("\n... %d elementos omitidos pelo limite.", #matches - maximum))
        end

        local summary = string.format("%d textos/imagens encontrados | filtro: %s",
            #matches, filter == "" and "nenhum" or filter)
        local report = table.concat(lines, "\n")
        lastGuiReport = report
        update("gui_status", "Varredura da interface concluída", summary)
        update("gui_report", "Prévia da interface", preview(report, 2600))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function candidateKind(instance, path)
        local tags = readTags(instance)
        local attributes, attributeCount = readAttributes(instance)
        local searchable = path .. " " .. table.concat(tags, " ") .. " " .. table.concat(attributes, " ")
        local door = containsAny(searchable, DOOR_WORDS)
        local glass = containsAny(searchable, GLASS_WORDS)
            or (instance:IsA("BasePart") and instance.Material == Enum.Material.Glass)
        local interaction = instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
            or instance:IsA("TouchTransmitter") or containsAny(searchable, INTERACTION_WORDS)
        local focus = settings.WorldFocus
        local accepted = (focus == "Tudo" and (door or glass or interaction))
            or (focus == "Portas e saídas" and door)
            or (focus == "Vidros e ponte" and glass)
            or (focus == "Interações" and interaction)
        if not accepted then return nil, 0 end
        local filter = normalizedFilter(settings.WorldFilter)
        if filter ~= "" and not string.find(string.lower(searchable), filter, 1, true) then
            return nil, 0
        end

        local kinds = {}
        local score = 0
        if door then table.insert(kinds, "porta/saída"); score = score + 2 end
        if glass then table.insert(kinds, "vidro/ponte"); score = score + 2 end
        if interaction then table.insert(kinds, "interação"); score = score + 4 end
        if instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector") then score = score + 3 end
        if attributeCount > 0 then score = score + math.min(attributeCount, 3) end
        return table.concat(kinds, "+"), score, attributes
    end

    local function scanWorld(shouldPublish)
        local candidates = {}
        local descendants = Workspace:GetDescendants()
        update("world_status", "Varrendo mapa...", string.format("0 de %d instâncias lidas", #descendants))
        for index, instance in ipairs(descendants) do
            local path = fullName(instance)
            local kind, score = candidateKind(instance, path)
            if kind then
                table.insert(candidates, { Instance = instance, Path = path, Kind = kind, Score = score })
            end
            if index % 750 == 0 then
                update("world_status", "Varrendo mapa...", string.format("%d de %d instâncias lidas", index, #descendants))
                task.wait()
            end
        end
        table.sort(candidates, function(a, b)
            if a.Score == b.Score then return string.lower(a.Path) < string.lower(b.Path) end
            return a.Score > b.Score
        end)

        local maximum = math.min(settings.MaxWorldResults, #candidates)
        local lines = {
            sessionHeader("MAPA — " .. settings.WorldFocus),
            "",
            string.format("Candidatos: %d | exibindo: %d", #candidates, maximum),
            "",
        }
        for index = 1, maximum do
            local entry = candidates[index]
            table.insert(lines, string.format("%03d. [%s] %s", index, entry.Kind, entry.Path))
            table.insert(lines, "     " .. specialInstanceDetails(entry.Instance, settings.ReportDetail == "Detalhado"))
        end
        if maximum == 0 then
            table.insert(lines, "Nenhum candidato encontrado com o foco atual.")
        elseif maximum < #candidates then
            table.insert(lines, "")
            table.insert(lines, string.format("... %d itens omitidos pelo limite configurado.", #candidates - maximum))
        end

        local summary = string.format("%d candidatos no mapa | foco: %s", #candidates, settings.WorldFocus)
        local report = table.concat(lines, "\n")
        lastWorldReport = report
        update("world_status", "Varredura do mapa concluída", summary)
        update("world_report", "Prévia do mapa", preview(report, 2400))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function scopeRoots(scope)
        local localPlayer = Players.LocalPlayer
        local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
        local character = localPlayer and localPlayer.Character
        if scope == "ReplicatedStorage" then return { ReplicatedStorage } end
        if scope == "Workspace" then return { Workspace } end
        if scope == "PlayerGui" then return playerGui and { playerGui } or {} end
        if scope == "Personagem" then return character and { character } or {} end
        local roots = { ReplicatedStorage, Workspace }
        if playerGui then table.insert(roots, playerGui) end
        if character then table.insert(roots, character) end
        return roots
    end

    local function matchesFreeFilter(instance, path, filter)
        if filter == "" then return isHighSignal(instance) end
        local attributes = readAttributes(instance)
        local tags = readTags(instance)
        local searchable = string.lower(path .. " " .. instance.ClassName .. " "
            .. table.concat(attributes, " ") .. " " .. table.concat(tags, " "))
        if instance:IsA("ValueBase") then
            local ok, value = pcall(function() return instance.Value end)
            if ok then searchable = searchable .. " " .. string.lower(formatValue(value)) end
        elseif isGuiDatum(instance) then
            searchable = searchable .. " " .. string.lower(guiDetails(instance))
        end
        return string.find(searchable, filter, 1, true) ~= nil
    end

    local function scanStructure(shouldPublish)
        local filter = normalizedFilter(settings.StructureFilter)
        local matches = {}
        local seen = {}
        local scanned = 0
        for _, root in ipairs(scopeRoots(settings.StructureScope)) do
            local objects = { root }
            for _, instance in ipairs(root:GetDescendants()) do table.insert(objects, instance) end
            for _, instance in ipairs(objects) do
                if not seen[instance] then
                    seen[instance] = true
                    scanned = scanned + 1
                    local path = fullName(instance)
                    if matchesFreeFilter(instance, path, filter) then
                        table.insert(matches, { Path = path, Instance = instance })
                    end
                    if scanned % 1000 == 0 then
                        update("structure_status", "Varrendo estrutura...", string.format("%d objetos lidos", scanned))
                        task.wait()
                    end
                end
            end
        end
        table.sort(matches, function(a, b) return string.lower(a.Path) < string.lower(b.Path) end)

        local maximum = math.min(settings.MaxStructureResults, #matches)
        local lines = {
            sessionHeader("ESTRUTURA — " .. settings.StructureScope),
            "",
            "Filtro: " .. (filter == "" and "(alto sinal automático)" or filter),
            string.format("Objetos lidos: %d | resultados: %d | exibindo: %d", scanned, #matches, maximum),
            "",
        }
        for index = 1, maximum do
            local entry = matches[index]
            table.insert(lines, string.format("%03d. %s", index, entry.Path))
            table.insert(lines, "     " .. specialInstanceDetails(entry.Instance, true))
        end
        if maximum == 0 then table.insert(lines, "Nenhuma instância corresponde ao filtro atual.") end
        if maximum < #matches then
            table.insert(lines, string.format("\n... %d instâncias omitidas pelo limite.", #matches - maximum))
        end

        local summary = string.format("%d resultados em %s | filtro: %s",
            #matches, settings.StructureScope, filter == "" and "automático" or filter)
        local report = table.concat(lines, "\n")
        lastStructureReport = report
        update("structure_status", "Busca estrutural concluída", summary)
        update("structure_report", "Prévia da estrutura", preview(report, 2800))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function isSnapshotCandidate(instance, path, scope, filter)
        if filter ~= "" then return matchesFreeFilter(instance, path, filter) end
        if scope == "Interface" then return isGuiDatum(instance) end
        if scope == "Jogador e itens" then
            return isHighSignal(instance) or belongsToTool(instance) or instance:IsA("Accessory")
        end
        if scope == "Vidros e mapa" then
            local searchable = path .. " " .. table.concat(readTags(instance), " ")
            return containsAny(searchable, GLASS_WORDS) or containsAny(searchable, DOOR_WORDS)
                or (instance:IsA("BasePart") and instance.Material == Enum.Material.Glass)
                or instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
        end
        if isGuiDatum(instance) or belongsToTool(instance) then return true end
        local searchable = path .. " " .. table.concat(readTags(instance), " ")
        if instance:IsDescendantOf(Workspace) then
            return containsAny(searchable, GLASS_WORDS) or containsAny(searchable, DOOR_WORDS)
                or (instance:IsA("BasePart") and instance.Material == Enum.Material.Glass)
                or instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
                or isHighSignal(instance)
        end
        return isHighSignal(instance)
    end

    local function snapshotRoots(scope)
        local localPlayer = Players.LocalPlayer
        local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
        local character = localPlayer and localPlayer.Character
        if scope == "Interface" then return playerGui and { playerGui } or {} end
        if scope == "Jogador e itens" then
            local roots = {}
            if localPlayer then table.insert(roots, localPlayer) end
            if character then table.insert(roots, character) end
            return roots
        end
        if scope == "Vidros e mapa" then return { Workspace } end
        local roots = { ReplicatedStorage, Workspace }
        if playerGui then table.insert(roots, playerGui) end
        if localPlayer then table.insert(roots, localPlayer) end
        if character then table.insert(roots, character) end
        return roots
    end

    local function collectSnapshot(scope, rawFilter, limit)
        local filter = normalizedFilter(rawFilter)
        local items = {}
        local seen = {}
        local count = 0
        local scanned = 0
        local truncated = false
        for _, root in ipairs(snapshotRoots(scope)) do
            local objects = { root }
            for _, instance in ipairs(root:GetDescendants()) do table.insert(objects, instance) end
            for _, instance in ipairs(objects) do
                if not seen[instance] then
                    seen[instance] = true
                    scanned = scanned + 1
                    local path = fullName(instance)
                    local topGui = instance:FindFirstAncestorOfClass("ScreenGui")
                    local isInspector = topGui and topGui.Name == "HInspect"
                    if not isInspector and isSnapshotCandidate(instance, path, scope, filter) then
                        items[path] = specialInstanceDetails(instance, true)
                        count = count + 1
                        if count >= limit then truncated = true break end
                    end
                    if scanned % 1000 == 0 then task.wait() end
                end
            end
            if truncated then break end
        end
        return items, count, scanned, truncated
    end

    local function captureBaseline()
        update("compare_status", "Salvando snapshot A...", "Aguarde a leitura do estado atual.")
        local items, count, scanned, truncated = collectSnapshot(
            settings.SnapshotScope, settings.SnapshotFilter, settings.SnapshotLimit)
        baseline = {
            Items = items,
            Count = count,
            Scanned = scanned,
            Truncated = truncated,
            Scope = settings.SnapshotScope,
            Filter = settings.SnapshotFilter,
            Limit = settings.SnapshotLimit,
            Timestamp = utcTimestamp(),
        }
        local description = string.format("%d objetos salvos de %d lidos | escopo: %s%s",
            count, scanned, baseline.Scope, truncated and " | limite atingido" or "")
        update("compare_status", "Snapshot A salvo", description)
        update("compare_report", "Pronto para comparar", "Mude de cargo, equipe, item ou fase e clique em Comparar.")
    end

    local function compareSnapshot()
        if not baseline then
            update("compare_status", "Snapshot A não salvo", "Salve uma base antes de comparar.")
            return
        end
        update("compare_status", "Comparando...", "Lendo o estado atual com o mesmo escopo e filtro do snapshot A.")
        local current, currentCount, scanned, truncated = collectSnapshot(
            baseline.Scope, baseline.Filter, baseline.Limit)
        local changes = {}
        local added, removed, changed = 0, 0, 0
        for path, signature in pairs(current) do
            if baseline.Items[path] == nil then
                added = added + 1
                table.insert(changes, { Path = path, Kind = "+ ADICIONADO", After = signature })
            elseif baseline.Items[path] ~= signature then
                changed = changed + 1
                table.insert(changes, {
                    Path = path, Kind = "~ ALTERADO",
                    Before = baseline.Items[path], After = signature,
                })
            end
        end
        for path, signature in pairs(baseline.Items) do
            if current[path] == nil then
                removed = removed + 1
                table.insert(changes, { Path = path, Kind = "- REMOVIDO", Before = signature })
            end
        end
        table.sort(changes, function(a, b)
            if a.Kind == b.Kind then return string.lower(a.Path) < string.lower(b.Path) end
            return a.Kind < b.Kind
        end)

        local maximum = math.min(settings.MaxStructureResults, #changes)
        local lines = {
            sessionHeader("COMPARAÇÃO DE SNAPSHOTS"),
            "",
            "Snapshot A: " .. baseline.Timestamp,
            "Escopo: " .. baseline.Scope,
            "Filtro: " .. (normalizedFilter(baseline.Filter) == "" and "(automático)" or baseline.Filter),
            string.format("A: %d objetos | atual: %d objetos | lidos agora: %d", baseline.Count, currentCount, scanned),
            string.format("Adicionados: %d | removidos: %d | alterados: %d", added, removed, changed),
            (baseline.Truncated or truncated) and "AVISO: ao menos um snapshot atingiu o limite configurado." or "",
            "",
        }
        for index = 1, maximum do
            local change = changes[index]
            table.insert(lines, string.format("%03d. %s | %s", index, change.Kind, change.Path))
            if change.Before then table.insert(lines, "     antes: " .. change.Before) end
            if change.After then table.insert(lines, "     agora: " .. change.After) end
        end
        if maximum == 0 then table.insert(lines, "Nenhuma diferença encontrada no escopo atual.") end
        if maximum < #changes then
            table.insert(lines, string.format("\n... %d diferenças omitidas pelo limite de resultados.", #changes - maximum))
        end

        local summary = string.format("%d adicionados | %d removidos | %d alterados", added, removed, changed)
        local report = table.concat(lines, "\n")
        update("compare_status", "Comparação concluída", summary)
        update("compare_report", "Prévia das diferenças", preview(report, 3000))
        publishReport(report, summary)
    end

    local function scanAll()
        local playersReport, playersSummary = scanPlayers(false)
        local itemsReport, itemsSummary = scanItems(false)
        local guiReport, guiSummary = scanGui(false)
        local worldReport, worldSummary = scanWorld(false)
        local combined = sessionHeader("SNAPSHOT COMPLETO") .. "\n\n"
            .. playersReport .. "\n\n" .. itemsReport .. "\n\n"
            .. guiReport .. "\n\n" .. worldReport
        publishReport(combined, playersSummary .. " | " .. itemsSummary
            .. " | " .. guiSummary .. " | " .. worldSummary)
    end

    local function startLivePlayerScan()
        liveGeneration = liveGeneration + 1
        local generation = liveGeneration
        if not settings.LivePlayerScan then return end
        task.spawn(function()
            while not destroyed and settings.LivePlayerScan and generation == liveGeneration do
                scanPlayers(true)
                task.wait(settings.ScanInterval)
            end
        end)
    end

    local function copyText(report, statusId, emptyMessage)
        if report == "" then
            update(statusId, "Nada para copiar", emptyMessage)
            return false
        end
        local clipboard = type(setclipboard) == "function" and setclipboard
            or (type(toclipboard) == "function" and toclipboard or nil)
        if not clipboard then
            update(statusId, "Área de transferência indisponível",
                "Este executor não oferece setclipboard/toclipboard.")
            return false
        end
        local ok, err = pcall(clipboard, report)
        if ok then
            update(statusId, "Relatório copiado",
                string.format("%d caracteres enviados para a área de transferência.", #report))
            return true
        else
            update(statusId, "Falha ao copiar", tostring(err))
            return false
        end
    end

    local function copyLastReport()
        copyText(lastReport, "report_status", "Crie uma varredura antes de exportar.")
    end

    local function copySelectedPlayerReport()
        copyText(lastSelectedPlayerReport, "selected_player_status",
            "Inspecione o jogador selecionado antes de copiar.")
    end

    function runtime:GetOptions(source)
        if source == "PlayerTargets" then return playerTargetOptions() end
        return {}
    end

    function runtime:Set(name, value)
        if destroyed then return end
        if name == "IncludePlayerAttributes" or name == "IncludePlayerTools"
            or name == "IncludeToolDescendants" or name == "IncludeAccessories"
            or name == "IncludeHiddenGui" or name == "LivePlayerScan"
            or name == "InspectToolDescendants" then
            settings[name] = value == true
        elseif name == "ScanInterval" or name == "MaxWorldResults"
            or name == "MaxGuiResults" or name == "MaxStructureResults"
            or name == "SnapshotLimit" then
            settings[name] = tonumber(value) or settings[name]
        elseif name == "WorldFocus" or name == "ReportDetail" or name == "StructureScope"
            or name == "SnapshotScope" or name == "WorldFilter" or name == "GuiFilter"
            or name == "StructureFilter" or name == "SnapshotFilter"
            or name == "SelectedPlayer" then
            settings[name] = tostring(value)
            if name == "SelectedPlayer" then
                update("selected_player_status", "Alvo selecionado", settings.SelectedPlayer
                    .. " | clique em Inspecionar para gerar o relatório focado.")
            end
        elseif name == "ScanPlayers" then
            scanPlayers(true)
        elseif name == "InspectSelectedPlayer" then
            inspectSelectedPlayer()
        elseif name == "CopySelectedPlayer" then
            copySelectedPlayerReport()
        elseif name == "ScanItems" then
            scanItems(true)
        elseif name == "ScanGui" then
            scanGui(true)
        elseif name == "ScanWorld" then
            scanWorld(true)
        elseif name == "ScanStructure" then
            scanStructure(true)
        elseif name == "CaptureBaseline" then
            captureBaseline()
        elseif name == "CompareSnapshot" then
            compareSnapshot()
        elseif name == "ClearBaseline" then
            baseline = nil
            update("compare_status", "Snapshot A apagado", "Salve uma nova base antes de comparar.")
            update("compare_report", "Prévia das diferenças", "Mudanças relevantes aparecerão aqui.")
        elseif name == "ScanAll" then
            scanAll()
        elseif name == "CopyReport" then
            copyLastReport()
        elseif name == "PrintReport" then
            if lastReport == "" then
                update("report_status", "Nada para imprimir", "Crie uma varredura antes de exportar.")
            else
                print(lastReport)
                update("report_status", "Relatório enviado ao console", string.format("%d caracteres impressos.", #lastReport))
            end
        elseif name == "ClearReport" then
            lastReport, lastPlayersReport, lastWorldReport = "", "", ""
            lastItemsReport, lastGuiReport, lastStructureReport = "", "", ""
            lastSelectedPlayerReport = ""
            baseline = nil
            update("report_status", "Sessão limpa", "Nenhum relatório disponível.")
            update("report_preview", "Prévia", "O conteúdo mais recente aparecerá aqui.")
            update("home_status", "Aguardando coleta", "Use o snapshot completo ou uma varredura direcionada.")
            update("players_status", "Nenhuma varredura", "Os possíveis sinais de cargo aparecerão aqui.")
            update("players_report", "Prévia dos jogadores", "A prévia será preenchida depois da primeira coleta.")
            update("selected_player_status", "Nenhum jogador inspecionado",
                "Escolha Meu personagem ou outro jogador e clique em Inspecionar.")
            update("selected_player_report", "Prévia individual", "O relatório focado aparecerá aqui.")
            update("items_status", "Nenhuma varredura", "Itens equipados e guardados aparecerão aqui.")
            update("items_report", "Prévia dos itens", "A prévia será preenchida depois da primeira coleta.")
            update("gui_status", "Nenhuma varredura", "Textos como cargos, chances e avisos de fase aparecerão aqui.")
            update("gui_report", "Prévia da interface", "A prévia será preenchida depois da primeira coleta.")
            update("world_status", "Nenhuma varredura", "Portas, vidros e interações candidatas aparecerão aqui.")
            update("world_report", "Prévia do mapa", "A prévia será preenchida depois da primeira coleta.")
            update("structure_status", "Nenhuma busca", "Use palavras do jogo para localizar dados replicados.")
            update("structure_report", "Prévia da estrutura", "A prévia será preenchida depois da busca.")
            update("compare_status", "Snapshot A não salvo", "Escolha o escopo e salve uma base primeiro.")
            update("compare_report", "Prévia das diferenças", "Mudanças relevantes aparecerão aqui.")
        end

        if name == "LivePlayerScan" then startLivePlayerScan() end
    end

    function runtime:Destroy()
        if destroyed then return end
        destroyed = true
        liveGeneration = liveGeneration + 1
        if _G.__HINSPECT_INSPECTOR_CLEANUP == cleanupFunction then
            _G.__HINSPECT_INSPECTOR_CLEANUP = nil
        end
    end

    cleanupFunction = function() runtime:Destroy() end
    _G.__HINSPECT_INSPECTOR_CLEANUP = cleanupFunction
    return runtime
end

return Inspector
