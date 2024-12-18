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

local StatsRod = ReplicatedStorage.playerstats[LocalPlayer.Name].Rods

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
    local Highlight = zone.npc:WaitForChild("Highlight", 10)
    local dialog = zone.npc:FindFirstChild("dialogprompt")

    repeat task.wait() until (HumanoidRootPart.Position - zone.npc.HumanoidRootPart.Position).Magnitude <= 6

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = zone.SellCam
    HumanoidRootPart.CFrame = zone.SellCFrame
    task.wait(0.3)

    if Highlight then
        if dialog then
            dialog.HoldDuration = 0
            dialog:InputHoldBegin()
            dialog:InputHoldEnd()
            bodyPosition:Destroy()

            local newPart = Instance.new("Part")
            newPart.Name = "FPSBOOST"
            newPart.Position = Vector3.new(0.9315884709358215, 138.69482421875, 0.6082026362419128)
            newPart.Size = Vector3.new(30, 1, 30)
            newPart.Color = Color3.fromRGB(0,0,0)
            newPart.Anchored = true
            newPart.CanCollide = false
            newPart.Parent = workspace
            newPart.Transparency = 0

            StartFarm = true
        end
    else
        local tpservice = game:GetService("TeleportService")
        game:Shutdown()
    end

end


local purchaseRod = function(RodName, Price)
    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if StatsRod:FindFirstChild(RodName) then
        return false
    elseif Price <= money then 
        ReplicatedStorage.events.purchase:FireServer(RodName, "Rod", 1)
        return false
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



-- Main auto Fish
local autoFish = function()
    local zone = "The Depths"
    setZone(zone)
    repeat task.wait() until StartFarm

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

    local rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value

    pcall(function()
        if StatsRod:FindFirstChild("Steady Rod") then
            if rodNameCache ~= "Steady Rod" then
                ReplicatedStorage:WaitForChild("events"):WaitForChild("equiprod"):FireServer("Steady Rod")
                RunService.Heartbeat:Wait()
            end
        end
    end)

    while config.AutoFish do
        pcall(function()
            rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
            local rod = Backpack:FindFirstChild(rodNameCache) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(rodNameCache))
    
            if not rod then
                RunService.Heartbeat:Wait()
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

            else
                rod.events.cast:FireServer(100)
                RunService.Heartbeat:Wait()
            end
        end)
    end

    camera.CameraType = Enum.CameraType.Custom
    bodyPosition:Destroy()
end

task.spawn(autoFish)
