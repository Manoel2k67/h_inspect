local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local AttackCapture = {}

local COMBAT_WORDS = {
    "attack", "combat", "cooldown", "damage", "debounce", "fight", "fist",
    "hit", "knife", "melee", "punch", "push", "shot", "swing", "weapon",
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
    if valueType == "Instance" then return fullName(value) end
    if valueType ~= "table" then return oneLine(value) end
    if depth >= 3 then return "{...}" end
    if seen[value] then return "<ciclo>" end
    seen[value] = true
    local entries = {}
    local count = 0
    for key, nested in pairs(value) do
        count = count + 1
        if count > 30 then
            table.insert(entries, "...")
            break
        end
        table.insert(entries, "[" .. formatValue(key, depth + 1, seen) .. "]="
            .. formatValue(nested, depth + 1, seen))
    end
    table.sort(entries)
    seen[value] = nil
    return "{" .. table.concat(entries, ", ") .. "}"
end

local function formatPacked(packed)
    local entries = {}
    for index = 1, packed.n do
        table.insert(entries, string.format("[%d]=%s", index,
            formatValue(packed[index], 0, {})))
    end
    return packed.n > 0 and table.concat(entries, " | ") or "(nenhum)"
end

local function containsCombatWord(value)
    local lowered = string.lower(tostring(value or ""))
    for _, word in ipairs(COMBAT_WORDS) do
        if string.find(lowered, word, 1, true) then return true end
    end
    return false
end

local function sortedAttributes(instance)
    local ok, attributes = pcall(function() return instance:GetAttributes() end)
    if not ok or type(attributes) ~= "table" then return {} end
    local entries = {}
    for name, value in pairs(attributes) do
        table.insert(entries, tostring(name) .. "=" .. formatValue(value))
    end
    table.sort(entries)
    return entries
end

local function sortedTags(instance)
    local ok, tags = pcall(function() return CollectionService:GetTags(instance) end)
    if not ok or type(tags) ~= "table" then return {} end
    table.sort(tags)
    return tags
end

local function toolLocation(tool, localPlayer)
    local character = localPlayer and localPlayer.Character
    local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
    if character and tool:IsDescendantOf(character) then return "equipado" end
    if backpack and tool:IsDescendantOf(backpack) then return "mochila" end
    return tool.Parent and fullName(tool.Parent) or "sem pai"
end

local function describeTool(tool, localPlayer)
    local lines = {
        string.format("Tool=%s | caminho=%s | estado=%s | Enabled=%s",
            tool.Name, fullName(tool), toolLocation(tool, localPlayer), tostring(tool.Enabled)),
    }
    local attributes = sortedAttributes(tool)
    table.insert(lines, "  attrs={" .. table.concat(attributes, "; ") .. "}")
    local tags = sortedTags(tool)
    if #tags > 0 then table.insert(lines, "  tags={" .. table.concat(tags, ", ") .. "}") end

    local descendants = tool:GetDescendants()
    table.sort(descendants, function(a, b) return fullName(a) < fullName(b) end)
    for index, object in ipairs(descendants) do
        if index > 180 then
            table.insert(lines, string.format("  ... +%d descendentes", #descendants - 180))
            break
        end
        local details = { object.Name .. "<" .. object.ClassName .. ">" }
        if object:IsA("ValueBase") then
            local ok, value = pcall(function() return object.Value end)
            if ok then table.insert(details, "value=" .. formatValue(value)) end
        elseif object:IsA("Sound") then
            table.insert(details, "SoundId=" .. formatValue(object.SoundId))
        end
        local objectAttributes = sortedAttributes(object)
        if #objectAttributes > 0 then
            table.insert(details, "attrs={" .. table.concat(objectAttributes, "; ") .. "}")
        end
        local objectTags = sortedTags(object)
        if #objectTags > 0 then table.insert(details, "tags={" .. table.concat(objectTags, ", ") .. "}") end
        table.insert(lines, "  - " .. table.concat(details, " | "))
    end
    return table.concat(lines, "\n")
end

local function describeInstanceAttributes(label, instance)
    if not instance then return label .. "=nil" end
    return label .. "={" .. table.concat(sortedAttributes(instance), "; ") .. "}"
end

local function snapshotState()
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return "LocalPlayer indisponível" end
    local lines = {
        "Player=" .. localPlayer.Name .. " | UserId=" .. tostring(localPlayer.UserId),
        describeInstanceAttributes("Player.attrs", localPlayer),
        describeInstanceAttributes("Character.attrs", localPlayer.Character),
    }
    local tools = {}
    local seen = {}
    local containers = { localPlayer.Character, localPlayer:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") and not seen[child] then
                    seen[child] = true
                    table.insert(tools, child)
                end
            end
        end
    end
    table.sort(tools, function(a, b) return string.lower(a.Name) < string.lower(b.Name) end)
    table.insert(lines, "Tools=" .. tostring(#tools))
    for _, tool in ipairs(tools) do table.insert(lines, describeTool(tool, localPlayer)) end
    return table.concat(lines, "\n")
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
                        local callingScript = nil
                        if type(getcallingscript) == "function" then
                            pcall(function() callingScript = getcallingscript() end)
                        end
                        local packed = table.pack(...)
                        for _, listener in pairs(current.Listeners) do
                            pcall(listener, self, method, packed, callerIsExecutor, callingScript)
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

function AttackCapture:Create(context)
    context = context or {}
    local ui = context.UI
    local settings = {
        CaptureLabel = "Push — Red Light/Green Light",
        CaptureInbound = true,
    }
    local active = false
    local destroyed = false
    local startedAt = nil
    local lastReport = ""
    local initialState = ""
    local finalState = ""
    local connections = {}
    local remoteConnections = {}
    local outboundRemove = nil
    local outboundAvailable = false
    local outboundError = nil
    local outbound = {}
    local inbound = {}
    local activations = {}
    local stateChanges = {}
    local timeline = {}
    local monitoredRemotes = setmetatable({}, { __mode = "k" })
    local watchedTools = setmetatable({}, { __mode = "k" })
    local watchedObjects = setmetatable({}, { __mode = "k" })
    local lastAttemptAt = -math.huge
    local lastAttemptTool = "nenhuma"

    local function update(id, labelValue, descriptionValue)
        if ui and type(ui.SetControlText) == "function" then
            ui:SetControlText(id, labelValue, descriptionValue)
        end
    end

    local function connect(bucket, signal, callback)
        local ok, connection = pcall(function() return signal:Connect(callback) end)
        if ok and connection then table.insert(bucket, connection) end
        return connection
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

    local function appendLimited(bucket, entry, maximum)
        table.insert(bucket, entry)
        while #bucket > maximum do table.remove(bucket, 1) end
    end

    local function addTimeline(kind, detail)
        appendLimited(timeline, {
            Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind, Detail = oneLine(detail),
        }, 500)
    end

    local function equippedToolNames()
        local localPlayer = Players.LocalPlayer
        local character = localPlayer and localPlayer.Character
        local names = {}
        if character then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") then table.insert(names, child.Name) end
            end
        end
        table.sort(names)
        return #names > 0 and table.concat(names, ", ") or "nenhuma"
    end

    local function updateLiveStatus(lastEvent)
        update("attack_status", "Captura de combate ativa — " .. settings.CaptureLabel,
            string.format("%.1fs | tentativas=%d | enviados=%d | mudanças=%d | equipado=%s | último=%s",
                elapsed(), #activations, #outbound, #stateChanges, equippedToolNames(),
                oneLine(lastEvent or "início")))
    end

    local function recordState(kind, object, value)
        if not active then return end
        local entry = {
            Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind,
            Path = object and fullName(object) or "?", Value = formatValue(value),
        }
        appendLimited(stateChanges, entry, 500)
        addTimeline(kind, entry.Path .. " = " .. entry.Value)
    end

    local function watchObject(object, label)
        if watchedObjects[object] then return end
        watchedObjects[object] = true
        connect(connections, object.AttributeChanged, function(name)
            if active then
                recordState(label .. ".Attribute", object,
                    tostring(name) .. "=" .. formatValue(object:GetAttribute(name)))
            end
        end)
        if object:IsA("ValueBase") then
            connect(connections, object.Changed, function(value)
                recordState(label .. ".Value", object, value)
            end)
        end
    end

    local function recordAttempt(kind, tool, inputName)
        if not active then return end
        lastAttemptAt = elapsed()
        lastAttemptTool = tool and tool.Name or equippedToolNames()
        local entry = {
            Time = utcTimestamp(), Elapsed = lastAttemptAt, Kind = kind,
            Tool = lastAttemptTool, Path = tool and fullName(tool) or "?",
            Enabled = tool and tostring(tool.Enabled) or "?", Input = inputName or "",
        }
        appendLimited(activations, entry, 200)
        addTimeline(kind, string.format("tool=%s | Enabled=%s | input=%s",
            entry.Tool, entry.Enabled, entry.Input ~= "" and entry.Input or "n/a"))
        updateLiveStatus(kind .. " " .. entry.Tool)
    end

    local function watchTool(tool)
        if not tool:IsA("Tool") or watchedTools[tool] then return end
        watchedTools[tool] = true
        watchObject(tool, "Tool")
        addTimeline("Tool detectada", describeTool(tool, Players.LocalPlayer))
        connect(connections, tool.Activated, function()
            recordAttempt("Tool.Activated", tool)
        end)
        connect(connections, tool.Equipped, function()
            addTimeline("Tool.Equipped", tool.Name .. " | " .. fullName(tool))
            updateLiveStatus("equipou " .. tool.Name)
        end)
        connect(connections, tool.Unequipped, function()
            addTimeline("Tool.Unequipped", tool.Name .. " | " .. fullName(tool))
            updateLiveStatus("desequipou " .. tool.Name)
        end)
        connect(connections, tool:GetPropertyChangedSignal("Enabled"), function()
            recordState("Tool.Enabled", tool, tool.Enabled)
        end)
        connect(connections, tool.AncestryChanged, function(_, parent)
            if active then
                addTimeline("Tool.Parent", tool.Name .. " → " .. (parent and fullName(parent) or "nil"))
            end
        end)
        for _, object in ipairs(tool:GetDescendants()) do watchObject(object, "Tool.Descendant") end
        connect(connections, tool.DescendantAdded, function(object)
            if active then addTimeline("Tool.DescendantAdded", fullName(object) .. ":" .. object.ClassName) end
            watchObject(object, "Tool.Descendant")
        end)
        connect(connections, tool.DescendantRemoving, function(object)
            if active then addTimeline("Tool.DescendantRemoving", fullName(object) .. ":" .. object.ClassName) end
        end)
    end

    local function watchContainer(container, label)
        if not container then return end
        watchObject(container, label)
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then watchTool(child) end
        end
        connect(connections, container.ChildAdded, function(child)
            if child:IsA("Tool") then
                watchTool(child)
                if active then addTimeline(label .. ".ToolAdded", child.Name) end
            end
        end)
        connect(connections, container.ChildRemoved, function(child)
            if active and child:IsA("Tool") then addTimeline(label .. ".ToolRemoved", child.Name) end
        end)
    end

    local function bindLocalPlayer()
        local localPlayer = Players.LocalPlayer
        if not localPlayer then return end
        watchObject(localPlayer, "Player")
        watchContainer(localPlayer:FindFirstChildOfClass("Backpack"), "Backpack")
        watchContainer(localPlayer.Character, "Character")
        connect(connections, localPlayer.ChildAdded, function(child)
            if child:IsA("Backpack") then watchContainer(child, "Backpack") end
        end)
        connect(connections, localPlayer.CharacterAdded, function(character)
            if active then addTimeline("CharacterAdded", fullName(character)) end
            watchContainer(character, "Character")
        end)
    end

    local function recordInbound(remote, ...)
        if not active or not settings.CaptureInbound then return end
        local packed = table.pack(...)
        local arguments = formatPacked(packed)
        local path = fullName(remote)
        local sinceAttempt = elapsed() - lastAttemptAt
        if sinceAttempt > 3 and not containsCombatWord(path .. " " .. arguments) then return end
        appendLimited(inbound, {
            Time = utcTimestamp(), Elapsed = elapsed(), Path = path,
            ArgumentCount = packed.n, Arguments = arguments,
            AttemptTool = lastAttemptTool, SinceAttempt = sinceAttempt,
        }, 250)
        addTimeline("Remote recebido", path .. " | " .. arguments)
    end

    local function monitorRemote(remote)
        if monitoredRemotes[remote] then return end
        if not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then return end
        monitoredRemotes[remote] = true
        connect(remoteConnections, remote.OnClientEvent, function(...)
            recordInbound(remote, ...)
        end)
    end

    local function monitorRemoteRoot(root)
        if not root then return end
        for _, object in ipairs(root:GetDescendants()) do monitorRemote(object) end
        connect(remoteConnections, root.DescendantAdded, function(object)
            if active then monitorRemote(object) end
        end)
    end

    local function resetData()
        active = false
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        startedAt = nil
        lastReport = ""
        initialState = ""
        finalState = ""
        outboundAvailable = false
        outboundError = nil
        outbound = {}
        inbound = {}
        activations = {}
        stateChanges = {}
        timeline = {}
        monitoredRemotes = setmetatable({}, { __mode = "k" })
        watchedTools = setmetatable({}, { __mode = "k" })
        watchedObjects = setmetatable({}, { __mode = "k" })
        lastAttemptAt = -math.huge
        lastAttemptTool = "nenhuma"
    end

    local function startCapture()
        resetData()
        active = true
        startedAt = os.clock()
        initialState = snapshotState()
        bindLocalPlayer()

        connect(connections, UserInputService.InputBegan, function(input, gameProcessed)
            if not active or gameProcessed then return end
            local inputType = input.UserInputType
            local attackInput = inputType == Enum.UserInputType.MouseButton1
                or inputType == Enum.UserInputType.Touch
                or (inputType == Enum.UserInputType.Gamepad1
                    and input.KeyCode == Enum.KeyCode.ButtonR2)
            if attackInput then
                local localPlayer = Players.LocalPlayer
                local character = localPlayer and localPlayer.Character
                local equipped = character and character:FindFirstChildOfClass("Tool") or nil
                if equipped then recordAttempt("Input de ataque", equipped, tostring(inputType)) end
            end
        end)

        monitorRemoteRoot(ReplicatedStorage)
        monitorRemoteRoot(Workspace)
        outboundAvailable, outboundRemove, outboundError = installOutboundObserver(
            function(remote, method, packed, callerIsExecutor, callingScript)
                if not active or typeof(remote) ~= "Instance" then return end
                if not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")
                    or remote:IsA("RemoteFunction")) then return end
                local now = elapsed()
                local sinceAttempt = now - lastAttemptAt
                local entry = {
                    Time = utcTimestamp(), Elapsed = now, Method = method,
                    Path = fullName(remote), ArgumentCount = packed.n,
                    Arguments = formatPacked(packed), CallerIsExecutor = callerIsExecutor,
                    CallingScript = callingScript and fullName(callingScript) or "indisponível",
                    AttemptTool = lastAttemptTool,
                    SinceAttempt = sinceAttempt < 60 and sinceAttempt or nil,
                    Equipped = equippedToolNames(),
                }
                appendLimited(outbound, entry, 300)
                addTimeline("Remote enviado", method .. " " .. entry.Path .. " | " .. entry.Arguments)
                updateLiveStatus(entry.Path)
            end)

        addTimeline("Início", settings.CaptureLabel .. " | estado inicial salvo")
        update("attack_status", "Captura iniciada — " .. settings.CaptureLabel,
            outboundAvailable
                and "Agora equipe, use uma vez e tente novamente durante a recarga."
                or ("Seu executor não permite observar FireServer/InvokeServer: " .. tostring(outboundError)))
        update("attack_report", "Captura em andamento",
            "O H Inspect está apenas observando. Faça o ataque normalmente e depois clique em Analisar.")
    end

    local function buildReport()
        local lines = {
            "H INSPECT — CAPTURA GUIADA DE COMBATE",
            "Teste: " .. settings.CaptureLabel,
            "UTC: " .. utcTimestamp(),
            "PlaceId: " .. tostring(game.PlaceId or "?"),
            "GameId: " .. tostring(game.GameId or "?"),
            "JobId: " .. tostring(game.JobId or "?"),
            string.format("Duração: %.2fs", elapsed()),
            "Chamadas cliente → servidor: " .. (outboundAvailable and "observação disponível"
                or ("indisponível — " .. tostring(outboundError))),
            "A captura não equipou ferramentas, não ativou ataques e não disparou remotes.",
            "",
            "ESTADO INICIAL",
            initialState ~= "" and initialState or "não capturado",
            "",
            "ESTADO FINAL",
            finalState ~= "" and finalState or "não capturado",
            "",
            "TENTATIVAS E ATIVAÇÕES",
        }
        if #activations == 0 then table.insert(lines, "  nenhuma tentativa detectada") end
        for index, entry in ipairs(activations) do
            table.insert(lines, string.format(
                "%03d. [+%.3fs] %s | tool=%s | Enabled=%s | input=%s | caminho=%s",
                index, entry.Elapsed, entry.Kind, entry.Tool, entry.Enabled,
                entry.Input ~= "" and entry.Input or "n/a", entry.Path))
        end

        table.insert(lines, "")
        table.insert(lines, "CHAMADAS ENVIADAS PELO CLIENTE")
        if not outboundAvailable then
            table.insert(lines, "  o executor não expôs hookmetamethod/getnamecallmethod")
        elseif #outbound == 0 then
            table.insert(lines, "  nenhuma chamada FireServer/InvokeServer foi observada")
        end
        for index, entry in ipairs(outbound) do
            local correlation = entry.SinceAttempt and string.format("%.3fs após %s",
                entry.SinceAttempt, entry.AttemptTool) or "sem tentativa recente"
            table.insert(lines, string.format(
                "%03d. [+%.3fs] %s %s | equipado=%s | correlação=%s",
                index, entry.Elapsed, entry.Method, entry.Path, entry.Equipped, correlation))
            table.insert(lines, "     script=" .. entry.CallingScript
                .. " | callerExecutor=" .. tostring(entry.CallerIsExecutor))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "MUDANÇAS DE ESTADO")
        if #stateChanges == 0 then table.insert(lines, "  nenhuma mudança observada") end
        for index, entry in ipairs(stateChanges) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s | %s | %s",
                index, entry.Elapsed, entry.Kind, entry.Path, entry.Value))
        end

        table.insert(lines, "")
        table.insert(lines, "EVENTOS RECEBIDOS DO SERVIDOR")
        if not settings.CaptureInbound then
            table.insert(lines, "  captura desativada")
        elseif #inbound == 0 then
            table.insert(lines, "  nenhum evento relevante observado")
        end
        for index, entry in ipairs(inbound) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s | %.3fs após %s",
                index, entry.Elapsed, entry.Path, entry.SinceAttempt, entry.AttemptTool))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "LINHA DO TEMPO")
        if #timeline == 0 then table.insert(lines, "  nenhum evento") end
        for index, entry in ipairs(timeline) do
            table.insert(lines, string.format("%03d. [+%.3fs] [%s] %s — %s",
                index, entry.Elapsed, entry.Time, entry.Kind, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "COMO COMPARAR")
        table.insert(lines, "- Faça um relatório somente do Push e outro somente do soco/arma.")
        table.insert(lines, "- O remote logo após Tool.Activated ou Input de ataque é o principal candidato.")
        table.insert(lines, "- Se a segunda tentativa não gerar remote, a recarga está bloqueando antes do servidor.")
        table.insert(lines, "- Se ela gerar o mesmo remote mas não surtir efeito, a recarga é provavelmente validada no servidor.")
        return table.concat(lines, "\n")
    end

    local function finishCapture()
        if not active then
            if lastReport == "" then
                update("attack_status", "Nenhuma captura ativa",
                    "Clique em Iniciar antes de equipar e usar a ferramenta.")
            end
            return lastReport
        end
        finalState = snapshotState()
        active = false
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        lastReport = buildReport()
        update("attack_status", "Captura concluída — " .. settings.CaptureLabel,
            string.format("tentativas=%d | enviados=%d | recebidos=%d | mudanças=%d",
                #activations, #outbound, #inbound, #stateChanges))
        local preview = #lastReport <= 4800 and lastReport
            or string.sub(lastReport, 1, 4800) .. "\n... prévia truncada; copie o relatório completo."
        update("attack_report", "Prévia da investigação", preview)
        return lastReport
    end

    local function copyReport()
        if active then finishCapture() end
        if lastReport == "" then
            update("attack_status", "Nada para copiar", "Faça uma captura de combate primeiro.")
            return
        end
        local clipboard = type(setclipboard) == "function" and setclipboard
            or (type(toclipboard) == "function" and toclipboard or nil)
        if not clipboard then
            print(lastReport)
            update("attack_status", "Área de transferência indisponível",
                "O relatório completo foi enviado ao console.")
            return
        end
        local ok, err = pcall(clipboard, lastReport)
        if ok then
            update("attack_status", "Relatório copiado — " .. settings.CaptureLabel,
                string.format("%d caracteres prontos para enviar.", #lastReport))
        else
            update("attack_status", "Falha ao copiar", oneLine(err))
        end
    end

    local runtime = {}

    function runtime:Set(name, value)
        if destroyed then return end
        if name == "CaptureLabel" then
            settings.CaptureLabel = tostring(value or "Captura de combate")
        elseif name == "CaptureInbound" then
            settings.CaptureInbound = value == true
        elseif name == "StartAttackCapture" then
            startCapture()
        elseif name == "FinishAttackCapture" then
            finishCapture()
        elseif name == "CopyAttackCapture" then
            copyReport()
        elseif name == "ClearAttackCapture" then
            resetData()
            update("attack_status", "Captura apagada",
                "Inicie uma nova coleta antes de equipar a próxima ferramenta.")
            update("attack_report", "Prévia da investigação",
                "Ativações, remotes e mudanças de estado aparecerão aqui.")
        end
    end

    function runtime:Destroy()
        if destroyed then return end
        destroyed = true
        resetData()
    end

    return runtime
end

return AttackCapture
