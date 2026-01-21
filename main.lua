local v0 = game:GetService("Players")
local v1 = game:GetService("RunService")
local v2 = game:GetService("UserInputService")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("Lighting")
local v5 = game:GetService("Teams")
local v6 = game:GetService("Workspace")
local v7 = game:GetService("HttpService")
local v8 = game:GetService("CoreGui")
local v9 = v0.LocalPlayer
local v10 = v9:WaitForChild("PlayerGui")

local v11 = {}
v11._cache = {}
v11._connections = {}
v11._espCache = {}
v11._lastUpdate = 0
v11._updateInterval = 0.1

v11.ScreenGui = Instance.new("ScreenGui")
v11.ScreenGui.Name = "Sishka52"
v11.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() 
    v11.ScreenGui.Parent = v8
end)

v11.MainFrame = Instance.new("Frame")
v11.MainFrame.Name = "MainFrame"
v11.MainFrame.Size = UDim2.new(0, 450, 0, 650)
v11.MainFrame.Position = UDim2.new(0, 20, 0, 100)
v11.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
v11.MainFrame.BorderSizePixel = 0
v11.MainFrame.ClipsDescendants = true
v11.MainFrame.Parent = v11.ScreenGui

v11.dragging = false
v11.dragInput = nil
v11.dragStart = nil
v11.startPos = nil

v11.update = function(v363)
    if v11.dragging then
        local v1219 = v363.Position - v11.dragStart
        v11.MainFrame.Position = UDim2.new(
            v11.startPos.X.Scale,
            v11.startPos.X.Offset + v1219.X,
            v11.startPos.Y.Scale,
            v11.startPos.Y.Offset + v1219.Y
        )
    end
end

v11.MainFrame.InputBegan:Connect(function(v364)
    if v364.UserInputType == Enum.UserInputType.MouseButton1 then
        v11.dragging = true
        v11.dragStart = v364.Position
        v11.startPos = v11.MainFrame.Position
    end
end)

v11.MainFrame.InputChanged:Connect(function(v365)
    if v365.UserInputType == Enum.UserInputType.MouseMovement then
        v11.dragInput = v365
    end
end)

v2.InputChanged:Connect(function(v366)
    if v366 == v11.dragInput and v11.dragging then
        v11.update(v366)
    end
end)

v2.InputEnded:Connect(function(v367)
    if v367.UserInputType == Enum.UserInputType.MouseButton1 then
        v11.dragging = false
    end
end)

v11.UICorner = Instance.new("UICorner")
v11.UICorner.CornerRadius = UDim.new(0, 12)
v11.UICorner.Parent = v11.MainFrame

v11.UIStroke = Instance.new("UIStroke")
v11.UIStroke.Color = Color3.fromRGB(60, 60, 70)
v11.UIStroke.Thickness = 2
v11.UIStroke.Parent = v11.MainFrame

v11.TitleFrame = Instance.new("Frame")
v11.TitleFrame.Name = "TitleFrame"
v11.TitleFrame.Size = UDim2.new(1, 0, 0, 40)
v11.TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
v11.TitleFrame.BorderSizePixel = 0
v11.TitleFrame.Parent = v11.MainFrame

v11.TitleCorner = Instance.new("UICorner")
v11.TitleCorner.CornerRadius = UDim.new(0, 12)
v11.TitleCorner.Parent = v11.TitleFrame

v11.TitleLabel = Instance.new("TextLabel")
v11.TitleLabel.Name = "TitleLabel"
v11.TitleLabel.Size = UDim2.new(1, 0, 1, 0)
v11.TitleLabel.BackgroundTransparency = 1
v11.TitleLabel.Text = "Singularity-Ninny.top"
v11.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
v11.TitleLabel.TextSize = 16
v11.TitleLabel.Font = Enum.Font.GothamBold
v11.TitleLabel.Parent = v11.TitleFrame

v11.TabButtonsFrame = Instance.new("Frame")
v11.TabButtonsFrame.Name = "TabButtonsFrame"
v11.TabButtonsFrame.Size = UDim2.new(1, -30, 0, 30)
v11.TabButtonsFrame.Position = UDim2.new(0, 15, 0, 45)
v11.TabButtonsFrame.BackgroundTransparency = 1
v11.TabButtonsFrame.Parent = v11.MainFrame

v11.TabButtonsLayout = Instance.new("UIListLayout")
v11.TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
v11.TabButtonsLayout.Padding = UDim.new(0, 5)
v11.TabButtonsLayout.Parent = v11.TabButtonsFrame

v11.ContentFrame = Instance.new("Frame")
v11.ContentFrame.Name = "ContentFrame"
v11.ContentFrame.Size = UDim2.new(1, -30, 1, -90)
v11.ContentFrame.Position = UDim2.new(0, 15, 0, 80)
v11.ContentFrame.BackgroundTransparency = 1
v11.ContentFrame.Parent = v11.MainFrame

v11.ESPSettingsFrame = Instance.new("ScrollingFrame")
v11.ESPSettingsFrame.Name = "ESPSettingsFrame"
v11.ESPSettingsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.ESPSettingsFrame.BackgroundTransparency = 1
v11.ESPSettingsFrame.ScrollBarThickness = 4
v11.ESPSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
v11.ESPSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.ESPSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.ESPSettingsFrame.Visible = true
v11.ESPSettingsFrame.Parent = v11.ContentFrame

v11.ESPColorsFrame = Instance.new("ScrollingFrame")
v11.ESPColorsFrame.Name = "ESPColorsFrame"
v11.ESPColorsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.ESPColorsFrame.BackgroundTransparency = 1
v11.ESPColorsFrame.ScrollBarThickness = 4
v11.ESPColorsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
v11.ESPColorsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.ESPColorsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.ESPColorsFrame.Visible = false
v11.ESPColorsFrame.Parent = v11.ContentFrame

v11.GameFeaturesFrame = Instance.new("ScrollingFrame")
v11.GameFeaturesFrame.Name = "GameFeaturesFrame"
v11.GameFeaturesFrame.Size = UDim2.new(1, 0, 1, 0)
v11.GameFeaturesFrame.BackgroundTransparency = 1
v11.GameFeaturesFrame.ScrollBarThickness = 4
v11.GameFeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
v11.GameFeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.GameFeaturesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.GameFeaturesFrame.Visible = false
v11.GameFeaturesFrame.Parent = v11.ContentFrame

v11.VisualSettingsFrame = Instance.new("ScrollingFrame")
v11.VisualSettingsFrame.Name = "VisualSettingsFrame"
v11.VisualSettingsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.VisualSettingsFrame.BackgroundTransparency = 1
v11.VisualSettingsFrame.ScrollBarThickness = 4
v11.VisualSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
v11.VisualSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.VisualSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.VisualSettingsFrame.Visible = false
v11.VisualSettingsFrame.Parent = v11.ContentFrame

v11.ESPLayout = Instance.new("UIListLayout")
v11.ESPLayout.Padding = UDim.new(0, 15)
v11.ESPLayout.Parent = v11.ESPSettingsFrame

v11.ColorsLayout = Instance.new("UIListLayout")
v11.ColorsLayout.Padding = UDim.new(0, 15)
v11.ColorsLayout.Parent = v11.ESPColorsFrame

v11.FeaturesLayout = Instance.new("UIListLayout")
v11.FeaturesLayout.Padding = UDim.new(0, 15)
v11.FeaturesLayout.Parent = v11.GameFeaturesFrame

v11.VisualLayout = Instance.new("UIListLayout")
v11.VisualLayout.Padding = UDim.new(0, 15)
v11.VisualLayout.Parent = v11.VisualSettingsFrame

v11._lastGeneratorCheck = 0
v11._lastPalletCheck = 0
v11.AutoRefreshConnection = nil
v11.ThirdPersonEnabled = false
v11.ThirdPersonConnection = nil
v11.OriginalCameraType = nil
v11.RotatePersonEnabled = false
v11.RotateSpeed = 100
v11.RotateConnection = nil
v11.MenuOpen = true
v11.ESPEnabled = false
v11.GeneratorESPEnabled = false
v11.PalletESPEnabled = false
v11.SuperESPEnabled = false
v11.AutoUpdateEnabled = true
v11.MapLoaded = false
v11.GameStarted = false
v11.CrosshairEnabled = false
v11.walkSpeedActive = false
v11.walkSpeed = 16
v11.JumpPowerEnabled = false
v11.JumpPowerValue = 50
v11.JumpPowerConnection = nil
v11.FlyEnabled = false
v11.FlySpeedValue = 50
v11.NoclipEnabled = false
v11.NoclipConnection = nil
v11.NoclipCharacterConnection = nil
v11.GodModeEnabled = false
v11.InvisibleEnabled = false
v11.AntiStunEnabled = false
v11.AntiGrabEnabled = false
v11.MaxEscapeChanceEnabled = false
v11.GrabKillerEnabled = false
v11.RapidFireEnabled = false
v11.DisableTwistAnimationsEnabled = false
v11.NoFogEnabled = false
v11.TimeEnabled = false
v11.TimeValue = 12
v11.MapColorEnabled = false
v11.MapColor = Color3.fromRGB(255, 255, 255)
v11.MapColorSaturation = 1
v11.SurvivorColor = Color3.fromRGB(0, 255, 0)
v11.KillerColor = Color3.fromRGB(255, 0, 0)
v11.GeneratorColor = Color3.fromRGB(0, 100, 255)
v11.PalletColor = Color3.fromRGB(255, 255, 0)
v11.RGBESPEnabled = false
v11.RGBESPSpeed = 1
v11.SuperESPSpeed = 1
v11.AimbotEnabled = false
v11.AimbotConnection = nil
v11.AimbotTarget = nil
v11.AimbotFOV = 50
v11.AimbotSmoothness = 10
v11.AimbotTeamCheck = true
v11.AimbotVisibleCheck = true
v11.AimbotKey = Enum.UserInputType.MouseButton2
v11.AimbotWallCheck = false
v11.TeleportEnabled = false
v11.TeleportFrame = nil
v11.TeleportPlayersFrame = nil
v11.TeleportPlayers = {}
v11.Flying = false
v11.BodyVelocity = nil
v11.BodyGyro = nil
v11.FlyConnection = nil
v11.NoclipConnection = nil
v11.GodModeConnection = nil
v11.AntiStunConnection = nil
v11.AntiGrabConnection = nil
v11.EscapeChanceConnection = nil
v11.GrabKillerConnection = nil
v11.RapidFireConnection = nil
v11.AutoRefreshConnection = nil
v11.TwistAnimationsConnection = nil
v11.NoFogConnection = nil
v11.TimeConnection = nil
v11.MapColorConnection = nil
v11.RGBESPConnection = nil
v11.SuperESPConnection = nil
v11.ESPFolders = {}
v11.ESPConnections = {}
v11.GeneratorESPItems = {}
v11.PalletESPItems = {}

v11.CrosshairFrame = Instance.new("Frame")
v11.CrosshairFrame.Name = "Sishka52Crosshair"
v11.CrosshairFrame.Size = UDim2.new(0, 20, 0, 20)
v11.CrosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
v11.CrosshairFrame.BackgroundTransparency = 1
v11.CrosshairFrame.Visible = false
v11.CrosshairFrame.ZIndex = 1000
v11.CrosshairFrame.Parent = v11.ScreenGui

v11.CrosshairDot = Instance.new("Frame")
v11.CrosshairDot.Name = "CrosshairDot"
v11.CrosshairDot.Size = UDim2.new(0, 4, 0, 4)
v11.CrosshairDot.Position = UDim2.new(0.5, -2, 0.5, -2)
v11.CrosshairDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
v11.CrosshairDot.BorderSizePixel = 0
v11.CrosshairDot.Parent = v11.CrosshairFrame

v11.CrosshairCorner = Instance.new("UICorner")
v11.CrosshairCorner.CornerRadius = UDim.new(0, 2)
v11.CrosshairCorner.Parent = v11.CrosshairDot

v11.AimbotFOVCircle = Instance.new("Frame")
v11.AimbotFOVCircle.Name = "Sishka52FOVCircle"
v11.AimbotFOVCircle.Size = UDim2.new(0, v11.AimbotFOV, 0, v11.AimbotFOV)
v11.AimbotFOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
v11.AimbotFOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
v11.AimbotFOVCircle.BackgroundTransparency = 1
v11.AimbotFOVCircle.BorderSizePixel = 2
v11.AimbotFOVCircle.BorderColor3 = Color3.fromRGB(255, 0, 0)
v11.AimbotFOVCircle.Visible = false
v11.AimbotFOVCircle.Parent = v11.ScreenGui

local v240 = Instance.new("UICorner")
v240.CornerRadius = UDim.new(1, 0)
v240.Parent = v11.AimbotFOVCircle

v11.PlayerAddedConnection = nil
v11.MapChecker = nil
v11.GameStartChecker = nil
v11.GameStateChecker = nil
v11.LastGameState = ""
v11.AimbotFunctions = {}
v11.ESPFunctions = {}
v11.MovementFunctions = {}

v11.AimbotFunctions.isPlayerVisible = function(v368)
    if not v11.AimbotWallCheck then
        return true
    end
    
    local v369 = v368.Character
    if not v369 then
        return false
    end
    
    local v370 = v369:FindFirstChild("Head")
    if not v370 then
        return false
    end
    
    local v371 = v6.CurrentCamera
    local v372 = v371.CFrame.Position
    local v373 = (v370.Position - v372).Unit
    local v374 = (v370.Position - v372).Magnitude
    
    local v375 = RaycastParams.new()
    v375.FilterDescendantsInstances = {v9.Character, v369}
    v375.FilterType = Enum.RaycastFilterType.Blacklist
    v375.IgnoreWater = true
    
    local v380 = v6:Raycast(v372, v373 * v374, v375)
    return v380 == nil
end

v11.AimbotFunctions.findClosestPlayer = function()
    local v381 = nil
    local v382 = v11.AimbotFOV
    local v383 = v6.CurrentCamera
    
    for v1058, v1059 in pairs(v0:GetPlayers()) do
        if v1059 ~= v9 and v1059.Character then
            if v11.AimbotTeamCheck and not v11.IsPlayerKiller(v1059) then
                continue
            end
            
            local v1325 = v1059.Character:FindFirstChild("Head")
            if v1325 then
                local v1467, v1468 = v383:WorldToViewportPoint(v1325.Position)
                if v1468 then
                    if v11.AimbotVisibleCheck and not v11.AimbotFunctions.isPlayerVisible(v1059) then
                        continue
                    end
                    
                    local v1541 = Vector2.new(v383.ViewportSize.X / 2, v383.ViewportSize.Y / 2)
                    local v1542 = Vector2.new(v1467.X, v1467.Y)
                    local v1543 = (v1541 - v1542).Magnitude
                    
                    if v1543 < v382 then
                        v382 = v1543
                        v381 = v1059
                    end
                end
            end
        end
    end
    
    return v381
end

v11.AimbotFunctions.aimAt = function(v384)
    if not v384 or not v384.Character then
        return
    end
    
    local v385 = v384.Character:FindFirstChild("Head")
    if not v385 then
        return
    end
    
    local v386 = v6.CurrentCamera
    local v387 = v386.CFrame.Position
    local v388 = v385.Position
    local v389 = CFrame.lookAt(v387, v388)
    local v390 = (100 - v11.AimbotSmoothness) / 100
    
    v386.CFrame = v386.CFrame:Lerp(v389, v390)
end

v11.AimbotFunctions.updateAimbotUI = function()
    if v11.AimbotEnabled then
        v11.AimbotFOVCircle.Visible = true
    else
        v11.AimbotFOVCircle.Visible = false
    end
    
    v11.AimbotFOVCircle.Size = UDim2.new(0, v11.AimbotFOV, 0, v11.AimbotFOV)
end

v11.AimbotFunctions.setupAimbotSlider = function(v393, v394, v395, v396)
    v393.MouseButton1Down:Connect(function()
        local v1060
        v1060 = v1.RenderStepped:Connect(function()
            if not v2:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                v1060:Disconnect()
                return
            end
            
            local v1230 = v2:GetMouseLocation()
            local v1231 = v393.AbsolutePosition
            local v1232 = v393.AbsoluteSize.X
            local v1233 = (v1230.X - v1231.X) / v1232
            local v1234 = v394 + ((v395 - v394) * math.clamp(v1233, 0, 1))
            v396(math.floor(v1234))
        end)
    end)
end

v11.AimbotFunctions.toggleAimbot = function()
    v11.AimbotEnabled = not v11.AimbotEnabled
    v11.AimbotFunctions.updateAimbotUI()
    print("Aimbot: " .. (v11.AimbotEnabled and "ENABLED" or "DISABLED"))
end

v11.AimbotFunctions.startAimbot = function()
    if v11.AimbotConnection then
        v11.AimbotConnection:Disconnect()
    end
    
    v11.AimbotConnection = v1.RenderStepped:Connect(function()
        if v11.AimbotEnabled then
            local v1326 = v11.AimbotFunctions.findClosestPlayer()
            if v1326 then
                v11.AimbotFunctions.aimAt(v1326)
            end
        end
    end)
end

v11.AimbotFunctions.stopAimbot = function()
    if v11.AimbotConnection then
        v11.AimbotConnection:Disconnect()
        v11.AimbotConnection = nil
    end
end

v11.ToggleAimbot = function(v399)
    v11.AimbotEnabled = v399
    
    if v399 then
        v11.AimbotFunctions.startAimbot()
        print("Aimbot: ENABLED")
    else
        v11.AimbotFunctions.stopAimbot()
        print("Aimbot: DISABLED")
    end
    
    v11.AimbotFunctions.updateAimbotUI()
end

v11.UpdateAimbotFOV = function(v401)
    v11.AimbotFOV = v401
    v11.AimbotFunctions.updateAimbotUI()
    print("Aimbot FOV: " .. v401)
end

v11.UpdateAimbotSmoothness = function(v403)
    v11.AimbotSmoothness = v403
    print("Aimbot Smoothness: " .. v403)
end

v11.ToggleAimbotTeamCheck = function(v405)
    v11.AimbotTeamCheck = v405
    print("Aimbot Team Check: " .. (v405 and "ENABLED" or "DISABLED"))
end

v11.ToggleAimbotVisibleCheck = function(v407)
    v11.AimbotVisibleCheck = v407
    print("Aimbot Visible Check: " .. (v407 and "ENABLED" or "DISABLED"))
end

v11.ToggleAimbotWallCheck = function(v409)
    v11.AimbotWallCheck = v409
    print("Aimbot Wall Check: " .. (v409 and "ENABLED" or "DISABLED"))
end

v11.MovementFunctions.UpdateJumpPowerValue = function(v411)
    v11.JumpPowerValue = v411
    print("JumpPower value changed to: " .. v411)
    
    if v11.JumpPowerEnabled then
        v11.UpdateJumpPower()
    end
end

v11.CreateTabButton = function(v413, v414)
    local v415 = Instance.new("TextButton")
    v415.Name = v413 .. "Tab"
    v415.Size = UDim2.new(0.25, -5, 1, 0)
    v415.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    v415.BorderSizePixel = 0
    v415.Text = v413
    v415.TextColor3 = Color3.fromRGB(200, 200, 200)
    v415.TextSize = 12
    v415.Font = Enum.Font.GothamBold
    v415.Parent = v11.TabButtonsFrame
    
    local v427 = Instance.new("UICorner")
    v427.CornerRadius = UDim.new(0, 6)
    v427.Parent = v415
    
    v415.MouseButton1Click:Connect(function()
        v11.ESPSettingsFrame.Visible = false
        v11.ESPColorsFrame.Visible = false
        v11.GameFeaturesFrame.Visible = false
        v11.VisualSettingsFrame.Visible = false
        v414.Visible = true
        
        for v1236, v1237 in ipairs(v11.TabButtonsFrame:GetChildren()) do
            if v1237:IsA("TextButton") then
                v1237.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                v1237.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        v415.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        v415.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return v415
end

v11.ESPTab = v11.CreateTabButton("ESP", v11.ESPSettingsFrame)
v11.ColorsTab = v11.CreateTabButton("ESP COLORS", v11.ESPColorsFrame)
v11.FeaturesTab = v11.CreateTabButton("FEATURES", v11.GameFeaturesFrame)
v11.VisualTab = v11.CreateTabButton("VISUAL", v11.VisualSettingsFrame)

v11.ESPTab.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
v11.ESPTab.TextColor3 = Color3.fromRGB(255, 255, 255)

v11.MovementFunctions.ToggleJumpPower = function(v430)
    v11.JumpPowerEnabled = v430
    
    if v11.JumpPowerConnection then
        v11.JumpPowerConnection:Disconnect()
        v11.JumpPowerConnection = nil
    end
    
    if v430 then
        print("Enabling JumpPower...")
        v11.UpdateJumpPower()
        
        v11.JumpPowerConnection = v9.CharacterAdded:Connect(function(v1327)
            print("New character detected, applying JumpPower...")
            
            for v1409 = 1, 3 do
                wait(1)
                v11.UpdateJumpPower()
            end
            
            local v1328 = v1327:WaitForChild("Humanoid", 5)
            if v1328 then
                v1328:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if v11.JumpPowerEnabled and v1328.JumpPower ~= v11.JumpPowerValue then
                        v1328.JumpPower = v11.JumpPowerValue
                        print("JumpPower corrected: " .. v11.JumpPowerValue)
                    end
                end)
                
                while v11.JumpPowerEnabled and v1327 and v1328 do
                    wait(2)
                    if v1328.JumpPower ~= v11.JumpPowerValue then
                        v1328.JumpPower = v11.JumpPowerValue
                        print("JumpPower force updated: " .. v11.JumpPowerValue)
                    end
                end
            end
        end)
        
        coroutine.wrap(function()
            while v11.JumpPowerEnabled do
                wait(3)
                v11.UpdateJumpPower()
            end
        end)()
    else
        local v1240 = v9.Character
        if v1240 then
            local v1410 = v1240:FindFirstChildOfClass("Humanoid")
            if v1410 then
                v1410.JumpPower = 50
            end
        end
        
        print("JumpPower: DISABLED")
    end
end

v11.UnlockCursor = function()
    pcall(function()
        v2.MouseIconEnabled = true
        if not v11.FlyEnabled then
            v2.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
end

v11.GetPlayerRole = function(v432)
    if not v432 or v432 == v9 then
        return "Unknown"
    end
    
    if v11._cache.roleCache and v11._cache.roleCache[v432] and (tick() - (v11._cache.roleCacheTime or 0)) < 2 then
        return v11._cache.roleCache[v432]
    end
    
    v11._cache.roleCache = v11._cache.roleCache or {}
    v11._cache.roleCacheTime = tick()
    local v435 = "Unknown"
    
    pcall(function()
        if v432.Team then
            local v1331 = string.lower(v432.Team.Name)
            if v1331 == "spectator" or v1331 == "spectators" then
                v435 = "Spectator"
                v11._cache.roleCache[v432] = v435
                return
            elseif v1331 == "killer" or v1331 == "murderer" or v1331 == "hunter" then
                v435 = "Killer"
                v11._cache.roleCache[v432] = v435
                return
            elseif v1331 == "survivor" or v1331 == "civilian" or v1331 == "victim" then
                v435 = "Survivor"
                v11._cache.roleCache[v432] = v435
                return
            end
        end
        
        local v1069 = v432:FindFirstChild("leaderstats")
        if v1069 then
            local v1332 = v1069:FindFirstChild("Role") or v1069:FindFirstChild("Team") or v1069:FindFirstChild("Class")
            if v1332 then
                local v1470 = string.lower(tostring(v1332.Value))
                if string.find(v1470, "spectator") then
                    v435 = "Spectator"
                elseif string.find(v1470, "killer") or string.find(v1470, "murderer") or string.find(v1470, "hunter") then
                    v435 = "Killer"
                elseif string.find(v1470, "survivor") or string.find(v1470, "civilian") then
                    v435 = "Survivor"
                end
                v11._cache.roleCache[v432] = v435
                return
            end
        end
        
        if v11.GameStarted then
            local function v1333(v1411)
                if not v1411 then
                    return false
                end
                
                local v1412 = {"knife", "axe", "gun", "katana", "sword", "murder", "killer", "weapon"}
                for v1472, v1473 in pairs(v1411:GetChildren()) do
                    if v1473:IsA("Tool") then
                        local v1545 = string.lower(v1473.Name)
                        for v1569, v1570 in ipairs(v1412) do
                            if string.find(v1545, v1570) then
                                return true
                            end
                        end
                    end
                end
                return false
            end
            
            local v1334 = v432:FindFirstChild("Backpack")
            local v1335 = v432.Character
            
            if v1334 and v1333(v1334) then
                v435 = "Killer"
            elseif v1335 and v1333(v1335) then
                v435 = "Killer"
            else
                v435 = "Survivor"
            end
        else
            v435 = "Survivor"
        end
        
        v11._cache.roleCache[v432] = v435
    end)
    
    return v435
end

v11.IsPlayerSpectator = function(v436)
    return v11.GetPlayerRole(v436) == "Spectator"
end

v11.IsPlayerKiller = function(v437)
    return v11.GetPlayerRole(v437) == "Killer"
end

v11.IsPlayerSurvivor = function(v438)
    return v11.GetPlayerRole(v438) == "Survivor"
end

v11.IsValidPlayerForESP = function(v439)
    if not v439 then
        return false
    end
    
    if v439 == v9 then
        return false
    end
    
    if v11.IsPlayerSpectator(v439) then
        return false
    end
    
    if not v11.GameStarted then
        return false
    end
    
    return true
end

v11.CheckGameStarted = function()
    local v440, v441 = pcall(function()
        v11._cache.roleCache = {}
        local v1072 = 0
        local v1073 = false
        local v1074 = false
        
        for v1241, v1242 in pairs(v0:GetPlayers()) do
            if v1242 ~= v9 then
                local v1413 = v11.GetPlayerRole(v1242)
                if v1413 == "Killer" then
                    v1073 = true
                    v1072 = v1072 + 1
                elseif v1413 == "Survivor" then
                    v1074 = true
                    v1072 = v1072 + 1
                end
            end
        end
        
        return (v1073 and v1074) or (v1072 >= 2 and v11.MapLoaded)
    end)
    
    return (v440 and v441) or false
end

v11.CheckMapLoaded = function()
    local v442, v443 = pcall(function()
        local v1075 = {"Generators", "Generator", "Pallets", "Pallet", "Exit", "Doors", "GameArea", "Map"}
        for v1243, v1244 in ipairs(v1075) do
            if v6:FindFirstChild(v1244) then
                return true
            end
        end
        
        for v1245, v1246 in pairs(v0:GetPlayers()) do
            if v1246 ~= v9 then
                local v1414 = v11.GetPlayerRole(v1246)
                if v1414 ~= "Spectator" and v1414 ~= "Unknown" then
                    return true
                end
            end
        end
        
        return false
    end)
    
    return (v442 and v443) or false
end

v11.CreateESP = function(v444)
    if not v11.IsValidPlayerForESP(v444) then
        v11.RemoveESP(v444)
        return
    end
    
    if v11.ESPFolders[v444] then
        if v11.ESPFolders[v444].Parent then
            return
        else
            v11.ESPFolders[v444] = nil
        end
    end
    
    local function v445(v1076)
        if not v1076 or not v1076.Parent then
            v11.RemoveESP(v444)
            return
        end
        
        local v1077 = v1076:WaitForChild("HumanoidRootPart", 3)
        local v1078 = v1076:WaitForChild("Humanoid", 3)
        
        if not v1077 or not v1078 then
            v11.RemoveESP(v444)
            return
        end
        
        if not v11.IsValidPlayerForESP(v444) then
            v11.RemoveESP(v444)
            return
        end
        
        local v1079 = v11.GetPlayerRole(v444)
        local v1080 = v1079 == "Killer" and v11.KillerColor or v11.SurvivorColor
        local v1081 = v1079 == "Killer" and "KILLER" or "SURVIVOR"
        
        local v1082 = Instance.new("Folder")
        v1082.Name = v444.Name .. "_ESP"
        v1082.Parent = v11.ScreenGui
        
        local v1086 = Instance.new("Highlight")
        v1086.Name = "ESPHighlight"
        v1086.Adornee = v1076
        v1086.FillColor = v1080
        v1086.FillTransparency = 0.3
        v1086.OutlineColor = v1080
        v1086.OutlineTransparency = 0
        v1086.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v1086.Parent = v1082
        
        local v1096 = Instance.new("BillboardGui")
        v1096.Name = "ESPBillboard"
        v1096.Adornee = v1077
        v1096.Size = UDim2.new(0, 200, 0, 30)
        v1096.StudsOffset = Vector3.new(0, 3.5, 0)
        v1096.AlwaysOnTop = true
        v1096.Enabled = true
        v1096.Parent = v1082
        
        local v1104 = Instance.new("TextLabel")
        v1104.Name = "ESPName"
        v1104.Size = UDim2.new(1, 0, 1, 0)
        v1104.BackgroundTransparency = 1
        v1104.Text = v444.Name .. " [" .. v1081 .. "]"
        v1104.TextColor3 = v1080
        v1104.TextSize = 14
        v1104.Font = Enum.Font.GothamBold
        v1104.TextStrokeColor3 = Color3.new(0, 0, 0)
        v1104.TextStrokeTransparency = 0.3
        v1104.Parent = v1096
        
        v11.ESPFolders[v444] = v1082
        
        local v1117 = {}
        v1117.died = v1078.Died:Connect(function()
            v11.RemoveESP(v444)
        end)
        
        v1117.characterRemoving = v1076.AncestryChanged:Connect(function(v1247, v1248)
            if not v1248 then
                v11.RemoveESP(v444)
            end
        end)
        
        v11.ESPConnections[v444] = v1117
    end
    
    if v444.Character then
        v445(v444.Character)
    end
    
    local v446 = v444.CharacterAdded:Connect(function(v1121)
        wait(2)
        if v11.IsValidPlayerForESP(v444) then
            v445(v1121)
        else
            v11.RemoveESP(v444)
        end
    end)
    
    v11.ESPConnections[v444] = v11.ESPConnections[v444] or {}
    v11.ESPConnections[v444].character = v446
end

v11.RemoveESP = function(v449)
    if not v449 then
        return
    end
    
    if v11.ESPConnections[v449] then
        for v1336, v1337 in pairs(v11.ESPConnections[v449]) do
            if v1337 then
                v1337:Disconnect()
            end
        end
        v11.ESPConnections[v449] = nil
    end
    
    if v11.ESPFolders[v449] then
        pcall(function()
            v11.ESPFolders[v449]:Destroy()
        end)
        v11.ESPFolders[v449] = nil
    end
end

v11.ClearAllESP = function()
    print("Clearing all ESP...")
    for v1122, v1123 in pairs(v11.ESPFolders) do
        v11.RemoveESP(v1122)
    end
    
    for v1124, v1125 in pairs(v11.GeneratorESPItems) do
        v11.RemoveGeneratorESP(v1124)
    end
    
    for v1126, v1127 in pairs(v11.PalletESPItems) do
        v11.RemovePalletESP(v1126)
    end
    
    v11.ESPFolders = {}
    v11.GeneratorESPItems = {}
    v11.PalletESPItems = {}
    v11.ESPConnections = {}
    print("All ESP cleared!")
end

v11.UpdateESP = function()
    for v1128, v1129 in pairs(v11.ESPFolders) do
        if not v11.IsValidPlayerForESP(v1128) or not v1129 or not v1129.Parent then
            v11.RemoveESP(v1128)
        end
    end
    
    for v1130, v1131 in pairs(v11.ESPFolders) do
        if v1130 and v1131 and v1131.Parent and v1130.Character then
            local v1338 = v11.GetPlayerRole(v1130)
            local v1339 = v1338 == "Killer" and v11.KillerColor or v11.SurvivorColor
            local v1340 = v1338 == "Killer" and "KILLER" or "SURVIVOR"
            
            local v1341 = v1131:FindFirstChild("ESPHighlight")
            local v1342 = v1131:FindFirstChild("ESPBillboard")
            
            if v1341 then
                v1341.FillColor = v1339
                v1341.OutlineColor = v1339
            end
            
            if v1342 then
                local v1476 = v1342:FindFirstChild("ESPName")
                if v1476 then
                    v1476.TextColor3 = v1339
                    v1476.Text = v1130.Name .. " [" .. v1340 .. "]"
                end
            end
        else
            v11.RemoveESP(v1130)
        end
    end
end

v11.OnGameStateChanged = function()
    if not v11.GameStarted then
        v11.ClearAllESP()
    elseif v11.ESPEnabled then
        v11.ForceUpdateAllESP()
    end
end

v11.StartGameCheckers = function()
    if v11.MapChecker then
        v11.MapChecker:Disconnect()
    end
    
    if v11.GameStartChecker then
        v11.GameStartChecker:Disconnect()
    end
    
    local v454 = v11.GameStarted
    
    v11.GameStartChecker = v1.Heartbeat:Connect(function()
        if tick() - (v11._cache.lastGameCheck or 0) > 3 then
            v11._cache.lastGameCheck = tick()
            
            local v1344 = v11.CheckMapLoaded()
            if v1344 ~= v11.MapLoaded then
                v11.MapLoaded = v1344
                print("Map state changed: " .. tostring(v11.MapLoaded))
            end
            
            local v1345 = v11.CheckGameStarted()
            if v1345 ~= v11.GameStarted then
                v11.GameStarted = v1345
                print("Game state changed: " .. tostring(v11.GameStarted))
                v11._cache.roleCache = {}
                v11.OnGameStateChanged()
            end
        end
    end)
end

v11.CreateToggle = function(v456, v457, v458, v459)
    local v460 = Instance.new("Frame")
    v460.Name = v456 .. "Toggle"
    v460.Size = UDim2.new(1, 0, 0, 40)
    v460.Position = UDim2.new(0, 0, 0, 0)
    v460.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    v460.BorderSizePixel = 0
    v460.Parent = v459
    
    local v467 = Instance.new("UICorner")
    v467.CornerRadius = UDim.new(0, 8)
    v467.Parent = v460
    
    local v470 = Instance.new("TextLabel")
    v470.Name = "ToggleLabel"
    v470.Size = UDim2.new(0.7, 0, 1, 0)
    v470.Position = UDim2.new(0, 15, 0, 0)
    v470.BackgroundTransparency = 1
    v470.Text = v456
    v470.TextColor3 = Color3.fromRGB(255, 255, 255)
    v470.TextSize = 14
    v470.Font = Enum.Font.Gotham
    v470.TextXAlignment = Enum.TextXAlignment.Left
    v470.Parent = v460
    
    local v483 = Instance.new("TextButton")
    v483.Name = "ToggleButton"
    v483.Size = UDim2.new(0, 50, 0, 25)
    v483.Position = UDim2.new(1, -65, 0.5, -12.5)
    v483.BackgroundColor3 = v457 and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
    v483.BorderSizePixel = 0
    v483.Text = ""
    v483.Parent = v460
    
    local v491 = Instance.new("UICorner")
    v491.CornerRadius = UDim.new(0, 12)
    v491.Parent = v483
    
    local v494 = Instance.new("Frame")
    v494.Name = "ToggleDot"
    v494.Size = UDim2.new(0, 21, 0, 21)
    v494.Position = UDim2.new(0, v457 and 29 or 2, 0, 2)
    v494.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v494.BorderSizePixel = 0
    v494.Parent = v483
    
    local v501 = Instance.new("UICorner")
    v501.CornerRadius = UDim.new(0, 10)
    v501.Parent = v494
    
    v483.MouseButton1Click:Connect(function()
        v457 = not v457
        v483.BackgroundColor3 = v457 and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        
        local v1133 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1134 = v3:Create(v494, v1133, {Position = UDim2.new(0, v457 and 29 or 2, 0, 2)})
        v1134:Play()
        v458(v457)
    end)
    
    return v460
end

v11.CreateSlider = function(v504, v505, v506, v507, v508, v509)
    local v510 = Instance.new("Frame")
    v510.Name = v504 .. "Slider"
    v510.Size = UDim2.new(1, 0, 0, 60)
    v510.Position = UDim2.new(0, 0, 0, 0)
    v510.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    v510.BorderSizePixel = 0
    v510.Parent = v509
    
    local v517 = Instance.new("UICorner")
    v517.CornerRadius = UDim.new(0, 8)
    v517.Parent = v510
    
    local v520 = Instance.new("TextLabel")
    v520.Name = "SliderLabel"
    v520.Size = UDim2.new(1, -30, 0, 20)
    v520.Position = UDim2.new(0, 15, 0, 5)
    v520.BackgroundTransparency = 1
    v520.Text = v504 .. ": " .. v507
    v520.TextColor3 = Color3.fromRGB(255, 255, 255)
    v520.TextSize = 14
    v520.Font = Enum.Font.Gotham
    v520.TextXAlignment = Enum.TextXAlignment.Left
    v520.Parent = v510
    
    local v533 = Instance.new("Frame")
    v533.Name = "SliderTrack"
    v533.Size = UDim2.new(1, -30, 0, 6)
    v533.Position = UDim2.new(0, 15, 0, 35)
    v533.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    v533.BorderSizePixel = 0
    v533.Parent = v510
    
    local v540 = Instance.new("UICorner")
    v540.CornerRadius = UDim.new(0, 3)
    v540.Parent = v533
    
    local v543 = Instance.new("Frame")
    v543.Name = "SliderFill"
    v543.Size = UDim2.new((v507 - v505) / (v506 - v505), 0, 1, 0)
    v543.Position = UDim2.new(0, 0, 0, 0)
    v543.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    v543.BorderSizePixel = 0
    v543.Parent = v533
    
    local v550 = Instance.new("UICorner")
    v550.CornerRadius = UDim.new(0, 3)
    v550.Parent = v543
    
    local v553 = Instance.new("TextButton")
    v553.Name = "SliderButton"
    v553.Size = UDim2.new(0, 20, 0, 20)
    v553.Position = UDim2.new((v507 - v505) / (v506 - v505), -10, 0.5, -10)
    v553.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v553.BorderSizePixel = 0
    v553.Text = ""
    v553.ZIndex = 2
    v553.Parent = v533
    
    local v562 = Instance.new("UICorner")
    v562.CornerRadius = UDim.new(0, 10)
    v562.Parent = v553
    
    local v565 = false
    
    local function v566(v1135)
        if not v565 then
            return
        end
        
        local v1136 = math.clamp((v1135.Position.X - v533.AbsolutePosition.X) / v533.AbsoluteSize.X, 0, 1)
        local v1137 = math.floor(v505 + ((v506 - v505) * v1136))
        
        if v543 and v553 then
            v543.Size = UDim2.new(v1136, 0, 1, 0)
            v553.Position = UDim2.new(v1136, -10, 0.5, -10)
        end
        
        if v520 then
            v520.Text = v504 .. ": " .. v1137
        end
        
        v508(v1137)
    end
    
    v553.InputBegan:Connect(function(v1138)
        if v1138.UserInputType == Enum.UserInputType.MouseButton1 then
            v565 = true
        end
    end)
    
    v533.InputBegan:Connect(function(v1139)
        if v1139.UserInputType == Enum.UserInputType.MouseButton1 then
            v565 = true
            v566(v1139)
        end
    end)
    
    v2.InputChanged:Connect(function(v1140)
        if v565 and v1140.UserInputType == Enum.UserInputType.MouseMovement then
            v566(v1140)
        end
    end)
    
    v2.InputEnded:Connect(function(v1141)
        if v1141.UserInputType == Enum.UserInputType.MouseButton1 then
            v565 = false
        end
    end)
    
    return v510
end

v11.CreateButton = function(v567, v568, v569)
    local v570 = Instance.new("Frame")
    v570.Name = v567 .. "Button"
    v570.Size = UDim2.new(1, 0, 0, 40)
    v570.Position = UDim2.new(0, 0, 0, 0)
    v570.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    v570.BorderSizePixel = 0
    v570.Parent = v569
    
    local v577 = Instance.new("UICorner")
    v577.CornerRadius = UDim.new(0, 8)
    v577.Parent = v570
    
    local v580 = Instance.new("TextButton")
    v580.Name = "Button"
    v580.Size = UDim2.new(1, -30, 1, -10)
    v580.Position = UDim2.new(0, 15, 0, 5)
    v580.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    v580.BorderSizePixel = 0
    v580.Text = v567
    v580.TextColor3 = Color3.fromRGB(255, 255, 255)
    v580.TextSize = 14
    v580.Font = Enum.Font.GothamBold
    v580.Parent = v570
    
    local v592 = Instance.new("UICorner")
    v592.CornerRadius = UDim.new(0, 6)
    v592.Parent = v580
    
    v580.MouseButton1Click:Connect(function()
        v568()
    end)
    
    return v580
end

v11.HSVToRGB = function(v595, v596, v597)
    v595 = v595 % 1
    local v598 = math.floor(v595 * 6)
    local v599 = v595 * 6 - v598
    local v600 = v597 * (1 - v596)
    local v601 = v597 * (1 - (v599 * v596))
    local v602 = v597 * (1 - ((1 - v599) * v596))
    
    if v598 == 0 then
        return Color3.new(v597, v602, v600)
    elseif v598 == 1 then
        return Color3.new(v601, v597, v600)
    elseif v598 == 2 then
        return Color3.new(v600, v597, v602)
    elseif v598 == 3 then
        return Color3.new(v600, v601, v597)
    elseif v598 == 4 then
        return Color3.new(v602, v600, v597)
    else
        return Color3.new(v597, v600, v601)
    end
end

v11.RGBToHSV = function(v603)
    local v604, v605, v606 = v603.R, v603.G, v603.B
    local v607 = math.max(v604, v605, v606)
    local v608 = math.min(v604, v605, v606)
    local v609, v610, v611
    v611 = v607
    local v612 = v607 - v608
    
    if v607 == 0 then
        v610 = 0
    else
        v610 = v612 / v607
    end
    
    if v607 == v608 then
        v609 = 0
    else
        if v607 == v604 then
            v609 = (v605 - v606) / v612
            if v605 < v606 then
                v609 = v609 + 6
            end
        elseif v607 == v605 then
            v609 = ((v606 - v604) / v612) + 2
        elseif v607 == v606 then
            v609 = ((v604 - v605) / v612) + 4
        end
        v609 = v609 / 6
    end
    
    return v609, v610, v611
end

v11.GetRainbowColor = function(v613, v614)
    local v615 = (tick() * v614) % 1
    return v11.HSVToRGB(v615, 1, 1)
end

v11.GetSuperESPColor = function(v616, v617, v618)
    local v619, v620, v621 = v11.RGBToHSV(v616)
    local v622 = (v619 + (v617 * v618)) % 1
    return v11.HSVToRGB(v622, v620, v621)
end

v11.CreateHSVColorPicker = function(v623, v624, v625, v626)
    local v627 = v624
    local v628, v629, v630 = v11.RGBToHSV(v624)
    
    local v631 = Instance.new("Frame")
    v631.Name = v623 .. "Color"
    v631.Size = UDim2.new(1, 0, 0, 40)
    v631.Position = UDim2.new(0, 0, 0, 0)
    v631.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    v631.BorderSizePixel = 0
    v631.Parent = v626
    
    local v638 = Instance.new("UICorner")
    v638.CornerRadius = UDim.new(0, 8)
    v638.Parent = v631
    
    local v641 = Instance.new("TextLabel")
    v641.Name = "ColorLabel"
    v641.Size = UDim2.new(0.6, 0, 1, 0)
    v641.Position = UDim2.new(0, 15, 0, 0)
    v641.BackgroundTransparency = 1
    v641.Text = v623
    v641.TextColor3 = Color3.fromRGB(255, 255, 255)
    v641.TextSize = 14
    v641.Font = Enum.Font.Gotham
    v641.TextXAlignment = Enum.TextXAlignment.Left
    v641.Parent = v631
    
    local v654 = Instance.new("TextButton")
    v654.Name = "ColorButton"
    v654.Size = UDim2.new(0, 60, 0, 30)
    v654.Position = UDim2.new(1, -75, 0.5, -15)
    v654.BackgroundColor3 = v624
    v654.BorderSizePixel = 0
    v654.Text = "Pick"
    v654.TextColor3 = Color3.fromRGB(255, 255, 255)
    v654.TextSize = 12
    v654.Font = Enum.Font.GothamBold
    v654.Parent = v631
    
    local v666 = Instance.new("UICorner")
    v666.CornerRadius = UDim.new(0, 6)
    v666.Parent = v654
    
    local v669 = Instance.new("Frame")
    v669.Name = v623 .. "ColorPicker"
    v669.Size = UDim2.new(0, 300, 0, 200)
    v669.Position = UDim2.new(0.5, -150, 0.5, -100)
    v669.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    v669.BorderSizePixel = 0
    v669.Visible = false
    v669.ZIndex = 100
    v669.Parent = v11.ScreenGui
    
    local v679 = Instance.new("UICorner")
    v679.CornerRadius = UDim.new(0, 12)
    v679.Parent = v669
    
    local v682 = Instance.new("UIStroke")
    v682.Color = Color3.fromRGB(80, 80, 90)
    v682.Thickness = 2
    v682.Parent = v669
    
    local v686 = Instance.new("Frame")
    v686.Name = "HuePicker"
    v686.Size = UDim2.new(0, 260, 0, 20)
    v686.Position = UDim2.new(0, 20, 0, 20)
    v686.BackgroundColor3 = Color3.new(1, 1, 1)
    v686.BorderSizePixel = 0
    v686.Parent = v669
    
    local v693 = Instance.new("UIGradient")
    v693.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    v693.Parent = v686
    
    local v696 = Instance.new("UICorner")
    v696.CornerRadius = UDim.new(0, 4)
    v696.Parent = v686
    
    local v699 = Instance.new("Frame")
    v699.Name = "HueSlider"
    v699.Size = UDim2.new(0, 4, 0, 24)
    v699.Position = UDim2.new(v628, -2, 0, 18)
    v699.BackgroundColor3 = Color3.new(1, 1, 1)
    v699.BorderSizePixel = 0
    v699.ZIndex = 101
    v699.Parent = v669
    
    local v707 = Instance.new("UICorner")
    v707.CornerRadius = UDim.new(0, 2)
    v707.Parent = v699
    
    local v710 = Instance.new("Frame")
    v710.Name = "SVPicker"
    v710.Size = UDim2.new(0, 150, 0, 150)
    v710.Position = UDim2.new(0, 20, 0, 50)
    v710.BackgroundColor3 = v11.HSVToRGB(v628, 1, 1)
    v710.BorderSizePixel = 0
    v710.Parent = v669
    
    local v717 = Instance.new("UIGradient")
    v717.Rotation = 90
    v717.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    })
    v717.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    v717.Parent = v710
    
    local v722 = Instance.new("UIGradient")
    v722.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
    })
    v722.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    v722.Parent = v710
    
    local v726 = Instance.new("UICorner")
    v726.CornerRadius = UDim.new(0, 4)
    v726.Parent = v710
    
    local v729 = Instance.new("Frame")
    v729.Name = "SVSlider"
    v729.Size = UDim2.new(0, 8, 0, 8)
    v729.Position = UDim2.new(v629, -4, 1 - v630, -4)
    v729.BackgroundColor3 = Color3.new(1, 1, 1)
    v729.BorderSizePixel = 0
    v729.ZIndex = 101
    v729.Parent = v710
    
    local v737 = Instance.new("UIStroke")
    v737.Color = Color3.new(0, 0, 0)
    v737.Thickness = 1
    v737.Parent = v729
    
    local v741 = Instance.new("UICorner")
    v741.CornerRadius = UDim.new(0, 4)
    v741.Parent = v729
    
    local v744 = Instance.new("Frame")
    v744.Name = "PreviewFrame"
    v744.Size = UDim2.new(0, 50, 0, 50)
    v744.Position = UDim2.new(0, 190, 0, 50)
    v744.BackgroundColor3 = v627
    v744.BorderSizePixel = 0
    v744.Parent = v669
    
    local v751 = Instance.new("UICorner")
    v751.CornerRadius = UDim.new(0, 6)
    v751.Parent = v744
    
    local v754 = Instance.new("UIStroke")
    v754.Color = Color3.fromRGB(100, 100, 100)
    v754.Thickness = 2
    v754.Parent = v744
    
    local v758 = Instance.new("TextButton")
    v758.Name = "ApplyButton"
    v758.Size = UDim2.new(0, 100, 0, 30)
    v758.Position = UDim2.new(0, 190, 0, 110)
    v758.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    v758.BorderSizePixel = 0
    v758.Text = "APPLY"
    v758.TextColor3 = Color3.fromRGB(255, 255, 255)
    v758.TextSize = 14
    v758.Font = Enum.Font.GothamBold
    v758.Parent = v669
    
    local v769 = Instance.new("UICorner")
    v769.CornerRadius = UDim.new(0, 6)
    v769.Parent = v758
    
    local function v772()
        v627 = v11.HSVToRGB(v628, v629, v630)
        v744.BackgroundColor3 = v627
        v710.BackgroundColor3 = v11.HSVToRGB(v628, 1, 1)
    end
    
    local function v773(v1144)
        local v1145 = math.clamp((v1144.X - v686.AbsolutePosition.X) / v686.AbsoluteSize.X, 0, 1)
        v628 = v1145
        v699.Position = UDim2.new(v1145, -2, 0, 18)
        v772()
    end
    
    local function v774(v1147)
        local v1148 = math.clamp((v1147.X - v710.AbsolutePosition.X) / v710.AbsoluteSize.X, 0, 1)
        local v1149 = math.clamp((v1147.Y - v710.AbsolutePosition.Y) / v710.AbsoluteSize.Y, 0, 1)
        v629 = v1148
        v630 = 1 - v1149
        v729.Position = UDim2.new(v1148, -4, 1 - v630, -4)
        v772()
    end
    
    local v775 = false
    local v776 = false
    
    v686.InputBegan:Connect(function(v1151)
        if v1151.UserInputType == Enum.UserInputType.MouseButton1 then
            v775 = true
            v773(v1151.Position)
        end
    end)
    
    v710.InputBegan:Connect(function(v1152)
        if v1152.UserInputType == Enum.UserInputType.MouseButton1 then
            v776 = true
            v774(v1152.Position)
        end
    end)
    
    v2.InputChanged:Connect(function(v1153)
        if v1153.UserInputType == Enum.UserInputType.MouseMovement then
            if v775 then
                v773(v1153.Position)
            elseif v776 then
                v774(v1153.Position)
            end
        end
    end)
    
    v2.InputEnded:Connect(function(v1154)
        if v1154.UserInputType == Enum.UserInputType.MouseButton1 then
            v775 = false
            v776 = false
        end
    end)
    
    v758.MouseButton1Click:Connect(function()
        v625(v627)
        v654.BackgroundColor3 = v627
        v669.Visible = false
    end)
    
    v654.MouseButton1Click:Connect(function()
        v669.Visible = not v669.Visible
    end)
    
    return v631
end

v11.ESPManager = {
    Enabled = false,
    Players = {},
    Connections = {}
}

v11.ESPManager.ClearAll = function(v777)
    for v1158, v1159 in pairs(v777.Players) do
        v777:RemovePlayerESP(v1158)
    end
    
    for v1160, v1161 in pairs(v777.Connections) do
        if v1161 then
            v1161:Disconnect()
        end
    end
    
    v777.Players = {}
    v777.Connections = {}
end

v11.ESPManager.IsValidPlayer = function(v780, v781)
    if not v781 then
        return false
    end
    
    if v781 == v9 then
        return false
    end
    
    if not v781:IsDescendantOf(v0) then
        return false
    end
    
    if not v11.GameStarted then
        return false
    end
    
    return true
end

v11.ESPManager.CreatePlayerESP = function(v782, v783)
    if not v782:IsValidPlayer(v783) then
        return
    end
    
    if v782.Players[v783] then
        return
    end
    
    local v784 = {
        Folder = nil,
        Connections = {}
    }
    
    local function v785(v1162)
        if not v1162 or not v1162.Parent then
            return
        end
        
        local v1163 = v1162:WaitForChild("HumanoidRootPart", 3)
        local v1164 = v1162:WaitForChild("Humanoid", 3)
        
        if not v1163 or not v1164 then
            return
        end
        
        local v1165 = Instance.new("Folder")
        v1165.Name = v783.Name .. "_ESP"
        v1165.Parent = v11.ScreenGui
        
        local v1169 = Instance.new("Highlight")
        v1169.Name = "Highlight"
        v1169.Adornee = v1162
        v1169.FillColor = v11.SurvivorColor
        v1169.FillTransparency = 0.3
        v1169.OutlineColor = v11.SurvivorColor
        v1169.OutlineTransparency = 0
        v1169.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v1169.Parent = v1165
        
        v784.Folder = v1165
        v782.Players[v783] = v784
        
        v784.Connections.died = v1164.Died:Connect(function()
            v782:RemovePlayerESP(v783)
        end)
    end
    
    if v783.Character then
        v785(v783.Character)
    end
    
    v784.Connections.characterAdded = v783.CharacterAdded:Connect(function(v1183)
        wait(2)
        if v782:IsValidPlayer(v783) then
            v785(v1183)
        else
            v782:RemovePlayerESP(v783)
        end
    end)
    
    v782.Players[v783] = v784
end

v11.ESPManager.RemovePlayerESP = function(v788, v789)
    if not v788.Players[v789] then
        return
    end
    
    local v790 = v788.Players[v789]
    
    for v1184, v1185 in pairs(v790.Connections) do
        if v1185 then
            v1185:Disconnect()
        end
    end
    
    if v790.Folder then
        pcall(function()
            v790.Folder:Destroy()
        end)
    end
    
    v788.Players[v789] = nil
end

v11.ESPManager.UpdateAll = function(v792)
    if not v792.Enabled then
        return
    end
    
    for v1186 in pairs(v792.Players) do
        if not v792:IsValidPlayer(v1186) then
            v792:RemovePlayerESP(v1186)
        end
    end
    
    for v1187, v1188 in pairs(v0:GetPlayers()) do
        if v792:IsValidPlayer(v1188) and not v792.Players[v1188] then
            v792:CreatePlayerESP(v1188)
        end
    end
end

v11.ESPManager.SetEnabled = function(v793, v794)
    v793.Enabled = v794
    
    if v794 then
        v793:UpdateAll()
        
        v793.Connections.playerAdded = v0.PlayerAdded:Connect(function(v1349)
            wait(2)
            if v793.Enabled then
                v793:CreatePlayerESP(v1349)
            end
        end)
        
        v793.Connections.playerRemoving = v0.PlayerRemoving:Connect(function(v1350)
            v793:RemovePlayerESP(v1350)
        end)
    else
        v793:ClearAll()
    end
end

v11.GetPlayerRole = function(v796)
    if not v796 or v796 == v9 then
        return "Unknown"
    end
    
    if not v11.GameStarted then
        return "Survivor"
    end
    
    if v796.Team then
        local v1253 = string.lower(v796.Team.Name)
        if v1253 == "spectator" or v1253 == "spectators" then
            return "Spectator"
        elseif v1253 == "killer" or v1253 == "murderer" then
            return "Killer"
        else
            return "Survivor"
        end
    end
    
    return "Survivor"
end

v11.CheckGameStarted = function()
    local v797 = 0
    for v1189, v1190 in pairs(v0:GetPlayers()) do
        if v1190 ~= v9 then
            local v1351 = v11.GetPlayerRole(v1190)
            if v1351 ~= "Spectator" then
                v797 = v797 + 1
            end
        end
    end
    
    return v797 >= 2 and v11.MapLoaded
end

v11.GameStateManager = {
    LastMapState = false,
    LastGameState = false
}

v11.GameStateManager.CheckForChanges = function(v798)
    local v799 = v11.CheckMapLoaded()
    local v800 = v11.CheckGameStarted()
    
    if v799 ~= v798.LastMapState then
        v798.LastMapState = v799
        print("Map state changed: " .. tostring(v799))
        
        if v799 then
            v798:OnMapLoaded()
        else
            v798:OnMapUnloaded()
        end
    end
    
    if v800 ~= v798.LastGameState then
        v798.LastGameState = v800
        print("Game state changed: " .. tostring(v800))
        
        if v800 then
            v798:OnGameStarted()
        else
            v798:OnGameEnded()
        end
    end
end

v11.GameStateManager.OnMapLoaded = function(v801)
    print("New map loaded - cleaning old ESP")
    v11.ESPManager:ClearAll()
end

v11.GameStateManager.OnMapUnloaded = function(v802)
    print("Map unloaded (back to lobby) - cleaning ESP")
    v11.ESPManager:ClearAll()
end

v11.GameStateManager.OnGameStarted = function(v803)
    print("Game started - initializing systems")
    if v11.ESPEnabled then
        wait(3)
        v11.ESPManager:UpdateAll()
    end
end

v11.GameStateManager.OnGameEnded = function(v804)
    print("Game ended - cleaning ESP")
    v11.ESPManager:ClearAll()
end

v11.StartGameStateMonitoring = function()
    while true do
        v11.GameStateManager:CheckForChanges()
        wait(5)
    end
end

coroutine.wrap(v11.StartGameStateMonitoring)()

v11.ToggleESP = function(v805)
    v11.ESPEnabled = v805
    v11.ESPManager:SetEnabled(v805)
    print("ESP Players: " .. (v805 and "ENABLED" or "DISABLED"))
end

v11.ForceUpdateAllESP = function()
    print("Force updating ESP...")
    v11.ESPManager:UpdateAll()
end

v11.ClearAllESP = function()
    print("Clearing all ESP...")
    v11.ESPManager:ClearAll()
    v11.ObjectESPManager:ClearAll()
end

v11.ObjectESPManager = {
    Enabled = false,
    Objects = {}
}

v11.ObjectESPManager.ClearAll = function(v807)
    for v1191, v1192 in pairs(v807.Objects) do
        if v1192 and v1192.Parent then
            pcall(function()
                v1192:Destroy()
            end)
        end
    end
    
    v807.Objects = {}
end

v11.ObjectESPManager.CreateObjectESP = function(v809, v810, v811, v812)
    if not v810 or not v810.Parent then
        return
    end
    
    if v809.Objects[v810] then
        return
    end
    
    local v813 = Instance.new("Folder")
    v813.Name = v812 .. "_ESP_" .. tostring(v810:GetFullName())
    v813.Parent = v11.ScreenGui
    
    local v817 = Instance.new("Highlight")
    v817.Name = "Highlight"
    v817.Adornee = v810
    v817.FillColor = v811
    v817.FillTransparency = 0.5
    v817.OutlineColor = v811
    v817.OutlineTransparency = 0
    v817.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    v817.Parent = v813
    
    v809.Objects[v810] = v813
    
    spawn(function()
        while v810 and v810.Parent do
            wait(2)
        end
        v809:RemoveObjectESP(v810)
    end)
end

v11.ObjectESPManager.RemoveObjectESP = function(v828, v829)
    if v828.Objects[v829] then
        pcall(function()
            v828.Objects[v829]:Destroy()
        end)
        v828.Objects[v829] = nil
    end
end

v11.ObjectESPManager.FindAndCreateObjects = function(v830, v831, v832, v833)
    for v1193, v1194 in pairs(v6:GetDescendants()) do
        if string.lower(v1194.Name) == string.lower(v831) and (v1194:IsA("Model") or v1194:IsA("Part")) then
            v830:CreateObjectESP(v1194, v832, v833)
        end
    end
end

v11.FindAndCreateGenerators = function()
    v11.ObjectESPManager:FindAndCreateObjects("Generator", v11.GeneratorColor, "Generator")
    v11.ObjectESPManager:FindAndCreateObjects("Generators", v11.GeneratorColor, "Generator")
end

v11.FindAndCreatePallets = function()
    v11.ObjectESPManager:FindAndCreateObjects("Pallet", v11.PalletColor, "Pallet")
    v11.ObjectESPManager:FindAndCreateObjects("PalletWrong", v11.PalletColor, "Pallet")
    v11.ObjectESPManager:FindAndCreateObjects("Pallets", v11.PalletColor, "Pallet")
end

v11.ToggleGeneratorESP = function(v834)
    v11.GeneratorESPEnabled = v834
    
    if v834 then
        print("Generator ESP: ENABLED")
        v11.FindAndCreateGenerators()
        
        if not v11.AutoRefreshConnection then
            v11.AutoRefreshConnection = v1.Heartbeat:Connect(function()
                if not v11.GeneratorESPEnabled then
                    v11.AutoRefreshConnection:Disconnect()
                    v11.AutoRefreshConnection = nil
                    return
                end
                
                if tick() - (v11._lastGeneratorCheck or 0) > 5 then
                    v11._lastGeneratorCheck = tick()
                    v11.FindAndCreateGenerators()
                end
            end)
        end
    else
        print("Generator ESP: DISABLED")
        for v1352, v1353 in pairs(v11.ObjectESPManager.Objects) do
            if v1353 and v1353.Name:find("Generator") then
                v11.ObjectESPManager:RemoveObjectESP(v1352)
            end
        end
        
        if v11.AutoRefreshConnection then
            v11.AutoRefreshConnection:Disconnect()
            v11.AutoRefreshConnection = nil
        end
    end
end

v11.TogglePalletESP = function(v836)
    v11.PalletESPEnabled = v836
    
    if v836 then
        print("Pallet ESP: ENABLED")
        v11.FindAndCreatePallets()
        
        if not v11.AutoRefreshConnection then
            v11.AutoRefreshConnection = v1.Heartbeat:Connect(function()
                if not v11.PalletESPEnabled then
                    v11.AutoRefreshConnection:Disconnect()
                    v11.AutoRefreshConnection = nil
                    return
                end
                
                if tick() - (v11._lastPalletCheck or 0) > 5 then
                    v11._lastPalletCheck = tick()
                    v11.FindAndCreatePallets()
                end
            end)
        end
    else
        print("Pallet ESP: DISABLED")
        for v1354, v1355 in pairs(v11.ObjectESPManager.Objects) do
            if v1355 and v1355.Name:find("Pallet") then
                v11.ObjectESPManager:RemoveObjectESP(v1354)
            end
        end
        
        if v11.AutoRefreshConnection then
            v11.AutoRefreshConnection:Disconnect()
            v11.AutoRefreshConnection = nil
        end
    end
end

v11.StartSuperESP = function()
    if v11.SuperESPConnection then
        v11.SuperESPConnection:Disconnect()
    end
    
    v11.SuperESPConnection = v1.Heartbeat:Connect(function()
        if not v11.SuperESPEnabled or not v11.ESPEnabled then
            return
        end
        
        local v1195 = tick()
        
        for v1257, v1258 in pairs(v11.ESPFolders) do
            if v1257 and v1258 and v1257.Character then
                local v1420 = v11.IsPlayerKiller(v1257)
                local v1421 = v1420 and v11.KillerColor or v11.SurvivorColor
                local v1422 = v11.GetSuperESPColor(v1421, v1195, v11.SuperESPSpeed)
                
                local v1423 = v1258:FindFirstChild("ESPHighlight")
                local v1424 = v1258:FindFirstChild("ESPBillboard")
                
                if v1423 then
                    v1423.FillColor = v1422
                    v1423.OutlineColor = v1422
                end
                
                if v1424 then
                    local v1515 = v1424:FindFirstChild("ESPName")
                    if v1515 then
                        v1515.TextColor3 = v1422
                    end
                end
            end
        end
        
        for v1259, v1260 in pairs(v11.GeneratorESPItems) do
            if v1259 and v1260 then
                local v1425 = v11.GetSuperESPColor(v11.GeneratorColor, v1195, v11.SuperESPSpeed)
                local v1426 = v1260:FindFirstChild("GeneratorHighlight")
                
                if v1426 then
                    v1426.FillColor = v1425
                    v1426.OutlineColor = v1425
                end
            end
        end
        
        for v1261, v1262 in pairs(v11.PalletESPItems) do
            if v1261 and v1262 then
                local v1427 = v11.GetSuperESPColor(v11.PalletColor, v1195, v11.SuperESPSpeed)
                local v1428 = v1262:FindFirstChild("PalletHighlight")
                
                if v1428 then
                    v1428.FillColor = v1427
                    v1428.OutlineColor = v1427
                end
            end
        end
    end)
end

v11.ToggleSuperESP = function(v839)
    v11.SuperESPEnabled = v839
    
    if v839 then
        v11.StartSuperESP()
        print("Super ESP: ENABLED")
    else
        if v11.SuperESPConnection then
            v11.SuperESPConnection:Disconnect()
            v11.SuperESPConnection = nil
        end
        
        v11.UpdateESP()
        v11.UpdateGeneratorESP()
        v11.UpdatePalletESP()
        print("Super ESP: DISABLED")
    end
end

v11.UpdateSuperESPSpeed = function(v841)
    v11.SuperESPSpeed = v841
    print("Super ESP Speed: " .. v841)
end

v11.ToggleESP = function(v843)
    v11.ESPEnabled = v843
    
    if v843 then
        print("ESP Players: ENABLED")
        
        for v1356, v1357 in pairs(v0:GetPlayers()) do
            if v1357 ~= v9 and not v11.IsPlayerSpectator(v1357) then
                v11.CreateESP(v1357)
            end
        end
        
        if v11.PlayerAddedConnection then
            v11.PlayerAddedConnection:Disconnect()
        end
        
        v11.PlayerAddedConnection = v0.PlayerAdded:Connect(function(v1358)
            wait(3)
            if not v11.IsPlayerSpectator(v1358) then
                v11.CreateESP(v1358)
            end
        end)
        
        v0.PlayerRemoving:Connect(function(v1359)
            v11.RemoveESP(v1359)
        end)
        
        if v11.RGBESPEnabled then
            v11.StartRGBESP()
        end
        
        if v11.SuperESPEnabled then
            v11.StartSuperESP()
        end
    else
        print("ESP Players: DISABLED")
        
        for v1360, v1361 in pairs(v11.ESPFolders) do
            v11.RemoveESP(v1360)
        end
        
        if v11.PlayerAddedConnection then
            v11.PlayerAddedConnection:Disconnect()
            v11.PlayerAddedConnection = nil
        end
        
        if v11.RGBESPConnection then
            v11.RGBESPConnection:Disconnect()
            v11.RGBESPConnection = nil
        end
        
        if v11.SuperESPConnection then
            v11.SuperESPConnection:Disconnect()
            v11.SuperESPConnection = nil
        end
    end
end

v11.ToggleGeneratorESP = function(v845)
    v11.GeneratorESPEnabled = v845
    
    if v845 then
        v11.FindAndCreateGenerators()
        print("ESP Generators: ENABLED")
        
        if v11.SuperESPEnabled then
            v11.StartSuperESP()
        end
    else
        for v1362, v1363 in pairs(v11.GeneratorESPItems) do
            v11.RemoveGeneratorESP(v1362)
        end
        print("ESP Generators: DISABLED")
    end
end

v11.TogglePalletESP = function(v847)
    v11.PalletESPEnabled = v847
    
    if v847 then
        v11.FindAndCreatePallets()
        print("ESP Pallets: ENABLED")
        
        if v11.SuperESPEnabled then
            v11.StartSuperESP()
        end
    else
        for v1364, v1365 in pairs(v11.PalletESPItems) do
            v11.RemovePalletESP(v1364)
        end
        print("ESP Pallets: DISABLED")
    end
end

v11.ToggleWalkSpeed = function(v849)
    v11.walkSpeedActive = v849
    
    if v849 then
        local v1264 = v9.Character
        if v1264 then
            local v1433 = v1264:FindFirstChildOfClass("Humanoid")
            if v1433 then
                v1433.WalkSpeed = v11.walkSpeed
            end
        end
        print("WalkSpeed: ENABLED (" .. v11.walkSpeed .. ")")
    else
        local v1265 = v9.Character
        if v1265 then
            local v1434 = v1265:FindFirstChildOfClass("Humanoid")
            if v1434 then
                v1434.WalkSpeed = 16
            end
        end
        print("WalkSpeed: DISABLED")
    end
end

v11.UpdateWalkSpeedValue = function(v851)
    v11.walkSpeed = v851
    if v11.walkSpeedActive then
        v11.ToggleWalkSpeed(true)
    end
    print("WalkSpeed Value: " .. v851)
end

v11.StartFly = function()
    local v853 = v9.Character
    if not v853 then
        return
    end
    
    local v854 = v853:FindFirstChild("HumanoidRootPart")
    local v855 = v853:FindFirstChildOfClass("Humanoid")
    
    if not v854 or not v855 then
        return
    end
    
    v11.Flying = true
    
    v11.BodyVelocity = Instance.new("BodyVelocity")
    v11.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    v11.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    v11.BodyVelocity.Parent = v854
    
    v11.BodyGyro = Instance.new("BodyGyro")
    v11.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    v11.BodyGyro.P = 1000
    v11.BodyGyro.D = 50
    v11.BodyGyro.Parent = v854
    
    v11.FlyConnection = v1.Heartbeat:Connect(function()
        if not v11.Flying or not v853 or not v854 or not v11.BodyVelocity or not v11.BodyGyro then
            return
        end
        
        v11.BodyGyro.CFrame = v6.CurrentCamera.CFrame
        
        local v1198 = Vector3.new(0, 0, 0)
        
        if v2:IsKeyDown(Enum.KeyCode.W) then
            v1198 = v1198 + (v6.CurrentCamera.CFrame.LookVector * v11.FlySpeedValue)
        end
        
        if v2:IsKeyDown(Enum.KeyCode.S) then
            v1198 = v1198 + (v6.CurrentCamera.CFrame.LookVector * -v11.FlySpeedValue)
        end
        
        if v2:IsKeyDown(Enum.KeyCode.A) then
            v1198 = v1198 + (v6.CurrentCamera.CFrame.RightVector * -v11.FlySpeedValue)
        end
        
        if v2:IsKeyDown(Enum.KeyCode.D) then
            v1198 = v1198 + (v6.CurrentCamera.CFrame.RightVector * v11.FlySpeedValue)
        end
        
        if v2:IsKeyDown(Enum.KeyCode.Space) then
            v1198 = v1198 + Vector3.new(0, v11.FlySpeedValue, 0)
        end
        
        if v2:IsKeyDown(Enum.KeyCode.LeftShift) then
            v1198 = v1198 + Vector3.new(0, -v11.FlySpeedValue, 0)
        end
        
        v11.BodyVelocity.Velocity = v1198
        v855.PlatformStand = true
    end)
end

v11.StopFly = function()
    v11.Flying = false
    
    if v11.FlyConnection then
        v11.FlyConnection:Disconnect()
    end
    
    local v868 = v9.Character
    if v868 then
        local v1266 = v868:FindFirstChild("HumanoidRootPart")
        local v1267 = v868:FindFirstChildOfClass("Humanoid")
        
        if v1267 then
            v1267.PlatformStand = false
        end
        
        if v1266 then
            if v11.BodyVelocity then
                v11.BodyVelocity:Destroy()
            end
            if v11.BodyGyro then
                v11.BodyGyro:Destroy()
            end
        end
    end
end

v11.ToggleFly = function(v869)
    v11.FlyEnabled = v869
    
    if v869 then
        v11.StartFly()
        print("Fly: ENABLED")
    else
        v11.StopFly()
        print("Fly: DISABLED")
    end
end

v11.StartNoclip = function()
    local v871 = v9.Character
    if not v871 then
        return
    end
    
    if v11.NoclipConnection then
        v11.NoclipConnection:Disconnect()
        v11.NoclipConnection = nil
    end
    
    v11.NoclipConnection = v1.Stepped:Connect(function()
        if not v11.NoclipEnabled or not v871 or not v871.Parent then
            if v11.NoclipConnection then
                v11.NoclipConnection:Disconnect()
                v11.NoclipConnection = nil
            end
            return
        end
        
        for v1269, v1270 in pairs(v871:GetDescendants()) do
            if v1270:IsA("BasePart") then
                v1270.CanCollide = false
            end
        end
        
        local v1201 = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        for v1271, v1272 in ipairs(v1201) do
            local v1273 = v871:FindFirstChild(v1272)
            if v1273 and v1273:IsA("BasePart") then
                v1273.CanCollide = false
                v1273.Velocity = Vector3.new(0, 0, 0)
                v1273.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        for v1274, v1275 in pairs(v871:GetChildren()) do
            if v1275:IsA("Accessory") then
                local v1440 = v1275:FindFirstChild("Handle")
                if v1440 and v1440:IsA("BasePart") then
                    v1440.CanCollide = false
                end
            end
        end
    end)
end

v11.StopNoclip = function()
    local v873 = v9.Character
    if v873 then
        for v1366, v1367 in pairs(v873:GetDescendants()) do
            if v1367:IsA("BasePart") then
                v1367.CanCollide = true
            end
        end
    end
    
    if v11.NoclipConnection then
        v11.NoclipConnection:Disconnect()
        v11.NoclipConnection = nil
    end
end

v11.ToggleNoclip = function(v874)
    v11.NoclipEnabled = v874
    
    if v11.NoclipCharacterConnection then
        v11.NoclipCharacterConnection:Disconnect()
        v11.NoclipCharacterConnection = nil
    end
    
    if v874 then
        print("Noclip: ENABLED (R6 Compatible)")
        v11.StartNoclip()
        
        v11.NoclipCharacterConnection = v9.CharacterAdded:Connect(function(v1368)
            wait(1)
            if v11.NoclipEnabled then
                v11.StartNoclip()
            end
        end)
    else
        v11.StopNoclip()
        print("Noclip: DISABLED")
    end
end

v11.ToggleGodMode = function(v876)
    v11.GodModeEnabled = v876
    
    if v876 then
        print("God Mode: ENABLED - Searching for health system...")
        
        if v11.GodModeConnection then
            v11.GodModeConnection:Disconnect()
        end
        
        v11.GodModeConnection = v1.Heartbeat:Connect(function()
            if not v11.GodModeEnabled then
                if v11.GodModeConnection then
                    v11.GodModeConnection:Disconnect()
                    v11.GodModeConnection = nil
                end
                return
            end
            
            local v1369 = v9.Character
            if v1369 then
                local v1482 = false
                
                for v1524, v1525 in pairs(v1369:GetDescendants()) do
                    if v1525:IsA("Script") or v1525:IsA("LocalScript") then
                        if string.find(string.lower(v1525.Name), "health") or string.find(string.lower(v1525.Name), "damage") or string.find(string.lower(v1525.Name), "hit") then
                            pcall(function()
                                v1525.Disabled = true
                            end)
                            v1482 = true
                        end
                    end
                end
                
                for v1526, v1527 in pairs(v1369:GetDescendants()) do
                    if v1527:IsA("NumberValue") or v1527:IsA("IntValue") then
                        local v1572 = string.lower(v1527.Name)
                        if string.find(v1572, "health") or string.find(v1572, "hp") or string.find(v1572, "damage") then
                            pcall(function()
                                if v1527.Value < 100 then
                                    v1527.Value = 100
                                end
                            end)
                            v1482 = true
                        end
                    end
                end
                
                local v1483 = v1369:FindFirstChildOfClass("Humanoid")
                if v1483 then
                    if v1483.Health < 100 then
                        v1483.Health = 100
                    end
                    if v1483.PlatformStand then
                        v1483.PlatformStand = false
                    end
                    if v1483.Sit then
                        v1483.Sit = false
                    end
                end
                
                if v1369.Parent == nil then
                    pcall(function()
                        v1369.Parent = v6
                    end)
                end
                
                for v1528, v1529 in pairs(v0:GetPlayers()) do
                    if v1529 ~= v9 and v11.IsPlayerKiller(v1529) then
                        local v1574 = v1529.Character
                        if v1574 then
                            for v1623, v1624 in pairs(v1574:GetChildren()) do
                                if v1624:IsA("Tool") then
                                    pcall(function()
                                        v1624:Destroy()
                                    end)
                                end
                            end
                            
                            local v1615 = v1574:FindFirstChildOfClass("Humanoid")
                            if v1615 then
                                pcall(function()
                                    v1615:ChangeState(Enum.HumanoidStateType.Running)
                                end)
                            end
                        end
                    end
                end
                
                if not v1482 then
                    if v1483 then
                        v1483.MaxHealth = math.huge
                        v1483.Health = math.huge
                    end
                end
            end
        end)
    else
        if v11.GodModeConnection then
            v11.GodModeConnection:Disconnect()
            v11.GodModeConnection = nil
        end
        
        local v1280 = v9.Character
        if v1280 then
            local v1442 = v1280:FindFirstChildOfClass("Humanoid")
            if v1442 then
                v1442.MaxHealth = 100
                v1442.Health = 100
            end
            
            for v1484, v1485 in pairs(v1280:GetDescendants()) do
                if v1485:IsA("Script") or v1485:IsA("LocalScript") then
                    pcall(function()
                        v1485.Disabled = false
                    end)
                end
            end
        end
        
        print("God Mode: DISABLED")
    end
end

v11.FindHealthSystem = function()
    print("=== Searching for Health System ===")
    local v878 = v9.Character
    if v878 then
        for v1370, v1371 in pairs(v878:GetDescendants()) do
            local v1372 = string.lower(v1371.Name)
            if string.find(v1372, "health") or string.find(v1372, "hp") or string.find(v1372, "damage") or string.find(v1372, "hit") then
                print("Found: " .. v1371:GetFullName() .. " (" .. v1371.ClassName .. ")")
                if v1371:IsA("NumberValue") or v1371:IsA("IntValue") then
                    print("Value: " .. tostring(v1371.Value))
                end
            end
        end
    end
    
    for v1202, v1203 in pairs(v9:GetDescendants()) do
        local v1204 = string.lower(v1203.Name)
        if string.find(v1204, "health") or string.find(v1204, "hp") then
            print("Found in Player: " .. v1203:GetFullName() .. " (" .. v1203.ClassName .. ")")
        end
    end
    
    print("=== Health System Search Complete ===")
end

v11.ToggleTime = function(v879)
    v11.TimeEnabled = v879
    
    if v879 then
        if not v11.TimeConnection then
            v11.TimeConnection = v1.Heartbeat:Connect(function()
                if not v11.TimeEnabled then
                    if v11.TimeConnection then
                        v11.TimeConnection:Disconnect()
                        v11.TimeConnection = nil
                    end
                    return
                end
                v4.ClockTime = v11.TimeValue
            end)
        end
        print("Custom Time: ENABLED (" .. v11.TimeValue .. ")")
    else
        if v11.TimeConnection then
            v11.TimeConnection:Disconnect()
            v11.TimeConnection = nil
        end
        print("Custom Time: DISABLED")
    end
end

v11.ToggleMapColor = function(v881)
    v11.MapColorEnabled = v881
    
    if v881 then
        if not v11.MapColorConnection then
            v11.MapColorConnection = v1.Heartbeat:Connect(function()
                if not v11.MapColorEnabled then
                    if v11.MapColorConnection then
                        v11.MapColorConnection:Disconnect()
                        v11.MapColorConnection = nil
                    end
                    return
                end
                
                v4.Ambient = v11.MapColor
                v4.OutdoorAmbient = v11.MapColor
                v4.ColorShift_Bottom = v11.MapColor
                v4.ColorShift_Top = v11.MapColor
                
                if not v4:FindFirstChild("ColorCorrection") then
                    local v1553 = Instance.new("ColorCorrectionEffect")
                    v1553.Name = "ColorCorrection"
                    v1553.Saturation = v11.MapColorSaturation
                    v1553.Parent = v4
                else
                    v4.ColorCorrection.Saturation = v11.MapColorSaturation
                end
            end)
        end
        print("Map Color: ENABLED")
    else
        if v11.MapColorConnection then
            v11.MapColorConnection:Disconnect()
            v11.MapColorConnection = nil
        end
        
        v4.Ambient = Color3.new(0.5, 0.5, 0.5)
        v4.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        v4.ColorShift_Bottom = Color3.new(0, 0, 0)
        v4.ColorShift_Top = Color3.new(0, 0, 0)
        
        if v4:FindFirstChild("ColorCorrection") then
            v4.ColorCorrection:Destroy()
        end
        
        print("Map Color: DISABLED")
    end
end

v11.ToggleAntiStun = function(v883)
    v11.AntiStunEnabled = v883
    
    if v883 then
        if v11.AntiStunConnection then
            v11.AntiStunConnection:Disconnect()
        end
        
        v11.AntiStunConnection = v1.Heartbeat:Connect(function()
            if not v11.AntiStunEnabled then
                if v11.AntiStunConnection then
                    v11.AntiStunConnection:Disconnect()
                end
                return
            end
            
            local v1373 = v9.Character
            if v1373 then
                local v1493 = v1373:FindFirstChildOfClass("Humanoid")
                if v1493 then
                    if v1493.PlatformStand then
                        v1493.PlatformStand = false
                    end
                    if v1493.Sit then
                        v1493.Sit = false
                    end
                    if v1493:GetState() == Enum.HumanoidStateType.FallingDown or v1493:GetState() == Enum.HumanoidStateType.Ragdoll then
                        v1493:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end)
        print("AntiStun: ENABLED")
    else
        if v11.AntiStunConnection then
            v11.AntiStunConnection:Disconnect()
            v11.AntiStunConnection = nil
        end
        print("AntiStun: DISABLED")
    end
end

v11.ToggleAntiGrab = function(v885)
    v11.AntiGrabEnabled = v885
    
    if v885 then
        if v11.AntiGrabConnection then
            v11.AntiGrabConnection:Disconnect()
        end
        
        v11.AntiGrabConnection = v1.Heartbeat:Connect(function()
            if not v11.AntiGrabEnabled then
                return
            end
            
            local v1374 = v9.Character
            if v1374 then
                local v1494 = v1374:FindFirstChild("HumanoidRootPart")
                local v1495 = v1374:FindFirstChildOfClass("Humanoid")
                
                if v1494 and v1495 and v1495.Health > 0 then
                    if v1495.PlatformStand then
                        v1495.PlatformStand = false
                        v1494.Velocity = Vector3.new(0, 50, 0)
                    end
                    
                    for v1576 = 1, #v0:GetPlayers() do
                        local v1577 = v0:GetPlayers()[v1576]
                        if v1577 ~= v9 then
                            if v1577.Team and string.lower(v1577.Team.Name) == "killer" then
                                local v1627 = v1577.Character
                                if v1627 then
                                    local v1636 = v1627:FindFirstChild("HumanoidRootPart")
                                    if v1636 then
                                        local v1640 = v1494.Position.X - v1636.Position.X
                                        local v1641 = v1494.Position.Z - v1636.Position.Z
                                        local v1642 = math.sqrt(v1640 * v1640 + v1641 * v1641)
                                        
                                        if v1642 < 12 then
                                            local v1643, v1644 = v1640 / v1642, v1641 / v1642
                                            local v1645 = v1636.Position.X + (v1643 * 25)
                                            local v1646 = v1636.Position.Z + (v1644 * 25)
                                            v1494.CFrame = CFrame.new(v1645, v1494.Position.Y + 3, v1646)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        print("AntiGrab: ENABLED - ULTRA FAST")
    else
        if v11.AntiGrabConnection then
            v11.AntiGrabConnection:Disconnect()
            v11.AntiGrabConnection = nil
        end
        print("AntiGrab: DISABLED")
    end
end

v11.ToggleMaxEscapeChance = function(v887)
    v11.MaxEscapeChanceEnabled = v887
    
    if v887 then
        if v11.EscapeChanceConnection then
            v11.EscapeChanceConnection:Disconnect()
        end
        
        v11.EscapeChanceConnection = v1.Heartbeat:Connect(function()
            if not v11.MaxEscapeChanceEnabled then
                if v11.EscapeChanceConnection then
                    v11.EscapeChanceConnection:Disconnect()
                end
                return
            end
            
            local v1375 = v9.Character
            if v1375 then
                local v1496 = v1375:FindFirstChildOfClass("Humanoid")
                local v1497 = v1375:FindFirstChild("HumanoidRootPart")
                
                if v1496 and v1497 then
                    if v1496.PlatformStand or v1496.Sit then
                        v1496.PlatformStand = false
                        v1496.Sit = false
                        v1497.Velocity = (v1497.CFrame.LookVector * 50) + Vector3.new(0, 25, 0)
                    end
                    
                    for v1578, v1579 in pairs(v0:GetPlayers()) do
                        if v1579 ~= v9 and v11.IsPlayerKiller(v1579) then
                            local v1616 = v1579.Character
                            if v1616 then
                                local v1628 = v1616:FindFirstChild("HumanoidRootPart")
                                if v1628 and (v1497.Position - v1628.Position).Magnitude < 8 then
                                    local v1637 = (v1497.Position - v1628.Position).Unit
                                    v1497.Velocity = (v1637 * 40) + Vector3.new(0, 15, 0)
                                end
                            end
                        end
                    end
                end
            end
        end)
        print("100% Escape Chance: ENABLED")
    else
        if v11.EscapeChanceConnection then
            v11.EscapeChanceConnection:Disconnect()
            v11.EscapeChanceConnection = nil
        end
        print("100% Escape Chance: DISABLED")
    end
end

v11.ToggleGrabKiller = function(v889)
    v11.GrabKillerEnabled = v889
    
    if v889 then
        if v11.GrabKillerConnection then
            v11.GrabKillerConnection:Disconnect()
        end
        
        v11.GrabKillerConnection = v1.Heartbeat:Connect(function()
            if not v11.GrabKillerEnabled then
                if v11.GrabKillerConnection then
                    v11.GrabKillerConnection:Disconnect()
                end
                return
            end
            
            local v1376 = v9.Character
            if v1376 then
                local v1498 = v1376:FindFirstChild("HumanoidRootPart")
                local v1499 = v1376:FindFirstChildOfClass("Humanoid")
                
                if v1498 and v1499 then
                    local v1560 = nil
                    local v1561 = 15
                    
                    for v1580, v1581 in pairs(v0:GetPlayers()) do
                        if v1581 ~= v9 and v11.IsPlayerKiller(v1581) and not v11.IsPlayerSpectator(v1581) then
                            local v1617 = v1581.Character
                            if v1617 then
                                local v1629 = v1617:FindFirstChild("HumanoidRootPart")
                                local v1630 = v1617:FindFirstChildOfClass("Humanoid")
                                
                                if v1629 and v1630 and v1630.Health > 0 then
                                    local v1639 = (v1498.Position - v1629.Position).Magnitude
                                    if v1639 < v1561 then
                                        v1561 = v1639
                                        v1560 = v1581
                                    end
                                end
                            end
                        end
                    end
                    
                    if v1560 then
                        local v1614 = v1560.Character
                        if v1614 then
                            local v1625 = v1614:FindFirstChild("HumanoidRootPart")
                            local v1626 = v1614:FindFirstChildOfClass("Humanoid")
                            
                            if v1625 and v1626 then
                                v1626.PlatformStand = true
                                local v1633 = (v1498.CFrame.LookVector * 4) + Vector3.new(0, 1, 0)
                                v1625.CFrame = CFrame.new(v1498.Position + v1633)
                                v1625.Velocity = Vector3.new(0, 0, 0)
                                
                                if v1626:FindFirstChild("Attack") then
                                    v1626.Attack:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end)
        print("Grab Killer: ENABLED")
    else
        if v11.GrabKillerConnection then
            v11.GrabKillerConnection:Disconnect()
            v11.GrabKillerConnection = nil
        end
        print("Grab Killer: DISABLED")
    end
end

v11.ToggleRapidFire = function(v891)
    v11.RapidFireEnabled = v891
    
    if v891 then
        if v11.RapidFireConnection then
            v11.RapidFireConnection:Disconnect()
        end
        
        v11.RapidFireConnection = v1.Heartbeat:Connect(function()
            if not v11.RapidFireEnabled then
                if v11.RapidFireConnection then
                    v11.RapidFireConnection:Disconnect()
                end
                return
            end
            
            local v1377 = v9.Character
            if v1377 then
                local v1500 = v9:FindFirstChild("Backpack")
                local v1501 = nil
                
                for v1532, v1533 in pairs(v1377:GetChildren()) do
                    if v1533:IsA("Tool") and (string.find(string.lower(v1533.Name), "twist") or string.find(string.lower(v1533.Name), "fate") or string.find(string.lower(v1533.Name), "pistol") or string.find(string.lower(v1533.Name), "gun")) then
                        v1501 = v1533
                        break
                    end
                end
                
                if not v1501 and v1500 then
                    for v1582, v1583 in pairs(v1500:GetChildren()) do
                        if v1583:IsA("Tool") and (string.find(string.lower(v1583.Name), "twist") or string.find(string.lower(v1583.Name), "fate") or string.find(string.lower(v1583.Name), "pistol") or string.find(string.lower(v1583.Name), "gun")) then
                            v1501 = v1583
                            break
                        end
                    end
                end
                
                if v1501 then
                    for v1584, v1585 in pairs(v1501:GetDescendants()) do
                        if v1585:IsA("NumberValue") and (v1585.Name == "Cooldown" or v1585.Name == "Delay" or v1585.Name == "FireRate") then
                            v1585.Value = 0
                        end
                    end
                    
                    if v2:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        if v1501.Parent == v1377 then
                            v1501:Activate()
                        end
                    end
                end
            end
        end)
        print("Rapid Fire: ENABLED")
    else
        if v11.RapidFireConnection then
            v11.RapidFireConnection:Disconnect()
            v11.RapidFireConnection = nil
        end
        print("Rapid Fire: DISABLED")
    end
end

v11.ToggleTwistAnimations = function(v893)
    v11.DisableTwistAnimationsEnabled = v893
    
    if v893 then
        if v11.TwistAnimationsConnection then
            v11.TwistAnimationsConnection:Disconnect()
        end
        
        v11.TwistAnimationsConnection = v1.Heartbeat:Connect(function()
            if not v11.DisableTwistAnimationsEnabled then
                if v11.TwistAnimationsConnection then
                    v11.TwistAnimationsConnection:Disconnect()
                end
                return
            end
            
            local v1378 = v9.Character
            if v1378 then
                local v1502 = v9:FindFirstChild("Backpack")
                local v1503 = nil
                
                for v1534, v1535 in pairs(v1378:GetChildren()) do
                    if v1535:IsA("Tool") and (string.find(string.lower(v1535.Name), "twist") or string.find(string.lower(v1535.Name), "fate")) then
                        v1503 = v1535
                        break
                    end
                end
                
                if not v1503 and v1502 then
                    for v1586, v1587 in pairs(v1502:GetChildren()) do
                        if v1587:IsA("Tool") and (string.find(string.lower(v1587.Name), "twist") or string.find(string.lower(v1587.Name), "fate")) then
                            v1503 = v1587
                            break
                        end
                    end
                end
                
                if v1503 then
                    for v1588, v1589 in pairs(v1503:GetDescendants()) do
                        if v1589:IsA("AnimationTrack") then
                            v1589:Stop()
                        end
                    end
                    
                    for v1590, v1591 in pairs(v1503:GetDescendants()) do
                        if v1591:IsA("Sound") then
                            v1591:Stop()
                        end
                    end
                    
                    for v1592, v1593 in pairs(v1503:GetDescendants()) do
                        if v1593:IsA("ParticleEmitter") then
                            v1593.Enabled = false
                        end
                    end
                end
            end
        end)
        print("Disable Twist Animations: ENABLED")
    else
        if v11.TwistAnimationsConnection then
            v11.TwistAnimationsConnection:Disconnect()
            v11.TwistAnimationsConnection = nil
        end
        print("Disable Twist Animations: DISABLED")
    end
end

v11.ToggleNoFog = function(v895)
    v11.NoFogEnabled = v895
    
    if v895 then
        if v11.NoFogConnection then
            v11.NoFogConnection:Disconnect()
        end
        
        v11.NoFogConnection = v1.Heartbeat:Connect(function()
            if not v11.NoFogEnabled then
                if v11.NoFogConnection then
                    v11.NoFogConnection:Disconnect()
                end
                return
            end
            
            if v4:FindFirstChild("FogEnd") then
                v4.FogEnd = 1000000
            end
            
            if v4:FindFirstChild("FogStart") then
                v4.FogStart = 100000
            end
            
            if v4:FindFirstChild("FogColor") then
                v4.FogColor = Color3.new(1, 1, 1)
            end
        end)
        print("No Fog: ENABLED")
    else
        if v11.NoFogConnection then
            v11.NoFogConnection:Disconnect()
            v11.NoFogConnection = nil
        end
        
        if v4:FindFirstChild("FogEnd") then
            v4.FogEnd = 1000
        end
        
        if v4:FindFirstChild("FogStart") then
            v4.FogStart = 0
        end
        
        print("No Fog: DISABLED")
    end
end

v11.TeleportToPlayer = function(v897)
    if not v897 or v897 == v9 then
        print("Cannot teleport to yourself")
        return
    end
    
    local v898 = v9.Character
    local v899 = v897.Character
    
    if not v898 or not v899 then
        print("Character not found")
        return
    end
    
    local v900 = v898:FindFirstChild("HumanoidRootPart")
    local v901 = v899:FindFirstChild("HumanoidRootPart")
    
    if not v900 or not v901 then
        print("HumanoidRootPart not found")
        return
    end
    
    v900.CFrame = CFrame.new(v901.Position + Vector3.new(3, 0, 3))
    print("Teleported to: " .. v897.Name)
end

v11.UpdateTeleportPlayersList = function()
    if not v11.TeleportPlayersFrame then
        return
    end
    
    for v1205, v1206 in ipairs(v11.TeleportPlayersFrame:GetChildren()) do
        v1206:Destroy()
    end
    
    local v903 = 0
    for v1207, v1208 in pairs(v0:GetPlayers()) do
        if v1208 ~= v9 and not v11.IsPlayerSpectator(v1208) then
            v903 = v903 + 1
            
            local v1379 = v11.IsPlayerKiller(v1208)
            local v1380 = Instance.new("TextButton")
            v1380.Name = v1208.Name
            v1380.Size = UDim2.new(1, -10, 0, 35)
            v1380.Position = UDim2.new(0, 5, 0, (v903 - 1) * 40)
            v1380.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            v1380.BorderSizePixel = 0
            v1380.Text = v1208.Name .. " (" .. (v1379 and "KILLER" or "SURVIVOR") .. ")"
            v1380.TextColor3 = v1379 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            v1380.TextSize = 12
            v1380.Font = Enum.Font.GothamBold
            v1380.Parent = v11.TeleportPlayersFrame
            
            local v1394 = Instance.new("UICorner")
            v1394.CornerRadius = UDim.new(0, 6)
            v1394.Parent = v1380
            
            v1380.MouseButton1Click:Connect(function()
                v11.TeleportToPlayer(v1208)
                if v11.TeleportFrame then
                    v11.TeleportFrame.Visible = false
                end
            end)
        end
    end
    
    v11.TeleportPlayersFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(50, v903 * 40))
    
    if v903 == 0 then
        local v1292 = Instance.new("TextLabel")
        v1292.Size = UDim2.new(1, -10, 0, 50)
        v1292.Position = UDim2.new(0, 5, 0, 0)
        v1292.BackgroundTransparency = 1
        v1292.Text = "No other players found"
        v1292.TextColor3 = Color3.fromRGB(150, 150, 150)
        v1292.TextSize = 14
        v1292.Font = Enum.Font.Gotham
        v1292.Parent = v11.TeleportPlayersFrame
    end
end

v11.CreateTeleportMenu = function()
    v11.TeleportFrame = Instance.new("Frame")
    v11.TeleportFrame.Name = "TeleportFrame"
    v11.TeleportFrame.Size = UDim2.new(0, 350, 0, 450)
    v11.TeleportFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    v11.TeleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v11.TeleportFrame.BorderSizePixel = 0
    v11.TeleportFrame.Visible = false
    v11.TeleportFrame.ZIndex = 100
    v11.TeleportFrame.Parent = v11.ScreenGui
    
    local v915 = Instance.new("UICorner")
    v915.CornerRadius = UDim.new(0, 12)
    v915.Parent = v11.TeleportFrame
    
    local v918 = Instance.new("UIStroke")
    v918.Color = Color3.fromRGB(80, 80, 90)
    v918.Thickness = 2
    v918.Parent = v11.TeleportFrame
    
    local v922 = Instance.new("Frame")
    v922.Name = "TitleFrame"
    v922.Size = UDim2.new(1, 0, 0, 40)
    v922.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    v922.BorderSizePixel = 0
    v922.Parent = v11.TeleportFrame
    
    local v928 = Instance.new("UICorner")
    v928.CornerRadius = UDim.new(0, 12)
    v928.Parent = v922
    
    local v931 = Instance.new("TextLabel")
    v931.Name = "TitleLabel"
    v931.Size = UDim2.new(1, 0, 1, 0)
    v931.BackgroundTransparency = 1
    v931.Text = "TELEPORT TO PLAYER"
    v931.TextColor3 = Color3.fromRGB(255, 255, 255)
    v931.TextSize = 16
    v931.Font = Enum.Font.GothamBold
    v931.Parent = v922
    
    v11.TeleportPlayersFrame = Instance.new("ScrollingFrame")
    v11.TeleportPlayersFrame.Name = "TeleportPlayersFrame"
    v11.TeleportPlayersFrame.Size = UDim2.new(1, -20, 1, -120)
    v11.TeleportPlayersFrame.Position = UDim2.new(0, 10, 0, 50)
    v11.TeleportPlayersFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    v11.TeleportPlayersFrame.BorderSizePixel = 0
    v11.TeleportPlayersFrame.ScrollBarThickness = 6
    v11.TeleportPlayersFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    v11.TeleportPlayersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    v11.TeleportPlayersFrame.Parent = v11.TeleportFrame
    
    local v951 = Instance.new("UICorner")
    v951.CornerRadius = UDim.new(0, 8)
    v951.Parent = v11.TeleportPlayersFrame
    
    local v954 = Instance.new("TextButton")
    v954.Name = "RefreshButton"
    v954.Size = UDim2.new(0, 120, 0, 35)
    v954.Position = UDim2.new(0, 20, 1, -60)
    v954.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    v954.BorderSizePixel = 0
    v954.Text = "REFRESH"
    v954.TextColor3 = Color3.fromRGB(255, 255, 255)
    v954.TextSize = 14
    v954.Font = Enum.Font.GothamBold
    v954.Parent = v11.TeleportFrame
    
    local v965 = Instance.new("UICorner")
    v965.CornerRadius = UDim.new(0, 8)
    v965.Parent = v954
    
    local v968 = Instance.new("TextButton")
    v968.Name = "CloseButton"
    v968.Size = UDim2.new(0, 120, 0, 35)
    v968.Position = UDim2.new(1, -140, 1, -60)
    v968.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    v968.BorderSizePixel = 0
    v968.Text = "CLOSE"
    v968.TextColor3 = Color3.fromRGB(255, 255, 255)
    v968.TextSize = 14
    v968.Font = Enum.Font.GothamBold
    v968.Parent = v11.TeleportFrame
    
    local v979 = Instance.new("UICorner")
    v979.CornerRadius = UDim.new(0, 8)
    v979.Parent = v968
    
    local v982 = false
    local v983, v984, v985
    
    local function v986(v1209)
        if v982 then
            local v1397 = v1209.Position - v984
            v11.TeleportFrame.Position = UDim2.new(
                v985.X.Scale,
                v985.X.Offset + v1397.X,
                v985.Y.Scale,
                v985.Y.Offset + v1397.Y
            )
        end
    end
    
    v922.InputBegan:Connect(function(v1210)
        if v1210.UserInputType == Enum.UserInputType.MouseButton1 then
            v982 = true
            v984 = v1210.Position
            v985 = v11.TeleportFrame.Position
        end
    end)
    
    v922.InputChanged:Connect(function(v1211)
        if v1211.UserInputType == Enum.UserInputType.MouseMovement then
            v983 = v1211
        end
    end)
    
    v2.InputChanged:Connect(function(v1212)
        if v1212 == v983 and v982 then
            v986(v1212)
        end
    end)
    
    v2.InputEnded:Connect(function(v1213)
        if v1213.UserInputType == Enum.UserInputType.MouseButton1 then
            v982 = false
        end
    end)
    
    v954.MouseButton1Click:Connect(function()
        v11.UpdateTeleportPlayersList()
    end)
    
    v968.MouseButton1Click:Connect(function()
        v11.TeleportFrame.Visible = false
    end)
end

v11.OpenTeleportMenu = function()
    if not v11.TeleportFrame then
        v11.CreateTeleportMenu()
    end
    
    v11.TeleportFrame.Visible = true
    v11.UpdateTeleportPlayersList()
end

v11.StartThirdPerson = function()
    if not v11.ThirdPersonEnabled then
        return
    end
    
    local v988 = v9.Character
    if not v988 then
        return
    end
    
    if not v11.IsPlayerKiller(v9) then
        print("Third Person: Available only for Killer")
        return
    end
    
    local v989 = v988:FindFirstChild("HumanoidRootPart")
    if not v989 then
        return
    end
    
    if not v11.OriginalCameraType then
        v11.OriginalCameraType = v6.CurrentCamera.CameraType
    end
    
    v6.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    v6.CurrentCamera.CameraSubject = v989
    print("Third Person View: ENABLED")
end

v11.StopThirdPerson = function()
    if v11.OriginalCameraType then
        v6.CurrentCamera.CameraType = v11.OriginalCameraType
        v11.OriginalCameraType = nil
    end
    
    local v993 = v9.Character
    if v993 then
        local v1307 = v993:FindFirstChildOfClass("Humanoid")
        if v1307 then
            v6.CurrentCamera.CameraSubject = v1307
        end
    end
    print("Third Person View: DISABLED")
end

v11.UpdateThirdPersonView = function()
    if not v11.ThirdPersonEnabled then
        return
    end
    
    local v994 = v9.Character
    if not v994 then
        return
    end
    
    local v995 = v994:FindFirstChild("HumanoidRootPart")
    if not v995 then
        return
    end
    
    local v996 = Vector3.new(0, 2, 8)
    local v997 = v995.CFrame.LookVector
    local v998 = (v995.Position - (v997 * v996.Z)) + Vector3.new(0, v996.Y, 0)
    v6.CurrentCamera.CFrame = CFrame.lookAt(v998, v995.Position + Vector3.new(0, 2, 0))
end

v11.ToggleThirdPerson = function(v1000)
    v11.ThirdPersonEnabled = v1000
    
    if v1000 and not v11.IsPlayerKiller(v9) then
        print("Third Person: You are not the Killer!")
        v11.ThirdPersonEnabled = false
        return
    end
    
    if v1000 then
        v11.StartThirdPerson()
        
        if v11.ThirdPersonConnection then
            v11.ThirdPersonConnection:Disconnect()
        end
        
        v11.ThirdPersonConnection = v1.RenderStepped:Connect(function()
            if not v11.ThirdPersonEnabled then
                v11.ThirdPersonConnection:Disconnect()
                v11.StopThirdPerson()
                return
            end
            
            if not v11.IsPlayerKiller(v9) then
                print("Third Person: You are no longer the Killer!")
                v11.ToggleThirdPerson(false)
                return
            end
            
            v11.UpdateThirdPersonView()
        end)
        
        v9.CharacterAdded:Connect(function()
            wait(1)
            if v11.ThirdPersonEnabled and v11.IsPlayerKiller(v9) then
                v11.StartThirdPerson()
            end
        end)
    else
        if v11.ThirdPersonConnection then
            v11.ThirdPersonConnection:Disconnect()
            v11.ThirdPersonConnection = nil
        end
        v11.StopThirdPerson()
    end
end

v11.CheckKillerRole = function()
    if v11.ThirdPersonEnabled and not v11.IsPlayerKiller(v9) then
        print("Auto-disabling Third Person: No longer Killer")
        v11.ToggleThirdPerson(false)
    end
end

coroutine.wrap(function()
    while true do
        wait(3)
        v11.CheckKillerRole()
    end
end)()

v11.CreateToggle("ESP Players", false, v11.ToggleESP, v11.ESPSettingsFrame)
v11.CreateToggle("ESP Generators", false, v11.ToggleGeneratorESP, v11.ESPSettingsFrame)
v11.CreateToggle("ESP Pallets", false, v11.TogglePalletESP, v11.ESPSettingsFrame)
v11.CreateToggle("RGB ESP Killer", false, v11.ToggleRGBESP, v11.ESPSettingsFrame)
v11.CreateSlider("RGB ESP Speed", 0.1, 5, 1, v11.UpdateRGBESPSpeed, v11.ESPSettingsFrame)
v11.CreateToggle("Super ESP", false, v11.ToggleSuperESP, v11.ESPSettingsFrame)
v11.CreateSlider("Super ESP Speed", 0.1, 5, 1, v11.UpdateSuperESPSpeed, v11.ESPSettingsFrame)

v11.CreateHSVColorPicker("Killer Color", v11.KillerColor, function(v1002)
    v11.KillerColor = v1002
    if v11.ESPEnabled then
        wait(0.1)
        v11.UpdateESP()
    end
end, v11.ESPColorsFrame)

v11.CreateHSVColorPicker("Survivor Color", v11.SurvivorColor, function(v1004)
    v11.SurvivorColor = v1004
    if v11.ESPEnabled then
        wait(0.1)
        v11.UpdateESP()
    end
end, v11.ESPColorsFrame)

v11.CreateHSVColorPicker("Generator Color", v11.GeneratorColor, function(v1006)
    v11.GeneratorColor = v1006
    if v11.GeneratorESPEnabled then
        wait(0.1)
        v11.UpdateGeneratorESP()
    end
end, v11.ESPColorsFrame)

v11.CreateHSVColorPicker("Pallet Color", v11.PalletColor, function(v1008)
    v11.PalletColor = v1008
    if v11.PalletESPEnabled then
        wait(0.1)
        v11.UpdatePalletESP()
    end
end, v11.ESPColorsFrame)

v11.walkSpeedActive = false
v11.walkSpeed = 16
v11.walkSpeedConnection = nil

v11.ToggleWalkSpeed = function(v1010)
    v11.walkSpeedActive = v1010
    
    if v11.walkSpeedConnection then
        v11.walkSpeedConnection:Disconnect()
        v11.walkSpeedConnection = nil
    end
    
    if v1010 then
        print("WalkSpeed: ENABLED")
        
        local function v1311()
            local v1401 = v9.Character
            if v1401 then
                local v1507 = v1401:FindFirstChildOfClass("Humanoid")
                if v1507 then
                    v1507.WalkSpeed = v11.walkSpeed
                    print("WalkSpeed set to: " .. v11.walkSpeed)
                    
                    v11.walkSpeedConnection = v1507:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                        if v11.walkSpeedActive and v1507.WalkSpeed ~= v11.walkSpeed then
                            v1507.WalkSpeed = v11.walkSpeed
                            print("WalkSpeed reset by server, reapplying: " .. v11.walkSpeed)
                        end
                    end)
                else
                    warn("Humanoid not found for WalkSpeed")
                end
            end
        end
        
        v1311()
        
        v9.CharacterAdded:Connect(function(v1402)
            wait(0.5)
            if v11.walkSpeedActive then
                v1311()
            end
        end)
    else
        print("WalkSpeed: DISABLED")
        local v1312 = v9.Character
        if v1312 then
            local v1458 = v1312:FindFirstChildOfClass("Humanoid")
            if v1458 then
                v1458.WalkSpeed = 16
                print("WalkSpeed reset to default: 16")
            end
        end
    end
end

v11.UpdateWalkSpeedValue = function(v1012)
    v11.walkSpeed = v1012
    print("WalkSpeed value updated to: " .. v1012)
    
    if v11.walkSpeedActive then
        local v1313 = v9.Character
        if v1313 then
            local v1459 = v1313:FindFirstChildOfClass("Humanoid")
            if v1459 then
                v1459.WalkSpeed = v11.walkSpeed
                print("WalkSpeed immediately updated to: " .. v11.walkSpeed)
            end
        end
    end
end

v11.ToggleJumpPower = function(v1014)
    v11.JumpPowerEnabled = v1014
    
    if v11.JumpPowerConnection then
        v11.JumpPowerConnection:Disconnect()
        v11.JumpPowerConnection = nil
    end
    
    if v1014 then
        print("Enabling JumpPower...")
        v11.UpdateJumpPower()
        
        v11.JumpPowerConnection = v9.CharacterAdded:Connect(function(v1403)
            print("New character detected, applying JumpPower...")
            
            for v1460 = 1, 3 do
                wait(1)
                v11.UpdateJumpPower()
            end
            
            local v1404 = v1403:WaitForChild("Humanoid", 5)
            if v1404 then
                v1404:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if v11.JumpPowerEnabled and v1404.JumpPower ~= v11.JumpPowerValue then
                        v1404.JumpPower = v11.JumpPowerValue
                        print("JumpPower corrected: " .. v11.JumpPowerValue)
                    end
                end)
                
                while v11.JumpPowerEnabled and v1403 and v1404 do
                    wait(2)
                    if v1404.JumpPower ~= v11.JumpPowerValue then
                        v1404.JumpPower = v11.JumpPowerValue
                        print("JumpPower force updated: " .. v11.JumpPowerValue)
                    end
                end
            end
        end)
        
        coroutine.wrap(function()
            while v11.JumpPowerEnabled do
                wait(3)
                v11.UpdateJumpPower()
            end
        end)()
    else
        local v1316 = v9.Character
        if v1316 then
            local v1461 = v1316:FindFirstChildOfClass("Humanoid")
            if v1461 then
                v1461.JumpPower = 50
            end
        end
        print("JumpPower: DISABLED")
    end
end

v11.UpdateJumpPowerValue = function(v1016)
    v11.JumpPowerValue = v1016
    print("JumpPower value changed to: " .. v1016)
    
    if v11.JumpPowerEnabled then
        v11.UpdateJumpPower()
    end
end

v11.StartRotatePerson = function()
    if v11.RotateConnection then
        v11.RotateConnection:Disconnect()
    end
    
    v11.RotateConnection = v1.Heartbeat:Connect(function()
        if not v11.RotatePersonEnabled then
            if v11.RotateConnection then
                v11.RotateConnection:Disconnect()
                v11.RotateConnection = nil
            end
            return
        end
        
        local v1215 = v9.Character
        if v1215 then
            local v1405 = v1215:FindFirstChild("HumanoidRootPart")
            if v1405 then
                local v1509 = v1405.CFrame
                local v1510 = CFrame.Angles(0, math.rad(v11.RotateSpeed) * 0.1, 0)
                v1405.CFrame = v1509 * v1510
            end
        end
    end)
end

v11.StopRotatePerson = function()
    if v11.RotateConnection then
        v11.RotateConnection:Disconnect()
        v11.RotateConnection = nil
    end
end

v11.ToggleRotatePerson = function(v1019)
    v11.RotatePersonEnabled = v1019
    
    if v1019 then
        v11.StartRotatePerson()
        print("Rotate Person: ENABLED (Speed: " .. v11.RotateSpeed .. ")")
    else
        v11.StopRotatePerson()
        print("Rotate Person: DISABLED")
    end
end

v11.UpdateRotateSpeed = function(v1021)
    v11.RotateSpeed = v1021
    print("Rotate Speed: " .. v1021)
    
    if v11.RotatePersonEnabled then
        v11.StopRotatePerson()
        v11.StartRotatePerson()
    end
end

v11.CreateToggle("Aimbot (Hold RMB)", false, v11.ToggleAimbot, v11.GameFeaturesFrame)
v11.CreateSlider("Aimbot FOV", 1, 200, 50, v11.UpdateAimbotFOV, v11.GameFeaturesFrame)
v11.CreateSlider("Aimbot Smoothness", 1, 100, 10, v11.UpdateAimbotSmoothness, v11.GameFeaturesFrame)
v11.CreateToggle("Team Check (Killer Only)", true, v11.ToggleAimbotTeamCheck, v11.GameFeaturesFrame)
v11.CreateToggle("Visible Check", true, v11.ToggleAimbotVisibleCheck, v11.GameFeaturesFrame)
v11.CreateToggle("Wall Check", false, v11.ToggleAimbotWallCheck, v11.GameFeaturesFrame)

coroutine.wrap(function()
    local v1023 = false
    while true do
        wait(5)
        local v1216 = false
        for v1318, v1319 in pairs(v0:GetPlayers()) do
            if v1319 ~= v9 then
                v1216 = true
                break
            end
        end
        
        local v1217 = v1216 and v11.MapLoaded
        
        if v1217 ~= v1023 then
            v1023 = v1217
            v11.GameStarted = v1217
            
            if v1217 then
                print("Game started - initializing systems")
            else
                print("Game ended - cleaning systems")
                v11.ESPManager:ClearAll()
                v11.ObjectESPManager:ClearAll()
            end
        end
    end
end)()

v11.ToggleCrosshair = function(v1024)
    v11.CrosshairEnabled = v1024
    v11.CrosshairFrame.Visible = v1024
    print("Crosshair: " .. (v1024 and "ENABLED" or "DISABLED"))
end

v11.CreateToggle("Crosshair", false, v11.ToggleCrosshair, v11.VisualSettingsFrame)
v11.CreateToggle("Rotate Person", false, v11.ToggleRotatePerson, v11.GameFeaturesFrame)
v11.CreateSlider("Rotate Speed", 0, 1000, 100, v11.UpdateRotateSpeed, v11.GameFeaturesFrame)
v11.CreateToggle("Walk Speed", false, v11.ToggleWalkSpeed, v11.GameFeaturesFrame)
v11.CreateSlider("Walk Speed Value", 16, 500, 16, v11.UpdateWalkSpeedValue, v11.GameFeaturesFrame)
v11.CreateToggle("JumpPower", false, v11.MovementFunctions.ToggleJumpPower, v11.GameFeaturesFrame)
v11.CreateSlider("JumpPower Value", 0, 500, 50, v11.MovementFunctions.UpdateJumpPowerValue, v11.GameFeaturesFrame)
v11.CreateToggle("Fly (WASD+Space+Shift)", false, v11.ToggleFly, v11.GameFeaturesFrame)
v11.CreateSlider("Fly Speed", 0, 500, 50, function(v1027)
    v11.FlySpeedValue = v1027
    print("Fly Speed: " .. v1027)
end, v11.GameFeaturesFrame)

v11.CreateToggle("Third Person View (Killer)", false, v11.ToggleThirdPerson, v11.GameFeaturesFrame)
v11.CreateToggle("Noclip", false, v11.ToggleNoclip, v11.GameFeaturesFrame)
v11.CreateToggle("God Mode", false, v11.ToggleGodMode, v11.GameFeaturesFrame)
v11.CreateToggle("Invisible", false, v11.ToggleInvisible, v11.GameFeaturesFrame)
v11.CreateToggle("AntiStun", false, v11.ToggleAntiStun, v11.GameFeaturesFrame)
v11.CreateToggle("AntiGrab", false, v11.ToggleAntiGrab, v11.GameFeaturesFrame)
v11.CreateToggle("100% Escape Chance", false, v11.ToggleMaxEscapeChance, v11.GameFeaturesFrame)
v11.CreateToggle("Grab Killer", false, v11.ToggleGrabKiller, v11.GameFeaturesFrame)
v11.CreateToggle("Rapid Fire (Twist of Fate)", false, v11.ToggleRapidFire, v11.GameFeaturesFrame)
v11.CreateToggle("Disable Twist Animations", false, v11.ToggleTwistAnimations, v11.GameFeaturesFrame)

v11.CreateButton("Teleport to Player", function()
    v11.OpenTeleportMenu()
end, v11.GameFeaturesFrame)

v11.CreateToggle("No Fog", false, v11.ToggleNoFog, v11.VisualSettingsFrame)
v11.CreateToggle("Custom Time", false, v11.ToggleTime, v11.VisualSettingsFrame)
v11.CreateSlider("Time Value", 0, 24, 12, function(v1029)
    v11.TimeValue = v1029
    if v11.TimeEnabled then
        v4.ClockTime = v1029
    end
end, v11.VisualSettingsFrame)

v11.CreateToggle("Map Color", false, v11.ToggleMapColor, v11.VisualSettingsFrame)
v11.CreateHSVColorPicker("Map Color Picker", v11.MapColor, function(v1031)
    v11.MapColor = v1031
    if v11.MapColorEnabled then
        v4.Ambient = v1031
        v4.OutdoorAmbient = v1031
    end
end, v11.VisualSettingsFrame)

v11.CreateSlider("Map Saturation", -1, 2, 1, function(v1033)
    v11.MapColorSaturation = v1033
    if v11.MapColorEnabled then
        if not v4:FindFirstChild("ColorCorrection") then
            local v1462 = Instance.new("ColorCorrectionEffect")
            v1462.Name = "ColorCorrection"
            v1462.Saturation = v1033
            v1462.Parent = v4
        else
            v4.ColorCorrection.Saturation = v1033
        end
    end
end, v11.VisualSettingsFrame)

v11.ToggleMenu = function()
    v11.MenuOpen = not v11.MenuOpen
    local v1036 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if v11.MenuOpen then
        local v1323 = v3:Create(v11.MainFrame, v1036, {Position = UDim2.new(0, 20, 0, 100)})
        v1323:Play()
        v11.UnlockCursor()
        print("Menu: OPENED")
    else
        local v1324 = v3:Create(v11.MainFrame, v1036, {Position = UDim2.new(0, -470, 0, 100)})
        v1324:Play()
        print("Menu: CLOSED")
    end
end

v2.InputBegan:Connect(function(v1037, v1038)
    if v1038 then
        return
    end
    
    if v1037.KeyCode == Enum.KeyCode.F1 then
        v11.ToggleMenu()
    elseif v1037.KeyCode == Enum.KeyCode.K then
        v11.AimbotFunctions.toggleAimbot()
    end
end)

v11.CreateSimpleNotification = function()
    local v1039 = Instance.new("TextLabel")
    v1039.Name = "Sishka52Hint"
    v1039.Size = UDim2.new(0, 200, 0, 40)
    v1039.Position = UDim2.new(0.5, -175, 0.5, -40)
    v1039.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v1039.BackgroundTransparency = 0.5
    v1039.Text = "Open Menu: F1 | Aimbot: K"
    v1039.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1039.TextSize = 14
    v1039.Font = Enum.Font.GothamBold
    v1039.TextStrokeTransparency = 0
    v1039.ZIndex = 1000
    v1039.Parent = v11.ScreenGui
    
    local v1054 = Instance.new("UICorner")
    v1054.CornerRadius = UDim.new(0, 8)
    v1054.Parent = v1039
    
    v1039.Position = UDim2.new(1, 300, 1, -50)
    local v1057 = v3:Create(v1039, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -50)})
    v1057:Play()
    
    delay(5, function()
        local v1218 = v3:Create(v1039, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -50)})
        v1218:Play()
        v1218.Completed:Connect(function()
            v1039:Destroy()
        end)
    end)
end

v11.CreateTeleportMenu()

coroutine.wrap(function()
    while true do
        wait(5)
        if v11.TeleportFrame and v11.TeleportFrame.Visible then
            v11.UpdateTeleportPlayersList()
        end
    end
end)()

v11.StartGameCheckers()
delay(1.5, v11.CreateSimpleNotification)
wait(2)
v11.UnlockCursor()
delay(60, function()
    v11.UnlockCursor()
end)

v11.ToggleMenu()

print("Violence District Ultimate loaded!")
print("F1 - Show/Hide menu")
print("K - Toggle aimbot ON/OFF")
print("Drag sliders to change values")
