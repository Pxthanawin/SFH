
--[[
getgenv().Sell_Every = 120
getgenv().OptimizePerformance = true
]]

local Config = {
    ["Farm Fish"] = true,
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local rodNameCache = nil

-- local oxygen = LocalPlayer.Character.client:FindFirstChild("oxygen")
-- oxygen.Disabled = true

-- game.Workspace.Gravity = 0

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

getgenv().ScriptRunning = true


task.spawn(function()

        repeat task.wait() until getgenv().ScriptRunning

    local function disconnectPlayer(player)
        if player == LocalPlayer then
            return
        end
        local character = player.Character or player.CharacterAdded:Wait()
        if character and Workspace:FindFirstChild(character.Name) then
            character:Destroy()
        end
        player.Parent = nil
    end

    while task.wait(1) do
            pcall(function()
        for i, player in next, game:GetService("Players"):GetPlayers() do
            pcall(function()
                disconnectPlayer(player)
            end)
        end
                end)
    end

end)


-- รายการการตั้งค่าที่ต้องการเปลี่ยน
local settings = {
    disableCamShake = true,
    willautosell_event = true,
    willautosell_exotic = true,
    willautosell_relic = false,
    willautosell_mythical = true,
    willautosell_legendary = true
}

-- ส่งคำสั่งเปลี่ยนการตั้งค่าทีละรายการ
local ChangeSetting = game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.menu.menu_safezone:FindFirstChild("ChangeSetting")
for settingName, settingValue in pairs(settings) do
    local args = {
        [1] = settingName,
        [2] = settingValue
    }
    pcall(function()
        ChangeSetting:FireServer(unpack(args))
    end)
end


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
            task.wait()
            rod.events.cast:FireServer(100)
            --  enableMetaReset(rod.events:FindFirstChild("reset"))
            task.wait(0.4)
        end
    end
end

local targetPosition = Vector3.new(893.439453, -772.387634, 975.62616)
local targetCFrame = CFrame.new(893.439453, -772.387634, 975.62616, -0.610115349, 0.0653887317, 0.78960973, 0.0176754892, 0.997463942, -0.0689439476, -0.79211539, -0.0281070229, -0.609723866)
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
            
        task.wait(2)
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
        task.wait(2)
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
        task.wait(2)
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame

        for i = 1, 2 do
                pcall(function()

            local camera = workspace.Camera
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = CFrame.new(889.485229, -761.570251, 971.296448, -0.72676146, 0.580407798, -0.367348105, -1.49011612e-08, 0.534799099, 0.844979286, 0.686890006, 0.61409837, -0.388671309)

            local MiloMerchant = workspace.world.npcs:FindFirstChild("Milo Merchant")
            if MiloMerchant then
                MiloMerchant.HumanoidRootPart.CFrame = targetCFrame*CFrame.new(0, 4, 0)

                local dialogPrompt = MiloMerchant:FindFirstChild("dialogprompt")
                if dialogPrompt then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.ButtonX, false, nil)
                    task.wait()
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.ButtonX, false, nil)
                end
            end

            task.wait()

            local options = PlayerGui:WaitForChild("options", math.huge)

            local safezone = options:FindFirstChild("safezone")
            if safezone then
                local option2 = safezone:FindFirstChild("2option")
                if option2 then
                    local button = option2:FindFirstChild("button")
                    if button then
                        GuiService.SelectedObject = button
                        task.wait()

                        if GuiService.SelectedObject == button then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                            task.wait()
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                        end
                    end
                end
            end
        
            task.wait()
            GuiService.SelectedObject = nil
                        end)
    
        end
            task.wait(1)
            
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
    while getgenv().Sell_Every do
        task.wait(getgenv().Sell_Every)
        workspace.world.npcs["Milo Merchant"].merchant.sellall:InvokeServer()
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
        if countM == 20 then
            LocalPlayer.Character.Humanoid:UnequipTools()
        end
        if countM >= 40 then
            game:Shutdown()
        end
    end
end)

-- 

-- 

pcall(function()

    -- ฟังก์ชันหลักในการปรับแต่งประสิทธิภาพ
    local function OptimizeGamePerformance()

        -- ฟังก์ชันหลักในการปรับแต่งวัตถุ
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
                PhysicsService.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
            end)
        else
            warn("PhysicsService not available.")
        end

        -- ลดการใช้งาน MeshParts และ Special Meshes
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.TextureID = ""
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            end
        end

        -- ปิดการใช้งานการสร้างวัตถุใหม่ที่ไม่จำเป็น
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
                elseif k == "TopSurface" or k == "BottomSurface" then
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
    end

    -- เรียกใช้ฟังก์ชัน
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
    for __, vv in pairs(v:GetDescendants()) do -- ใช้ GetDescendants() แทน GetChildren()
        vv:Destroy()
    end
end

ReplicatedStorage.modules.fx:Destroy()
