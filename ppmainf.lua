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
local camera = workspace.Camera

local Character = LocalPlayer.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")

local PlayerStats = ReplicatedStorage.playerstats[LocalPlayer.Name]
local StatsRod = PlayerStats.Rods
local StatsInventory = PlayerStats.Inventory
local rodNameCache = PlayerStats.Stats.rod.Value

local AutoSell = true
--local __sec = false
local __count = 0

local zonefish = Vector3.new(841, -750, 1246)

local sundialt = true
local aurorat = true
local farmc = true
local gct = true

local iS = 1000
local iA = 1000
local iF = 1000
local iC = 1000

local function extractNumber(String)
    return tonumber((String:gsub("[^%d]", "")))
end

local Lighting = game:GetService("Lighting")

local function checkDayNight()
    return ReplicatedStorage.world.cycle.Value
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
    ["Ancient Isle"] = Vector3.new(-2695, 157, 1752),
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

local crabcframe = {
    CFrame.new(-108.393913, -731.931641, 1274.02393, 0.0261686351, -4.32356586e-08, 0.999657571, -2.81474204e-08, 1, 4.39872991e-08, -0.999657571, -2.92888682e-08, 0.0261686351),
    CFrame.new(-107.913918, -731.931641, 1268.96436, 0.398755074, 1.14332195e-07, 0.917057455, -5.97640621e-08, 1, -9.86862574e-08, -0.917057455, -1.54554307e-08, 0.398755074),
    CFrame.new(-105.316803, -731.931641, 1265.45081, 0.731348395, 2.57834554e-08, 0.682004035, 1.95802414e-08, 1, -5.88023426e-08, -0.682004035, 5.63588038e-08, 0.731348395),
    CFrame.new(-101.398254, -731.931641, 1264.73889, 0.996194124, -1.86150686e-08, 0.0871622413, 9.5941024e-09, 1, 1.03915177e-07, -0.0871622413, -1.02683444e-07, 0.996194124),
    CFrame.new(-126.570824, -736.921326, 1249.44983, -0.930414855, 3.3981955e-08, -0.366508096, 1.14769492e-08, 1, 6.35828528e-08, 0.366508096, 5.49520394e-08, -0.930414855),
    CFrame.new(-126.570824, -736.921326, 1249.44983, -0.559208751, 3.68686166e-08, 0.829026878, 6.70668143e-08, 1, 7.66842256e-10, -0.829026878, 5.60290196e-08, -0.559208751),
    CFrame.new(-126.570786, -736.921326, 1249.44995, 0.669113874, -3.92071797e-08, 0.74315989, 1.19301635e-09, 1, 5.16832479e-08, -0.74315989, -3.36953754e-08, 0.669113874),
    CFrame.new(-126.57077, -736.921326, 1249.44971, 0.852652609, 4.90440648e-08, -0.522478223, -2.68322822e-08, 1, 5.00795032e-08, 0.522478223, -2.86811357e-08, 0.852652609),
    CFrame.new(-128.476593, -736.86377, 1236.09924, 0.182254702, -6.49348531e-09, -0.983251333, 7.47906448e-09, 1, -5.21778132e-09, 0.983251333, -6.40283471e-09, 0.182254702),
    CFrame.new(-130.444183, -736.86377, 1230.6322, 0.573596358, 2.54263739e-08, -0.81913805, -7.80947573e-08, 1, -2.36449722e-08, 0.81913805, 7.75330591e-08, 0.573596358),
    CFrame.new(-133.651352, -736.863831, 1227.5675, 0.927194059, 9.46170431e-08, -0.374581277, -7.10716819e-08, 1, 7.66717463e-08, 0.374581277, -4.44674697e-08, 0.927194059),
    CFrame.new(-137.511536, -736.86377, 1236.93909, -0.90997088, 6.27705354e-09, 0.414672107, -2.32460842e-08, 1, -6.61494042e-08, -0.414672107, -6.98335327e-08, -0.90997088),
    CFrame.new(-143.535797, -736.404785, 1215.13452, 0.93968612, -7.76427314e-08, 0.342038006, 7.29872056e-08, 1, 2.64814499e-08, -0.342038006, 8.01478328e-11, 0.93968612),
    CFrame.new(-139.552338, -736.86377, 1234.79895, -0.333827347, -8.40543579e-10, 0.942634225, 3.85927912e-08, 1, 1.45590651e-08, -0.942634225, 4.1239101e-08, -0.333827347),
    CFrame.new(-139.768021, -736.86377, 1229.72083, 0.139154732, 7.20137336e-08, 0.990270674, 6.96110547e-08, 1, -8.25031421e-08, -0.990270674, 8.04144875e-08, 0.139154732),
    CFrame.new(-144.556717, -736.404785, 1217.0918, -0.469492912, -1.77599588e-08, 0.882936239, -3.25390097e-08, 1, 2.81234813e-09, -0.882936239, -2.74094951e-08, -0.469492912),
    CFrame.new(-146.442352, -736.404785, 1215.35657, 0.398721874, 4.28803766e-08, 0.917071879, -3.06554426e-08, 1, -3.34296395e-08, -0.917071879, -1.47841162e-08, 0.398721874),
    CFrame.new(-141.684692, -736.404785, 1214.90491, 0.843406498, 2.19585949e-08, -0.53727597, -4.32623466e-08, 1, -2.70422476e-08, 0.53727597, 4.60514258e-08, 0.843406498),
    CFrame.new(-138.502258, -736.404785, 1214.53247, 0.267267436, -8.63725518e-08, -0.963622391, 1.64266123e-09, 1, -8.91775827e-08, 0.963622391, 2.22513599e-08, 0.267267436),
    CFrame.new(-74.3979568, -736.791931, 1209.00134, -1, -2.08987991e-08, -2.98460945e-05, -2.08969748e-08, 1, -6.11025612e-08, 2.98460945e-05, -6.11019431e-08, -1),
    CFrame.new(-71.0015869, -736.79187, 1205.38, 0.965933383, -1.03933129e-09, -0.25879091, 1.44798218e-09, 1, 1.38846867e-09, 0.25879091, -1.71589287e-09, 0.965933383),
    CFrame.new(-71.6375351, -736.791931, 1206.02002, 0.587764978, 2.55517651e-08, 0.809031725, -8.85797746e-08, 1, 3.27704406e-08, -0.809031725, -9.09251696e-08, 0.587764978),
    CFrame.new(-81.0526276, -736.791931, 1210.33521, 0.82902503, -3.25108047e-08, 0.559211493, -1.40557663e-08, 1, 7.8974395e-08, -0.559211493, -7.3331897e-08, 0.82902503),
    CFrame.new(-82.1462708, -736.791931, 1211.06555, 0.00869873539, -3.7484206e-08, 0.999962151, -2.79494881e-08, 1, 3.7728757e-08, -0.999962151, -2.82766237e-08, 0.00869873539),
    CFrame.new(-82.1949234, -736.791931, 1214.10071, -0.629336298, 2.05353174e-08, 0.777133107, 6.62660637e-09, 1, -2.10581099e-08, -0.777133107, -8.10287748e-09, -0.629336298)
}

if PlayerGui.hud.safezone:FindFirstChild("reward") then
    GuiService.SelectedObject = PlayerGui.hud.safezone.reward.Claim
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
    task.wait(0.1)
    GuiService.SelectedObject = nil
end
if PlayerGui:FindFirstChild("DateReward") and PlayerGui.DateReward.datereward.Visible then
    GuiService.SelectedObject = PlayerGui.DateReward.datereward.Visible
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
    task.wait(0.1)
    GuiService.SelectedObject = nil
end

local npcRemote = function(remote)
    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    --local currentPos = HumanoidRootPart.Position
    if remote == "luck" then
        if money < 5000 then return end
        if Torso.Anchored then
            Torso.Anchored = false
            task.wait(0.25)
        end
        HumanoidRootPart.CFrame = CFrame.new(-926.718994, 223.700012, -998.751404)
        task.wait(0.1)
        pcall(workspace.world.npcs:WaitForChild("Merlin", math.huge).Merlin.luck:InvokeServer())
        --HumanoidRootPart.CFrame = CFrame.new(currentPos)
    elseif remote == "power" then
        if money < 11000 then return end
        if Torso.Anchored then
            Torso.Anchored = false
            task.wait(0.25)
        end
        HumanoidRootPart.CFrame = CFrame.new(-926.718994, 223.700012, -998.751404)
        task.wait(0.1)
        pcall(workspace.world.npcs:WaitForChild("Merlin", math.huge).Merlin.power:InvokeServer())
        --HumanoidRootPart.CFrame = CFrame.new(currentPos)
    elseif remote == "Appraiser" then
        if money < 450 then return end
        if Torso.Anchored then
            Torso.Anchored = false
            task.wait(0.25)
        end
        HumanoidRootPart.CFrame = CFrame.new(453.076996, 150.501022, 210.481934)
        task.wait(0.1)
        pcall(workspace.world.npcs:WaitForChild("Appraiser", math.huge).appraiser.appraise:InvokeServer())
        --HumanoidRootPart.CFrame = CFrame.new(currentPos)
    elseif remote == "Jack Marrow" then
        if money < 250 then return end
        if Torso.Anchored then
            Torso.Anchored = false
            task.wait(0.25)
        end
        HumanoidRootPart.CFrame = CFrame.new(256.994873, 135.709, 58.1402702)
        task.wait(0.1)
        pcall(workspace.world.npcs:WaitForChild("Jack Marrow", math.huge).treasure.repairmap:InvokeServer())
        --HumanoidRootPart.CFrame = CFrame.new(currentPos)
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
            pos = Vector3.new(-1811.86853, -136.927979, -3281.16772),
            cframe = CFrame.new(-1811.86853, -136.927979, -3281.16772, 0.999493241, -3.9704716e-08, 0.0318309925, 3.91892918e-08, 1, 1.68163776e-08, -0.0318309925, -1.55604223e-08, 0.999493241),
            cam = CFrame.new(-1813.31018, -130.086349, -3281.83008, -0.750986338, 0.650285959, -0.114663109, 0, 0.173648387, 0.98480773, 0.660317659, 0.739577174, -0.130407587),
            price = 500000
        }
        if more then
            datainterac.interac = workspace.world.interactables:WaitForChild("Aurora Totem", math.huge)
        end
    elseif interacname == "Crab Cage" then
        datainterac = {
            pos = Vector3.new(477.21521, 152.536423, 225.896362),
            cframe = CFrame.new(477.21521, 152.536423, 225.896362, -0.856148243, 8.27452524e-08, 0.516730249, 4.23745021e-08, 1, -8.99238941e-08, -0.516730249, -5.50919985e-08, -0.856148243),
            cam = CFrame.new(482.736908, 161.19809, 217.266678, -0.842328846, -0.308790088, 0.441736042, 0, 0.819602251, 0.572932839, -0.538963854, 0.482597858, -0.690374732),
            price = 45
        }
        if more then
            datainterac.interac = workspace.world.interactables:WaitForChild("Crab Cage", math.huge)
            for _, v in pairs(datainterac.interac:GetChildren()) do
                if v:FindFirstChild("purchaserompt") then
                    datainterac.interac = v
                    break
                end
            end
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

    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = interac.cam
    HumanoidRootPart.CFrame = interac.cframe

    local purchaserompt = interac.interac:FindFirstChild("purchaserompt")
    task.wait(1)
    for i = 1, quantity do
        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        if money > interac.price then
            HumanoidRootPart.CFrame = interac.cframe
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
    task.wait(0.25)
    if Torso.Anchored then
        if (HumanoidRootPart.Position - zone).Magnitude < 6 then
            return
        else
            Torso.Anchored = false
            task.wait(0.25)
        end
    end
    HumanoidRootPart.CFrame = CFrame.new(zone)
    task.wait(2)
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

local enchantRod = function(RodName, value, value2)

    if not value2 then
        value2 = "nil"
    end

    while task.wait(0.5) do

        if StatsRod[RodName].Value == value or StatsRod[RodName].Value == value2 then
            return
        end

        if checkDayNight() == "Day" then return end

        if not StatsRod:FindFirstChild(RodName) then
            return
        end

        local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        local relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")
        if not relic then
            if money > 33000 then
                for i = 1, 3 do
                    npcRemote("power")
                end
                task.wait()
                relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")
            else
                return
            end
        end

        if PlayerStats.Stats.rod.Value ~= RodName then
            if StatsRod:FindFirstChild(RodName) then
                LocalPlayer.Character.Humanoid:UnequipTools()
                ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Rod/Equip"):FireServer(RodName)
            end
        end

        local pos = Vector3.new(1311, -802.427063, -83)
        if Torso.Anchored then
            Torso.Anchored = false
            task.wait(0.25)
        end
        HumanoidRootPart.CFrame = CFrame.new(pos)
        task.wait(0.25)

        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(1310.2572, -765.473999, -89.2070618, -0.992915571, 0.117016889, -0.0206332784, 0, 0.173648536, 0.98480773, 0.118822068, 0.977830946, -0.172418341)

        local interactable = workspace.world.interactables:WaitForChild("Enchant Altar", math.huge)
        local ProximityPrompt = interactable.ProximityPrompt

        if not relic then
            return
        end

        while task.wait(0.25) do

            relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")

            if not relic then
                break
            end

            HumanoidRootPart.CFrame = CFrame.new(pos)
            Humanoid:EquipTool(relic.equip)

            local Highlight = interactable:WaitForChild("Highlight", 60)
            if StatsRod[RodName].Value == value or StatsRod[RodName].Value == value2 then
                return
            end
            if checkDayNight() == "Day" then
                return
            end
            if not Highlight then
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(1310.2572, -765.473999, -89.2070618, -0.992915571, 0.117016889, -0.0206332784, 0, 0.173648536, 0.98480773, 0.118822068, 0.977830946, -0.172418341)
                continue
            end
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
                end
            end

            Character.Humanoid:UnequipTools()

        end
        camera.CameraType = Enum.CameraType.Custom
    end
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
                pcall(function()
                    Character.Humanoid:UnequipTools()
                    task.wait(0.25)
                    ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Rod/Equip"):FireServer(v)
                    task.wait(0.25)
                    rodNameCache = PlayerStats.Stats.rod.Value
                end)
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
    local fish = #ListVartigoFish + 1
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

    task.wait(0.5)

    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(4.40501785, -698.242615, 1247.79309, -0.142213896, 0.299789965, -0.943345785, 0, 0.953032434, 0.302868336, 0.989835918, 0.0430720858, -0.135534465)
    HumanoidRootPart.CFrame = CFrame.new(23.8910046, -705.998718, 1250.59277, -0.0548401251, 6.33398187e-08, -0.998495162, 9.3198544e-08, 1, 5.83165551e-08, 0.998495162, -8.98602082e-08, -0.0548401251)

    repeat
        pcall(function()
            local Highlight = workspace.world.npcs.Custos:GetChildren()[15]
            local dialog = workspace.world.npcs.Custos:FindFirstChild("dialogprompt")

            if Highlight then
                dialog.HoldDuration = 0
                dialog:InputHoldBegin()
                dialog:InputHoldEnd()
            end

            local button = PlayerGui:WaitForChild("options",10) and PlayerGui.options.safezone["1option"].button
            if button then
                GuiService.SelectedObject = button
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
            end
        end)
    until PlayerStats.Cache:FindFirstChild("Door.TheDepthsGate")

    GuiService.SelectedObject = nil
    camera.CameraType = Enum.CameraType.Custom

end

local crabCage = function()
    Character.Humanoid:UnequipTools()
    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end
    if not Backpack:FindFirstChild("Crab Cage") then
        setInterac("Crab Cage", 5)
    end
    HumanoidRootPart.CFrame = CFrame.new(zonelist["Vertigo"])
    Humanoid.Sit = false
    task.wait(0.25)
    for _, v in ipairs(crabcframe) do
        HumanoidRootPart.CFrame = v
        local viewportSize = Workspace.CurrentCamera.ViewportSize
        local x, y = 0, viewportSize.Y - 1
        local cameraPosition = HumanoidRootPart.Position + Vector3.new(0, 15, 0)
        local cameraLookAt = HumanoidRootPart.Position
        camera.CameraType = Enum.CameraType.Attach
        camera.CFrame = CFrame.new(cameraPosition, cameraLookAt)
        if Backpack:FindFirstChild("Crab Cage") then
            Humanoid:EquipTool(Backpack:FindFirstChild("Crab Cage"))
        else
            break
        end
        task.wait(0.25)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
        task.wait(0.25)
        Humanoid:UnequipTools()
    end
    camera.CameraType = Enum.CameraType.Custom
    task.wait(0.25)
    Humanoid.Sit = true
end

local autoRodOfTheDepths = function()

    if StatsRod:FindFirstChild("Rod Of The Depths") then return end

    local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if money < 750000 then
        return
    end

    camera.CameraType = Enum.CameraType.Custom

    if checkVertigoFish() == "Vertigo" then

        repeat

            if not PlayerStats.Bestiary:FindFirstChild("Night Shrimp") then
                local i = 0
                for _, v in pairs(workspace.active.crabcages:GetChildren()) do
                    if (v.blocker.Position - Vector3.new(-121, -743, 1234)).Magnitude < 200 then
                        if v.Name == game.Players.LocalPlayer.Name then
                            i = 100001
                            break
                        else
                            i += 1
                        end
                    end
                end
                if i < 22 then
                    crabCage()
                elseif i ~= 100001 then
                    return
                end
            end

            for _, v in ipairs(workspace.active.crabcages:GetChildren()) do
                if v.Name == game.Players.LocalPlayer.Name and v:FindFirstChild("Prompt") and v.Prompt.Enabled then
                    if Torso.Anchored then
                        Torso.Anchored = false
                        task.wait(0.25)
                    end
                    local pos = v.handle.Position
                    local cameraPosition = pos + Vector3.new(0, 15, 0)
                    local cameraLookAt = pos
                    local prompt = v.Prompt
                    camera.CameraType = Enum.CameraType.Scriptable
                    camera.CFrame = CFrame.new(cameraPosition, cameraLookAt)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                    task.wait(0.25)
                    prompt.HoldDuration = 0
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                    task.wait(0.25)
                    camera.CameraType = Enum.CameraType.Custom
                end
            end

            AutoSell = false
            setFishZone(zonelist["Vertigo"])

        until task.wait(1) and checkVertigoFish() ~= "Vertigo"

        for _, v in ipairs(workspace.active.crabcages:GetChildren()) do
            while v.Name == game.Players.LocalPlayer.Name do
                task.wait()
                if v:FindFirstChild("Prompt") and v.Prompt.Enabled then
                    break
                end
            end
            if v.Name == game.Players.LocalPlayer.Name and v:FindFirstChild("Prompt") and v.Prompt.Enabled then
                if Torso.Anchored then
                    Torso.Anchored = false
                    task.wait(0.25)
                end
                local pos = v.handle.Position
                local cameraPosition = pos + Vector3.new(0, 15, 0)
                local cameraLookAt = pos
                local prompt = v.Prompt
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(cameraPosition, cameraLookAt)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                task.wait(0.25)
                prompt.HoldDuration = 0
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
                task.wait(0.25)
                camera.CameraType = Enum.CameraType.Custom
            end
        end

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
        task.wait(1)
        npcDepthsDoor()
        task.wait(0.5)
    end

    AutoSell = true
    ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()

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
    if money < 750000 then
        return
    end

    repeat

        money = extractNumber(LocalPlayer.leaderstats["C$"].Value)

        local relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")
        if not relic then
            money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money > 100000 then
                for i = 1, 5 do
                    npcRemote("power")
                end
                relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")
            else
                return
            end
        end

        repeat
            task.wait()
            relic = enctRelic() or enctRelic("Aurora") or enctRelic("Glossy")
            if not relic then
                return
            end
            Character.Humanoid:EquipTool(relic.equip)
            npcRemote("Appraiser")
            Character.Humanoid:UnequipTools()
        until setAbysHex()

    until task.wait() and setAbysHex()

    money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
    if money < 750000 then
        return
    end

    setAbysHex(true)
end

local getchest = function()
    if Torso.Anchored then
        Torso.Anchored = false
        task.wait(0.25)
    end
    Character.Humanoid:UnequipTools()
    task.wait()
    for _, v in ipairs(Backpack:GetChildren()) do
        if v.Name == "Treasure Map" then
            Humanoid:EquipTool(v)
            task.wait(0.25)
            npcRemote("Jack Marrow")

            for _, vv in ipairs(workspace.world.chests:GetChildren()) do
                if not vv:FindFirstChild("ProximityPrompt") then
                    continue
                end
                vv.CFrame = HumanoidRootPart.CFrame
                task.wait()
                local pos = vv.Position
                local cameraPosition = pos + Vector3.new(0, 15, 0)
                local cameraLookAt = pos
                local prompt = vv.ProximityPrompt
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(cameraPosition, cameraLookAt)
                HumanoidRootPart.CFrame = CFrame.new(pos)
                task.wait(0.5)
                prompt.HoldDuration = 0
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
                task.wait(0.25)
                camera.CameraType = Enum.CameraType.Custom
            end
        end
    end
end

task.spawn(function()
    local rod
    while RunService.Heartbeat:Wait() do

        if not Torso.Anchored then
            --__sec = true
            task.wait(0.5)
            continue
        end

        rodNameCache = PlayerStats.Stats.rod.Value
        rod = Backpack:FindFirstChild(rodNameCache) or (Character and Character:FindFirstChild(rodNameCache))

        if not rod then
            continue
        end

        if not Character:FindFirstChild(rodNameCache) then
            if rod.Parent == Backpack then
                pcall(function()
                    Character.Humanoid:EquipTool(rod)
                end)
                equipRod(RodPriority)
                task.wait()
                continue
            end
        end

        if rod:FindFirstChild("bobber") then

            repeat
                RunService.Heartbeat:Wait()
            until PlayerGui:FindFirstChild("shakeui") or Backpack:FindFirstChild(rodNameCache) or not rod:FindFirstChild("bobber")
            local shakeUI = PlayerGui:FindFirstChild("shakeui")
            while PlayerGui:FindFirstChild("shakeui") do
                local button = shakeUI:FindFirstChild("safezone") and shakeUI.safezone:FindFirstChild("button")
                if button then
                    button.Size = UDim2.new(1001, 0, 1001, 0)
                    VirtualUser:Button1Down(Vector2.new(1, 1))
                    VirtualUser:Button1Up(Vector2.new(1, 1))
                end
                RunService.Heartbeat:Wait()
            end
            --[[
            if __sec and rod.values.bite.Value then
                __sec = false
                task.wait()
                Character.Humanoid:UnequipTools()
                continue
            end]]
            while rod.values.bite.Value do
                if PlayerGui:FindFirstChild("reel") then
                    PlayerGui.reel:Destroy()
                end
                ReplicatedStorage.events.reelfinished:FireServer(100, true)
                if rod.values.bite.Value then
                    Character.Humanoid:UnequipTools()
                end
                task.wait()
            end

            __count += 1

            if AutoSell and __count >= 30 then
                __count = 0
                ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
            end

            Character.Humanoid:UnequipTools()

        else
            rod.events.cast:FireServer(100)
        end

    end
end)

if config["C$_100k"] then

    setFishZone(zonelist["The Depths"])
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)

elseif config["FarmLevel"] then

    while task.wait(1) do

        if iF > 1 then
            farmc = true
            iF = 0
        end
        if iS > 60 then
            sundialt = true
            iS = 0
        end
        if iA > 60 then
            aurorat = true
            iA = 0
        end
        if iC > 300 then
            gct = true
            iC = 0
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") then
            if not checkLuck() then
                for i = 1, 6 do
                    npcRemote("luck")
                end
                task.wait(0.25)
            end
            if checkDayNight() ~= "Night" and sundialt then
                sundialt = false
                iS = 0
                if Backpack:FindFirstChild("Sundial Totem") then
                    if Torso.Anchored then
                        Torso.Anchored = false
                        task.wait(0.25)
                    end
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Sundial Totem"))
                else
                    setInterac("Sundial Totem", 3)
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Sundial Totem"))
                end
                task.wait(math.random(0, 30) / 10)
                if checkDayNight() ~= "Night" then
                    local viewportSize = Workspace.CurrentCamera.ViewportSize
                    local x, y = 0, viewportSize.Y - 1
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
                    task.wait(1)
                end
            elseif not checkAurora() and aurorat then
                aurorat = false
                iA = 0
                if Backpack:FindFirstChild("Aurora Totem") then
                    if Torso.Anchored then
                        Torso.Anchored = false
                        task.wait(0.25)
                    end
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Aurora Totem"))
                else
                    setInterac("Aurora Totem")
                    Character.Humanoid:EquipTool(Backpack:FindFirstChild("Aurora Totem"))
                end
                task.wait(math.random(0, 20) / 10)
                if Backpack:FindFirstChild("Aurora Totem") and not checkAurora() then
                    local viewportSize = Workspace.CurrentCamera.ViewportSize
                    local x, y = 0, viewportSize.Y - 1
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 0)
                    task.wait(1)
                end
            end
        elseif StatsRod:FindFirstChild("Aurora Rod") then
            if not checkLuck() then
                npcRemote("luck")
                task.wait(0.25)
            end
        elseif StatsRod:FindFirstChild("Steady Rod") then
            if not checkLuck() then
                npcRemote("luck")
                task.wait(0.25)
            end
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") and StatsRod["Rod Of The Depths"].Value ~= "Clever" then
            enchantRod("Rod Of The Depths", "Clever")
        elseif StatsRod:FindFirstChild("Aurora Rod") and (StatsRod["Aurora Rod"].Value ~= "Mutated" and StatsRod["Aurora Rod"].Value ~= "Divine") and not StatsRod:FindFirstChild("Rod Of The Depths") then
            enchantRod("Aurora Rod", "Mutated", "Divine")
        end

        local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
        if (not StatsRod:FindFirstChild("Rod Of The Depths")) and money > 750000 then
            task.wait(0.5)
            autoRodOfTheDepths()
        end

        if StatsRod:FindFirstChild("Rod Of The Depths") and (money > 1000000 or game.Players.LocalPlayer.leaderstats.Level.Value > 400) then
            purchaseRod("Mythical Rod", 110000)
            purchaseRod("Trident Rod", 150000)
            purchaseRod("Kings Rod", 120000)
            purchaseRod("Destiny Rod", 190000)
        end

        if game.Players.LocalPlayer.leaderstats.Level.Value > 500 and not StatsRod:FindFirstChild("Sunken Rod") and gct and money > 10000 then
            gct = false
            iC = 0
            getchest()
        end

        if farmc then
            farmc = false
            iF = 0
            if StatsRod:FindFirstChild("Rod Of The Depths") then
                setFishZone(zonelist["Ancient Isle"])
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)
            else
                setFishZone(zonelist["The Depths"])
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(0.943815053, 141.073318, -0.428265214, -0.999930441, -0.0116165085, 0.00204831036, 0, 0.173648715, 0.98480773, -0.0117957117, 0.984739244, -0.173636645)
            end
        end

        iS += 1
        iA += 1
        iF += 1
        iC += 1
    end
end
--[[
task.spawn(function()
    if config["FarmLevel"] then
        task.wait(300)
        while not StatsRod:FindFirstChild("Rod Of The Depths") do
            local money = extractNumber(LocalPlayer.leaderstats["C$"].Value)
            if money > 1600000 then
                game:Shutdown()
            end
            task.wait(1)
        end
    end
end)]]
