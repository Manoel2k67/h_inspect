-- H Inspect public loader. No key, password or license validation.
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Manoel2k67/h_inspect/main/Loader.lua", true))()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local VERSION_PATH = "VERSION"
local BUNDLE_PATH = "dist/HInspect.bundle.lua"
local REPOSITORIES = {
    "https://raw.githubusercontent.com/Manoel2k67/h_inspect/main/",
    "https://cdn.jsdelivr.net/gh/Manoel2k67/h_inspect@main/",
}
local MAX_ATTEMPTS = 4
local RETRY_BASE_DELAY = 0.75
local CACHE_BUST = tostring(os.time())

local function payloadError(source, expectedPng)
    if type(source) ~= "string" or #source == 0 then return "resposta vazia" end
    if expectedPng then
        return string.sub(source, 1, 8) == "\137PNG\r\n\26\n" and nil or "imagem PNG inválida"
    end
    if string.sub(source, 1, 3) == "\239\187\191" then source = string.sub(source, 4) end
    local prefix = string.lower(string.sub(source, 1, 512))
    local firstCharacter = string.match(source, "^%s*(.)")
    if firstCharacter == "<" or string.find(prefix, "<!doctype", 1, true)
        or string.find(prefix, "<html", 1, true) then
        return "servidor retornou HTML em vez do arquivo esperado"
    end
    return nil, source
end

local function download(path, query)
    local lastError = "falha de rede desconhecida"
    for attempt = 1, MAX_ATTEMPTS do
        for _, repository in ipairs(REPOSITORIES) do
            local separator = string.find(path, "?", 1, true) and "&" or "?"
            local url = repository .. path .. separator .. (query or ("cacheBust=" .. CACHE_BUST))
            local ok, response = pcall(function() return game:HttpGet(url, true) end)
            if ok then
                local responseError, source = payloadError(response, false)
                if not responseError then return source, repository end
                lastError = responseError
            else
                lastError = tostring(response)
            end
        end
        if attempt < MAX_ATTEMPTS then task.wait(RETRY_BASE_DELAY * (2 ^ (attempt - 1))) end
    end
    error("não foi possível baixar " .. path .. ": " .. lastError, 0)
end

local function resolveGuiParent()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    local coreGuiOk = pcall(function() return CoreGui.Name end)
    if coreGuiOk then return CoreGui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

if type(loadstring) ~= "function" then
    error("este executor não disponibiliza loadstring", 0)
end

local versionSource = download(VERSION_PATH, "cacheBust=" .. CACHE_BUST)
local releaseVersion = versionSource:match("^%s*(%d+%.%d+%.%d+)%s*$")
if not releaseVersion then error("VERSION publicada é inválida", 0) end
_G.__HINSPECT_RELEASE_VERSION = releaseVersion

local bundleSource = download(BUNDLE_PATH,
    "v=" .. releaseVersion .. "&cacheBust=" .. CACHE_BUST)
local chunk, compileError = loadstring(bundleSource, "@HInspect/" .. BUNDLE_PATH)
if not chunk then error("bundle inválido: " .. tostring(compileError), 0) end

local bundleOk, bundle = pcall(chunk)
if not bundleOk then error("falha ao iniciar bundle: " .. tostring(bundle), 0) end
if type(bundle) ~= "table" or type(bundle.Create) ~= "function"
    or bundle.Version ~= releaseVersion then
    error("bundle publicado está desatualizado ou não expõe Create", 0)
end

print("[H Inspect] Abrindo v" .. releaseVersion .. "...")
return bundle:Create({
    Parent = resolveGuiParent(),
    AssetBaseUrls = REPOSITORIES,
    AssetVersion = releaseVersion,
})
