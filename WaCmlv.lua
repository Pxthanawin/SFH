-- Script
repeat wait() until game:IsLoaded()

-- White Screen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CircularButtons"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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

local GraphicButton = createCircularButton("G", UDim2.new(0.85, 0, 0.3, 0), screenGui)

local RunService = game:GetService("RunService")

if white_screen then
    RunService:Set3dRenderingEnabled(false)
end

GraphicButton.MouseButton1Click:Connect(function()
    if white_screen then
        RunService:Set3dRenderingEnabled(true)
        getgenv().white_screen = false
    else
        RunService:Set3dRenderingEnabled(false)
        getgenv().white_screen = true
    end
end)


if getgenv().ScriptRunning then return end
getgenv().ScriptRunning = true

-- Check Money and Level
while task.wait() do
    pcall(function()
        getgenv().money1 = game.Players.LocalPlayer.leaderstats['C$'].Value
        getgenv().lv1 = game.Players.LocalPlayer.leaderstats.Level.Value

        task.wait(wait_time)

        getgenv().money2 = game.Players.LocalPlayer.leaderstats['C$'].Value
        getgenv().lv2 = game.Players.LocalPlayer.leaderstats.Level.Value

        if money1 == money2 then game:Shutdown() end
        if lv1 == lv2 then game:Shutdown() end
    end)
end
