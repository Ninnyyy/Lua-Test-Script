-- main.lua (LocalScript) - StarterPlayerScripts
-- Updated: solid background, limited tabs, keybinds, ESP customization

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local SoundService      = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--=====================================================
-- Config
--=====================================================
local UI_NAME = "SingularityMenu"
local TOGGLE_BUTTON_GUI = "SingularityMenu_ToggleButton"

local TOGGLE_KEYS = {
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.RightControl] = true,
	[Enum.KeyCode.Escape] = true,
}
local TOGGLE_GAMEPAD_START = true

-- Sounds (optional - add SoundIds if desired)
local SOUND_IDS = {
	Open = "", Close = "", Click = "", Hover = "", Notify = "",
}

local Theme = {
	BaseBlack    = Color3.fromRGB(12, 12, 14),
	PanelBlack   = Color3.fromRGB(18, 18, 22),
	PanelBlack2  = Color3.fromRGB(24, 24, 30),
	Text         = Color3.fromRGB(245, 245, 245),
	SubText      = Color3.fromRGB(185, 185, 195),
	Orange1      = Color3.fromRGB(255, 140, 26),
	Orange2      = Color3.fromRGB(255, 190, 90),
	Button       = Color3.fromRGB(28, 28, 34),
	ButtonHover  = Color3.fromRGB(38, 38, 46),
	Good         = Color3.fromRGB(90, 220, 150),
	Warn         = Color3.fromRGB(255, 200, 90),
	Bad          = Color3.fromRGB(255, 90, 90),
}

-- Player features
local PlayerConfig = {
	WalkSpeed      = 16,
	WalkSpeedMin   = 16,
	WalkSpeedMax   = 100,
	FlyEnabled     = false,
	FlySpeed       = 60,
	FlySpeedMin    = 20,
	FlySpeedMax    = 150,
	NoclipEnabled  = false,
}

-- ESP features
local ESPConfig = {
	Enabled    = false,
	Color      = Color3.fromRGB(255, 80, 60),
	ShowBox    = true,
	ShowTracer = true,
	ShowName   = true,
	ShowHealth = false,
	Aura       = false,
}

-- Keybinds (per feature toggle)
local Keybinds = {
	Fly    = nil,
	Noclip = nil,
	ESP    = nil,
	-- Aimbot = nil,  -- placeholder
}

-- UI settings
local SettingsState = {
	SoundsEnabled  = true,
	MasterVolume   = 0.8,
}

--=====================================================
-- Utilities
--=====================================================
local function make(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then inst[k] = v end
	end
	if props and props.Parent then inst.Parent = props.Parent end
	return inst
end

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function getGui() return playerGui:FindFirstChild(UI_NAME) end
local function isOpen() return getGui() ~= nil end

local function safeDisconnect(c) if c then c:Disconnect() end end

local function clamp(v, min, max) return math.clamp(v, min, max) end

--=====================================================
-- Sounds
--=====================================================
local SoundFolder = SoundService:FindFirstChild("Singularity_UI_Sounds") or make("Folder", {
	Name = "Singularity_UI_Sounds", Parent = SoundService
})

local function getSound(name)
	local s = SoundFolder:FindFirstChild(name)
	if not s then
		s = make("Sound", {Name = name, Volume = SettingsState.MasterVolume, SoundId = SOUND_IDS[name] or "", Parent = SoundFolder})
	end
	s.Volume = SettingsState.MasterVolume
	s.SoundId = SOUND_IDS[name] or s.SoundId
	return s
end

local function playSound(name)
	if not SettingsState.SoundsEnabled then return end
	local id = SOUND_IDS[name]
	if id and id ~= "" then getSound(name):Play() end
end

--=====================================================
-- Notifications
--=====================================================
local Notif = {holder = nil, queue = {}, active = 0, maxActive = 4}

local function notifAccent(kind)
	if kind == "good" then return Theme.Good end
	if kind == "warn" then return Theme.Warn end
	if kind == "bad"  then return Theme.Bad  end
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
		Size = UDim2.fromOffset(300, 60),
		ZIndex = 500, Parent = Notif.holder
	})
	make("UICorner", {CornerRadius = UDim.new(0,12), Parent = card})
	make("UIStroke", {Color = accent, Thickness = 1.5, Transparency = 0.3, Parent = card})

	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-16,1,-16),
		Position = UDim2.fromOffset(8,8),
		TextTransparency = 1,
		ZIndex = 501, Parent = card
	})

	local scale = make("UIScale", {Scale = 0.8, Parent = card})

	tween(card, TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
	tween(label, TweenInfo.new(0.25), {TextTransparency = 0})
	tween(scale, TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Scale = 1})

	task.delay(3.2, function()
		if not card.Parent then return end
		tween(scale, TweenInfo.new(0.2), {Scale = 0.85})
		tween(label, TweenInfo.new(0.18), {TextTransparency = 1})
		local fade = tween(card, TweenInfo.new(0.18), {BackgroundTransparency = 1})
		fade.Completed:Connect(function() card:Destroy() end)
		Notif.active -= 1
		if #Notif.queue > 0 and Notif.active < Notif.maxActive then
			local next = table.remove(Notif.queue,1)
			spawnNotification(next.kind, next.text)
		end
	end)
end

local function notify(kind, text)
	if Notif.active >= Notif.maxActive then
		table.insert(Notif.queue, {kind=kind, text=text})
	else
		spawnNotification(kind, text)
	end
end

--=====================================================
-- Player Features (local only)
--=====================================================
local Feature = {
	char = nil, hum = nil, root = nil,
	flyBV = nil, flyBG = nil, flyConn = nil,
	noclipConn = nil,
	flightInput = {W=false,A=false,S=false,D=false,Up=false,Down=false},
}

local function bindCharacter()
	Feature.char = player.Character or player.CharacterAdded:Wait()
	Feature.hum = Feature.char:WaitForChild("Humanoid")
	Feature.root = Feature.char:WaitForChild("HumanoidRootPart")
end

local function applyWalkSpeed()
	if Feature.hum then Feature.hum.WalkSpeed = PlayerConfig.WalkSpeed end
end

local function stopFly()
	PlayerConfig.FlyEnabled = false
	safeDisconnect(Feature.flyConn)
	if Feature.flyBV then Feature.flyBV:Destroy() Feature.flyBV = nil end
	if Feature.flyBG then Feature.flyBG:Destroy() Feature.flyBG = nil end
	if Feature.hum then Feature.hum.PlatformStand = false end
end

local function startFly()
	if not Feature.root or not Feature.hum then return end
	stopFly()
	PlayerConfig.FlyEnabled = true
	Feature.hum.PlatformStand = true

	Feature.flyBV = make("BodyVelocity", {MaxForce = Vector3.new(1e9,1e9,1e9), P = 1e4, Velocity = Vector3.zero, Parent = Feature.root})
	Feature.flyBG = make("BodyGyro",     {MaxTorque = Vector3.new(1e9,1e9,1e9), P = 1e5, CFrame = Feature.root.CFrame, Parent = Feature.root})

	Feature.flyConn = RunService.RenderStepped:Connect(function()
		if not PlayerConfig.FlyEnabled then return end
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		local lv = cam.CFrame.LookVector
		local rv = cam.CFrame.RightVector
		local forward = Vector3.new(lv.X, 0, lv.Z).Unit
		local right   = Vector3.new(rv.X, 0, rv.Z).Unit

		if Feature.flightInput.W    then move += forward end
		if Feature.flightInput.S    then move -= forward end
		if Feature.flightInput.D    then move += right   end
		if Feature.flightInput.A    then move -= right   end
		if Feature.flightInput.Up   then move += Vector3.yAxis end
		if Feature.flightInput.Down then move -= Vector3.yAxis end

		Feature.flyBV.Velocity = move.Unit * PlayerConfig.FlySpeed * (move.Magnitude > 0 and 1 or 0)
		Feature.flyBG.CFrame = cam.CFrame
	end)
end

local function toggleFly(v)
	PlayerConfig.FlyEnabled = v
	if v then startFly() else stopFly() end
	notify(v and "good" or "warn", "Fly " .. (v and "enabled" or "disabled"))
end

local function stopNoclip()
	PlayerConfig.NoclipEnabled = false
	safeDisconnect(Feature.noclipConn)
	if Feature.char then
		for _, p in Feature.char:GetDescendants() do
			if p:IsA("BasePart") then p.CanCollide = true end
		end
	end
end

local function startNoclip()
	PlayerConfig.NoclipEnabled = true
	safeDisconnect(Feature.noclipConn)
	Feature.noclipConn = RunService.Stepped:Connect(function()
		if not PlayerConfig.NoclipEnabled then return end
		for _, p in (Feature.char or {}):GetDescendants() do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end)
end

local function toggleNoclip(v)
	PlayerConfig.NoclipEnabled = v
	if v then startNoclip() else stopNoclip() end
	notify(v and "good" or "warn", "Noclip " .. (v and "enabled" or "disabled"))
end

-- Flight controls
UserInputService.InputBegan:Connect(function(i, gp)
	if gp then return end
	local k = i.KeyCode
	if k == Enum.KeyCode.W     then Feature.flightInput.W    = true end
	if k == Enum.KeyCode.A     then Feature.flightInput.A    = true end
	if k == Enum.KeyCode.S     then Feature.flightInput.S    = true end
	if k == Enum.KeyCode.D     then Feature.flightInput.D    = true end
	if k == Enum.KeyCode.Space then Feature.flightInput.Up   = true end
	if k == Enum.KeyCode.LeftShift then Feature.flightInput.Down = true end
end)

UserInputService.InputEnded:Connect(function(i, gp)
	if gp then return end
	local k = i.KeyCode
	if k == Enum.KeyCode.W     then Feature.flightInput.W    = false end
	if k == Enum.KeyCode.A     then Feature.flightInput.A    = false end
	if k == Enum.KeyCode.S     then Feature.flightInput.S    = false end
	if k == Enum.KeyCode.D     then Feature.flightInput.D    = false end
	if k == Enum.KeyCode.Space then Feature.flightInput.Up   = false end
	if k == Enum.KeyCode.LeftShift then Feature.flightInput.Down = false end
end)

player.CharacterAdded:Connect(function()
	task.wait()
	bindCharacter()
	applyWalkSpeed()
	if PlayerConfig.FlyEnabled    then startFly()    end
	if PlayerConfig.NoclipEnabled then startNoclip() end
end)

task.defer(function()
	bindCharacter()
	applyWalkSpeed()
end)

--=====================================================
-- UI Helpers
--=====================================================
local function mkToggleRow(parent, label, get, set)
	local row = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.2,
		Size = UDim2.new(1,0,0,52),
		Parent = parent
	})
	make("UICorner", {CornerRadius = UDim.new(0,12), Parent = row})
	make("UIStroke", {Color = Theme.Orange1, Thickness = 1, Transparency = 0.75, Parent = row})

	make("TextLabel", {
		BackgroundTransparency = 1,
		Text = label,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-140,1,0),
		Position = UDim2.fromOffset(14,0),
		Parent = row
	})

	local btn = make("TextButton", {
		Text = "",
		BackgroundColor3 = Theme.Button,
		Size = UDim2.fromOffset(110,36),
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,-14,0.5,0),
		Parent = row
	})
	make("UICorner", {CornerRadius = UDim.new(0,10), Parent = btn})
	local stroke = make("UIStroke", {Color = Theme.Warn, Transparency = 0.5, Parent = btn})

	local function refresh()
		local on = get()
		btn.Text = on and "ON" or "OFF"
		stroke.Color = on and Theme.Good or Theme.Warn
	end
	refresh()

	btn.MouseButton1Click:Connect(function()
		playSound("Click")
		set(not get())
		refresh()
	end)

	btn.MouseEnter:Connect(function() tween(btn, TweenInfo.new(0.14), {BackgroundColor3 = Theme.ButtonHover}) end)
	btn.MouseLeave:Connect(function() tween(btn, TweenInfo.new(0.14), {BackgroundColor3 = Theme.Button}) end)

	return row, refresh
end

local function mkSliderRow(parent, label, minv, maxv, get, set, suffix)
	suffix = suffix or ""
	local row = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.2,
		Size = UDim2.new(1,0,0,64),
		Parent = parent
	})
	make("UICorner", {CornerRadius = UDim.new(0,12), Parent = row})
	make("UIStroke", {Color = Theme.Orange1, Thickness = 1, Transparency = 0.75, Parent = row})

	make("TextLabel", {
		Text = label,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-20,0,22),
		Position = UDim2.fromOffset(12,6),
		BackgroundTransparency = 1,
		Parent = row
	})

	local valLabel = make("TextLabel", {
		Text = "",
		TextColor3 = Theme.SubText,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(1,-20,0,20),
		Position = UDim2.fromOffset(12,6),
		BackgroundTransparency = 1,
		Parent = row
	})

	local track = make("Frame", {
		BackgroundColor3 = Theme.Button,
		Size = UDim2.new(1,-24,0,8),
		Position = UDim2.fromOffset(12,38),
		Parent = row
	})
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = track})

	local fill = make("Frame", {BackgroundColor3 = Theme.Orange2, Size = UDim2.new(0,0,1,0), Parent = track})
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})

	local knob = make("Frame", {
		BackgroundColor3 = Theme.Text,
		Size = UDim2.fromOffset(18,18),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0,0,0.5,0),
		Parent = track
	})
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = knob})
	make("UIStroke", {Color = Theme.Orange1, Thickness = 1.2, Transparency = 0.4, Parent = knob})

	local dragging = false

	local function refresh()
		local v = clamp(get(), minv, maxv)
		local frac = (v - minv) / (maxv - minv)
		fill.Size = UDim2.new(frac, 0, 1, 0)
		knob.Position = UDim2.new(frac, 0, 0.5, 0)
		valLabel.Text = math.floor(v + 0.5) .. suffix
	end

	local function setFromX(x)
		local absX = track.AbsolutePosition.X
		local w = track.AbsoluteSize.X
		local frac = clamp((x - absX) / w, 0, 1)
		local v = minv + frac * (maxv - minv)
		set(v)
		refresh()
	end

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(i.Position.X)
		end
	end)

	track.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setFromX(i.Position.X)
		end
	end)

	refresh()
	return row, refresh
end

local function mkKeybindRow(parent, name, getKey, setKey)
	local row = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,42),
		Parent = parent
	})

	make("TextLabel", {
		Text = "Keybind",
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.4,0,1,0),
		BackgroundTransparency = 1,
		Parent = row
	})

	local btn = make("TextButton", {
		Text = getKey() and getKey().Name or "NONE",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		BackgroundColor3 = Theme.Button,
		Size = UDim2.fromOffset(130,32),
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,0,0.5,0),
		Parent = row
	})
	make("UICorner", {CornerRadius = UDim.new(0,10), Parent = btn})

	local waiting = false

	btn.MouseButton1Click:Connect(function()
		if waiting then return end
		waiting = true
		btn.Text = "..."
		local conn = UserInputService.InputBegan:Connect(function(i, gpe)
			if gpe then return end
			if i.KeyCode == Enum.KeyCode.Escape then
				setKey(nil)
			elseif i.KeyCode ~= Enum.KeyCode.Unknown then
				setKey(i.KeyCode)
			end
			btn.Text = getKey() and getKey().Name or "NONE"
			waiting = false
			conn:Disconnect()
			notify("good", name .. " keybind " .. (getKey() and "set" or "cleared"))
		end)
	end)

	return row
end

local function mkColorSliders(parent, getColor, setColor)
	local wrap = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,110),
		Parent = parent
	})
	make("UIListLayout", {Padding = UDim.new(0,6), Parent = wrap})

	local function channel(label, ch)
		local _, ref = mkSliderRow(wrap, label, 0, 255,
			function() return math.floor(getColor()[ch]*255) end,
			function(v)
				local c = getColor()
				setColor(Color3.new(
					ch=="R" and v/255 or c.R,
					ch=="G" and v/255 or c.G,
					ch=="B" and v/255 or c.B
				))
			end, "")
		return ref
	end

	local r = channel("Red",   "R")
	local g = channel("Green", "G")
	local b = channel("Blue",  "B")

	local preview = make("Frame", {
		Size = UDim2.new(1,0,0,32),
		BackgroundColor3 = getColor(),
		Parent = wrap
	})
	make("UICorner", {CornerRadius = UDim.new(0,10), Parent = preview})

	local function update()
		preview.BackgroundColor3 = getColor()
		r() g() b()
	end

	return wrap, update
end

--=====================================================
-- UI Construction
--=====================================================
local function buildUI()
	local old = getGui()
	if old then old:Destroy() end

	local gui = make("ScreenGui", {
		Name = UI_NAME,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui
	})

	local backdrop = make("Frame", {
		Size = UDim2.fromScale(1,1),
		BackgroundColor3 = Theme.BaseBlack,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = gui
	})
	make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Theme.BaseBlack, Color3.new(0,0,0)),
		Parent = backdrop
	})

	local vignette = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://4576475446",
		ImageTransparency = 0.4,
		ImageColor3 = Theme.Orange1,
		Size = UDim2.fromScale(1,1),
		Parent = gui
	})

	Notif.holder = make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-20,0,20),
		Size = UDim2.fromOffset(320,500),
		Parent = gui
	})
	make("UIListLayout", {Padding = UDim.new(0,12), HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = Notif.holder})

	local shadow = make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageTransparency = 0.65,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10,10,118,118),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		Size = UDim2.fromOffset(820,560),
		Parent = backdrop
	})

	local panel = make("Frame", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		Size = UDim2.fromOffset(760, 500),
		BackgroundColor3 = Theme.PanelBlack,
		BackgroundTransparency = 0.08,
		Parent = backdrop
	})
	make("UICorner", {CornerRadius = UDim.new(0,22), Parent = panel})

	local stroke = make("UIStroke", {
		Color = Theme.Orange1,
		Thickness = 2.2,
		Transparency = 0.25,
		Parent = panel
	})
	make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Theme.Orange1, Theme.Orange2, Theme.Orange1),
		Parent = stroke
	})

	local title = make("TextLabel", {
		Text = "Singularity",
		TextColor3 = Theme.Text,
		TextSize = 28,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-180,0,40),
		Position = UDim2.fromOffset(20,18),
		BackgroundTransparency = 1,
		Parent = panel
	})

	make("TextLabel", {
		Text = "Solid • Clean • Keybinds • ESP",
		TextColor3 = Theme.SubText,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-180,0,24),
		Position = UDim2.fromOffset(20,52),
		BackgroundTransparency = 1,
		Parent = panel
	})

	local closeBtn = make("TextButton", {
		Text = "×",
		TextColor3 = Theme.Text,
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Theme.Button,
		Size = UDim2.fromOffset(44,44),
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-20,0,18),
		Parent = panel
	})
	make("UICorner", {CornerRadius = UDim.new(0,12), Parent = closeBtn})

	closeBtn.MouseButton1Click:Connect(function()
		playSound("Click")
		toggleUI()
	end)

	local body = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,-40,1,-110),
		Position = UDim2.fromOffset(20,90),
		Parent = panel
	})

	local sidebar = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		Size = UDim2.new(0,200,1,0),
		Parent = body
	})
	make("UICorner", {CornerRadius = UDim.new(0,16), Parent = sidebar})
	make("UIStroke", {Color = Theme.Orange1, Transparency = 0.8, Parent = sidebar})

	local pagesWrap = make("Frame", {
		BackgroundColor3 = Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,0,0,0),
		Size = UDim2.new(1,-212,1,0),
		Parent = body
	})
	make("UICorner", {CornerRadius = UDim.new(0,16), Parent = pagesWrap})
	make("UIStroke", {Color = Theme.Orange1, Transparency = 0.8, Parent = pagesWrap})

	local pages = make("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = pagesWrap})
	local pageLayout = make("UIPageLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		EasingStyle = Enum.EasingStyle.Quint,
		EasingDirection = Enum.EasingDirection.Out,
		TweenTime = 0.4,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = pages
	})

	local function mkPage(name, order)
		local p = make("Frame", {
			Name = name,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1,1),
			LayoutOrder = order,
			Parent = pages
		})
		make("UIPadding", {
			PaddingTop = UDim.new(0,16),
			PaddingLeft = UDim.new(0,16),
			PaddingRight = UDim.new(0,16),
			PaddingBottom = UDim.new(0,16),
			Parent = p
		})
		return p
	end

	local pagePlayer   = mkPage("Player",   1)
	local pageAimbot   = mkPage("Aimbot",   2)
	local pageESP      = mkPage("ESP",      3)
	local pageMisc     = mkPage("Misc",     4)
	local pageSettings = mkPage("Settings", 5)

	local function pageHeader(p, title, desc)
		make("TextLabel", {
			Text = title,
			TextColor3 = Theme.Text,
			TextSize = 22,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1,0,0,30),
			BackgroundTransparency = 1,
			Parent = p
		})
		make("TextLabel", {
			Text = desc,
			TextColor3 = Theme.SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1,0,0,22),
			Position = UDim2.fromOffset(0,32),
			BackgroundTransparency = 1,
			Parent = p
		})
	end

	-- Sidebar tabs
	local selectedTab = nil
	local tabButtons = {}

	local function mkTabButton(text, icon, tabName)
		local b = make("TextButton", {
			Text = "",
			BackgroundColor3 = Theme.Button,
			Size = UDim2.new(1,-24,0,46),
			Parent = sidebar
		})
		make("UICorner", {CornerRadius = UDim.new(0,12), Parent = b})
		local st = make("UIStroke", {Color = Theme.Orange1, Thickness = 1, Transparency = 0.7, Parent = b})

		make("TextLabel", {
			Text = (icon or "") .. "  " .. text,
			TextColor3 = Theme.Text,
			TextSize = 16,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1,-20,1,0),
			Position = UDim2.fromOffset(16,0),
			BackgroundTransparency = 1,
			Parent = b
		})

		b.MouseEnter:Connect(function()
			if selectedTab ~= tabName then
				tween(b, TweenInfo.new(0.14), {BackgroundColor3 = Theme.ButtonHover})
				tween(st, TweenInfo.new(0.14), {Transparency = 0.4})
			end
		end)
		b.MouseLeave:Connect(function()
			if selectedTab ~= tabName then
				tween(b, TweenInfo.new(0.14), {BackgroundColor3 = Theme.Button})
				tween(st, TweenInfo.new(0.14), {Transparency = 0.7})
			end
		end)

		tabButtons[tabName] = {btn = b, stroke = st}
		return b
	end

	local function selectTab(name)
		selectedTab = name
		for tname, data in pairs(tabButtons) do
			local on = tname == name
			tween(data.btn, TweenInfo.new(0.16), {BackgroundColor3 = on and Theme.ButtonHover or Theme.Button})
			tween(data.stroke, TweenInfo.new(0.16), {Transparency = on and 0.25 or 0.7})
		end
	end

	local tabs = {
		{"Player",   "🧍"},
		{"Aimbot",   "🎯"},
		{"ESP",      "👁️"},
		{"Misc",     "🛠️"},
		{"Settings", "⚙️"},
	}

	for _, t in ipairs(tabs) do
		local name, icon = t[1], t[2]
		local btn = mkTabButton(name, icon, name)
		btn.MouseButton1Click:Connect(function()
			playSound("Click")
			pageLayout:JumpToIndex(table.find(tabs, t))
			selectTab(name)
		end)
	end

	-- Player page
	pageHeader(pagePlayer, "Player", "Movement & local cheats")
	do
		local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pagePlayer})
		make("UIListLayout", {Padding = UDim.new(0,12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})

		mkSliderRow(list, "Walk Speed", PlayerConfig.WalkSpeedMin, PlayerConfig.WalkSpeedMax,
			function() return PlayerConfig.WalkSpeed end,
			function(v) PlayerConfig.WalkSpeed = math.floor(v); applyWalkSpeed() end)

		local _, refFly = mkToggleRow(list, "Fly", function() return PlayerConfig.FlyEnabled end, toggleFly)
		mkKeybindRow(list, "Fly", function() return Keybinds.Fly end, function(k) Keybinds.Fly = k end)

		mkSliderRow(list, "Fly Speed", PlayerConfig.FlySpeedMin, PlayerConfig.FlySpeedMax,
			function() return PlayerConfig.FlySpeed end,
			function(v) PlayerConfig.FlySpeed = math.floor(v) end)

		local _, refNoclip = mkToggleRow(list, "Noclip", function() return PlayerConfig.NoclipEnabled end, toggleNoclip)
		mkKeybindRow(list, "Noclip", function() return Keybinds.Noclip end, function(k) Keybinds.Noclip = k end)
	end

	-- Aimbot page (placeholder - add your logic)
	pageHeader(pageAimbot, "Aimbot", "Silent / FOV / Smoothness")
	do
		local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageAimbot})
		make("UIListLayout", {Padding = UDim.new(0,12), Parent = list})

		mkToggleRow(list, "Aimbot Enabled", function() return false end, function(v) notify("warn", "Aimbot logic not implemented yet") end)
		mkKeybindRow(list, "Aimbot", function() return Keybinds.Aimbot end, function(k) Keybinds.Aimbot = k end)
		mkSliderRow(list, "FOV", 10, 800, function() return 120 end, function(v) end)
		mkSliderRow(list, "Smoothness", 0, 100, function() return 40 end, function(v) end)
	end

	-- ESP page
	pageHeader(pageESP, "ESP", "Player visuals & customization")
	do
		local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageESP})
		make("UIListLayout", {Padding = UDim.new(0,12), Parent = list})

		local _, refESP = mkToggleRow(list, "ESP Enabled",
			function() return ESPConfig.Enabled end,
			function(v)
				ESPConfig.Enabled = v
				notify(v and "good" or "warn", "ESP " .. (v and "enabled" or "disabled"))
				-- Connect real ESP loop here if you have one
			end
		)
		mkKeybindRow(list, "ESP", function() return Keybinds.ESP end, function(k) Keybinds.ESP = k end)

		make("TextLabel", {Text="Color", TextColor3=Theme.Text, Font=Enum.Font.GothamSemibold, TextSize=16, Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, Parent=list})

		local _, updateColor = mkColorSliders(list,
			function() return ESPConfig.Color end,
			function(c) ESPConfig.Color = c; updateColor() end
		)

		local espOptions = {
			{"Box",     function() return ESPConfig.ShowBox    end, function(v) ESPConfig.ShowBox = v    end},
			{"Tracer",  function() return ESPConfig.ShowTracer end, function(v) ESPConfig.ShowTracer = v end},
			{"Name",    function() return ESPConfig.ShowName   end, function(v) ESPConfig.ShowName = v   end},
			{"Health",  function() return ESPConfig.ShowHealth end, function(v) ESPConfig.ShowHealth = v end},
			{"Aura",    function() return ESPConfig.Aura       end, function(v) ESPConfig.Aura = v       end},
		}

		for _, opt in ipairs(espOptions) do
			mkToggleRow(list, opt[1], opt[2], function(v)
				opt[3](v)
				notify("good", opt[1] .. (v and " enabled" or " disabled"))
			end)
		end
	end

	-- Misc page (placeholder)
	pageHeader(pageMisc, "Misc", "Other utilities")
	do
		local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageMisc})
		make("UIListLayout", {Padding = UDim.new(0,12), Parent = list})
		make("TextLabel", {
			Text = "Coming soon...\nFullbright, Crosshair, No Recoil, etc.",
			TextColor3 = Theme.SubText,
			TextSize = 15,
			Font = Enum.Font.Gotham,
			TextWrapped = true,
			Size = UDim2.new(1,0,0,80),
			BackgroundTransparency = 1,
			Parent = list
		})
	end

	-- Settings page
	pageHeader(pageSettings, "Settings", "UI & sound preferences")
	do
		local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageSettings})
		make("UIListLayout", {Padding = UDim.new(0,12), Parent = list})

		mkToggleRow(list, "UI Sounds", function() return SettingsState.SoundsEnabled end,
			function(v) SettingsState.SoundsEnabled = v; notify("good", "Sounds " .. (v and "on" or "off")) end)

		mkSliderRow(list, "Volume", 0, 1, function() return SettingsState.MasterVolume end,
			function(v)
				SettingsState.MasterVolume = v
				for _, s in SoundFolder:GetChildren() do
					if s:IsA("Sound") then s.Volume = v end
				end
			end, "")
	end

	-- Default tab
	task.defer(function()
		pageLayout:JumpTo(pagePlayer)
		selectTab("Player")
	end)

	-- Simple animated stroke
	local time = 0
	local animConn = RunService.RenderStepped:Connect(function(dt)
		time += dt
		stroke.Transparency = 0.2 + 0.12 * math.sin(time * 3)
	end)

	-- Drag
	local dragging, dragStart, startPos
	panel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = panel.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			shadow.Position = panel.Position
		end
	end)

	panel.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return gui
end

--=====================================================
-- Open / Close
--=====================================================
local function openUI()
	if isOpen() then return end
	buildUI()
	playSound("Open")
	notify("good", "Menu opened")
end

local function closeUI()
	local g = getGui()
	if not g then return end
	g:Destroy()
	Notif.holder = nil
	notify("warn", "Menu closed")
end

local function toggleUI()
	if isOpen() then closeUI() else openUI() end
end

--=====================================================
-- Toggle button (mobile / always visible)
--=====================================================
local function createToggleButton()
	local ex = playerGui:FindFirstChild(TOGGLE_BUTTON_GUI)
	if ex then return end

	local sg = make("ScreenGui", {Name = TOGGLE_BUTTON_GUI, ResetOnSpawn = false, IgnoreGuiInset = true, Parent = playerGui})
	local btn = make("TextButton", {
		Text = "≡",
		TextColor3 = Theme.Text,
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Theme.Button,
		Size = UDim2.fromOffset(60,60),
		AnchorPoint = Vector2.new(0,1),
		Position = UDim2.new(0,20,1,-20),
		Parent = sg
	})
	make("UICorner", {CornerRadius = UDim.new(1,0), Parent = btn})
	make("UIStroke", {Color = Theme.Orange2, Thickness = 2, Transparency = 0.4, Parent = btn})

	btn.MouseButton1Click:Connect(toggleUI)

	-- Drag button
	local drg, ds, sp
	btn.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drg = true
			ds = i.Position
			sp = btn.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if not drg then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			local d = i.Position - ds
			btn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)

	btn.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drg = false end
	end)
end

createToggleButton()

--=====================================================
-- Global keybinds listener
--=====================================================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local k = input.KeyCode

	if Keybinds.Fly    and k == Keybinds.Fly    then toggleFly   (not PlayerConfig.FlyEnabled)    end
	if Keybinds.Noclip and k == Keybinds.Noclip then toggleNoclip(not PlayerConfig.NoclipEnabled) end
	if Keybinds.ESP    and k == Keybinds.ESP    then
		ESPConfig.Enabled = not ESPConfig.Enabled
		notify(ESPConfig.Enabled and "good" or "warn", "ESP " .. (ESPConfig.Enabled and "on" or "off"))
	end

	-- Add more keybind actions here (Aimbot etc.)

	for tk,_ in pairs(TOGGLE_KEYS) do
		if k == tk then toggleUI() return end
	end

	if TOGGLE_GAMEPAD_START and input.UserInputType == Enum.UserInputType.Gamepad1 and k == Enum.KeyCode.ButtonStart then
		toggleUI()
	end
end)

-- Optional: auto open on start
-- task.delay(1.5, openUI)
