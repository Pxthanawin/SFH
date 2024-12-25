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

local PlayerStats = ReplicatedStorage.playerstats[LocalPlayer.Name]
local StatsRod = PlayerStats.Rods
local StatsInventory = PlayerStats.Inventory
local rodNameCache = PlayerStats.Stats.rod.Value
local morefunc
local Stop

local dataFarm = {}
local moreFunction = function() end

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
    "Voidfin Mahi",
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

local npcList = function(location, npcname, more, remote)
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
                if remote == "luck" then
                    datanpc.remote = datanpc.npc.Merlin.luck
                    datanpc.price = 5000
                elseif remote == "power" then
                    datanpc.remote = datanpc.npc.Merlin.power
                    datanpc.price = 11000
                end
            end
        end
    elseif location == "Moosewood" then
        if npcname == "Appraiser" then
            datanpc = {
                pos = Vector3.new(453.076996, 150.501022, 210.481934),
                cframe = CFrame.new(453.076996, 150.501022, 210.481934, -0.0841025636, 1.00578879e-08, 0.9964571, -4.54328983e-08, 1, -1.39282568e-08, -0.9964571, -4.64433363e-08, -0.0841025636),
                cam = CFrame.new(441.024414, 153.907944, 207.771103, -0.219435185, 0.148836121, -0.96420747, 0, 0.988295138, 0.152554303, 0.975627124, 0.0334757827, -0.216866717),
                price = 450
            }
            if more then
                datanpc.npc = workspace.world.npcs:WaitForChild("Appraiser", math.huge)
                if remote == "appraise" then
                    datanpc.remote = datanpc.npc.appraiser.appraise
                end
            end
        end
    end
    return datanpc
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

local setNPC = function(ZoneName, npcname, remote, quantity)

    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()

        if not quantity then
            quantity = 1
        end

        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local npc = npcList(ZoneName, npcname)
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = npc.pos
        bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
        bodyPosition.Parent = HumanoidRootPart

        npc = npcList(ZoneName, npcname, true, remote)

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
                if npc.remote then
                    for i = 1, quantity do
                        local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
                        if money < npc.price then
                            bodyPosition:Destroy()
                            return
                        end
                        npc.remote:InvokeServer()
                        task.wait(0.1)
                    end
                end
                bodyPosition:Destroy()
                camera.CameraType = Enum.CameraType.Custom
                SetNPC[(ZoneName..npcname)] = true
            end
        else
            game:Shutdown()
        end

    end)

    Stop = false

end

local setInterac = function(interacname, quantity)

    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()

        if not quantity then
            quantity = 1
        end

        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local interac = interactableList(interacname)
        local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        if interac.price and money < interac.price then
            return
        end
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = interac.pos
        bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
        bodyPosition.Parent = HumanoidRootPart

        interac = interactableList(interacname, true)

        repeat task.wait() until (HumanoidRootPart.Position - interac.pos).Magnitude <= 1

        local camera = workspace.Camera
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = interac.cam
        HumanoidRootPart.CFrame = interac.cframe

        local purchaserompt = interac.interac:FindFirstChild("purchaserompt")
        for i = 1, quantity do
            money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money < interac.price then
                bodyPosition:Destroy()
                return
            end
            local Highlight = interac.interac:WaitForChild("Highlight", 10)
            if Highlight then
                if purchaserompt then
                    purchaserompt.HoldDuration = 0
                    purchaserompt:InputHoldBegin()
                    purchaserompt:InputHoldEnd()
                    local button = PlayerGui.over:WaitForChild("prompt",10) and PlayerGui.over.prompt.confirm
                    if not button then
                        bodyPosition:Destroy()
                        return
                    end
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                    repeat task.wait() until not PlayerGui.over:FindFirstChild("prompt")
                    GuiService.SelectedObject = nil
                end
                task.wait(0.1)
            else
                bodyPosition:Destroy()
                return
            end
        end
        bodyPosition:Destroy()
        camera.CameraType = Enum.CameraType.Custom

    end)

    Stop = false

end

local setZone = function(zone, moreFunction2)

    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()

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

        if not moreFunction2 then
            moreFunction2 = function() end
        end
        moreFunction2()

        camera.CameraType = Enum.CameraType.Custom
        bodyPosition:Destroy()

    end)

    Stop = false

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

    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()

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
                setNPC("Sunstone Island", "Marlin", "power", 5)
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

        Character.Humanoid:EquipTool(relic.equip)
        while StatsRod[RodName].Value ~= value and relic.stack > 0 and checkDayNight() == "Night" and task.wait() do

            local Highlight = interactable:WaitForChild("Highlight", 60)
            if StatsRod[RodName].Value == value then
                bodyPosition:Destroy()
                return
            end
            if checkDayNight() == "Day" then
                bodyPosition:Destroy()
                return
            end
            if Highlight then
                if ProximityPrompt then
                    ProximityPrompt.HoldDuration = 0
                    ProximityPrompt:InputHoldBegin()
                    ProximityPrompt:InputHoldEnd()
                    local button = PlayerGui.over:WaitForChild("prompt",10) and PlayerGui.over.prompt.confirm
                    if not button then
                        bodyPosition:Destroy()
                        return
                    end
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                    repeat task.wait() until not PlayerGui.over:FindFirstChild("prompt")
                    GuiService.SelectedObject = nil
                    relic.stack -= 1
                end
            else
                bodyPosition:Destroy()
                return
            end

        end

        if StatsRod[RodName].Value == value then
            bodyPosition:Destroy()
            return
        end
        bodyPosition:Destroy()
        return

    end)

    Stop = false

end

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

    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()

        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = Vector3.new(23.8910046, -705.998718, 1250.59277)
        bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
        bodyPosition.Parent = HumanoidRootPart

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
            bodyPosition:Destroy()
            camera.CameraType = Enum.CameraType.Custom
        else
            game:Shutdown()
        end

    end)

    Stop = false

end

-- Main auto Farm
task.spawn(function()
    while task.wait() do

        if Stop then
            continue
        end

        local currentData = dataFarm

        local zone
        local AutoSell
        if currentData.zone then
            zone = currentData.zone
            AutoSell = currentData.AutoSell
        else
            zone = "The Depths"
            AutoSell = true
        end

        if AutoSell and (not SetNPC[(zone.."Merchant")]) then
            setNPC(zone, "Merchant")
        end

        AutoFish = true

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
        bodyPosition:Destroy()

        local RodPriority = {
            [1] = "Rod Of The Depths",
            [2] = "Aurora Rod",
            [3] = "Steady Rod"
        }

        while RunService.Heartbeat:Wait() do

            if Stop then
                break
            end

            if currentData ~= dataFarm then
                break
            end

            if moreFunction() then
                break
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

                if AutoSell and zone.sell then
                    zone.sell:InvokeServer()
                end

                Character.Humanoid:UnequipTools()

            else
                rod.events.cast:FireServer(100)
            end

        end

        camera.CameraType = Enum.CameraType.Custom
        Character.Torso.Anchored = false
        Character.Humanoid.Sit = false
        AutoFish = false

    end
end)

local crabCage = function()
    repeat
        task.wait()
    until not Stop
    Stop = true

    pcall(function()
        Character.Humanoid:UnequipTools()
        if not Backpack:FindFirstChild("Crab Cage") then
            setInterac("Crab Cage", 3)
        end
        local pos = Vector3.new(-127.297638, -736.863892, 1234.20581)
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Position = pos
        bodyPosition.MaxForce = Vector3.new(math.huge,math.huge, math.huge)
        bodyPosition.Parent = HumanoidRootPart
        repeat task.wait() until (HumanoidRootPart.Position - pos).Magnitude < 1
        local camera = workspace.Camera
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(-139.568878, -720.290649, 1227.21326, -0.495092869, 0.634007037, -0.594069302, 0, 0.683749914, 0.729716539, 0.868840158, 0.361277461, -0.338519663)
        Character.Humanoid:EquipTool(Backpack:FindFirstChild("Crab Cage"))
        task.wait(0.5)
        Character:WaitForChild("Crab Cage").Deploy:FireServer(CFrame.new(-124.78862762451172, -737.0723876953125, 1234.0301513671875, -0.05541973561048508, -0, -0.9984631538391113, -0, 1, -0, 0.9984631538391113, 0, -0.05541973561048508))
        bodyPosition:Destroy()
        camera.CameraType = Enum.CameraType.Custom
    end)

    Stop = false
end

local autoRodOfTheDepths = function()

    if StatsRod:FindFirstChild("Rod Of The Depths") then return end

    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait() and money > 750000

    repeat

        if checkVertigoFish() == "Vertigo" then

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

            moreFunction = function()
                if checkVertigoFish() ~= "Vertigo" then
                    moreFunction = function() end
                    return true
                end
                local crabcages = workspace.active.crabcages:FindFirstChild(LocalPlayer.Name)
                if not crabcages then
                    return
                end
                if crabcages:FindFirstChild("Highlight") then
                    local prompt = crabcages:FindFirstChild("Prompt")
                    if not prompt then return end
                    prompt.HoldDuration = 0
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                end
            end

            dataFarm = {"Vertigo", false}

        elseif checkVertigoFish() == "Isonade" then

            dataFarm = {"The Depths", false}

            repeat
                task.wait()
            until zoneList("Isonade").pos

            moreFunction = function()
                local i = 0
                for _, v in pairs(workspace.zones.fishing:GetChildren()) do
                    if v.Name == "Isonade" then
                        if (v.Position - HumanoidRootPart.Position).Magnitude < 1 then
                            i += 1
                            break
                        end
                    end
                end
                if i == 0 then
                    moreFunction = function() end
                    return true
                end
            end

            dataFarm = {"Isonade", false}

        end

    until task.wait(1) and checkVertigoFish() == "100%"

    if not PlayerStats.Cache:FindFirstChild("Door.TheDepthsGate") then
        npcDepthsDoor()
    end

    local setAbysHex = function(purchase)
        repeat
            task.wait()
        until not Stop
        Stop = true

        local abys = enctRelic("Abyssal")
        local hex = enctRelic("Hexed")
        if abys and hex then
            if purchase then
                local moreFunction2 = function()
                    Character.Humanoid:EquipTool(hex.equip)
                    task.wait(0.1)
                    ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/ActivatorClientActive"):FireServer("Hexed")
                    task.wait(0.1)
                    Character.Humanoid:EquipTool(abys.equip)
                    task.wait(0.1)
                    ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/ActivatorClientActive"):FireServer("Abyssal")
                end
                setZone("The Depths", moreFunction2)
                setInterac("Rod Of The Depths", 1)
            end
            Stop = false
            return true
        end
        stop = false
    end

    if setAbysHex() then
        setAbysHex(true)
        return
    end

    dataFarm = {"The Depths", true}

    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait(1) and money > 850000

    repeat

        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)

        local relic = enctRelic()
        if not relic then
            money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money > 805000 then
                setNPC("Sunstone Island", "Marlin", "power", 5)
                relic = enctRelic()
            else
                continue
            end
        end

        repeat
            task.wait()
        until not Stop
        Stop = true

        Character.Humanoid:EquipTool(relic.equip)

        setNPC("Moosewood", "Appraiser", "appraise", 1)
        repeat
            relic = enctRelic()
            if not relic then
                break
            end
            Character.Humanoid:EquipTool(relic.equip)
            pcall(function()
                workspace.world.npcs.Appraiser.appraiser.appraise:InvokeServer()
            end)
            task.wait()
        until setAbysHex()

        Stop = false

    until task.wait() and setAbysHex()

    repeat
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    until task.wait(1) and money > 750000

    setAbysHex(true)
end

if config["C$_100k"] then

    dataFarm = {"The Depths", true}

elseif config["FarmLevel"] then

    dataFarm = {"The Depths", true}

    task.spawn(function()
        local viewportSize = Workspace.CurrentCamera.ViewportSize
        local x, y = 0, viewportSize.Y - 1
        while task.wait(5) do
            if (not AutoFish) or Stop then
                continue
            end
            if StatsRod:FindFirstChild("Rod Of The Depths") then
                if not checkLuck() then
                    setNPC("Sunstone Island", "Marlin", "luck", 6)
                end
                if checkDayNight() == "Day" then
                    Character.Humanoid:UnequipTools()
                    if Backpack:FindFirstChild("Sundial Totem") then
                        Character.Humanoid:EquipTool(Backpack:FindFirstChild("Sundial Totem"))
                    else
                        setInterac("Sundial Totem", 5)
                    end
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
                end
                if not checkAurora() then
                    Character.Humanoid:UnequipTools()
                    if Backpack:FindFirstChild("Aurora Totem") then
                        Character.Humanoid:EquipTool(Backpack:FindFirstChild("Aurora Totem"))
                    end
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
                end
            elseif StatsRod:FindFirstChild("Aurora Rod") then
                if not checkLuck() then
                    setNPC("Sunstone Island", "Marlin", "luck", 3)
                end
            elseif StatsRod:FindFirstChild("Steady Rod") then
                if not checkLuck() then
                    setNPC("Sunstone Island", "Marlin", "luck", 1)
                end
            end
        end
    end)

    task.spawn(function()
        
        while task.wait(2) do

            if StatsRod:FindFirstChild("Rod Of The Depths") and StatsRod["Rod Of The Depths"].Value ~= "Clever" then
                enchantRod("Rod Of The Depths", "Clever")
                dataFarm = {"Ancient Isle", true}
            elseif StatsRod:FindFirstChild("Aurora Rod") and StatsRod["Aurora Rod"].Value ~= "Mutated" then
                enchantRod("Aurora Rod", "Mutated")
                dataFarm = {"The Depths", true}
            end

            local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if (not StatsRod:FindFirstChild("Rod Of The Depths")) and money > 750000 then
                autoRodOfTheDepths()
                dataFarm = {"Ancient Isle", true}
            end

            if money > 1000000 then
                purchaseRod("Mythical Rod", 110000)
                purchaseRod("Trident Rod", 150000)
                purchaseRod("Kings Rod", 120000)
                purchaseRod("Destiny Rod", 190000)
            end

        end
    end)

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
