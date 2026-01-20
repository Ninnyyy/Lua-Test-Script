-- main.lua (LocalScript)
-- Put in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Controls
local OPEN_KEY = Enum.KeyCode.LeftControl
local CLOSE_KEY = Enum.KeyCode.RightControl

-- UI name
local UI_NAME = "Ninny.top"

-- Theme
local Colors = {
	Backdrop = Color3.fromRGB(10, 10, 14),
	Panel = Color3.fromRGB(20, 20, 28),
	Text = Color3.fromRGB(240, 240, 245),
	SubText = Color3.fromRGB(180, 180, 190),
	Btn = Color3.fromRGB(32, 32, 44),
	BtnHover = Color3.fromRGB(45, 45, 62),
	Accent = Color3.fromRGB(120, 80, 255),
	Accent2 = Color3.fromRGB(80, 220, 255),
	Good = Color3.fromRGB(80, 220, 140),
	Warn = Color3.fromRGB(255, 200, 80),
	Bad  = Color3.fromRGB(255, 90, 90),
}

-- ----------------------------------------------------
-- Utilities
-- ----------------------------------------------------
local function make(className, props)
	local inst = Instance.new(className)
	for k, v in pairs(props) do
		if k ~= "Parent" then
			inst[k] = v
		end
	end
	inst.Parent = props.Parent
	return inst
end

local function tween(obj, tinfo, props)
	local t = TweenService:Create(obj, tinfo, props)
	t:Play()
	return t
end

local function getGui()
	return playerGui:FindFirstChild(UI_NAME)
end

-- ----------------------------------------------------
-- Blur effect (reused)
-- ----------------------------------------------------
local blur = Lighting:FindFirstChild("MainUI_Blur")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "MainUI_Blur"
	blur.Size = 0
	blur.Parent = Lighting
end

-- ----------------------------------------------------
-- UI Construction
-- ----------------------------------------------------
local shimmerConn: RBXScriptConnection? = nil

local function buildUI()
	-- Destroy old if somehow exists
	local old = getGui()
	if old then old:Destroy() end

	local gui = make("ScreenGui", {
		Name = UI_NAME,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	local backdrop = make("Frame", {
		Name = "Backdrop",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colors.Backdrop,
		BackgroundTransparency = 1, -- start hidden
		BorderSizePixel = 0,
		Parent = gui,
	})

	make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Colors.Backdrop),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}),
		Parent = backdrop,
	})

	-- Shadow behind panel
	local shadow = make("ImageLabel", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.fromOffset(580, 380),
		ZIndex = 1,
		Parent = backdrop,
	})

	local panel = make("Frame", {
		Name = "Panel",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(-0.2, 0, 0.5, 0), -- start offscreen left
		Size = UDim2.fromOffset(520, 320),
		BackgroundColor3 = Colors.Panel,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = backdrop,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = panel })

	local scale = make("UIScale", {
		Scale = 0.9,
		Parent = panel,
	})

	local stroke = make("UIStroke", {
		Color = Colors.Accent,
		Thickness = 2,
		Transparency = 0.25,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = panel,
	})

	local strokeGrad = make("UIGradient", {
		Rotation = 0,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Colors.Accent),
			ColorSequenceKeypoint.new(0.5, Colors.Accent2),
			ColorSequenceKeypoint.new(1, Colors.Accent),
		}),
		Parent = stroke,
	})

	local title = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Main Menu",
		TextColor3 = Colors.Text,
		TextSize = 26,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -32, 0, 40),
		Position = UDim2.fromOffset(16, 14),
		ZIndex = 3,
		Parent = panel,
	})

	local subtitle = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "LeftCtrl opens • RightCtrl closes",
		TextColor3 = Colors.SubText,
		TextSize = 15,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -32, 0, 26),
		Position = UDim2.fromOffset(16, 48),
		ZIndex = 3,
		Parent = panel,
	})

	-- Content blocks
	local content = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -32, 1, -110),
		Position = UDim2.fromOffset(16, 86),
		ZIndex = 3,
		Parent = panel,
	})

	local left = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(0.55, -8, 1, 0),
		Parent = content,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = left })

	local right = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0.45, -8, 1, 0),
		Parent = content,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = right })

	local info = make("TextLabel", {
		BackgroundTransparency = 1,
		TextColor3 = Colors.Text,
		TextSize = 16,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "This is a single-script animated UI.\n\nEffects:\n• Blur + fade backdrop\n• Slide + bounce\n• Shimmer border\n• Popup notifications\n\nTry the buttons on the left.",
		Size = UDim2.new(1, -20, 1, -20),
		Position = UDim2.fromOffset(10, 10),
		Parent = right,
	})

	-- Buttons
	local list = make("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = left,
	})
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.VerticalAlignment = Enum.VerticalAlignment.Center

	local function mkButton(text, accent)
		local b = make("TextButton", {
			Text = text,
			TextColor3 = Colors.Text,
			TextSize = 16,
			Font = Enum.Font.GothamSemibold,
			BackgroundColor3 = Colors.Btn,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -24, 0, 44),
			Parent = left,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = b })
		local s = make("UIStroke", {
			Color = accent,
			Thickness = 1,
			Transparency = 0.5,
			Parent = b,
		})

		b.MouseEnter:Connect(function()
			tween(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
			tween(s, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.2 })
		end)

		b.MouseLeave:Connect(function()
			tween(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
			tween(s, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.5 })
		end)

		return b
	end

	local btnGood = mkButton("Popup: Success", Colors.Good)
	local btnWarn = mkButton("Popup: Warning", Colors.Warn)
	local btnBad  = mkButton("Popup: Error", Colors.Bad)

	-- Notifications holder (top-right)
	local notifHolder = make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(320, 400),
		ZIndex = 10,
		Parent = gui,
	})

	local notifLayout = make("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = notifHolder,
	})
	notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local function notify(kind, text)
		local accent = Colors.Accent
		if kind == "good" then accent = Colors.Good end
		if kind == "warn" then accent = Colors.Warn end
		if kind == "bad"  then accent = Colors.Bad end

		local card = make("Frame", {
			BackgroundColor3 = Color3.fromRGB(22, 22, 30),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(320, 64),
			ZIndex = 11,
			Parent = notifHolder,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = card })
		make("UIStroke", { Color = accent, Thickness = 2, Transparency = 0.25, Parent = card })

		local label = make("TextLabel", {
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Colors.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -18, 1, -18),
			Position = UDim2.fromOffset(9, 9),
			TextTransparency = 1,
			ZIndex = 12,
			Parent = card,
		})

		local cScale = make("UIScale", { Scale = 0.75, Parent = card })

		tween(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.05 })
		tween(label, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
		tween(cScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })

		task.delay(2.8, function()
			if card and card.Parent then
				tween(cScale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 })
				tween(label, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
				local out = tween(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
				out.Completed:Wait()
				if card then card:Destroy() end
			end
		end)
	end

	btnGood.MouseButton1Click:Connect(function()
		notify("good", "Success! UI is alive and bouncing.")
	end)

	btnWarn.MouseButton1Click:Connect(function()
		notify("warn", "Warning: Something might be spicy.")
	end)

	btnBad.MouseButton1Click:Connect(function()
		notify("bad", "Error: The gremlins did it.")
	end)

	-- Shimmer animation on stroke gradient
	if shimmerConn then shimmerConn:Disconnect() end
	local rot = 0
	shimmerConn = RunService.RenderStepped:Connect(function(dt)
		if not gui or not gui.Parent then
			if shimmerConn then shimmerConn:Disconnect() end
			return
		end
		rot = (rot + dt * 50) % 360
		strokeGrad.Rotation = rot
	end)

	return gui, backdrop, panel, shadow, scale
end

-- ----------------------------------------------------
-- Open / Close Animations
-- ----------------------------------------------------
local opening = false
local closing = false

local function openUI()
	if opening or closing then return end
	if getGui() then return end
	opening = true

	local gui, backdrop, panel, shadow, scale = buildUI()

	-- Blur in
	tween(blur, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 14 })

	-- Backdrop fade in
	tween(backdrop, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 })

	-- Panel + shadow slide in + bounce
	tween(scale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	tween(panel, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })
	tween(shadow, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })

	task.delay(0.15, function()
		opening = false
	end)
end

local function closeUI()
	if closing or opening then return end
	local gui = getGui()
	if not gui then return end
	closing = true

	local backdrop = gui:FindFirstChild("Backdrop")
	local panel = backdrop and backdrop:FindFirstChild("Panel")

	if panel then
		local scale = panel:FindFirstChildOfClass("UIScale")

		-- Blur out
		tween(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 0 })

		-- Fade backdrop out
		if backdrop then
			tween(backdrop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
		end

		-- Slide panel out to the RIGHT + shrink a bit
		if scale then
			tween(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.85 })
		end
		local out = tween(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1.2, 0, 0.5, 0)
		})

		out.Completed:Wait()
	end

	if shimmerConn then
		shimmerConn:Disconnect()
		shimmerConn = nil
	end

	gui:Destroy()
	closing = false
end

-- ----------------------------------------------------
-- Input handling
-- ----------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == OPEN_KEY then
		openUI()
	elseif input.KeyCode == CLOSE_KEY then
		closeUI()
	end
end)

-- Optional: start closed; uncomment to auto-open after spawn:
-- task.delay(1, openUI)
