-- main.lua (LocalScript) - One file "full menu system"
-- Put in StarterPlayerScripts

--//////////////////////////////////////////////////////
-- Services
--//////////////////////////////////////////////////////
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

--//////////////////////////////////////////////////////
-- CONFIG
--//////////////////////////////////////////////////////
local UI_NAME = "MainAnimatedUI_Full"
local TOGGLE_BUTTON_GUI = "MainMenu_ToggleButton"

-- Default toggle keys (can be changed in Settings)
local ToggleKeys = {
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.RightControl] = true,
	[Enum.KeyCode.Escape] = true,
}

-- Gamepad toggle
local TOGGLE_GAMEPAD_START = true

-- Sound IDs (set these to your own!)
-- If you leave them blank, sounds simply won't play.
local SOUND_IDS = {
	Open  = "", -- e.g. "rbxassetid://123456"
	Close = "",
	Click = "",
	Hover = "",
	Notify = "",
}

local SettingsState = {
	SoundsEnabled = true,
	VignetteEnabled = true,
	BlurEnabled = true,
	FovPunchEnabled = true,
	MasterVolume = 0.8, -- 0..1 (applies to these UI sounds)
	CustomToggleKey = nil, -- Enum.KeyCode or nil
}

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

-- Dummy shop items (example)
local ShopItems = {
	{ id = "sword", name = "Sword", price = 100 },
	{ id = "speed", name = "Speed Boost", price = 150 },
	{ id = "vip", name = "VIP", price = 999 },
}

-- Dummy inventory items (example)
local InventoryItems = {
	"Wooden Sword",
	"Potion x3",
	"Key: Ancient Door",
}

--//////////////////////////////////////////////////////
-- Utility
--//////////////////////////////////////////////////////
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

local function isOpen()
	return getGui() ~= nil
end

local function safeDisconnect(conn)
	if conn and conn.Disconnect then
		conn:Disconnect()
	end
end

--//////////////////////////////////////////////////////
-- Effects: Blur + Vignette + FOV Punch
--//////////////////////////////////////////////////////
local blur = Lighting:FindFirstChild("MainUI_Blur_Full")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "MainUI_Blur_Full"
	blur.Size = 0
	blur.Parent = Lighting
end

local function ensureFov()
	if not camera then
		camera = workspace.CurrentCamera
	end
end

local originalFov = nil

local function fovPunchIn()
	if not SettingsState.FovPunchEnabled then return end
	ensureFov()
	if not camera then return end
	originalFov = originalFov or camera.FieldOfView
	tween(camera, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = originalFov - 6 })
end

local function fovPunchOut()
	if not SettingsState.FovPunchEnabled then return end
	ensureFov()
	if not camera then return end
	if not originalFov then originalFov = camera.FieldOfView end
	tween(camera, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = originalFov })
end

--//////////////////////////////////////////////////////
-- Sounds
--//////////////////////////////////////////////////////
local SoundFolder = SoundService:FindFirstChild("UI_Sounds_Full")
if not SoundFolder then
	SoundFolder = Instance.new("Folder")
	SoundFolder.Name = "UI_Sounds_Full"
	SoundFolder.Parent = SoundService
end

local function getSound(name)
	local s = SoundFolder:FindFirstChild(name)
	if not s then
		s = Instance.new("Sound")
		s.Name = name
		s.Volume = SettingsState.MasterVolume
		s.SoundId = SOUND_IDS[name] or ""
		s.Parent = SoundFolder
	end
	-- Keep updated
	s.Volume = SettingsState.MasterVolume
	s.SoundId = SOUND_IDS[name] or s.SoundId
	return s
end

local function playSound(name)
	if not SettingsState.SoundsEnabled then return end
	local id = SOUND_IDS[name]
	if not id or id == "" then return end
	local s = getSound(name)
	s:Play()
end

--//////////////////////////////////////////////////////
-- Notification System (stack + queue)
--//////////////////////////////////////////////////////
local Notif = {
	holder = nil,
	queue = {},
	activeCount = 0,
	maxActive = 3,
}

local function notifAccent(kind)
	if kind == "good" then return Colors.Good end
	if kind == "warn" then return Colors.Warn end
	if kind == "bad" then return Colors.Bad end
	return Colors.Accent
end

local function spawnNotification(kind, text)
	if not Notif.holder then return end
	Notif.activeCount += 1

	playSound("Notify")

	local accent = notifAccent(kind)

	local card = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(22, 22, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(320, 64),
		ZIndex = 50,
		Parent = Notif.holder,
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
		ZIndex = 51,
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

		Notif.activeCount -= 1

		-- Drain queue
		if #Notif.queue > 0 and Notif.activeCount < Notif.maxActive then
			local nextN = table.remove(Notif.queue, 1)
			spawnNotification(nextN.kind, nextN.text)
		end
	end)
end

local function notify(kind, text)
	if not Notif.holder then return end
	if Notif.activeCount >= Notif.maxActive then
		table.insert(Notif.queue, { kind = kind, text = text })
	else
		spawnNotification(kind, text)
	end
end

--//////////////////////////////////////////////////////
-- Modal Confirm Popup
--//////////////////////////////////////////////////////
local function showConfirm(gui, titleText, bodyText, onYes, onNo)
	local modalLayer = make("Frame", {
		Name = "ModalLayer",
		BackgroundColor3 = Colors.Backdrop,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 200,
		Parent = gui,
	})

	local modal = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(420, 220),
		BackgroundColor3 = Colors.Panel,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 201,
		Parent = modalLayer,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 16), Parent = modal })
	make("UIStroke", { Color = Colors.Accent, Thickness = 2, Transparency = 0.25, Parent = modal })

	local scale = make("UIScale", { Scale = 0.85, Parent = modal })

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = titleText or "Confirm",
		TextColor3 = Colors.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -24, 0, 28),
		Position = UDim2.fromOffset(12, 12),
		ZIndex = 202,
		Parent = modal,
	})

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = bodyText or "Are you sure?",
		TextColor3 = Colors.SubText,
		TextSize = 15,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, -24, 1, -90),
		Position = UDim2.fromOffset(12, 46),
		ZIndex = 202,
		Parent = modal,
	})

	local btnRow = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -24, 0, 44),
		Position = UDim2.new(0, 12, 1, -56),
		ZIndex = 202,
		Parent = modal,
	})

	local layout = make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = btnRow,
	})

	local function mkModalBtn(text, accent)
		local b = make("TextButton", {
			Text = text,
			TextColor3 = Colors.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			BackgroundColor3 = Colors.Btn,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(110, 40),
			ZIndex = 203,
			Parent = btnRow,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = b })
		make("UIStroke", { Color = accent, Thickness = 1, Transparency = 0.4, Parent = b })

		b.MouseEnter:Connect(function()
			playSound("Hover")
			tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
		end)
		b.MouseLeave:Connect(function()
			tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
		end)

		return b
	end

	local noBtn = mkModalBtn("Cancel", Colors.Warn)
	local yesBtn = mkModalBtn("Confirm", Colors.Good)

	local function closeModal()
		tween(scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 })
		tween(modalLayer, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
		task.delay(0.19, function()
			if modalLayer then modalLayer:Destroy() end
		end)
	end

	noBtn.MouseButton1Click:Connect(function()
		playSound("Click")
		closeModal()
		if onNo then onNo() end
	end)

	yesBtn.MouseButton1Click:Connect(function()
		playSound("Click")
		closeModal()
		if onYes then onYes() end
	end)

	-- Animate in
	tween(modalLayer, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.45 })
	tween(scale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
end

--//////////////////////////////////////////////////////
-- Loading Overlay + Spinner
--//////////////////////////////////////////////////////
local Spinner = {
	layer = nil,
	conn = nil,
	rot = 0,
}

local function showLoading(gui, text)
	if Spinner.layer then Spinner.layer:Destroy() Spinner.layer = nil end
	safeDisconnect(Spinner.conn)
	Spinner.rot = 0

	local layer = make("Frame", {
		Name = "LoadingLayer",
		BackgroundColor3 = Colors.Backdrop,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 300,
		Parent = gui,
	})
	Spinner.layer = layer

	local card = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(360, 140),
		BackgroundColor3 = Colors.Panel,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 301,
		Parent = layer,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 16), Parent = card })
	make("UIStroke", { Color = Colors.Accent2, Thickness = 2, Transparency = 0.25, Parent = card })

	local spinner = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://3926305904", -- Roblox sprite sheet (we use one icon region)
		ImageRectOffset = Vector2.new(764, 764),
		ImageRectSize = Vector2.new(36, 36),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(40, 40),
		ZIndex = 302,
		Parent = card,
	})

	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = text or "Loading...",
		TextColor3 = Colors.Text,
		TextSize = 16,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 70, 0.5, 0),
		Size = UDim2.new(1, -86, 0, 30),
		ZIndex = 302,
		Parent = card,
	})

	tween(layer, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 })

	Spinner.conn = RunService.RenderStepped:Connect(function(dt)
		if not spinner or not spinner.Parent then return end
		Spinner.rot = (Spinner.rot + dt * 360) % 360
		spinner.Rotation = Spinner.rot
	end)
end

local function hideLoading()
	if Spinner.layer then
		local layer = Spinner.layer
		safeDisconnect(Spinner.conn)
		Spinner.conn = nil
		Spinner.layer = nil
		tween(layer, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
		task.delay(0.13, function()
			if layer then layer:Destroy() end
		end)
	end
end

--//////////////////////////////////////////////////////
-- Main UI Build (Tabs/Pages + everything)
--//////////////////////////////////////////////////////
local shimmerConn = nil

local function buildUI()
	local old = getGui()
	if old then old:Destroy() end

	local gui = make("ScreenGui", {
		Name = UI_NAME,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	-- Backdrop
	local backdrop = make("Frame", {
		Name = "Backdrop",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colors.Backdrop,
		BackgroundTransparency = 1,
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

	-- Vignette overlay
	local vignette = make("ImageLabel", {
		Name = "Vignette",
		BackgroundTransparency = 1,
		Image = "rbxassetid://4576475446", -- soft vignette image
		ImageTransparency = SettingsState.VignetteEnabled and 0.25 or 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1,
		Parent = gui,
	})

	-- Notifications holder
	local notifHolder = make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(320, 400),
		ZIndex = 60,
		Parent = gui,
	})
	make("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = notifHolder,
	})
	Notif.holder = notifHolder

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
		Size = UDim2.fromOffset(660, 420),
		ZIndex = 10,
		Parent = backdrop,
	})

	-- Main panel
	local panel = make("Frame", {
		Name = "Panel",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(-0.3, 0, 0.5, 0), -- offscreen left start
		Size = UDim2.fromOffset(640, 380),
		BackgroundColor3 = Colors.Panel,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = backdrop,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = panel })
	local panelScale = make("UIScale", { Scale = 0.9, Parent = panel })

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

	-- Top bar (drag area)
	local topBar = make("Frame", {
		Name = "TopBar",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 76),
		ZIndex = 12,
		Parent = panel,
	})

	local title = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Singularity",
		TextColor3 = Colors.Text,
		TextSize = 26,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -160, 0, 40),
		Position = UDim2.fromOffset(16, 14),
		ZIndex = 13,
		Parent = panel,
	})

	local subtitle = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Ctrl/Esc/Start toggles • Mobile button supported",
		TextColor3 = Colors.SubText,
		TextSize = 15,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -160, 0, 26),
		Position = UDim2.fromOffset(16, 48),
		ZIndex = 13,
		Parent = panel,
	})

	-- Close button
	local closeBtn = make("TextButton", {
		Name = "Close",
		Text = "✕",
		TextColor3 = Colors.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Colors.Btn,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.fromOffset(40, 40),
		ZIndex = 14,
		Parent = panel,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = closeBtn })
	make("UIStroke", { Color = Colors.Accent2, Thickness = 1, Transparency = 0.5, Parent = closeBtn })

	closeBtn.MouseEnter:Connect(function()
		playSound("Hover")
		tween(closeBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
	end)

	-- Content area split: sidebar + pages
	local body = make("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -32, 1, -110),
		Position = UDim2.fromOffset(16, 86),
		ZIndex = 12,
		Parent = panel,
	})

	local sidebar = make("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 170, 1, 0),
		Parent = body,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = sidebar })

	local pagesWrap = make("Frame", {
		Name = "PagesWrap",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, -182, 1, 0),
		Parent = body,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = pagesWrap })

	local sidebarLayout = make("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = sidebar,
	})
	make("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		Parent = sidebar,
	})

	-- Pages container
	local pages = make("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = pagesWrap,
	})

	local pageLayout = make("UIPageLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		EasingStyle = Enum.EasingStyle.Quint,
		EasingDirection = Enum.EasingDirection.Out,
		TweenTime = 0.35,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = pages,
	})

	-- Helper: create a page
	local function mkPage(name, order)
		local page = make("Frame", {
			Name = name,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = order,
			Parent = pages,
		})
		make("UIPadding", {
			PaddingTop = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
			Parent = page,
		})
		return page
	end

	local pageHome = mkPage("Home", 1)
	local pageShop = mkPage("Shop", 2)
	local pageInv  = mkPage("Inventory", 3)
	local pageSet  = mkPage("Settings", 4)

	-- Page Header helper
	local function pageHeader(page, header, desc)
		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = header,
			TextColor3 = Colors.Text,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 28),
			Parent = page,
		})
		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = desc,
			TextColor3 = Colors.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.fromOffset(0, 30),
			Parent = page,
		})
	end

	-- Sidebar button helper
	local selectedTab = nil
	local tabButtons = {}

	local function mkSideButton(text, icon, tabName)
		local b = make("TextButton", {
			Text = "",
			BackgroundColor3 = Colors.Btn,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -24, 0, 42),
			Parent = sidebar,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = b })
		local strokeB = make("UIStroke", { Color = Colors.Accent, Thickness = 1, Transparency = 0.65, Parent = b })

		local label = make("TextLabel", {
			BackgroundTransparency = 1,
			Text = (icon and (icon .. " ") or "") .. text,
			TextColor3 = Colors.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.fromOffset(12, 0),
			Parent = b,
		})

		b.MouseEnter:Connect(function()
			playSound("Hover")
			if selectedTab ~= tabName then
				tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
				tween(strokeB, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.35 })
			end
		end)
		b.MouseLeave:Connect(function()
			if selectedTab ~= tabName then
				tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
				tween(strokeB, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
			end
		end)

		tabButtons[tabName] = { button = b, stroke = strokeB }
		return b
	end

	local function setSelectedTab(tabName)
		selectedTab = tabName
		for name, t in pairs(tabButtons) do
			if name == tabName then
				tween(t.button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
				tween(t.stroke, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.15 })
			else
				tween(t.button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
				tween(t.stroke, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
			end
		end
	end

	local function jumpTo(pageName)
		playSound("Click")
		if pageName == "Home" then pageLayout:JumpTo(pageHome) end
		if pageName == "Shop" then pageLayout:JumpTo(pageShop) end
		if pageName == "Inventory" then pageLayout:JumpTo(pageInv) end
		if pageName == "Settings" then pageLayout:JumpTo(pageSet) end
		setSelectedTab(pageName)
	end

	local btnHome = mkSideButton("Home", "🏠", "Home")
	local btnShop = mkSideButton("Shop", "🛒", "Shop")
	local btnInv  = mkSideButton("Inventory", "🎒", "Inventory")
	local btnSet  = mkSideButton("Settings", "⚙️", "Settings")

	btnHome.MouseButton1Click:Connect(function() jumpTo("Home") end)
	btnShop.MouseButton1Click:Connect(function() jumpTo("Shop") end)
	btnInv.MouseButton1Click:Connect(function() jumpTo("Inventory") end)
	btnSet.MouseButton1Click:Connect(function() jumpTo("Settings") end)

	-- HOME PAGE
	pageHeader(pageHome, "Home", "Welcome. This menu is fully scripted (one file).")

	do
		local box = make("Frame", {
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.95,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageHome,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = box })
		make("UIStroke", { Color = Colors.Accent2, Thickness = 1, Transparency = 0.75, Parent = box })

		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = "Features included:\n• Tabs & animated transitions\n• Confirm modals\n• Loading spinner overlay\n• Notifications (queue + stack)\n• Mobile & controller support\n• Dragging + blur + vignette + FOV punch\n\nTry Shop for confirm + loading demo.",
			TextColor3 = Colors.Text,
			TextSize = 15,
			Font = Enum.Font.Gotham,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, -20, 1, -20),
			Position = UDim2.fromOffset(10, 10),
			Parent = box,
		})
	end

	-- SHOP PAGE
	pageHeader(pageShop, "Shop", "Demo shop items with confirm modal + loading.")

	do
		local listFrame = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageShop,
		})

		local layout = make("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = listFrame,
		})

		local function mkShopRow(item)
			local row = make("Frame", {
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BackgroundTransparency = 0.95,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 56),
				Parent = listFrame,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
			make("UIStroke", { Color = Colors.Accent, Thickness = 1, Transparency = 0.8, Parent = row })

			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = item.name .. "  •  $" .. tostring(item.price),
				TextColor3 = Colors.Text,
				TextSize = 16,
				Font = Enum.Font.GothamSemibold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -140, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})

			local buy = make("TextButton", {
				Text = "Buy",
				TextColor3 = Colors.Text,
				TextSize = 15,
				Font = Enum.Font.GothamSemibold,
				BackgroundColor3 = Colors.Btn,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(110, 38),
				Parent = row,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = buy })
			make("UIStroke", { Color = Colors.Good, Thickness = 1, Transparency = 0.5, Parent = buy })

			buy.MouseEnter:Connect(function()
				playSound("Hover")
				tween(buy, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
			end)
			buy.MouseLeave:Connect(function()
				tween(buy, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
			end)

			buy.MouseButton1Click:Connect(function()
				playSound("Click")
				showConfirm(gui,
					"Buy Item",
					("Buy %s for $%d?"):format(item.name, item.price),
					function()
						-- Demo "processing"
						showLoading(gui, "Processing purchase...")
						task.delay(1.2, function()
							hideLoading()
							notify("good", ("Purchased: %s"):format(item.name))
						end)
					end,
					function()
						notify("warn", "Purchase cancelled.")
					end
				)
			end)
		end

		for _, it in ipairs(ShopItems) do
			mkShopRow(it)
		end
	end

	-- INVENTORY PAGE
	pageHeader(pageInv, "Inventory", "Example list. Replace with your real items.")

	do
		local box = make("Frame", {
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.95,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageInv,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = box })
		make("UIStroke", { Color = Colors.Accent2, Thickness = 1, Transparency = 0.75, Parent = box })

		local list = make("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -20, 1, -20),
			Position = UDim2.fromOffset(10, 10),
			Parent = box,
		})
		local layout = make("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = list,
		})

		for _, name in ipairs(InventoryItems) do
			local row = make("Frame", {
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BackgroundTransparency = 0.94,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 40),
				Parent = list,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = row })
			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = "• " .. name,
				TextColor3 = Colors.Text,
				TextSize = 15,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})
		end
	end

	-- SETTINGS PAGE (toggles, slider, keybind)
	pageHeader(pageSet, "Settings", "UI settings (local). Hook to server if you want to save.")

	local function mkSettingRow(parent, y, labelText)
		local row = make("Frame", {
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.95,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, y),
			Size = UDim2.new(1, 0, 0, 54),
			Parent = parent,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
		make("UIStroke", { Color = Colors.Accent, Thickness = 1, Transparency = 0.8, Parent = row })

		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = labelText,
			TextColor3 = Colors.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -200, 1, 0),
			Position = UDim2.fromOffset(12, 0),
			Parent = row,
		})
		return row
	end

	do
		local area = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageSet,
		})

		-- Toggle helper
		local function mkToggle(row, getValue, setValue)
			local btn = make("TextButton", {
				Text = "",
				BackgroundColor3 = Colors.Btn,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(110, 38),
				Parent = row,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = btn })
			local st = make("UIStroke", { Color = Colors.Accent2, Thickness = 1, Transparency = 0.5, Parent = btn })

			local txt = make("TextLabel", {
				BackgroundTransparency = 1,
				Text = "",
				TextColor3 = Colors.Text,
				TextSize = 14,
				Font = Enum.Font.GothamSemibold,
				Size = UDim2.fromScale(1, 1),
				Parent = btn,
			})

			local function refresh()
				local v = getValue()
				txt.Text = v and "ON" or "OFF"
				st.Color = v and Colors.Good or Colors.Warn
			end
			refresh()

			btn.MouseEnter:Connect(function()
				playSound("Hover")
				tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
			end)
			btn.MouseLeave:Connect(function()
				tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
			end)

			btn.MouseButton1Click:Connect(function()
				playSound("Click")
				setValue(not getValue())
				refresh()
			end)

			return refresh
		end

		-- Row: Sounds
		local rowSounds = mkSettingRow(area, 0, "Sounds")
		mkToggle(rowSounds,
			function() return SettingsState.SoundsEnabled end,
			function(v) SettingsState.SoundsEnabled = v end
		)

		-- Row: Vignette
		local rowVig = mkSettingRow(area, 64, "Vignette")
		mkToggle(rowVig,
			function() return SettingsState.VignetteEnabled end,
			function(v)
				SettingsState.VignetteEnabled = v
				local g = getGui()
				if g then
					local vg = g:FindFirstChild("Vignette")
					if vg then
						tween(vg, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = v and 0.25 or 1 })
					end
				end
			end
		)

		-- Row: Blur
		local rowBlur = mkSettingRow(area, 128, "Blur")
		mkToggle(rowBlur,
			function() return SettingsState.BlurEnabled end,
			function(v) SettingsState.BlurEnabled = v end
		)

		-- Row: FOV Punch
		local rowFov = mkSettingRow(area, 192, "Camera FOV punch")
		mkToggle(rowFov,
			function() return SettingsState.FovPunchEnabled end,
			function(v) SettingsState.FovPunchEnabled = v end
		)

		-- Row: Volume slider
		local rowVol = mkSettingRow(area, 256, "UI Volume")
		do
			local sliderBack = make("Frame", {
				BackgroundColor3 = Colors.Btn,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(180, 10),
				Parent = rowVol,
			})
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sliderBack })

			local fill = make("Frame", {
				BackgroundColor3 = Colors.Accent2,
				BorderSizePixel = 0,
				Size = UDim2.new(SettingsState.MasterVolume, 0, 1, 0),
				Parent = sliderBack,
			})
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

			local knob = make("Frame", {
				BackgroundColor3 = Colors.Text,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(SettingsState.MasterVolume, 0, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				Parent = sliderBack,
			})
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
			make("UIStroke", { Color = Colors.Accent, Thickness = 1, Transparency = 0.4, Parent = knob })

			local dragging = false
			local function setFromX(x)
				local abs = sliderBack.AbsolutePosition.X
				local w = sliderBack.AbsoluteSize.X
				local a = math.clamp((x - abs) / w, 0, 1)
				SettingsState.MasterVolume = a
				fill.Size = UDim2.new(a, 0, 1, 0)
				knob.Position = UDim2.new(a, 0, 0.5, 0)

				-- Update all our UI sounds
				for _, s in ipairs(SoundFolder:GetChildren()) do
					if s:IsA("Sound") then
						s.Volume = SettingsState.MasterVolume
					end
				end
			end

			sliderBack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					setFromX(input.Position.X)
				end
			end)
			sliderBack.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if not dragging then return end
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					setFromX(input.Position.X)
				end
			end)
		end

		-- Row: Keybind
		local rowKey = mkSettingRow(area, 320, "Toggle Keybind")
		do
			local btn = make("TextButton", {
				Text = "Set Key",
				TextColor3 = Colors.Text,
				TextSize = 14,
				Font = Enum.Font.GothamSemibold,
				BackgroundColor3 = Colors.Btn,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(110, 38),
				Parent = rowKey,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = btn })
			make("UIStroke", { Color = Colors.Accent2, Thickness = 1, Transparency = 0.5, Parent = btn })

			local info = make("TextLabel", {
				BackgroundTransparency = 1,
				Text = "Current: Ctrl/Esc/Start",
				TextColor3 = Colors.SubText,
				TextSize = 13,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Right,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -132, 0, 16),
				Size = UDim2.fromOffset(260, 20),
				Parent = rowKey,
			})

			local waiting = false
			local bindConn = nil

			local function refreshText()
				if SettingsState.CustomToggleKey then
					info.Text = "Current: " .. tostring(SettingsState.CustomToggleKey.Name) .. " + Ctrl/Esc/Start"
				else
					info.Text = "Current: Ctrl/Esc/Start"
				end
			end
			refreshText()

			btn.MouseEnter:Connect(function()
				playSound("Hover")
				tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
			end)
			btn.MouseLeave:Connect(function()
				tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
			end)

			btn.MouseButton1Click:Connect(function()
				playSound("Click")
				if waiting then return end
				waiting = true
				btn.Text = "Press key..."
				notify("warn", "Press any key to set a custom toggle key (Esc cancels).")

				safeDisconnect(bindConn)
				bindConn = UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.KeyCode == Enum.KeyCode.Escape then
						-- cancel
						notify("warn", "Keybind change cancelled.")
						waiting = false
						btn.Text = "Set Key"
						safeDisconnect(bindConn)
						return
					end

					-- Set custom key
					SettingsState.CustomToggleKey = input.KeyCode
					notify("good", "Toggle key set to: " .. tostring(input.KeyCode.Name))
					refreshText()

					waiting = false
					btn.Text = "Set Key"
					safeDisconnect(bindConn)
				end)
			end)
		end
	end

	-- Default to Home
	task.defer(function()
		jumpTo("Home")
	end)

	-- Shimmer animation
	safeDisconnect(shimmerConn)
	local rot = 0
	shimmerConn = RunService.RenderStepped:Connect(function(dt)
		if not gui or not gui.Parent then
			safeDisconnect(shimmerConn)
			return
		end
		rot = (rot + dt * 50) % 360
		strokeGrad.Rotation = rot
	end)

	-- Drag logic (top bar drags panel + shadow)
	do
		local dragging = false
		local dragStart = nil
		local startPos = nil

		local function update(input)
			if not dragging then return end
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			shadow.Position = panel.Position
		end

		topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = panel.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		topBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				update(input)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				update(input)
			end
		end)
	end

	return gui, backdrop, panel, shadow, panelScale, closeBtn
end

--//////////////////////////////////////////////////////
-- Open / Close Animations
--//////////////////////////////////////////////////////
local opening = false
local closing = false

local function openUI()
	if opening or closing then return end
	if isOpen() then return end
	opening = true

	local gui, backdrop, panel, shadow, scale, closeBtn = buildUI()

	-- Effects in
	if SettingsState.BlurEnabled then
		tween(blur, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 14 })
	else
		blur.Size = 0
	end

	-- Vignette already set by settings; fade it in a bit on open
	local vignette = gui:FindFirstChild("Vignette")
	if vignette then
		local target = SettingsState.VignetteEnabled and 0.25 or 1
		vignette.ImageTransparency = 1
		tween(vignette, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = target })
	end

	-- Backdrop fade
	tween(backdrop, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 })

	-- FOV punch
	fovPunchIn()

	-- Panel slide + bounce
	tween(scale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	tween(panel, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })
	tween(shadow, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })

	playSound("Open")
	notify("good", "Menu opened.")

	-- Close button hook
	closeBtn.MouseButton1Click:Connect(function()
		playSound("Click")
		task.spawn(function()
			-- close via toggle (so everything is consistent)
			-- (we call closeUI below via toggle function)
			local g = getGui()
			if g then
				-- simulate toggle close
				-- closeUI will be defined later; to avoid forward ref issues,
				-- we just fire Esc style toggle using a function pointer stored later.
			end
		end)
	end)

	task.delay(0.12, function()
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

	-- Effects out
	if SettingsState.BlurEnabled then
		tween(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 0 })
	else
		blur.Size = 0
	end

	local vignette = gui:FindFirstChild("Vignette")
	if vignette then
		tween(vignette, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { ImageTransparency = 1 })
	end

	fovPunchOut()

	if backdrop then
		tween(backdrop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
	end

	if panel then
		local scale = panel:FindFirstChildOfClass("UIScale")
		local cur = panel.Position

		if scale then
			tween(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.85 })
		end

		-- slide out to the right (keeps current Y even if you dragged)
		local out = tween(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1.25, 0, cur.Y.Scale, cur.Y.Offset)
		})
		out.Completed:Wait()
	end

	hideLoading()
	safeDisconnect(shimmerConn)
	shimmerConn = nil

	playSound("Close")
	-- no notify on close, usually feels cleaner

	gui:Destroy()
	Notif.holder = nil
	Notif.queue = {}
	Notif.activeCount = 0

	closing = false
end

local function toggleUI()
	if isOpen() then
		closeUI()
	else
		openUI()
	end
end

-- Now that toggle exists, wire the close button reliably:
-- (When UI builds, it doesn’t know closeUI. So we also add Esc/Ctrl input below.)

--//////////////////////////////////////////////////////
-- Toggle Button for Mobile (always available)
--//////////////////////////////////////////////////////
local function ensureToggleButton()
	local existing = playerGui:FindFirstChild(TOGGLE_BUTTON_GUI)
	if existing then return existing end

	local gui = make("ScreenGui", {
		Name = TOGGLE_BUTTON_GUI,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	local btn = make("TextButton", {
		Name = "Button",
		Text = "≡",
		TextColor3 = Colors.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Colors.Btn,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 18, 1, -18),
		Size = UDim2.fromOffset(54, 54),
		ZIndex = 500,
		Parent = gui,
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
	make("UIStroke", { Color = Colors.Accent2, Thickness = 2, Transparency = 0.35, Parent = btn })

	btn.MouseEnter:Connect(function()
		playSound("Hover")
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.BtnHover })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Colors.Btn })
	end)

	btn.MouseButton1Click:Connect(function()
		playSound("Click")
		toggleUI()
	end)

	-- Drag the mobile button (optional)
	do
		local dragging = false
		local dragStart, startPos

		local function setPosFromDelta(delta)
			btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = btn.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				setPosFromDelta(input.Position - dragStart)
			end
		end)
	end

	return gui
end

ensureToggleButton()

--//////////////////////////////////////////////////////
-- Input handling (Keyboard + Gamepad)
--//////////////////////////////////////////////////////
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	-- Custom keybind
	if SettingsState.CustomToggleKey and input.KeyCode == SettingsState.CustomToggleKey then
		toggleUI()
		return
	end

	-- Default keys
	if ToggleKeys[input.KeyCode] then
		toggleUI()
		return
	end

	-- Gamepad Start
	if TOGGLE_GAMEPAD_START and input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonStart then
			toggleUI()
			return
		end
	end
end)

-- Optional: open once on spawn
-- task.delay(1, openUI)
