-- Script
if getgenv().ScriptRunning then return end
getgenv().ScriptRunning = true

repeat wait() until game:IsLoaded()

-- White Screen
if white_screen then
	local RunService = game:GetService("RunService")
	RunService:Set3dRenderingEnabled(false)
end

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
