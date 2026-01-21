-- main.lua (LocalScript)
-- Put in StarterPlayerScripts

--=====================================================
-- Services
--=====================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

--=====================================================
-- Config
--=====================================================
local UI_NAME = "SingularityMenu"
local TOGGLE_BUTTON_GUI = "SingularityMenu_ToggleButton"

-- Toggle keys (both Ctrl + Esc) + gamepad Start
local TOGGLE_KEYS = {
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.RightControl] = true,
	[Enum.KeyCode.Escape] = true,
}
local TOGGLE_GAMEPAD_START = true

-- Optional: add your own sound ids
local SOUND_IDS = {
	Open = "",
	Close = "",
	Click = "",
	Hover = "",
	Notify = "",
}

-- Black + Orange theme + animated accents
local Theme = {
	BaseBlack = Color3.fromRGB(12, 12, 14),
	PanelBlack = Color3.fromRGB(18, 18, 22),
	PanelBlack2 = Color3.fromRGB(24, 24, 30),

	Text = Color3.fromRGB(245, 245, 245),
	SubText = Color3.fromRGB(185, 185, 195),

	-- Orange accents
	Orange1 = Color3.fromRGB(255, 140, 26),
	Orange2 = Color3.fromRGB(255, 190, 90),

	Button = Color3.fromRGB(28, 28, 34),
	ButtonHover = Color3.fromRGB(38, 38, 46),

	Good = Color3.fromRGB(90, 220, 150),
	Warn = Color3.fromRGB(255, 200, 90),
	Bad  = Color3.fromRGB(255, 90, 90),
}

-- Player feature config defaults
local PlayerConfig = {
	WalkSpeed = 16,
	WalkSpeedMin = 16,
	WalkSpeedMax = 100,

	FlyEnabled = false,
	FlySpeed = 60,
	FlySpeedMin = 20,
	FlySpeedMax = 150,

	NoclipEnabled = false,
}

-- Additional pages you can customize
local TeleportTargets = {
	-- Put Parts in Workspace with these names (or change names here)
	{ name = "Spawn", partName = "SpawnLocation" },
	{ name = "Arena", partName = "ArenaSpawn" },
	{ name = "Shop", partName = "ShopSpawn" },
}

local DummyStats = {
	{ label = "Coins", value = "0" },
	{ label = "Wins", value = "0" },
	{ label = "Level", value = "1" },
}

--=====================================================
-- Utilities
--=====================================================
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

local function clamp(n, a, b)
	return math.clamp(n, a, b)
end

--=====================================================
-- Effects: Blur + Camera FOV punch
--=====================================================
local blur = Lighting:FindFirstChild("Singularity_Blur")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "Singularity_Blur"
	blur.Size = 0
	blur.Parent = Lighting
end

local originalFov = nil
local function ensureCamera()
	camera = workspace.CurrentCamera
end

local function fovPunchIn()
	ensureCamera()
	if not camera then return end
	originalFov = originalFov or camera.FieldOfView
	tween(camera, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = originalFov - 6 })
end

local function fovPunchOut()
	ensureCamera()
	if not camera then return end
	originalFov = originalFov or camera.FieldOfView
	tween(camera, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = originalFov })
end

--=====================================================
-- Sounds (optional)
--=====================================================
local SoundFolder = SoundService:FindFirstChild("Singularity_UI_Sounds")
if not SoundFolder then
	SoundFolder = Instance.new("Folder")
	SoundFolder.Name = "Singularity_UI_Sounds"
	SoundFolder.Parent = SoundService
end

local SettingsState = {
	SoundsEnabled = true,
	MasterVolume = 0.8,
	CustomToggleKey = nil, -- Enum.KeyCode or nil
}

local function getSound(name)
	local s = SoundFolder:FindFirstChild(name)
	if not s then
		s = Instance.new("Sound")
		s.Name = name
		s.Volume = SettingsState.MasterVolume
		s.SoundId = SOUND_IDS[name] or ""
		s.Parent = SoundFolder
	end
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

--=====================================================
-- Notifications (stack + queue)
--=====================================================
local Notif = { holder = nil, queue = {}, active = 0, maxActive = 3 }

local function notifAccent(kind)
	if kind == "good" then return Theme.Good end
	if kind == "warn" then return Theme.Warn end
	if kind == "bad" then return Theme.Bad end
	return Theme.Orange1
end

local function spawnNotification(kind, text)
	if not Notif.holder then return end
	Notif.active += 1

	playSound("Notify")

	local accent = notifAccent(kind)

	local card = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(320, 64),
		ZIndex = 500,
		Parent = Notif.holder,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = card })
	make("UIStroke", { Color = accent, Thickness = 2, Transparency = 0.25, Parent = card })

	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -18, 1, -18),
		Position = UDim2.fromOffset(9, 9),
		TextTransparency = 1,
		ZIndex = 501,
		Parent = card,
	})

	local scale = make("UIScale", { Scale = 0.75, Parent = card })

	tween(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.05 })
	tween(label, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
	tween(scale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })

	task.delay(2.8, function()
		if card and card.Parent then
			tween(scale, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 })
			tween(label, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
			local out = tween(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
			out.Completed:Wait()
			if card then card:Destroy() end
		end

		Notif.active -= 1
		if #Notif.queue > 0 and Notif.active < Notif.maxActive then
			local nextN = table.remove(Notif.queue, 1)
			spawnNotification(nextN.kind, nextN.text)
		end
	end)
end

local function notify(kind, text)
	if not Notif.holder then return end
	if Notif.active >= Notif.maxActive then
		table.insert(Notif.queue, { kind = kind, text = text })
	else
		spawnNotification(kind, text)
	end
end

--=====================================================
-- Modal confirm
--=====================================================
local function showConfirm(gui, titleText, bodyText, onYes, onNo)
	local layer = make("Frame", {
		Name = "ModalLayer",
		BackgroundColor3 = Theme.BaseBlack,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 800,
		Parent = gui,
	})

	local card = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(420, 220),
		BackgroundColor3 = Theme.PanelBlack,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 801,
		Parent = layer,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 16), Parent = card })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 2, Transparency = 0.25, Parent = card })

	local scale = make("UIScale", { Scale = 0.85, Parent = card })

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = titleText or "Confirm",
		TextColor3 = Theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -24, 0, 28),
		Position = UDim2.fromOffset(12, 12),
		ZIndex = 802,
		Parent = card,
	})

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = bodyText or "Are you sure?",
		TextColor3 = Theme.SubText,
		TextSize = 15,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, -24, 1, -90),
		Position = UDim2.fromOffset(12, 46),
		ZIndex = 802,
		Parent = card,
	})

	local btnRow = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -24, 0, 44),
		Position = UDim2.new(0, 12, 1, -56),
		ZIndex = 802,
		Parent = card,
	})

	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = btnRow,
	})

	local function mkBtn(text, strokeColor)
		local b = make("TextButton", {
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			BackgroundColor3 = Theme.Button,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(110, 40),
			ZIndex = 803,
			Parent = btnRow,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = b })
		make("UIStroke", { Color = strokeColor, Thickness = 1, Transparency = 0.4, Parent = b })

		b.MouseEnter:Connect(function()
			playSound("Hover")
			tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
		end)
		b.MouseLeave:Connect(function()
			tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
		end)

		return b
	end

	local cancel = mkBtn("Cancel", Theme.Warn)
	local ok = mkBtn("Confirm", Theme.Good)

	local function close()
		tween(scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 })
		tween(layer, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
		task.delay(0.19, function()
			if layer then layer:Destroy() end
		end)
	end

	cancel.MouseButton1Click:Connect(function()
		playSound("Click")
		close()
		if onNo then onNo() end
	end)

	ok.MouseButton1Click:Connect(function()
		playSound("Click")
		close()
		if onYes then onYes() end
	end)

	tween(layer, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 })
	tween(scale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
end

--=====================================================
-- Loading overlay + spinner
--=====================================================
local Spinner = { layer = nil, conn = nil, rot = 0 }

local function showLoading(gui, text)
	if Spinner.layer then Spinner.layer:Destroy() Spinner.layer = nil end
	safeDisconnect(Spinner.conn)
	Spinner.rot = 0

	local layer = make("Frame", {
		Name = "LoadingLayer",
		BackgroundColor3 = Theme.BaseBlack,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 900,
		Parent = gui,
	})
	Spinner.layer = layer

	local card = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(360, 140),
		BackgroundColor3 = Theme.PanelBlack,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 901,
		Parent = layer,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 16), Parent = card })
	make("UIStroke", { Color = Theme.Orange2, Thickness = 2, Transparency = 0.25, Parent = card })

	local spinner = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://3926305904",
		ImageRectOffset = Vector2.new(764, 764),
		ImageRectSize = Vector2.new(36, 36),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(40, 40),
		ZIndex = 902,
		Parent = card,
	})

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = text or "Loading...",
		TextColor3 = Theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 70, 0.5, 0),
		Size = UDim2.new(1, -86, 0, 30),
		ZIndex = 902,
		Parent = card,
	})

	tween(layer, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.55 })

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

--=====================================================
-- Player Features: Speed / Fly / Noclip (LOCAL)
-- Note: For real games, server should validate anything important.
--=====================================================
local Feature = {
	char = nil,
	hum = nil,
	root = nil,

	flyBV = nil,
	flyBG = nil,
	flyConn = nil,

	noclipConn = nil,
	flightInput = {
		W=false,A=false,S=false,D=false,Up=false,Down=false
	},
}

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function bindCharacter()
	Feature.char = getCharacter()
	Feature.hum = Feature.char:WaitForChild("Humanoid")
	Feature.root = Feature.char:WaitForChild("HumanoidRootPart")
end

local function applyWalkSpeed()
	if Feature.hum then
		Feature.hum.WalkSpeed = PlayerConfig.WalkSpeed
	end
end

-- Fly implementation (BodyVelocity + BodyGyro)
local function stopFly()
	PlayerConfig.FlyEnabled = false

	safeDisconnect(Feature.flyConn)
	Feature.flyConn = nil

	if Feature.flyBV then Feature.flyBV:Destroy() Feature.flyBV = nil end
	if Feature.flyBG then Feature.flyBG:Destroy() Feature.flyBG = nil end

	if Feature.hum then
		Feature.hum.PlatformStand = false
	end
end

local function startFly()
	if not Feature.root or not Feature.hum then return end
	PlayerConfig.FlyEnabled = true

	-- Prevent duplicate
	stopFly()
	PlayerConfig.FlyEnabled = true

	Feature.hum.PlatformStand = true

	Feature.flyBV = Instance.new("BodyVelocity")
	Feature.flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	Feature.flyBV.P = 1e4
	Feature.flyBV.Velocity = Vector3.zero
	Feature.flyBV.Parent = Feature.root

	Feature.flyBG = Instance.new("BodyGyro")
	Feature.flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	Feature.flyBG.P = 1e5
	Feature.flyBG.CFrame = Feature.root.CFrame
	Feature.flyBG.Parent = Feature.root

	Feature.flyConn = RunService.RenderStepped:Connect(function()
		if not PlayerConfig.FlyEnabled then return end
		if not Feature.root or not Feature.flyBV or not Feature.flyBG then return end
		if not camera then camera = workspace.CurrentCamera end
		if not camera then return end

		local move = Vector3.zero
		local camCF = camera.CFrame

		local forward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
		if forward.Magnitude > 0 then forward = forward.Unit end

		local right = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
		if right.Magnitude > 0 then right = right.Unit end

		if Feature.flightInput.W then move += forward end
		if Feature.flightInput.S then move -= forward end
		if Feature.flightInput.D then move += right end
		if Feature.flightInput.A then move -= right end
		if Feature.flightInput.Up then move += Vector3.new(0, 1, 0) end
		if Feature.flightInput.Down then move -= Vector3.new(0, 1, 0) end

		if move.Magnitude > 0 then
			move = move.Unit * PlayerConfig.FlySpeed
		end

		Feature.flyBV.Velocity = move
		Feature.flyBG.CFrame = camCF
	end)
end

-- Noclip (sets CanCollide false continuously)
local function stopNoclip()
	PlayerConfig.NoclipEnabled = false
	safeDisconnect(Feature.noclipConn)
	Feature.noclipConn = nil

	-- Restore collisions (best effort)
	if Feature.char then
		for _, d in ipairs(Feature.char:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = true
			end
		end
	end
end

local function startNoclip()
	PlayerConfig.NoclipEnabled = true

	safeDisconnect(Feature.noclipConn)
	Feature.noclipConn = RunService.Stepped:Connect(function()
		if not PlayerConfig.NoclipEnabled then return end
		local c = Feature.char
		if not c then return end
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = false
			end
		end
	end)
end

local function toggleFly(on)
	if on then
		startFly()
		notify("good", "Fly enabled")
	else
		stopFly()
		notify("warn", "Fly disabled")
	end
end

local function toggleNoclip(on)
	if on then
		startNoclip()
		notify("good", "Noclip enabled")
	else
		stopNoclip()
		notify("warn", "Noclip disabled")
	end
end

-- Flight key tracking (WASD + Space + Shift)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then Feature.flightInput.W = true end
	if input.KeyCode == Enum.KeyCode.A then Feature.flightInput.A = true end
	if input.KeyCode == Enum.KeyCode.S then Feature.flightInput.S = true end
	if input.KeyCode == Enum.KeyCode.D then Feature.flightInput.D = true end
	if input.KeyCode == Enum.KeyCode.Space then Feature.flightInput.Up = true end
	if input.KeyCode == Enum.KeyCode.LeftShift then Feature.flightInput.Down = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then Feature.flightInput.W = false end
	if input.KeyCode == Enum.KeyCode.A then Feature.flightInput.A = false end
	if input.KeyCode == Enum.KeyCode.S then Feature.flightInput.S = false end
	if input.KeyCode == Enum.KeyCode.D then Feature.flightInput.D = false end
	if input.KeyCode == Enum.KeyCode.Space then Feature.flightInput.Up = false end
	if input.KeyCode == Enum.KeyCode.LeftShift then Feature.flightInput.Down = false end
end)

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	bindCharacter()
	applyWalkSpeed()
	if PlayerConfig.FlyEnabled then toggleFly(true) end
	if PlayerConfig.NoclipEnabled then toggleNoclip(true) end
end)

-- Initial bind
task.defer(function()
	bindCharacter()
	applyWalkSpeed()
end)

--=====================================================
-- UI: Build helpers (sliders/toggles)
--=====================================================
local function mkButton(parent, text, strokeColor)
	local b = make("TextButton", {
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		BackgroundColor3 = Theme.Button,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 42),
		Parent = parent,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = b })
	local st = make("UIStroke", { Color = strokeColor or Theme.Orange1, Thickness = 1, Transparency = 0.65, Parent = b })

	b.MouseEnter:Connect(function()
		playSound("Hover")
		tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
		tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.35 })
	end)
	b.MouseLeave:Connect(function()
		tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
		tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
	end)

	return b
end

local function mkToggleRow(parent, labelText, getValue, setValue)
	local row = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 54),
		Parent = parent,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.8, Parent = row })

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = labelText,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -160, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		Parent = row,
	})

	local btn = make("TextButton", {
		Text = "",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Theme.Button,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(120, 38),
		Parent = row,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = btn })
	local st = make("UIStroke", { Color = Theme.Warn, Thickness = 1, Transparency = 0.4, Parent = btn })

	local function refresh()
		local v = getValue()
		btn.Text = v and "ON" or "OFF"
		st.Color = v and Theme.Good or Theme.Warn
	end
	refresh()

	btn.MouseEnter:Connect(function()
		playSound("Hover")
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
	end)

	btn.MouseButton1Click:Connect(function()
		playSound("Click")
		setValue(not getValue())
		refresh()
	end)

	return row, refresh
end

local function mkSliderRow(parent, labelText, minV, maxV, getValue, setValue, suffix)
	suffix = suffix or ""
	local row = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 66),
		Parent = parent,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.8, Parent = row })

	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = labelText,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -24, 0, 24),
		Position = UDim2.fromOffset(12, 8),
		Parent = row,
	})

	local valueLabel = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.SubText,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(1, -24, 0, 20),
		Position = UDim2.fromOffset(12, 8),
		Parent = row,
	})

	local sliderBack = make("Frame", {
		BackgroundColor3 = Theme.Button,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(12, 42),
		Size = UDim2.new(1, -24, 0, 10),
		Parent = row,
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sliderBack })

	local fill = make("Frame", {
		BackgroundColor3 = Theme.Orange2,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = sliderBack,
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

	local knob = make("Frame", {
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		Parent = sliderBack,
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.4, Parent = knob })

	local dragging = false

	local function refresh()
		local v = clamp(getValue(), minV, maxV)
		local a = (v - minV) / (maxV - minV)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		valueLabel.Text = tostring(math.floor(v + 0.5)) .. suffix
	end

	local function setFromX(x)
		local abs = sliderBack.AbsolutePosition.X
		local w = sliderBack.AbsoluteSize.X
		local a = clamp((x - abs) / w, 0, 1)
		local v = minV + a * (maxV - minV)
		setValue(v)
		refresh()
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

	refresh()
	return row, refresh
end

--=====================================================
-- UI Build (Tabs + Pages + Animated Orange Accents)
--=====================================================
local uiConns = {}
local animConn = nil
local shimmerConn = nil

local function addConn(c)
	table.insert(uiConns, c)
end

local function cleanupConnections()
	for _, c in ipairs(uiConns) do
		safeDisconnect(c)
	end
	uiConns = {}
	safeDisconnect(animConn); animConn = nil
	safeDisconnect(shimmerConn); shimmerConn = nil
end

local function destroyUI()
	local g = getGui()
	if g then g:Destroy() end
	Notif.holder = nil
	Notif.queue = {}
	Notif.active = 0
	hideLoading()
	cleanupConnections()
end

local toggleUI -- forward declare

local function buildUI()
	destroyUI()

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
		BackgroundColor3 = Theme.BaseBlack,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = gui,
	})

	local bgGrad = make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.BaseBlack),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}),
		Parent = backdrop,
	})

	-- Vignette overlay (orange-themed)
	local vignette = make("ImageLabel", {
		Name = "Vignette",
		BackgroundTransparency = 1,
		Image = "rbxassetid://4576475446",
		ImageTransparency = 0.35,
		ImageColor3 = Theme.Orange1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1,
		Parent = gui,
	})

	-- Notifications holder (top-right)
	local notifHolder = make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(320, 400),
		ZIndex = 600,
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

	-- Shadow
	local shadow = make("ImageLabel", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.fromOffset(700, 440),
		ZIndex = 10,
		Parent = backdrop,
	})

	-- Panel
	local panel = make("Frame", {
		Name = "Panel",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(-0.35, 0, 0.5, 0), -- start offscreen left
		Size = UDim2.fromOffset(680, 400),
		BackgroundColor3 = Theme.PanelBlack,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = backdrop,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = panel })

	local panelScale = make("UIScale", { Scale = 0.9, Parent = panel })

	-- Outline stroke with orange animated gradient
	local stroke = make("UIStroke", {
		Color = Theme.Orange1,
		Thickness = 2,
		Transparency = 0.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = panel,
	})
	local strokeGrad = make("UIGradient", {
		Rotation = 0,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Orange1),
			ColorSequenceKeypoint.new(0.5, Theme.Orange2),
			ColorSequenceKeypoint.new(1, Theme.Orange1),
		}),
		Parent = stroke,
	})

	-- Top bar (drag)
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
		TextColor3 = Theme.Text,
		TextSize = 26,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -160, 0, 40),
		Position = UDim2.fromOffset(16, 14),
		ZIndex = 13,
		Parent = panel,
	})

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Black + Orange • Animated accents • Ctrl/Esc/Start toggles",
		TextColor3 = Theme.SubText,
		TextSize = 14,
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
		TextColor3 = Theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Theme.Button,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.fromOffset(40, 40),
		ZIndex = 14,
		Parent = panel,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = closeBtn })
	make("UIStroke", { Color = Theme.Orange2, Thickness = 1, Transparency = 0.45, Parent = closeBtn })

	addConn(closeBtn.MouseEnter:Connect(function()
		playSound("Hover")
		tween(closeBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
	end))
	addConn(closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
	end))
	addConn(closeBtn.MouseButton1Click:Connect(function()
		playSound("Click")
		if toggleUI then toggleUI() end
	end))

	-- Body
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
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 185, 1, 0),
		Parent = body,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = sidebar })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.85, Parent = sidebar })

	local pagesWrap = make("Frame", {
		Name = "PagesWrap",
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, -197, 1, 0),
		Parent = body,
	})
	make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = pagesWrap })
	make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.85, Parent = pagesWrap })

	make("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		Parent = sidebar,
	})

	local sideLayout = make("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = sidebar,
	})

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

	local function mkPage(name, order)
		local p = make("Frame", {
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
			Parent = p,
		})
		return p
	end

	local function pageHeader(p, header, desc)
		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = header,
			TextColor3 = Theme.Text,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 28),
			Parent = p,
		})
		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = desc,
			TextColor3 = Theme.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.fromOffset(0, 30),
			Parent = p,
		})
	end

	-- Pages (more pages added)
	local pageHome = mkPage("Home", 1)
	local pagePlayer = mkPage("Player", 2)
	local pageTeleport = mkPage("Teleport", 3)
	local pageShop = mkPage("Shop", 4)
	local pageInventory = mkPage("Inventory", 5)
	local pageStats = mkPage("Stats", 6)
	local pageSettings = mkPage("Settings", 7)

	-- Sidebar tab buttons
	local selected = nil
	local tabButtons = {}

	local function mkSideButton(text, icon, tabName)
		local b = make("TextButton", {
			Text = "",
			BackgroundColor3 = Theme.Button,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -24, 0, 42),
			Parent = sidebar,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = b })
		local st = make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.65, Parent = b })

		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = (icon and (icon .. " ") or "") .. text,
			TextColor3 = Theme.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.fromOffset(12, 0),
			Parent = b,
		})

		addConn(b.MouseEnter:Connect(function()
			playSound("Hover")
			if selected ~= tabName then
				tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
				tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.35 })
			end
		end))
		addConn(b.MouseLeave:Connect(function()
			if selected ~= tabName then
				tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
				tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
			end
		end))

		tabButtons[tabName] = { b = b, st = st }
		return b
	end

	local function setSelected(tabName)
		selected = tabName
		for name, t in pairs(tabButtons) do
			if name == tabName then
				tween(t.b, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
				tween(t.st, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.15 })
			else
				tween(t.b, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
				tween(t.st, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
			end
		end
	end

	local function jumpTo(name)
		playSound("Click")
		if name == "Home" then pageLayout:JumpTo(pageHome) end
		if name == "Player" then pageLayout:JumpTo(pagePlayer) end
		if name == "Teleport" then pageLayout:JumpTo(pageTeleport) end
		if name == "Shop" then pageLayout:JumpTo(pageShop) end
		if name == "Inventory" then pageLayout:JumpTo(pageInventory) end
		if name == "Stats" then pageLayout:JumpTo(pageStats) end
		if name == "Settings" then pageLayout:JumpTo(pageSettings) end
		setSelected(name)
	end

	local tabs = {
		{ "Home", "🏠" },
		{ "Player", "🧍" },
		{ "Teleport", "🗺️" },
		{ "Shop", "🛒" },
		{ "Inventory", "🎒" },
		{ "Stats", "📈" },
		{ "Settings", "⚙️" },
	}

	for _, t in ipairs(tabs) do
		local name, icon = t[1], t[2]
		local btn = mkSideButton(name, icon, name)
		addConn(btn.MouseButton1Click:Connect(function()
			jumpTo(name)
		end))
	end

	-- HOME
	pageHeader(pageHome, "Home", "Welcome. Black + Orange theme with animated accents.")
	do
		local box = make("Frame", {
			BackgroundColor3 = Theme.PanelBlack2,
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageHome,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = box })
		make("UIStroke", { Color = Theme.Orange2, Thickness = 1, Transparency = 0.75, Parent = box })

		make("TextLabel", {
			BackgroundTransparency = 1,
			TextColor3 = Theme.Text,
			TextSize = 15,
			Font = Enum.Font.Gotham,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Text = table.concat({
				"Added pages:",
				"• Player: speed slider, fly, fly speed, noclip",
				"• Teleport: quick teleport buttons",
				"• Stats: placeholders you can wire to leaderstats",
				"",
				"Fly controls:",
				"• WASD to move, Space up, Shift down",
				"",
				"Note:",
				"These player features are client-side (local).",
				"For real gameplay you should validate/replicate from the server."
			}, "\n"),
			Size = UDim2.new(1, -20, 1, -20),
			Position = UDim2.fromOffset(10, 10),
			Parent = box,
		})
	end

	-- PLAYER PAGE (speed, fly, fly speed, noclip)
	pageHeader(pagePlayer, "Player", "Speed boost slider, Fly + Fly Speed, Noclip.")
	do
		local wrap = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pagePlayer,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = wrap,
		})

		-- WalkSpeed slider
		local _, refreshSpeed = mkSliderRow(
			wrap,
			"Speed Boost (WalkSpeed)",
			PlayerConfig.WalkSpeedMin,
			PlayerConfig.WalkSpeedMax,
			function() return PlayerConfig.WalkSpeed end,
			function(v)
				PlayerConfig.WalkSpeed = math.floor(v + 0.5)
				applyWalkSpeed()
			end,
			""
		)

		-- Fly toggle
		local _, refreshFly = mkToggleRow(
			wrap,
			"Fly",
			function() return PlayerConfig.FlyEnabled end,
			function(v)
				PlayerConfig.FlyEnabled = v
				if v then
					toggleFly(true)
				else
					toggleFly(false)
				end
			end
		)

		-- Fly speed slider
		local _, refreshFlySpeed = mkSliderRow(
			wrap,
			"Fly Speed",
			PlayerConfig.FlySpeedMin,
			PlayerConfig.FlySpeedMax,
			function() return PlayerConfig.FlySpeed end,
			function(v)
				PlayerConfig.FlySpeed = math.floor(v + 0.5)
			end,
			""
		)

		-- Noclip toggle
		local _, refreshNoclip = mkToggleRow(
			wrap,
			"Noclip",
			function() return PlayerConfig.NoclipEnabled end,
			function(v)
				PlayerConfig.NoclipEnabled = v
				if v then
					toggleNoclip(true)
				else
					toggleNoclip(false)
				end
			end
		)

		-- Quick buttons
		local buttons = make("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 96),
			Parent = wrap,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = buttons,
		})

		local resetBtn = mkButton(buttons, "Reset Player Settings", Theme.Warn)
		addConn(resetBtn.MouseButton1Click:Connect(function()
			playSound("Click")
			showConfirm(gui, "Reset Player Settings", "Reset speed/fly/noclip to defaults?",
				function()
					PlayerConfig.WalkSpeed = 16
					PlayerConfig.FlySpeed = 60
					if PlayerConfig.FlyEnabled then toggleFly(false) end
					if PlayerConfig.NoclipEnabled then toggleNoclip(false) end
					PlayerConfig.FlyEnabled = false
					PlayerConfig.NoclipEnabled = false
					applyWalkSpeed()
					refreshSpeed()
					refreshFly()
					refreshFlySpeed()
					refreshNoclip()
					notify("good", "Player settings reset.")
				end,
				function()
					notify("warn", "Reset cancelled.")
				end
			)
		end))

		local respawnBtn = mkButton(buttons, "Respawn Character", Theme.Orange1)
		addConn(respawnBtn.MouseButton1Click:Connect(function()
			playSound("Click")
			local c = player.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if h then
				h.Health = 0
				notify("warn", "Respawning...")
			end
		end))
	end

	-- TELEPORT PAGE
	pageHeader(pageTeleport, "Teleport", "Teleports to named Parts in Workspace.")
	do
		local wrap = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageTeleport,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = wrap,
		})

		for _, t in ipairs(TeleportTargets) do
			local btn = mkButton(wrap, ("Teleport: %s"):format(t.name), Theme.Orange2)
			addConn(btn.MouseButton1Click:Connect(function()
				playSound("Click")
				local target = workspace:FindFirstChild(t.partName, true)
				if not target or not target:IsA("BasePart") then
					notify("bad", ("Missing Part: %s"):format(t.partName))
					return
				end

				bindCharacter()
				if Feature.root then
					showLoading(gui, "Teleporting...")
					task.delay(0.35, function()
						hideLoading()
						Feature.root.CFrame = target.CFrame + Vector3.new(0, 4, 0)
						notify("good", ("Teleported to %s"):format(t.name))
					end)
				end
			end))
		end

		local tip = make("TextLabel", {
			BackgroundTransparency = 1,
			TextColor3 = Theme.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Text = "Tip: Create Parts in Workspace named SpawnLocation / ArenaSpawn / ShopSpawn (or edit TeleportTargets in the script).",
			Size = UDim2.new(1, 0, 0, 60),
			Parent = wrap,
		})
	end

	-- SHOP (demo)
	pageHeader(pageShop, "Shop", "Demo purchases with confirm + loading.")
	do
		local wrap = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageShop,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = wrap,
		})

		local items = {
			{ name = "Sword", price = 100 },
			{ name = "Speed Boost", price = 150 },
			{ name = "VIP", price = 999 },
		}

		for _, it in ipairs(items) do
			local row = make("Frame", {
				BackgroundColor3 = Theme.PanelBlack2,
				BackgroundTransparency = 0.15,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 56),
				Parent = wrap,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
			make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.8, Parent = row })

			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = ("%s  •  $%d"):format(it.name, it.price),
				TextColor3 = Theme.Text,
				TextSize = 16,
				Font = Enum.Font.GothamSemibold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -140, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})

			local buy = make("TextButton", {
				Text = "Buy",
				TextColor3 = Theme.Text,
				TextSize = 15,
				Font = Enum.Font.GothamSemibold,
				BackgroundColor3 = Theme.Button,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(110, 38),
				Parent = row,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = buy })
			make("UIStroke", { Color = Theme.Good, Thickness = 1, Transparency = 0.5, Parent = buy })

			addConn(buy.MouseEnter:Connect(function()
				playSound("Hover")
				tween(buy, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
			end))
			addConn(buy.MouseLeave:Connect(function()
				tween(buy, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
			end))

			addConn(buy.MouseButton1Click:Connect(function()
				playSound("Click")
				showConfirm(gui, "Buy Item", ("Buy %s for $%d?"):format(it.name, it.price),
					function()
						showLoading(gui, "Processing purchase...")
						task.delay(1.0, function()
							hideLoading()
							notify("good", ("Purchased: %s"):format(it.name))
						end)
					end,
					function()
						notify("warn", "Purchase cancelled.")
					end
				)
			end))
		end
	end

	-- INVENTORY (demo)
	pageHeader(pageInventory, "Inventory", "Example list. Replace with your real items.")
	do
		local box = make("Frame", {
			BackgroundColor3 = Theme.PanelBlack2,
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageInventory,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = box })
		make("UIStroke", { Color = Theme.Orange2, Thickness = 1, Transparency = 0.75, Parent = box })

		local list = make("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -20, 1, -20),
			Position = UDim2.fromOffset(10, 10),
			Parent = box,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = list,
		})

		local inv = { "Wooden Sword", "Potion x3", "Key: Ancient Door" }
		for _, name in ipairs(inv) do
			local row = make("Frame", {
				BackgroundColor3 = Theme.PanelBlack,
				BackgroundTransparency = 0.15,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 40),
				Parent = list,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = row })
			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = "• " .. name,
				TextColor3 = Theme.Text,
				TextSize = 15,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})
		end
	end

	-- STATS (demo)
	pageHeader(pageStats, "Stats", "Placeholders (wire to leaderstats if you want).")
	do
		local wrap = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageStats,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = wrap,
		})

		for _, s in ipairs(DummyStats) do
			local row = make("Frame", {
				BackgroundColor3 = Theme.PanelBlack2,
				BackgroundTransparency = 0.15,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 54),
				Parent = wrap,
			})
			make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
			make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.8, Parent = row })

			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = s.label,
				TextColor3 = Theme.Text,
				TextSize = 15,
				Font = Enum.Font.GothamSemibold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -24, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})
			make("TextLabel", {
				BackgroundTransparency = 1,
				Text = s.value,
				TextColor3 = Theme.SubText,
				TextSize = 15,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Right,
				Size = UDim2.new(1, -24, 1, 0),
				Position = UDim2.fromOffset(12, 0),
				Parent = row,
			})
		end
	end

	-- SETTINGS (UI-only settings)
	pageHeader(pageSettings, "Settings", "UI behavior settings (local).")
	do
		local wrap = make("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 70),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = pageSettings,
		})
		make("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = wrap,
		})

		-- Sounds toggle
		mkToggleRow(
			wrap,
			"Sounds",
			function() return SettingsState.SoundsEnabled end,
			function(v)
				SettingsState.SoundsEnabled = v
				notify("good", v and "Sounds enabled" or "Sounds disabled")
			end
		)

		-- Volume slider
		mkSliderRow(
			wrap,
			"UI Volume",
			0, 1,
			function() return SettingsState.MasterVolume end,
			function(v)
				SettingsState.MasterVolume = v
				for _, s in ipairs(SoundFolder:GetChildren()) do
					if s:IsA("Sound") then s.Volume = SettingsState.MasterVolume end
				end
			end,
			""
		)

		-- Keybind setter
		local row = make("Frame", {
			BackgroundColor3 = Theme.PanelBlack2,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 54),
			Parent = wrap,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = row })
		make("UIStroke", { Color = Theme.Orange1, Thickness = 1, Transparency = 0.8, Parent = row })

		make("TextLabel", {
			BackgroundTransparency = 1,
			Text = "Toggle Keybind",
			TextColor3 = Theme.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -160, 1, 0),
			Position = UDim2.fromOffset(12, 0),
			Parent = row,
		})

		local info = make("TextLabel", {
			BackgroundTransparency = 1,
			Text = "Current: Ctrl/Esc/Start",
			TextColor3 = Theme.SubText,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -132, 0, 16),
			Size = UDim2.fromOffset(260, 20),
			Parent = row,
		})

		local btn = make("TextButton", {
			Text = "Set Key",
			TextColor3 = Theme.Text,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			BackgroundColor3 = Theme.Button,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.fromOffset(110, 38),
			Parent = row,
		})
		make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = btn })
		make("UIStroke", { Color = Theme.Orange2, Thickness = 1, Transparency = 0.5, Parent = btn })

		local waiting = false
		local bindConn = nil
		local function refreshKeyText()
			if SettingsState.CustomToggleKey then
				info.Text = "Current: " .. SettingsState.CustomToggleKey.Name .. " + Ctrl/Esc/Start"
			else
				info.Text = "Current: Ctrl/Esc/Start"
			end
		end
		refreshKeyText()

		addConn(btn.MouseEnter:Connect(function()
			playSound("Hover")
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
		end))
		addConn(btn.MouseLeave:Connect(function()
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
		end))

		addConn(btn.MouseButton1Click:Connect(function()
			playSound("Click")
			if waiting then return end
			waiting = true
			btn.Text = "Press key..."
			notify("warn", "Press any key to set custom toggle (Esc cancels).")

			safeDisconnect(bindConn)
			bindConn = UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if input.KeyCode == Enum.KeyCode.Escape then
					waiting = false
					btn.Text = "Set Key"
					notify("warn", "Keybind cancelled.")
					safeDisconnect(bindConn)
					return
				end

				SettingsState.CustomToggleKey = input.KeyCode
				waiting = false
				btn.Text = "Set Key"
				refreshKeyText()
				notify("good", "Toggle key set: " .. input.KeyCode.Name)
				safeDisconnect(bindConn)
			end)
		end))
	end

	-- Default tab
	task.defer(function()
		jumpTo("Home")
	end)

	--=====================================================
	-- Animated orange accents (shimmer + pulse + gradient drift)
	--=====================================================
	local t = 0
	animConn = RunService.RenderStepped:Connect(function(dt)
		t += dt

		-- Pulse stroke thickness/transparency a bit
		local pulse = 0.5 + 0.5 * math.sin(t * 2.2)
		stroke.Transparency = 0.15 + 0.15 * (1 - pulse)

		-- Drift background gradient a tiny bit (subtle)
		bgGrad.Rotation = 90 + 6 * math.sin(t * 0.6)
		vignette.ImageColor3 = Theme.Orange1:Lerp(Theme.Orange2, 0.35 + 0.35 * math.sin(t * 0.9))
	end)

	shimmerConn = RunService.RenderStepped:Connect(function(dt)
		strokeGrad.Rotation = (strokeGrad.Rotation + dt * 70) % 360
	end)

	--=====================================================
	-- Drag panel
	--=====================================================
	do
		local dragging = false
		local dragStart, startPos

		local function update(input)
			if not dragging then return end
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			shadow.Position = panel.Position
		end

		addConn(topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = panel.Position

				local ch
				ch = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						safeDisconnect(ch)
					end
				end)
			end
		end))

		addConn(topBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				update(input)
			end
		end))

		addConn(UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				update(input)
			end
		end))
	end

	return gui, backdrop, panel, shadow, panelScale
end

--=====================================================
-- Open / Close / Toggle
--=====================================================
local opening = false
local closing = false

local function openUI()
	if opening or closing then return end
	if isOpen() then return end
	opening = true

	local gui, backdrop, panel, shadow, scale = buildUI()

	-- Effects in
	tween(blur, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 14 })
	tween(backdrop, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 })

	fovPunchIn()

	-- Panel slide + bounce
	tween(scale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	tween(panel, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })
	tween(shadow, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })

	playSound("Open")
	notify("good", "Menu opened")

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
	tween(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 0 })
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

		local out = tween(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1.25, 0, cur.Y.Scale, cur.Y.Offset)
		})
		out.Completed:Wait()
	end

	playSound("Close")
	destroyUI()
	closing = false
end

toggleUI = function()
	if isOpen() then
		closeUI()
	else
		openUI()
	end
end

--=====================================================
-- Mobile toggle button (always available)
--=====================================================
local function ensureToggleButton()
	local existing = playerGui:FindFirstChild(TOGGLE_BUTTON_GUI)
	if existing then return end

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
		TextColor3 = Theme.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Theme.Button,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 18, 1, -18),
		Size = UDim2.fromOffset(54, 54),
		ZIndex = 1000,
		Parent = gui,
	})
	make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
	make("UIStroke", { Color = Theme.Orange2, Thickness = 2, Transparency = 0.35, Parent = btn })

	btn.MouseEnter:Connect(function()
		playSound("Hover")
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.ButtonHover })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Button })
	end)

	btn.MouseButton1Click:Connect(function()
		playSound("Click")
		toggleUI()
	end)

	-- Drag mobile button
	do
		local dragging = false
		local dragStart, startPos

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
				local delta = input.Position - dragStart
				btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end
end

ensureToggleButton()

--=====================================================
-- Input handling (Keyboard + Gamepad)
--=====================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if SettingsState.CustomToggleKey and input.KeyCode == SettingsState.CustomToggleKey then
		toggleUI()
		return
	end

	if TOGGLE_KEYS[input.KeyCode] then
		toggleUI()
		return
	end

	if TOGGLE_GAMEPAD_START and input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonStart then
			toggleUI()
			return
		end
	end
end)

-- Optional auto-open
-- task.delay(1, openUI)
