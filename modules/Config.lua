-- modules/Config.lua

local Config = {}

Config.GuiName              = "Singularity-Ninny.top"
Config.DefaultKillerColor   = Color3.fromRGB(255, 0, 0)
Config.DefaultSurvivorColor = Color3.fromRGB(0, 255, 0)
Config.GeneratorColor       = Color3.fromRGB(0, 100, 255)
Config.PalletColor          = Color3.fromRGB(255, 255, 0)

Config.DefaultWalkSpeed     = 16
Config.MaxWalkSpeed         = 500
Config.DefaultFlySpeed      = 50
Config.DefaultJumpPower     = 50
Config.DefaultAimbotFOV     = 50
Config.DefaultRotateSpeed   = 100

-- Add more as you implement features
Config.AutoRepairSpeed      = 0.12   -- seconds between attempts
Config.AutoPalletDistance   = 14     -- studs

return Config