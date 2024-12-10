--[[
getgenv().Sell_Every = 120
getgenv().white_screen = true
getgenv().OptimizePerformance = true
]]

local Config = {
    ["Farm Fish"] = true,
}

repeat task.wait() until game:IsLoaded()
repeat
    task.wait()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true,"LeftControl",false,game)
    VirtualInputManager:SendKeyEvent(false,"LeftControl",false,game)
until not game:GetService("Players").LocalPlayer.PlayerGui.loading:FindFirstChild("TitleMusic")
getgenv().ScriptRunning = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")

local rodNameCache = nil

-- local oxygen = LocalPlayer.Character.client:FindFirstChild("oxygen")
-- oxygen.Disabled = true

-- game.Workspace.Gravity = 0

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

task.spawn(function()
    repeat task.wait() until getgenv().ScriptRunning
    task.wait(1)
    humanoid.Sit = true
    humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if not humanoid.Sit then
            humanoid.Sit = true -- บังคับให้นั่ง
        end
    end)
end)

-- Auto click function optimized
local function autoClickButton()
    local shakeUI = PlayerGui:FindFirstChild("shakeui")
    if not shakeUI then return end

    local button = shakeUI.safezone and shakeUI.safezone:FindFirstChild("button")
    if button then
        button.Size = UDim2.new(1001, 0, 1001, 0)
        VirtualUser:Button1Down(Vector2.new(1, 1))
        VirtualUser:Button1Up(Vector2.new(1, 1))
    end
end

--[[
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

local function enableMetaReset(resetEvent)
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "FireServer" and self == resetEvent then
            return
        end
        return oldNamecall(self, ...)
    end

    setreadonly(mt, true)
end

local function disableMetaReset()
    setreadonly(mt, false)
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end
]]

-- ฟังก์ชันสำหรับส่งคำขอซื้อไอเท็ม
local StatsRod = ReplicatedStorage.playerstats[LocalPlayer.Name].Rods
local function purchaseItem(itemName, itemType, quantity)
    repeat task.wait() until getgenv().ScriptRunning
    while not StatsRod:FindFirstChild(itemName) do
        ReplicatedStorage.events.purchase:FireServer(itemName, itemType, quantity)
        task.wait(1)
    end
end

local equiprod = ReplicatedStorage:WaitForChild("events"):WaitForChild("equiprod")
local function EquipRod()
    repeat task.wait() until getgenv().ScriptRunning
    while rodNameCache ~= "Steady Rod" do
        if StatsRod:FindFirstChild("Steady Rod") then
            if rodNameCache ~= "Steady Rod" then
                equiprod:FireServer("Steady Rod")
                rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
            end
        end
        task.wait(1)
    end
end

-- Main fishing function optimized
local function farmFish()
    repeat task.wait() until getgenv().StartFarm
    task.wait(1)
    while Config["Farm Fish"] do
        -- Cache rodName to avoid repeated lookups

        rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value

        local rod = Backpack:FindFirstChild(rodNameCache) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(rodNameCache))

        if not rod then
            RunService.Heartbeat:Wait() -- Shorter wait than task.wait()
            return
        end

        if rod.Parent == Backpack then
            LocalPlayer.Character.Humanoid:EquipTool(rod)
        end

        if rod:FindFirstChild("bobber") then
            -- wait(0.1)
            --if rod.bobber.BobberWeld.Enabled then
                --wait(0.2)
                --rod.bobber.BobberWeld.Enabled = false
            --end
            -- rod.bobber.CanCollide = false
            -- task.wait(0.1)
            -- rod.bobber.Anchored = true
            while Config["Farm Fish"] and rod:FindFirstChild("bobber") do
                pcall(function()
                    if rod.values.bite.Value then
                        ReplicatedStorage.events.reelfinished:FireServer(100, true)
                        task.wait() -- Reduced delay
                    else
                        autoClickButton()
                        RunService.Heartbeat:Wait() -- Smoother frame sync
                    end
                end)
            end
        else
            --disableMetaReset()
            LocalPlayer.Character.Humanoid:UnequipTools()
            task.wait(0.1)
            LocalPlayer.Character.Humanoid:EquipTool(rod)
            task.wait()
            rod.events.cast:FireServer(100)
            --  enableMetaReset(rod.events:FindFirstChild("reset"))
            task.wait(0.4)
        end
    end
end

local targetPosition = Vector3.new(893.679871, -772.342407, 977.9375)
local targetCFrame = CFrame.new(893.679871, -772.342407, 977.9375, -0.467594326, 0.0559145212, 0.882172942, 0.00594715448, 0.998173773, -0.0601146892, -0.883923173, -0.0228628702, -0.467072934)
local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
local currentPosition = humanoidRootPart.Position
local Distance = (targetPosition - currentPosition).Magnitude
local tweenpos = function()
    getgenv().StartFarm = false
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false -- ปิดการชน
        end
    end

    local Speed
    if Distance >= 1000 then
        Speed = 500
    else
        Speed = 25
    end

    local tweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})

    tween.Completed:Connect(function()
        getgenv().StartFarm = true
    end)
    tween:Play()
end

task.spawn(function()
    repeat task.wait() until getgenv().ScriptRunning
    task.wait(1)
    humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    currentPosition = humanoidRootPart.Position
    Distance = (targetPosition - currentPosition).Magnitude
    tweenpos()
    while task.wait(1) do
        pcall(function()
            repeat task.wait() until getgenv().StartFarm
            humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
            currentPosition = humanoidRootPart.Position
            Distance = (targetPosition - currentPosition).Magnitude
            if Distance >= 400 then
                tweenpos()
                return
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            end
        end)
    end
end)

-- Spawn the fishing loop
task.spawn(farmFish)
task.spawn(function()
    purchaseItem("Steady Rod", "Rod", 1)
end)
task.spawn(EquipRod)

task.spawn(function()
    repeat task.wait() until getgenv().StartFarm
    task.wait(10)
    while getgenv().Sell_Every do
        pcall(function()
            workspace.world.npcs["Milo Merchant"].HumanoidRootPart.CFrame = targetCFrame*CFrame.new(0,7,0)
            task.wait(getgenv().Sell_Every)
            workspace.world.npcs["Milo Merchant"].merchant.sellall:InvokeServer()
        end)
    end
end)

-- Monitor Money Changes
task.spawn(function()
    repeat task.wait() until getgenv().StartFarm
    task.wait(20)
    local countM = 0
    local money = LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("C$") and LocalPlayer.leaderstats["C$"].Value or 0

    while task.wait(1) do
        countM += 1
        local currentMoney = LocalPlayer.leaderstats["C$"] and LocalPlayer.leaderstats["C$"].Value or 0
        if money ~= currentMoney then
            countM = 0
            money = currentMoney
        end
        if countM >= 30 then
            game:Shutdown()
        end
    end
end)

-- 

local function OptimizeGamePerformance()

    -- ฟังก์ชันหลักในการปรับแต่งวัตถุ
    local function optimizeObject(obj)
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.TopSurface = Enum.SurfaceType.Smooth
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

    -- ปรับแต่ง Lighting
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

    -- ปรับแต่ง Terrain
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

    -- Hook ระบบเพื่อลดการสร้างข้อมูลที่ไม่จำเป็น (ถ้ามี)
    if hookfunction and setreadonly then
        local mt = getrawmetatable(game)
        local old = mt.__newindex
        setreadonly(mt, false)
        local sda
        sda = hookfunction(old, function(t, k, v)
            if k == "Material" then
                if v ~= Enum.Material.Neon and v ~= Enum.Material.Plastic and v ~= Enum.Material.ForceField then
                    v = Enum.Material.Plastic
                end
            elseif k == "TopSurface" then
                v = "Smooth"
            elseif k == "Reflectance" or k == "WaterWaveSize" or k == "WaterWaveSpeed" or k == "WaterReflectance" then
                v = 0
            elseif k == "WaterTransparency" then
                v = 1
            elseif k == "GlobalShadows" then
                v = false
            end
            return sda(t, k, v)
        end)
        setreadonly(mt, true)
    end

    -- ปรับแต่งวัตถุทั้งหมดใน Workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        optimizeObject(obj)
    end
    workspace.DescendantAdded:Connect(optimizeObject)

    -- ลบ Decals และ Textures ที่ไม่ได้ใช้งาน
    for _, texture in ipairs(workspace:GetDescendants()) do
        if texture:IsA("Texture") or texture:IsA("Decal") then
            if not texture.Parent then
                texture:Destroy()
            end
        end
    end

    -- ลดคุณภาพการเรนเดอร์
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- ลดฟิสิกส์ในเกม
    local PhysicsService = game:GetService("PhysicsService")
    if PhysicsService then
        pcall(function()
            PhysicsService.PhysicsEnvironmentalThrottle = nil
        end)
    else
        warn("PhysicsService not available.")
    end

    -- ล้างหน่วยความจำ
    game:GetService("Debris"):ClearAllChildren()
end

-- เรียกใช้ฟังก์ชัน
if getgenv().OptimizePerformance then
    OptimizeGamePerformance()
end

-- 

-- Create White Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CircularButtons"
screenGui.Parent = game:GetService("CoreGui") -- เปลี่ยน Parent เป็น CoreGui

local function createCircularButton(name, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 40, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 0.5
    button.Text = name
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.Font = Enum.Font.SourceSans
    button.TextScaled = true
    button.BorderSizePixel = 0

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = button

    button.Parent = parent
    return button
end

local graphicButton = createCircularButton("G", UDim2.new(0.85, 0, 0.3, 0), screenGui)

-- Handle White Screen Toggle
if getgenv().white_screen then
    RunService:Set3dRenderingEnabled(false)
end

graphicButton.MouseButton1Click:Connect(function()
    getgenv().white_screen = not getgenv().white_screen
    RunService:Set3dRenderingEnabled(not getgenv().white_screen)
end)
