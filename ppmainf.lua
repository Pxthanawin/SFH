local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")
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
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")

local PlayerStats = ReplicatedStorage.playerstats[LocalPlayer.Name]
local StatsRod = PlayerStats.Rods
local StatsInventory = PlayerStats.Inventory
local rodNameCache = PlayerStats.Stats.rod.Value

local AutoSell = true

local zonefish = Vector3.new(841, -750, 1246)

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

local function checkAurora()
    if ReplicatedStorage.world.weather.Value == "Aurora_Borealis" then
        return true
    end
end

local function checkLuck()
    if PlayerStats.Stats:FindFirstChild("status_luck") then
        return true
    end
end

local zonelist = {
    ["The Depths"] = Vector3.new(841, -750, 1246),
    ["Vertigo"] = Vector3.new(-121, -743, 1234),
    ["Ancient Isle"] = Vector3.new(5833, 125, 401),
    ["Sunstone Island"] = Vector3.new(-926.718994, 223.700012, -998.751404),
    ["Aurora Totem"] = Vector3.new(-1810.5636, -136.927948, -3282.44849),
    ["Rod Of The Depths"] = Vector3.new(1704.9292, -902.527039, 1450.42468),
    ["Enchant"] = Vector3.new(1311, -802.427063, -83),
    ["Moosewood"] = Vector3.new(453.076996, 150.501022, 210.481934)
}

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

local ListVartigoFish = {
    "The Depths Key",
    "Rubber Ducky",
    "Spiderfish",
    "Night Shrimp",
    "Twilight Eel",
    "Fangborn Gar",
    "Abyssacuda",
    "Voidfin Mahi"
}

local npcRemote = function(remote)
    local currentPos = HumanoidRootPart.Position
    if remote == "luck" then
        HumanoidRootPart.CFrame = CFrame.new(-926.718994, 223.700012, -998.751404)
        pcall(workspace.world.npcs:WaitForChild("Merlin", math.huge).Merlin.luck:InvokeServer())
        HumanoidRootPart.CFrame = CFrame.new(currentPos)
    elseif remote == "power" then
        HumanoidRootPart.CFrame = CFrame.new(-926.718994, 223.700012, -998.751404)
        pcall(workspace.world.npcs:WaitForChild("Merlin", math.huge).Merlin.luck:InvokeServer())
        HumanoidRootPart.CFrame = CFrame.new(currentPos)
    elseif remote == "Appraiser" then
        HumanoidRootPart.CFrame = CFrame.new(453.076996, 150.501022, 210.481934)
        pcall(workspace.world.npcs:WaitForChild("Appraiser", math.huge).appraiser.appraise:InvokeServer())
        HumanoidRootPart.CFrame = CFrame.new(currentPos)
    end
end

local interactableList = function(interacname, more)
    local datainterac = {}
    if interacname == "Sundial Totem" then
        datainterac = {
            pos = Vector3.new(-1150.93311, 134.499969, -1079.84131),
            cframe = CFrame.new(-1150.93311, 134.499969, -1079.84131, -0.896305919, -5.75794239e-08, -0.443436265, -3.43829925e-08, 1, -6.03508212e-08, 0.443436265, -3.88461316e-08, -0.896305919),
            cam = CFrame.new(-1148.46057, 136.514679, -1073.94812, 0.966715574, -0.117059469, 0.227504075, 0, 0.889196634, 0.457525373, -0.255853504, -0.442296892, 0.859600246),
            price = 2000
        }
        if more then
            datainterac.interac = workspace.world.interactables:WaitForChild("Sundial Totem", math.huge)
        end
    elseif interacname == "Aurora Totem" then
        datainterac = {
            pos = Vector3.new(-1810.5636, -136.927948, -3282.44849),
            cframe = CFrame.new(-1810.5636, -136.927948, -3282.44849, -0.820921123, -3.69710804e-08, -0.571041584, -3.08078718e-08, 1, -2.04542854e-08, 0.571041584, 8.01221478e-10, -0.820921123),
            cam = CFrame.new(-1813.31018, -130.086349, -3281.83008, -0.750986338, 0.650285959, -0.114663109, 0, 0.173648387, 0.98480773, 0.660317659, 0.739577174, -0.130407587),
            price = 500000
        }
        if more then
            datainterac.interac = workspace.world.interactables:WaitForChild("Aurora Totem", math.huge)
        end
    elseif interacname == "Crab Cage" then
        datainterac = {
            pos = Vector3.new(477.114136, 152.552109, 226.858932),
            cframe = CFrame.new(477.114136, 152.552109, 226.858932, -0.769669056, -2.87299997e-08, 0.638443053, 3.6466183e-08, 1, 8.89615634e-08, -0.638443053, 9.17525398e-08, -0.769669056),
            cam = CFrame.new(471.929352, 160.65332, 241.613632, 0.971649051, 0.163671121, -0.17061621, 0, 0.721641779, 0.692266703, 0.236427844, -0.672640264, 0.701182544),
            price = 45
        }
        if more then
            local Highlight
            repeat
                datainterac.interac = workspace.world.interactables:WaitForChild("Crab Cage", math.huge)
                for _, v in pairs(datainterac.interac:GetChildren()) do
                    if v:FindFirstChild("Highlight") then
                        Highlight = true
                        datainterac.interac = v
                    end
                end
            until task.wait() and Highlight
        end
    elseif interacname == "Rod Of The Depths" then
        datainterac = {
            pos = Vector3.new(1704.9292, -902.527039, 1450.42468),
            cframe = CFrame.new(1704.9292, -902.527039, 1450.42468, 0.995097816, -1.08760378e-08, -0.0988958851, 2.04235899e-08, 1, 9.55290673e-08, 0.0988958851, -9.70805729e-08, 0.995097816),
            cam = CFrame.new(1704.4585, -895.608765, 1434.77356, -0.999177396, 0.017578356, -0.0365453809, 0, 0.901170909, 0.433463901, 0.0405532196, 0.433107346, -0.900429606),
            price = 750000
        }
        if more then
            datainterac.interac = workspace.world.interactables:WaitForChild("Rod Of The Depths", math.huge)
        end
    end
    return datainterac
end

local setInterac = function(interacname, quantity)

    local currentPos = HumanoidRootPart.Position

    if not quantity then
        quantity = 1
    end

    Character = game.Players.LocalPlayer.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local interac = interactableList(interacname)
    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if interac.price and money < interac.price then
        return
    end
    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end

    HumanoidRootPart.CFrame = CFrame.new(interac.pos)

    interac = interactableList(interacname, true)

    repeat task.wait() until (HumanoidRootPart.Position - interac.pos).Magnitude <= 1

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = interac.cam
    HumanoidRootPart.CFrame = interac.cframe

    local purchaserompt = interac.interac:FindFirstChild("purchaserompt")
    task.wait(1)
    for i = 1, quantity do
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        if money > interac.price then
            local Highlight = interac.interac:WaitForChild("Highlight", math.huge)
            if Highlight then
                if purchaserompt then
                    purchaserompt.HoldDuration = 0
                    purchaserompt:InputHoldBegin()
                    purchaserompt:InputHoldEnd()
                    local button = PlayerGui.over:WaitForChild("prompt",10) and PlayerGui.over.prompt.confirm
                    if button then
                        GuiService.SelectedObject = button
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                        repeat task.wait() until not PlayerGui.over:FindFirstChild("prompt")
                        GuiService.SelectedObject = nil
                    end
                end
                task.wait(0.1)
            end
        end
    end
    camera.CameraType = Enum.CameraType.Custom
    HumanoidRootPart.CFrame = CFrame.new(currentPos)

end

--[[
local setFishZone = function(zone)
    if Torso.Anchored then
        Torso.Anchored = false
    end
    Character.Humanoid:UnequipTools()
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Position = zone
    bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
    bodyPosition.Parent = HumanoidRootPart
    repeat task.wait() until (HumanoidRootPart.Position - zone).Magnitude <= 1
    task.wait(0.5)
    Torso.Anchored = true
    Humanoid.Sit = true
    bodyPosition:Destroy()
    task.wait()
    Humanoid.Sit = false
end]]

local setFishZone = function(zone)
    if Torso.Anchored then
        if (HumanoidRootPart.Position - zone).Magnitude < 6 then
            return
        else
            Torso.Anchored = false
            task.wait(1)
        end
    end
    HumanoidRootPart.CFrame = CFrame.new(zone)
    task.wait(5)
    Torso.Anchored = true
end

local enctRelic = function(Mutation)
    for _,v in ipairs(StatsInventory:GetChildren()) do
        if v.Value == "Enchant Relic" then
            local mutation = v:FindFirstChild("Mutation") and v.Mutation.Value
            if mutation == Mutation then
                local equip
                for _, vv in ipairs(Backpack:GetChildren()) do
                    if vv.Name == "Enchant Relic" then
                        if tostring(vv.link.Value) == tostring(v.Name) then
                            equip = vv
                            break
                        end
                    end
                end
                return {stack = v.Stack.Value, equip = equip}
            end
        end
    end
end

local enchantRod = function(RodName, value)

    if StatsRod[RodName].Value == value then
        return
    end

    if checkDayNight() == "Day" then return end

    if not StatsRod:FindFirstChild(RodName) then
        return
    end

    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    local relic = enctRelic()
    if not relic then
        if money > 55000 then
            for i = 1, 5 do
                npcRemote("power")
            end
            relic = enctRelic()
        else
            return
        end
    end

    if PlayerStats.Stats.rod.Value ~= RodName then
        if StatsRod:FindFirstChild(RodName) then
            LocalPlayer.Character.Humanoid:UnequipTools()
            ReplicatedStorage.events.equiprod:FireServer(RodName)
        end
    end

    local pos = Vector3.new(1311, -802.427063, -83)
    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end
    HumanoidRootPart.CFrame = CFrame.new(pos)
    repeat task.wait() until (HumanoidRootPart.Position - pos).Magnitude <= 1

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(1310.2572, -765.473999, -89.2070618, -0.992915571, 0.117016889, -0.0206332784, 0, 0.173648536, 0.98480773, 0.118822068, 0.977830946, -0.172418341)

    local interactable = workspace.world.interactables:WaitForChild("Enchant Altar", math.huge)
    local ProximityPrompt = interactable.ProximityPrompt

    Character.Humanoid:EquipTool(relic.equip)
    while StatsRod[RodName].Value ~= value and relic.stack > 0 and checkDayNight() == "Night" and task.wait() do

        local Highlight = interactable:WaitForChild("Highlight", 60)
        if StatsRod[RodName].Value == value then
            return
        end
        if checkDayNight() == "Day" then
            return
        end
        if Highlight then
            if ProximityPrompt then
                ProximityPrompt.HoldDuration = 0
                ProximityPrompt:InputHoldBegin()
                ProximityPrompt:InputHoldEnd()
                local button = PlayerGui.over:WaitForChild("prompt",10) and PlayerGui.over.prompt.confirm
                if button then
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                    repeat task.wait() until not PlayerGui.over:FindFirstChild("prompt")
                    GuiService.SelectedObject = nil
                    relic.stack -= 1
                end
            end
        end

    end

    camera.CameraType = Enum.CameraType.Custom

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

local RodPriority = {
    [1] = "Rod Of The Depths",
    [2] = "Aurora Rod",
    [3] = "Steady Rod"
}

local checkVertigoFish = function()
    local fish = 9
    for _, v in pairs(PlayerStats.Bestiary:GetChildren()) do
        for _, vv in ipairs(ListVartigoFish) do
            if v.Name == vv then
                fish -= 1
            end
        end
        if v.Name == "Isonade" then
            fish -= 1
        end
    end
    if fish > 1 then
        return "Vertigo"
    elseif fish == 1 then
        return "Isonade"
    elseif fish == 0 then
        return "100%"
    end
end


local npcDepthsDoor = function()

    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end

    Character = LocalPlayer.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    HumanoidRootPart.CFrame = CFrame.new(23.8910046, -705.998718, 1250.59277, -0.0548401251, 6.33398187e-08, -0.998495162, 9.3198544e-08, 1, 5.83165551e-08, 0.998495162, -8.98602082e-08, -0.0548401251)

    repeat task.wait() until (HumanoidRootPart.Position - Vector3.new(23.8910046, -705.998718, 1250.59277)).Magnitude <= 1

    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(4.40501785, -698.242615, 1247.79309, -0.142213896, 0.299789965, -0.943345785, 0, 0.953032434, 0.302868336, 0.989835918, 0.0430720858, -0.135534465)
    HumanoidRootPart.CFrame = CFrame.new(23.8910046, -705.998718, 1250.59277, -0.0548401251, 6.33398187e-08, -0.998495162, 9.3198544e-08, 1, 5.83165551e-08, 0.998495162, -8.98602082e-08, -0.0548401251)

    repeat task.wait() until workspace.world.npcs.Custos:GetChildren()[15]
    local Highlight = workspace.world.npcs.Custos:GetChildren()[15]
    local dialog = workspace.world.npcs.Custos:FindFirstChild("dialogprompt")

    if Highlight then
        if dialog then
            dialog.HoldDuration = 0
            dialog:InputHoldBegin()
            dialog:InputHoldEnd()
            repeat
                local button = PlayerGui:WaitForChild("options",10) and PlayerGui.options.safezone["1option"].button
                if not button then
                    continue
                end
                GuiService.SelectedObject = button
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                repeat task.wait() until not PlayerGui:FindFirstChild("options")
                GuiService.SelectedObject = nil
            until PlayerStats.Cache:FindFirstChild("Door.TheDepthsGate")
        end
        camera.CameraType = Enum.CameraType.Custom
    end
    camera.CameraType = Enum.CameraType.Custom

end

local crabCage = function()
    Character.Humanoid:UnequipTools()
    if not Backpack:FindFirstChild("Crab Cage") then
        setInterac("Crab Cage", 3)
    end
    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end
    Humanoid.PlatformStand = false
    local pos = Vector3.new(-127.297638, -736.863892, 1234.20581)
    HumanoidRootPart.CFrame = CFrame.new(pos)
    repeat task.wait() until (HumanoidRootPart.Position - pos).Magnitude < 2
    HumanoidRootPart.CFrame = CFrame.new(pos)
    local camera = workspace.Camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(-139.568878, -720.290649, 1227.21326, -0.495092869, 0.634007037, -0.594069302, 0, 0.683749914, 0.729716539, 0.868840158, 0.361277461, -0.338519663)
    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Crab Cage"))
    task.wait(0.5)
    HumanoidRootPart.CFrame = CFrame.new(pos)
    Character:WaitForChild("Crab Cage").Deploy:FireServer(CFrame.new(-124.78862762451172, -737.0723876953125, 1234.0301513671875, -0.05541973561048508, -0, -0.9984631538391113, -0, 1, -0, 0.9984631538391113, 0, -0.05541973561048508))
    task.wait(0.5)
    Humanoid.PlatformStand = true
    camera.CameraType = Enum.CameraType.Custom
end

local autoRodOfTheDepths = function()

    if StatsRod:FindFirstChild("Rod Of The Depths") then return end

    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait() and money > 750000

    AutoSell = false

    if checkVertigoFish() == "Vertigo" then

        repeat

            if not PlayerStats.Bestiary:FindFirstChild("Night Shrimp") then
                if #(workspace.active.crabcages:GetChildren()) == 0 then
                    crabCage()
                else
                    local i = 0
                    for _, v in pairs(workspace.active.crabcages:GetChildren()) do
                        if (v.blocker.Position - Vector3.new(-124.78862762451172, -737.0723876953125, 1234.0301513671875)).Magnitude < 20 then
                            i += 1
                            break
                        end
                    end
                    if i == 0 then
                        crabCage()
                    end
                end
            end

            setFishZone(zonelist["Vertigo"])

            local crabcages = workspace.active.crabcages:FindFirstChild(LocalPlayer.Name)
            if not crabcages then
                continue
            end

            if crabcages:FindFirstChild("Highlight") then
                local prompt = crabcages:FindFirstChild("Prompt")
                if not prompt then continue end
                prompt.HoldDuration = 0
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
            end

        until task.wait(1) and checkVertigoFish() ~= "Vertigo"

    end

    if checkVertigoFish() == "Isonade" then

        repeat

            if not workspace.zones.fishing:FindFirstChild("Isonade") then
                setFishZone(zonelist["The Depths"])
            end

            repeat
                task.wait()
            until workspace.zones.fishing:FindFirstChild("Isonade")

            local pos = workspace.zones.fishing:FindFirstChild("Isonade") and workspace.zones.fishing.Isonade.Position
            if not pos then
                continue
            end

            local i = true
            for _, v in pairs(workspace.zones.fishing:GetChildren()) do
                if v.Name == "Isonade" then
                    if (v.Position - HumanoidRootPart.Position).Magnitude < 6 then
                        i = false
                        break
                    end
                end
            end
            if i then
                setFishZone(pos)
            end

        until task.wait() and checkVertigoFish() ~= "Isonade"

    end

    if not PlayerStats.Cache:FindFirstChild("Door.TheDepthsGate") then
        while not Backpack:FindFirstChild("The Depths Key") do
            setFishZone(zonelist["Vertigo"])
            task.wait(1)
        end
        task.wait(5)
        npcDepthsDoor()
    end

    AutoSell = true

    local setAbysHex = function(purchase)

        local abys = enctRelic("Abyssal")
        local hex = enctRelic("Hexed")
        if abys and hex then
            if purchase then
                if Torso.Anchored then
                    Torso.Anchored = false
                    task.wait(0.25)
                end
                HumanoidRootPart.CFrame = CFrame.new(Vector3.new(841, -750, 1246))
                task.wait(0.1)
                Character.Humanoid:EquipTool(hex.equip)
                task.wait(0.1)
                ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/ActivatorClientActive"):FireServer("Hexed")
                task.wait(0.1)
                Character.Humanoid:EquipTool(abys.equip)
                task.wait(0.1)
                ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/ActivatorClientActive"):FireServer("Abyssal")
                setInterac("Rod Of The Depths", 1)
            end

            return true
        end

    end

    if setAbysHex() then
        setAbysHex(true)
        return
    end

    money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if money < 850000 then
        setFishZone(zonelist["The Depths"])
    end

    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait(1) and money > 850000

    repeat

        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)

        local relic = enctRelic()
        if not relic then
            money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money > 805000 then
                for i = 1, 5 do
                    npcRemote("power")
                end
                relic = enctRelic()
            else
                setFishZone(zonelist["The Depths"])
                continue
            end
        end

        repeat
            relic = enctRelic()
            if not relic then
                break
            end
            Character.Humanoid:EquipTool(relic.equip)
            npcRemote("Appraiser")
            Character.Humanoid:UnequipTools()
            task.wait()
        until setAbysHex()

    until task.wait() and setAbysHex()

    money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if money < 750000 then
        setFishZone(zonelist["The Depths"])
    end
    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait(1) and money > 750000

    setAbysHex(true)
end

task.spawn(function()
    while RunService.Heartbeat:Wait() do

        if not Torso.Anchored then
            task.wait(0.5)
            continue
        end

        rodNameCache = PlayerStats.Stats.rod.Value

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

            if AutoSell then
                ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
            end

            LocalPlayer.Character.Humanoid:UnequipTools()

        else
            rod.events.cast:FireServer(100)
        end

    end
end)

if config["C$_100k"] then

    setFishZone(zonelist["The Depths"])

elseif config["FarmLevel"] then

    local viewportSize = Workspace.CurrentCamera.ViewportSize
    local x, y = 0, viewportSize.Y - 1
    while task.wait(1) do
        if StatsRod:FindFirstChild("Rod Of The Depths") then
            if not checkLuck() then
                for i = 1, 6 do
                    npcRemote("luck")
                end
            end
            if checkDayNight() == "Day" then
                Character.Humanoid:UnequipTools()
                if Torso.Anchored then
                    Torso.Anchored = false
                    task.wait(0.25)
                end
                if Backpack:FindFirstChild("Sundial Totem") then
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Sundial Totem"))
                else
                    setInterac("Sundial Totem", 5)
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Sundial Totem"))
                end
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
            end
            if not checkAurora() then
                Character.Humanoid:UnequipTools()
                if Torso.Anchored then
                    Torso.Anchored = false
                    task.wait(0.25)
                end
                if Backpack:FindFirstChild("Aurora Totem") then
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Aurora Totem"))
                else
                    setInterac("Aurora Totem", 5)
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Aurora Totem"))
                end
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
            end
        elseif StatsRod:FindFirstChild("Aurora Rod") then
            if not checkLuck() then
                for i = 1, 3 do
                    npcRemote("luck")
                end
            end
        elseif StatsRod:FindFirstChild("Steady Rod") then
            if not checkLuck() then
                npcRemote("luck")
            end
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") and StatsRod["Rod Of The Depths"].Value ~= "Clever" then
            enchantRod("Rod Of The Depths", "Clever")
        elseif StatsRod:FindFirstChild("Aurora Rod") and StatsRod["Aurora Rod"].Value ~= "Mutated" then
            --enchantRod("Aurora Rod", "Mutated")
        end

        local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        if (not StatsRod:FindFirstChild("Rod Of The Depths")) and money > 1100000 then
            autoRodOfTheDepths()
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") and money > 1000000 then
            purchaseRod("Mythical Rod", 110000)
            purchaseRod("Trident Rod", 150000)
            purchaseRod("Kings Rod", 120000)
            purchaseRod("Destiny Rod", 190000)
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") then
            setFishZone(zonelist["Ancient Isle"])
        else
            setFishZone(zonelist["The Depths"])
        end
    end
end

task.spawn(function()
    if config["FarmLevel"] then
        task.wait(300)
        while not StatsRod:FindFirstChild("Rod Of The Depths") do
            local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money > 1500000 then
                game:Shutdown()
            end
            task.wait(1)
        end
    end
end)
