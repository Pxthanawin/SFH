local Config = {
    ["Farm Fish"] = true,
}

repeat task.wait() until game:IsLoaded()

repeat
    task.wait(1)
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

local rodNameCache = nil

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

-- Main fishing function optimized
local function farmFish()
    repeat task.wait(1) until ScriptRunning
    while Config["Farm Fish"] do
        -- Cache rodName to avoid repeated lookups
        if not rodNameCache then
            rodNameCache = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
        end

        local rod = Backpack:FindFirstChild(rodNameCache) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(rodNameCache))

        if not rod then
            RunService.Heartbeat:Wait() -- Shorter wait than task.wait()
            continue
        end

        if rod.Parent == Backpack then
            LocalPlayer.Character.Humanoid:EquipTool(rod)
        end

        if rod:FindFirstChild("bobber") then
            while Config["Farm Fish"] and rod:FindFirstChild("bobber") do
                if rod.values.bite.Value then
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    task.wait(0.3) -- Reduced delay
                else
                    autoClickButton()
                    RunService.Heartbeat:Wait() -- Smoother frame sync
                end
            end
        else
            rod.events.cast:FireServer(100)
            task.wait(0.3)
        end
    end
end

task.spawn(function()
    repeat task.wait(1) until ScriptRunning
    while task.wait(1) do
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(286.446014, 133.615952, 215.977982, -0.0249165799, -9.16445231e-08, 0.999689519, -3.31714545e-09, 1, 9.15903016e-08, -0.999689519, -1.03399844e-09, -0.0249165799)
        end)
    end
end)

-- Spawn the fishing loop
task.spawn(farmFish)

-- Monitor Money and Level Changes
task.spawn(function()
    repeat task.wait(1) until ScriptRunning
    local countM = 0
    local money = LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("C$") and LocalPlayer.leaderstats["C$"].Value or 0

    while task.wait(1) do
        countM += 1
        local currentMoney = LocalPlayer.leaderstats["C$"] and LocalPlayer.leaderstats["C$"].Value or 0
        if money ~= currentMoney then
            countM = 0
            money = currentMoney
        end
        if countM >= 15 then
            pcall(LocalPlayer.Character:FindFirstChild(rodNameCache).events.reset:FireServer())
            task.wait(9)
        end
    end
end)
