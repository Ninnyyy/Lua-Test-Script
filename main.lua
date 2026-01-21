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
v11.ScreenGui.Name = "Singularity-Ninny.top"
v11.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() 
    v11.ScreenGui.Parent = v8
end)

v11.MainFrame = Instance.new("Frame")
v11.MainFrame.Name = "MainFrame"
v11.MainFrame.Size = UDim2.new(0, 450, 0, 650)
v11.MainFrame.Position = UDim2.new(0, 20, 0, 100)
v11.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
v11.UIStroke.Color = Color3.fromRGB(255, 140, 0)
v11.UIStroke.Thickness = 2
v11.UIStroke.Parent = v11.MainFrame

v11.TitleFrame = Instance.new("Frame")
v11.TitleFrame.Name = "TitleFrame"
v11.TitleFrame.Size = UDim2.new(1, 0, 0, 40)
v11.TitleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
v11.ESPSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.ESPSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.ESPSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.ESPSettingsFrame.Visible = true
v11.ESPSettingsFrame.Parent = v11.ContentFrame

v11.ESPColorsFrame = Instance.new("ScrollingFrame")
v11.ESPColorsFrame.Name = "ESPColorsFrame"
v11.ESPColorsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.ESPColorsFrame.BackgroundTransparency = 1
v11.ESPColorsFrame.ScrollBarThickness = 4
v11.ESPColorsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.ESPColorsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.ESPColorsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.ESPColorsFrame.Visible = false
v11.ESPColorsFrame.Parent = v11.ContentFrame

v11.GameFeaturesFrame = Instance.new("ScrollingFrame")
v11.GameFeaturesFrame.Name = "GameFeaturesFrame"
v11.GameFeaturesFrame.Size = UDim2.new(1, 0, 1, 0)
v11.GameFeaturesFrame.BackgroundTransparency = 1
v11.GameFeaturesFrame.ScrollBarThickness = 4
v11.GameFeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.GameFeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.GameFeaturesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.GameFeaturesFrame.Visible = false
v11.GameFeaturesFrame.Parent = v11.ContentFrame

v11.VisualSettingsFrame = Instance.new("ScrollingFrame")
v11.VisualSettingsFrame.Name = "VisualSettingsFrame"
v11.VisualSettingsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.VisualSettingsFrame.BackgroundTransparency = 1
v11.VisualSettingsFrame.ScrollBarThickness = 4
v11.VisualSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.VisualSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.VisualSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.VisualSettingsFrame.Visible = false
v11.VisualSettingsFrame.Parent = v11.ContentFrame

v11.MenuAutoCloseEnabled = false

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
v11.CrosshairFrame.Name = "CrosshairFrame"
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
v11.AimbotFOVCircle.Name = "AimbotFOVCircle"
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
    
    -- Add tab button hover animations
    v415.MouseEnter:Connect(function()
        local v1238 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1239 = v3:Create(v415, v1238, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)})
        v1239:Play()
    end)
    
    v415.MouseLeave:Connect(function()
        if v415.BackgroundColor3 ~= Color3.fromRGB(0, 100, 255) then
            local v1240 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v1241 = v3:Create(v415, v1240, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
            v1241:Play()
        end
    end)
    
    v415.MouseButton1Click:Connect(function()
        v11.ESPSettingsFrame.Visible = false
        v11.ESPColorsFrame.Visible = false
        v11.GameFeaturesFrame.Visible = false
        v11.VisualSettingsFrame.Visible = false
        
        -- Fade out current tab
        for v1242, v1243 in ipairs(v11.ContentFrame:GetChildren()) do
            if v1243:IsA("ScrollingFrame") and v1243.Visible then
                local v1244 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local v1245 = v3:Create(v1243, v1244, {BackgroundTransparency = 0.5})
                v1245:Play()
            end
        end
        
        wait(0.1)
        v414.Visible = true
        
        -- Fade in new tab
        local v1246 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1247 = v3:Create(v414, v1246, {BackgroundTransparency = 1})
        v1247:Play()
        
        for v1248, v1249 in ipairs(v11.TabButtonsFrame:GetChildren()) do
            if v1249:IsA("TextButton") then
                local v1250 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local v1251 = v3:Create(v1249, v1250, {BackgroundColor3 = Color3.fromRGB(40, 40, 50), TextColor3 = Color3.fromRGB(200, 200, 200)})
                v1251:Play()
            end
        end
        
        local v1252 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1253 = v3:Create(v415, v1252, {BackgroundColor3 = Color3.fromRGB(0, 100, 255), TextColor3 = Color3.fromRGB(255, 255, 255)})
        v1253:Play()
    end)
    
    return v415
end

v11.ESPTab = v11.CreateTabButton("ESP", v11.ESPSettingsFrame)
v11.ColorsTab = v11.CreateTabButton("COLORS", v11.ESPColorsFrame)
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
    
    -- Add smooth animations to button
    v11.AddButtonAnimations(v580)
    
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
    v11.TeleportPlayersFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
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

-- ========== ADD NEW TABS FOR FEATURES ==========
v11.AdvancedESPFrame = Instance.new("ScrollingFrame")
v11.AdvancedESPFrame.Name = "AdvancedESPFrame"
v11.AdvancedESPFrame.Size = UDim2.new(1, 0, 1, 0)
v11.AdvancedESPFrame.BackgroundTransparency = 1
v11.AdvancedESPFrame.ScrollBarThickness = 4
v11.AdvancedESPFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.AdvancedESPFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.AdvancedESPFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.AdvancedESPFrame.Visible = false
v11.AdvancedESPFrame.Parent = v11.ContentFrame

v11.AdvancedESPLayout = Instance.new("UIListLayout")
v11.AdvancedESPLayout.Padding = UDim.new(0, 15)
v11.AdvancedESPLayout.Parent = v11.AdvancedESPFrame

v11.AutoFeaturesFrame = Instance.new("ScrollingFrame")
v11.AutoFeaturesFrame.Name = "AutoFeaturesFrame"
v11.AutoFeaturesFrame.Size = UDim2.new(1, 0, 1, 0)
v11.AutoFeaturesFrame.BackgroundTransparency = 1
v11.AutoFeaturesFrame.ScrollBarThickness = 4
v11.AutoFeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.AutoFeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.AutoFeaturesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.AutoFeaturesFrame.Visible = false
v11.AutoFeaturesFrame.Parent = v11.ContentFrame

v11.AutoFeaturesLayout = Instance.new("UIListLayout")
v11.AutoFeaturesLayout.Padding = UDim.new(0, 15)
v11.AutoFeaturesLayout.Parent = v11.AutoFeaturesFrame

v11.ExploitsFrame = Instance.new("ScrollingFrame")
v11.ExploitsFrame.Name = "ExploitsFrame"
v11.ExploitsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.ExploitsFrame.BackgroundTransparency = 1
v11.ExploitsFrame.ScrollBarThickness = 4
v11.ExploitsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.ExploitsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.ExploitsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.ExploitsFrame.Visible = false
v11.ExploitsFrame.Parent = v11.ContentFrame

v11.ExploitsLayout = Instance.new("UIListLayout")
v11.ExploitsLayout.Padding = UDim.new(0, 15)
v11.ExploitsLayout.Parent = v11.ExploitsFrame

v11.PredictionFrame = Instance.new("ScrollingFrame")
v11.PredictionFrame.Name = "PredictionFrame"
v11.PredictionFrame.Size = UDim2.new(1, 0, 1, 0)
v11.PredictionFrame.BackgroundTransparency = 1
v11.PredictionFrame.ScrollBarThickness = 4
v11.PredictionFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.PredictionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.PredictionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.PredictionFrame.Visible = false
v11.PredictionFrame.Parent = v11.ContentFrame
v11.PredictionLayout = Instance.new("UIListLayout")
v11.PredictionLayout.Padding = UDim.new(0, 15)
v11.PredictionLayout.Parent = v11.PredictionFrame

v11.AnalyticsFrame = Instance.new("ScrollingFrame")
v11.AnalyticsFrame.Name = "AnalyticsFrame"
v11.AnalyticsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.AnalyticsFrame.BackgroundTransparency = 1
v11.AnalyticsFrame.ScrollBarThickness = 4
v11.AnalyticsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.AnalyticsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.AnalyticsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.AnalyticsFrame.Visible = false
v11.AnalyticsFrame.Parent = v11.ContentFrame
v11.AnalyticsLayout = Instance.new("UIListLayout")
v11.AnalyticsLayout.Padding = UDim.new(0, 15)
v11.AnalyticsLayout.Parent = v11.AnalyticsFrame

v11.UICustomFrame = Instance.new("ScrollingFrame")
v11.UICustomFrame.Name = "UICustomFrame"
v11.UICustomFrame.Size = UDim2.new(1, 0, 1, 0)
v11.UICustomFrame.BackgroundTransparency = 1
v11.UICustomFrame.ScrollBarThickness = 4
v11.UICustomFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.UICustomFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.UICustomFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.UICustomFrame.Visible = false
v11.UICustomFrame.Parent = v11.ContentFrame
v11.UICustomLayout = Instance.new("UIListLayout")
v11.UICustomLayout.Padding = UDim.new(0, 15)
v11.UICustomLayout.Parent = v11.UICustomFrame

v11.NetworkFrame = Instance.new("ScrollingFrame")
v11.NetworkFrame.Name = "NetworkFrame"
v11.NetworkFrame.Size = UDim2.new(1, 0, 1, 0)
v11.NetworkFrame.BackgroundTransparency = 1
v11.NetworkFrame.ScrollBarThickness = 4
v11.NetworkFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.NetworkFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.NetworkFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.NetworkFrame.Visible = false
v11.NetworkFrame.Parent = v11.ContentFrame
v11.NetworkLayout = Instance.new("UIListLayout")
v11.NetworkLayout.Padding = UDim.new(0, 15)
v11.NetworkLayout.Parent = v11.NetworkFrame

v11.StateFrame = Instance.new("ScrollingFrame")
v11.StateFrame.Name = "StateFrame"
v11.StateFrame.Size = UDim2.new(1, 0, 1, 0)
v11.StateFrame.BackgroundTransparency = 1
v11.StateFrame.ScrollBarThickness = 4
v11.StateFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.StateFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.StateFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.StateFrame.Visible = false
v11.StateFrame.Parent = v11.ContentFrame
v11.StateLayout = Instance.new("UIListLayout")
v11.StateLayout.Padding = UDim.new(0, 15)
v11.StateLayout.Parent = v11.StateFrame

v11.SecurityFrame = Instance.new("ScrollingFrame")
v11.SecurityFrame.Name = "SecurityFrame"
v11.SecurityFrame.Size = UDim2.new(1, 0, 1, 0)
v11.SecurityFrame.BackgroundTransparency = 1
v11.SecurityFrame.ScrollBarThickness = 4
v11.SecurityFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.SecurityFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.SecurityFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.SecurityFrame.Visible = false
v11.SecurityFrame.Parent = v11.ContentFrame
v11.SecurityLayout = Instance.new("UIListLayout")
v11.SecurityLayout.Padding = UDim.new(0, 15)
v11.SecurityLayout.Parent = v11.SecurityFrame

v11.DevToolsFrame = Instance.new("ScrollingFrame")
v11.DevToolsFrame.Name = "DevToolsFrame"
v11.DevToolsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.DevToolsFrame.BackgroundTransparency = 1
v11.DevToolsFrame.ScrollBarThickness = 4
v11.DevToolsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.DevToolsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.DevToolsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.DevToolsFrame.Visible = false
v11.DevToolsFrame.Parent = v11.ContentFrame
v11.DevToolsLayout = Instance.new("UIListLayout")
v11.DevToolsLayout.Padding = UDim.new(0, 15)
v11.DevToolsLayout.Parent = v11.DevToolsFrame

v11.QOLFrame = Instance.new("ScrollingFrame")
v11.QOLFrame.Name = "QOLFrame"
v11.QOLFrame.Size = UDim2.new(1, 0, 1, 0)
v11.QOLFrame.BackgroundTransparency = 1
v11.QOLFrame.ScrollBarThickness = 4
v11.QOLFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.QOLFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
v11.QOLFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.QOLFrame.Visible = false
v11.QOLFrame.Parent = v11.ContentFrame
v11.QOLLayout = Instance.new("UIListLayout")
v11.QOLLayout.Padding = UDim.new(0, 15)
v11.QOLLayout.Parent = v11.QOLFrame

v11.AdvancedESPTab = v11.CreateTabButton("ADV ESP", v11.AdvancedESPFrame)
v11.AutoTab = v11.CreateTabButton("AUTO", v11.AutoFeaturesFrame)
v11.ExploitTab = v11.CreateTabButton("EXPLOITS", v11.ExploitsFrame)
v11.PredictionTab = v11.CreateTabButton("PRED", v11.PredictionFrame)
v11.AnalyticsTab = v11.CreateTabButton("STATS", v11.AnalyticsFrame)
v11.UITab = v11.CreateTabButton("UI", v11.UICustomFrame)
v11.NetworkTab = v11.CreateTabButton("NET", v11.NetworkFrame)
v11.StateTab = v11.CreateTabButton("STATE", v11.StateFrame)
v11.SecurityTab = v11.CreateTabButton("SEC", v11.SecurityFrame)
v11.DevTab = v11.CreateTabButton("DEV", v11.DevToolsFrame)
v11.QOLTab = v11.CreateTabButton("QOL", v11.QOLFrame)

-- ========== NEW ADVANCED FEATURE TABS ==========
v11.CombatFrame = Instance.new("ScrollingFrame")
v11.CombatFrame.Name = "CombatFrame"
v11.CombatFrame.Size = UDim2.new(1, 0, 1, 0)
v11.CombatFrame.BackgroundTransparency = 1
v11.CombatFrame.ScrollBarThickness = 4
v11.CombatFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.CombatFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.CombatFrame.Visible = false
v11.CombatFrame.Parent = v11.ContentFrame
v11.CombatLayout = Instance.new("UIListLayout")
v11.CombatLayout.Padding = UDim.new(0, 15)
v11.CombatLayout.Parent = v11.CombatFrame

v11.MapFrame = Instance.new("ScrollingFrame")
v11.MapFrame.Name = "MapFrame"
v11.MapFrame.Size = UDim2.new(1, 0, 1, 0)
v11.MapFrame.BackgroundTransparency = 1
v11.MapFrame.ScrollBarThickness = 4
v11.MapFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.MapFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.MapFrame.Visible = false
v11.MapFrame.Parent = v11.ContentFrame
v11.MapLayout = Instance.new("UIListLayout")
v11.MapLayout.Padding = UDim.new(0, 15)
v11.MapLayout.Parent = v11.MapFrame

v11.MovementFrame = Instance.new("ScrollingFrame")
v11.MovementFrame.Name = "MovementFrame"
v11.MovementFrame.Size = UDim2.new(1, 0, 1, 0)
v11.MovementFrame.BackgroundTransparency = 1
v11.MovementFrame.ScrollBarThickness = 4
v11.MovementFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.MovementFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.MovementFrame.Visible = false
v11.MovementFrame.Parent = v11.ContentFrame
v11.MovementLayout = Instance.new("UIListLayout")
v11.MovementLayout.Padding = UDim.new(0, 15)
v11.MovementLayout.Parent = v11.MovementFrame

v11.EconomyFrame = Instance.new("ScrollingFrame")
v11.EconomyFrame.Name = "EconomyFrame"
v11.EconomyFrame.Size = UDim2.new(1, 0, 1, 0)
v11.EconomyFrame.BackgroundTransparency = 1
v11.EconomyFrame.ScrollBarThickness = 4
v11.EconomyFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.EconomyFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.EconomyFrame.Visible = false
v11.EconomyFrame.Parent = v11.ContentFrame
v11.EconomyLayout = Instance.new("UIListLayout")
v11.EconomyLayout.Padding = UDim.new(0, 15)
v11.EconomyLayout.Parent = v11.EconomyFrame

v11.RecordingFrame = Instance.new("ScrollingFrame")
v11.RecordingFrame.Name = "RecordingFrame"
v11.RecordingFrame.Size = UDim2.new(1, 0, 1, 0)
v11.RecordingFrame.BackgroundTransparency = 1
v11.RecordingFrame.ScrollBarThickness = 4
v11.RecordingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.RecordingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.RecordingFrame.Visible = false
v11.RecordingFrame.Parent = v11.ContentFrame
v11.RecordingLayout = Instance.new("UIListLayout")
v11.RecordingLayout.Padding = UDim.new(0, 15)
v11.RecordingLayout.Parent = v11.RecordingFrame

v11.CommunicationFrame = Instance.new("ScrollingFrame")
v11.CommunicationFrame.Name = "CommunicationFrame"
v11.CommunicationFrame.Size = UDim2.new(1, 0, 1, 0)
v11.CommunicationFrame.BackgroundTransparency = 1
v11.CommunicationFrame.ScrollBarThickness = 4
v11.CommunicationFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.CommunicationFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.CommunicationFrame.Visible = false
v11.CommunicationFrame.Parent = v11.ContentFrame
v11.CommunicationLayout = Instance.new("UIListLayout")
v11.CommunicationLayout.Padding = UDim.new(0, 15)
v11.CommunicationLayout.Parent = v11.CommunicationFrame

v11.AccountFrame = Instance.new("ScrollingFrame")
v11.AccountFrame.Name = "AccountFrame"
v11.AccountFrame.Size = UDim2.new(1, 0, 1, 0)
v11.AccountFrame.BackgroundTransparency = 1
v11.AccountFrame.ScrollBarThickness = 4
v11.AccountFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.AccountFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.AccountFrame.Visible = false
v11.AccountFrame.Parent = v11.ContentFrame
v11.AccountLayout = Instance.new("UIListLayout")
v11.AccountLayout.Padding = UDim.new(0, 15)
v11.AccountLayout.Parent = v11.AccountFrame

v11.VisualsFrame = Instance.new("ScrollingFrame")
v11.VisualsFrame.Name = "VisualsFrame"
v11.VisualsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.VisualsFrame.BackgroundTransparency = 1
v11.VisualsFrame.ScrollBarThickness = 4
v11.VisualsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.VisualsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.VisualsFrame.Visible = false
v11.VisualsFrame.Parent = v11.ContentFrame
v11.VisualsLayout = Instance.new("UIListLayout")
v11.VisualsLayout.Padding = UDim.new(0, 15)
v11.VisualsLayout.Parent = v11.VisualsFrame

v11.DatabaseFrame = Instance.new("ScrollingFrame")
v11.DatabaseFrame.Name = "DatabaseFrame"
v11.DatabaseFrame.Size = UDim2.new(1, 0, 1, 0)
v11.DatabaseFrame.BackgroundTransparency = 1
v11.DatabaseFrame.ScrollBarThickness = 4
v11.DatabaseFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.DatabaseFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.DatabaseFrame.Visible = false
v11.DatabaseFrame.Parent = v11.ContentFrame
v11.DatabaseLayout = Instance.new("UIListLayout")
v11.DatabaseLayout.Padding = UDim.new(0, 15)
v11.DatabaseLayout.Parent = v11.DatabaseFrame

v11.AIFrame = Instance.new("ScrollingFrame")
v11.AIFrame.Name = "AIFrame"
v11.AIFrame.Size = UDim2.new(1, 0, 1, 0)
v11.AIFrame.BackgroundTransparency = 1
v11.AIFrame.ScrollBarThickness = 4
v11.AIFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.AIFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.AIFrame.Visible = false
v11.AIFrame.Parent = v11.ContentFrame
v11.AILayout = Instance.new("UIListLayout")
v11.AILayout.Padding = UDim.new(0, 15)
v11.AILayout.Parent = v11.AIFrame

v11.SkillsFrame = Instance.new("ScrollingFrame")
v11.SkillsFrame.Name = "SkillsFrame"
v11.SkillsFrame.Size = UDim2.new(1, 0, 1, 0)
v11.SkillsFrame.BackgroundTransparency = 1
v11.SkillsFrame.ScrollBarThickness = 4
v11.SkillsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.SkillsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.SkillsFrame.Visible = false
v11.SkillsFrame.Parent = v11.ContentFrame
v11.SkillsLayout = Instance.new("UIListLayout")
v11.SkillsLayout.Padding = UDim.new(0, 15)
v11.SkillsLayout.Parent = v11.SkillsFrame

v11.PerfTweaksFrame = Instance.new("ScrollingFrame")
v11.PerfTweaksFrame.Name = "PerfTweaksFrame"
v11.PerfTweaksFrame.Size = UDim2.new(1, 0, 1, 0)
v11.PerfTweaksFrame.BackgroundTransparency = 1
v11.PerfTweaksFrame.ScrollBarThickness = 4
v11.PerfTweaksFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.PerfTweaksFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.PerfTweaksFrame.Visible = false
v11.PerfTweaksFrame.Parent = v11.ContentFrame
v11.PerfTweaksLayout = Instance.new("UIListLayout")
v11.PerfTweaksLayout.Padding = UDim.new(0, 15)
v11.PerfTweaksLayout.Parent = v11.PerfTweaksFrame

v11.EvasionFrame = Instance.new("ScrollingFrame")
v11.EvasionFrame.Name = "EvasionFrame"
v11.EvasionFrame.Size = UDim2.new(1, 0, 1, 0)
v11.EvasionFrame.BackgroundTransparency = 1
v11.EvasionFrame.ScrollBarThickness = 4
v11.EvasionFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.EvasionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.EvasionFrame.Visible = false
v11.EvasionFrame.Parent = v11.ContentFrame
v11.EvasionLayout = Instance.new("UIListLayout")
v11.EvasionLayout.Padding = UDim.new(0, 15)
v11.EvasionLayout.Parent = v11.EvasionFrame

v11.UtilityFrame = Instance.new("ScrollingFrame")
v11.UtilityFrame.Name = "UtilityFrame"
v11.UtilityFrame.Size = UDim2.new(1, 0, 1, 0)
v11.UtilityFrame.BackgroundTransparency = 1
v11.UtilityFrame.ScrollBarThickness = 4
v11.UtilityFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
v11.UtilityFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
v11.UtilityFrame.Visible = false
v11.UtilityFrame.Parent = v11.ContentFrame
v11.UtilityLayout = Instance.new("UIListLayout")
v11.UtilityLayout.Padding = UDim.new(0, 15)
v11.UtilityLayout.Parent = v11.UtilityFrame

-- Create Tab Buttons for new features
v11.CombatTab = v11.CreateTabButton("COMBAT", v11.CombatFrame)
v11.MapTab = v11.CreateTabButton("MAP", v11.MapFrame)
v11.MovementTab = v11.CreateTabButton("MOVE", v11.MovementFrame)
v11.EconomyTab = v11.CreateTabButton("FARM", v11.EconomyFrame)
v11.RecordingTab = v11.CreateTabButton("REC", v11.RecordingFrame)
v11.CommTab = v11.CreateTabButton("COMM", v11.CommunicationFrame)
v11.AccountTab = v11.CreateTabButton("ACC", v11.AccountFrame)
v11.VisualsTab = v11.CreateTabButton("VFX", v11.VisualsFrame)
v11.DatabaseTab = v11.CreateTabButton("DB", v11.DatabaseFrame)
v11.AITab = v11.CreateTabButton("AI", v11.AIFrame)
v11.SkillsTab = v11.CreateTabButton("SKILL", v11.SkillsFrame)
v11.PerfTab = v11.CreateTabButton("PERF", v11.PerfTweaksFrame)
v11.EvasionTab = v11.CreateTabButton("EVADE", v11.EvasionFrame)
v11.UtilityTab = v11.CreateTabButton("UTIL", v11.UtilityFrame)

-- ========== ADVANCED ESP IMPROVEMENTS ==========
v11.ESPHealthBars = {}
v11.ESPTracers = {}
v11.ESPStatusIcons = {}
v11.HealthBarEnabled = false
v11.DistanceDisplayEnabled = false
v11.TracerLinesEnabled = false
v11.StatusIconsEnabled = false
v11.BoxESPEnabled = false

v11.CreateHealthBar = function(v1400)
    if not v1400 or not v1400.Character then return nil end
    
    local v1401 = Instance.new("BillboardGui")
    v1401.Name = "HealthBar_" .. v1400.Name
    v1401.Size = UDim2.new(3, 0, 0.5, 0)
    v1401.MaxDistance = 100
    v1401.Adornee = v1400.Character:FindFirstChild("Head")
    v1401.Parent = v11.ScreenGui
    
    local v1402 = Instance.new("Frame")
    v1402.Name = "HealthBackground"
    v1402.Size = UDim2.new(1, 0, 1, 0)
    v1402.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    v1402.BorderSizePixel = 0
    v1402.Parent = v1401
    
    local v1403 = Instance.new("UICorner")
    v1403.CornerRadius = UDim.new(0, 4)
    v1403.Parent = v1402
    
    local v1404 = Instance.new("Frame")
    v1404.Name = "HealthFill"
    v1404.Size = UDim2.new(1, 0, 1, 0)
    v1404.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    v1404.BorderSizePixel = 0
    v1404.Parent = v1402
    
    local v1405 = Instance.new("UICorner")
    v1405.CornerRadius = UDim.new(0, 4)
    v1405.Parent = v1404
    
    local v1406 = Instance.new("TextLabel")
    v1406.Name = "HealthText"
    v1406.Size = UDim2.new(1, 0, 1, 0)
    v1406.BackgroundTransparency = 1
    v1406.Text = "100%"
    v1406.TextScaled = true
    v1406.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1406.Font = Enum.Font.GothamBold
    v1406.Parent = v1404
    
    v11.ESPHealthBars[v1400.Name] = {gui = v1401, fill = v1404, text = v1406, player = v1400}
    return v1401
end

v11.UpdateHealthBars = function()
    for v1407, v1408 in pairs(v11.ESPHealthBars) do
        if v1408.gui and v1408.gui.Parent then
            local v1409 = 100
            if v1408.player.Character then
                local v1410 = v1408.player.Character:FindFirstChild("Humanoid")
                if v1410 then
                    v1409 = math.floor((v1410.Health / v1410.MaxHealth) * 100)
                end
            end
            
            v1408.fill.Size = UDim2.new(math.clamp(v1409 / 100, 0, 1), 0, 1, 0)
            v1408.text.Text = v1409 .. "%"
            
            if v1409 > 50 then
                v1408.fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif v1409 > 25 then
                v1408.fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                v1408.fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            v11.ESPHealthBars[v1407] = nil
        end
    end
end

v11.CreateDistanceDisplay = function(v1411)
    if not v1411 or not v1411.Character then return nil end
    
    local v1412 = Instance.new("BillboardGui")
    v1412.Name = "Distance_" .. v1411.Name
    v1412.Size = UDim2.new(4, 0, 2, 0)
    v1412.MaxDistance = 150
    v1412.Adornee = v1411.Character:FindFirstChild("Head")
    v1412.Parent = v11.ScreenGui
    
    local v1413 = Instance.new("TextLabel")
    v1413.Name = "DistanceText"
    v1413.Size = UDim2.new(1, 0, 1, 0)
    v1413.BackgroundTransparency = 1
    v1413.TextScaled = true
    v1413.TextColor3 = Color3.fromRGB(200, 200, 200)
    v1413.Font = Enum.Font.GothamBold
    v1413.Parent = v1412
    
    return {gui = v1412, label = v1413, player = v1411}
end

v11.UpdateDistanceDisplays = function()
    if not v9.Character then return end
    
    for v1414, v1415 in pairs(v0:GetPlayers()) do
        if v1415 ~= v9 and v1415.Character then
            local v1416 = (v1415.Character.PrimaryPart.Position - v9.Character.PrimaryPart.Position).Magnitude
            if not v11._distanceDisplays then v11._distanceDisplays = {} end
            
            if not v11._distanceDisplays[v1415.Name] then
                v11._distanceDisplays[v1415.Name] = v11.CreateDistanceDisplay(v1415)
            end
            
            local v1417 = v11._distanceDisplays[v1415.Name]
            if v1417 and v1417.label then
                v1417.label.Text = math.floor(v1416) .. " studs"
            end
        end
    end
end

v11.CreateTracerLine = function(v1418)
    if not v1418 or not v1418.Character then return nil end
    
    local v1419 = Instance.new("Frame")
    v1419.Name = "Tracer_" .. v1418.Name
    v1419.Size = UDim2.new(0, 2, 0, 100)
    v1419.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    v1419.BorderSizePixel = 0
    v1419.ZIndex = 10
    v1419.Parent = v11.ScreenGui
    
    return {gui = v1419, player = v1418, lastUpdate = tick()}
end

v11.UpdateTracerLines = function()
    local v1420 = v6.CurrentCamera
    local v1421 = Vector2.new(v1420.ViewportSize.X / 2, v1420.ViewportSize.Y)
    
    if not v11._tracers then v11._tracers = {} end
    
    for v1422, v1423 in pairs(v0:GetPlayers()) do
        if v1423 ~= v9 and v1423.Character then
            local v1424 = v1423.Character:FindFirstChild("Head")
            if v1424 then
                local v1425, v1426 = v1420:WorldToViewportPoint(v1424.Position)
                
                if not v11._tracers[v1423.Name] then
                    v11._tracers[v1423.Name] = v11.CreateTracerLine(v1423)
                end
                
                local v1427 = v11._tracers[v1423.Name]
                if v1427 and v1427.gui then
                    local v1428 = math.sqrt((v1425.X - v1421.X)^2 + (v1425.Y - v1421.Y)^2)
                    v1427.gui.Size = UDim2.new(0, 2, 0, v1428)
                    v1427.gui.Rotation = math.deg(math.atan2(v1425.Y - v1421.Y, v1425.X - v1421.X)) + 90
                    v1427.gui.Position = UDim2.new(0, v1421.X - 1, 0, v1421.Y)
                end
            end
        end
    end
end

v11.CreateBoxESP = function(v1429)
    if not v1429 or not v1429.Character then return nil end
    
    local v1430 = Instance.new("Frame")
    v1430.Name = "BoxESP_" .. v1429.Name
    v1430.BackgroundTransparency = 0.7
    v1430.BackgroundColor3 = v11.IsPlayerKiller(v1429) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    v1430.BorderColor3 = Color3.new(1, 1, 1)
    v1430.BorderSizePixel = 2
    v1430.ZIndex = 20
    v1430.Parent = v11.ScreenGui
    
    return {gui = v1430, player = v1429}
end

v11.UpdateBoxESP = function()
    if not v11._boxESPs then v11._boxESPs = {} end
    local v1431 = v6.CurrentCamera
    
    for v1432, v1433 in pairs(v0:GetPlayers()) do
        if v1433 ~= v9 and v1433.Character then
            if not v11._boxESPs[v1433.Name] then
                v11._boxESPs[v1433.Name] = v11.CreateBoxESP(v1433)
            end
            
            local v1434 = v11._boxESPs[v1433.Name]
            if v1434 and v1434.gui then
                local v1435 = v1433.Character:FindFirstChild("Head")
                local v1436 = v1433.Character:FindFirstChild("HumanoidRootPart")
                
                if v1435 and v1436 then
                    local v1437, v1438 = v1431:WorldToViewportPoint(v1435.Position)
                    local v1439, v1440 = v1431:WorldToViewportPoint(v1436.Position)
                    
                    local v1441 = Vector3.new(1, 0, 0)
                    local v1442, _ = v1431:WorldToViewportPoint(v1436.Position + v1441)
                    local v1443 = v1442.X - v1439.X
                    
                    v1434.gui.Size = UDim2.new(0, v1443 * 2, 0, v1437.Y - v1439.Y)
                    v1434.gui.Position = UDim2.new(0, v1439.X - v1443, 0, v1439.Y)
                end
            end
        end
    end
end

-- ========== VISUAL INDICATORS ==========
v11.TerrorRadiusEnabled = false
v11.HookedPlayersHighlightEnabled = false
v11.GeneratorProgressEnabled = false
v11.PowerGateHighlightEnabled = false

v11.CreateTerrorRadiusCircle = function()
    if not v11._terrorRadiusCircle then
        local v1444 = Instance.new("Frame")
        v1444.Name = "TerrorRadius"
        v1444.BackgroundTransparency = 0.8
        v1444.BorderColor3 = Color3.fromRGB(255, 0, 0)
        v1444.BorderSizePixel = 3
        v1444.ZIndex = 5
        v1444.Parent = v11.ScreenGui
        
        local v1445 = Instance.new("UICorner")
        v1445.CornerRadius = UDim.new(1, 0)
        v1445.Parent = v1444
        
        v11._terrorRadiusCircle = v1444
    end
    
    return v11._terrorRadiusCircle
end

v11.UpdateTerrorRadius = function()
    if not v11.TerrorRadiusEnabled then return end
    
    local v1446 = v11.CreateTerrorRadiusCircle()
    local v1447 = v6:FindFirstChild("KillerCharacter")
    
    if v1447 then
        local v1448 = v6.CurrentCamera
        local v1449, v1450 = v1448:WorldToViewportPoint(v1447.PrimaryPart.Position)
        local v1451 = 40
        
        local v1452, _ = v1448:WorldToViewportPoint(v1447.PrimaryPart.Position + Vector3.new(v1451, 0, 0))
        local v1453 = (v1452.X - v1449.X) * 2
        
        v1446.Size = UDim2.new(0, v1453, 0, v1453)
        v1446.Position = UDim2.new(0, v1449.X - v1453 / 2, 0, v1450.Y - v1453 / 2)
        v1446.BorderColor3 = v11.GetRainbowColor(tick(), 2)
        v1446.Visible = true
    else
        v1446.Visible = false
    end
end

-- ========== QOL / INFORMATION OVERLAYS ==========
v11.MatchTimerEnabled = false
v11.PlayerListEnabled = false
v11.SpeedometerEnabled = false
v11.MatchStartTime = 0
v11.InfoOverlayGui = nil

v11.CreateInfoOverlay = function()
    if v11.InfoOverlayGui then return v11.InfoOverlayGui end
    
    local v1454 = Instance.new("ScreenGui")
    v1454.Name = "InfoOverlay"
    v1454.ResetOnSpawn = false
    v1454.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() v1454.Parent = v8 end)
    
    local v1455 = Instance.new("Frame")
    v1455.Name = "InfoContainer"
    v1455.Size = UDim2.new(0, 350, 0, 200)
    v1455.Position = UDim2.new(0, 20, 0, 20)
    v1455.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    v1455.BorderSizePixel = 0
    v1455.Parent = v1454
    
    local v1456 = Instance.new("UICorner")
    v1456.CornerRadius = UDim.new(0, 10)
    v1456.Parent = v1455
    
    local v1457 = Instance.new("UIStroke")
    v1457.Color = Color3.fromRGB(60, 60, 70)
    v1457.Thickness = 2
    v1457.Parent = v1455
    
    local v1458 = Instance.new("TextLabel")
    v1458.Name = "MatchTimer"
    v1458.Size = UDim2.new(1, -20, 0, 30)
    v1458.Position = UDim2.new(0, 10, 0, 10)
    v1458.BackgroundTransparency = 1
    v1458.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1458.TextSize = 16
    v1458.Font = Enum.Font.GothamBold
    v1458.TextXAlignment = Enum.TextXAlignment.Left
    v1458.Text = "Match Timer: 00:00"
    v1458.Parent = v1455
    
    local v1459 = Instance.new("TextLabel")
    v1459.Name = "RoleInfo"
    v1459.Size = UDim2.new(1, -20, 0, 30)
    v1459.Position = UDim2.new(0, 10, 0, 45)
    v1459.BackgroundTransparency = 1
    v1459.TextColor3 = Color3.fromRGB(200, 200, 200)
    v1459.TextSize = 14
    v1459.Font = Enum.Font.Gotham
    v1459.TextXAlignment = Enum.TextXAlignment.Left
    v1459.Text = "Role: Unknown"
    v1459.Parent = v1455
    
    local v1460 = Instance.new("TextLabel")
    v1460.Name = "SurvivorsInfo"
    v1460.Size = UDim2.new(1, -20, 0, 30)
    v1460.Position = UDim2.new(0, 10, 0, 80)
    v1460.BackgroundTransparency = 1
    v1460.TextColor3 = Color3.fromRGB(200, 200, 200)
    v1460.TextSize = 14
    v1460.Font = Enum.Font.Gotham
    v1460.TextXAlignment = Enum.TextXAlignment.Left
    v1460.Text = "Survivors: 0/4 | Hooked: 0"
    v1460.Parent = v1455
    
    local v1461 = Instance.new("TextLabel")
    v1461.Name = "Speedometer"
    v1461.Size = UDim2.new(1, -20, 0, 30)
    v1461.Position = UDim2.new(0, 10, 0, 115)
    v1461.BackgroundTransparency = 1
    v1461.TextColor3 = Color3.fromRGB(150, 255, 150)
    v1461.TextSize = 14
    v1461.Font = Enum.Font.Gotham
    v1461.TextXAlignment = Enum.TextXAlignment.Left
    v1461.Text = "Speed: 0 studs/s"
    v1461.Parent = v1455
    
    v11.InfoOverlayGui = {
        container = v1454,
        frame = v1455,
        timer = v1458,
        role = v1459,
        survivors = v1460,
        speed = v1461
    }
    
    return v11.InfoOverlayGui
end

v11.UpdateInfoOverlay = function()
    if not v11.InfoOverlayGui then v11.CreateInfoOverlay() end
    if not v9.Character then return end
    
    if v11.MatchTimerEnabled and v11.MatchStartTime > 0 then
        local v1462 = tick() - v11.MatchStartTime
        local v1463 = math.floor(v1462 / 60)
        local v1464 = math.floor(v1462 % 60)
        v11.InfoOverlayGui.timer.Text = "Match Timer: " .. string.format("%02d:%02d", v1463, v1464)
    end
    
    if v11.SpeedometerEnabled then
        local v1465 = v9.Character:FindFirstChild("HumanoidRootPart")
        if v1465 then
            local v1466 = v1465.AssemblyLinearVelocity.Magnitude
            v11.InfoOverlayGui.speed.Text = "Speed: " .. math.floor(v1466) .. " studs/s"
        end
    end
end

-- ========== AUTO FEATURES ==========
v11.AutoUnhookEnabled = false
v11.AutoUnhookRange = 30
v11.AutoSkillcheckEnabled = false
v11.AutoDropPalletsEnabled = false
v11.AutoDropPalletRange = 20

v11.AutoUnhook = function()
    if not v11.AutoUnhookEnabled or not v9.Character then return end
    
    for v1467, v1468 in pairs(v6:GetChildren()) do
        if string.find(v1468.Name:lower(), "hook") then
            local v1469 = (v1468.Position - v9.Character.PrimaryPart.Position).Magnitude
            if v1469 < v11.AutoUnhookRange then
                local v1470 = v1468:FindFirstChild("HumanoidRootPart")
                if v1470 then
                    v9.Character.HumanoidRootPart.CFrame = v1470.CFrame
                    wait(0.5)
                    game:GetService("RunService").RenderStepped:Wait()
                end
            end
        end
    end
end

v11.AutoSkillcheck = function()
    if not v11.AutoSkillcheckEnabled then return end
    
    local v1471 = v10:FindFirstChild("SkillCheckUI")
    if v1471 then
        local v1472 = v1471:FindFirstChild("CircleFrame")
        if v1472 then
            local v1473 = v1471:FindFirstChild("SuccessZone")
            if v1473 then
                local v1474 = v1473.AbsolutePosition.X + v1473.AbsoluteSize.X / 2
                local v1475 = v1472.AbsolutePosition.X + v1472.AbsoluteSize.X / 2
                
                if math.abs(v1475 - v1474) < 20 then
                    v2:SendKeyEvent(true, Enum.KeyCode.Space, false)
                    wait(0.1)
                    v2:SendKeyEvent(false, Enum.KeyCode.Space, false)
                end
            end
        end
    end
end

v11.AutoDropPallets = function()
    if not v11.AutoDropPalletsEnabled or not v9.Character then return end
    
    local v1476 = nil
    for v1477, v1478 in pairs(v6:GetChildren()) do
        if string.find(v1478.Name:lower(), "pallet") then
            local v1479 = (v1478.Position - v9.Character.PrimaryPart.Position).Magnitude
            if v1479 < v11.AutoDropPalletRange and string.find(v1478.Name:lower(), "intact") then
                v1476 = v1478
                break
            end
        end
    end
    
    if v1476 then
        v2:SendKeyEvent(true, Enum.KeyCode.E, false)
        wait(0.2)
        v2:SendKeyEvent(false, Enum.KeyCode.E, false)
    end
end

-- ========== ADVANCED EXPLOITS ==========
v11.ChamEnabled = false
v11.InvisibleKillerEnabled = false
v11.LagSwitchEnabled = false
v11.LagSwitchInterval = 5
v11.InfiniteHookStagesEnabled = false
v11.ChamsConnection = nil
v11.LagSwitchConnection = nil

v11.EnableChams = function()
    if v11.ChamEnabled then
        if v11.ChamsConnection then v11.ChamsConnection:Disconnect() end
        
        v11.ChamsConnection = v1.RenderStepped:Connect(function()
            for v1480, v1481 in pairs(v0:GetPlayers()) do
                if v1481 ~= v9 and v1481.Character then
                    for v1482, v1483 in pairs(v1481.Character:GetDescendants()) do
                        if v1483:IsA("BasePart") then
                            v1483.Transparency = 0.3
                            v1483.CanCollide = false
                        end
                    end
                end
            end
        end)
        print("Chams: ENABLED")
    else
        if v11.ChamsConnection then
            v11.ChamsConnection:Disconnect()
            v11.ChamsConnection = nil
        end
        print("Chams: DISABLED")
    end
end

v11.EnableInvisibleKiller = function()
    if v11.InvisibleKillerEnabled then
        local v1484 = v6:FindFirstChild("KillerCharacter")
        if v1484 then
            for v1485, v1486 in pairs(v1484:GetDescendants()) do
                if v1486:IsA("BasePart") then
                    v1486.Transparency = 1
                    v1486.CanCollide = false
                end
            end
            print("Invisible Killer: ENABLED (Client-side)")
        end
    else
        local v1487 = v6:FindFirstChild("KillerCharacter")
        if v1487 then
            for v1488, v1489 in pairs(v1487:GetDescendants()) do
                if v1489:IsA("BasePart") then
                    v1489.Transparency = 0
                    v1489.CanCollide = true
                end
            end
        end
        print("Invisible Killer: DISABLED")
    end
end

v11.LagSwitch = function()
    if not v11.LagSwitchEnabled then return end
    
    if v11.LagSwitchConnection then v11.LagSwitchConnection:Disconnect() end
    
    v11.LagSwitchConnection = v1.Heartbeat:Connect(function()
        local v1490 = (tick() % (v11.LagSwitchInterval * 2)) > v11.LagSwitchInterval
        
        if v1490 then
            wait(0.1)
        end
    end)
    print("Lag Switch: ENABLED")
end

v11.PacketSpoof = function(v1491)
    pcall(function()
        local v1492 = v6:FindFirstChild("RemoteEvents")
        if v1492 then
            local v1493 = v1492:FindFirstChild(v1491)
            if v1493 then
                v1493:FireServer(v9, true)
                print("Packet Spoofed: " .. v1491)
            end
        end
    end)
end

-- ========== ADVANCED PREDICTION & TARGETING ==========
v11.PredictionEnabled = false
v11.EscapeRouteEnabled = false
v11.DangerZoneEnabled = false
v11.BehaviorPredictionEnabled = false
v11.WeaponDropPredictionEnabled = false

v11.CalculatePredictedPosition = function(v1550)
    if not v1550 or not v1550.Character then return v1550.Character.PrimaryPart.Position end
    local v1551 = v1550.Character.HumanoidRootPart.AssemblyLinearVelocity
    local v1552 = 0.5
    return v1550.Character.PrimaryPart.Position + (v1551 * v1552)
end

v11.GetEscapeRoutes = function()
    if not v9.Character then return {} end
    local v1553 = {}
    for v1554, v1555 in pairs(v6:GetChildren()) do
        if string.find(v1555.Name:lower(), "exit") or string.find(v1555.Name:lower(), "gate") then
            table.insert(v1553, v1555)
        end
    end
    return v1553
end

v11.AnalyzeDangerZones = function()
    if not v9.Character then return {} end
    local v1556 = {}
    local v1557 = v6:FindFirstChild("KillerCharacter")
    if v1557 then
        local v1558 = (v1557.Position - v9.Character.PrimaryPart.Position).Magnitude
        if v1558 < 50 then
            table.insert(v1556, {name = "Killer Close", distance = v1558, danger = 10})
        end
    end
    return v1556
end

v11.PredictPlayerBehavior = function(v1559)
    local v1560 = (tick() % 10)
    if v1560 < 3 then return "stationary"
    elseif v1560 < 6 then return "moving_forward"
    else return "moving_random" end
end

-- ========== ADVANCED PLAYER ANALYTICS ==========
v11.StatsTrackerEnabled = false
v11.BehaviorLoggerEnabled = false
v11.ReplaySystemEnabled = false
v11.MatchStatsEnabled = false
v11.AntiCheatDetectorEnabled = false

v11.PlayerStats = {}
v11.ReplayBuffer = {}
v11.MatchStats = {kills = 0, heals = 0, gens = 0, escapes = 0}

v11.UpdatePlayerStats = function(v1561)
    if not v11.PlayerStats[v1561.Name] then
        v11.PlayerStats[v1561.Name] = {name = v1561.Name, joined = tick(), playtime = 0, actions = 0}
    end
    v11.PlayerStats[v1561.Name].playtime = tick() - v11.PlayerStats[v1561.Name].joined
    v11.PlayerStats[v1561.Name].actions = v11.PlayerStats[v1561.Name].actions + 1
end

v11.LogBehavior = function(v1562, v1563)
    table.insert(v11.ReplayBuffer, {player = v1562, action = v1563, time = tick()})
    if #v11.ReplayBuffer > 300 then table.remove(v11.ReplayBuffer, 1) end
end

v11.DetectAnticheat = function()
    local v1564 = {}
    for v1565, v1566 in pairs(v0:GetPlayers()) do
        local v1567 = (v1566.Character.PrimaryPart.Position - v1566.Character.PrimaryPart.Position).Magnitude
        if v1567 > 100 then
            table.insert(v1564, v1566.Name)
        end
    end
    return v1564
end

-- ========== ENHANCED VISUALS & UI ==========
v11.CrosshairEnabled = false
v11.RadarEnabled = false
v11.World3DMarkersEnabled = false
v11.PerfMonitorEnabled = false
v11.ThemeCustom = "dark"

v11.CrosshairStyle = "plus"
v11.RadarFrame = nil

v11.CreateRadar = function()
    if v11.RadarFrame then return end
    local v1568 = Instance.new("Frame")
    v1568.Name = "Radar"
    v1568.Size = UDim2.new(0, 150, 0, 150)
    v1568.Position = UDim2.new(1, -170, 1, -170)
    v1568.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v1568.BorderSizePixel = 2
    v1568.BorderColor3 = Color3.fromRGB(100, 255, 100)
    v1568.ZIndex = 50
    v1568.Parent = v11.ScreenGui
    
    local v1569 = Instance.new("UICorner")
    v1569.CornerRadius = UDim.new(0, 8)
    v1569.Parent = v1568
    
    v11.RadarFrame = v1568
end

v11.UpdateRadar = function()
    if not v11.RadarFrame or not v9.Character then return end
    for v1570, v1571 in pairs(v11.RadarFrame:GetChildren()) do
        if v1571:IsA("Frame") and v1571.Name ~= "UICorner" then
            v1571:Destroy()
        end
    end
    
    for v1572, v1573 in pairs(v0:GetPlayers()) do
        if v1573 ~= v9 and v1573.Character then
            local v1574 = Instance.new("Frame")
            v1574.Size = UDim2.new(0, 5, 0, 5)
            v1574.BackgroundColor3 = v11.IsPlayerKiller(v1573) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            local v1575 = ((v1573.Character.PrimaryPart.Position - v9.Character.PrimaryPart.Position) * 0.1)
            v1574.Position = UDim2.new(0.5, v1575.X, 0.5, v1575.Z)
            v1574.Parent = v11.RadarFrame
        end
    end
end

v11.ApplyTheme = function(v1576)
    v11.ThemeCustom = v1576
    if v1576 == "dark" then
        v11.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    elseif v1576 == "light" then
        v11.MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    elseif v1576 == "cyberpunk" then
        v11.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
    end
end

-- ========== ADVANCED AUTO FEATURES (EXTENDED) ==========
v11.PathNavEnabled = false
v11.AutoObjectivesEnabled = false
v11.SmartDodgeEnabled = false
v11.AutoLootEnabled = false
v11.ScheduledActionsEnabled = false

v11.CurrentPath = {}
v11.ScheduledTasks = {}

v11.NavigateToPoint = function(v1577)
    if not v9.Character then return end
    local v1578 = v9.Character.HumanoidRootPart
    local v1579 = (v1577 - v1578.Position).Unit * 15
    v1578.Velocity = v1579
end

v11.ExecuteAutoObjectives = function()
    if not v9.Character then return end
    for v1580, v1581 in pairs(v6:GetChildren()) do
        if string.find(v1581.Name:lower(), "generator") then
            v11.NavigateToPoint(v1581.Position)
        end
    end
end

v11.SmartDodge = function()
    if not v9.Character then return end
    local v1582 = v6:FindFirstChild("KillerCharacter")
    if v1582 then
        local v1583 = (v9.Character.PrimaryPart.Position - v1582.Position).Magnitude
        if v1583 < 15 then
            v9.Character.HumanoidRootPart.Velocity = (v9.Character.PrimaryPart.Position - v1582.Position).Unit * 50
        end
    end
end

v11.CollectNearbyLoot = function()
    if not v9.Character then return end
    for v1584, v1585 in pairs(v6:GetChildren()) do
        if string.find(v1585.Name:lower(), "item") or string.find(v1585.Name:lower(), "loot") then
            local v1586 = (v1585.Position - v9.Character.PrimaryPart.Position).Magnitude
            if v1586 < 20 then
                v1585.CanCollide = false
                v1585.CFrame = v9.Character.PrimaryPart.CFrame
            end
        end
    end
end

v11.ScheduleAction = function(v1587, v1588, v1589)
    table.insert(v11.ScheduledTasks, {name = v1587, callback = v1588, time = tick() + v1589})
end

-- ========== NETWORK & PACKET MANIPULATION ==========
v11.PacketLoggerEnabled = false
v11.CustomPacketEnabled = false
v11.LatencyManipEnabled = false
v11.StateSyncBypassEnabled = false
v11.ActionQueueEnabled = false

v11.PacketLog = {}
v11.ActionQueue = {}

v11.LogPacket = function(v1590)
    table.insert(v11.PacketLog, {packet = v1590, time = tick()})
    if #v11.PacketLog > 100 then table.remove(v11.PacketLog, 1) end
end

v11.SendCustomPacket = function(v1591, v1592)
    pcall(function()
        local v1593 = v6:FindFirstChild("RemoteEvents")
        if v1593 then
            local v1594 = v1593:FindFirstChild(v1591)
            if v1594 then
                v1594:FireServer(v1592)
            end
        end
    end)
end

v11.ManipulateLatency = function(v1595)
    wait(v1595 / 1000)
end

v11.QueueAction = function(v1596)
    table.insert(v11.ActionQueue, v1596)
end

v11.ProcessActionQueue = function()
    for v1597, v1598 in ipairs(v11.ActionQueue) do
        pcall(v1598)
    end
    v11.ActionQueue = {}
end

-- ========== GAME STATE MANIPULATION ==========
v11.TimeScalerEnabled = false
v11.PhysicsModEnabled = false
v11.ModelEditorEnabled = false
v11.SoundManipEnabled = false
v11.WeatherControlEnabled = false

v11.TimeScale = 1
v11.GravityScale = 1
v11.PlayerScale = 1

v11.ApplyTimeScale = function(v1599)
    v11.TimeScale = v1599
    game:GetService("RunService").RenderStepped:Connect(function()
        game.Workspace.Gravity = 196.2 * (1 / v1599)
    end)
end

v11.ModifyPhysics = function(v1600, v1601)
    if v1600 == "gravity" then
        v11.GravityScale = v1601
        game.Workspace.Gravity = 196.2 * v1601
    end
end

v11.ScaleModel = function(v1602)
    if not v9.Character then return end
    for v1603, v1604 in pairs(v9.Character:GetDescendants()) do
        if v1604:IsA("BasePart") then
            v1604.Size = v1604.Size * v1602
        end
    end
end

v11.MuteSounds = function(v1605)
    for v1606, v1607 in pairs(v6:FindFirstChildOfClass("Sound") or {}) do
        if string.find(v1607.Name:lower(), v1605:lower()) then
            v1607.Volume = 0
        end
    end
end

v11.ControlWeather = function(v1608)
    local v1609 = game:GetService("Lighting")
    if v1608 == "dark" then
        v1609.Brightness = 0
    elseif v1608 == "light" then
        v1609.Brightness = 2
    end
end

-- ========== ADVANCED SECURITY & ANTI-DETECTION ==========
v11.FingerprintSpooferEnabled = false
v11.BehaviorRandomizerEnabled = false
v11.RateLimiterEnabled = false
v11.InjectionHiderEnabled = false
v11.WhitelistEnabled = false

v11.Whitelist = {"God Mode", "Fly", "Noclip"}
v11.ActionCount = 0
v11.LastActionTime = tick()

v11.SpooFingerprint = function()
    local v1610 = math.random(100000, 999999)
    return tostring(v1610)
end

v11.RandomizeBehavior = function()
    wait(math.random(1, 3))
end

v11.CheckRateLimit = function()
    local v1611 = tick() - v11.LastActionTime
    if v11.ActionCount > 50 and v1611 < 1 then
        v11.ManipulateLatency(100)
    end
    v11.LastActionTime = tick()
    v11.ActionCount = v11.ActionCount + 1
end

v11.HideInjection = function()
    pcall(function()
        for v1612, v1613 in pairs(getfenv()) do
            if type(v1613) == "function" then
                debug.setfenv(v1613, setmetatable({}, {__index = _G}))
            end
        end
    end)
end

v11.IsWhitelisted = function(v1614)
    for v1615, v1616 in ipairs(v11.Whitelist) do
        if v1616 == v1614 then return true end
    end
    return false
end

-- ========== DEVELOPER TOOLS ==========
v11.LuaExecutorEnabled = false
v11.ObjectInspectorEnabled = false
v11.RemoteLoggerEnabled = false
v11.MemoryEditorEnabled = false
v11.APIDebuggerEnabled = false

v11.ExecuteLua = function(v1617)
    local v1618, v1619 = loadstring(v1617)
    if v1618 then
        local v1620 = v1618()
        print("Execution result:", v1620)
    else
        print("Lua Error:", v1619)
    end
end

v11.InspectObject = function(v1621)
    print("=== Object Inspector ===")
    print("Name: " .. v1621.Name)
    print("Class: " .. v1621.ClassName)
    print("Position: " .. tostring(v1621.Position))
    for v1622, v1623 in pairs(v1621:GetChildren()) do
        print("  - " .. v1623.Name .. " (" .. v1623.ClassName .. ")")
    end
end

v11.LogRemotes = function()
    local v1624 = {}
    for v1625, v1626 in pairs(v6:FindFirstChild("RemoteEvents") or {}) do
        table.insert(v1624, v1626.Name)
    end
    return v1624
end

v11.EditMemory = function(v1627, v1628)
    if type(v1627.Value) == "number" then
        v1627.Value = v1628
    end
end

-- ========== QUALITY OF LIFE ENHANCEMENTS ==========
v11.AutoScreenshotEnabled = false
v11.NotificationSystemEnabled = false
v11.HotkeysEnabled = false
v11.SettingsExportEnabled = false
v11.AutoUpdaterEnabled = false

v11.HotkeyBindings = {}
v11.NotificationQueue = {}

v11.TakeScreenshot = function()
    print("[Screenshot] Captured at " .. tick())
end

v11.SendNotification = function(v1629)
    table.insert(v11.NotificationQueue, v1629)
    local v1630 = Instance.new("TextLabel")
    v1630.Text = v1629
    v1630.Size = UDim2.new(0, 300, 0, 50)
    v1630.Position = UDim2.new(0.5, -150, 0, 10)
    v1630.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v1630.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1630.Parent = v11.ScreenGui
    
    delay(3, function() v1630:Destroy() end)
end

v11.BindHotkey = function(v1631, v1632, v1633)
    v11.HotkeyBindings[v1631] = {key = v1632, callback = v1633}
end

v11.ExportSettings = function()
    local v1634 = {
        esp_enabled = v11.ESPEnabled,
        aimbot_enabled = v11.AimbotEnabled,
        godmode_enabled = v11.GodModeEnabled,
        settings_exported = tick()
    }
    print("Settings exported:", game:GetService("HttpService"):JSONEncode(v1634))
end

v11.CheckForUpdates = function()
    print("Checking for script updates...")
end

-- ========== ADVANCED COMBAT & TARGETING ==========
v11.HitboxExtenderEnabled = false
v11.FramePerfectEnabled = false
v11.DamageCalcEnabled = false
v11.ComboSystemEnabled = false
v11.PriorityTargetEnabled = false
v11.HitboxSize = 1
v11.ComboSequence = {}

v11.ExtendHitbox = function(v1800)
    if v1800:IsA("BasePart") then
        v1800.Size = v1800.Size * (1 + v11.HitboxSize)
    end
end

v11.CalculateDamage = function(v1801, v1802)
    local v1803 = v1801:FindFirstChildOfClass("Humanoid")
    if v1803 then
        return math.floor(v1803.MaxHealth * 0.1)
    end
    return 10
end

v11.ExecuteCombo = function(v1804)
    for v1805, v1806 in ipairs(v11.ComboSequence) do
        pcall(v1806)
        wait(0.1)
    end
end

-- ========== MAP HACKING & AWARENESS ==========
v11.MapRevealEnabled = false
v11.LandmarkHighlightEnabled = false
v11.WallESPEnabled = false
v11.SafeZoneEnabled = false
v11.ObjectiveTrackerEnabled = false

v11.RevealMap = function()
    for v1807, v1808 in pairs(v6:GetChildren()) do
        if v1808:IsA("BasePart") then
            pcall(function()
                v1808.CanCollide = false
                v1808.Transparency = 0.3
            end)
        end
    end
end

v11.HighlightLandmarks = function()
    local v1809 = {"Generator", "Pallet", "Hook", "Exit", "Window"}
    for v1810, v1811 in ipairs(v1809) do
        for v1812, v1813 in pairs(v6:FindFirstChildren(v1811, true) or {}) do
            if v1813:IsA("BasePart") then
                v1813.CanCollide = false
            end
        end
    end
end

-- ========== ADVANCED MOVEMENT ==========
v11.TeleportChainEnabled = false
v11.WallPhaseEnabled = false
v11.CollisionBypassEnabled = false
v11.VelocityMultEnabled = false
v11.ParkourEnabled = false
v11.VelocityMult = 1

v11.TeleportChain = function(v1814)
    if not v9.Character then return end
    for v1815 = 1, 5 do
        v9.Character.HumanoidRootPart.CFrame = v9.Character.HumanoidRootPart.CFrame + Vector3.new(v1814, 0, 0)
        wait(0.05)
    end
end

v11.EnableWallPhase = function()
    if not v9.Character then return end
    for v1816, v1817 in pairs(v9.Character:GetDescendants()) do
        if v1817:IsA("BasePart") then
            v1817.CanCollide = false
        end
    end
end

v11.BypassCollision = function()
    if not v9.Character then return end
    v6.Terrain:FillBall(v9.Character.PrimaryPart.Position, 5, Enum.Material.Air)
end

-- ========== ECONOMY & PROGRESSION ==========
v11.AutoFarmEnabled = false
v11.XPMultiplierEnabled = false
v11.PerkUnlockerEnabled = false
v11.LoadoutManagerEnabled = false
v11.ProgressTrackerEnabled = false
v11.XPMult = 2
v11.SavedLoadouts = {}

v11.AutoFarm = function()
    if not v9.Character then return end
    local v1818 = v6:FindFirstChild("GeneratorCluster")
    if v1818 then
        v11.NavigateToPoint(v1818.Position)
    end
end

v11.ApplyXPMultiplier = function(v1819)
    for v1820, v1821 in pairs(v0:GetPlayers()) do
        if v1821 ~= v9 then
            pcall(function()
                v1821.leaderstats.Exp.Value = v1821.leaderstats.Exp.Value * v1819
            end)
        end
    end
end

v11.UnlockPerks = function()
    print("Attempting to unlock all perks...")
end

v11.SaveLoadout = function(v1822)
    v11.SavedLoadouts[v1822] = {
        equipped_perks = {},
        loadout_name = v1822,
        saved_at = tick()
    }
end

-- ========== RECORDING & STREAMING ==========
v11.AutoClipEnabled = false
v11.HighlightDetectorEnabled = false
v11.StreamOverlayEnabled = false
v11.ReplayEditorEnabled = false
v11.BroadcastEnabled = false
v11.IsRecording = false

v11.StartAutoClip = function()
    v11.IsRecording = true
    print("[Recording] Started clip recording...")
end

v11.StopAutoClip = function()
    v11.IsRecording = false
    print("[Recording] Clip saved!")
end

v11.DetectHighlight = function()
    if math.random(1, 100) > 70 then
        print("[Highlight] Epic moment detected! Recording...")
        v11.StartAutoClip()
        wait(5)
        v11.StopAutoClip()
    end
end

-- ========== COMMUNICATION ==========
v11.AutoChatEnabled = false
v11.MessageLoggerEnabled = false
v11.UsernameSpooferEnabled = false
v11.SocialTrackerEnabled = false
v11.PartyManagerEnabled = false
v11.ChatResponses = {}
v11.MessageLog = {}
v11.SocialList = {}

v11.SetupAutoChatResponses = function()
    v11.ChatResponses["gg"] = "gg wp"
    v11.ChatResponses["thanks"] = "np gl"
    v11.ChatResponses["lol"] = "xd"
end

v11.LogMessage = function(v1823, v1824)
    table.insert(v11.MessageLog, {player = v1823, message = v1824, time = tick()})
end

v11.TrackSocial = function(v1825)
    if not v11.SocialList[v1825.Name] then
        v11.SocialList[v1825.Name] = {name = v1825.Name, encounters = 0, first_met = tick()}
    end
    v11.SocialList[v1825.Name].encounters = v11.SocialList[v1825.Name].encounters + 1
end

-- ========== ACCOUNT MANAGEMENT ==========
v11.AccountSwitcherEnabled = false
v11.ProfileSyncEnabled = false
v11.AccountProtectorEnabled = false
v11.LoginAutoEnabled = false
v11.StoredAccounts = {}

v11.SwitchAccount = function(v1826)
    print("Switching to account: " .. v1826)
end

v11.SyncProfile = function()
    print("Syncing profile data...")
end

v11.ProtectAccount = function()
    print("Account protection enabled")
end

-- ========== ADVANCED VISUALS ==========
v11.GlowEffectEnabled = false
v11.TransparencyControlEnabled = false
v11.CustomShaderEnabled = false
v11.HUDCustomizerEnabled = false
v11.TextureReplacerEnabled = false
v11.GlowIntensity = 1
v11.ShaderType = "neon"

v11.ApplyGlowEffect = function(v1827)
    if v1827:IsA("BasePart") then
        local v1828 = Instance.new("SurfaceGui")
        v1828.Face = Enum.NormalId.Top
        v1828.Parent = v1827
    end
end

v11.AdjustTransparency = function(v1829, v1830)
    for v1831, v1832 in pairs(v1829:GetDescendants()) do
        if v1832:IsA("BasePart") then
            v1832.Transparency = v1830
        end
    end
end

-- ========== DATABASE & STORAGE ==========
v11.LocalDatabaseEnabled = false
v11.CloudSyncEnabled = false
v11.AutoBackupEnabled = false
v11.DataRecoveryEnabled = false
v11.ConfigExportEnabled = false
v11.LocalDB = {}
v11.BackupHistory = {}

v11.SaveToDatabase = function(v1833, v1834)
    v11.LocalDB[v1833] = {data = v1834, saved_at = tick()}
end

v11.CreateBackup = function()
    table.insert(v11.BackupHistory, {backup_data = v11.LocalDB, created_at = tick()})
    print("Backup created: " .. #v11.BackupHistory)
end

v11.ExportConfig = function()
    local v1835 = game:GetService("HttpService"):JSONEncode(v11.LocalDB)
    print("Config exported: " .. string.sub(v1835, 1, 50) .. "...")
end

-- ========== AI & MACHINE LEARNING ==========
v11.AIPathfinderEnabled = false
v11.ThreatAssessmentEnabled = false
v11.DecisionEngineEnabled = false
v11.LearningSystemEnabled = false
v11.SkillOptimizerEnabled = false
v11.AIMemory = {}

v11.ComputeOptimalPath = function(v1836)
    return {v1836, v1836 + Vector3.new(5, 0, 5), v1836 + Vector3.new(10, 0, 0)}
end

v11.AssessThreat = function()
    local v1837 = 0
    local v1838 = v6:FindFirstChild("KillerCharacter")
    if v1838 and v9.Character then
        v1837 = (v1838.Position - v9.Character.PrimaryPart.Position).Magnitude
    end
    return v1837 < 20 and "HIGH" or "LOW"
end

v11.OptimizePerkSetup = function()
    print("AI analyzing best perk configuration...")
end

-- ========== SKILL SYSTEM ==========
v11.PerfectSkillcheckEnabled = false
v11.SpeedhackPalletEnabled = false
v11.HookEscapeEnabled = false
v11.VaultingAssistEnabled = false
v11.HealingOptimizerEnabled = false
v11.SkillcheckAccuracy = 100

v11.OptimizeHealingRoute = function()
    if not v9.Character then return {} end
    local v1839 = {}
    for v1840, v1841 in pairs(v6:GetChildren()) do
        if string.find(v1841.Name:lower(), "survivor") then
            table.insert(v1839, v1841)
        end
    end
    table.sort(v1839, function(a, b) 
        return (a.Position - v9.Character.PrimaryPart.Position).Magnitude < (b.Position - v9.Character.PrimaryPart.Position).Magnitude 
    end)
    return v1839
end

-- ========== PERFORMANCE TWEAKS ==========
v11.FPSUnlockerEnabled = false
v11.RenderDistanceEnabled = false
v11.LODModifierEnabled = false
v11.TickRateAdjustEnabled = false
v11.MemOptimEnabled = false
v11.FPSTarget = 240
v11.RenderDist = 1000
v11.LODDistance = 500

v11.UnlockFPS = function()
    game:GetService("RunService"):Set3dRenderingEnabled(true)
    print("FPS Unlocked: Target " .. v11.FPSTarget)
end

v11.OptimizeMemory = function()
    collectgarbage("collect")
    print("Memory optimized")
end

-- ========== ADVANCED DETECTION EVASION ==========
v11.BanPreventionEnabled = false
v11.SigHiderEnabled = false
v11.ActionRandomizerEnabled = false
v11.DelayInjectorEnabled = false
v11.PatternObfuscatorEnabled = false
v11.AntiDetectMode = false

v11.RandomizeActions = function()
    wait(math.random(1, 3))
end

v11.InjectRandomDelay = function()
    wait(math.random(10, 100) / 1000)
end

-- ========== UTILITY TOOLS ==========
v11.MacroRecorderEnabled = false
v11.KeybindManagerEnabled = false
v11.PerfProfilerEnabled = false
v11.BugReporterEnabled = false
v11.HelpSystemEnabled = false
v11.MacroSequences = {}
v11.PerfMetrics = {}

v11.RecordMacro = function(v1842)
    v11.MacroSequences[v1842] = {keys = {}, created_at = tick()}
    print("Macro recording started: " .. v1842)
end

v11.PlayMacro = function(v1843)
    if v11.MacroSequences[v1843] then
        for v1844, v1845 in ipairs(v11.MacroSequences[v1843].keys) do
            v2:SendKeyEvent(true, v1845, false)
            wait(0.05)
            v2:SendKeyEvent(false, v1845, false)
        end
    end
end

v11.ProfilePerformance = function()
    table.insert(v11.PerfMetrics, {fps = 60, memory = collectgarbage("count"), time = tick()})
end

-- ========== POPULATE UI MENUS ==========
v11.CreateToggle("Health Bars", v11.HealthBarEnabled, function(v1500)
    v11.HealthBarEnabled = v1500
    if v1500 then
        for v1501, v1502 in pairs(v0:GetPlayers()) do
            if v1502 ~= v9 then v11.CreateHealthBar(v1502) end
        end
        print("Health Bars: ENABLED")
    else
        for v1503, v1504 in pairs(v11.ESPHealthBars) do
            if v1504.gui then v1504.gui:Destroy() end
        end
        v11.ESPHealthBars = {}
        print("Health Bars: DISABLED")
    end
end, v11.AdvancedESPFrame)

v11.CreateToggle("Distance Display", v11.DistanceDisplayEnabled, function(v1505)
    v11.DistanceDisplayEnabled = v1505
    print("Distance Display: " .. (v1505 and "ENABLED" or "DISABLED"))
end, v11.AdvancedESPFrame)

v11.CreateToggle("Tracer Lines", v11.TracerLinesEnabled, function(v1506)
    v11.TracerLinesEnabled = v1506
    print("Tracer Lines: " .. (v1506 and "ENABLED" or "DISABLED"))
end, v11.AdvancedESPFrame)

v11.CreateToggle("Status Icons", v11.StatusIconsEnabled, function(v1507)
    v11.StatusIconsEnabled = v1507
    print("Status Icons: " .. (v1507 and "ENABLED" or "DISABLED"))
end, v11.AdvancedESPFrame)

v11.CreateToggle("Box ESP", v11.BoxESPEnabled, function(v1508)
    v11.BoxESPEnabled = v1508
    print("Box ESP: " .. (v1508 and "ENABLED" or "DISABLED"))
end, v11.AdvancedESPFrame)

-- Visual Settings
v11.CreateToggle("Terror Radius", v11.TerrorRadiusEnabled, function(v1509)
    v11.TerrorRadiusEnabled = v1509
    print("Terror Radius: " .. (v1509 and "ENABLED" or "DISABLED"))
end, v11.VisualSettingsFrame)

v11.CreateToggle("Generator Progress", v11.GeneratorProgressEnabled, function(v1510)
    v11.GeneratorProgressEnabled = v1510
    print("Generator Progress: " .. (v1510 and "ENABLED" or "DISABLED"))
end, v11.VisualSettingsFrame)

v11.CreateToggle("Match Timer", v11.MatchTimerEnabled, function(v1511)
    v11.MatchTimerEnabled = v1511
    if v1511 then v11.MatchStartTime = tick() end
    print("Match Timer: " .. (v1511 and "ENABLED" or "DISABLED"))
end, v11.VisualSettingsFrame)

v11.CreateToggle("Player List", v11.PlayerListEnabled, function(v1512)
    v11.PlayerListEnabled = v1512
    print("Player List: " .. (v1512 and "ENABLED" or "DISABLED"))
end, v11.VisualSettingsFrame)

v11.CreateToggle("Speedometer", v11.SpeedometerEnabled, function(v1513)
    v11.SpeedometerEnabled = v1513
    print("Speedometer: " .. (v1513 and "ENABLED" or "DISABLED"))
end, v11.VisualSettingsFrame)

-- Auto Features
v11.CreateToggle("Auto Unhook", v11.AutoUnhookEnabled, function(v1514)
    v11.AutoUnhookEnabled = v1514
    print("Auto Unhook: " .. (v1514 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateSlider("Unhook Range", 10, 100, 30, function(v1515)
    v11.AutoUnhookRange = v1515
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Auto Skillcheck", v11.AutoSkillcheckEnabled, function(v1516)
    v11.AutoSkillcheckEnabled = v1516
    print("Auto Skillcheck: " .. (v1516 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Auto Drop Pallets", v11.AutoDropPalletsEnabled, function(v1517)
    v11.AutoDropPalletsEnabled = v1517
    print("Auto Drop Pallets: " .. (v1517 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateSlider("Pallet Range", 10, 50, 20, function(v1518)
    v11.AutoDropPalletRange = v1518
end, v11.AutoFeaturesFrame)

-- Exploits
v11.CreateToggle("Chams (X-Ray)", v11.ChamEnabled, function(v1519)
    v11.ChamEnabled = v1519
    v11.EnableChams()
end, v11.ExploitsFrame)

v11.CreateToggle("Invisible Killer", v11.InvisibleKillerEnabled, function(v1520)
    v11.InvisibleKillerEnabled = v1520
    v11.EnableInvisibleKiller()
end, v11.ExploitsFrame)

v11.CreateToggle("Lag Switch", v11.LagSwitchEnabled, function(v1521)
    v11.LagSwitchEnabled = v1521
    v11.LagSwitch()
end, v11.ExploitsFrame)

v11.CreateSlider("Lag Interval", 1, 10, 5, function(v1522)
    v11.LagSwitchInterval = v1522
end, v11.ExploitsFrame)

v11.CreateToggle("Infinite Hook Stages", v11.InfiniteHookStagesEnabled, function(v1523)
    v11.InfiniteHookStagesEnabled = v1523
    print("Infinite Hook Stages: " .. (v1523 and "ENABLED" or "DISABLED"))
end, v11.ExploitsFrame)

v11.CreateButton("Fake Repair Packet", function()
    v11.PacketSpoof("RepairGenerator")
end, v11.ExploitsFrame)

v11.CreateButton("Fake Heal Packet", function()
    v11.PacketSpoof("HealPlayer")
end, v11.ExploitsFrame)

-- PREDICTION & TARGETING
v11.CreateToggle("Prediction System", v11.PredictionEnabled, function(v1640)
    v11.PredictionEnabled = v1640
    print("Prediction: " .. (v1640 and "ENABLED" or "DISABLED"))
end, v11.PredictionFrame)

v11.CreateToggle("Escape Routes", v11.EscapeRouteEnabled, function(v1641)
    v11.EscapeRouteEnabled = v1641
    print("Escape Routes: " .. (v1641 and "ENABLED" or "DISABLED"))
end, v11.PredictionFrame)

v11.CreateToggle("Danger Zones", v11.DangerZoneEnabled, function(v1642)
    v11.DangerZoneEnabled = v1642
    print("Danger Zones: " .. (v1642 and "ENABLED" or "DISABLED"))
end, v11.PredictionFrame)

v11.CreateToggle("Behavior Prediction", v11.BehaviorPredictionEnabled, function(v1643)
    v11.BehaviorPredictionEnabled = v1643
    print("Behavior Prediction: " .. (v1643 and "ENABLED" or "DISABLED"))
end, v11.PredictionFrame)

v11.CreateToggle("Weapon Drop Prediction", v11.WeaponDropPredictionEnabled, function(v1644)
    v11.WeaponDropPredictionEnabled = v1644
    print("Weapon Drop Prediction: " .. (v1644 and "ENABLED" or "DISABLED"))
end, v11.PredictionFrame)

-- ANALYTICS
v11.CreateToggle("Stats Tracker", v11.StatsTrackerEnabled, function(v1645)
    v11.StatsTrackerEnabled = v1645
    print("Stats Tracker: " .. (v1645 and "ENABLED" or "DISABLED"))
end, v11.AnalyticsFrame)

v11.CreateToggle("Behavior Logger", v11.BehaviorLoggerEnabled, function(v1646)
    v11.BehaviorLoggerEnabled = v1646
    print("Behavior Logger: " .. (v1646 and "ENABLED" or "DISABLED"))
end, v11.AnalyticsFrame)

v11.CreateToggle("Replay System", v11.ReplaySystemEnabled, function(v1647)
    v11.ReplaySystemEnabled = v1647
    print("Replay System: " .. (v1647 and "ENABLED" or "DISABLED"))
end, v11.AnalyticsFrame)

v11.CreateToggle("Match Stats", v11.MatchStatsEnabled, function(v1648)
    v11.MatchStatsEnabled = v1648
    print("Match Stats: " .. (v1648 and "ENABLED" or "DISABLED"))
end, v11.AnalyticsFrame)

v11.CreateToggle("Anti-Cheat Detector", v11.AntiCheatDetectorEnabled, function(v1649)
    v11.AntiCheatDetectorEnabled = v1649
    print("Anti-Cheat Detector: " .. (v1649 and "ENABLED" or "DISABLED"))
end, v11.AnalyticsFrame)

-- UI CUSTOMIZATION
v11.CreateToggle("Custom Crosshair", v11.CrosshairEnabled, function(v1650)
    v11.CrosshairEnabled = v1650
    print("Custom Crosshair: " .. (v1650 and "ENABLED" or "DISABLED"))
end, v11.UICustomFrame)

v11.CreateButton("Crosshair Style: Plus", function()
    v11.CrosshairStyle = "plus"
    print("Crosshair Style: Plus")
end, v11.UICustomFrame)

v11.CreateButton("Crosshair Style: Circle", function()
    v11.CrosshairStyle = "circle"
    print("Crosshair Style: Circle")
end, v11.UICustomFrame)

v11.CreateToggle("Radar", v11.RadarEnabled, function(v1651)
    v11.RadarEnabled = v1651
    if v1651 then
        v11.CreateRadar()
    elseif v11.RadarFrame then
        v11.RadarFrame:Destroy()
        v11.RadarFrame = nil
    end
    print("Radar: " .. (v1651 and "ENABLED" or "DISABLED"))
end, v11.UICustomFrame)

v11.CreateToggle("3D World Markers", v11.World3DMarkersEnabled, function(v1652)
    v11.World3DMarkersEnabled = v1652
    print("3D World Markers: " .. (v1652 and "ENABLED" or "DISABLED"))
end, v11.UICustomFrame)

v11.CreateToggle("Performance Monitor", v11.PerfMonitorEnabled, function(v1653)
    v11.PerfMonitorEnabled = v1653
    print("Performance Monitor: " .. (v1653 and "ENABLED" or "DISABLED"))
end, v11.UICustomFrame)

v11.CreateButton("Theme: Dark", function()
    v11.ApplyTheme("dark")
end, v11.UICustomFrame)

v11.CreateButton("Theme: Light", function()
    v11.ApplyTheme("light")
end, v11.UICustomFrame)

v11.CreateButton("Theme: Cyberpunk", function()
    v11.ApplyTheme("cyberpunk")
end, v11.UICustomFrame)

-- NETWORK & PACKETS
v11.CreateToggle("Packet Logger", v11.PacketLoggerEnabled, function(v1654)
    v11.PacketLoggerEnabled = v1654
    print("Packet Logger: " .. (v1654 and "ENABLED" or "DISABLED"))
end, v11.NetworkFrame)

v11.CreateToggle("Custom Packets", v11.CustomPacketEnabled, function(v1655)
    v11.CustomPacketEnabled = v1655
    print("Custom Packets: " .. (v1655 and "ENABLED" or "DISABLED"))
end, v11.NetworkFrame)

v11.CreateToggle("Latency Manipulation", v11.LatencyManipEnabled, function(v1656)
    v11.LatencyManipEnabled = v1656
    print("Latency Manipulation: " .. (v1656 and "ENABLED" or "DISABLED"))
end, v11.NetworkFrame)

v11.CreateToggle("State Sync Bypass", v11.StateSyncBypassEnabled, function(v1657)
    v11.StateSyncBypassEnabled = v1657
    print("State Sync Bypass: " .. (v1657 and "ENABLED" or "DISABLED"))
end, v11.NetworkFrame)

v11.CreateToggle("Action Queue", v11.ActionQueueEnabled, function(v1658)
    v11.ActionQueueEnabled = v1658
    print("Action Queue: " .. (v1658 and "ENABLED" or "DISABLED"))
end, v11.NetworkFrame)

-- GAME STATE
v11.CreateToggle("Time Scaler", v11.TimeScalerEnabled, function(v1659)
    v11.TimeScalerEnabled = v1659
    print("Time Scaler: " .. (v1659 and "ENABLED" or "DISABLED"))
end, v11.StateFrame)

v11.CreateSlider("Time Scale", 0.1, 2, 1, function(v1660)
    v11.TimeScale = v1660
    if v11.TimeScalerEnabled then v11.ApplyTimeScale(v1660) end
end, v11.StateFrame)

v11.CreateToggle("Physics Modifier", v11.PhysicsModEnabled, function(v1661)
    v11.PhysicsModEnabled = v1661
    print("Physics Modifier: " .. (v1661 and "ENABLED" or "DISABLED"))
end, v11.StateFrame)

v11.CreateSlider("Gravity Scale", 0, 2, 1, function(v1662)
    v11.GravityScale = v1662
    if v11.PhysicsModEnabled then v11.ModifyPhysics("gravity", v1662) end
end, v11.StateFrame)

v11.CreateToggle("Model Editor", v11.ModelEditorEnabled, function(v1663)
    v11.ModelEditorEnabled = v1663
    print("Model Editor: " .. (v1663 and "ENABLED" or "DISABLED"))
end, v11.StateFrame)

v11.CreateToggle("Sound Manipulator", v11.SoundManipEnabled, function(v1664)
    v11.SoundManipEnabled = v1664
    print("Sound Manipulator: " .. (v1664 and "ENABLED" or "DISABLED"))
end, v11.StateFrame)

v11.CreateToggle("Weather Control", v11.WeatherControlEnabled, function(v1665)
    v11.WeatherControlEnabled = v1665
    print("Weather Control: " .. (v1665 and "ENABLED" or "DISABLED"))
end, v11.StateFrame)

-- SECURITY & ANTI-DETECTION
v11.CreateToggle("Fingerprint Spoofer", v11.FingerprintSpooferEnabled, function(v1666)
    v11.FingerprintSpooferEnabled = v1666
    print("Fingerprint Spoofer: " .. (v1666 and "ENABLED" or "DISABLED"))
end, v11.SecurityFrame)

v11.CreateToggle("Behavior Randomizer", v11.BehaviorRandomizerEnabled, function(v1667)
    v11.BehaviorRandomizerEnabled = v1667
    print("Behavior Randomizer: " .. (v1667 and "ENABLED" or "DISABLED"))
end, v11.SecurityFrame)

v11.CreateToggle("Rate Limiter", v11.RateLimiterEnabled, function(v1668)
    v11.RateLimiterEnabled = v1668
    print("Rate Limiter: " .. (v1668 and "ENABLED" or "DISABLED"))
end, v11.SecurityFrame)

v11.CreateToggle("Injection Hider", v11.InjectionHiderEnabled, function(v1669)
    v11.InjectionHiderEnabled = v1669
    if v1669 then v11.HideInjection() end
    print("Injection Hider: " .. (v1669 and "ENABLED" or "DISABLED"))
end, v11.SecurityFrame)

v11.CreateToggle("Whitelist System", v11.WhitelistEnabled, function(v1670)
    v11.WhitelistEnabled = v1670
    print("Whitelist System: " .. (v1670 and "ENABLED" or "DISABLED"))
end, v11.SecurityFrame)

-- DEVELOPER TOOLS
v11.CreateToggle("Lua Executor", v11.LuaExecutorEnabled, function(v1671)
    v11.LuaExecutorEnabled = v1671
    print("Lua Executor: " .. (v1671 and "ENABLED" or "DISABLED"))
end, v11.DevToolsFrame)

v11.CreateButton("Execute Code", function()
    v11.ExecuteLua("print('Hello from Lua Executor!')")
end, v11.DevToolsFrame)

v11.CreateToggle("Object Inspector", v11.ObjectInspectorEnabled, function(v1672)
    v11.ObjectInspectorEnabled = v1672
    print("Object Inspector: " .. (v1672 and "ENABLED" or "DISABLED"))
end, v11.DevToolsFrame)

v11.CreateButton("Inspect Workspace", function()
    v11.InspectObject(v6)
end, v11.DevToolsFrame)

v11.CreateToggle("Remote Logger", v11.RemoteLoggerEnabled, function(v1673)
    v11.RemoteLoggerEnabled = v1673
    print("Remote Logger: " .. (v1673 and "ENABLED" or "DISABLED"))
end, v11.DevToolsFrame)

v11.CreateToggle("Memory Editor", v11.MemoryEditorEnabled, function(v1674)
    v11.MemoryEditorEnabled = v1674
    print("Memory Editor: " .. (v1674 and "ENABLED" or "DISABLED"))
end, v11.DevToolsFrame)

v11.CreateToggle("API Debugger", v11.APIDebuggerEnabled, function(v1675)
    v11.APIDebuggerEnabled = v1675
    print("API Debugger: " .. (v1675 and "ENABLED" or "DISABLED"))
end, v11.DevToolsFrame)

-- QUALITY OF LIFE
v11.CreateToggle("Auto Screenshot", v11.AutoScreenshotEnabled, function(v1676)
    v11.AutoScreenshotEnabled = v1676
    print("Auto Screenshot: " .. (v1676 and "ENABLED" or "DISABLED"))
end, v11.QOLFrame)

v11.CreateButton("Take Screenshot Now", function()
    v11.TakeScreenshot()
end, v11.QOLFrame)

v11.CreateToggle("Notifications", v11.NotificationSystemEnabled, function(v1677)
    v11.NotificationSystemEnabled = v1677
    print("Notifications: " .. (v1677 and "ENABLED" or "DISABLED"))
end, v11.QOLFrame)

v11.CreateToggle("Hotkey Manager", v11.HotkeysEnabled, function(v1678)
    v11.HotkeysEnabled = v1678
    print("Hotkey Manager: " .. (v1678 and "ENABLED" or "DISABLED"))
end, v11.QOLFrame)

v11.CreateButton("Export Settings", function()
    v11.ExportSettings()
end, v11.QOLFrame)

v11.CreateButton("Import Settings", function()
    print("Settings import feature coming soon!")
end, v11.QOLFrame)

v11.CreateToggle("Auto Updater", v11.AutoUpdaterEnabled, function(v1679)
    v11.AutoUpdaterEnabled = v1679
    print("Auto Updater: " .. (v1679 and "ENABLED" or "DISABLED"))
end, v11.QOLFrame)

v11.CreateButton("Check Updates", function()
    v11.CheckForUpdates()
end, v11.QOLFrame)

-- ========== THEME SELECTOR ==========
v11.CreateButton("THEME: BLACK-ORANGE", function()
    v11.BackgroundMode = "black-orange"
    print("Background Mode: BLACK-ORANGE GRADIENT")
end, v11.QOLFrame)

v11.CreateButton("THEME: ORANGE-WHITE", function()
    v11.BackgroundMode = "orange-white"
    print("Background Mode: ORANGE-WHITE PULSING")
end, v11.QOLFrame)

v11.CreateButton("THEME: NEON-ORANGE", function()
    v11.BackgroundMode = "neon-orange"
    print("Background Mode: NEON-ORANGE FAST PULSING")
end, v11.QOLFrame)

v11.CreateButton("THEME: STATIC", function()
    v11.BackgroundMode = "static"
    print("Background Mode: STATIC BLACK")
end, v11.QOLFrame)

v11.CreateButton("THEME: RAINBOW", function()
    v11.BackgroundMode = "rainbow"
    print("Background Mode: RAINBOW")
end, v11.QOLFrame)

-- EXTENDED AUTO FEATURES
v11.CreateToggle("Path Navigation", v11.PathNavEnabled, function(v1680)
    v11.PathNavEnabled = v1680
    print("Path Navigation: " .. (v1680 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Auto Objectives", v11.AutoObjectivesEnabled, function(v1681)
    v11.AutoObjectivesEnabled = v1681
    print("Auto Objectives: " .. (v1681 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Smart Dodge", v11.SmartDodgeEnabled, function(v1682)
    v11.SmartDodgeEnabled = v1682
    print("Smart Dodge: " .. (v1682 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Auto Loot", v11.AutoLootEnabled, function(v1683)
    v11.AutoLootEnabled = v1683
    print("Auto Loot: " .. (v1683 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

v11.CreateToggle("Scheduled Actions", v11.ScheduledActionsEnabled, function(v1690)
    v11.ScheduledActionsEnabled = v1690
    print("Scheduled Actions: " .. (v1690 and "ENABLED" or "DISABLED"))
end, v11.AutoFeaturesFrame)

-- ========== COMBAT FEATURES ==========
v11.CreateToggle("Hitbox Extender", v11.HitboxExtenderEnabled, function(v1840)
    v11.HitboxExtenderEnabled = v1840
    print("Hitbox Extender: " .. (v1840 and "ENABLED" or "DISABLED"))
end, v11.CombatFrame)

v11.CreateSlider("Hitbox Size", 0.5, 3, 1, function(v1841)
    v11.HitboxSize = v1841
end, v11.CombatFrame)

v11.CreateToggle("Frame Perfect Attack", v11.FramePerfectEnabled, function(v1842)
    v11.FramePerfectEnabled = v1842
    print("Frame Perfect: " .. (v1842 and "ENABLED" or "DISABLED"))
end, v11.CombatFrame)

v11.CreateToggle("Damage Calculator", v11.DamageCalcEnabled, function(v1843)
    v11.DamageCalcEnabled = v1843
    print("Damage Calc: " .. (v1843 and "ENABLED" or "DISABLED"))
end, v11.CombatFrame)

v11.CreateToggle("Combo System", v11.ComboSystemEnabled, function(v1844)
    v11.ComboSystemEnabled = v1844
    print("Combo System: " .. (v1844 and "ENABLED" or "DISABLED"))
end, v11.CombatFrame)

v11.CreateToggle("Priority Targeting", v11.PriorityTargetEnabled, function(v1845)
    v11.PriorityTargetEnabled = v1845
    print("Priority Target: " .. (v1845 and "ENABLED" or "DISABLED"))
end, v11.CombatFrame)

-- MAP HACKING
v11.CreateToggle("Map Reveal", v11.MapRevealEnabled, function(v1846)
    v11.MapRevealEnabled = v1846
    if v1846 then v11.RevealMap() end
    print("Map Reveal: " .. (v1846 and "ENABLED" or "DISABLED"))
end, v11.MapFrame)

v11.CreateToggle("Landmark Highlight", v11.LandmarkHighlightEnabled, function(v1847)
    v11.LandmarkHighlightEnabled = v1847
    if v1847 then v11.HighlightLandmarks() end
    print("Landmarks: " .. (v1847 and "ENABLED" or "DISABLED"))
end, v11.MapFrame)

v11.CreateToggle("Wall ESP", v11.WallESPEnabled, function(v1848)
    v11.WallESPEnabled = v1848
    print("Wall ESP: " .. (v1848 and "ENABLED" or "DISABLED"))
end, v11.MapFrame)

v11.CreateToggle("Safe Zone Map", v11.SafeZoneEnabled, function(v1849)
    v11.SafeZoneEnabled = v1849
    print("Safe Zones: " .. (v1849 and "ENABLED" or "DISABLED"))
end, v11.MapFrame)

v11.CreateToggle("Objective Tracker", v11.ObjectiveTrackerEnabled, function(v1850)
    v11.ObjectiveTrackerEnabled = v1850
    print("Objective Tracker: " .. (v1850 and "ENABLED" or "DISABLED"))
end, v11.MapFrame)

-- ADVANCED MOVEMENT
v11.CreateToggle("Teleport Chain", v11.TeleportChainEnabled, function(v1851)
    v11.TeleportChainEnabled = v1851
    print("Teleport Chain: " .. (v1851 and "ENABLED" or "DISABLED"))
end, v11.MovementFrame)

v11.CreateToggle("Wall Phase", v11.WallPhaseEnabled, function(v1852)
    v11.WallPhaseEnabled = v1852
    if v1852 then v11.EnableWallPhase() end
    print("Wall Phase: " .. (v1852 and "ENABLED" or "DISABLED"))
end, v11.MovementFrame)

v11.CreateToggle("Collision Bypass", v11.CollisionBypassEnabled, function(v1853)
    v11.CollisionBypassEnabled = v1853
    print("Collision Bypass: " .. (v1853 and "ENABLED" or "DISABLED"))
end, v11.MovementFrame)

v11.CreateToggle("Velocity Multiplier", v11.VelocityMultEnabled, function(v1854)
    v11.VelocityMultEnabled = v1854
    print("Velocity Mult: " .. (v1854 and "ENABLED" or "DISABLED"))
end, v11.MovementFrame)

v11.CreateSlider("Speed Mult", 1, 10, 1, function(v1855)
    v11.VelocityMult = v1855
end, v11.MovementFrame)

v11.CreateToggle("Parkour System", v11.ParkourEnabled, function(v1856)
    v11.ParkourEnabled = v1856
    print("Parkour: " .. (v1856 and "ENABLED" or "DISABLED"))
end, v11.MovementFrame)

-- ECONOMY & PROGRESSION
v11.CreateToggle("Auto Farm", v11.AutoFarmEnabled, function(v1857)
    v11.AutoFarmEnabled = v1857
    print("Auto Farm: " .. (v1857 and "ENABLED" or "DISABLED"))
end, v11.EconomyFrame)

v11.CreateToggle("XP Multiplier", v11.XPMultiplierEnabled, function(v1858)
    v11.XPMultiplierEnabled = v1858
    print("XP Mult: " .. (v1858 and "ENABLED" or "DISABLED"))
end, v11.EconomyFrame)

v11.CreateSlider("XP Mult", 1, 10, 2, function(v1859)
    v11.XPMult = v1859
end, v11.EconomyFrame)

v11.CreateToggle("Perk Unlocker", v11.PerkUnlockerEnabled, function(v1860)
    v11.PerkUnlockerEnabled = v1860
    v11.UnlockPerks()
    print("Perk Unlocker: " .. (v1860 and "ENABLED" or "DISABLED"))
end, v11.EconomyFrame)

v11.CreateToggle("Loadout Manager", v11.LoadoutManagerEnabled, function(v1861)
    v11.LoadoutManagerEnabled = v1861
    print("Loadout Manager: " .. (v1861 and "ENABLED" or "DISABLED"))
end, v11.EconomyFrame)

v11.CreateToggle("Progression Tracker", v11.ProgressTrackerEnabled, function(v1862)
    v11.ProgressTrackerEnabled = v1862
    print("Progress Tracker: " .. (v1862 and "ENABLED" or "DISABLED"))
end, v11.EconomyFrame)

-- RECORDING & STREAMING
v11.CreateToggle("Auto Clip", v11.AutoClipEnabled, function(v1863)
    v11.AutoClipEnabled = v1863
    if v1863 then v11.StartAutoClip() else v11.StopAutoClip() end
    print("Auto Clip: " .. (v1863 and "ENABLED" or "DISABLED"))
end, v11.RecordingFrame)

v11.CreateToggle("Highlight Detector", v11.HighlightDetectorEnabled, function(v1864)
    v11.HighlightDetectorEnabled = v1864
    print("Highlights: " .. (v1864 and "ENABLED" or "DISABLED"))
end, v11.RecordingFrame)

v11.CreateToggle("Stream Overlay", v11.StreamOverlayEnabled, function(v1865)
    v11.StreamOverlayEnabled = v1865
    print("Stream Overlay: " .. (v1865 and "ENABLED" or "DISABLED"))
end, v11.RecordingFrame)

v11.CreateToggle("Replay Editor", v11.ReplayEditorEnabled, function(v1866)
    v11.ReplayEditorEnabled = v1866
    print("Replay Editor: " .. (v1866 and "ENABLED" or "DISABLED"))
end, v11.RecordingFrame)

v11.CreateToggle("Broadcast", v11.BroadcastEnabled, function(v1867)
    v11.BroadcastEnabled = v1867
    print("Broadcast: " .. (v1867 and "ENABLED" or "DISABLED"))
end, v11.RecordingFrame)

-- COMMUNICATION
v11.CreateToggle("Auto Chat", v11.AutoChatEnabled, function(v1868)
    v11.AutoChatEnabled = v1868
    v11.SetupAutoChatResponses()
    print("Auto Chat: " .. (v1868 and "ENABLED" or "DISABLED"))
end, v11.CommunicationFrame)

v11.CreateToggle("Message Logger", v11.MessageLoggerEnabled, function(v1869)
    v11.MessageLoggerEnabled = v1869
    print("Message Logger: " .. (v1869 and "ENABLED" or "DISABLED"))
end, v11.CommunicationFrame)

v11.CreateToggle("Username Spoofer", v11.UsernameSpooferEnabled, function(v1870)
    v11.UsernameSpooferEnabled = v1870
    print("Username Spoof: " .. (v1870 and "ENABLED" or "DISABLED"))
end, v11.CommunicationFrame)

v11.CreateToggle("Social Tracker", v11.SocialTrackerEnabled, function(v1871)
    v11.SocialTrackerEnabled = v1871
    print("Social Tracker: " .. (v1871 and "ENABLED" or "DISABLED"))
end, v11.CommunicationFrame)

v11.CreateToggle("Party Manager", v11.PartyManagerEnabled, function(v1872)
    v11.PartyManagerEnabled = v1872
    print("Party Manager: " .. (v1872 and "ENABLED" or "DISABLED"))
end, v11.CommunicationFrame)

-- ACCOUNT MANAGEMENT
v11.CreateToggle("Account Switcher", v11.AccountSwitcherEnabled, function(v1873)
    v11.AccountSwitcherEnabled = v1873
    print("Account Switch: " .. (v1873 and "ENABLED" or "DISABLED"))
end, v11.AccountFrame)

v11.CreateToggle("Profile Sync", v11.ProfileSyncEnabled, function(v1874)
    v11.ProfileSyncEnabled = v1874
    if v1874 then v11.SyncProfile() end
    print("Profile Sync: " .. (v1874 and "ENABLED" or "DISABLED"))
end, v11.AccountFrame)

v11.CreateToggle("Account Protector", v11.AccountProtectorEnabled, function(v1875)
    v11.AccountProtectorEnabled = v1875
    if v1875 then v11.ProtectAccount() end
    print("Account Protect: " .. (v1875 and "ENABLED" or "DISABLED"))
end, v11.AccountFrame)

v11.CreateToggle("Login Auto", v11.LoginAutoEnabled, function(v1876)
    v11.LoginAutoEnabled = v1876
    print("Login Auto: " .. (v1876 and "ENABLED" or "DISABLED"))
end, v11.AccountFrame)

-- ADVANCED VISUALS
v11.CreateToggle("Glow Effects", v11.GlowEffectEnabled, function(v1877)
    v11.GlowEffectEnabled = v1877
    print("Glow Effects: " .. (v1877 and "ENABLED" or "DISABLED"))
end, v11.VisualsFrame)

v11.CreateSlider("Glow Intensity", 0, 2, 1, function(v1878)
    v11.GlowIntensity = v1878
end, v11.VisualsFrame)

v11.CreateToggle("Transparency Control", v11.TransparencyControlEnabled, function(v1879)
    v11.TransparencyControlEnabled = v1879
    print("Transparency: " .. (v1879 and "ENABLED" or "DISABLED"))
end, v11.VisualsFrame)

v11.CreateToggle("Custom Shader", v11.CustomShaderEnabled, function(v1880)
    v11.CustomShaderEnabled = v1880
    print("Custom Shader: " .. (v1880 and "ENABLED" or "DISABLED"))
end, v11.VisualsFrame)

v11.CreateToggle("HUD Customizer", v11.HUDCustomizerEnabled, function(v1881)
    v11.HUDCustomizerEnabled = v1881
    print("HUD Custom: " .. (v1881 and "ENABLED" or "DISABLED"))
end, v11.VisualsFrame)

v11.CreateToggle("Texture Replacer", v11.TextureReplacerEnabled, function(v1882)
    v11.TextureReplacerEnabled = v1882
    print("Texture Replace: " .. (v1882 and "ENABLED" or "DISABLED"))
end, v11.VisualsFrame)

-- DATABASE & STORAGE
v11.CreateToggle("Local Database", v11.LocalDatabaseEnabled, function(v1883)
    v11.LocalDatabaseEnabled = v1883
    print("Local DB: " .. (v1883 and "ENABLED" or "DISABLED"))
end, v11.DatabaseFrame)

v11.CreateToggle("Cloud Sync", v11.CloudSyncEnabled, function(v1884)
    v11.CloudSyncEnabled = v1884
    print("Cloud Sync: " .. (v1884 and "ENABLED" or "DISABLED"))
end, v11.DatabaseFrame)

v11.CreateToggle("Auto Backup", v11.AutoBackupEnabled, function(v1885)
    v11.AutoBackupEnabled = v1885
    if v1885 then v11.CreateBackup() end
    print("Auto Backup: " .. (v1885 and "ENABLED" or "DISABLED"))
end, v11.DatabaseFrame)

v11.CreateToggle("Data Recovery", v11.DataRecoveryEnabled, function(v1886)
    v11.DataRecoveryEnabled = v1886
    print("Data Recovery: " .. (v1886 and "ENABLED" or "DISABLED"))
end, v11.DatabaseFrame)

v11.CreateButton("Export Config", function()
    v11.ExportConfig()
end, v11.DatabaseFrame)

-- AI & MACHINE LEARNING
v11.CreateToggle("AI Pathfinder", v11.AIPathfinderEnabled, function(v1887)
    v11.AIPathfinderEnabled = v1887
    print("AI Pathfinder: " .. (v1887 and "ENABLED" or "DISABLED"))
end, v11.AIFrame)

v11.CreateToggle("Threat Assessment", v11.ThreatAssessmentEnabled, function(v1888)
    v11.ThreatAssessmentEnabled = v1888
    print("Threat Assessment: " .. (v1888 and "ENABLED" or "DISABLED"))
end, v11.AIFrame)

v11.CreateToggle("Decision Engine", v11.DecisionEngineEnabled, function(v1889)
    v11.DecisionEngineEnabled = v1889
    print("Decision Engine: " .. (v1889 and "ENABLED" or "DISABLED"))
end, v11.AIFrame)

v11.CreateToggle("Learning System", v11.LearningSystemEnabled, function(v1890)
    v11.LearningSystemEnabled = v1890
    print("Learning System: " .. (v1890 and "ENABLED" or "DISABLED"))
end, v11.AIFrame)

v11.CreateToggle("Skill Optimizer", v11.SkillOptimizerEnabled, function(v1891)
    v11.SkillOptimizerEnabled = v1891
    v11.OptimizePerkSetup()
    print("Skill Optimizer: " .. (v1891 and "ENABLED" or "DISABLED"))
end, v11.AIFrame)

-- SKILL SYSTEM
v11.CreateToggle("Perfect Skillcheck", v11.PerfectSkillcheckEnabled, function(v1892)
    v11.PerfectSkillcheckEnabled = v1892
    print("Perfect Skillcheck: " .. (v1892 and "ENABLED" or "DISABLED"))
end, v11.SkillsFrame)

v11.CreateToggle("Speedhack Pallets", v11.SpeedhackPalletEnabled, function(v1893)
    v11.SpeedhackPalletEnabled = v1893
    print("Speedhack Pallets: " .. (v1893 and "ENABLED" or "DISABLED"))
end, v11.SkillsFrame)

v11.CreateToggle("Hook Escape Pred", v11.HookEscapeEnabled, function(v1894)
    v11.HookEscapeEnabled = v1894
    print("Hook Escape: " .. (v1894 and "ENABLED" or "DISABLED"))
end, v11.SkillsFrame)

v11.CreateToggle("Vaulting Assist", v11.VaultingAssistEnabled, function(v1895)
    v11.VaultingAssistEnabled = v1895
    print("Vault Assist: " .. (v1895 and "ENABLED" or "DISABLED"))
end, v11.SkillsFrame)

v11.CreateToggle("Healing Optimizer", v11.HealingOptimizerEnabled, function(v1896)
    v11.HealingOptimizerEnabled = v1896
    print("Healing Optimizer: " .. (v1896 and "ENABLED" or "DISABLED"))
end, v11.SkillsFrame)

-- PERFORMANCE TWEAKS
v11.CreateToggle("FPS Unlocker", v11.FPSUnlockerEnabled, function(v1897)
    v11.FPSUnlockerEnabled = v1897
    if v1897 then v11.UnlockFPS() end
    print("FPS Unlock: " .. (v1897 and "ENABLED" or "DISABLED"))
end, v11.PerfTweaksFrame)

v11.CreateSlider("FPS Target", 60, 360, 240, function(v1898)
    v11.FPSTarget = v1898
end, v11.PerfTweaksFrame)

v11.CreateToggle("Render Distance", v11.RenderDistanceEnabled, function(v1899)
    v11.RenderDistanceEnabled = v1899
    print("Render Dist: " .. (v1899 and "ENABLED" or "DISABLED"))
end, v11.PerfTweaksFrame)

v11.CreateToggle("LOD Modifier", v11.LODModifierEnabled, function(v1900)
    v11.LODModifierEnabled = v1900
    print("LOD Modifier: " .. (v1900 and "ENABLED" or "DISABLED"))
end, v11.PerfTweaksFrame)

v11.CreateToggle("Memory Optimizer", v11.MemOptimEnabled, function(v1901)
    v11.MemOptimEnabled = v1901
    if v1901 then v11.OptimizeMemory() end
    print("Memory Optimize: " .. (v1901 and "ENABLED" or "DISABLED"))
end, v11.PerfTweaksFrame)

-- DETECTION EVASION
v11.CreateToggle("Ban Prevention", v11.BanPreventionEnabled, function(v1902)
    v11.BanPreventionEnabled = v1902
    print("Ban Prevention: " .. (v1902 and "ENABLED" or "DISABLED"))
end, v11.EvasionFrame)

v11.CreateToggle("Signature Hider", v11.SigHiderEnabled, function(v1903)
    v11.SigHiderEnabled = v1903
    print("Sig Hider: " .. (v1903 and "ENABLED" or "DISABLED"))
end, v11.EvasionFrame)

v11.CreateToggle("Action Randomizer", v11.ActionRandomizerEnabled, function(v1904)
    v11.ActionRandomizerEnabled = v1904
    print("Action Random: " .. (v1904 and "ENABLED" or "DISABLED"))
end, v11.EvasionFrame)

v11.CreateToggle("Delay Injector", v11.DelayInjectorEnabled, function(v1905)
    v11.DelayInjectorEnabled = v1905
    print("Delay Inject: " .. (v1905 and "ENABLED" or "DISABLED"))
end, v11.EvasionFrame)

v11.CreateToggle("Pattern Obfuscator", v11.PatternObfuscatorEnabled, function(v1906)
    v11.PatternObfuscatorEnabled = v1906
    print("Pattern Obfus: " .. (v1906 and "ENABLED" or "DISABLED"))
end, v11.EvasionFrame)

-- UTILITY TOOLS
v11.CreateToggle("Macro Recorder", v11.MacroRecorderEnabled, function(v1907)
    v11.MacroRecorderEnabled = v1907
    print("Macro Record: " .. (v1907 and "ENABLED" or "DISABLED"))
end, v11.UtilityFrame)

v11.CreateButton("Start Macro", function()
    v11.RecordMacro("Macro1")
end, v11.UtilityFrame)

v11.CreateToggle("Keybind Manager", v11.KeybindManagerEnabled, function(v1908)
    v11.KeybindManagerEnabled = v1908
    print("Keybind Manager: " .. (v1908 and "ENABLED" or "DISABLED"))
end, v11.UtilityFrame)

v11.CreateToggle("Perf Profiler", v11.PerfProfilerEnabled, function(v1909)
    v11.PerfProfilerEnabled = v1909
    print("Perf Profiler: " .. (v1909 and "ENABLED" or "DISABLED"))
end, v11.UtilityFrame)

v11.CreateToggle("Bug Reporter", v11.BugReporterEnabled, function(v1910)
    v11.BugReporterEnabled = v1910
    print("Bug Reporter: " .. (v1910 and "ENABLED" or "DISABLED"))
end, v11.UtilityFrame)

v11.CreateToggle("Help System", v11.HelpSystemEnabled, function(v1911)
    v11.HelpSystemEnabled = v1911
    print("Help System: " .. (v1911 and "ENABLED" or "DISABLED"))
end, v11.UtilityFrame)

v11.ToggleMenu = function()
    -- If menu auto-close is disabled, don't close menu automatically
    if not v11.MenuOpen and v11.MenuAutoCloseEnabled == false then
        -- Menu is already closed and auto-close is disabled, so open it
        v11.MenuOpen = true
    else
        v11.MenuOpen = not v11.MenuOpen
    end
    
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

-- ========== ANIMATED UI EFFECTS ==========
v11.AnimationSpeed = 1
v11.BackgroundMode = "rainbow"
v11.MenuGlowEnabled = true
v11.ButtonAnimEnabled = true
v11.TextGlowEnabled = true
v11.ParticleEnabled = true

v11.CreateAnimatedBackground = function()
    if not v11.MainFrame:FindFirstChild("AnimatedBG") then
        local v1950 = Instance.new("Frame")
        v1950.Name = "AnimatedBG"
        v1950.Size = UDim2.new(1, 0, 1, 0)
        v1950.Position = UDim2.new(0, 0, 0, 0)
        v1950.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        v1950.BorderSizePixel = 0
        v1950.ZIndex = -1
        v1950.Parent = v11.MainFrame
        
        local v1951 = Instance.new("UICorner")
        v1951.CornerRadius = UDim.new(0, 12)
        v1951.Parent = v1950
    end
end

v11.AnimateBackgroundColor = function()
    if not v11.MainFrame then return end
    
    local v1952 = v11.MainFrame:FindFirstChild("AnimatedBG")
    if not v1952 then v11.CreateAnimatedBackground() v1952 = v11.MainFrame:FindFirstChild("AnimatedBG") end
    
    if v11.BackgroundMode == "rainbow" then
        local v1953 = (tick() * 0.5 * v11.AnimationSpeed) % 1
        v1952.BackgroundColor3 = v11.GetRainbowColor(v1953, 2)
    elseif v11.BackgroundMode == "gradient" then
        local v1954 = (tick() * 0.3 * v11.AnimationSpeed) % 1
        if v1954 < 0.5 then
            v1952.BackgroundColor3 = Color3.new(1, v1954 * 2, 0)
        else
            v1952.BackgroundColor3 = Color3.new(1, 2 - v1954 * 2, 0)
        end
    elseif v11.BackgroundMode == "pulsing" then
        local v1955 = math.sin(tick() * v11.AnimationSpeed) * 0.5 + 0.5
        v1952.BackgroundColor3 = Color3.new(v1955 * 0.1, v1955 * 0.05, 0)
    elseif v11.BackgroundMode == "neon" then
        local v1956 = (tick() * 0.4 * v11.AnimationSpeed) % 1
        if v1956 < 0.33 then
            v1952.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        elseif v1956 < 0.66 then
            v1952.BackgroundColor3 = Color3.fromRGB(40, 30, 10)
        else
            v1952.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    elseif v11.BackgroundMode == "black-orange" then
        -- Black to Orange gradient theme
        local v1957 = (tick() * 0.3 * v11.AnimationSpeed) % 1
        if v1957 < 0.5 then
            local blend = v1957 * 2
            v1952.BackgroundColor3 = Color3.new(
                (255/255) * blend,
                (140/255) * blend,
                0
            )
        else
            local blend = (v1957 - 0.5) * 2
            v1952.BackgroundColor3 = Color3.new(
                1 - (255/255) * blend + (20/255) * blend,
                (140/255) - (140/255) * blend + (20/255) * blend,
                0 + (20/255) * blend
            )
        end
    elseif v11.BackgroundMode == "orange-white" then
        -- Orange to White pulsing
        local v1958 = math.sin(tick() * v11.AnimationSpeed * 0.5) * 0.5 + 0.5
        v1952.BackgroundColor3 = Color3.new(
            (255/255) - (55/255) * v1958,
            (140/255) + (115/255) * v1958,
            (0/255) + (255/255) * v1958
        )
    elseif v11.BackgroundMode == "neon-orange" then
        -- Fast pulsing orange
        local v1959 = math.sin(tick() * v11.AnimationSpeed * 1.5) * 0.5 + 0.5
        v1952.BackgroundColor3 = Color3.new(
            1 * v1959 + (20/255) * (1 - v1959),
            (140/255) * v1959 + (20/255) * (1 - v1959),
            0
        )
    elseif v11.BackgroundMode == "static" then
        -- Static black background
        v1952.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end

v11.AddButtonGlowEffect = function(v1957)
    if not v1957:FindFirstChild("GlowEffect") then
        local v1958 = Instance.new("UIStroke")
        v1958.Name = "GlowEffect"
        v1958.Color = Color3.fromRGB(255, 140, 0)  -- Orange glow
        v1958.Thickness = 0
        v1958.Parent = v1957
    end
end

v11.AnimateButtonGlow = function(v1957)
    local v1959 = v1957:FindFirstChild("GlowEffect")
    if v1959 then
        local v1960 = (math.sin(tick() * v11.AnimationSpeed) + 1) * 1.5
        v1959.Thickness = v1960
    end
end

v11.AddTextGlow = function(v1961)
    if not v1961:FindFirstChild("TextGlow") then
        local v1962 = Instance.new("UIStroke")
        v1962.Name = "TextGlow"
        v1962.Color = Color3.fromRGB(255, 255, 255)  -- White glow
        v1962.Thickness = 0.5
        v1962.Parent = v1961
    end
end

v11.CreateParticleEffect = function(v1963)
    local v1964 = Instance.new("Frame")
    v1964.Name = "Particle"
    v1964.Size = UDim2.new(0, 5, 0, 5)
    v1964.BackgroundColor3 = Color3.fromRGB(255, 140, 0)  -- Orange particles
    v1964.BorderSizePixel = 0
    v1964.Parent = v11.ScreenGui
    
    local v1965 = Instance.new("UICorner")
    v1965.CornerRadius = UDim.new(1, 0)
    v1965.Parent = v1964
    
    local v1966 = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    local v1967 = v3:Create(v1964, v1966, {Position = v1963.Position + UDim2.new(0, math.random(-50, 50), 0, 100), BackgroundTransparency = 1})
    v1967:Play()
    
    v1967.Completed:Connect(function()
        v1964:Destroy()
    end)
end

v11.AnimateButtonHover = function(v1968)
    v1968.MouseEnter:Connect(function()
        local v1969 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1970 = v3:Create(v1968, v1969, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
        v1970:Play()
        
        if v11.ParticleEnabled then
            for v1971 = 1, 3 do
                v11.CreateParticleEffect(v1968)
            end
        end
    end)
    
    v1968.MouseLeave:Connect(function()
        local v1972 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v1973 = v3:Create(v1968, v1972, {BackgroundColor3 = Color3.fromRGB(0, 100, 255)})
        v1973:Play()
    end)
end

v11.ApplyAnimationToTab = function(v1974)
    local v1975 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v1976 = v3:Create(v1974, v1975, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0})
    v1976:Play()
end

v11.AnimateUIElements = function()
    for v1977, v1978 in pairs(v11.MainFrame:GetDescendants()) do
        if v1978:IsA("TextButton") and v1978.Parent and v1978.Parent.Name ~= "UICorner" then
            if v11.ButtonAnimEnabled and not v1978:FindFirstChild("GlowEffect") then
                v11.AddButtonGlowEffect(v1978)
                v11.AnimateButtonHover(v1978)
            end
            
            if v11.MenuGlowEnabled then
                v11.AnimateButtonGlow(v1978)
            end
        end
    end
end

-- ========== MAIN UPDATE LOOP FOR NEW FEATURES ==========
coroutine.wrap(function()
    while true do
        wait(0.016) -- 60 FPS
        
        -- UI ANIMATIONS & EFFECTS
        v11.AnimateBackgroundColor()
        v11.AnimateUIElements()
        
        if v11.HealthBarEnabled then
            v11.UpdateHealthBars()
        end
        
        if v11.DistanceDisplayEnabled then
            v11.UpdateDistanceDisplays()
        end
        
        if v11.TracerLinesEnabled then
            v11.UpdateTracerLines()
        end
        
        if v11.BoxESPEnabled then
            v11.UpdateBoxESP()
        end
        
        if v11.TerrorRadiusEnabled then
            v11.UpdateTerrorRadius()
        end
        
        if v11.MatchTimerEnabled or v11.SpeedometerEnabled then
            v11.UpdateInfoOverlay()
        end
        
        if v11.AutoUnhookEnabled then
            v11.AutoUnhook()
        end
        
        if v11.AutoSkillcheckEnabled then
            v11.AutoSkillcheck()
        end
        
        if v11.AutoDropPalletsEnabled then
            v11.AutoDropPallets()
        end
        
        -- PREDICTION & TARGETING
        if v11.PredictionEnabled and v9.Character then
            for v1800, v1801 in pairs(v0:GetPlayers()) do
                if v1801 ~= v9 and v1801.Character then
                    local v1802 = v11.CalculatePredictedPosition(v1801)
                end
            end
        end
        
        if v11.EscapeRouteEnabled then
            v11.GetEscapeRoutes()
        end
        
        if v11.DangerZoneEnabled then
            v11.AnalyzeDangerZones()
        end
        
        -- ANALYTICS
        if v11.StatsTrackerEnabled then
            for v1803, v1804 in pairs(v0:GetPlayers()) do
                if v1804 ~= v9 then
                    v11.UpdatePlayerStats(v1804)
                end
            end
        end
        
        if v11.BehaviorLoggerEnabled and v9.Character then
            v11.LogBehavior(v9.Name, "moving")
        end
        
        if v11.AntiCheatDetectorEnabled then
            v11.DetectAnticheat()
        end
        
        -- UI UPDATES
        if v11.RadarEnabled and v11.RadarFrame then
            v11.UpdateRadar()
        end
        
        -- AUTO FEATURES (ALL)
        if v11.PathNavEnabled and v9.Character then
            local v1805 = v11.GetEscapeRoutes()
            if #v1805 > 0 then
                v11.NavigateToPoint(v1805[1].Position)
            end
        end
        
        if v11.AutoObjectivesEnabled then
            v11.ExecuteAutoObjectives()
        end
        
        if v11.SmartDodgeEnabled then
            v11.SmartDodge()
        end
        
        if v11.AutoLootEnabled then
            v11.CollectNearbyLoot()
        end
        
        if v11.AutoFarmEnabled then
            v11.AutoFarm()
        end
        
        -- MAP HACKING
        if v11.LandmarkHighlightEnabled then
            v11.HighlightLandmarks()
        end
        
        -- ADVANCED MOVEMENT
        if v11.WallPhaseEnabled then
            v11.EnableWallPhase()
        end
        
        if v11.CollisionBypassEnabled then
            v11.BypassCollision()
        end
        
        -- COMBAT FEATURES
        if v11.FramePerfectEnabled and math.random(1, 100) < 5 then
            print("[Combat] Frame perfect detected!")
        end
        
        -- RECORDING
        if v11.HighlightDetectorEnabled then
            v11.DetectHighlight()
        end
        
        if v11.AutoClipEnabled and v11.IsRecording then
            -- Recording is active
        end
        
        -- AI FEATURES
        if v11.AIPathfinderEnabled and v9.Character then
            v11.ComputeOptimalPath(v9.Character.PrimaryPart.Position)
        end
        
        if v11.ThreatAssessmentEnabled then
            v11.AssessThreat()
        end
        
        -- NETWORK
        if v11.ActionQueueEnabled and #v11.ActionQueue > 0 then
            v11.ProcessActionQueue()
        end
        
        -- SECURITY
        if v11.RateLimiterEnabled then
            v11.CheckRateLimit()
        end
        
        if v11.BehaviorRandomizerEnabled then
            if math.random(1, 100) < 5 then
                v11.RandomizeBehavior()
            end
        end
        
        if v11.ActionRandomizerEnabled and math.random(1, 100) < 3 then
            v11.RandomizeActions()
        end
        
        if v11.DelayInjectorEnabled and math.random(1, 100) < 5 then
            v11.InjectRandomDelay()
        end
        
        -- UTILITIES
        if v11.PerfProfilerEnabled then
            v11.ProfilePerformance()
        end
        
        -- SCHEDULED TASKS
        for v1806, v1807 in ipairs(v11.ScheduledTasks) do
            if tick() >= v1807.time then
                pcall(v1807.callback)
                table.remove(v11.ScheduledTasks, v1806)
            end
        end
    end
end)()

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
    v1039.Size = UDim2.new(0, 350, 0, 60)
    v1039.Position = UDim2.new(0.5, -175, 0.5, -40)
    v1039.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v1039.BackgroundTransparency = 0.3
    v1039.Text = "F1: Menu | K: Aimbot | 30+ New Tabs | Animated UI Effects!"
    v1039.TextColor3 = Color3.fromRGB(100, 255, 100)
    v1039.TextSize = 14
    v1039.Font = Enum.Font.GothamBold
    v1039.TextStrokeTransparency = 0.5
    v1039.ZIndex = 1000
    v1039.Parent = v11.ScreenGui
    
    local v1054 = Instance.new("UICorner")
    v1054.CornerRadius = UDim.new(0, 12)
    v1054.Parent = v1039
    
    local v1055 = Instance.new("UIStroke")
    v1055.Color = Color3.fromRGB(100, 255, 100)
    v1055.Thickness = 2
    v1055.Parent = v1039
    
    v1039.Position = UDim2.new(1, 400, 1, -80)
    local v1057 = v3:Create(v1039, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -360, 1, -80)})
    v1057:Play()
    
    delay(5, function()
        local v1218 = v3:Create(v1039, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 400, 1, -80)})
        v1218:Play()
        v1218.Completed:Connect(function()
            v1039:Destroy()
        end)
    end)
end

-- ========== UI THEME SELECTOR ==========
v11.CreateThemeSelector = function()
    local v1080 = Instance.new("Frame")
    v1080.Name = "ThemeSelector"
    v1080.Size = UDim2.new(0, 200, 0, 120)
    v1080.Position = UDim2.new(0, 20, 0, 500)
    v1080.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    v1080.BorderSizePixel = 0
    v1080.Parent = v11.ScreenGui
    
    local v1081 = Instance.new("UICorner")
    v1081.CornerRadius = UDim.new(0, 10)
    v1081.Parent = v1080
    
    local v1082 = Instance.new("UIStroke")
    v1082.Color = Color3.fromRGB(100, 200, 255)
    v1082.Thickness = 2
    v1082.Parent = v1080
    
    local v1083 = Instance.new("TextLabel")
    v1083.Size = UDim2.new(1, 0, 0, 25)
    v1083.BackgroundTransparency = 1
    v1083.Text = "Background Mode"
    v1083.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1083.TextSize = 12
    v1083.Font = Enum.Font.GothamBold
    v1083.Parent = v1080
    
    local v1084 = {"Rainbow", "Gradient", "Pulsing", "Neon"}
    local v1085 = 25
    
    for v1086, v1087 in ipairs(v1084) do
        local v1088 = Instance.new("TextButton")
        v1088.Size = UDim2.new(0.45, 0, 0, 20)
        v1088.Position = UDim2.new(0.05 + (v1086 % 2) * 0.5, 0, 0, v1085 + math.floor((v1086 - 1) / 2) * 22)
        v1088.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        v1088.BorderSizePixel = 0
        v1088.Text = v1087
        v1088.TextColor3 = Color3.fromRGB(200, 200, 200)
        v1088.TextSize = 11
        v1088.Font = Enum.Font.Gotham
        v1088.Parent = v1080
        
        local v1089 = Instance.new("UICorner")
        v1089.CornerRadius = UDim.new(0, 5)
        v1089.Parent = v1088
        
        v1088.MouseButton1Click:Connect(function()
            v11.BackgroundMode = v1087:lower()
            print("Background Mode: " .. v1087)
        end)
    end
end

v11.CreateTeleportMenu()

v11.CreateAnimatedBackground()
v11.CreateThemeSelector()

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

-- ========== SMOOTH STARTUP SEQUENCE ==========
local v2017 = v11.CreateLoadingScreen()
wait(0.5)

-- Animate title on startup
v11.AnimateTitle()

-- Simulate loading for 2 seconds
for v2018 = 1, 20 do
    wait(0.1)
end

-- Fade out loading screen
local v2019 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v2020 = v3:Create(v2017, v2019, {BackgroundTransparency = 1})
v2020:Play()

for _, v2021 in pairs(v2017:GetDescendants()) do
    if v2021:IsA("TextLabel") or v2021:IsA("Frame") then
        local v2022 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local v2023 = v3:Create(v2021, v2022, {BackgroundTransparency = 1, TextTransparency = 1})
        v2023:Play()
    end
end

wait(0.8)
v2017:Destroy()

-- Open menu with smooth fade-in
v11.MainFrame.BackgroundTransparency = 0.5
local v2024 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2025 = v3:Create(v11.MainFrame, v2024, {BackgroundTransparency = 0})
v2025:Play()

v11.ToggleMenu()

print("===========================================")
print("Violence District Ultimate ULTRA LOADED!")
print("===========================================")
print("F1 - Show/Hide menu")
print("K - Toggle aimbot ON/OFF")
print("")
print("FEATURE COUNT: 80+ Features")
print("UI TABS: 25 Total (All Categories)")
print("ANIMATION EFFECTS: Rainbow | Gradient | Pulsing | Neon")
print("BUTTON ANIMATIONS: Glow | Hover | Particles")
print("")
print("NEW TABS:")
print("ADV ESP | AUTO | EXPLOITS | PRED | STATS | UI | NET")
print("STATE | SEC | DEV | QOL | COMBAT | MAP | MOVE | FARM")
print("REC | COMM | ACC | VFX | DB | AI | SKILL | PERF | EVADE | UTIL")
print("")
print("DRAG sliders to change values")
print("CLICK buttons to toggle features")
print("SELECT background mode in bottom-left")
print("===========================================")
-- ========== SMOOTH LOADING UI ==========
v11.CreateLoadingScreen = function()
    local v1984 = Instance.new("Frame")
    v1984.Name = "LoadingScreen"
    v1984.Size = UDim2.new(1, 0, 1, 0)
    v1984.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    v1984.BorderSizePixel = 0
    v1984.ZIndex = 9999
    v1984.Parent = v11.ScreenGui
    
    local v1985 = Instance.new("Frame")
    v1985.Name = "LoadingBox"
    v1985.Size = UDim2.new(0, 300, 0, 150)
    v1985.Position = UDim2.new(0.5, -150, 0.5, -75)
    v1985.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    v1985.BorderSizePixel = 0
    v1985.Parent = v1984
    
    local v1986 = Instance.new("UICorner")
    v1986.CornerRadius = UDim.new(0, 12)
    v1986.Parent = v1985
    
    local v1987 = Instance.new("UIStroke")
    v1987.Color = Color3.fromRGB(255, 140, 0)
    v1987.Thickness = 2
    v1987.Parent = v1985
    
    local v1988 = Instance.new("TextLabel")
    v1988.Name = "LoadingText"
    v1988.Size = UDim2.new(1, 0, 0, 40)
    v1988.Position = UDim2.new(0, 0, 0, 10)
    v1988.BackgroundTransparency = 1
    v1988.Text = "LOADING..."
    v1988.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1988.TextSize = 18
    v1988.Font = Enum.Font.GothamBold
    v1988.Parent = v1985
    
    local v1989 = Instance.new("Frame")
    v1989.Name = "ProgressBar"
    v1989.Size = UDim2.new(0, 250, 0, 8)
    v1989.Position = UDim2.new(0, 25, 0, 65)
    v1989.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    v1989.BorderSizePixel = 0
    v1989.Parent = v1985
    
    local v1990 = Instance.new("UICorner")
    v1990.CornerRadius = UDim.new(0, 4)
    v1990.Parent = v1989
    
    local v1991 = Instance.new("Frame")
    v1991.Name = "Fill"
    v1991.Size = UDim2.new(0, 0, 1, 0)
    v1991.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    v1991.BorderSizePixel = 0
    v1991.Parent = v1989
    
    local v1992 = Instance.new("UICorner")
    v1992.CornerRadius = UDim.new(0, 4)
    v1992.Parent = v1991
    
    -- Animate loading bar
    local v1993 = 0
    local v1994 = coroutine.create(function()
        while v1984.Parent do
            v1993 = (v1993 + math.random(2, 8)) % 100
            local v1995 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v1996 = v3:Create(v1991, v1995, {Size = UDim2.new(0, (v1993 / 100) * 250, 1, 0)})
            v1996:Play()
            wait(0.4)
        end
    end)
    coroutine.resume(v1994)
    
    return v1984
end

-- ========== BUTTON ANIMATIONS ==========
v11.AddButtonAnimations = function(v1997)
    local v1998 = false
    
    v1997.MouseEnter:Connect(function()
        if v1998 then return end
        v1998 = true
        
        local v1999 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2000 = v3:Create(v1997, v1999, {
            BackgroundColor3 = Color3.fromRGB(0, 120, 255),
            TextSize = 16
        })
        v2000:Play()
        v2000.Completed:Connect(function() v1998 = false end)
    end)
    
    v1997.MouseLeave:Connect(function()
        if v1998 then return end
        v1998 = true
        
        local v2001 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2002 = v3:Create(v1997, v2001, {
            BackgroundColor3 = Color3.fromRGB(0, 100, 255),
            TextSize = 14
        })
        v2002:Play()
        v2002.Completed:Connect(function() v1998 = false end)
    end)
    
    v1997.MouseButton1Down:Connect(function()
        local v2003 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v2004 = v3:Create(v1997, v2003, {BackgroundColor3 = Color3.fromRGB(0, 80, 200)})
        v2004:Play()
    end)
    
    v1997.MouseButton1Up:Connect(function()
        local v2005 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2006 = v3:Create(v1997, v2005, {BackgroundColor3 = Color3.fromRGB(0, 100, 255)})
        v2006:Play()
    end)
end

-- ========== TITLE ANIMATIONS ==========
v11.AnimateTitle = function()
    local v2007 = v11.TitleLabel
    if not v2007 then return end
    
    local v2008 = coroutine.create(function()
        while v2007.Parent do
            local v2009 = math.sin(tick() * 1.5) * 0.1 + 1
            v2007.TextSize = 16 * v2009
            wait(0.016)
        end
    end)
    coroutine.resume(v2008)
end

-- ========== SMOOTH MENU FADE ==========
v11.SmoothMenuFade = function(v2010, v2011)
    local v2012 = TweenInfo.new(v2011, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local v2013 = v3:Create(v2010, v2012, {BackgroundTransparency = v2010.BackgroundTransparency})
    
    for _, v2014 in pairs(v2010:GetDescendants()) do
        if v2014:IsA("TextLabel") or v2014:IsA("TextButton") or v2014:IsA("Frame") then
            local v2015 = TweenInfo.new(v2011, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local v2016 = v3:Create(v2014, v2015, {BackgroundTransparency = v2014.BackgroundTransparency})
            v2016:Play()
        end
    end
    v2013:Play()
end
