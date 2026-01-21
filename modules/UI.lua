-- modules/UI.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

UI.TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function UI.CreateMainFrame(screenGui, config)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 650)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0) -- centered a bit
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = screenGui

    -- Drag
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Title.Text = config.GuiName
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    local Corner = Instance.new("UICorner", MainFrame)
    Corner.CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 70)
    Stroke.Thickness = 2

    local Content = Instance.new("Frame")
    Content.Name = "ContentFrame"
    Content.Size = UDim2.new(1, -30, 1, -90)
    Content.Position = UDim2.new(0, 15, 0, 80)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    MainFrame.ContentFrame = Content
    return MainFrame
end

function UI.CreateTab(name, parent)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.ScrollBarThickness = 4
    tab.Visible = false
    tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Parent = parent

    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0, 15)

    return tab
end

function UI.CreateToggle(parent, name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = parent

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 50, 0, 25)
    button.Position = UDim2.new(1, -65, 0.5, -12.5)
    button.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(80,80,90)
    button.Text = ""

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

    local dot = Instance.new("Frame", button)
    dot.Size = UDim2.new(0, 21, 0, 21)
    dot.Position = default and UDim2.new(0,29,0,2) or UDim2.new(0,2,0,2)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0,10)

    button.MouseButton1Click:Connect(function()
        default = not default
        button.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(80,80,90)
        TweenService:Create(dot, TweenInfo.new(0.2), {
            Position = default and UDim2.new(0,29,0,2) or UDim2.new(0,2,0,2)
        }):Play()
        callback(default)
    end)
end

-- Slider stub (expand later)
function UI.CreateSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = parent

    -- Add real slider logic here when ready
    print("[UI] Slider stub created: " .. name)
end

function UI.ToggleMenu(frame)
    local targetPos = frame.Position.X.Offset > 0 and UDim2.new(0, -470, 0, 100) or UDim2.new(0, 20, 0, 100)
    TweenService:Create(frame, UI.TweenInfo, {Position = targetPos}):Play()
end

function UI.CreateSimpleNotification(screenGui)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 200, 0, 40)
    notif.Position = UDim2.new(1, 300, 1, -50)
    notif.BackgroundColor3 = Color3.new(0,0,0)
    notif.BackgroundTransparency = 0.5
    notif.Text = "Open Menu: F1 | Aimbot: K"
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 14
    notif.Parent = screenGui

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

    TweenService:Create(notif, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -210, 1, -50)
    }):Play()

    task.delay(5, function()
        TweenService:Create(notif, TweenInfo.new(0.7), {
            Position = UDim2.new(1, 300, 1, -50)
        }):Play()
        task.wait(0.7)
        notif:Destroy()
    end)
end

return UI