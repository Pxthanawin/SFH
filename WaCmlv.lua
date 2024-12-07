-- Configurations
-- getgenv().white_screen = true
-- getgenv().OptimizePerformance = true
-- getgenv().wait_time = 300


-- Script Initialization
repeat task.wait() until game:IsLoaded()

if getgenv().ScriptRunning then return end
getgenv().ScriptRunning = true

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

local RunService = game:GetService("RunService")

-- Handle White Screen Toggle
if getgenv().white_screen then
    RunService:Set3dRenderingEnabled(false)
end

graphicButton.MouseButton1Click:Connect(function()
    getgenv().white_screen = not getgenv().white_screen
    RunService:Set3dRenderingEnabled(not getgenv().white_screen)
end)

-- Monitor Money and Level Changes
task.spawn(function()
    local countM = 0
    local money = game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("C$") and game.Players.LocalPlayer.leaderstats["C$"].Value or 0

    -- local countL = 0
    -- local level = game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("Level") and game.Players.LocalPlayer.leaderstats.Level.Value or 0

    while task.wait(1) do
        countM += 1
        local currentMoney = game.Players.LocalPlayer.leaderstats["C$"] and game.Players.LocalPlayer.leaderstats["C$"].Value or 0
        if money ~= currentMoney then
            countM = 0
            money = currentMoney
        end
        if countM >= getgenv().wait_time then
            game:Shutdown()
        end

        --[[
        countL += 1
        local currentLevel = game.Players.LocalPlayer.leaderstats.Level and game.Players.LocalPlayer.leaderstats.Level.Value or 0
        if level ~= currentLevel then
            countL = 0
            level = currentLevel
        end
        if countL >= getgenv().wait_time then
            game:Shutdown()
        end]]
    end
end)

local function OptimizeGamePerformance()
    if not game:IsLoaded() then repeat wait() until game:IsLoaded() end

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
