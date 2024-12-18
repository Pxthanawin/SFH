Configurations = string.gsub(Configurations, "[%s#*-]", "")

getgenv().config = {}
config.PurchaseRod = {}

local enabled = {
    "C$_100k/",
    {"PurchaseRod", "CarbonRod/", "NocturnalRod/", "SteadyRod/", "MagnetRod/", "RapidRod/", "AuroraRod/", "MythicalRod/", "TridentRod/", "KingsRod/", "DestinyRod/"}
}

for i, v in ipairs(enabled) do
    if type(v) == "table" then
        for ii, vv in ipairs(v) do
            if ii ~= 1 and string.match(Configurations, vv) then
                table.insert(config[v[1]], tostring(string.gsub(vv,"[/]","")))
            end
        end
    elseif type(v) == "string" then
        if string.match(Configurations, v) then
            config[string.gsub(v,"[/]","")] = true
        end
    end
end

if config["C$_100k"] then
    config.AutoFish = true
    config.AutoSell = true
    if not table.find(config.PurchaseRod, "SteadyRod") then
        table.insert(config.PurchaseRod, "SteadyRod")
    end
end

--

repeat task.wait() until game:IsLoaded()
if game.PlaceId == 4483381587 then return end

-- Variable zone

-- ---- Main Varieble

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ---- Other Variable

local playerName = LocalPlayer.Name
local userId = LocalPlayer.UserId

local AssetsLoaded

-- function

local function extractNumber(String)
    return tonumber((String:gsub("[^%d]", "")))
end

-- Main Script zone

-- ---- Assets Load

repeat

    local skip = PlayerGui:FindFirstChild("loading") and PlayerGui.loading:FindFirstChild("loading") and PlayerGui.loading.loading:FindFirstChild("skip")
    if skip and skip.Visible then

        if not skip.Selectable then
            skip.Selectable = true
        end

        GuiService.SelectedObject = skip
        task.wait(0.2)

        if GuiService.SelectedObject == skip then

            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
            task.wait()
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)

        end

        task.wait(0.1)
        GuiService.SelectedObject = nil

    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
    end
    task.wait()

until LocalPlayer:FindFirstChild("assetsloaded") and LocalPlayer:FindFirstChild("assetsloaded").Value

repeat
    task.wait()
until not game:GetService("Players").LocalPlayer.PlayerGui.loading:FindFirstChild("TitleMusic")

AssetsLoaded = true

local FpsPart = Instance.new("Part")
FpsPart.Name = "FPSBOOST"
FpsPart.Position = Vector3.new(0.9315884709358215, 138.69482421875, 0.6082026362419128)
FpsPart.Size = Vector3.new(30, 1, 30)
FpsPart.Color = Color3.fromRGB(0,0,0)
FpsPart.Anchored = true
FpsPart.CanCollide = false
FpsPart.Parent = workspace
FpsPart.Transparency = 0

local oxygen = LocalPlayer.Character.client:FindFirstChild("oxygen")
oxygen.Disabled = true

workspace.Gravity = 0

local function applySettings(object)
    if object:IsA("BasePart") then
        if object.Name == "FPSBOOST" then return end
        object.Transparency = 1
        object.CanCollide = false
        object.CanQuery = false
    end
end

local function recursiveIterate(parent)
    for _, object in pairs(parent:GetChildren()) do
        applySettings(object)
        recursiveIterate(object)
    end
end
recursiveIterate(workspace)

local destroyPlayer = function()
    for _, v in pairs(workspace:GetChildren()) do
        pcall(function()
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                local player = Players:GetPlayerFromCharacter(v)
                if player and player ~= LocalPlayer then
                    v:Destroy()
                    pcall(function()
                        player:Destroy()
                    end)
                end
            end
        end)
    end
end
destroyPlayer()
task.spawn(function()
    while task.wait(2) do
        destroyPlayer()
    end
end)

workspace.DescendantAdded:Connect(function(descendant)
    applySettings(descendant)
end)

-- Monitor Money Changes
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    if game.PlaceId == 4483381587 then return end
    task.wait(60)
    local countM = 0
    local money = LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("C$") and LocalPlayer.leaderstats["C$"].Value or 0

    while task.wait(1) do
        pcall(function()
            countM = countM + 1
            local currentMoney = LocalPlayer.leaderstats["C$"] and LocalPlayer.leaderstats["C$"].Value or 0
            if money ~= currentMoney then
                countM = 0
                money = currentMoney
            end
            if countM == 20 then
                LocalPlayer.Character.Humanoid:UnequipTools()
            end
            if countM >= 40 then
                local tpservice = game:GetService("TeleportService")
                game:Shutdown()
            end
        end)
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pxthanawin/SFH/main/ppmainf.lua"))()

-- --

pcall(function()

    local function OptimizeGamePerformance()

        local function optimizeObject(obj)
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.TopSurface = Enum.SurfaceType.Smooth
                    obj.BottomSurface = Enum.SurfaceType.Smooth
                    obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                    obj.Enabled = false
                elseif obj:IsA("Sound") then
                    obj:Stop()
                    obj.Volume = 0
                elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj.Enabled = false
                end
            end)
        end

        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 1e6
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.EnvironmentSpecularScale = 0
        Lighting.EnvironmentDiffuseScale = 0

        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
                effect.Enabled = false
            end
        end

        local Terrain = workspace:FindFirstChild("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            for _, child in ipairs(Terrain:GetChildren()) do
                optimizeObject(child)
            end
            Terrain.ChildAdded:Connect(optimizeObject)
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            optimizeObject(obj)
        end
        workspace.DescendantAdded:Connect(optimizeObject)

        for _, texture in ipairs(workspace:GetDescendants()) do
            if texture:IsA("Texture") or texture:IsA("Decal") then
                if not texture.Parent then
                    texture:Destroy()
                end
            end
        end

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        local PhysicsService = game:GetService("PhysicsService")
        if PhysicsService then
            pcall(function()
                PhysicsService.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
            end)
        else
            warn("PhysicsService not available.")
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.TextureID = ""
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            end
        end

    end

    OptimizeGamePerformance()

end)

if LocalPlayer and LocalPlayer.PlayerScripts then
    LocalPlayer.PlayerScripts.weather.Disabled = true
    LocalPlayer.PlayerScripts.windcontroller.Disabled = true
end

for _, v in pairs(workspace.Terrain:GetChildren()) do
    v:Destroy()
end

for _, v in pairs(game.Lighting:GetChildren()) do
    v:Destroy()
end


for _, v in pairs(ReplicatedStorage.resources.animations:GetChildren()) do
    if v:IsA("Animation") then
        v:Destroy()
    end
    for __, vv in pairs(v:GetDescendants()) do
        vv:Destroy()
    end
end
