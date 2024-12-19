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

local Character = LocalPlayer.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local PlayerStats = ReplicatedStorage.playerstats[LocalPlayer.Name]
local StatsRod = PlayerStats.Rods
local StatsInventory = PlayerStats.Inventory

local StartFarm

local ListRod = {
    ["CarbonRod"] = {"Carbon Rod", 2000},
    ["NocturnalRod"] = {"Nocturnal Rod", 11000},
    ["SteadyRod"] = {"Steady Rod", 7000},
    ["MagnetRod"] = {"Magnet Rod", 15000},
    ["RapidRod"] = {"Rapid Rod", 14000},
    ["AuroraRod"] = {"Aurora Rod", 90000},
    ["MythicalRod"] = {"Mythical Rod", 110000},
    ["TridentRod"] = {"Trident Rod", 150000},
    ["KingsRod"] = {"Kings Rod", 120000},
    ["DestinyRod"] = {"Destiny Rod", 190000}
}

local zoneList = function(ZoneName, LoadData)
    if ZoneName == "The Depths" then
        local DataZone = {
            Pos = Vector3.new(841, -750, 1246),
            Cam = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645),
            SellPos = Vector3.new(959.983887, -711.580261, 1262.43103),
            SellCFrame = CFrame.new(959.983887, -711.580261, 1262.43103, -0.170621768, 1.00927435e-08, 0.985336602, 9.79065007e-08, 1, 6.71063694e-09, -0.985336602, 9.7615839e-08, -0.170621768),
            SellCam = CFrame.new(947.130798, -711.47113, 1262.57898, -0.0641093925, -0.115132757, -0.991279244, 0, 0.99332267, -0.11537008, 0.997942924, -0.00739630591, -0.0636813045)
        }
        if LoadData then
            DataZone.npc = workspace.world.npcs:WaitForChild("Milo Merchant", math.huge)
            DataZone.npcpos = DataZone.npc.HumanoidRootPart.Position
        end
        return DataZone
    end
end

local function extractNumber(String)
    return tonumber((String:gsub("[^%d]", "")))
end

local Lighting = game:GetService("Lighting")

local function checkDayNight()
    local currentTime = Lighting.ClockTime
    if currentTime >= 6 and currentTime < 18 then
        return "Day"
    else
        return "Night"
    end
end


local setZone = function(ZoneName)

    if StartFarm then
        return
    end

    Character = LocalPlayer.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local zone = zoneList(ZoneName)
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = zone.SellPos
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart

    zone = zoneList(ZoneName, true)

    repeat task.wait() until (HumanoidRootPart.Position - zone.npcpos).Magnitude <= 6

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = zone.SellCam
    HumanoidRootPart.CFrame = zone.SellCFrame

    local Highlight = zone.npc:WaitForChild("Highlight", 10)
    local dialog = zone.npc:FindFirstChild("dialogprompt")

    if Highlight then
        if dialog then
            dialog.HoldDuration = 0
            dialog:InputHoldBegin()
            dialog:InputHoldEnd()
            bodyPosition:Destroy()
            StartFarm = true
        end
    else
        local tpservice = game:GetService("TeleportService")
        game:Shutdown()
    end

end


local enchantRod = function(RodName, value)

    if checkDayNight() == "Day" then return end

    if StatsRod[RodName].Value == value then
        return true
    end

    if PlayerStats.Stats.rod.Value ~= RodName then
        if StatsRod:FindFirstChild(RodName) then
            LocalPlayer.Character.Humanoid:UnequipTools()
            ReplicatedStorage.events.equiprod:FireServer(RodName)
        else
            return
        end
    end

    local enctRelic = function()
        for _, v in pairs(Backpack:GetChildren()) do
            if v.Name == "Enchant Relic" then
                if #StatsInventory[tostring(v.link.Value)]:GetChildren() == 2 then
                    return {StatsInventory[tostring(v.link.Value)].Stack, v}
                end
            end
        end
        return
    end

    local enctr = enctRelic()
    if not enctr then return end
    if enctr[1].Value < 6 then return end
    if enctr[2].Parent == Backpack then
        Character.Humanoid:EquipTool(enctr[2])
    end

    local pos = Vector3.new(1311, -802.427063, -83)
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = pos
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart
    repeat task.wait() until (HumanoidRootPart.Position - pos).Magnitude <= 1

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(1311.10535, -802.427063, -83.1130219, 0.20237419, 1.59500679e-08, 0.979308248, 3.0397711e-08, 1, -2.25687682e-08, -0.979308248, 3.43360682e-08, 0.20237419)

    local ProximityPrompt = workspace.world.interactables["Enchant Altar"].ProximityPrompt

    while StatsRod[RodName].Value == value and enctr[1].Value > 1 and checkDayNight() == "Night" and task.wait() do
        local Highlight = workspace.world.interactables["Enchant Altar"]:WaitForChild("Highlight", 10)
        if Highlight then
            if ProximityPrompt then
                ProximityPrompt.HoldDuration = 0
                ProximityPrompt:InputHoldBegin()
                ProximityPrompt:InputHoldEnd()
                local button = PlayerGui.over:WaitForChild("prompt",10) and PlayerGui.over.prompt.confirm
                if not button then return end
                GuiService.SelectedObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                task.wait()
                GuiService.SelectedObject = nil
            end
        else
            return
        end
    end

    if StatsRod[RodName].Value == value then
        return true
    end

    return

end


local purchaseRod = function(RodName, Price)
    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if StatsRod:FindFirstChild(RodName) then
        return
    elseif Price <= money then 
        ReplicatedStorage.events.purchase:FireServer(RodName, "Rod", 1)
        return
    else
        return true
    end
end
task.spawn(function()
    local List = config.PurchaseRod
    while #List > 0 do
        local newList = {}
        for i, v in ipairs(List) do
            if purchaseRod(ListRod[v][1], ListRod[v][2]) then
                table.insert(newList, v)
            end
        end
        List = newList
        task.wait(4)
    end
end)

local morefunction

-- Main auto Fish
local autoFish = function()
    local zone = "The Depths"

    if not StartFarm then
        setZone(zone)
    end

    zone = zoneList(zone, true)

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = zone.Cam

    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = zone.Pos
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart

    repeat task.wait() until (HumanoidRootPart.Position - zone.Pos).Magnitude <= 1
    task.wait(0.2)

    Character.Torso.Anchored = true
    Character.Humanoid.Sit = true

    while config.AutoFish and RunService.Heartbeat:Wait() do
        pcall(function()
            local rodNameCache = PlayerStats.Stats.rod.Value

            if morefunction then
                config.AutoFish = false
                return
            end

            if rodNameCache ~= "Aurora Rod" then
                if StatsRod:FindFirstChild("Aurora Rod") then
                    ReplicatedStorage.events.equiprod.FireServer("Aurora Rod")
                    return
                end
            end

            local rod = Backpack:FindFirstChild(rodNameCache) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(rodNameCache))
    
            if not rod then
                return
            end
    
            if rod.Parent == Backpack then
                Character.Humanoid:EquipTool(rod)
            end
    
            if rod:FindFirstChild("bobber") then

                local shakeUI = PlayerGui:WaitForChild("shakeui", 3)
                if not shakeUI then
                    Character.Humanoid:UnequipTools()
                    return
                end

                while PlayerGui:FindFirstChild("shakeui") do
                    local button = shakeUI.safezone:FindFirstChild("button")
                    if button then
                        button.Size = UDim2.new(1001, 0, 1001, 0)
                        VirtualUser:Button1Down(Vector2.new(1, 1))
                        VirtualUser:Button1Up(Vector2.new(1, 1))
                    end
                    RunService.Heartbeat:Wait()
                end

                repeat
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    RunService.Heartbeat:Wait()
                until not rod.values.bite.Value

                if config.AutoSell then
                    zone.npc.merchant.sellall:InvokeServer()
                end

                LocalPlayer.Character.Humanoid:UnequipTools()

            else
                rod.events.cast:FireServer(100)
            end
        end)
    end

    camera.CameraType = Enum.CameraType.Custom
    Character.Torso.Anchored = false
    Character.Humanoid.Sit = false
    bodyPosition:Destroy()
end

if config.AutoFish then
    task.spawn(autoFish)
end

task.spawn(function()
    while task.wait(1) do
        if StatsRod:FindFirstChild("Aurora Rod") and StatsRod["Aurora Rod"].Value ~= "Mutated" then
            if checkDayNight() == "Night" then
                morefunction1 = true
            end
            if not config.AutoFish then
                if enchantRod("Aurora Rod", "Mutated") then
                    config.AutoFish = true
                    morefunction1 = false
                    task.spawn(autoFish)
                end
            end
        end
        if morefunction1 then
            morefunction = true
        end
    end
end)
