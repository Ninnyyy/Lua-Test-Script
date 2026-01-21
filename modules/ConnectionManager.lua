-- modules/ConnectionManager.lua

local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager

function ConnectionManager.new()
    return setmetatable({ connections = {} }, ConnectionManager)
end

function ConnectionManager:Add(conn)
    table.insert(self.connections, conn)
end

function ConnectionManager:Clean()
    for _, conn in ipairs(self.connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(self.connections)
end

return ConnectionManager