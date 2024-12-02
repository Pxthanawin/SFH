-- Configurations
getgenv().white_screen = true
getgenv().wait_time = 15

-- Script Initialization
repeat task.wait() until game:IsLoaded()

if getgenv().ScriptRunning then return end
getgenv().ScriptRunning = true

-- Create White Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CircularButtons"
screenGui.Parent = game:GetService("CoreGui") -- เปลี่ยน Parent เป็น CoreGui

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

local graphicButton = createCircularButton("G", UDim2.new(0.85, 0, 0.3, 0), screenGui)

local RunService = game:GetService("RunService")

-- Handle White Screen Toggle
if getgenv().white_screen then
    RunService:Set3dRenderingEnabled(false)
end

graphicButton.MouseButton1Click:Connect(function()
    getgenv().white_screen = not getgenv().white_screen
    RunService:Set3dRenderingEnabled(not getgenv().white_screen)
end)


-- Monitor Money and Level Changes
task.spawn(function()
    local countM = 0
    local money = game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("C$") and game.Players.LocalPlayer.leaderstats["C$"].Value or 0

    local countL = 0
    local level = game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("Level") and game.Players.LocalPlayer.leaderstats.Level.Value or 0

    while task.wait(1) do
        countM = countM + 1
        local currentMoney = game.Players.LocalPlayer.leaderstats["C$"] and game.Players.LocalPlayer.leaderstats["C$"].Value or 0
        if money ~= currentMoney then
            countM = 0
            money = currentMoney
        end
        if countM >= getgenv().wait_time then
            game:Shutdown()
        end

        countL = countL + 1
        local currentLevel = game.Players.LocalPlayer.leaderstats.Level and game.Players.LocalPlayer.leaderstats.Level.Value or 0
        if level ~= currentLevel then
            countL = 0
            level = currentLevel
        end
        if countL >= getgenv().wait_time then
            game:Shutdown()
        end
    end
end)

--

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1313075518727393310/qFe8ooPPvaJnbD1QbL3sYd3LZCVrqyVyheY47Wm7zwDlsPbKq2-llKLg6p48jD98ex4k"

-- Player Information
local playerName = game.Players.LocalPlayer.Name
local userId = game.Players.LocalPlayer.UserId

-- Function to Send Discord Message
local function sendDiscordMessage(username, id)
    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "A player has executed the script!",
                ["description"] = string.format("**Player Name:** %s\n**User ID:** %d", username, id),
                ["color"] = 16711680,
                ["footer"] = {
                    ["text"] = "Script Execution Monitor",
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    local jsonData = game:GetService("HttpService"):JSONEncode(data)

    http_request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end

-- เรียกใช้ฟังก์ชันเมื่อรันสคริปต์
sendDiscordMessage(playerName, userId)
