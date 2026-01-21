-- main.lua

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Load modules
local Config           = require(script.Parent.modules.Config)
local ConnectionManager = require(script.Parent.modules.ConnectionManager)
local UI               = require(script.Parent.modules.UI)
local ESP              = require(script.Parent.modules.ESP)
local Aimbot           = require(script.Parent.modules.Aimbot)
local Movement         = require(script.Parent.modules.Movement)
local Combat           = require(script.Parent.modules.Combat)
local Visuals          = require(script.Parent.modules.Visuals)
local Teleport         = require(script.Parent.modules.Teleport)
local GameState        = require(script.Parent.modules.GameState)

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = Config.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Initialize systems
local espSystem      = ESP.new(ScreenGui, Config)
local aimbotSystem   = Aimbot.new(ScreenGui, Config)
local movementSystem = Movement.new(Config)
local combatSystem   = Combat.new(Config)
local visualsSystem  = Visuals.new(Config)
local teleportSystem = Teleport.new(ScreenGui, Config)
local gameState      = GameState.new()

-- Create main UI
local mainFrame = UI.CreateMainFrame(ScreenGui, Config)
mainFrame.Visible = true

-- Tabs
local tabs = {
    ESP     = UI.CreateTab("ESP",     mainFrame.ContentFrame),
    Colors  = UI.CreateTab("COLORS",  mainFrame.ContentFrame),
    Features = UI.CreateTab("FEATURES", mainFrame.ContentFrame),
    Visual  = UI.CreateTab("VISUAL",  mainFrame.ContentFrame),
}

-- Populate tabs (examples – add more as you expand)
UI.CreateToggle(tabs.ESP,     "ESP Players",          false, function(s) espSystem:TogglePlayers(s)      end)
UI.CreateToggle(tabs.ESP,     "ESP Generators",       false, function(s) espSystem:ToggleGenerators(s)   end)
UI.CreateToggle(tabs.Features,"Aimbot (Hold RMB)",    false, function(s) aimbotSystem:Toggle(s)          end)
UI.CreateSlider(tabs.Features,"Aimbot FOV", 10, 500,  Config.DefaultAimbotFOV, function(v) aimbotSystem:SetFOV(v) end)
UI.CreateToggle(tabs.Movement,"Fly",                  false, function(s) movementSystem:ToggleFly(s)     end)
UI.CreateToggle(tabs.Combat,  "God Mode",             false, function(s) combatSystem:ToggleGodMode(s)   end)
UI.CreateToggle(tabs.Visuals, "No Fog",               false, function(s) visualsSystem:ToggleNoFog(s)    end)

-- Input
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        UI.ToggleMenu(mainFrame)
    elseif input.KeyCode == Enum.KeyCode.K then
        aimbotSystem:Toggle()
    end
end)

-- Game state
gameState:StartMonitoring(function(state)
    if not state.GameStarted then
        espSystem:ClearAll()
    end
end)

-- Final touches
UI.CreateSimpleNotification(ScreenGui)
print("Singularity-Ninny.top loaded!")
print("F1 = Menu | K = Aimbot toggle")