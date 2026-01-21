-- modules/UI.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

UI.TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function UI.CreateMainFrame(screenGui, config)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 650)
    MainFrame.Position = UDim2.new(0, 20, 0, 100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = screenGui

    -- Drag logic
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

    -- Title + corners + stroke
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Title.Text = config.GuiName or "Singularity-Ninny.top"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    local Corner = Instance.new("UICorner", MainFrame)
    Corner.CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 70)
    Stroke.Thickness = 2

    local Content = Instance.new("Frame", MainFrame)
    Content.Name = "ContentFrame"
    Content.Size = UDim2.new(1, -30, 1, -90)
    Content.Position = UDim2.new(0, 15, 0, 80)
    Content.BackgroundTransparency = 1

    MainFrame.ContentFrame = Content
    return MainFrame
end

function UI.CreateTab(name, parent)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Tab"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 4
    tabFrame.Visible = false
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.Parent = parent

    local layout = Instance.new("UIListLayout", tabFrame)
    layout.Padding = UDim.new(0, 15)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return tabFrame
end

function UI.CreateToggle(parent, name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Frame.Parent = parent

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(1, -65, 0.5, -12.5)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
    Button.Text = ""

    local BtnCorner = Instance.new("UICorner", Button)
    BtnCorner.CornerRadius = UDim.new(0, 12)

    local Dot = Instance.new("Frame", Button)
    Dot.Size = UDim2.new(0, 21, 0, 21)
    Dot.Position = default and UDim2.new(0, 29, 0, 2) or UDim2.new(0, 2, 0, 2)
    Dot.BackgroundColor3 = Color3.new(1,1,1)
    local DotCorner = Instance.new("UICorner", Dot)
    DotCorner.CornerRadius = UDim.new(0, 10)

    Button.MouseButton1Click:Connect(function()
        default = not default
        Button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = default and UDim2.new(0, 29, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        callback(default)
    end)
end

function UI.CreateSlider(parent, name, min, max, default, callback)
    -- (I'll give you full slider later if needed, but for now toggles are enough to test)
end

function UI.ToggleMenu(mainFrame)
    local target = mainFrame.Visible and UDim2.new(0, -470, 0, 100) or UDim2.new(0, 20, 0, 100)
    TweenService:Create(mainFrame, UI.TweenInfo, {Position = target}):Play()
    mainFrame.Visible = true
end

function UI.CreateSimpleNotification(screenGui)
    local notif = Instance.new("TextLabel", screenGui)
    notif.Size = UDim2.new(0, 200, 0, 40)
    notif.Position = UDim2.new(1, 300, 1, -50)
    notif.BackgroundColor3 = Color3.new(0,0,0)
    notif.BackgroundTransparency = 0.5
    notif.Text = "Open Menu: F1 | Aimbot: K"
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 14
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 8)

    TweenService:Create(notif, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -210, 1, -50)}):Play()
    task.delay(5, function()
        TweenService:Create(notif, TweenInfo.new(0.7), {Position = UDim2.new(1, 300, 1, -50)}):Play()
        notif:Destroy()
    end)
end

return UI