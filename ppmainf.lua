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

local SetNPC = {}

local zoneList = function(zone, sell)
    local datazone = {}
    if zone == "The Depths" then
        datazone = {
            pos = Vector3.new(841, -750, 1246),
            cam = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)
        }
        if sell then
            datazone.sell = workspace.world.npcs:FindFirstChild("Milo Merchant") and workspace.world.npcs["Milo Merchant"].merchant.sellall
        end
    elseif zone == "Vertigo" then
        datazone = {
            pos = Vector3.new(-121, -743, 1234),
            cam = CFrame.new(-124.090141, -719.073669, 1262.87964, 0.994196475, 0.0633590296, -0.0869422331, 0, 0.808168352, 0.588951588, 0.10757935, -0.585533619, 0.803478181),
        }
    elseif zone == "Isonade" then
        datazone = {
            pos = workspace.zones.fishing:FindFirstChild("Isonade") and workspace.zones.fishing.Isonade.Position,
            cam = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)
        }
    elseif zone == "Ancient Isle" then
        datazone = {
            pos = Vector3.new(5833, 124, 401),
            cam = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)
        }
        if sell then
            datazone.sell = workspace.world.npcs:FindFirstChild("Mann Merchant") and workspace.world.npcs["Mann Merchant"].merchant.sellall
        end
    end
    return datazone
end

local npcList = function(location, npcname, more)
    local datanpc = {}
    if location == "The Depths" then
        if npcname == "Merchant" then
            datanpc = {
                pos = Vector3.new(959.983887, -711.580261, 1262.43103),
                cframe = CFrame.new(959.983887, -711.580261, 1262.43103, -0.170621768, 1.00927435e-08, 0.985336602, 9.79065007e-08, 1, 6.71063694e-09, -0.985336602, 9.7615839e-08, -0.170621768),
                cam = CFrame.new(947.130798, -711.47113, 1262.57898, -0.0641093925, -0.115132757, -0.991279244, 0, 0.99332267, -0.11537008, 0.997942924, -0.00739630591, -0.0636813045)
            }
            if more then
                datanpc.npc = workspace.world.npcs:WaitForChild("Milo Merchant", math.huge)
            end
        end
    elseif location == "Ancient Isle" then
        if npcname == "Merchant" then
            datanpc = {
                pos = Vector3.new(6083.28369, 194.980133, 309.774139),
                cframe = CFrame.new(6083.28369, 194.980133, 309.774139, 0.295308411, 3.59556722e-08, 0.955401957, -2.01901749e-08, 1, -3.13934265e-08, -0.955401957, -1.00189901e-08, 0.295308411),
                cam = CFrame.new(6066.44531, 203.267548, 302.752106, -0.401562601, 0.329215497, -0.854613841, 0, 0.933156133, 0.359471679, 0.915831566, 0.14435038, -0.374720603)
            }
            if more then
                datanpc.npc = workspace.world.npcs:WaitForChild("Mann Merchant", math.huge)
            end
        end
    elseif location == "Sunstone Island" then
        if npcname == "Marlin" then
            datanpc = {
                pos = Vector3.new(-926.718994, 223.700012, -998.751404),
                cframe = CFrame.new(-926.718994, 223.700012, -998.751404, 0.0335294306, 8.36562108e-08, -0.999437749, -7.97742601e-08, 1, 8.10269825e-08, 0.999437749, 7.7012615e-08, 0.0335294306),
                cam = CFrame.new(-932.332153, 227.20462, -990.165649, 0.836995304, 0.104951933, -0.537051201, 0, 0.98143512, 0.191794604, 0.547210038, -0.160531178, 0.821456611)
            }
            if more then
                datanpc.npc = workspace.world.npcs:WaitForChild("Merlin", math.huge)
            end
        end
    end
    return datanpc
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


local setNPC = function(ZoneName, npcname)

    if SetNPC[(ZoneName..npcname)] then
        return
    end

    Character = LocalPlayer.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local npc = npcList(ZoneName, npcname)
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = npc.pos
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart

    npc = npcList(ZoneName, npcname, true)
    
    repeat task.wait() until (HumanoidRootPart.Position - npc.npc.HumanoidRootPart.Position).Magnitude <= 6

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = npc.cam
    HumanoidRootPart.CFrame = npc.cframe

    local Highlight = npc.npc:WaitForChild("Highlight", 10)
    local dialog = npc.npc:FindFirstChild("dialogprompt")

    if Highlight then
        if dialog then
            dialog.HoldDuration = 0
            dialog:InputHoldBegin()
            dialog:InputHoldEnd()
            bodyPosition:Destroy()
            camera.CameraType = Enum.CameraType.Custom
            SetNPC[(ZoneName..npcname)] = true
        end
    else
        game:Shutdown()
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

local enchantRod = function(RodName, value)

    if checkDayNight() == "Day" then return end

    if PlayerStats.Stats.rod.Value ~= RodName then
        if StatsRod:FindFirstChild(RodName) then
            LocalPlayer.Character.Humanoid:UnequipTools()
            ReplicatedStorage.events.equiprod:FireServer(RodName)
        else
            return
        end
    end

    Character.Humanoid:UnequipTools()
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
    camera.CFrame = CFrame.new(1310.2572, -765.473999, -89.2070618, -0.992915571, 0.117016889, -0.0206332784, 0, 0.173648536, 0.98480773, 0.118822068, 0.977830946, -0.172418341)

    local interactable = workspace.world.interactables:WaitForChild("Enchant Altar", 10)
    if not interactable then return end
    local ProximityPrompt = interactable.ProximityPrompt

    while StatsRod[RodName].Value ~= value and enctr[1].Value > 1 and checkDayNight() == "Night" and task.wait() do
        
        local Highlight = interactable:WaitForChild("Highlight", 60)
        if StatsRod[RodName].Value == value then
            bodyPosition:Destroy()
            return true
        end
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
                repeat task.wait() until not PlayerGui.over:FindFirstChild("prompt")
                GuiService.SelectedObject = nil
            end
        else
            bodyPosition:Destroy()
            return
        end

    end

    if StatsRod[RodName].Value == value then
        bodyPosition:Destroy()
        return true
    end
    bodyPosition:Destroy()
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

local equipRod = function(RodPriority)
    local rodNameCache = PlayerStats.Stats.rod.Value
    for _, v in ipairs(RodPriority) do
        if StatsRod:FindFirstChild(v) then
            if rodNameCache ~= v then
                ReplicatedStorage.events.equiprod:FireServer(v)
            end
            return
        end
    end
end

-- local moreFunction = function() end

-- Main auto Farm
local autoFish = function(zone)

    if (not SetNPC[(zone.."Merchant")]) and config.AutoSell then
        setNPC(zone, "Merchant")
    end

    zone = zoneList(zone, true)

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = zone.cam

    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = zone.pos
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart

    repeat task.wait() until (HumanoidRootPart.Position - zone.pos).Magnitude <= 1
    task.wait(0.2)

    Character.Torso.Anchored = true
    Character.Humanoid.Sit = true

    local RodPriority = {
        [1] = "Rod Of The Depths",
        [2] = "Aurora Rod",
        [3] = "Steady Rod"
    }

    while config.AutoFish and RunService.Heartbeat:Wait() do
        pcall(function()

            equipRod(RodPriority)

            local rod = Backpack:FindFirstChild(PlayerStats.Stats.rod.Value) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(PlayerStats.Stats.rod.Value))

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

                if config.AutoSell and zone.sell then
                    zone.sell:InvokeServer()
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
    task.spawn(autoFish("The Depths"))
end

--[[

task.spawn(function()
    local morefunction1
    while task.wait(1) do
        if StatsRod:FindFirstChild("Aurora Rod") and StatsRod["Aurora Rod"].Value ~= "Mutated" then
            local enctr = enctRelic()
            if enctr and enctr[1].Value > 6 then
                if checkDayNight() == "Night" then
                    morefunction1 = true
                end
                if not config.AutoFish then
                    if enchantRod("Aurora Rod", "Mutated") then
                        config.AutoFish = true
                        morefunction1 = false
                        task.spawn(autoFish("The Depths"))
                    else
                        config.AutoFish = true
                        morefunction1 = false
                        task.spawn(autoFish("The Depths"))
                    end
                end
            end
        end
        if morefunction1 then
            morefunction = true
        end
    end
end)]]
