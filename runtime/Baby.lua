local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Baby = {}

local RELEVANT_WORDS = {
    "baby", "newborn", "pickup", "pick up", "prompt", "interact",
    "touch", "click", "carry", "drop", "clean", "sprint",
}

local function utcTimestamp()
    local ok, value = pcall(function() return os.date("!%Y-%m-%dT%H:%M:%SZ") end)
    return ok and value or "horário indisponível"
end

local function oneLine(value)
    return tostring(value == nil and "nil" or value):gsub("[\r\n\t]", " ")
end

local function fullName(instance)
    local ok, result = pcall(function() return instance:GetFullName() end)
    return ok and result or tostring(instance)
end

local function sortedKeys(values)
    local keys = {}
    for key in pairs(values or {}) do table.insert(keys, tostring(key)) end
    table.sort(keys)
    return keys
end

local function formatValue(value, depth, seen)
    depth = depth or 0
    seen = seen or {}
    local valueType = typeof(value)
    if valueType == "nil" then return "nil" end
    if valueType == "string" then return string.format("%q", oneLine(value)) end
    if valueType == "boolean" or valueType == "number" then return tostring(value) end
    if valueType == "Vector3" then
        return string.format("(%.2f, %.2f, %.2f)", value.X, value.Y, value.Z)
    end
    if valueType == "CFrame" then
        local position = value.Position
        return string.format("CFrame(%.2f, %.2f, %.2f)", position.X, position.Y, position.Z)
    end
    if valueType == "Color3" then
        return string.format("rgb(%d, %d, %d)",
            math.floor(value.R * 255 + 0.5), math.floor(value.G * 255 + 0.5),
            math.floor(value.B * 255 + 0.5))
    end
    if valueType == "Instance" then return fullName(value) end
    if valueType ~= "table" then return oneLine(value) end
    if depth >= 3 then return "{...}" end
    if seen[value] then return "<ciclo>" end
    seen[value] = true
    local pieces = {}
    local count = 0
    for key, nested in pairs(value) do
        count = count + 1
        if count > 24 then
            table.insert(pieces, "...")
            break
        end
        table.insert(pieces, "[" .. formatValue(key, depth + 1, seen) .. "]="
            .. formatValue(nested, depth + 1, seen))
    end
    table.sort(pieces)
    seen[value] = nil
    return "{" .. table.concat(pieces, ", ") .. "}"
end

local function formatPacked(packed)
    local parts = {}
    for index = 1, packed.n do
        table.insert(parts, string.format("[%d]=%s", index, formatValue(packed[index], 0, {})))
    end
    return packed.n > 0 and table.concat(parts, " | ") or "(nenhum)"
end

local function containsRelevant(value)
    local lowered = string.lower(tostring(value or ""))
    for _, word in ipairs(RELEVANT_WORDS) do
        if string.find(lowered, word, 1, true) then return true end
    end
    return false
end

local function readTags(instance)
    local ok, tags = pcall(function() return CollectionService:GetTags(instance) end)
    if not ok or type(tags) ~= "table" then return {} end
    table.sort(tags)
    return tags
end

local function readAttributes(instance)
    local ok, attributes = pcall(function() return instance:GetAttributes() end)
    if not ok or type(attributes) ~= "table" then return {} end
    local parts = {}
    for _, key in ipairs(sortedKeys(attributes)) do
        table.insert(parts, key .. "=" .. formatValue(attributes[key]))
    end
    return parts
end

local function instancePosition(instance)
    if not instance then return nil end
    if instance:IsA("BasePart") then return instance.Position end
    if instance:IsA("Attachment") then return instance.WorldPosition end
    if instance:IsA("Model") then
        local ok, pivot = pcall(function() return instance:GetPivot() end)
        if ok then return pivot.Position end
    end
    local current = instance.Parent
    while current and current ~= Workspace do
        if current:IsA("BasePart") then return current.Position end
        if current:IsA("Attachment") then return current.WorldPosition end
        if current:IsA("Model") then
            local ok, pivot = pcall(function() return current:GetPivot() end)
            if ok then return pivot.Position end
        end
        current = current.Parent
    end
    return nil
end

local function describeInstance(instance, referencePosition)
    local path = fullName(instance)
    local details = { "class=" .. instance.ClassName }
    local position = instancePosition(instance)
    if position then
        table.insert(details, "pos=" .. formatValue(position))
        if referencePosition then
            table.insert(details, string.format("distância=%.2f", (position - referencePosition).Magnitude))
        end
    end
    if instance:IsA("BasePart") then
        table.insert(details, "size=" .. formatValue(instance.Size))
        table.insert(details, "CanCollide=" .. tostring(instance.CanCollide))
        table.insert(details, "CanTouch=" .. tostring(instance.CanTouch))
        table.insert(details, "CanQuery=" .. tostring(instance.CanQuery))
        table.insert(details, "Transparency=" .. tostring(instance.Transparency))
    elseif instance:IsA("ProximityPrompt") then
        table.insert(details, "ActionText=" .. formatValue(instance.ActionText))
        table.insert(details, "ObjectText=" .. formatValue(instance.ObjectText))
        table.insert(details, "Enabled=" .. tostring(instance.Enabled))
        table.insert(details, "MaxActivationDistance=" .. tostring(instance.MaxActivationDistance))
        table.insert(details, "HoldDuration=" .. tostring(instance.HoldDuration))
        table.insert(details, "RequiresLineOfSight=" .. tostring(instance.RequiresLineOfSight))
        table.insert(details, "KeyboardKeyCode=" .. tostring(instance.KeyboardKeyCode))
    elseif instance:IsA("ClickDetector") then
        table.insert(details, "MaxActivationDistance=" .. tostring(instance.MaxActivationDistance))
        table.insert(details, "CursorIcon=" .. formatValue(instance.CursorIcon))
    elseif instance:IsA("ValueBase") then
        local ok, value = pcall(function() return instance.Value end)
        if ok then table.insert(details, "value=" .. formatValue(value)) end
    end
    local attributes = readAttributes(instance)
    if #attributes > 0 then table.insert(details, "attrs={" .. table.concat(attributes, "; ") .. "}") end
    local tags = readTags(instance)
    if #tags > 0 then table.insert(details, "tags={" .. table.concat(tags, ", ") .. "}") end
    local parent = instance.Parent
    table.insert(details, "parent=" .. (parent and fullName(parent) or "nil"))
    local children = {}
    local ok, directChildren = pcall(function() return instance:GetChildren() end)
    if ok then
        for index, child in ipairs(directChildren) do
            if index > 20 then
                table.insert(children, "...")
                break
            end
            table.insert(children, child.Name .. ":" .. child.ClassName)
        end
    end
    if #children > 0 then table.insert(details, "filhos={" .. table.concat(children, ", ") .. "}") end
    return path .. "\n     " .. table.concat(details, " | ")
end

local function snapshotLocalPlayer()
    local player = Players.LocalPlayer
    local lines = {}
    if not player then return "LocalPlayer indisponível" end
    table.insert(lines, "Player=" .. player.Name .. " | UserId=" .. tostring(player.UserId))
    local attributes = readAttributes(player)
    table.insert(lines, "Player.attrs={" .. table.concat(attributes, "; ") .. "}")
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local values = {}
        for _, child in ipairs(leaderstats:GetChildren()) do
            if child:IsA("ValueBase") then
                local ok, value = pcall(function() return child.Value end)
                if ok then table.insert(values, child.Name .. "=" .. formatValue(value)) end
            end
        end
        table.sort(values)
        table.insert(lines, "leaderstats={" .. table.concat(values, "; ") .. "}")
    end
    local character = player.Character
    if not character then
        table.insert(lines, "Character=nil")
        return table.concat(lines, "\n")
    end
    table.insert(lines, "Character=" .. fullName(character))
    table.insert(lines, "Character.attrs={" .. table.concat(readAttributes(character), "; ") .. "}")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        table.insert(lines, string.format(
            "Humanoid: Health=%s/%s | WalkSpeed=%s | JumpHeight=%s | JumpPower=%s | Sit=%s",
            tostring(humanoid.Health), tostring(humanoid.MaxHealth), tostring(humanoid.WalkSpeed),
            tostring(humanoid.JumpHeight), tostring(humanoid.JumpPower), tostring(humanoid.Sit)))
    end
    local babyObjects = {}
    local tools = {}
    for _, descendant in ipairs(character:GetDescendants()) do
        if containsRelevant(descendant.Name) then
            table.insert(babyObjects, fullName(descendant) .. ":" .. descendant.ClassName)
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then table.insert(tools, child.Name .. "(equipado)") end
    end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then table.insert(tools, child.Name .. "(mochila)") end
        end
    end
    table.sort(babyObjects)
    table.sort(tools)
    table.insert(lines, "objetosBaby={" .. table.concat(babyObjects, "; ") .. "}")
    table.insert(lines, "tools={" .. table.concat(tools, "; ") .. "}")
    return table.concat(lines, "\n")
end

local function sessionHeader()
    return table.concat({
        "H INSPECT — COLETA GUIADA DO BEBÊ",
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

local function installOutboundObserver(callback)
    local key = "__HINSPECT_OUTBOUND_OBSERVER"
    local state = rawget(_G, key)
    if type(state) ~= "table" or type(state.Listeners) ~= "table" then
        state = { Listeners = {}, NextId = 0, Available = false }
        rawset(_G, key, state)
        if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
            local oldNamecall
            local wrapper = function(self, ...)
                local method = ""
                pcall(function() method = getnamecallmethod() end)
                if method == "FireServer" or method == "InvokeServer" then
                    local current = rawget(_G, key)
                    if type(current) == "table" and type(current.Listeners) == "table" then
                        local callerIsExecutor = nil
                        if type(checkcaller) == "function" then
                            pcall(function() callerIsExecutor = checkcaller() end)
                        end
                        local packed = table.pack(...)
                        for _, listener in pairs(current.Listeners) do
                            pcall(listener, self, method, packed, callerIsExecutor)
                        end
                    end
                end
                return oldNamecall(self, ...)
            end
            if type(newcclosure) == "function" then wrapper = newcclosure(wrapper) end
            local ok, result = pcall(function()
                oldNamecall = hookmetamethod(game, "__namecall", wrapper)
                return oldNamecall
            end)
            if ok and type(result) == "function" then
                state.Available = true
            else
                state.Error = oneLine(result)
            end
        else
            state.Error = "hookmetamethod/getnamecallmethod indisponível"
        end
    end
    state.NextId = (tonumber(state.NextId) or 0) + 1
    local listenerId = state.NextId
    state.Listeners[listenerId] = callback
    local function remove()
        local current = rawget(_G, key)
        if type(current) == "table" and type(current.Listeners) == "table" then
            current.Listeners[listenerId] = nil
        end
    end
    return state.Available == true, remove, state.Error
end

function Baby:Create(context)
    context = context or {}
    local ui = context.UI
    local settings = { BabyScanRadius = 60 }
    local active = false
    local destroyed = false
    local startedAt = nil
    local initialState = ""
    local finalState = ""
    local lastReport = ""
    local connections = {}
    local remoteConnections = {}
    local outboundRemove = nil
    local outboundAvailable = false
    local outboundError = nil
    local baselineInstances = {}
    local addedEntries = {}
    local removedEntries = {}
    local nearbyEntries = {}
    local nearbySeen = {}
    local timeline = {}
    local inbound = {}
    local outbound = {}
    local promptEvents = {}
    local dropPosition = nil
    local dropIdentifier = nil
    local captureGeneration = 0

    local function update(id, labelValue, descriptionValue)
        if ui and type(ui.SetControlText) == "function" then
            ui:SetControlText(id, labelValue, descriptionValue)
        end
    end

    local function disconnect(bucket)
        for index = #bucket, 1, -1 do
            pcall(function() bucket[index]:Disconnect() end)
            table.remove(bucket, index)
        end
    end

    local function elapsed()
        return startedAt and math.max(0, os.clock() - startedAt) or 0
    end

    local function addTimeline(kind, detail)
        table.insert(timeline, {
            Time = utcTimestamp(),
            Elapsed = elapsed(),
            Kind = kind,
            Detail = oneLine(detail),
        })
        while #timeline > 300 do table.remove(timeline, 1) end
    end

    local function updateLiveStatus(lastEvent)
        update("baby_status", "Coleta do bebê ativa",
            string.format("%.1fs | recebidos=%d | enviados=%d | adicionados=%d | último=%s",
                elapsed(), #inbound, #outbound, #addedEntries, lastEvent or "início"))
    end

    local function scanNearDrop(label)
        if not active or not dropPosition then return end
        local radius = settings.BabyScanRadius
        local matches = {}
        for _, instance in ipairs(Workspace:GetDescendants()) do
            local path = fullName(instance)
            local isInteraction = instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
                or instance:IsA("TouchTransmitter")
            local shouldInspect = instance:IsA("BasePart") or isInteraction
                or containsRelevant(path) or not baselineInstances[instance]
            local position = shouldInspect and instancePosition(instance) or nil
            if position then
                local distance = (position - dropPosition).Magnitude
                if distance <= radius then
                    local priority = 0
                    if isInteraction then priority = priority + 100 end
                    if containsRelevant(path) then priority = priority + 50 end
                    if not baselineInstances[instance] then priority = priority + 25 end
                    if instance:IsA("BasePart") then priority = priority + 1 end
                    table.insert(matches, { Instance = instance, Distance = distance, Priority = priority })
                end
            end
        end
        table.sort(matches, function(a, b)
            if a.Priority == b.Priority then return a.Distance < b.Distance end
            return a.Priority > b.Priority
        end)
        for index, entry in ipairs(matches) do
            if index > 250 then break end
            local key = fullName(entry.Instance) .. "|" .. entry.Instance.ClassName
            if not nearbySeen[key] then
                nearbySeen[key] = true
                table.insert(nearbyEntries, {
                    Label = label,
                    Priority = entry.Priority,
                    Detail = describeInstance(entry.Instance, dropPosition),
                })
            end
        end
        addTimeline("varredura", string.format("%s: %d objetos em até %d studs",
            label, math.min(#matches, 250), radius))
    end

    local function scheduleDropScans()
        local generation = captureGeneration
        scanNearDrop("imediata")
        task.delay(0.12, function()
            if active and generation == captureGeneration then scanNearDrop("+0.12s") end
        end)
        task.delay(0.50, function()
            if active and generation == captureGeneration then scanNearDrop("+0.50s") end
        end)
    end

    local function recordInbound(remote, ...)
        if not active then return end
        local packed = table.pack(...)
        local path = fullName(remote)
        local argumentText = formatPacked(packed)
        table.insert(inbound, {
            Time = utcTimestamp(), Elapsed = elapsed(), Path = path,
            ArgumentCount = packed.n, Arguments = argumentText,
        })
        while #inbound > 200 do table.remove(inbound, 1) end
        addTimeline("recebido", path .. " | " .. argumentText)
        if string.lower(remote.Name) == "babyaction" then
            local action = packed[1]
            if action == "dropBaby" and typeof(packed[2]) == "CFrame" then
                dropPosition = packed[2].Position
                dropIdentifier = packed[3]
                scheduleDropScans()
            elseif action == "cleanUp" then
                task.delay(0.10, function()
                    if active then finalState = snapshotLocalPlayer() end
                end)
            end
        end
        updateLiveStatus(path)
    end

    local monitoredRemotes = {}
    local function monitorRemote(instance)
        if monitoredRemotes[instance] then return end
        if not (instance:IsA("RemoteEvent") or instance:IsA("UnreliableRemoteEvent")) then return end
        monitoredRemotes[instance] = true
        local ok, connection = pcall(function()
            return instance.OnClientEvent:Connect(function(...)
                recordInbound(instance, ...)
            end)
        end)
        if ok and connection then table.insert(remoteConnections, connection) end
    end

    local function connectPlayerSignals()
        local player = Players.LocalPlayer
        if not player then return end
        table.insert(connections, player.AttributeChanged:Connect(function(name)
            if active then
                addTimeline("Player.Attribute", name .. "=" .. formatValue(player:GetAttribute(name)))
            end
        end))
        local function bindCharacter(character)
            if not character then return end
            table.insert(connections, character.AttributeChanged:Connect(function(name)
                if active then
                    addTimeline("Character.Attribute", name .. "=" .. formatValue(character:GetAttribute(name)))
                end
            end))
            table.insert(connections, character.DescendantAdded:Connect(function(instance)
                if active and containsRelevant(instance.Name) then
                    addTimeline("Character.Adicionado", fullName(instance) .. ":" .. instance.ClassName)
                end
            end))
            table.insert(connections, character.DescendantRemoving:Connect(function(instance)
                if active and containsRelevant(instance.Name) then
                    addTimeline("Character.Removido", fullName(instance) .. ":" .. instance.ClassName)
                end
            end))
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, property in ipairs({ "WalkSpeed", "JumpHeight", "JumpPower", "Sit" }) do
                    table.insert(connections, humanoid:GetPropertyChangedSignal(property):Connect(function()
                        if active then
                            addTimeline("Humanoid." .. property, formatValue(humanoid[property]))
                        end
                    end))
                end
            end
        end
        bindCharacter(player.Character)
        table.insert(connections, player.CharacterAdded:Connect(function(character)
            if active then
                addTimeline("Character", "novo personagem: " .. fullName(character))
                bindCharacter(character)
            end
        end))
    end

    local function resetData()
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        active = false
        startedAt = nil
        initialState = ""
        finalState = ""
        lastReport = ""
        baselineInstances = {}
        addedEntries = {}
        removedEntries = {}
        nearbyEntries = {}
        nearbySeen = {}
        timeline = {}
        inbound = {}
        outbound = {}
        promptEvents = {}
        dropPosition = nil
        dropIdentifier = nil
        outboundAvailable = false
        outboundError = nil
        monitoredRemotes = {}
        captureGeneration = captureGeneration + 1
    end

    local function startCapture()
        resetData()
        active = true
        startedAt = os.clock()
        initialState = snapshotLocalPlayer()
        local descendants = Workspace:GetDescendants()
        baselineInstances[Workspace] = true
        for _, instance in ipairs(descendants) do baselineInstances[instance] = true end

        table.insert(connections, Workspace.DescendantAdded:Connect(function(instance)
            if not active or baselineInstances[instance] then return end
            local entry = {
                Time = utcTimestamp(), Elapsed = elapsed(), Instance = instance,
                Detail = describeInstance(instance, dropPosition),
            }
            table.insert(addedEntries, entry)
            if #addedEntries > 600 then table.remove(addedEntries, 1) end
            if containsRelevant(fullName(instance)) or instance:IsA("ProximityPrompt")
                or instance:IsA("ClickDetector") or instance:IsA("TouchTransmitter") then
                addTimeline("Workspace.Adicionado", fullName(instance) .. ":" .. instance.ClassName)
            end
        end))
        table.insert(connections, Workspace.DescendantRemoving:Connect(function(instance)
            if not active then return end
            local interesting = not baselineInstances[instance] or containsRelevant(fullName(instance))
                or instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
                or instance:IsA("TouchTransmitter")
            if interesting then
                table.insert(removedEntries, {
                    Time = utcTimestamp(), Elapsed = elapsed(),
                    Detail = describeInstance(instance, dropPosition),
                })
                if #removedEntries > 300 then table.remove(removedEntries, 1) end
            end
        end))
        connectPlayerSignals()

        local function recordPromptEvent(kind, prompt, extra)
            if not active or not prompt then return end
            local detail = describeInstance(prompt, dropPosition)
            if extra ~= nil then detail = detail .. " | extra=" .. formatValue(extra) end
            table.insert(promptEvents, {
                Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind, Detail = detail,
            })
            while #promptEvents > 100 do table.remove(promptEvents, 1) end
            addTimeline("Prompt." .. kind, fullName(prompt))
            updateLiveStatus(fullName(prompt))
        end
        local promptSignals = {
            { Name = "Shown", Event = "PromptShown" },
            { Name = "Hidden", Event = "PromptHidden" },
            { Name = "Triggered", Event = "PromptTriggered" },
            { Name = "TriggerEnded", Event = "PromptTriggerEnded" },
        }
        for _, item in ipairs(promptSignals) do
            local ok, connection = pcall(function()
                return ProximityPromptService[item.Event]:Connect(function(prompt, extra)
                    recordPromptEvent(item.Name, prompt, extra)
                end)
            end)
            if ok and connection then table.insert(connections, connection) end
        end

        for _, instance in ipairs(ReplicatedStorage:GetDescendants()) do monitorRemote(instance) end
        table.insert(remoteConnections, ReplicatedStorage.DescendantAdded:Connect(function(instance)
            if active then monitorRemote(instance) end
        end))

        outboundAvailable, outboundRemove, outboundError = installOutboundObserver(
            function(remote, method, packed, callerIsExecutor)
                if not active then return end
                if typeof(remote) ~= "Instance" then return end
                if not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")
                    or remote:IsA("RemoteFunction")) then return end
                local entry = {
                    Time = utcTimestamp(), Elapsed = elapsed(), Method = method,
                    Path = fullName(remote), ArgumentCount = packed.n,
                    Arguments = formatPacked(packed), CallerIsExecutor = callerIsExecutor,
                }
                table.insert(outbound, entry)
                while #outbound > 200 do table.remove(outbound, 1) end
                addTimeline("enviado", entry.Method .. " " .. entry.Path .. " | " .. entry.Arguments)
                updateLiveStatus(entry.Path)
            end)

        addTimeline("início", "base salva com " .. tostring(#descendants) .. " descendentes no Workspace")
        update("baby_status", "Coleta iniciada — solte e pegue o bebê",
            outboundAvailable
                and "Observação de chamadas enviadas disponível. Faça somente a ação normal de soltar e pegar."
                or ("Chamadas enviadas indisponíveis neste executor: " .. tostring(outboundError)))
        update("baby_report", "Coleta em andamento",
            "Quando terminar de pegar o bebê, clique em Encerrar e analisar ou diretamente em Copiar.")
    end

    local function buildReport()
        local lines = {
            sessionHeader(),
            "",
            string.format("Duração: %.2fs | raio: %d studs", elapsed(), settings.BabyScanRadius),
            "Chamadas cliente → servidor: " .. (outboundAvailable and "capturadas quando observadas"
                or ("indisponíveis — " .. tostring(outboundError))),
            "A coleta não disparou remotes nem interações; apenas observou a ação normal do jogador.",
            "",
            "ESTADO INICIAL — BEBÊ CARREGADO",
            initialState ~= "" and initialState or "não capturado",
            "",
            "ESTADO FINAL — APÓS O PICKUP",
            finalState ~= "" and finalState or "não capturado",
            "",
            "DROP DETECTADO",
            "posição=" .. (dropPosition and formatValue(dropPosition) or "não observada"),
            "identificador=" .. formatValue(dropIdentifier),
            "",
            "LINHA DO TEMPO",
        }
        if #timeline == 0 then table.insert(lines, "  nenhum evento") end
        for index, entry in ipairs(timeline) do
            table.insert(lines, string.format("%03d. [+%.3fs] [%s] %s — %s",
                index, entry.Elapsed, entry.Time, entry.Kind, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "EVENTOS DE PROXIMITY PROMPT")
        if #promptEvents == 0 then table.insert(lines, "  nenhum prompt mostrado ou acionado") end
        for index, entry in ipairs(promptEvents) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Kind))
            table.insert(lines, "     " .. entry.Detail)
        end

        table.insert(lines, "")
        table.insert(lines, "CHAMADAS ENVIADAS PELO CLIENTE")
        if not outboundAvailable then
            table.insert(lines, "  não foi possível observar FireServer/InvokeServer neste executor")
        elseif #outbound == 0 then
            table.insert(lines, "  nenhuma chamada enviada foi observada durante a coleta")
        end
        for index, entry in ipairs(outbound) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s %s | callerExecutor=%s",
                index, entry.Elapsed, entry.Method, entry.Path, tostring(entry.CallerIsExecutor)))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "EVENTOS RECEBIDOS DO SERVIDOR")
        if #inbound == 0 then table.insert(lines, "  nenhum evento recebido") end
        for index, entry in ipairs(inbound) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Path))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "OBJETOS ADICIONADOS DURANTE A COLETA")
        if #addedEntries == 0 then table.insert(lines, "  nenhum objeto adicionado") end
        for index, entry in ipairs(addedEntries) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "OBJETOS REMOVIDOS DURANTE A COLETA")
        if #removedEntries == 0 then table.insert(lines, "  nenhum candidato removido") end
        for index, entry in ipairs(removedEntries) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "OBJETOS PRÓXIMOS AO DROP")
        if #nearbyEntries == 0 then table.insert(lines, "  nenhuma varredura próxima disponível") end
        for index, entry in ipairs(nearbyEntries) do
            table.insert(lines, string.format("%03d. [%s] prioridade=%d | %s",
                index, entry.Label, entry.Priority, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "COMO INTERPRETAR")
        table.insert(lines, "- ProximityPrompt, ClickDetector ou TouchTransmitter perto do drop indica interação física.")
        table.insert(lines, "- FireServer/InvokeServer próximo do pickup indica o caminho e os argumentos usados pelo cliente.")
        table.insert(lines, "- cleanUp é confirmação servidor → cliente; sozinho não prova qual ação iniciou o pickup.")
        return table.concat(lines, "\n")
    end

    local function finishCapture()
        if not active then
            if lastReport == "" then
                update("baby_status", "Nenhuma coleta ativa", "Inicie carregando o bebê antes de analisar.")
            end
            return lastReport
        end
        finalState = snapshotLocalPlayer()
        active = false
        captureGeneration = captureGeneration + 1
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        lastReport = buildReport()
        update("baby_status", "Coleta do bebê concluída",
            string.format("recebidos=%d | enviados=%d | adicionados=%d | próximos=%d",
                #inbound, #outbound, #addedEntries, #nearbyEntries))
        update("baby_report", "Prévia da investigação", preview(lastReport, 4200))
        return lastReport
    end

    local function copyReport()
        if active then finishCapture() end
        if lastReport == "" then
            update("baby_status", "Nada para copiar", "Inicie, solte e pegue o bebê antes de copiar.")
            return
        end
        local clipboard = type(setclipboard) == "function" and setclipboard
            or (type(toclipboard) == "function" and toclipboard or nil)
        if not clipboard then
            update("baby_status", "Área de transferência indisponível",
                "Este executor não oferece setclipboard/toclipboard. Use a prévia ou o console.")
            print(lastReport)
            return
        end
        local ok, err = pcall(clipboard, lastReport)
        if ok then
            update("baby_status", "Relatório do bebê copiado",
                string.format("%d caracteres prontos para enviar.", #lastReport))
        else
            update("baby_status", "Falha ao copiar", oneLine(err))
        end
    end

    local runtime = {}

    function runtime:Set(name, value)
        if name == "BabyScanRadius" then
            settings.BabyScanRadius = math.clamp(tonumber(value) or 60, 15, 150)
        elseif name == "StartBabyCapture" then
            startCapture()
        elseif name == "FinishBabyCapture" then
            finishCapture()
        elseif name == "CopyBabyCapture" then
            copyReport()
        elseif name == "ClearBabyCapture" then
            resetData()
            update("baby_status", "Coleta apagada", "Inicie novamente enquanto estiver carregando o bebê.")
            update("baby_report", "Prévia da investigação", "Os eventos e candidatos de interação aparecerão aqui.")
        end
    end

    function runtime:Destroy()
        if destroyed then return end
        destroyed = true
        resetData()
    end

    return runtime
end

return Baby
