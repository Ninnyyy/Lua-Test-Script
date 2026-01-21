-- modules/ESP.lua
local ESP = {}
ESP.__index = ESP

function ESP.new(screenGui, config)
    local self = setmetatable({}, ESP)
    self.screenGui = screenGui
    self.config = config
    self.folders = {}
    return self
end

function ESP:TogglePlayers(enabled)
    if enabled then
        print("[ESP] Players ON")
        -- Real ESP logic will go here later
    else
        for _, folder in pairs(self.folders) do
            folder:Destroy()
        end
        self.folders = {}
        print("[ESP] Players OFF")
    end
end

function ESP:ToggleGenerators(enabled)
    print("[ESP] Generators:", enabled and "ON" or "OFF")
end

function ESP:ClearAll()
    self:TogglePlayers(false)
end

return ESP