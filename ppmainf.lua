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
local rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value

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

local function extractNumber(String)
    return tonumber((String:gsub("[^%d]", "")))
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

local equipRod = function(RodPriority)
    for _, v in ipairs(RodPriority) do
        if StatsRod:FindFirstChild(v) then
            if rodNameCache ~= v then
                Character.Humanoid:UnequipTools()
                RunService.Heartbeat:Wait()
                ReplicatedStorage.events.equiprod:FireServer(v)
                RunService.Heartbeat:Wait()
            end
            return
        end
    end
end


-- Main auto Fish
local autoFish = function()

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)

    local RodPriority = {
        [1] = "Rod Of The Depths",
        [2] = "Aurora Rod",
        [3] = "Steady Rod"
    }

    Character = LocalPlayer.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = Vector3.new(841, -750, 1246)
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart

    repeat task.wait() until (HumanoidRootPart.Position - Vector3.new(841, -750, 1246)).Magnitude <= 1

    Character.Torso.Anchored = true
    Character.Humanoid.Sit = true

    bodyPosition:Destroy()

    while config.AutoFish and RunService.Heartbeat:Wait() do

        rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value

        local rod = Backpack:FindFirstChild(rodNameCache) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(rodNameCache))

        if not rod then
            continue
        end

        if rod.Parent == Backpack then
            Character.Humanoid:EquipTool(rod)
            equipRod(RodPriority)
            continue
        end

        if rod:FindFirstChild("bobber") then

            local shakeUI = PlayerGui:WaitForChild("shakeui", 3)
            if not shakeUI then
                Character.Humanoid:UnequipTools()
                continue
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
                ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
            end

            LocalPlayer.Character.Humanoid:UnequipTools()

        else
            rod.events.cast:FireServer(100)
        end

    end
end

if config.AutoFish then
    task.spawn(autoFish)
end
