Configurations = string.gsub(Configurations, "[%s#*-]", "")

getgenv().config = {}
config.PurchaseRod = {}
--getgenv().AutoFish = nil

local enabled = {
    "C$_100k/",
    "FarmLevel/",
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
    if not table.find(config.PurchaseRod, "SteadyRod") then
        table.insert(config.PurchaseRod, "SteadyRod")
    end
elseif config["FarmLevel"] then
    if not table.find(config.PurchaseRod, "SteadyRod") then
        table.insert(config.PurchaseRod, "SteadyRod")
    end
    if not table.find(config.PurchaseRod, "AuroraRod") then
        table.insert(config.PurchaseRod, "AuroraRod")
    end
end

--

repeat task.wait() until game:IsLoaded()

--setfpscap(15)

-- Variable zone

-- ---- Main Varieble

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local tpservice = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Monitor Money Changes
if not disablecheckafk then
    task.spawn(function()
        task.wait(100)
        local countM = 1
        local money

        while task.wait(1) do
            countM = countM + 1
            local currentMoney = money
            pcall(function()
                currentMoney = LocalPlayer.leaderstats["C$"] and LocalPlayer.leaderstats["C$"].Value
            end)
            if money ~= currentMoney then
                countM = 1
                money = currentMoney
            end
            if countM % 20 == 0 then
                if LocalPlayer.Character then
                    LocalPlayer.Character.Humanoid:UnequipTools()
                end
            end
            if countM >= 120 then
                if rejoin then
                    print(LocalPlayer.Name, "Rejoin")
                    tpservice:Teleport(16732694052, LocalPlayer)
                else
                    print(LocalPlayer.Name, "Shutdown")
                    game:Shutdown()
                end
            end
        end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local backgroundFrame = Instance.new("Frame")
backgroundFrame.Parent = screenGui
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
backgroundFrame.BorderSizePixel = 0

local textLabel = Instance.new("TextLabel")
textLabel.Parent = backgroundFrame
textLabel.Size = UDim2.new(0, 1000, 0, 250)
textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.Text = "00:00:00\n"..LocalPlayer.Name
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.BorderSizePixel = 0

local startTime = tick()

local function updateTime()
    local currentTime = tick() - startTime
    local hours = math.floor(currentTime / 3600)
    local minutes = math.floor((currentTime % 3600) / 60)
    local seconds = math.floor(currentTime % 60)

    textLabel.Text = string.format("%02d:%02d:%02d\n"..LocalPlayer.Name, hours, minutes, seconds)
end

task.spawn(function()
    while task.wait(0.25) do
        updateTime()
    end
end)

task.spawn(function()
    while task.wait(2) do
        RunService:Set3dRenderingEnabled(true)
        task.wait(0.05)
        RunService:Set3dRenderingEnabled(false)
    end
end)

-- ---- Other Variable

local playerName = LocalPlayer.Name
local userId = LocalPlayer.UserId

-- function

local function extractNumber(String)
    return tonumber((String:gsub("[^%d]", "")))
end

-- Main Script zone

-- ---- Assets Load

while not (LocalPlayer:FindFirstChild("assetsloaded") and LocalPlayer:FindFirstChild("assetsloaded").Value) do

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

end
--[[
repeat
    task.wait()
until not game:GetService("Players").LocalPlayer.PlayerGui.loading:FindFirstChild("TitleMusic")]]

task.wait(1)
for i = 1, math.random(2,4) do
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
    task.wait(math.random(1,50)/100)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
    task.wait(math.random(1,30)/10)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
    task.wait(math.random(1,50)/100)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, nil)
    task.wait(math.random(1,30)/10)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, nil)
end
task.wait(0.25)
getgenv().AssetsLoaded = true

ReplicatedStorage:WaitForChild("events"):WaitForChild("afk"):FireServer(false)
ReplicatedStorage:WaitForChild("events"):WaitForChild("afk"):Destroy()

local Character = LocalPlayer.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local FpsPart = Instance.new("Part")
FpsPart.Name = "FPSBOOST"
FpsPart.Position = Vector3.new(0.9315884709358215, 138.69482421875, 0.6082026362419128)
FpsPart.Size = Vector3.new(30, 1, 30)
FpsPart.Color = Color3.fromRGB(0,0,0)
FpsPart.Anchored = true
FpsPart.CanCollide = false
FpsPart.Parent = workspace
FpsPart.Transparency = 0


local humanoid = LocalPlayer.Character.Humanoid
humanoid.Sit = true

--workspace.Gravity = 30

local function applySettings(object)
    if object:IsA("BasePart") then
        if object.Name == "partt" then return end
        if object.Name == "FPSBOOST" then return end
        object.Transparency = 1
        --object.CanCollide = false
        object.CanQuery = false
    end
end

local newPart = function(y)
    local part = Instance.new("Part")
    part.Name = "partt"
    part.Position = HumanoidRootPart.Position - Vector3.new(0, y, 0)
    part.Size = Vector3.new(2, 1, 2)
    part.Anchored = true
    part.Parent = workspace
    part.Transparency = 1
end

task.spawn(function()
    repeat
        task.wait()
    until AssetsLoaded
    while task.wait(0.25) do
        local rpart = true
        for i, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and v.Name == "partt" then
                if humanoid.Sit then
                    if (v.Position - HumanoidRootPart.Position).Magnitude < 2 then
                        rpart = false
                        break
                    else
                        v:Destroy()
                    end
                else
                    if (v.Position - HumanoidRootPart.Position).Magnitude < 4 then
                        rpart = false
                        break
                    else
                        v:Destroy()
                    end
                end
            end
        end
        if rpart then
            if humanoid.Sit then
                newPart(1.4)
            else
                newPart(3.4)
            end
        end
    end
end)

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
        pcall(function()
            destroyPlayer()
        end)
    end
end)

workspace.DescendantAdded:Connect(function(descendant)
    applySettings(descendant)
end)

-- --

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

if LocalPlayer and LocalPlayer.PlayerScripts then
    if LocalPlayer.PlayerScripts:FindFirstChild("weather") then
        LocalPlayer.PlayerScripts.weather.Disabled = true
    end
end

for _, v in pairs(workspace.Terrain:GetChildren()) do
    v:Destroy()
end
--[[
for _, v in pairs(ReplicatedStorage.resources.animations:GetChildren()) do
    if v:IsA("Animation") then
        v:Destroy()
    end
    for __, vv in pairs(v:GetDescendants()) do
        vv:Destroy()
    end
end]]


local settings = {
    disableCamShake = true,
    willautosell_event = true,
    willautosell_exotic = true,
    willautosell_relic = false,
    willautosell_mythical = true,
    willautosell_legendary = true
}

local ChangeSetting = game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Settings/Update")
for settingName, settingValue in pairs(settings) do
    local args = {
        [1] = settingName,
        [2] = settingValue
    }
    ChangeSetting:FireServer(unpack(args))
end

local npclist = {
    ["Marlin"] = {
        pos = Vector3.new(-926.718994, 223.700012, -998.751404),
        cframe = CFrame.new(-926.718994, 223.700012, -998.751404, 0.0335294306, 8.36562108e-08, -0.999437749, -7.97742601e-08, 1, 8.10269825e-08, 0.999437749, 7.7012615e-08, 0.0335294306),
        cam = CFrame.new(-932.332153, 227.20462, -990.165649, 0.836995304, 0.104951933, -0.537051201, 0, 0.98143512, 0.191794604, 0.547210038, -0.160531178, 0.821456611)
    },
    ["Appraiser"] = {
        pos = Vector3.new(453.076996, 150.501022, 210.481934),
        cframe = CFrame.new(453.076996, 150.501022, 210.481934, -0.0841025636, 1.00578879e-08, 0.9964571, -4.54328983e-08, 1, -1.39282568e-08, -0.9964571, -4.64433363e-08, -0.0841025636),
        cam = CFrame.new(441.024414, 153.907944, 207.771103, -0.219435185, 0.148836121, -0.96420747, 0, 0.988295138, 0.152554303, 0.975627124, 0.0334757827, -0.216866717)
    },
    ["Jack Marrow"] = {
        pos = Vector3.new(-2831.02246, 215.351669, 1518.76208),
        cframe = CFrame.new(-2831.02246, 215.351669, 1518.76208, 0.667300344, -1.11774305e-08, -0.744788706, -6.68319666e-09, 1, -2.09953903e-08, 0.744788706, 1.89878016e-08, 0.667300344),
        cam = CFrame.new(-2829.26733, 224.575134, 1516.48926, -0.791481197, -0.572879732, 0.212993562, 0, 0.348487943, 0.937313318, -0.611193419, 0.741865873, -0.275821686)
    }
}

for i, v in pairs(npclist) do

    pcall(function()

        local npc = v
        HumanoidRootPart.CFrame = CFrame.new(npc.pos)

        task.wait(1)

        if i == "Marlin" and LocalPlayer.leaderstats.Level.Value >= 200 then
            npc.npc = workspace.world.npcs:WaitForChild("Merlin", 10)
        elseif i == "Appraiser" then
            npc.npc = workspace.world.npcs:WaitForChild("Appraiser", 10)
        elseif i == "Jack Marrow" then
            npc.npc = workspace.world.npcs:WaitForChild("Jack Marrow", 10)
        end

        local camera = workspace.Camera
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = npc.cam
        HumanoidRootPart.CFrame = npc.cframe
        task.wait(0.25)

        while not (PlayerGui.hud.safezone:FindFirstChild("options") or PlayerGui:FindFirstChild("options")) do
            HumanoidRootPart.CFrame = npc.cframe

            if not npc.npc then return end

            local Highlight = npc.npc:FindFirstChild("Highlight")
            local dialog = npc.npc:FindFirstChild("dialogprompt")

            if Highlight then
                if dialog then
                    dialog.HoldDuration = 0
                    dialog:InputHoldBegin()
                    dialog:InputHoldEnd()
                    task.wait()
                end
            end

            task.wait(0.5)
        end
        GuiService.SelectedObject = nil
        camera.CameraType = Enum.CameraType.Custom

    end)

end

local codelists = {
	"GOLDENTIDE",
    "NewYear",
    "FISCHMASDAY",
    "NorthernExpedition",
    "MERRYFISCHMAS"
}
for _, v in ipairs(codelists) do
    pcall(function()
        ReplicatedStorage.events.runcode:FireServer(v)
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pxthanawin/SFH/main/ppmainf.lua"))()
