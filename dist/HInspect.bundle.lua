-- AUTO-GENERATED FILE. DO NOT EDIT DIRECTLY.
-- Run tools/Build-Bundle.ps1 after changing a source module.
-- Release is read from VERSION at runtime.

local __modules = {}

-- BEGIN HInspectConfig.lua
__modules["HInspectConfig.lua"] = function()
local Config = {}

Config.GuiName = "HInspect"
Config.DisplayName = "H Inspect"
Config.Version = "v" .. tostring(rawget(_G, "__HINSPECT_RELEASE_VERSION") or "unknown")
Config.ToggleKey = Enum.KeyCode.RightShift
Config.DefaultCategory = "Home"
Config.Window = { Width = 720, Height = 520, MinScale = 0.68, Margin = 24 }

Config.Theme = {
    Window = Color3.fromRGB(31, 48, 80),
    WindowHighlight = Color3.fromRGB(38, 58, 96),
    WindowDark = Color3.fromRGB(18, 29, 51),
    Sidebar = Color3.fromRGB(27, 42, 70),
    Header = Color3.fromRGB(29, 45, 76),
    Surface = Color3.fromRGB(32, 49, 82),
    SurfaceHover = Color3.fromRGB(41, 61, 99),
    Control = Color3.fromRGB(25, 40, 68),
    Accent = Color3.fromRGB(102, 151, 246),
    Bookmark = Color3.fromRGB(255, 218, 0),
    Text = Color3.fromRGB(238, 243, 255),
    Muted = Color3.fromRGB(169, 183, 211),
    Dim = Color3.fromRGB(112, 130, 165),
    Border = Color3.fromRGB(83, 112, 169),
    Success = Color3.fromRGB(96, 218, 151),
    Danger = Color3.fromRGB(255, 112, 124),
}

Config.Themes = {
    Default = {
        Colors = Config.Theme,
    },
    Purple = {
        Wallpaper = "theme/wallpapers/Purple.png",
        WallpaperTransparency = 0.42,
        ShadeTransparency = 0.5,
        Colors = {
            Window = Color3.fromRGB(37, 24, 61),
            WindowHighlight = Color3.fromRGB(69, 43, 108),
            WindowDark = Color3.fromRGB(18, 11, 33),
            Sidebar = Color3.fromRGB(29, 19, 49),
            Header = Color3.fromRGB(34, 21, 56),
            Surface = Color3.fromRGB(45, 29, 73),
            SurfaceHover = Color3.fromRGB(61, 40, 96),
            Control = Color3.fromRGB(32, 21, 54),
            Accent = Color3.fromRGB(177, 105, 255),
            Bookmark = Color3.fromRGB(255, 220, 78),
            Text = Color3.fromRGB(247, 242, 255),
            Muted = Color3.fromRGB(198, 181, 224),
            Dim = Color3.fromRGB(143, 120, 176),
            Border = Color3.fromRGB(111, 77, 151),
            Success = Color3.fromRGB(105, 224, 158),
            Danger = Color3.fromRGB(255, 119, 144),
        },
    },
    Orange = {
        Wallpaper = "theme/wallpapers/Orange.png",
        WallpaperTransparency = 0.42,
        ShadeTransparency = 0.5,
        Colors = {
            Window = Color3.fromRGB(58, 31, 18),
            WindowHighlight = Color3.fromRGB(108, 55, 24),
            WindowDark = Color3.fromRGB(31, 15, 8),
            Sidebar = Color3.fromRGB(48, 25, 14),
            Header = Color3.fromRGB(55, 28, 16),
            Surface = Color3.fromRGB(68, 35, 20),
            SurfaceHover = Color3.fromRGB(91, 48, 26),
            Control = Color3.fromRGB(49, 25, 14),
            Accent = Color3.fromRGB(255, 145, 58),
            Bookmark = Color3.fromRGB(255, 220, 78),
            Text = Color3.fromRGB(255, 246, 237),
            Muted = Color3.fromRGB(222, 190, 163),
            Dim = Color3.fromRGB(171, 128, 94),
            Border = Color3.fromRGB(158, 88, 44),
            Success = Color3.fromRGB(112, 222, 151),
            Danger = Color3.fromRGB(255, 116, 104),
        },
    },
}

-- Lucide line icons published as Roblox image assets.
Config.Icons = {
    home = "rbxassetid://7733960981",
    settings = "rbxassetid://7734053495",
    info = "rbxassetid://7733964719",
    overview = "rbxassetid://7733970318",
    sliders = "rbxassetid://7734058803",
    palette = "rbxassetid://7734021595",
    users = "rbxassetid://7743876054",
    map = "rbxassetid://7733992424",
    bookmark = "rbxassetid://7733692043",
    search = "rbxassetid://7734052925",
    laptop = "rbxassetid://7733965386",
    target = "rbxassetid://7743872758",
}

Config.CategoryModules = {
    "categories/Home.lua",
    "categories/Players.lua",
    "categories/Items.lua",
    "categories/AttackCapture.lua",
    "categories/Baby.lua",
    "categories/MusicalChairs.lua",
    "categories/Interface.lua",
    "categories/World.lua",
    "categories/Explorer.lua",
    "categories/Remotes.lua",
    "categories/Compare.lua",
    "categories/Reports.lua",
    "categories/Settings.lua",
}

return Config
end
-- END HInspectConfig.lua

-- BEGIN HInspectSchema.lua
__modules["HInspectSchema.lua"] = function()
local Schema = {}

local VALID_CONTROL_KINDS = {
    Toggle = true,
    Slider = true,
    Dropdown = true,
    Input = true,
    Button = true,
    Paragraph = true,
}

local REQUIRED_THEME_KEYS = {
    "Window", "WindowHighlight", "WindowDark", "Sidebar", "Header",
    "Surface", "SurfaceHover", "Control", "Accent", "Bookmark",
    "Text", "Muted", "Dim", "Border", "Success", "Danger",
}

local function requireNonEmptyString(value, context)
    if type(value) ~= "string" or value:match("^%s*$") then
        error(context .. " deve ser uma string não vazia", 0)
    end
end

function Schema.ValidateConfig(config)
    if type(config) ~= "table" then error("HInspectConfig.lua deve retornar uma tabela", 0) end
    requireNonEmptyString(config.GuiName, "Config.GuiName")
    requireNonEmptyString(config.DisplayName, "Config.DisplayName")
    requireNonEmptyString(config.Version, "Config.Version")
    requireNonEmptyString(config.DefaultCategory, "Config.DefaultCategory")
    if config.ToggleKey == nil then error("Config.ToggleKey não pode ser nil", 0) end
    if type(config.Theme) ~= "table" then error("Config.Theme deve ser uma tabela", 0) end
    for _, key in ipairs(REQUIRED_THEME_KEYS) do
        if config.Theme[key] == nil then
            error("Config.Theme não possui a cor obrigatória " .. key, 0)
        end
    end
    if type(config.Icons) ~= "table" then error("Config.Icons deve ser uma tabela", 0) end
    if type(config.Window) ~= "table" or type(config.Window.Width) ~= "number"
        or type(config.Window.Height) ~= "number" then
        error("Config.Window deve informar Width e Height numéricos", 0)
    end
    if config.Window.Width <= 0 or config.Window.Height <= 0
        or type(config.Window.MinScale) ~= "number" or config.Window.MinScale <= 0
        or type(config.Window.Margin) ~= "number" or config.Window.Margin < 0 then
        error("Config.Window possui dimensões, MinScale ou Margin inválidos", 0)
    end
    if type(config.CategoryModules) ~= "table" or #config.CategoryModules == 0 then
        error("Config.CategoryModules não pode estar vazio", 0)
    end
end

function Schema.ValidateCategory(category, path, categoryIds, controlIds)
    if type(category) ~= "table" then
        error(path .. " deve retornar uma tabela", 0)
    end
    requireNonEmptyString(category.Id, path .. ".Id")
    requireNonEmptyString(category.Label, path .. ".Label")
    requireNonEmptyString(category.Icon, path .. ".Icon")
    if categoryIds[category.Id] then
        error("Id de categoria duplicado '" .. category.Id .. "' em " .. path, 0)
    end
    categoryIds[category.Id] = path

    if category.RuntimeModule ~= nil then
        requireNonEmptyString(category.RuntimeModule, path .. ".RuntimeModule")
    end
    if type(category.Sections) ~= "table" or #category.Sections == 0 then
        error(path .. ".Sections deve conter ao menos uma seção", 0)
    end

    for sectionIndex, section in ipairs(category.Sections) do
        local sectionContext = path .. ".Sections[" .. tostring(sectionIndex) .. "]"
        if type(section) ~= "table" then error(sectionContext .. " deve ser uma tabela", 0) end
        requireNonEmptyString(section.Title, sectionContext .. ".Title")
        if section.Icon ~= nil then requireNonEmptyString(section.Icon, sectionContext .. ".Icon") end
        if type(section.Controls) ~= "table" then
            error(sectionContext .. ".Controls deve ser uma tabela", 0)
        end

        for controlIndex, control in ipairs(section.Controls) do
            local context = sectionContext .. ".Controls[" .. tostring(controlIndex) .. "]"
            if type(control) ~= "table" then error(context .. " deve ser uma tabela", 0) end
            if not VALID_CONTROL_KINDS[control.Kind] then
                error(context .. " possui Kind inválido: " .. tostring(control.Kind), 0)
            end
            requireNonEmptyString(control.Label, context .. ".Label")
            if control.Description ~= nil and type(control.Description) ~= "string" then
                error(context .. ".Description deve ser uma string", 0)
            end
            if control.Callback ~= nil and type(control.Callback) ~= "function" then
                error(context .. ".Callback deve ser uma função", 0)
            end

            if control.Kind ~= "Paragraph" or control.Id ~= nil then
                requireNonEmptyString(control.Id, context .. ".Id")
                if controlIds[control.Id] then
                    error("Id de controle duplicado '" .. control.Id .. "' em " .. context, 0)
                end
                controlIds[control.Id] = context
            end
            if control.Kind == "Paragraph" and control.Height ~= nil
                and (type(control.Height) ~= "number" or control.Height < 56 or control.Height > 480) then
                error(context .. ".Height deve estar entre 56 e 480", 0)
            end
            if control.Setting ~= nil then
                requireNonEmptyString(control.Setting, context .. ".Setting")
                if not category.RuntimeModule then
                    error(context .. " possui Setting, mas a categoria não possui RuntimeModule", 0)
                end
            end
            if control.OptionsSource ~= nil then
                requireNonEmptyString(control.OptionsSource, context .. ".OptionsSource")
                if not category.RuntimeModule then
                    error(context .. " possui OptionsSource, mas a categoria não possui RuntimeModule", 0)
                end
            end

            if control.Kind == "Slider" then
                if type(control.Min) ~= "number" or type(control.Max) ~= "number" or control.Max <= control.Min then
                    error(context .. " precisa de Min e Max numéricos, com Max maior que Min", 0)
                end
                if control.Step ~= nil and (type(control.Step) ~= "number" or control.Step <= 0) then
                    error(context .. ".Step deve ser um número positivo", 0)
                end
                if control.Default ~= nil and (type(control.Default) ~= "number"
                    or control.Default < control.Min or control.Default > control.Max) then
                    error(context .. ".Default deve estar entre Min e Max", 0)
                end
            elseif control.Kind == "Dropdown" then
                local optionsType = type(control.Options)
                if optionsType ~= "table" and optionsType ~= "function"
                    and type(control.OptionsSource) ~= "string" then
                    error(context .. " precisa de Options ou OptionsSource", 0)
                end
                if optionsType == "table" and #control.Options == 0 then
                    error(context .. ".Options não pode estar vazio", 0)
                end
                if optionsType == "table" and control.Default ~= nil then
                    local defaultExists = false
                    for _, option in ipairs(control.Options) do
                        if option == control.Default then defaultExists = true break end
                    end
                    if not defaultExists then
                        error(context .. ".Default não existe em Options", 0)
                    end
                end
            elseif control.Kind == "Toggle" and control.Default ~= nil
                and type(control.Default) ~= "boolean" then
                error(context .. ".Default deve ser booleano", 0)
            elseif control.Kind == "Input" then
                if control.Default ~= nil and type(control.Default) ~= "string" then
                    error(context .. ".Default deve ser uma string", 0)
                end
                if control.Placeholder ~= nil and type(control.Placeholder) ~= "string" then
                    error(context .. ".Placeholder deve ser uma string", 0)
                end
            elseif control.Kind == "Button" and control.ButtonText ~= nil
                and type(control.ButtonText) ~= "string" then
                error(context .. ".ButtonText deve ser uma string", 0)
            end
        end
    end
end

function Schema.RequireModulePath(path, context)
    requireNonEmptyString(path, context or "caminho do módulo")
end

return Schema
end
-- END HInspectSchema.lua

-- BEGIN HInspect.lua
__modules["HInspect.lua"] = function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local HInspect = {}

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do object[key] = value end
    object.Parent = parent
    return object
end

local function round(parent, radius)
    return make("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(parent, color, transparency)
    return make("UIStroke", { Color = color, Thickness = 1, Transparency = transparency or 0 }, parent)
end

local function pad(parent, left, right, top, bottom)
    return make("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0), PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or 0), PaddingBottom = UDim.new(0, bottom or top or 0),
    }, parent)
end

local function text(parent, value, properties)
    properties = properties or {}
    properties.BackgroundTransparency = properties.BackgroundTransparency == nil and 1 or properties.BackgroundTransparency
    properties.Text = value
    properties.BorderSizePixel = 0
    local object = make("TextLabel", properties, parent)
    return object
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

function HInspect:Create(options)
    assert(options and type(options.Import) == "function", "H Inspect requires an Import function")
    local Schema = options.Import("HInspectSchema.lua")
    local Config = options.Import("HInspectConfig.lua")
    Schema.ValidateConfig(Config)
    local Theme = {}
    for key, value in pairs(Config.Theme) do Theme[key] = value end
    local Parent = options.Parent or Players.LocalPlayer:WaitForChild("PlayerGui")
    local function icon(parent, iconName, properties)
        properties = properties or {}
        properties.BackgroundTransparency = 1
        properties.BorderSizePixel = 0
        properties.Image = Config.Icons[iconName] or iconName or ""
        properties.ImageColor3 = properties.ImageColor3 or Theme.Muted
        return make("ImageLabel", properties, parent)
    end
    local categories = {}
    local categoryIds = {}
    local controlIds = {}
    local runtimeModules = {}
    for _, path in ipairs(Config.CategoryModules) do
        Schema.RequireModulePath(path, "Config.CategoryModules[]")
        local ok, category = pcall(options.Import, path)
        if not ok then
            error("Falha ao importar categoria " .. tostring(path) .. ": " .. tostring(category), 0)
        end
        Schema.ValidateCategory(category, path, categoryIds, controlIds)
        table.insert(categories, category)
    end
    if not categoryIds[Config.DefaultCategory] then
        error("Config.DefaultCategory aponta para uma categoria inexistente: "
            .. tostring(Config.DefaultCategory), 0)
    end

    for _, category in ipairs(categories) do
        local path = category.RuntimeModule
        if path and not runtimeModules[path] then
            local ok, runtimeModule = pcall(options.Import, path)
            if not ok then
                error("Falha ao importar runtime " .. path .. ": " .. tostring(runtimeModule), 0)
            end
            if type(runtimeModule) ~= "table" or type(runtimeModule.Create) ~= "function" then
                error(path .. " deve retornar uma tabela com função Create", 0)
            end
            runtimeModules[path] = runtimeModule
        end
    end

    if type(_G.__HINSPECT_CLEANUP) == "function" then pcall(_G.__HINSPECT_CLEANUP) end
    local connections = {}
    local pageConnections = {}
    local popupConnections = {}
    local runtimes = {}
    local activeDropdownPopup
    local wallpaperRequest = 0
    local themeSetter
    local cameraViewportConnection
    local destroyed = false
    local cleanupFunction
    local controlViews = {}
    local pendingControlText = {}
    local uiBridge = {}

    function uiBridge:SetControlText(id, labelValue, descriptionValue)
        if type(id) ~= "string" or id == "" then return end
        local pending = pendingControlText[id] or {}
        if labelValue ~= nil then pending.Label = tostring(labelValue) end
        if descriptionValue ~= nil then pending.Description = tostring(descriptionValue) end
        pendingControlText[id] = pending

        local view = controlViews[id]
        if not view then return end
        if pending.Label ~= nil and view.Label then view.Label.Text = pending.Label end
        if pending.Description ~= nil and view.Description then
            view.Description.Text = pending.Description
        end
    end

    local function connectTracked(bucket, signal, callback)
        local connection = signal:Connect(callback)
        table.insert(bucket, connection)
        return connection
    end

    local function connect(signal, callback)
        return connectTracked(connections, signal, callback)
    end

    local function connectPage(signal, callback)
        return connectTracked(pageConnections, signal, callback)
    end

    local function connectPopup(signal, callback)
        return connectTracked(popupConnections, signal, callback)
    end

    local function disconnectAll(bucket)
        for index = #bucket, 1, -1 do
            pcall(function() bucket[index]:Disconnect() end)
            table.remove(bucket, index)
        end
    end

    local previous = Parent:FindFirstChild(Config.GuiName)
    if previous then previous:Destroy() end
    local gui = make("ScreenGui", {
        Name = Config.GuiName, ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 998,
    }, Parent)
    if type(protect_gui) == "function" then pcall(protect_gui, gui) end

    cleanupFunction = function()
        if destroyed then return end
        destroyed = true
        wallpaperRequest = wallpaperRequest + 1
        disconnectAll(popupConnections)
        disconnectAll(pageConnections)
        disconnectAll(connections)
        if cameraViewportConnection then
            pcall(function() cameraViewportConnection:Disconnect() end)
            cameraViewportConnection = nil
        end
        if activeDropdownPopup then
            activeDropdownPopup:Destroy()
            activeDropdownPopup = nil
        end
        for index = #runtimes, 1, -1 do
            local runtime = runtimes[index]
            if type(runtime.Destroy) == "function" then
                pcall(function() runtime:Destroy() end)
            end
            table.remove(runtimes, index)
        end
        if gui and gui.Parent then gui:Destroy() end
        if _G.__HINSPECT_SET_THEME == themeSetter then _G.__HINSPECT_SET_THEME = nil end
        if _G.__HINSPECT_CLEANUP == cleanupFunction then _G.__HINSPECT_CLEANUP = nil end
    end
    _G.__HINSPECT_CLEANUP = cleanupFunction

    local runtimeInstances = {}
    for _, category in ipairs(categories) do
        if category.RuntimeModule then
            local runtimeModule = runtimeModules[category.RuntimeModule]
            local runtime = runtimeInstances[category.RuntimeModule]
            if not runtime then
                local runtimeOk
                runtimeOk, runtime = pcall(function()
                    return runtimeModule:Create({ Parent = Parent, UI = uiBridge })
                end)
                if not runtimeOk or type(runtime) ~= "table" or type(runtime.Set) ~= "function"
                    or type(runtime.Destroy) ~= "function" then
                    cleanupFunction()
                    error("Falha ao iniciar runtime " .. category.RuntimeModule .. ": "
                        .. tostring(runtime), 0)
                end
                runtimeInstances[category.RuntimeModule] = runtime
                table.insert(runtimes, runtime)
            end
            for _, section in ipairs(category.Sections) do
                for _, control in ipairs(section.Controls) do
                    if control.OptionsSource then
                        if type(runtime.GetOptions) ~= "function" then
                            cleanupFunction()
                            error(category.RuntimeModule .. " precisa implementar GetOptions para "
                                .. control.Id, 0)
                        end
                        local optionsSource = control.OptionsSource
                        control.Options = function()
                            return runtime:GetOptions(optionsSource)
                        end
                    end
                    if control.Setting then
                        local settingName = control.Setting
                        local settingRuntime = runtime
                        local previousCallback = control.Callback
                        control.Callback = function(value, state)
                            settingRuntime:Set(settingName, value)
                            if type(previousCallback) == "function" then
                                previousCallback(value, state)
                            end
                        end
                    end
                end
            end
        end
    end

    local root = make("Frame", {
        Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Config.Window.Width, Config.Window.Height),
        BackgroundColor3 = Theme.Window, BackgroundTransparency = 0.13,
        BorderSizePixel = 0, ClipsDescendants = true,
    }, gui)
    round(root, 12)
    stroke(root, Theme.Border, 0.3)
    local rootGradient = make("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.WindowHighlight),
            ColorSequenceKeypoint.new(1, Theme.WindowDark),
        }), Rotation = 135,
    }, root)
    local wallpaper = make("ImageLabel", {
        Name = "ThemeWallpaper",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "",
        ImageColor3 = Color3.fromRGB(225, 225, 235),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Crop,
        Visible = false,
    }, root)
    local wallpaperShade = make("Frame", {
        Name = "ThemeWallpaperShade",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.WindowDark,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
    }, root)
    local scale = make("UIScale", { Scale = 1 }, root)
    local accentLine = make("Frame", {
        Name = "AccentLine", Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, ZIndex = 8,
    }, root)
    make("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.22, 0.15),
            NumberSequenceKeypoint.new(0.78, 0.15), NumberSequenceKeypoint.new(1, 1),
        }),
    }, accentLine)

    local header = make("Frame", {
        Name = "Header", Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Header,
        BackgroundTransparency = 0.22, BorderSizePixel = 0, Active = true, ZIndex = 2,
    }, root)
    text(header, (Config.DisplayName or "H Inspect") .. " " .. Config.Version, {
        Size = UDim2.fromOffset(230, 54), Position = UDim2.fromOffset(20, 0),
        TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    icon(header, "laptop", {
        Size = UDim2.fromOffset(14, 14), Position = UDim2.new(1, -193, 0.5, -7),
        ImageColor3 = Theme.Dim,
    })
    text(header, "Desktop PC", {
        Size = UDim2.fromOffset(95, 54), Position = UDim2.new(1, -175, 0, 0),
        TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local minimize = make("TextButton", {
        Name = "Minimize", Size = UDim2.fromOffset(36, 54), Position = UDim2.new(1, -80, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "-", TextColor3 = Theme.Muted,
        Font = Enum.Font.Gotham, TextSize = 15, AutoButtonColor = false,
    }, header)
    local close = make("TextButton", {
        Name = "Close", Size = UDim2.fromOffset(38, 54), Position = UDim2.new(1, -42, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "X", TextColor3 = Theme.Muted,
        Font = Enum.Font.Gotham, TextSize = 14, AutoButtonColor = false,
    }, header)
    make("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border, BackgroundTransparency = 0.7, BorderSizePixel = 0,
    }, header)

    local sidebar = make("Frame", {
        Name = "Sidebar", Size = UDim2.new(0, 178, 1, -54), Position = UDim2.fromOffset(0, 54),
        BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 0.24, BorderSizePixel = 0, ZIndex = 2,
    }, root)
    make("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Border, BackgroundTransparency = 0.73, BorderSizePixel = 0,
    }, sidebar)

    local search = make("TextBox", {
        Name = "Search", Size = UDim2.new(1, -26, 0, 34), Position = UDim2.fromOffset(13, 12),
        BackgroundColor3 = Theme.Control, BackgroundTransparency = 0.25, BorderSizePixel = 0,
        Text = "", PlaceholderText = "Pesquisar...", ClearTextOnFocus = false,
        PlaceholderColor3 = Theme.Dim, TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
    }, sidebar)
    round(search, 7)
    stroke(search, Theme.Border, 0.48)
    pad(search, 32, 11)
    icon(sidebar, "search", {
        Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(23, 22),
        ImageColor3 = Theme.Dim, ZIndex = 3,
    })

    local nav = make("ScrollingFrame", {
        Name = "Navigation", Size = UDim2.new(1, -14, 1, -89), Position = UDim2.fromOffset(7, 58),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Border, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, sidebar)
    local navLayout = make("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, nav)
    pad(nav, 0, 3, 0, 8)
    text(sidebar, "RIGHTSHIFT  |  MOSTRAR / OCULTAR", {
        Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 12, 1, -27),
        TextColor3 = Theme.Dim, Font = Enum.Font.GothamMedium, TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local content = make("Frame", {
        Name = "Content", Size = UDim2.new(1, -178, 1, -54), Position = UDim2.fromOffset(178, 54),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
    }, root)
    local titleIcon = icon(content, "home", {
        Size = UDim2.fromOffset(21, 21), Position = UDim2.fromOffset(25, 26),
        ImageColor3 = Theme.Accent,
    })
    local title = text(content, "", {
        Size = UDim2.new(1, -70, 0, 42), Position = UDim2.fromOffset(55, 16),
        TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local titleAccent = make("Frame", {
        Size = UDim2.fromOffset(34, 2), Position = UDim2.fromOffset(56, 57),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
    }, content)
    round(titleAccent, 1)
    local page = make("ScrollingFrame", {
        Name = "Page", Size = UDim2.new(1, -39, 1, -76), Position = UDim2.fromOffset(24, 66),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Border, ScrollingDirection = Enum.ScrollingDirection.Y,
    }, content)
    local pageLayout = make("UIListLayout", {
        Padding = UDim.new(0, 13), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, page)
    pad(page, 0, 8, 0, 14)

    local state = {}
    local activeButton, activeCategory
    local navButtons = {}

    local function closeDropdown()
        disconnectAll(popupConnections)
        if activeDropdownPopup then
            activeDropdownPopup:Destroy()
            activeDropdownPopup = nil
        end
    end

    local function fire(control, value)
        state[control.Id or control.Label] = value
        if type(control.Callback) == "function" then
            local ok, err = pcall(control.Callback, value, state)
            if not ok then warn("[H Inspect] Erro no controle:", err) end
        end
    end

    local function createToggle(parent, control, row)
        local saved = state[control.Id or control.Label]
        local enabled = saved == nil and control.Default == true or saved == true
        local track = make("Frame", {
            Size = UDim2.fromOffset(36, 19), Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = enabled and Theme.Accent or Theme.Control, BorderSizePixel = 0,
        }, row)
        round(track, 10)
        stroke(track, enabled and Theme.Accent or Theme.Border, 0.28)
        local knob = make("Frame", {
            Size = UDim2.fromOffset(13, 13), Position = enabled and UDim2.fromOffset(20, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = Theme.Text, BorderSizePixel = 0,
        }, track)
        round(knob, 7)
        local hit = make("TextButton", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        }, row)
        state[control.Id or control.Label] = enabled
        connectPage(hit.MouseButton1Click, function()
            enabled = not enabled
            TweenService:Create(track, TweenInfo.new(0.14), { BackgroundColor3 = enabled and Theme.Accent or Theme.Control }):Play()
            TweenService:Create(knob, TweenInfo.new(0.14), { Position = enabled and UDim2.fromOffset(20, 3) or UDim2.fromOffset(3, 3) }):Play()
            fire(control, enabled)
        end)
    end

    local function createSlider(parent, control, row)
        local minimum, maximum = control.Min or 0, control.Max or 100
        local saved = state[control.Id or control.Label]
        local value = math.clamp(saved == nil and (control.Default or minimum) or saved, minimum, maximum)
        local valueText = text(row, tostring(value), {
            Size = UDim2.fromOffset(42, 18), Position = UDim2.new(1, -166, 0.5, -9),
            TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
        })
        local bar = make("Frame", {
            Size = UDim2.fromOffset(104, 4), Position = UDim2.new(1, -116, 0.5, -2),
            BackgroundColor3 = Theme.Control, BorderSizePixel = 0,
        }, row)
        round(bar, 3)
        local fill = make("Frame", {
            Size = UDim2.fromScale((value - minimum) / (maximum - minimum), 1),
            BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        }, bar)
        round(fill, 3)
        local knob = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(15, 15), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        }, fill)
        round(knob, 8)
        local dragging = false
        local function update(x)
            local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor((minimum + (maximum - minimum) * alpha) / (control.Step or 1) + 0.5) * (control.Step or 1)
            value = math.clamp(value, minimum, maximum)
            fill.Size = UDim2.fromScale((value - minimum) / (maximum - minimum), 1)
            valueText.Text = tostring(value)
            fire(control, value)
        end
        local hit = make("TextButton", {
            Size = UDim2.new(1, 12, 0, 22), Position = UDim2.fromOffset(-6, -9),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        }, bar)
        connectPage(hit.InputBegan, function(inputObject)
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(inputObject.Position.X)
            end
        end)
        connectPage(UserInputService.InputChanged, function(inputObject)
            if dragging and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then
                update(inputObject.Position.X)
            end
        end)
        connectPage(UserInputService.InputEnded, function(inputObject)
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        state[control.Id or control.Label] = value
    end

    local function createChoice(control, row)
        local function readChoices()
            local choices = control.Options
            if type(choices) == "function" then
                local ok, result = pcall(choices)
                choices = ok and result or nil
            end
            if type(choices) ~= "table" or #choices == 0 then
                return { "None" }
            end
            return choices
        end
        local choices = readChoices()
        local saved = state[control.Id or control.Label]
        local index = table.find(choices, saved == nil and control.Default or saved) or 1
        local button = make("TextButton", {
            Size = UDim2.fromOffset(152, 27), Position = UDim2.new(1, -165, 0.5, -14),
            BackgroundColor3 = Theme.Control, BorderSizePixel = 0, Text = tostring(choices[index]) .. "  v",
            TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 10, AutoButtonColor = false,
        }, row)
        round(button, 5)
        stroke(button, Theme.Border, 0.55)
        state[control.Id or control.Label] = choices[index]
        connectPage(button.MouseButton1Click, function()
            local current = choices[index]
            choices = readChoices()
            if not control.UseList then
                index = table.find(choices, current) or 0
                index = index % #choices + 1
                button.Text = tostring(choices[index]) .. "  v"
                fire(control, choices[index])
                return
            end
            index = table.find(choices, current) or 1

            if activeDropdownPopup then
                closeDropdown()
                button.Text = tostring(choices[index]) .. "  v"
                return
            end

            button.Text = tostring(choices[index]) .. "  ^"
            local optionCount = math.max(#choices, 1)
            local popup = make("Frame", {
                Name = "DropdownPopup",
                Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y + button.AbsoluteSize.Y + 4),
                Size = UDim2.fromOffset(button.AbsoluteSize.X, math.min(optionCount * 29 + 8, 182)),
                BackgroundColor3 = Theme.WindowDark,
                BackgroundTransparency = 0.03,
                BorderSizePixel = 0,
                ZIndex = 80,
            }, gui)
            activeDropdownPopup = popup
            round(popup, 7)
            stroke(popup, Theme.Border, 0.2)

            local list = make("ScrollingFrame", {
                Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4),
                BackgroundTransparency = 1, BorderSizePixel = 0,
                CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Border,
                ZIndex = 81,
            }, popup)
            make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, list)

            for optionIndex, option in ipairs(choices) do
                local optionButton = make("TextButton", {
                    Size = UDim2.new(1, -3, 0, 27), BackgroundColor3 = Theme.Surface,
                    BackgroundTransparency = option == current and 0.25 or 1,
                    BorderSizePixel = 0, Text = tostring(option), TextColor3 = option == current and Theme.Text or Theme.Muted,
                    Font = Enum.Font.Gotham, TextSize = 10, AutoButtonColor = false,
                    ZIndex = 82, LayoutOrder = optionIndex,
                }, list)
                round(optionButton, 5)
                connectPopup(optionButton.MouseButton1Click, function()
                    index = optionIndex
                    button.Text = tostring(option) .. "  v"
                    fire(control, option)
                    closeDropdown()
                end)
                connectPopup(optionButton.MouseEnter, function()
                    optionButton.BackgroundTransparency = 0.35
                    optionButton.TextColor3 = Theme.Text
                end)
                connectPopup(optionButton.MouseLeave, function()
                    optionButton.BackgroundTransparency = optionIndex == index and 0.25 or 1
                    optionButton.TextColor3 = optionIndex == index and Theme.Text or Theme.Muted
                end)
            end
        end)
    end

    local function createAction(control, row)
        local button = make("TextButton", {
            Size = UDim2.fromOffset(102, 27), Position = UDim2.new(1, -115, 0.5, -14),
            BackgroundColor3 = Theme.Control, BorderSizePixel = 0, Text = control.ButtonText or "Executar",
            TextColor3 = Theme.Accent, Font = Enum.Font.GothamMedium, TextSize = 10, AutoButtonColor = false,
        }, row)
        round(button, 5)
        stroke(button, Theme.Border, 0.45)
        connectPage(button.MouseButton1Click, function()
            fire(control, true)
            button.Text = "Concluído"
            task.delay(1, function() if button.Parent then button.Text = control.ButtonText or "Executar" end end)
        end)
    end

    local function createInput(control, row)
        local saved = state[control.Id or control.Label]
        local value = tostring(saved == nil and (control.Default or "") or saved)
        local input = make("TextBox", {
            Size = UDim2.fromOffset(220, 27), Position = UDim2.new(1, -233, 0.5, -14),
            BackgroundColor3 = Theme.Control, BorderSizePixel = 0, Text = value,
            PlaceholderText = control.Placeholder or "Digite um filtro...",
            PlaceholderColor3 = Theme.Dim, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 10, ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
        round(input, 5)
        stroke(input, Theme.Border, 0.45)
        pad(input, 9, 9)
        state[control.Id or control.Label] = value
        connectPage(input.FocusLost, function()
            fire(control, input.Text)
        end)
    end

    local function createControl(sectionFrame, control)
        local height = control.Kind == "Paragraph" and (control.Height or 56) or 42
        local row = make("Frame", {
            Name = control.Id or control.Label, Size = UDim2.new(1, 0, 0, height),
            BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.17,
            BorderSizePixel = 0, Active = true,
        }, sectionFrame)
        round(row, 5)
        stroke(row, Theme.Border, 0.6)
        local labelWidth = control.Kind == "Paragraph" and -26
            or (control.Kind == "Input" and -255 or -185)
        local labelObject = text(row, control.Label, {
            Name = "Label",
            Size = UDim2.new(1, labelWidth, 0, control.Description and 18 or height), Position = UDim2.fromOffset(12, control.Description and 6 or 0),
            TextColor3 = Theme.Text, Font = control.Kind == "Paragraph" and Enum.Font.GothamMedium or Enum.Font.Gotham,
            TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = control.Kind == "Paragraph", TextYAlignment = Enum.TextYAlignment.Top,
        })
        local descriptionObject
        if control.Description then
            descriptionObject = text(row, control.Description, {
                Name = "Description",
                Size = UDim2.new(1, -26, 0, control.Kind == "Paragraph" and (height - 33) or 18), Position = UDim2.fromOffset(12, 27),
                TextColor3 = Theme.Dim, Font = Enum.Font.Gotham, TextSize = 9,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = control.Kind == "Paragraph", TextYAlignment = Enum.TextYAlignment.Top,
            })
        end
        if control.Id then
            controlViews[control.Id] = { Label = labelObject, Description = descriptionObject }
            local pending = pendingControlText[control.Id]
            if pending then
                if pending.Label ~= nil then labelObject.Text = pending.Label end
                if pending.Description ~= nil and descriptionObject then
                    descriptionObject.Text = pending.Description
                end
            end
        end
        if control.Kind == "Toggle" then createToggle(sectionFrame, control, row)
        elseif control.Kind == "Slider" then createSlider(sectionFrame, control, row)
        elseif control.Kind == "Dropdown" then createChoice(control, row)
        elseif control.Kind == "Input" then createInput(control, row)
        elseif control.Kind == "Button" then createAction(control, row)
        end
        connectPage(row.MouseEnter, function()
            TweenService:Create(row, TweenInfo.new(0.12), { BackgroundTransparency = 0.08 }):Play()
        end)
        connectPage(row.MouseLeave, function()
            TweenService:Create(row, TweenInfo.new(0.12), { BackgroundTransparency = 0.17 }):Play()
        end)
        return row
    end

    local function clearPage()
        closeDropdown()
        disconnectAll(pageConnections)
        controlViews = {}
        for _, child in ipairs(page:GetChildren()) do
            if child ~= pageLayout and not child:IsA("UIPadding") then child:Destroy() end
        end
    end

    local function render(category)
        activeCategory = category
        title.Text = category.Label
        titleIcon.Image = Config.Icons[category.Icon] or category.Icon or ""
        clearPage()
        for sectionIndex, section in ipairs(category.Sections or {}) do
            local sectionFrame = make("Frame", {
                Name = section.Title, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = sectionIndex,
            }, page)
            local layout = make("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, sectionFrame)
            local sectionHeader = make("Frame", {
                Name = "SectionHeader", Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 0,
            }, sectionFrame)
            icon(sectionHeader, section.Icon or category.Icon, {
                Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(1, 4),
                ImageColor3 = Theme.Muted,
            })
            text(sectionHeader, section.Title, {
                Size = UDim2.new(1, -25, 1, 0), Position = UDim2.fromOffset(24, 0), TextColor3 = Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            })
            for controlIndex, control in ipairs(section.Controls or {}) do
                local row = createControl(sectionFrame, control)
                row.LayoutOrder = controlIndex
            end
        end
        page.CanvasPosition = Vector2.new(0, 0)
    end

    local function selectCategory(category, button)
        if activeButton then
            activeButton.BackgroundTransparency = 1
            local marker = activeButton:FindFirstChild("ActiveMarker")
            if marker then marker.Visible = false end
            local oldIcon = activeButton:FindFirstChild("CategoryIcon")
            local oldLabel = activeButton:FindFirstChild("CategoryLabel")
            if oldIcon then oldIcon.ImageColor3 = Theme.Muted end
            if oldLabel then oldLabel.TextColor3 = Theme.Muted end
        end
        activeButton, activeCategory = button, category
        button.BackgroundTransparency = 0.72
        button.ActiveMarker.Visible = true
        button.CategoryIcon.ImageColor3 = Theme.Accent
        button.CategoryLabel.TextColor3 = Theme.Text
        render(category)
    end

    local function refreshFavoriteOrder()
        for _, item in pairs(navButtons) do
            item.Button.LayoutOrder = item.Favorite and item.OriginalIndex or (1000 + item.OriginalIndex)
            item.FavoriteButton.ImageColor3 = item.Favorite and Theme.Bookmark or Theme.Dim
            item.FavoriteButton.ImageTransparency = item.Favorite and 0 or 0.12
        end
    end

    for index, category in ipairs(categories) do
        category.Bookmarked = false
        local button = make("TextButton", {
            Name = category.Id, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Text = "", AutoButtonColor = false, LayoutOrder = index,
        }, nav)
        round(button, 5)
        local marker = make("Frame", {
            Name = "ActiveMarker", Size = UDim2.fromOffset(3, 18), Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Visible = false,
        }, button)
        round(marker, 2)
        icon(button, category.Icon, {
            Name = "CategoryIcon",
            Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(12, 10),
            ImageColor3 = Theme.Muted, ZIndex = 2,
        })
        text(button, category.Label, {
            Name = "CategoryLabel",
            Size = UDim2.new(1, -68, 1, 0), Position = UDim2.fromOffset(36, 0),
            TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
        })
        local favorite = make("ImageButton", {
            Name = "Favorite", AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(16, 16), Position = UDim2.new(1, -17, 0.5, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, Image = Config.Icons.bookmark,
            ImageColor3 = Theme.Dim,
            AutoButtonColor = false, ZIndex = 5,
        }, button)
        navButtons[category.Id] = {
            Button = button, Category = category, FavoriteButton = favorite,
            Favorite = false, OriginalIndex = index,
        }
        connect(button.MouseButton1Click, function() selectCategory(category, button) end)
        connect(button.MouseEnter, function()
            if activeButton ~= button then TweenService:Create(button, TweenInfo.new(0.12), { BackgroundTransparency = 0.88 }):Play() end
        end)
        connect(button.MouseLeave, function()
            if activeButton ~= button then TweenService:Create(button, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play() end
        end)
        connect(favorite.MouseButton1Click, function()
            local item = navButtons[category.Id]
            item.Favorite = not item.Favorite
            category.Bookmarked = item.Favorite
            refreshFavoriteOrder()
            favorite.Size = UDim2.fromOffset(13, 13)
            TweenService:Create(favorite, TweenInfo.new(0.14, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(16, 16) }):Play()
        end)
        if category.Id == Config.DefaultCategory then selectCategory(category, button) end
    end
    refreshFavoriteOrder()
    if not activeButton then
        local first = navButtons[categories[1].Id]
        selectCategory(first.Category, first.Button)
    end

    connect(search:GetPropertyChangedSignal("Text"), function()
        local query = lower(search.Text):gsub("^%s+", ""):gsub("%s+$", "")
        for _, item in pairs(navButtons) do
            item.Button.Visible = query == "" or string.find(lower(item.Category.Label), query, 1, true) ~= nil
        end
    end)

    local hidden = false
    local function setVisible(visible)
        if destroyed or not root.Parent then return end
        if not visible then closeDropdown() end
        hidden = not visible
        root.Visible = visible
    end
    connect(minimize.MouseButton1Click, function() setVisible(false) end)
    connect(close.MouseButton1Click, function() setVisible(false) end)
    connect(UserInputService.InputBegan, function(inputObject, processed)
        if not processed and inputObject.KeyCode == Config.ToggleKey then setVisible(hidden) end
    end)

    local dragging, dragStart, startPosition = false, nil, nil
    connect(header.InputBegan, function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
            closeDropdown()
            dragging, dragStart, startPosition = true, inputObject.Position, root.Position
        end
    end)
    connect(UserInputService.InputChanged, function(inputObject)
        if dragging and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then
            local delta = inputObject.Position - dragStart
            root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
    connect(UserInputService.InputEnded, function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    local function updateScale()
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        local fit = math.min((viewport.X - Config.Window.Margin) / Config.Window.Width, (viewport.Y - Config.Window.Margin) / Config.Window.Height, 1)
        scale.Scale = math.max(fit, Config.Window.MinScale)
    end
    local function bindCamera()
        if cameraViewportConnection then
            pcall(function() cameraViewportConnection:Disconnect() end)
            cameraViewportConnection = nil
        end
        if Workspace.CurrentCamera then
            cameraViewportConnection = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
        end
        updateScale()
    end
    connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
    bindCamera()

    local currentThemeName = "Default"
    local wallpaperAssets = {}
    local themeKeys = {
        "Window", "WindowHighlight", "WindowDark", "Sidebar", "Header",
        "Surface", "SurfaceHover", "Control", "Accent", "Bookmark",
        "Text", "Muted", "Dim", "Border", "Success", "Danger",
    }
    local colorProperties = {
        "BackgroundColor3", "TextColor3", "PlaceholderColor3",
        "ImageColor3", "ScrollBarImageColor3", "Color",
    }

    local function copyColors(source)
        local result = {}
        for _, key in ipairs(themeKeys) do result[key] = source[key] end
        return result
    end

    local function colorThemeKey(color, palette)
        if typeof(color) ~= "Color3" then return nil end
        for _, key in ipairs(themeKeys) do
            if palette[key] == color then return key end
        end
        return nil
    end

    local function recolorMenu(oldColors, newColors)
        local objects = { root }
        for _, object in ipairs(root:GetDescendants()) do table.insert(objects, object) end
        for _, object in ipairs(objects) do
            for _, property in ipairs(colorProperties) do
                local ok, current = pcall(function() return object[property] end)
                if ok then
                    local key = colorThemeKey(current, oldColors)
                    if key and newColors[key] then
                        pcall(function() object[property] = newColors[key] end)
                    end
                end
            end
        end
    end

    local function assetBaseUrls()
        if type(options.AssetBaseUrls) == "table" and #options.AssetBaseUrls > 0 then
            return options.AssetBaseUrls
        end
        if type(options.BaseUrl) == "string" and options.BaseUrl ~= "" then
            return { options.BaseUrl }
        end
        return {}
    end

    local function downloadWallpaper(path)
        local lastError = "nenhuma fonte de assets foi configurada"
        local version = tostring(options.AssetVersion or Config.Version or "stable")
        for attempt = 1, 3 do
            for _, configuredBaseUrl in ipairs(assetBaseUrls()) do
                local baseUrl = configuredBaseUrl
                if string.sub(baseUrl, -1) ~= "/" then baseUrl = baseUrl .. "/" end
                local ok, data = pcall(function()
                    return game:HttpGet(baseUrl .. path .. "?v=" .. version, true)
                end)
                if ok and type(data) == "string" and string.sub(data, 1, 8) == "\137PNG\r\n\26\n" then
                    return data
                end
                if ok then
                    lastError = "a resposta não é uma imagem PNG válida"
                else
                    lastError = tostring(data)
                end
            end
            if attempt < 3 then task.wait(0.75 * (2 ^ (attempt - 1))) end
        end
        return nil, lastError
    end

    local function wallpaperAsset(themeName, definition)
        if wallpaperAssets[themeName] then return wallpaperAssets[themeName] end
        local assetLoader = type(getcustomasset) == "function" and getcustomasset
            or (type(getsynasset) == "function" and getsynasset or nil)
        if not assetLoader or type(writefile) ~= "function" then return nil end

        local ok, asset = pcall(function()
            local directory = "HInspectThemes"
            local version = tostring(options.AssetVersion or Config.Version or "stable")
                :gsub("[^%w%-_%.]", "_")
            local localPath = "HInspectTheme-" .. themeName .. "-" .. version .. ".png"
            if type(makefolder) == "function" then
                pcall(function() makefolder(directory) end)
                localPath = directory .. "/" .. themeName .. "-" .. version .. ".png"
            end
            if type(isfile) == "function" and isfile(localPath) then
                local cachedOk, cachedAsset = pcall(assetLoader, localPath)
                if cachedOk and cachedAsset then return cachedAsset end
            end
            local data, downloadError = downloadWallpaper(definition.Wallpaper)
            if not data then error(downloadError, 0) end
            writefile(localPath, data)
            return assetLoader(localPath)
        end)
        if not ok or not asset then
            warn("[H Inspect] Não foi possível carregar o wallpaper:", themeName, asset)
            return nil
        end
        wallpaperAssets[themeName] = asset
        return asset
    end

    local function updateWallpaper(themeName, definition)
        wallpaperRequest = wallpaperRequest + 1
        local request = wallpaperRequest
        wallpaper.Visible = false
        wallpaperShade.Visible = false
        if not definition.Wallpaper then
            wallpaper.Image = ""
            wallpaper.ImageTransparency = 1
            wallpaperShade.BackgroundTransparency = 1
            return
        end

        task.spawn(function()
            local asset = wallpaperAsset(themeName, definition)
            if request ~= wallpaperRequest or currentThemeName ~= themeName or not asset then return end
            wallpaper.Image = asset
            wallpaper.ImageTransparency = 1
            wallpaperShade.BackgroundTransparency = 1
            wallpaper.Visible = true
            wallpaperShade.Visible = true
            TweenService:Create(wallpaper, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {
                ImageTransparency = definition.WallpaperTransparency or 0.42,
            }):Play()
            TweenService:Create(wallpaperShade, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {
                BackgroundTransparency = definition.ShadeTransparency or 0.5,
            }):Play()
        end)
    end

    local function applyTheme(themeName)
        local definition = Config.Themes and Config.Themes[themeName]
        if not definition or not definition.Colors or themeName == currentThemeName then return end
        closeDropdown()

        local oldColors = copyColors(Theme)
        local newColors = definition.Colors
        recolorMenu(oldColors, newColors)
        for _, key in ipairs(themeKeys) do
            if newColors[key] then Theme[key] = newColors[key] end
        end
        currentThemeName = themeName
        rootGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.WindowHighlight),
            ColorSequenceKeypoint.new(1, Theme.WindowDark),
        })
        wallpaperShade.BackgroundColor3 = Theme.WindowDark
        updateWallpaper(themeName, definition)

        if activeCategory then render(activeCategory) end
        refreshFavoriteOrder()
    end

    themeSetter = function(themeName)
        applyTheme(tostring(themeName or "Default"))
    end
    _G.__HINSPECT_SET_THEME = themeSetter

    print("[H Inspect] Aberto. Use RightShift para ocultar ou mostrar.")
    return { Gui = gui, State = state, Destroy = cleanupFunction, SetVisible = setVisible }
end

return HInspect
end
-- END HInspect.lua

-- BEGIN categories/AttackCapture.lua
__modules["categories/AttackCapture.lua"] = function()
return {
    Id = "AttackCapture",
    Label = "Combate",
    Icon = "target",
    Bookmarked = false,
    RuntimeModule = "runtime/AttackCapture.lua",
    Sections = {
        {
            Title = "Captura guiada",
            Icon = "search",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "attack_help",
                    Label = "Capture Push, soco e armas separadamente",
                    Description = "Inicie antes de equipar. Equipe uma ferramenta, use uma vez e tente novamente durante a recarga. Encerre e copie. Repita em outra coleta para a próxima arma.",
                    Height = 98,
                },
                {
                    Kind = "Input",
                    Setting = "CaptureLabel",
                    Id = "attack_capture_label",
                    Label = "Nome deste teste",
                    Placeholder = "Push — Red Light/Green Light",
                    Default = "Push — Red Light/Green Light",
                },
                {
                    Kind = "Toggle",
                    Setting = "CaptureInbound",
                    Id = "attack_capture_inbound",
                    Label = "Registrar respostas do servidor",
                    Description = "Preserva eventos recebidos próximos das ativações e eventos com nomes ligados a combate.",
                    Default = true,
                },
                {
                    Kind = "Button",
                    Setting = "StartAttackCapture",
                    Id = "start_attack_capture",
                    Label = "Iniciar antes de equipar",
                    Description = "Observa todas as Tools, ativações, estados e chamadas enviadas pelo jogo sem executar ataques.",
                    ButtonText = "Iniciar",
                },
                {
                    Kind = "Button",
                    Setting = "FinishAttackCapture",
                    Id = "finish_attack_capture",
                    Label = "Encerrar e analisar",
                    Description = "Use depois do ataque normal e da tentativa feita durante a recarga.",
                    ButtonText = "Analisar",
                },
                {
                    Kind = "Button",
                    Setting = "CopyAttackCapture",
                    Id = "copy_attack_capture",
                    Label = "Copiar relatório completo",
                    Description = "Encerra automaticamente uma coleta ativa antes de copiar.",
                    ButtonText = "Copiar",
                },
                {
                    Kind = "Button",
                    Setting = "ClearAttackCapture",
                    Id = "clear_attack_capture",
                    Label = "Limpar captura de combate",
                    ButtonText = "Limpar",
                },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "attack_status",
                    Label = "Aguardando captura",
                    Description = "Faça uma coleta para o Push e outra para o soco ou arma diferente.",
                    Height = 82,
                },
                {
                    Kind = "Paragraph",
                    Id = "attack_report",
                    Label = "Prévia da investigação",
                    Description = "Ativações, remotes e mudanças de estado aparecerão aqui.",
                    Height = 400,
                },
            },
        },
    },
}
end
-- END categories/AttackCapture.lua

-- BEGIN categories/Baby.lua
__modules["categories/Baby.lua"] = function()
return {
    Id = "Baby",
    Label = "Bebê",
    Icon = "users",
    Bookmarked = false,
    RuntimeModule = "runtime/Baby.lua",
    Sections = {
        {
            Title = "Coleta guiada",
            Icon = "search",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "baby_help",
                    Label = "1. Inicie carregando o bebê  •  2. Solte  •  3. Pegue normalmente  •  4. Copie",
                    Description = "A coleta observa os remotes recebidos, tenta registrar chamadas enviadas pelo jogo, salva mudanças do seu personagem e examina objetos criados perto da posição do drop.",
                    Height = 82,
                },
                {
                    Kind = "Slider",
                    Setting = "BabyScanRadius",
                    Id = "baby_scan_radius",
                    Label = "Raio ao redor do bebê",
                    Description = "Distância usada para detalhar prompts, detectores, peças e modelos ao redor do CFrame recebido em dropBaby.",
                    Min = 15,
                    Max = 150,
                    Default = 60,
                    Step = 5,
                },
                {
                    Kind = "Button",
                    Setting = "StartBabyCapture",
                    Id = "start_baby_capture",
                    Label = "Iniciar enquanto estiver carregando",
                    Description = "Salva a base e começa a observar. Depois deste clique, solte e pegue o bebê normalmente.",
                    ButtonText = "Iniciar",
                },
                {
                    Kind = "Button",
                    Setting = "FinishBabyCapture",
                    Id = "finish_baby_capture",
                    Label = "Encerrar e analisar",
                    Description = "Finalize depois de pegar o bebê novamente.",
                    ButtonText = "Analisar",
                },
                {
                    Kind = "Button",
                    Setting = "CopyBabyCapture",
                    Id = "copy_baby_capture",
                    Label = "Copiar relatório completo",
                    Description = "Se a coleta ainda estiver ativa, ela será encerrada automaticamente antes da cópia.",
                    ButtonText = "Copiar",
                },
                {
                    Kind = "Button",
                    Setting = "ClearBabyCapture",
                    Id = "clear_baby_capture",
                    Label = "Limpar coleta do bebê",
                    ButtonText = "Limpar",
                },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "baby_status",
                    Label = "Aguardando coleta",
                    Description = "Inicie a coleta enquanto o bebê ainda estiver com você.",
                    Height = 78,
                },
                {
                    Kind = "Paragraph",
                    Id = "baby_report",
                    Label = "Prévia da investigação",
                    Description = "Os eventos e candidatos de interação aparecerão aqui.",
                    Height = 360,
                },
            },
        },
    },
}
end
-- END categories/Baby.lua

-- BEGIN categories/Compare.lua
__modules["categories/Compare.lua"] = function()
return {
    Id = "Compare",
    Label = "Comparar",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Snapshot A → estado atual",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "SnapshotScope", Id = "snapshot_scope", Label = "Escopo do snapshot", Options = { "Tudo relevante", "Vidros e mapa", "Interface", "Jogador e itens" }, Default = "Tudo relevante", UseList = true },
                { Kind = "Input", Setting = "SnapshotFilter", Id = "snapshot_filter", Label = "Filtro opcional", Placeholder = "glass, bridge, fabricante...", Default = "" },
                { Kind = "Slider", Setting = "SnapshotLimit", Id = "snapshot_limit", Label = "Limite de objetos", Min = 500, Max = 10000, Default = 5000, Step = 500 },
                { Kind = "Button", Setting = "CaptureBaseline", Id = "capture_baseline", Label = "Salvar snapshot A", Description = "Faça isto antes de mudar de cargo, receber o item ou entrar na fase da ponte.", ButtonText = "Salvar A" },
                { Kind = "Button", Setting = "CompareSnapshot", Id = "compare_snapshot", Label = "Comparar com o estado atual", Description = "Mostra objetos adicionados, removidos e propriedades alteradas.", ButtonText = "Comparar" },
                { Kind = "Button", Setting = "ClearBaseline", Id = "clear_baseline", Label = "Apagar snapshot A", ButtonText = "Apagar" },
            },
        },
        {
            Title = "Diferenças",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "compare_status", Label = "Snapshot A não salvo", Description = "Escolha o escopo e salve uma base primeiro.", Height = 68 },
                { Kind = "Paragraph", Id = "compare_report", Label = "Prévia das diferenças", Description = "Mudanças relevantes aparecerão aqui.", Height = 360 },
            },
        },
    },
}
end
-- END categories/Compare.lua

-- BEGIN categories/Explorer.lua
__modules["categories/Explorer.lua"] = function()
return {
    Id = "Explorer",
    Label = "Estrutura",
    Icon = "search",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Busca geral",
            Icon = "overview",
            Controls = {
                { Kind = "Dropdown", Setting = "StructureScope", Id = "structure_scope", Label = "Escopo", Options = { "Tudo relevante", "ReplicatedStorage", "Workspace", "PlayerGui", "Personagem" }, Default = "Tudo relevante", UseList = true },
                { Kind = "Input", Setting = "StructureFilter", Id = "structure_filter", Label = "Nome ou caminho", Placeholder = "role, glass, door, remote...", Default = "" },
                { Kind = "Slider", Setting = "MaxStructureResults", Id = "max_structure_results", Label = "Máximo de resultados", Min = 50, Max = 500, Default = 200, Step = 50 },
                { Kind = "Button", Setting = "ScanStructure", Id = "scan_structure", Label = "Varrer estrutura", Description = "Sem filtro, prioriza Values, Tools, remotes, módulos, prompts, tags e atributos.", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "structure_status", Label = "Nenhuma busca", Description = "Use palavras do jogo para localizar dados replicados.", Height = 68 },
                { Kind = "Paragraph", Id = "structure_report", Label = "Prévia da estrutura", Description = "A prévia será preenchida depois da busca.", Height = 340 },
            },
        },
    },
}
end
-- END categories/Explorer.lua

-- BEGIN categories/Home.lua
__modules["categories/Home.lua"] = function()
return {
    Id = "Home",
    Label = "Início",
    Icon = "home",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "H Inspect",
            Icon = "overview",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "welcome",
                    Label = "Base limpa para investigação",
                    Description = "Colete sinais visíveis no cliente — jogadores, itens, interface, mapa e estrutura replicada — antes de criar módulos específicos. Nenhuma ação é executada no jogo.",
                    Height = 72,
                },
                {
                    Kind = "Button",
                    Setting = "ScanAll",
                    Id = "scan_all_home",
                    Label = "Criar snapshot completo",
                    Description = "Varre jogadores, itens equipados, textos da interface, portas, interações e vidros.",
                    ButtonText = "Coletar",
                },
                {
                    Kind = "Paragraph",
                    Id = "home_status",
                    Label = "Aguardando coleta",
                    Description = "Use o snapshot completo ou abra uma categoria para fazer uma varredura direcionada.",
                    Height = 78,
                },
            },
        },
        {
            Title = "Fluxo recomendado",
            Icon = "info",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "workflow_help",
                    Label = "1. Colete a base  •  2. Mude de fase/cargo  •  3. Compare",
                    Description = "Para o fabricante de vidro, salve o snapshot A antes da informação aparecer e compare quando o cargo ou a fase estiver ativo. O diff destaca propriedades e textos alterados.",
                    Height = 72,
                },
            },
        },
    },
}
end
-- END categories/Home.lua

-- BEGIN categories/Interface.lua
__modules["categories/Interface.lua"] = function()
return {
    Id = "Interface",
    Label = "Interface",
    Icon = "sliders",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Textos e imagens locais",
            Icon = "search",
            Controls = {
                { Kind = "Input", Setting = "GuiFilter", Id = "gui_filter", Label = "Filtro da interface", Placeholder = "fabricante, guarda, glass...", Default = "" },
                { Kind = "Toggle", Setting = "IncludeHiddenGui", Id = "include_hidden_gui", Label = "Incluir elementos ocultos", Description = "Muitos jogos deixam textos de cargos e fases carregados, mas invisíveis.", Default = true },
                { Kind = "Slider", Setting = "MaxGuiResults", Id = "max_gui_results", Label = "Máximo de resultados", Min = 50, Max = 500, Default = 200, Step = 50 },
                { Kind = "Button", Setting = "ScanGui", Id = "scan_gui", Label = "Varrer PlayerGui agora", Description = "Coleta textos, imagens, visibilidade, posição, tamanho, tags e atributos.", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "gui_status", Label = "Nenhuma varredura", Description = "Textos como cargos, chances e avisos de fase aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "gui_report", Label = "Prévia da interface", Description = "A prévia será preenchida depois da primeira coleta.", Height = 320 },
            },
        },
    },
}
end
-- END categories/Interface.lua

-- BEGIN categories/Items.lua
__modules["categories/Items.lua"] = function()
return {
    Id = "Items",
    Label = "Itens",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Mão, hotbar e mochila",
            Icon = "search",
            Controls = {
                { Kind = "Toggle", Setting = "IncludeToolDescendants", Id = "include_tool_descendants", Label = "Detalhar conteúdo dos itens", Description = "Inclui Handle, valores, animações, sons, scripts e objetos de rede dentro de cada Tool.", Default = true },
                { Kind = "Toggle", Setting = "IncludeAccessories", Id = "include_accessories", Label = "Incluir acessórios e objetos anexados", Description = "Ajuda quando o jogo representa um item na mão fora de uma Tool comum.", Default = true },
                { Kind = "Button", Setting = "ScanItems", Id = "scan_items", Label = "Varrer itens agora", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "items_status", Label = "Nenhuma varredura", Description = "Itens equipados e guardados aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "items_report", Label = "Prévia dos itens", Description = "A prévia será preenchida depois da primeira coleta.", Height = 320 },
            },
        },
    },
}
end
-- END categories/Items.lua

-- BEGIN categories/MusicalChairs.lua
__modules["categories/MusicalChairs.lua"] = function()
return {
    Id = "MusicalChairs",
    Label = "Cadeiras",
    Icon = "search",
    Bookmarked = false,
    RuntimeModule = "runtime/MusicalChairs.lua",
    Sections = {
        {
            Title = "Coleta guiada completa",
            Icon = "search",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "chairs_help",
                    Label = "Inicie antes da música e marque cada estado durante a rodada",
                    Description = "Registra Humanoid.Sit/SeatPart, Seat.Occupant, SeatWeld, estrutura próxima, prompts, remotes e mudanças. Não senta, não move e não dispara nada.",
                    Height = 96,
                },
                {
                    Kind = "Slider",
                    Setting = "ChairScanRadius",
                    Id = "chairs_scan_radius",
                    Label = "Raio da estrutura próxima",
                    Description = "Inclui peças genéricas ao redor do personagem mesmo quando não possuem chair ou seat no nome.",
                    Min = 10,
                    Max = 120,
                    Default = 45,
                    Step = 5,
                },
                {
                    Kind = "Slider",
                    Setting = "ChairCandidateLimit",
                    Id = "chairs_candidate_limit",
                    Label = "Limite por fotografia",
                    Description = "Quantidade máxima de Seats, juntas, interações e peças próximas detalhadas em cada marcação.",
                    Min = 50,
                    Max = 300,
                    Default = 160,
                    Step = 10,
                },
                {
                    Kind = "Toggle",
                    Setting = "CaptureAllChairRemotes",
                    Id = "chairs_all_remotes",
                    Label = "Preservar todos os remotes recebidos",
                    Description = "Desligado mantém apenas eventos relacionados à fase, cadeira, estado, timer e eliminação.",
                    Default = false,
                },
                {
                    Kind = "Button",
                    Setting = "StartChairsCapture",
                    Id = "start_chairs_capture",
                    Label = "1. Iniciar antes da música",
                    Description = "Salva a base e começa a observar a rodada inteira.",
                    ButtonText = "Iniciar",
                },
                {
                    Kind = "Button",
                    Setting = "MarkChairFree",
                    Id = "mark_chair_free",
                    Label = "2. Registrar cadeira livre",
                    Description = "Use perto de uma cadeira antes de alguém sentar nela.",
                    ButtonText = "Marcar livre",
                },
                {
                    Kind = "Button",
                    Setting = "MarkRealSeat",
                    Id = "mark_real_seat",
                    Label = "3. Registrar sentado de verdade",
                    Description = "Sente normalmente e clique enquanto ainda estiver ocupando a cadeira real.",
                    ButtonText = "Marcar real",
                },
                {
                    Kind = "Button",
                    Setting = "MarkAirSeat",
                    Id = "mark_air_seat",
                    Label = "4. Registrar sentado no ar",
                    Description = "Opcional: ative o teste do HMenu e marque para comparar com a cadeira real.",
                    ButtonText = "Marcar no ar",
                },
                {
                    Kind = "Button",
                    Setting = "FinishChairsCapture",
                    Id = "finish_chairs_capture",
                    Label = "5. Encerrar após a eliminação/limpeza",
                    Description = "Salva o estado final e monta o relatório comparativo.",
                    ButtonText = "Analisar",
                },
                {
                    Kind = "Button",
                    Setting = "CopyChairsCapture",
                    Id = "copy_chairs_capture",
                    Label = "6. Copiar relatório completo",
                    Description = "Encerra automaticamente uma captura ativa e copia tudo para enviar.",
                    ButtonText = "Copiar",
                },
                {
                    Kind = "Button",
                    Setting = "ClearChairsCapture",
                    Id = "clear_chairs_capture",
                    Label = "Limpar coleta das cadeiras",
                    ButtonText = "Limpar",
                },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                {
                    Kind = "Paragraph",
                    Id = "chairs_status",
                    Label = "Aguardando coleta",
                    Description = "Inicie antes da música e faça as marcações na ordem indicada.",
                    Height = 86,
                },
                {
                    Kind = "Paragraph",
                    Id = "chairs_report",
                    Label = "Prévia da investigação",
                    Description = "Estados, assentos, juntas e eventos relevantes aparecerão aqui.",
                    Height = 400,
                },
            },
        },
    },
}
end
-- END categories/MusicalChairs.lua

-- BEGIN categories/Players.lua
__modules["categories/Players.lua"] = function()
return {
    Id = "Players",
    Label = "Jogadores",
    Icon = "users",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Inspeção individual",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "SelectedPlayer", Id = "selected_player", Label = "Jogador alvo", Description = "Abra a lista para atualizar os jogadores disponíveis. Meu personagem fica sempre no topo.", OptionsSource = "PlayerTargets", Default = "Meu personagem", UseList = true },
                { Kind = "Toggle", Setting = "InspectToolDescendants", Id = "inspect_tool_descendants", Label = "Detalhar ferramentas do alvo", Description = "Inclui scripts, valores, sons, animações e peças úteis de Knife, Fork e outras Tools.", Default = true },
                { Kind = "Button", Setting = "InspectSelectedPlayer", Id = "inspect_selected_player", Label = "Inspecionar jogador selecionado", Description = "Lê Player, Character, Humanoid, Backpack, atributos, valores, ferramentas e acessórios.", ButtonText = "Inspecionar" },
                { Kind = "Button", Setting = "CopySelectedPlayer", Id = "copy_selected_player", Label = "Copiar inspeção individual", Description = "Copia somente o relatório deste jogador, sem o snapshot completo.", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Resultado individual",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "selected_player_status", Label = "Nenhum jogador inspecionado", Description = "Escolha Meu personagem ou outro jogador e clique em Inspecionar.", Height = 68 },
                { Kind = "Paragraph", Id = "selected_player_report", Label = "Prévia individual", Description = "O relatório focado aparecerá aqui.", Height = 400 },
            },
        },
        {
            Title = "Coleta de jogadores",
            Icon = "users",
            Controls = {
                { Kind = "Toggle", Setting = "IncludePlayerAttributes", Id = "include_player_attributes", Label = "Incluir atributos e valores", Description = "Procura sinais como role, cargo, class, team, status e valores do leaderstats.", Default = true },
                { Kind = "Toggle", Setting = "IncludePlayerTools", Id = "include_player_tools", Label = "Incluir ferramentas", Description = "Lista Tools no personagem e na mochila; os detalhes completos ficam em Itens.", Default = true },
                { Kind = "Toggle", Setting = "LivePlayerScan", Id = "live_player_scan", Label = "Atualização automática", Description = "Repete a coleta de jogadores no intervalo selecionado.", Default = false },
                { Kind = "Slider", Setting = "ScanInterval", Id = "scan_interval", Label = "Intervalo da atualização", Min = 2, Max = 15, Default = 5, Step = 1 },
                { Kind = "Button", Setting = "ScanPlayers", Id = "scan_players", Label = "Varrer jogadores agora", ButtonText = "Varrer" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "players_status", Label = "Nenhuma varredura", Description = "Os possíveis sinais de cargo aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "players_report", Label = "Prévia dos jogadores", Description = "A prévia será preenchida depois da primeira coleta.", Height = 280 },
            },
        },
    },
}
end
-- END categories/Players.lua

-- BEGIN categories/Remotes.lua
__modules["categories/Remotes.lua"] = function()
return {
    Id = "Remotes",
    Label = "Remotes",
    Icon = "overview",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Inventário de rede",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "RemoteScope", Id = "remote_scope", Label = "Escopo", Options = { "ReplicatedStorage", "Workspace", "Tudo replicado" }, Default = "ReplicatedStorage", UseList = true },
                { Kind = "Input", Setting = "RemoteFilter", Id = "remote_filter", Label = "Filtro do caminho", Placeholder = "GameStateUpdate, ReplicaSet, Notify...", Default = "" },
                { Kind = "Input", Setting = "RemotePayloadFilter", Id = "remote_payload_filter", Label = "Filtro dos argumentos", Placeholder = "glass, rope, bounty, reward...", Default = "" },
                { Kind = "Slider", Setting = "MaxRemoteResults", Id = "max_remote_results", Label = "Máximo de remotes", Min = 20, Max = 300, Default = 150, Step = 10 },
                { Kind = "Button", Setting = "ScanRemotes", Id = "scan_remotes", Label = "Varrer remotes", Description = "Lista RemoteEvent, UnreliableRemoteEvent e RemoteFunction sem chamar o servidor.", ButtonText = "Varrer" },
                { Kind = "Button", Setting = "CopyRemoteReport", Id = "copy_remote_report", Label = "Copiar inventário", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Eventos recebidos",
            Icon = "info",
            Controls = {
                { Kind = "Slider", Setting = "MaxRemoteLog", Id = "max_remote_log", Label = "Máximo de eventos no histórico", Min = 20, Max = 300, Default = 120, Step = 10 },
                { Kind = "Button", Setting = "StartRemoteMonitor", Id = "start_remote_monitor", Label = "Iniciar monitor passivo", Description = "Conecta pelos caminhos escolhidos e pode filtrar o conteúdo recebido sem enviar nada ao servidor.", ButtonText = "Iniciar" },
                { Kind = "Button", Setting = "StopRemoteMonitor", Id = "stop_remote_monitor", Label = "Parar monitor", ButtonText = "Parar" },
                { Kind = "Button", Setting = "CopyRemoteLog", Id = "copy_remote_log", Label = "Copiar eventos recebidos", ButtonText = "Copiar" },
                { Kind = "Button", Setting = "ClearRemoteLog", Id = "clear_remote_log", Label = "Limpar histórico", ButtonText = "Limpar" },
                { Kind = "Paragraph", Id = "remote_status", Label = "Monitor parado", Description = "Faça o inventário ou inicie a observação passiva.", Height = 72 },
                { Kind = "Paragraph", Id = "remote_report", Label = "Prévia dos remotes", Description = "Caminhos e eventos recebidos aparecerão aqui.", Height = 280 },
            },
        },
    },
}
end
-- END categories/Remotes.lua

-- BEGIN categories/Reports.lua
__modules["categories/Reports.lua"] = function()
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
end
-- END categories/Reports.lua

-- BEGIN categories/Settings.lua
__modules["categories/Settings.lua"] = function()
return {
    Id = "Settings",
    Label = "Configurações",
    Icon = "settings",
    Bookmarked = false,
    RuntimeModule = "runtime/Settings.lua",
    Sections = {
        {
            Title = "Aparência",
            Icon = "palette",
            Controls = {
                { Kind = "Dropdown", Setting = "MenuTheme", Id = "menu_theme", Label = "Tema do menu", Description = "Mantém os temas visuais da base original.", Options = { "Default", "Purple", "Orange" }, Default = "Default", UseList = true },
            },
        },
        {
            Title = "Atalhos",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "shortcut_help", Label = "RightShift mostra ou oculta o H Inspect", Description = "A barra superior continua arrastável; os botões — e X apenas ocultam a janela.", Height = 68 },
            },
        },
    },
}
end
-- END categories/Settings.lua

-- BEGIN categories/World.lua
__modules["categories/World.lua"] = function()
return {
    Id = "World",
    Label = "Mapa",
    Icon = "map",
    Bookmarked = false,
    RuntimeModule = "runtime/Inspector.lua",
    Sections = {
        {
            Title = "Coleta do mapa",
            Icon = "search",
            Controls = {
                { Kind = "Dropdown", Setting = "WorldFocus", Id = "world_focus", Label = "Foco da varredura", Options = { "Tudo", "Portas e saídas", "Vidros e ponte", "Interações" }, Default = "Tudo", UseList = true },
                { Kind = "Input", Setting = "WorldFilter", Id = "world_filter", Label = "Filtro adicional", Placeholder = "glass, bridge, door, nome...", Default = "" },
                { Kind = "Slider", Setting = "MaxWorldResults", Id = "max_world_results", Label = "Máximo de resultados", Min = 20, Max = 200, Default = 80, Step = 10 },
                { Kind = "Button", Setting = "ScanWorld", Id = "scan_world", Label = "Varrer mapa agora", Description = "Lê cor, material, transparência local, colisão, tags, atributos e prompts.", ButtonText = "Varrer" },
                { Kind = "Button", Setting = "CopyWorldReport", Id = "copy_world_report", Label = "Copiar relatório do mapa", Description = "Copia a coleta completa, incluindo assinaturas, pais, irmãos e filhos dos candidatos.", ButtonText = "Copiar" },
            },
        },
        {
            Title = "Resultado",
            Icon = "info",
            Controls = {
                { Kind = "Paragraph", Id = "world_status", Label = "Nenhuma varredura", Description = "Portas, vidros e interações candidatas aparecerão aqui.", Height = 68 },
                { Kind = "Paragraph", Id = "world_report", Label = "Prévia do mapa", Description = "A prévia será preenchida depois da primeira coleta.", Height = 300 },
            },
        },
    },
}
end
-- END categories/World.lua

-- BEGIN runtime/AttackCapture.lua
__modules["runtime/AttackCapture.lua"] = function()
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
end
-- END runtime/AttackCapture.lua

-- BEGIN runtime/Baby.lua
__modules["runtime/Baby.lua"] = function()
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
end
-- END runtime/Baby.lua

-- BEGIN runtime/Inspector.lua
__modules["runtime/Inspector.lua"] = function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Inspector = {}

local ROLE_WORDS = {
    "role", "cargo", "class", "classe", "team", "time", "status",
    "job", "type", "tipo", "guard", "guarda", "detective", "detetive",
    "leader", "lider", "líder", "maker", "fabricante", "baby", "newborn",
    "vip", "playerstate", "state",
}

local INSPECTION_WORDS = {
    "role", "cargo", "class", "team", "status", "state", "playing", "inside",
    "guard", "detective", "frontman", "leader", "maker", "glass", "vision",
    "rank", "dead", "winner", "safe", "protect", "target", "bounty", "reward",
    "cooldown", "knife", "fork", "weapon", "gun", "ammo", "damage", "hit",
    "baby", "newborn", "sprint",
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
    if value == nil then value = "" end
    return tostring(value):gsub("[\r\n\t]", " ")
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

local function matchesCommaFilter(searchable, filter)
    local normalized = normalizedFilter(filter)
    if normalized == "" then return true end
    local lowered = string.lower(tostring(searchable or ""))
    local foundTerm = false
    for term in string.gmatch(normalized, "[^,;]+") do
        term = term:gsub("^%s+", ""):gsub("%s+$", "")
        if term ~= "" then
            foundTerm = true
            if string.find(lowered, term, 1, true) then return true end
        end
    end
    return not foundTerm
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
        table.insert(details, "orientation=" .. formatValue(instance.Orientation))
        if instance:IsA("Part") then table.insert(details, "shape=" .. tostring(instance.Shape)) end
        table.insert(details, "material=" .. tostring(instance.Material))
        table.insert(details, "color=" .. formatValue(instance.Color))
        table.insert(details, "transparency=" .. tostring(instance.Transparency))
        table.insert(details, "localTransparency=" .. tostring(instance.LocalTransparencyModifier))
        table.insert(details, "reflectance=" .. tostring(instance.Reflectance))
        table.insert(details, "collide=" .. tostring(instance.CanCollide))
        table.insert(details, "touch=" .. tostring(instance.CanTouch))
        table.insert(details, "query=" .. tostring(instance.CanQuery))
        table.insert(details, "anchored=" .. tostring(instance.Anchored))
        table.insert(details, "massless=" .. tostring(instance.Massless))
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

local function directChildren(instance)
    local ok, children = pcall(function() return instance:GetChildren() end)
    return ok and children or {}
end

local function descendantCount(instance)
    local ok, descendants = pcall(function() return instance:GetDescendants() end)
    return ok and #descendants or 0
end

local function siblingPosition(instance)
    local parent = instance.Parent
    if not parent then return 0, 0 end
    local siblings = directChildren(parent)
    table.sort(siblings, function(a, b)
        local aName, bName = string.lower(a.Name), string.lower(b.Name)
        if aName == bName then return a.ClassName < b.ClassName end
        return aName < bName
    end)
    for index, sibling in ipairs(siblings) do
        if sibling == instance then return index, #siblings end
    end
    return 0, #siblings
end

local function nearestModelPath(instance)
    local current = instance.Parent
    while current and current ~= Workspace do
        if current:IsA("Model") then return fullName(current) end
        current = current.Parent
    end
    return "nenhum"
end

local function childSummary(instance, maximum)
    local descriptions = {}
    local children = directChildren(instance)
    table.sort(children, function(a, b)
        local aKey = string.lower(a.Name) .. "\0" .. a.ClassName
        local bKey = string.lower(b.Name) .. "\0" .. b.ClassName
        return aKey < bKey
    end)
    for index, child in ipairs(children) do
        if index > maximum then break end
        local description = child.Name .. "<" .. child.ClassName .. ">"
        if child:IsA("ValueBase") then
            local ok, value = pcall(function() return child.Value end)
            if ok then description = description .. "=" .. formatValue(value) end
        end
        local tags = readTags(child)
        if #tags > 0 then description = description .. " tags={" .. table.concat(tags, ",") .. "}" end
        local attributes = readAttributes(child)
        if #attributes > 0 then description = description .. " attrs={" .. table.concat(attributes, ";") .. "}" end
        table.insert(descriptions, description)
    end
    if #children > maximum then
        table.insert(descriptions, string.format("... +%d filhos", #children - maximum))
    end
    return #children > 0 and table.concat(descriptions, ", ") or "nenhum"
end

local function containerSignalSummary(instance)
    if not instance then return "nenhum" end
    local signals = { "class=" .. instance.ClassName }
    local tags = readTags(instance)
    if #tags > 0 then table.insert(signals, "tags={" .. table.concat(tags, ",") .. "}") end
    local attributes = readAttributes(instance)
    if #attributes > 0 then table.insert(signals, "attrs={" .. table.concat(attributes, ";") .. "}") end
    local values = {}
    for _, child in ipairs(directChildren(instance)) do
        if child:IsA("ValueBase") then
            local ok, value = pcall(function() return child.Value end)
            if ok then table.insert(values, child.Name .. "=" .. formatValue(value)) end
        end
    end
    table.sort(values)
    if #values > 0 then table.insert(signals, "values={" .. table.concat(values, ";") .. "}") end
    return table.concat(signals, " | ")
end

-- A assinatura ignora nome, caminho e posição. Objetos visualmente iguais ficam
-- no mesmo grupo; qualquer diferença replicada de vidro real/falso tende a criar
-- grupos distintos e fica mais fácil de comparar no relatório copiado.
local function worldFingerprint(instance)
    local values = { "class=" .. instance.ClassName }
    if instance:IsA("BasePart") then
        table.insert(values, "size=" .. formatValue(instance.Size))
        table.insert(values, "material=" .. tostring(instance.Material))
        table.insert(values, "color=" .. formatValue(instance.Color))
        table.insert(values, "transparency=" .. tostring(instance.Transparency))
        table.insert(values, "localTransparency=" .. tostring(instance.LocalTransparencyModifier))
        table.insert(values, "reflectance=" .. tostring(instance.Reflectance))
        table.insert(values, "collide=" .. tostring(instance.CanCollide))
        table.insert(values, "touch=" .. tostring(instance.CanTouch))
        table.insert(values, "query=" .. tostring(instance.CanQuery))
        table.insert(values, "anchored=" .. tostring(instance.Anchored))
        table.insert(values, "castShadow=" .. tostring(instance.CastShadow))
        table.insert(values, "collisionGroup=" .. tostring(instance.CollisionGroup))
        table.insert(values, "materialVariant=" .. oneLine(instance.MaterialVariant))
        if instance:IsA("MeshPart") then
            table.insert(values, "meshId=" .. oneLine(instance.MeshId))
            table.insert(values, "textureId=" .. oneLine(instance.TextureID))
        end
    elseif instance:IsA("ValueBase") then
        local ok, value = pcall(function() return instance.Value end)
        if ok then table.insert(values, "value=" .. formatValue(value)) end
    end
    local tags = readTags(instance)
    if #tags > 0 then table.insert(values, "tags=" .. table.concat(tags, ",")) end
    local attributes = readAttributes(instance)
    if #attributes > 0 then table.insert(values, "attrs=" .. table.concat(attributes, ";")) end

    local childShapes = {}
    for _, child in ipairs(directChildren(instance)) do
        local shape = child.ClassName .. ":" .. child.Name
        if child:IsA("ValueBase") then
            local ok, value = pcall(function() return child.Value end)
            if ok then shape = shape .. "=" .. formatValue(value) end
        end
        local childTags = readTags(child)
        if #childTags > 0 then shape = shape .. "#" .. table.concat(childTags, ",") end
        local childAttributes = readAttributes(child)
        if #childAttributes > 0 then shape = shape .. "@" .. table.concat(childAttributes, ";") end
        table.insert(childShapes, shape)
    end
    table.sort(childShapes)
    table.insert(values, "children=" .. table.concat(childShapes, ","))
    return table.concat(values, "|")
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
    if player:GetAttribute("HasBaby") == true then
        local babyType = player:GetAttribute("BabyType")
        table.insert(labels, babyType ~= nil and babyType ~= ""
            and ("Baby:" .. oneLine(babyType)) or "Baby")
    end
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

local function formatRemoteArgument(value, depth, seen)
    local valueType = typeof(value)
    if valueType == "nil" then return "nil" end
    if valueType == "Instance" then
        return string.format("<%s %s>", value.ClassName, fullName(value))
    end
    if valueType == "string" then
        local text = oneLine(value)
        if #text > 240 then text = string.sub(text, 1, 240) .. "..." end
        return string.format("%q", text)
    end
    if valueType ~= "table" then return formatValue(value) end
    if depth >= 4 then return "{...}" end
    if seen[value] then return "{<ciclo>}" end
    seen[value] = true

    local entries = {}
    local totalEntries = 0
    for key, item in pairs(value) do
        totalEntries = totalEntries + 1
        if #entries < 24 then
            table.insert(entries, {
                Key = formatRemoteArgument(key, depth + 1, seen),
                Value = formatRemoteArgument(item, depth + 1, seen),
            })
        end
    end
    table.sort(entries, function(a, b) return a.Key < b.Key end)
    local parts = {}
    for _, entry in ipairs(entries) do
        table.insert(parts, "[" .. entry.Key .. "]=" .. entry.Value)
    end
    if totalEntries > #entries then
        table.insert(parts, string.format("... +%d entradas", totalEntries - #entries))
    end
    seen[value] = nil
    return "{" .. table.concat(parts, ", ") .. "}"
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
    local lastRemoteReport = ""
    local remoteLog = {}
    local remoteEventCounts = {}
    local remoteReceivedTotal = 0
    local remoteConnections = {}
    local monitoredRemotes = {}
    local remoteMonitoring = false
    local lastRemoteUiUpdate = 0
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
        RemoteScope = "ReplicatedStorage",
        RemoteFilter = "",
        RemotePayloadFilter = "",
        MaxRemoteResults = 150,
        MaxRemoteLog = 120,
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
        if focus == "Vidros e ponte" then
            local current = instance
            while current and current ~= Workspace do
                if current:IsA("Accessory") or current:IsA("Tool")
                    or (current:IsA("Model") and current:FindFirstChildOfClass("Humanoid")) then
                    return nil, 0
                end
                current = current.Parent
            end
        end
        local accepted = (focus == "Tudo" and (door or glass or interaction))
            or (focus == "Portas e saídas" and door)
            or (focus == "Vidros e ponte" and glass)
            or (focus == "Interações" and interaction)
        if not accepted then return nil, 0 end
        if not matchesCommaFilter(searchable, settings.WorldFilter) then
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
                table.insert(candidates, {
                    Instance = instance,
                    Path = path,
                    Kind = kind,
                    Score = score,
                    Fingerprint = worldFingerprint(instance),
                })
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
        local fingerprints = {}
        local parentGroups = {}
        for _, entry in ipairs(candidates) do
            local fingerprint = fingerprints[entry.Fingerprint]
            if not fingerprint then
                fingerprint = { Count = 0, Samples = {}, Kind = entry.Kind }
                fingerprints[entry.Fingerprint] = fingerprint
            end
            fingerprint.Count = fingerprint.Count + 1
            if #fingerprint.Samples < 3 then table.insert(fingerprint.Samples, entry.Path) end

            local parentPath = entry.Instance.Parent and fullName(entry.Instance.Parent) or "sem pai"
            parentGroups[parentPath] = (parentGroups[parentPath] or 0) + 1
        end

        local fingerprintList = {}
        for signature, group in pairs(fingerprints) do
            table.insert(fingerprintList, { Signature = signature, Group = group })
        end
        table.sort(fingerprintList, function(a, b)
            if a.Group.Count == b.Group.Count then return a.Signature < b.Signature end
            return a.Group.Count > b.Group.Count
        end)
        local fingerprintIds = {}
        for index, item in ipairs(fingerprintList) do
            local id = string.format("G%03d", index)
            fingerprintIds[item.Signature] = id
            item.Id = id
        end

        local parentList = {}
        for path, count in pairs(parentGroups) do
            table.insert(parentList, { Path = path, Count = count })
        end
        table.sort(parentList, function(a, b)
            if a.Count == b.Count then return string.lower(a.Path) < string.lower(b.Path) end
            return a.Count > b.Count
        end)

        local lines = {
            sessionHeader("MAPA — " .. settings.WorldFocus),
            "",
            string.format("Filtro: %s", settings.WorldFilter ~= "" and settings.WorldFilter or "(nenhum)"),
            string.format("Candidatos: %d | exibindo: %d | assinaturas distintas: %d",
                #candidates, maximum, #fingerprintList),
            "",
        }
        if #fingerprintList > 0 then
            table.insert(lines, "GRUPOS DE ASSINATURA (mesmas propriedades e filhos diretos)")
            for index, item in ipairs(fingerprintList) do
                if index > 30 then
                    table.insert(lines, string.format("... +%d grupos omitidos neste resumo", #fingerprintList - 30))
                    break
                end
                table.insert(lines, string.format("  %s | quantidade=%d | tipo=%s",
                    item.Id, item.Group.Count, item.Group.Kind))
                for _, sample in ipairs(item.Group.Samples) do
                    table.insert(lines, "       exemplo: " .. sample)
                end
            end
            table.insert(lines, "")
        end
        if #parentList > 0 then
            table.insert(lines, "AGRUPAMENTO POR PAI/PAR")
            for index, item in ipairs(parentList) do
                if index > 30 then
                    table.insert(lines, string.format("... +%d pais omitidos neste resumo", #parentList - 30))
                    break
                end
                table.insert(lines, string.format("  quantidade=%d | %s", item.Count, item.Path))
            end
            table.insert(lines, "")
        end
        table.insert(lines, "DETALHES DOS CANDIDATOS")
        for index = 1, maximum do
            local entry = candidates[index]
            local siblingIndex, siblingCount = siblingPosition(entry.Instance)
            table.insert(lines, string.format("%03d. [%s] [%s] %s",
                index, entry.Kind, fingerprintIds[entry.Fingerprint] or "G???", entry.Path))
            table.insert(lines, "     " .. specialInstanceDetails(entry.Instance, settings.ReportDetail == "Detalhado"))
            table.insert(lines, string.format(
                "     contexto: pai=%s | irmãoOrdenado=%d/%d | modelo=%s | filhos=%d | descendentes=%d",
                entry.Instance.Parent and fullName(entry.Instance.Parent) or "nil",
                siblingIndex, siblingCount, nearestModelPath(entry.Instance),
                #directChildren(entry.Instance), descendantCount(entry.Instance)))
            table.insert(lines, "     sinaisDoPai: " .. containerSignalSummary(entry.Instance.Parent))
            table.insert(lines, "     filhosDiretos: " .. childSummary(entry.Instance, 16))
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

    local function isRemoteObject(instance)
        return instance:IsA("RemoteEvent") or instance:IsA("UnreliableRemoteEvent")
            or instance:IsA("RemoteFunction")
    end

    local function remoteRoots()
        if settings.RemoteScope == "ReplicatedStorage" then return { ReplicatedStorage } end
        if settings.RemoteScope == "Workspace" then return { Workspace } end
        local roots = { ReplicatedStorage, Workspace }
        local localPlayer = Players.LocalPlayer
        local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then table.insert(roots, playerGui) end
        return roots
    end

    local function remoteMatches(instance)
        local path = fullName(instance)
        local attributes = readAttributes(instance)
        local tags = readTags(instance)
        local searchable = path .. " " .. instance.ClassName .. " "
            .. table.concat(attributes, " ") .. " " .. table.concat(tags, " ")
        return matchesCommaFilter(searchable, settings.RemoteFilter)
    end

    local function scanRemotes(shouldPublish)
        local matches = {}
        local seen = {}
        local scanned = 0
        for _, root in ipairs(remoteRoots()) do
            for _, instance in ipairs(root:GetDescendants()) do
                scanned = scanned + 1
                if isRemoteObject(instance) and not seen[instance] and remoteMatches(instance) then
                    seen[instance] = true
                    table.insert(matches, instance)
                end
                if scanned % 1500 == 0 then task.wait() end
            end
        end
        table.sort(matches, function(a, b) return string.lower(fullName(a)) < string.lower(fullName(b)) end)

        local maximum = math.min(settings.MaxRemoteResults, #matches)
        local classCounts = {}
        for _, instance in ipairs(matches) do
            classCounts[instance.ClassName] = (classCounts[instance.ClassName] or 0) + 1
        end
        local lines = {
            sessionHeader("REMOTES — " .. settings.RemoteScope),
            "",
            "Filtro do caminho: " .. (settings.RemoteFilter ~= "" and settings.RemoteFilter or "(nenhum)"),
            string.format("Objetos lidos: %d | remotes: %d | exibindo: %d", scanned, #matches, maximum),
            "Observação: esta coleta não chama FireServer nem InvokeServer.",
            "",
        }
        for index = 1, maximum do
            local instance = matches[index]
            table.insert(lines, string.format("%03d. %s", index, fullName(instance)))
            table.insert(lines, "     " .. specialInstanceDetails(instance, true))
            table.insert(lines, "     pai: " .. containerSignalSummary(instance.Parent))
        end
        if maximum == 0 then table.insert(lines, "Nenhum remote corresponde ao filtro atual.") end
        if maximum < #matches then
            table.insert(lines, string.format("\n... %d remotes omitidos pelo limite.", #matches - maximum))
        end

        local countParts = {}
        for className, count in pairs(classCounts) do
            table.insert(countParts, className .. "=" .. tostring(count))
        end
        table.sort(countParts)
        local summary = string.format("%d remotes em %s | %s", #matches, settings.RemoteScope,
            #countParts > 0 and table.concat(countParts, ", ") or "nenhum")
        local report = table.concat(lines, "\n")
        lastRemoteReport = report
        update("remote_status", "Inventário de remotes concluído", summary)
        update("remote_report", "Prévia dos remotes", preview(report, 3000))
        if shouldPublish ~= false then publishReport(report, summary) end
        return report, summary
    end

    local function disconnectRemoteMonitor()
        remoteMonitoring = false
        for _, connection in ipairs(remoteConnections) do
            pcall(function() connection:Disconnect() end)
        end
        remoteConnections = {}
        monitoredRemotes = {}
    end

    local function buildRemoteLogReport()
        local lines = {
            sessionHeader("EVENTOS REMOTOS RECEBIDOS"),
            "",
            "Escopo: " .. settings.RemoteScope,
            "Filtro do caminho: " .. (settings.RemoteFilter ~= "" and settings.RemoteFilter or "(nenhum)"),
            "Filtro dos argumentos: " .. (settings.RemotePayloadFilter ~= "" and settings.RemotePayloadFilter or "(nenhum)"),
            string.format("Eventos recebidos: %d | registros preservados: %d | limite: %d",
                remoteReceivedTotal, #remoteLog, settings.MaxRemoteLog),
            "Somente OnClientEvent; nenhum remote foi disparado pelo H Inspect.",
            "",
            "CONTAGEM POR CAMINHO",
        }
        local counts = {}
        for path, count in pairs(remoteEventCounts) do
            table.insert(counts, { Path = path, Count = count })
        end
        table.sort(counts, function(a, b)
            if a.Count == b.Count then return a.Path < b.Path end
            return a.Count > b.Count
        end)
        if #counts == 0 then table.insert(lines, "  nenhum evento recebido") end
        for _, item in ipairs(counts) do
            table.insert(lines, string.format("  %d x %s", item.Count, item.Path))
        end
        table.insert(lines, "")
        table.insert(lines, "EVENTOS")
        if #remoteLog == 0 then table.insert(lines, "Nenhum evento recebido até agora.") end
        for index, entry in ipairs(remoteLog) do
            table.insert(lines, string.format("%03d. [%s] %s%s", index, entry.Time, entry.Path,
                entry.Repeat > 1 and (" | repetido=" .. tostring(entry.Repeat) .. "x") or ""))
            table.insert(lines, "     args(" .. tostring(entry.ArgumentCount) .. "): " .. entry.Arguments)
        end
        return table.concat(lines, "\n")
    end

    local function recordRemoteEvent(remote, ...)
        if not remoteMonitoring then return end
        local packed = table.pack(...)
        local arguments = {}
        for index = 1, packed.n do
            arguments[index] = string.format("[%d]=%s", index,
                formatRemoteArgument(packed[index], 0, {}))
        end
        local path = fullName(remote)
        local argumentText = packed.n > 0 and table.concat(arguments, " | ") or "(nenhum)"
        if not matchesCommaFilter(path .. " " .. argumentText, settings.RemotePayloadFilter) then return end
        remoteReceivedTotal = remoteReceivedTotal + 1
        remoteEventCounts[path] = (remoteEventCounts[path] or 0) + 1
        local now = os.clock()
        local lastEntry = remoteLog[#remoteLog]
        if lastEntry and lastEntry.Path == path and lastEntry.Arguments == argumentText
            and now - lastEntry.Clock <= 0.25 then
            lastEntry.Repeat = lastEntry.Repeat + 1
            lastEntry.Time = utcTimestamp()
            lastEntry.Clock = now
        else
            table.insert(remoteLog, {
                Time = utcTimestamp(),
                Clock = now,
                Path = path,
                ArgumentCount = packed.n,
                Arguments = argumentText,
                Repeat = 1,
            })
        end
        while #remoteLog > settings.MaxRemoteLog do table.remove(remoteLog, 1) end
        if now - lastRemoteUiUpdate >= 0.25 then
            lastRemoteUiUpdate = now
            update("remote_status", "Monitor passivo ativo",
                string.format("%d eventos | %d registros preservados | último: %s",
                    remoteReceivedTotal, #remoteLog, path))
            update("remote_report", "Prévia dos eventos recebidos", preview(buildRemoteLogReport(), 3000))
        end
    end

    local function monitorRemote(instance)
        if monitoredRemotes[instance] or not remoteMatches(instance) then return end
        if not (instance:IsA("RemoteEvent") or instance:IsA("UnreliableRemoteEvent")) then return end
        local ok, connection = pcall(function()
            return instance.OnClientEvent:Connect(function(...)
                recordRemoteEvent(instance, ...)
            end)
        end)
        if ok and connection then
            monitoredRemotes[instance] = true
            table.insert(remoteConnections, connection)
        end
    end

    local function startRemoteMonitor()
        disconnectRemoteMonitor()
        remoteMonitoring = true
        lastRemoteUiUpdate = 0
        local monitoredCount = 0
        for _, root in ipairs(remoteRoots()) do
            for _, instance in ipairs(root:GetDescendants()) do monitorRemote(instance) end
            local connection = root.DescendantAdded:Connect(function(instance)
                if remoteMonitoring and isRemoteObject(instance) then monitorRemote(instance) end
            end)
            table.insert(remoteConnections, connection)
        end
        for _ in pairs(monitoredRemotes) do monitoredCount = monitoredCount + 1 end
        update("remote_status", "Monitor passivo ativo",
            string.format("Observando %d RemoteEvents | caminho: %s | argumentos: %s", monitoredCount,
                settings.RemoteFilter ~= "" and settings.RemoteFilter or "todos",
                settings.RemotePayloadFilter ~= "" and settings.RemotePayloadFilter or "todos"))
        update("remote_report", "Prévia dos eventos recebidos", preview(buildRemoteLogReport(), 3000))
    end

    local function stopRemoteMonitor()
        disconnectRemoteMonitor()
        update("remote_status", "Monitor parado",
            string.format("%d eventos permanecem no histórico para cópia.", #remoteLog))
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

    local function copyWorldReport()
        copyText(lastWorldReport, "world_status",
            "Faça uma varredura do mapa antes de copiar.")
    end

    local function copyRemoteReport()
        copyText(lastRemoteReport, "remote_status",
            "Faça um inventário de remotes antes de copiar.")
    end

    local function copyRemoteLog()
        copyText(#remoteLog > 0 and buildRemoteLogReport() or "", "remote_status",
            "Inicie o monitor e aguarde eventos enviados pelo servidor.")
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
            or name == "SnapshotLimit" or name == "MaxRemoteResults"
            or name == "MaxRemoteLog" then
            settings[name] = tonumber(value) or settings[name]
        elseif name == "WorldFocus" or name == "ReportDetail" or name == "StructureScope"
            or name == "SnapshotScope" or name == "WorldFilter" or name == "GuiFilter"
            or name == "StructureFilter" or name == "SnapshotFilter"
            or name == "SelectedPlayer" or name == "RemoteScope"
            or name == "RemoteFilter" or name == "RemotePayloadFilter" then
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
        elseif name == "CopyWorldReport" then
            copyWorldReport()
        elseif name == "ScanStructure" then
            scanStructure(true)
        elseif name == "ScanRemotes" then
            scanRemotes(true)
        elseif name == "CopyRemoteReport" then
            copyRemoteReport()
        elseif name == "StartRemoteMonitor" then
            startRemoteMonitor()
        elseif name == "StopRemoteMonitor" then
            stopRemoteMonitor()
        elseif name == "CopyRemoteLog" then
            copyRemoteLog()
        elseif name == "ClearRemoteLog" then
            remoteLog = {}
            remoteEventCounts = {}
            remoteReceivedTotal = 0
            update("remote_status", remoteMonitoring and "Monitor passivo ativo" or "Histórico limpo",
                "Nenhum evento preservado.")
            update("remote_report", "Prévia dos remotes", "Caminhos e eventos recebidos aparecerão aqui.")
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
            lastRemoteReport = ""
            remoteLog = {}
            remoteEventCounts = {}
            remoteReceivedTotal = 0
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
            update("remote_status", remoteMonitoring and "Monitor passivo ativo" or "Monitor parado",
                "Faça o inventário ou inicie a observação passiva.")
            update("remote_report", "Prévia dos remotes", "Caminhos e eventos recebidos aparecerão aqui.")
            update("compare_status", "Snapshot A não salvo", "Escolha o escopo e salve uma base primeiro.")
            update("compare_report", "Prévia das diferenças", "Mudanças relevantes aparecerão aqui.")
        end

        if name == "LivePlayerScan" then startLivePlayerScan() end
    end

    function runtime:Destroy()
        if destroyed then return end
        destroyed = true
        liveGeneration = liveGeneration + 1
        disconnectRemoteMonitor()
        if _G.__HINSPECT_INSPECTOR_CLEANUP == cleanupFunction then
            _G.__HINSPECT_INSPECTOR_CLEANUP = nil
        end
    end

    cleanupFunction = function() runtime:Destroy() end
    _G.__HINSPECT_INSPECTOR_CLEANUP = cleanupFunction
    return runtime
end

return Inspector
end
-- END runtime/Inspector.lua

-- BEGIN runtime/MusicalChairs.lua
__modules["runtime/MusicalChairs.lua"] = function()
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
end
-- END runtime/MusicalChairs.lua

-- BEGIN runtime/Settings.lua
__modules["runtime/Settings.lua"] = function()
local Settings = {}

function Settings:Create()
    local runtime = {}
    local destroyed = false

    function runtime:Set(name, value)
        if destroyed then return end
        if name == "MenuTheme" and type(_G.__HINSPECT_SET_THEME) == "function" then
            _G.__HINSPECT_SET_THEME(tostring(value or "Default"))
        end
    end

    function runtime:Destroy()
        destroyed = true
    end

    return runtime
end

return Settings
end
-- END runtime/Settings.lua

local Bundle = {
    Version = tostring(rawget(_G, "__HINSPECT_RELEASE_VERSION") or "unknown"),
    ModuleCount = 21,
}

local function createImporter()
    local cache = {}
    local loaded = {}
    local loading = {}

    return function(path)
        if loaded[path] then return cache[path] end
        local factory = __modules[path]
        if type(factory) ~= "function" then
            error("Modulo nao incluido no bundle: " .. tostring(path), 0)
        end
        if loading[path] then
            error("Dependencia circular ao importar: " .. tostring(path), 0)
        end

        loading[path] = true
        local ok, result = pcall(factory)
        loading[path] = nil
        if not ok then
            error("Falha no modulo " .. tostring(path) .. ": " .. tostring(result), 0)
        end
        if result == nil then
            error("O modulo " .. tostring(path) .. " nao retornou um valor", 0)
        end

        cache[path] = result
        loaded[path] = true
        return result
    end
end

function Bundle:Validate()
    local import = createImporter()
    local schema = import("HInspectSchema.lua")
    local config = import("HInspectConfig.lua")
    schema.ValidateConfig(config)
    local categoryIds = {}
    local controlIds = {}
    local runtimePaths = {}
    for _, path in ipairs(config.CategoryModules) do
        schema.RequireModulePath(path, "Config.CategoryModules[]")
        local category = import(path)
        schema.ValidateCategory(category, path, categoryIds, controlIds)
        if category.RuntimeModule then runtimePaths[category.RuntimeModule] = true end
    end
    if not categoryIds[config.DefaultCategory] then
        error("DefaultCategory nao esta registrada: " .. tostring(config.DefaultCategory), 0)
    end
    local runtimeCount = 0
    for path in pairs(runtimePaths) do
        local runtimeModule = import(path)
        if type(runtimeModule) ~= "table" or type(runtimeModule.Create) ~= "function" then
            error(path .. " deve expor Create", 0)
        end
        runtimeCount = runtimeCount + 1
    end
    local controlCount = 0
    for _ in pairs(controlIds) do controlCount = controlCount + 1 end
    return { Categories = #config.CategoryModules, Controls = controlCount, Runtimes = runtimeCount }
end

function Bundle:Create(options)
    options = options or {}
    local resolvedOptions = {}
    for key, value in pairs(options) do resolvedOptions[key] = value end
    resolvedOptions.Import = createImporter()
    local menu = resolvedOptions.Import("HInspect.lua")
    if type(menu) ~= "table" or type(menu.Create) ~= "function" then
        error("HInspect.lua nao expoe uma funcao Create", 0)
    end
    return menu:Create(resolvedOptions)
end

return Bundle
