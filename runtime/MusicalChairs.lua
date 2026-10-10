local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")

local MusicalChairs = {}

local RELEVANT_WORDS = {
    "musicalchairs", "musical chairs", "chair", "seat", "sit", "stool", "bench",
    "occupant", "seatweld", "take a seat", "timer", "gamemode", "notify", "lighting",
    "cleanup", "clean up", "elimin", "dead", "kill", "movement", "replica",
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
    if valueType == "number" or valueType == "boolean" then return tostring(value) end
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
    local parts = {}
    local count = 0
    for key, nested in pairs(value) do
        count = count + 1
        if count > 24 then table.insert(parts, "...") break end
        table.insert(parts, "[" .. formatValue(key, depth + 1, seen) .. "]="
            .. formatValue(nested, depth + 1, seen))
    end
    table.sort(parts)
    seen[value] = nil
    return "{" .. table.concat(parts, ", ") .. "}"
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

local function sortedAttributes(instance)
    local ok, attributes = pcall(function() return instance:GetAttributes() end)
    if not ok or type(attributes) ~= "table" then return {} end
    local keys = {}
    for key in pairs(attributes) do table.insert(keys, tostring(key)) end
    table.sort(keys)
    local parts = {}
    for _, key in ipairs(keys) do
        table.insert(parts, key .. "=" .. formatValue(attributes[key]))
    end
    return parts
end

local function sortedTags(instance)
    local ok, tags = pcall(function() return CollectionService:GetTags(instance) end)
    if not ok or type(tags) ~= "table" then return {} end
    table.sort(tags)
    return tags
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
        if current:IsA("Model") then
            local ok, pivot = pcall(function() return current:GetPivot() end)
            if ok then return pivot.Position end
        end
        current = current.Parent
    end
    return nil
end

local function safeProperty(instance, property)
    local ok, value = pcall(function() return instance[property] end)
    return ok and value or nil
end

local function describeInstance(instance, referencePosition)
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
        table.insert(details, "anchored=" .. tostring(instance.Anchored))
        table.insert(details, "collide=" .. tostring(instance.CanCollide))
        table.insert(details, "touch=" .. tostring(instance.CanTouch))
        table.insert(details, "query=" .. tostring(instance.CanQuery))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
    end
    if instance:IsA("Seat") or instance:IsA("VehicleSeat") then
        table.insert(details, "Occupant=" .. formatValue(instance.Occupant))
        local disabled = safeProperty(instance, "Disabled")
        if disabled ~= nil then table.insert(details, "Disabled=" .. tostring(disabled)) end
    elseif instance:IsA("ProximityPrompt") then
        table.insert(details, "ActionText=" .. formatValue(instance.ActionText))
        table.insert(details, "ObjectText=" .. formatValue(instance.ObjectText))
        table.insert(details, "Enabled=" .. tostring(instance.Enabled))
        table.insert(details, "HoldDuration=" .. tostring(instance.HoldDuration))
        table.insert(details, "Distance=" .. tostring(instance.MaxActivationDistance))
    elseif instance:IsA("ClickDetector") then
        table.insert(details, "Distance=" .. tostring(instance.MaxActivationDistance))
    end

    if instance:IsA("JointInstance") or instance:IsA("WeldConstraint") then
        table.insert(details, "Part0=" .. formatValue(safeProperty(instance, "Part0")))
        table.insert(details, "Part1=" .. formatValue(safeProperty(instance, "Part1")))
        local enabled = safeProperty(instance, "Enabled")
        if enabled ~= nil then table.insert(details, "Enabled=" .. tostring(enabled)) end
    end

    local attributes = sortedAttributes(instance)
    if #attributes > 0 then table.insert(details, "attrs={" .. table.concat(attributes, "; ") .. "}") end
    local tags = sortedTags(instance)
    if #tags > 0 then table.insert(details, "tags={" .. table.concat(tags, ", ") .. "}") end

    local children = {}
    local ok, directChildren = pcall(function() return instance:GetChildren() end)
    if ok then
        for index, child in ipairs(directChildren) do
            if index > 18 then table.insert(children, "...") break end
            table.insert(children, child.Name .. "<" .. child.ClassName .. ">")
        end
    end
    if #children > 0 then table.insert(details, "filhos={" .. table.concat(children, ", ") .. "}") end
    return fullName(instance) .. "\n     " .. table.concat(details, " | ")
end

local function currentMap()
    local map = Workspace:FindFirstChild("Map")
    local chairs = map and map:FindFirstChild("MusicalChairs")
    return chairs
end

local function currentCharacterState()
    local player = Players.LocalPlayer
    if not player then return "LocalPlayer indisponível" end
    local lines = {
        "Player=" .. player.Name .. " | UserId=" .. tostring(player.UserId),
        "Player.attrs={" .. table.concat(sortedAttributes(player), "; ") .. "}",
    }
    local character = player.Character
    if not character then
        table.insert(lines, "Character=nil")
        return table.concat(lines, "\n")
    end
    table.insert(lines, "Character=" .. fullName(character))
    table.insert(lines, "Character.attrs={" .. table.concat(sortedAttributes(character), "; ") .. "}")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if humanoid then
        local seatPart = humanoid.SeatPart
        table.insert(lines, string.format(
            "Humanoid: state=%s | Sit=%s | SeatPart=%s | Health=%s/%s | WalkSpeed=%s | PlatformStand=%s | AutoRotate=%s",
            tostring(humanoid:GetState()), tostring(humanoid.Sit), formatValue(seatPart),
            tostring(humanoid.Health), tostring(humanoid.MaxHealth), tostring(humanoid.WalkSpeed),
            tostring(humanoid.PlatformStand), tostring(humanoid.AutoRotate)))
        if seatPart then
            table.insert(lines, "ASSENTO ATUAL:")
            table.insert(lines, describeInstance(seatPart, root and root.Position or nil))
            table.insert(lines, "Seat.OccupantÉLocal=" .. tostring(safeProperty(seatPart, "Occupant") == humanoid))
        end
    end
    if root then
        table.insert(lines, "HumanoidRootPart: pos=" .. formatValue(root.Position)
            .. " | velocidade=" .. formatValue(root.AssemblyLinearVelocity)
            .. " | angular=" .. formatValue(root.AssemblyAngularVelocity)
            .. " | anchored=" .. tostring(root.Anchored))
    end

    local joints = {}
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
            local lowered = string.lower(descendant.Name)
            if string.find(lowered, "seat", 1, true) or string.find(lowered, "sit", 1, true)
                or descendant.Name == "SeatWeld" then
                table.insert(joints, describeInstance(descendant, root and root.Position or nil))
            end
        end
    end
    table.insert(lines, "JUNTAS DE ASSENTO NO CHARACTER (" .. tostring(#joints) .. ")")
    if #joints == 0 then table.insert(lines, "  nenhuma") end
    for _, detail in ipairs(joints) do table.insert(lines, detail) end
    return table.concat(lines, "\n")
end

local function connectedToCharacter(instance, character)
    if not character then return false end
    local part0 = safeProperty(instance, "Part0")
    local part1 = safeProperty(instance, "Part1")
    return (typeof(part0) == "Instance" and part0:IsDescendantOf(character))
        or (typeof(part1) == "Instance" and part1:IsDescendantOf(character))
end

local function scanChairStructure(radius, limit)
    local map = currentMap()
    if not map then
        return "Workspace.Map.MusicalChairs não encontrado no momento da fotografia."
    end
    local player = Players.LocalPlayer
    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local referencePosition = root and root.Position or nil
    local descendants = map:GetDescendants()
    local classCounts = {}
    local candidates = {}
    local exactSeatCount = 0
    local occupiedSeatCount = 0
    local interactionCount = 0
    local jointCount = 0

    for _, instance in ipairs(descendants) do
        classCounts[instance.ClassName] = (classCounts[instance.ClassName] or 0) + 1
        local priority = 0
        local position = instancePosition(instance)
        local distance = position and referencePosition and (position - referencePosition).Magnitude or math.huge
        local relevantName = containsRelevant(instance.Name)

        if instance:IsA("Seat") or instance:IsA("VehicleSeat") then
            exactSeatCount = exactSeatCount + 1
            if instance.Occupant then occupiedSeatCount = occupiedSeatCount + 1 end
            priority = 1200
        elseif instance.Name == "SeatWeld" then
            priority = 1150
        elseif instance:IsA("JointInstance") or instance:IsA("WeldConstraint") then
            jointCount = jointCount + 1
            if relevantName or connectedToCharacter(instance, character) then priority = 850 end
        elseif instance:IsA("ProximityPrompt") or instance:IsA("ClickDetector")
            or instance:IsA("TouchTransmitter") then
            interactionCount = interactionCount + 1
            priority = relevantName and 800 or 650
        elseif relevantName then
            priority = 600
        end

        if instance:IsA("BasePart") and distance <= radius then
            priority = math.max(priority, 400 + math.max(0, radius - distance))
        elseif priority > 0 and distance < math.huge then
            priority = priority + math.max(0, 100 - math.min(distance, 100))
        end

        if priority > 0 then
            table.insert(candidates, { Instance = instance, Priority = priority, Distance = distance })
        end
    end

    table.sort(candidates, function(a, b)
        if a.Priority == b.Priority then
            if a.Distance == b.Distance then return fullName(a.Instance) < fullName(b.Instance) end
            return a.Distance < b.Distance
        end
        return a.Priority > b.Priority
    end)

    local classParts = {}
    for className, count in pairs(classCounts) do
        table.insert(classParts, className .. "=" .. tostring(count))
    end
    table.sort(classParts)
    local lines = {
        "Mapa=" .. fullName(map),
        string.format("descendentes=%d | Seat/VehicleSeat=%d | ocupados=%d | interações=%d | juntas=%d",
            #descendants, exactSeatCount, occupiedSeatCount, interactionCount, jointCount),
        "classes={" .. table.concat(classParts, "; ") .. "}",
        string.format("candidatos=%d | exibindo=%d | raio=%d", #candidates, math.min(#candidates, limit), radius),
    }
    if #candidates == 0 then table.insert(lines, "  nenhum candidato") end
    for index, entry in ipairs(candidates) do
        if index > limit then break end
        table.insert(lines, string.format("%03d. prioridade=%.2f", index, entry.Priority))
        table.insert(lines, "     " .. describeInstance(entry.Instance, referencePosition))
    end
    if #candidates > limit then
        table.insert(lines, "... +" .. tostring(#candidates - limit) .. " candidatos omitidos pelo limite")
    end
    return table.concat(lines, "\n")
end

local function sessionHeader()
    return table.concat({
        "H INSPECT — COLETA COMPLETA — CADEIRAS MUSICAIS",
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

function MusicalChairs:Create(context)
    context = context or {}
    local ui = context.UI
    local settings = {
        ChairScanRadius = 45,
        ChairCandidateLimit = 160,
        CaptureAllChairRemotes = false,
    }
    local active = false
    local destroyed = false
    local startedAt
    local lastReport = ""
    local snapshots = {}
    local timeline = {}
    local inbound = {}
    local outbound = {}
    local promptEvents = {}
    local structureEvents = {}
    local connections = {}
    local remoteConnections = {}
    local monitoredRemotes = setmetatable({}, { __mode = "k" })
    local monitoredSeats = setmetatable({}, { __mode = "k" })
    local outboundRemove
    local outboundAvailable = false
    local outboundError

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

    local function appendLimited(bucket, value, maximum)
        table.insert(bucket, value)
        while #bucket > maximum do table.remove(bucket, 1) end
    end

    local function addTimeline(kind, detail)
        appendLimited(timeline, {
            Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind, Detail = oneLine(detail),
        }, 500)
    end

    local function currentSeatSummary()
        local player = Players.LocalPlayer
        local character = player and player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return "Humanoid indisponível" end
        return "Sit=" .. tostring(humanoid.Sit) .. " | estado=" .. tostring(humanoid:GetState())
            .. " | SeatPart=" .. formatValue(humanoid.SeatPart)
    end

    local function updateLiveStatus(lastEvent)
        update("chairs_status", "Coleta das cadeiras ativa — " .. currentSeatSummary(),
            string.format("%.1fs | fotos=%d | recebidos=%d | enviados=%d | último=%s",
                elapsed(), #snapshots, #inbound, #outbound, lastEvent or "início"))
    end

    local function recordSnapshot(label)
        if not active then
            update("chairs_status", "Coleta não iniciada", "Clique em Iniciar antes de registrar uma fotografia.")
            return
        end
        local entry = {
            Label = label,
            Time = utcTimestamp(),
            Elapsed = elapsed(),
            Character = currentCharacterState(),
            Structure = scanChairStructure(settings.ChairScanRadius, settings.ChairCandidateLimit),
        }
        table.insert(snapshots, entry)
        addTimeline("FOTOGRAFIA", label .. " | " .. currentSeatSummary())
        updateLiveStatus(label)
        update("chairs_report", "Fotografia registrada — " .. label,
            preview(entry.Character .. "\n\n" .. entry.Structure, 4200))
    end

    local function recordStructureEvent(kind, instance)
        if not active or not instance then return end
        local map = currentMap()
        local path = fullName(instance)
        local belongsToMap = map and (instance == map or instance:IsDescendantOf(map))
        local characterEvent = string.find(kind, "Character", 1, true) ~= nil
        local interesting = belongsToMap and (containsRelevant(instance.Name)
            or instance:IsA("Seat") or instance:IsA("VehicleSeat")
            or instance:IsA("JointInstance") or instance:IsA("WeldConstraint")
            or instance:IsA("ProximityPrompt") or instance:IsA("TouchTransmitter"))
            or (characterEvent and (containsRelevant(instance.Name)
                or instance:IsA("JointInstance") or instance:IsA("WeldConstraint")))
        if not interesting and not (instance.Name == "SeatWeld") then return end
        appendLimited(structureEvents, {
            Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind,
            Detail = describeInstance(instance, nil),
        }, 350)
        addTimeline("Estrutura." .. kind, path .. ":" .. instance.ClassName)
        updateLiveStatus(path)
    end

    local function monitorSeat(seat)
        if monitoredSeats[seat] then return end
        if not (seat:IsA("Seat") or seat:IsA("VehicleSeat")) then return end
        monitoredSeats[seat] = true
        table.insert(connections, seat:GetPropertyChangedSignal("Occupant"):Connect(function()
            if active then
                addTimeline("Seat.Occupant", fullName(seat) .. "=" .. formatValue(seat.Occupant))
                updateLiveStatus(fullName(seat))
            end
        end))
        table.insert(connections, seat.ChildAdded:Connect(function(child)
            if active then recordStructureEvent("Adicionado ao Seat", child) end
        end))
        table.insert(connections, seat.ChildRemoved:Connect(function(child)
            if active then
                addTimeline("Removido do Seat", fullName(seat) .. "." .. child.Name .. ":" .. child.ClassName)
            end
        end))
    end

    local function bindCharacter(character)
        if not character then return end
        table.insert(connections, character.AttributeChanged:Connect(function(name)
            if active then addTimeline("Character.Attribute", name .. "=" .. formatValue(character:GetAttribute(name))) end
        end))
        table.insert(connections, character.DescendantAdded:Connect(function(instance)
            if active and (instance.Name == "SeatWeld" or containsRelevant(instance.Name)
                or instance:IsA("JointInstance") or instance:IsA("WeldConstraint")) then
                recordStructureEvent("Character.Adicionado", instance)
            end
        end))
        table.insert(connections, character.DescendantRemoving:Connect(function(instance)
            if active and (instance.Name == "SeatWeld" or containsRelevant(instance.Name)) then
                addTimeline("Character.Removido", fullName(instance) .. ":" .. instance.ClassName)
            end
        end))
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        for _, property in ipairs({ "Sit", "SeatPart", "Health", "WalkSpeed", "PlatformStand", "AutoRotate" }) do
            local ok, connection = pcall(function()
                return humanoid:GetPropertyChangedSignal(property):Connect(function()
                    if active then
                        addTimeline("Humanoid." .. property, formatValue(humanoid[property]))
                        updateLiveStatus("Humanoid." .. property)
                    end
                end)
            end)
            if ok and connection then table.insert(connections, connection) end
        end
        table.insert(connections, humanoid.StateChanged:Connect(function(oldState, newState)
            if active then addTimeline("Humanoid.State", tostring(oldState) .. " -> " .. tostring(newState)) end
        end))
        local ok, seatedConnection = pcall(function()
            return humanoid.Seated:Connect(function(isSeated, seatPart)
                if active then
                    addTimeline("Humanoid.Seated", "ativo=" .. tostring(isSeated)
                        .. " | seatPart=" .. formatValue(seatPart))
                    updateLiveStatus("Humanoid.Seated")
                end
            end)
        end)
        if ok and seatedConnection then table.insert(connections, seatedConnection) end
    end

    local function bindPlayer()
        local player = Players.LocalPlayer
        if not player then return end
        table.insert(connections, player.AttributeChanged:Connect(function(name)
            if active then addTimeline("Player.Attribute", name .. "=" .. formatValue(player:GetAttribute(name))) end
        end))
        bindCharacter(player.Character)
        table.insert(connections, player.CharacterAdded:Connect(function(character)
            if active then
                addTimeline("Character", "novo personagem: " .. fullName(character))
                bindCharacter(character)
            end
        end))
    end

    local function recordPrompt(kind, prompt, extra)
        if not active or not prompt then return end
        local map = currentMap()
        if not (map and prompt:IsDescendantOf(map)) and not containsRelevant(fullName(prompt)) then return end
        appendLimited(promptEvents, {
            Time = utcTimestamp(), Elapsed = elapsed(), Kind = kind,
            Detail = describeInstance(prompt, nil) .. (extra ~= nil and (" | extra=" .. formatValue(extra)) or ""),
        }, 150)
        addTimeline("Prompt." .. kind, fullName(prompt))
        updateLiveStatus(fullName(prompt))
    end

    local function recordInbound(remote, ...)
        if not active then return end
        local packed = table.pack(...)
        local path = fullName(remote)
        local arguments = formatPacked(packed)
        if not settings.CaptureAllChairRemotes and not containsRelevant(path .. " " .. arguments) then return end
        appendLimited(inbound, {
            Time = utcTimestamp(), Elapsed = elapsed(), Path = path,
            ArgumentCount = packed.n, Arguments = arguments,
        }, 300)
        addTimeline("Remote recebido", path .. " | " .. arguments)
        updateLiveStatus(path)
    end

    local function monitorRemote(remote)
        if monitoredRemotes[remote] then return end
        if not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then return end
        monitoredRemotes[remote] = true
        local ok, connection = pcall(function()
            return remote.OnClientEvent:Connect(function(...) recordInbound(remote, ...) end)
        end)
        if ok and connection then table.insert(remoteConnections, connection) end
    end

    local function resetData()
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        active = false
        startedAt = nil
        lastReport = ""
        snapshots = {}
        timeline = {}
        inbound = {}
        outbound = {}
        promptEvents = {}
        structureEvents = {}
        monitoredRemotes = setmetatable({}, { __mode = "k" })
        monitoredSeats = setmetatable({}, { __mode = "k" })
        outboundAvailable = false
        outboundError = nil
    end

    local function startCapture()
        resetData()
        active = true
        startedAt = os.clock()
        bindPlayer()

        local map = currentMap()
        if map then
            for _, instance in ipairs(map:GetDescendants()) do monitorSeat(instance) end
        end
        table.insert(connections, Workspace.DescendantAdded:Connect(function(instance)
            if not active then return end
            monitorSeat(instance)
            recordStructureEvent("Adicionado", instance)
        end))
        table.insert(connections, Workspace.DescendantRemoving:Connect(function(instance)
            if active then recordStructureEvent("Removendo", instance) end
        end))

        local promptSignals = {
            { Event = "PromptShown", Name = "Shown" },
            { Event = "PromptHidden", Name = "Hidden" },
            { Event = "PromptTriggered", Name = "Triggered" },
            { Event = "PromptTriggerEnded", Name = "TriggerEnded" },
            { Event = "PromptButtonHoldBegan", Name = "HoldBegan" },
            { Event = "PromptButtonHoldEnded", Name = "HoldEnded" },
        }
        for _, item in ipairs(promptSignals) do
            local ok, connection = pcall(function()
                return ProximityPromptService[item.Event]:Connect(function(prompt, extra)
                    recordPrompt(item.Name, prompt, extra)
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
                if not active or typeof(remote) ~= "Instance" then return end
                if not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")
                    or remote:IsA("RemoteFunction")) then return end
                local entry = {
                    Time = utcTimestamp(), Elapsed = elapsed(), Method = method,
                    Path = fullName(remote), ArgumentCount = packed.n,
                    Arguments = formatPacked(packed), CallerIsExecutor = callerIsExecutor,
                }
                appendLimited(outbound, entry, 300)
                addTimeline("Remote enviado", method .. " " .. entry.Path .. " | " .. entry.Arguments)
                updateLiveStatus(entry.Path)
            end)

        addTimeline("INÍCIO", "captura passiva iniciada | mapa=" .. formatValue(currentMap()))
        recordSnapshot("INÍCIO — ANTES DA MÚSICA")
        update("chairs_status", "Coleta iniciada — faça as marcações durante a rodada",
            outboundAvailable and "Chamadas enviadas pelo próprio jogo também serão observadas."
                or ("FireServer/InvokeServer indisponíveis: " .. tostring(outboundError)))
    end

    local function buildReport()
        local lines = {
            sessionHeader(),
            "",
            string.format("Duração: %.2fs | raio=%d | limite=%d | todosRemotes=%s",
                elapsed(), settings.ChairScanRadius, settings.ChairCandidateLimit,
                tostring(settings.CaptureAllChairRemotes)),
            "Chamadas cliente → servidor: " .. (outboundAvailable and "observação disponível"
                or ("indisponível — " .. tostring(outboundError))),
            "Somente observação: nenhuma cadeira, interação ou remote foi acionado pelo H Inspect.",
            "",
            "FOTOGRAFIAS COMPARATIVAS (" .. tostring(#snapshots) .. ")",
        }
        if #snapshots == 0 then table.insert(lines, "  nenhuma fotografia") end
        for index, entry in ipairs(snapshots) do
            table.insert(lines, "")
            table.insert(lines, string.format("=== FOTO %02d — %s | +%.3fs | %s ===",
                index, entry.Label, entry.Elapsed, entry.Time))
            table.insert(lines, "ESTADO LOCAL")
            table.insert(lines, entry.Character)
            table.insert(lines, "")
            table.insert(lines, "ESTRUTURA DA FASE E PROXIMIDADE")
            table.insert(lines, entry.Structure)
        end

        table.insert(lines, "")
        table.insert(lines, "LINHA DO TEMPO")
        if #timeline == 0 then table.insert(lines, "  nenhum evento") end
        for index, entry in ipairs(timeline) do
            table.insert(lines, string.format("%03d. [+%.3fs] [%s] %s — %s",
                index, entry.Elapsed, entry.Time, entry.Kind, entry.Detail))
        end

        table.insert(lines, "")
        table.insert(lines, "EVENTOS DE PROMPT")
        if #promptEvents == 0 then table.insert(lines, "  nenhum") end
        for index, entry in ipairs(promptEvents) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Kind))
            table.insert(lines, "     " .. entry.Detail)
        end

        table.insert(lines, "")
        table.insert(lines, "CHAMADAS ENVIADAS PELO JOGO")
        if not outboundAvailable then
            table.insert(lines, "  executor não permitiu observar FireServer/InvokeServer")
        elseif #outbound == 0 then
            table.insert(lines, "  nenhuma chamada enviada foi observada")
        end
        for index, entry in ipairs(outbound) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s %s | callerExecutor=%s",
                index, entry.Elapsed, entry.Method, entry.Path, tostring(entry.CallerIsExecutor)))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "EVENTOS RECEBIDOS DO SERVIDOR")
        if #inbound == 0 then table.insert(lines, "  nenhum evento relevante") end
        for index, entry in ipairs(inbound) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Path))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end

        table.insert(lines, "")
        table.insert(lines, "MUDANÇAS DE ESTRUTURA")
        if #structureEvents == 0 then table.insert(lines, "  nenhuma mudança relevante") end
        for index, entry in ipairs(structureEvents) do
            table.insert(lines, string.format("%03d. [+%.3fs] %s", index, entry.Elapsed, entry.Kind))
            table.insert(lines, "     " .. entry.Detail)
        end

        table.insert(lines, "")
        table.insert(lines, "O QUE COMPARAR")
        table.insert(lines, "- Assento real: Humanoid.SeatPart não nil, Seat.Occupant igual ao Humanoid e possível SeatWeld.")
        table.insert(lines, "- Assento no ar: Sit/Seated sem SeatPart, Occupant ou SeatWeld; esse estado já não evitou a eliminação.")
        table.insert(lines, "- Remote imediatamente após sentar pode ser a confirmação adicional usada pelo servidor.")
        table.insert(lines, "- Se não houver classe Seat, compare peças próximas, TouchTransmitter, prompts e juntas criadas ao sentar.")
        return table.concat(lines, "\n")
    end

    local function finishCapture()
        if not active then
            if lastReport == "" then
                update("chairs_status", "Nenhuma coleta ativa", "Inicie antes da música para analisar a fase.")
            end
            return lastReport
        end
        recordSnapshot("FINAL — ELIMINAÇÃO OU LIMPEZA")
        active = false
        disconnect(connections)
        disconnect(remoteConnections)
        if outboundRemove then outboundRemove(); outboundRemove = nil end
        lastReport = buildReport()
        update("chairs_status", "Coleta das cadeiras concluída",
            string.format("fotos=%d | recebidos=%d | enviados=%d | estrutura=%d",
                #snapshots, #inbound, #outbound, #structureEvents))
        update("chairs_report", "Prévia da investigação", preview(lastReport, 4600))
        return lastReport
    end

    local function copyReport()
        if active then finishCapture() end
        if lastReport == "" then
            update("chairs_status", "Nada para copiar", "Inicie e conclua uma coleta primeiro.")
            return
        end
        local clipboard = type(setclipboard) == "function" and setclipboard
            or (type(toclipboard) == "function" and toclipboard or nil)
        if not clipboard then
            update("chairs_status", "Área de transferência indisponível",
                "O executor não oferece setclipboard/toclipboard; o relatório foi enviado ao console.")
            print(lastReport)
            return
        end
        local ok, err = pcall(clipboard, lastReport)
        if ok then
            update("chairs_status", "Relatório das cadeiras copiado",
                string.format("%d caracteres prontos para enviar.", #lastReport))
        else
            update("chairs_status", "Falha ao copiar", oneLine(err))
        end
    end

    local runtime = {}

    function runtime:Set(name, value)
        if name == "ChairScanRadius" then
            settings.ChairScanRadius = math.clamp(tonumber(value) or 45, 10, 120)
        elseif name == "ChairCandidateLimit" then
            settings.ChairCandidateLimit = math.clamp(tonumber(value) or 160, 50, 300)
        elseif name == "CaptureAllChairRemotes" then
            settings.CaptureAllChairRemotes = value == true
        elseif name == "StartChairsCapture" then
            startCapture()
        elseif name == "MarkChairFree" then
            recordSnapshot("CADEIRA LIVRE")
        elseif name == "MarkRealSeat" then
            recordSnapshot("SENTADO DE VERDADE")
        elseif name == "MarkAirSeat" then
            recordSnapshot("SENTADO NO AR")
        elseif name == "FinishChairsCapture" then
            finishCapture()
        elseif name == "CopyChairsCapture" then
            copyReport()
        elseif name == "ClearChairsCapture" then
            resetData()
            update("chairs_status", "Coleta apagada", "Inicie novamente antes da música.")
            update("chairs_report", "Prévia da investigação", "Nenhuma coleta registrada.")
        end
    end

    function runtime:Destroy()
        if destroyed then return end
        destroyed = true
        resetData()
    end

    return runtime
end

return MusicalChairs
