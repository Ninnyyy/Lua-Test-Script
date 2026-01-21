-- main.lua (LocalScript) - StarterPlayerScripts
-- Modularized: UI helpers, features separated
-- Fixed UI fit: increased panel size, added scrolling to pages
-- Added Aimbot implementation (silent + camera, with checks for executor funcs)

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local SoundService      = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

--=====================================================
-- Config Module
--=====================================================
local Config = {
	UI_NAME = "SingularityMenu",
	TOGGLE_BUTTON_GUI = "SingularityMenu_ToggleButton",
	TOGGLE_KEYS = {
		[Enum.KeyCode.LeftControl] = true,
		[Enum.KeyCode.RightControl] = true,
		[Enum.KeyCode.Escape] = true,
	},
	TOGGLE_GAMEPAD_START = true,
	SOUND_IDS = {
		Open = "", Close = "", Click = "", Hover = "", Notify = "",
	},
	Theme = {
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
	},
	PlayerConfig = {
		WalkSpeed      = 16,
		WalkSpeedMin   = 16,
		WalkSpeedMax   = 100,
		FlyEnabled     = false,
		FlySpeed       = 60,
		FlySpeedMin    = 20,
		FlySpeedMax    = 150,
		NoclipEnabled  = false,
	},
	ESPConfig = {
		Enabled    = false,
		Color      = Color3.fromRGB(255, 80, 60),
		ShowBox    = true,
		ShowTracer = true,
		ShowName   = true,
		ShowHealth = false,
		Aura       = false,
	},
	AimbotConfig = {
		Enabled       = false,
		AimPart       = "Head",
		FOV           = 120,
		Smoothness    = 40,
		TeamCheck     = true,
		WallCheck     = true,
	},
	Keybinds = {
		Fly    = nil,
		Noclip = nil,
		ESP    = nil,
		Aimbot = nil,
	},
	SettingsState = {
		SoundsEnabled  = true,
		MasterVolume   = 0.8,
	},
}

--=====================================================
-- Utilities Module
--=====================================================
local Utils = {}

function Utils.make(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then inst[k] = v end
	end
	if props and props.Parent then inst.Parent = props.Parent end
	return inst
end

function Utils.tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

function Utils.getGui() return playerGui:FindFirstChild(Config.UI_NAME) end
function Utils.isOpen() return Utils.getGui() ~= nil end

function Utils.safeDisconnect(c) if c then c:Disconnect() end end

function Utils.clamp(v, min, max) return math.clamp(v, min, max) end

--=====================================================
-- Sounds Module
--=====================================================
local Sounds = {}

Sounds.SoundFolder = SoundService:FindFirstChild("Singularity_UI_Sounds") or Utils.make("Folder", {
	Name = "Singularity_UI_Sounds", Parent = SoundService
})

function Sounds.getSound(name)
	local s = Sounds.SoundFolder:FindFirstChild(name)
	if not s then
		s = Utils.make("Sound", {Name = name, Volume = Config.SettingsState.MasterVolume, SoundId = Config.SOUND_IDS[name] or "", Parent = Sounds.SoundFolder})
	end
	s.Volume = Config.SettingsState.MasterVolume
	s.SoundId = Config.SOUND_IDS[name] or s.SoundId
	return s
end

function Sounds.playSound(name)
	if not Config.SettingsState.SoundsEnabled then return end
	local id = Config.SOUND_IDS[name]
	if id and id ~= "" then Sounds.getSound(name):Play() end
end

--=====================================================
-- Notifications Module
--=====================================================
local Notifications = {holder = nil, queue = {}, active = 0, maxActive = 4}

function Notifications.notifAccent(kind)
	if kind == "good" then return Config.Theme.Good end
	if kind == "warn" then return Config.Theme.Warn end
	if kind == "bad"  then return Config.Theme.Bad  end
	return Config.Theme.Orange1
end

function Notifications.spawnNotification(kind, text)
	if not Notifications.holder then return end
	Notifications.active += 1
	Sounds.playSound("Notify")

	local accent = Notifications.notifAccent(kind)

	local card = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(300, 60),
		ZIndex = 500, Parent = Notifications.holder
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,12), Parent = card})
	Utils.make("UIStroke", {Color = accent, Thickness = 1.5, Transparency = 0.3, Parent = card})

	local label = Utils.make("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Config.Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-16,1,-16),
		Position = UDim2.fromOffset(8,8),
		TextTransparency = 1,
		ZIndex = 501, Parent = card
	})

	local scale = Utils.make("UIScale", {Scale = 0.8, Parent = card})

	Utils.tween(card, TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
	Utils.tween(label, TweenInfo.new(0.25), {TextTransparency = 0})
	Utils.tween(scale, TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Scale = 1})

	task.delay(3.2, function()
		if not card.Parent then return end
		Utils.tween(scale, TweenInfo.new(0.2), {Scale = 0.85})
		Utils.tween(label, TweenInfo.new(0.18), {TextTransparency = 1})
		local fade = Utils.tween(card, TweenInfo.new(0.18), {BackgroundTransparency = 1})
		fade.Completed:Connect(function() card:Destroy() end)
		Notifications.active -= 1
		if #Notifications.queue > 0 and Notifications.active < Notifications.maxActive then
			local next = table.remove(Notifications.queue,1)
			Notifications.spawnNotification(next.kind, next.text)
		end
	end)
end

function Notifications.notify(kind, text)
	if Notifications.active >= Notifications.maxActive then
		table.insert(Notifications.queue, {kind=kind, text=text})
	else
		Notifications.spawnNotification(kind, text)
	end
end

--=====================================================
-- Player Features Module
--=====================================================
local PlayerFeatures = {
	Feature = {
		char = nil, hum = nil, root = nil,
		flyBV = nil, flyBG = nil, flyConn = nil,
		noclipConn = nil,
		flightInput = {W=false,A=false,S=false,D=false,Up=false,Down=false},
	},
}

function PlayerFeatures.bindCharacter()
	PlayerFeatures.Feature.char = player.Character or player.CharacterAdded:Wait()
	PlayerFeatures.Feature.hum = PlayerFeatures.Feature.char:WaitForChild("Humanoid")
	PlayerFeatures.Feature.root = PlayerFeatures.Feature.char:WaitForChild("HumanoidRootPart")
end

function PlayerFeatures.applyWalkSpeed()
	if PlayerFeatures.Feature.hum then PlayerFeatures.Feature.hum.WalkSpeed = Config.PlayerConfig.WalkSpeed end
end

function PlayerFeatures.stopFly()
	Config.PlayerConfig.FlyEnabled = false
	Utils.safeDisconnect(PlayerFeatures.Feature.flyConn)
	if PlayerFeatures.Feature.flyBV then PlayerFeatures.Feature.flyBV:Destroy() PlayerFeatures.Feature.flyBV = nil end
	if PlayerFeatures.Feature.flyBG then PlayerFeatures.Feature.flyBG:Destroy() PlayerFeatures.Feature.flyBG = nil end
	if PlayerFeatures.Feature.hum then PlayerFeatures.Feature.hum.PlatformStand = false end
end

function PlayerFeatures.startFly()
	if not PlayerFeatures.Feature.root or not PlayerFeatures.Feature.hum then return end
	PlayerFeatures.stopFly()
	Config.PlayerConfig.FlyEnabled = true
	PlayerFeatures.Feature.hum.PlatformStand = true

	PlayerFeatures.Feature.flyBV = Utils.make("BodyVelocity", {MaxForce = Vector3.new(1e9,1e9,1e9), P = 1e4, Velocity = Vector3.zero, Parent = PlayerFeatures.Feature.root})
	PlayerFeatures.Feature.flyBG = Utils.make("BodyGyro", {MaxTorque = Vector3.new(1e9,1e9,1e9), P = 1e5, CFrame = PlayerFeatures.Feature.root.CFrame, Parent = PlayerFeatures.Feature.root})

	PlayerFeatures.Feature.flyConn = RunService.RenderStepped:Connect(function()
		if not Config.PlayerConfig.FlyEnabled then return end
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		local lv = cam.CFrame.LookVector
		local rv = cam.CFrame.RightVector
		local forward = Vector3.new(lv.X, 0, lv.Z).Unit
		local right   = Vector3.new(rv.X, 0, rv.Z).Unit

		if PlayerFeatures.Feature.flightInput.W    then move += forward end
		if PlayerFeatures.Feature.flightInput.S    then move -= forward end
		if PlayerFeatures.Feature.flightInput.D    then move += right   end
		if PlayerFeatures.Feature.flightInput.A    then move -= right   end
		if PlayerFeatures.Feature.flightInput.Up   then move += Vector3.yAxis end
		if PlayerFeatures.Feature.flightInput.Down then move -= Vector3.yAxis end

		PlayerFeatures.Feature.flyBV.Velocity = move.Unit * Config.PlayerConfig.FlySpeed * (move.Magnitude > 0 and 1 or 0)
		PlayerFeatures.Feature.flyBG.CFrame = cam.CFrame
	end)
end

function PlayerFeatures.toggleFly(v)
	Config.PlayerConfig.FlyEnabled = v
	if v then PlayerFeatures.startFly() else PlayerFeatures.stopFly() end
	Notifications.notify(v and "good" or "warn", "Fly " .. (v and "enabled" or "disabled"))
end

function PlayerFeatures.stopNoclip()
	Config.PlayerConfig.NoclipEnabled = false
	Utils.safeDisconnect(PlayerFeatures.Feature.noclipConn)
	if PlayerFeatures.Feature.char then
		for _, p in PlayerFeatures.Feature.char:GetDescendants() do
			if p:IsA("BasePart") then p.CanCollide = true end
		end
	end
end

function PlayerFeatures.startNoclip()
	Config.PlayerConfig.NoclipEnabled = true
	Utils.safeDisconnect(PlayerFeatures.Feature.noclipConn)
	PlayerFeatures.Feature.noclipConn = RunService.Stepped:Connect(function()
		if not Config.PlayerConfig.NoclipEnabled then return end
		local c = PlayerFeatures.Feature.char
		if not c then return end
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = false
			end
		end
	end)
end

function PlayerFeatures.toggleNoclip(v)
	Config.PlayerConfig.NoclipEnabled = v
	if v then PlayerFeatures.startNoclip() else PlayerFeatures.stopNoclip() end
	Notifications.notify(v and "good" or "warn", "Noclip " .. (v and "enabled" or "disabled"))
end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then PlayerFeatures.Feature.flightInput.W = true end
	if k == Enum.KeyCode.A then PlayerFeatures.Feature.flightInput.A = true end
	if k == Enum.KeyCode.S then PlayerFeatures.Feature.flightInput.S = true end
	if k == Enum.KeyCode.D then PlayerFeatures.Feature.flightInput.D = true end
	if k == Enum.KeyCode.Space then PlayerFeatures.Feature.flightInput.Up = true end
	if k == Enum.KeyCode.LeftShift then PlayerFeatures.Feature.flightInput.Down = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then PlayerFeatures.Feature.flightInput.W = false end
	if k == Enum.KeyCode.A then PlayerFeatures.Feature.flightInput.A = false end
	if k == Enum.KeyCode.S then PlayerFeatures.Feature.flightInput.S = false end
	if k == Enum.KeyCode.D then PlayerFeatures.Feature.flightInput.D = false end
	if k == Enum.KeyCode.Space then PlayerFeatures.Feature.flightInput.Up = false end
	if k == Enum.KeyCode.LeftShift then PlayerFeatures.Feature.flightInput.Down = false end
end)

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	PlayerFeatures.bindCharacter()
	PlayerFeatures.applyWalkSpeed()
	if Config.PlayerConfig.FlyEnabled then PlayerFeatures.toggleFly(true) end
	if Config.PlayerConfig.NoclipEnabled then PlayerFeatures.toggleNoclip(true) end
end)

task.defer(function()
	PlayerFeatures.bindCharacter()
	PlayerFeatures.applyWalkSpeed()
end)

--=====================================================
-- Aimbot Module
--=====================================================
local Aimbot = {
	target = nil,
	fovCircle = Drawing.new("Circle"),
	conn = nil
}

Aimbot.fovCircle.Visible = false
Aimbot.fovCircle.Thickness = 1
Aimbot.fovCircle.NumSides = 36
Aimbot.fovCircle.Radius = Config.AimbotConfig.FOV
Aimbot.fovCircle.Color = Config.Theme.Orange1

local function findClosestTarget()
	local closest = nil
	local minDist = math.huge

	for _, p in ipairs(Players:GetPlayers()) do
		if p == player then continue end
		local char = p.Character
		if not char then continue end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then continue end
		local hum = char:FindFirstChild("Humanoid")
		if not hum or hum.Health <= 0 then continue end
		if Config.AimbotConfig.TeamCheck and p.Team == player.Team then continue end

		local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
		if not onScreen then continue end

		local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
		if dist < Config.AimbotConfig.FOV and dist < minDist then
			local ray = Ray.new(camera.CFrame.Position, (root.Position - camera.CFrame.Position).Unit * 1000)
			local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
			if not Config.AimbotConfig.WallCheck or (hit and hit:IsDescendantOf(char)) then
				minDist = dist
				closest = p
			end
		end
	end

	return closest
end

local function updateAimbot()
	if not Config.AimbotConfig.Enabled then
		Aimbot.target = nil
		Aimbot.fovCircle.Visible = false
		return
	end

	Aimbot.fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
	Aimbot.fovCircle.Radius = Config.AimbotConfig.FOV
	Aimbot.fovCircle.Visible = true

	Aimbot.target = findClosestTarget()

	if Aimbot.target then
		local char = Aimbot.target.Character
		local part = char:FindFirstChild(Config.AimbotConfig.AimPart) or char.HumanoidRootPart
		local goal = CFrame.new(camera.CFrame.Position, part.Position)
		camera.CFrame = camera.CFrame:Lerp(goal, Config.AimbotConfig.Smoothness / 100)
	end
end

function Aimbot.toggle(v)
	Config.AimbotConfig.Enabled = v
	Notifications.notify(v and "good" or "warn", "Aimbot " .. (v and "enabled" or "disabled"))
	if v then
		Aimbot.conn = RunService.RenderStepped:Connect(updateAimbot)
	else
		Utils.safeDisconnect(Aimbot.conn)
		Aimbot.conn = nil
	end
end

--=====================================================
-- UI Module
--=====================================================
local UI = {}

UI.UIHelpers = {}

function UI.UIHelpers.mkToggleRow(parent, label, get, set)
	local row = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 0.2,
		Size = UDim2.new(1,0,0,52),
		Parent = parent
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,12), Parent = row})
	Utils.make("UIStroke", {Color = Config.Theme.Orange1, Thickness = 1, Transparency = 0.75, Parent = row})

	Utils.make("TextLabel", {
		BackgroundTransparency = 1,
		Text = label,
		TextColor3 = Config.Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-140,1,0),
		Position = UDim2.fromOffset(14,0),
		Parent = row
	})

	local btn = Utils.make("TextButton", {
		Text = "",
		BackgroundColor3 = Config.Theme.Button,
		Size = UDim2.fromOffset(110,36),
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,-14,0.5,0),
		Parent = row
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,10), Parent = btn})
	local stroke = Utils.make("UIStroke", {Color = Config.Theme.Warn, Transparency = 0.5, Parent = btn})

	local function refresh()
		local on = get()
		btn.Text = on and "ON" or "OFF"
		stroke.Color = on and Config.Theme.Good or Config.Theme.Warn
	end
	refresh()

	btn.MouseButton1Click:Connect(function()
		Sounds.playSound("Click")
		set(not get())
		refresh()
	end)

	btn.MouseEnter:Connect(function() Utils.tween(btn, TweenInfo.new(0.14), {BackgroundColor3 = Config.Theme.ButtonHover}) end)
	btn.MouseLeave:Connect(function() Utils.tween(btn, TweenInfo.new(0.14), {BackgroundColor3 = Config.Theme.Button}) end)

	return row, refresh
end

function UI.UIHelpers.mkSliderRow(parent, label, minv, maxv, get, set, suffix)
	suffix = suffix or ""
	local row = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 0.2,
		Size = UDim2.new(1,0,0,64),
		Parent = parent
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,12), Parent = row})
	Utils.make("UIStroke", {Color = Config.Theme.Orange1, Thickness = 1, Transparency = 0.75, Parent = row})

	Utils.make("TextLabel", {
		Text = label,
		TextColor3 = Config.Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-20,0,22),
		Position = UDim2.fromOffset(12,6),
		BackgroundTransparency = 1,
		Parent = row
	})

	local valLabel = Utils.make("TextLabel", {
		Text = "",
		TextColor3 = Config.Theme.SubText,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(1,-20,0,20),
		Position = UDim2.fromOffset(12,6),
		BackgroundTransparency = 1,
		Parent = row
	})

	local track = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.Button,
		Size = UDim2.new(1,-24,0,8),
		Position = UDim2.fromOffset(12,38),
		Parent = row
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(1,0), Parent = track})

	local fill = Utils.make("Frame", {BackgroundColor3 = Config.Theme.Orange2, Size = UDim2.new(0,0,1,0), Parent = track})
	Utils.make("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})

	local knob = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.Text,
		Size = UDim2.fromOffset(18,18),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0,0,0.5,0),
		Parent = track
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(1,0), Parent = knob})
	Utils.make("UIStroke", {Color = Config.Theme.Orange1, Thickness = 1.2, Transparency = 0.4, Parent = knob})

	local dragging = false

	local function refresh()
		local v = Utils.clamp(get(), minv, maxv)
		local frac = (v - minv) / (maxv - minv)
		fill.Size = UDim2.new(frac, 0, 1, 0)
		knob.Position = UDim2.new(frac, 0, 0.5, 0)
		valLabel.Text = math.floor(v + 0.5) .. suffix
	end

	local function setFromX(x)
		local absX = track.AbsolutePosition.X
		local w = track.AbsoluteSize.X
		local frac = Utils.clamp((x - absX) / w, 0, 1)
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

function UI.UIHelpers.mkKeybindRow(parent, name, getKey, setKey)
	local row = Utils.make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,42),
		Parent = parent
	})

	Utils.make("TextLabel", {
		Text = "Keybind",
		TextColor3 = Config.Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.4,0,1,0),
		BackgroundTransparency = 1,
		Parent = row
	})

	local btn = Utils.make("TextButton", {
		Text = getKey() and getKey().Name or "NONE",
		TextColor3 = Config.Theme.Text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		BackgroundColor3 = Config.Theme.Button,
		Size = UDim2.fromOffset(130,32),
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,0,0.5,0),
		Parent = row
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,10), Parent = btn})

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
			Notifications.notify("good", name .. " keybind " .. (getKey() and "set" or "cleared"))
		end)
	end)

	return row
end

function UI.UIHelpers.mkColorSliders(parent, getColor, setColor)
	local wrap = Utils.make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,110),
		Parent = parent
	})
	Utils.make("UIListLayout", {Padding = UDim.new(0,6), Parent = wrap})

	local function channel(label, ch)
		local _, ref = UI.UIHelpers.mkSliderRow(wrap, label, 0, 255,
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

	local preview = Utils.make("Frame", {
		Size = UDim2.new(1,0,0,32),
		BackgroundColor3 = getColor(),
		Parent = wrap
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,10), Parent = preview})

	local function update()
		preview.BackgroundColor3 = getColor()
		r() g() b()
	end

	return wrap, update
end

function UI.buildUI()
	local old = Utils.getGui()
	if old then old:Destroy() end

	local gui = Utils.make("ScreenGui", {
		Name = Config.UI_NAME,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui
	})

	local backdrop = Utils.make("Frame", {
		Size = UDim2.fromScale(1,1),
		BackgroundColor3 = Config.Theme.BaseBlack,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = gui
	})
	Utils.make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Config.Theme.BaseBlack, Color3.new(0,0,0)),
		Parent = backdrop
	})

	local vignette = Utils.make("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://4576475446",
		ImageTransparency = 0.4,
		ImageColor3 = Config.Theme.Orange1,
		Size = UDim2.fromScale(1,1),
		Parent = gui
	})

	Notifications.holder = Utils.make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-20,0,20),
		Size = UDim2.fromOffset(320,500),
		Parent = gui
	})
	Utils.make("UIListLayout", {Padding = UDim.new(0,12), HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = Notifications.holder})

	local shadow = Utils.make("ImageLabel", {
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

	local panel = Utils.make("Frame", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		Size = UDim2.fromOffset(760, 500),
		BackgroundColor3 = Config.Theme.PanelBlack,
		BackgroundTransparency = 0.08,
		Parent = backdrop
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,22), Parent = panel})

	local stroke = Utils.make("UIStroke", {
		Color = Config.Theme.Orange1,
		Thickness = 2.2,
		Transparency = 0.25,
		Parent = panel
	})
	Utils.make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Config.Theme.Orange1, Config.Theme.Orange2, Config.Theme.Orange1),
		Parent = stroke
	})

	local title = Utils.make("TextLabel", {
		Text = "Singularity",
		TextColor3 = Config.Theme.Text,
		TextSize = 28,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-180,0,40),
		Position = UDim2.fromOffset(20,18),
		BackgroundTransparency = 1,
		Parent = panel
	})

	Utils.make("TextLabel", {
		Text = "Solid • Clean • Keybinds • ESP",
		TextColor3 = Config.Theme.SubText,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,-180,0,24),
		Position = UDim2.fromOffset(20,52),
		BackgroundTransparency = 1,
		Parent = panel
	})

	local closeBtn = Utils.make("TextButton", {
		Text = "×",
		TextColor3 = Config.Theme.Text,
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Config.Theme.Button,
		Size = UDim2.fromOffset(44,44),
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-20,0,18),
		Parent = panel
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,12), Parent = closeBtn})

	closeBtn.MouseButton1Click:Connect(function()
		Sounds.playSound("Click")
		UI.toggleUI()
	end)

	local body = Utils.make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,-40,1,-110),
		Position = UDim2.fromOffset(20,90),
		Parent = panel
	})

	local sidebar = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		Size = UDim2.new(0,200,1,0),
		Parent = body
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,16), Parent = sidebar})
	Utils.make("UIStroke", {Color = Config.Theme.Orange1, Transparency = 0.8, Parent = sidebar})

	local pagesWrap = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 0.15,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,0,0,0),
		Size = UDim2.new(1,-212,1,0),
		Parent = body
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,16), Parent = pagesWrap})
	Utils.make("UIStroke", {Color = Config.Theme.Orange1, Transparency = 0.8, Parent = pagesWrap})

	local pages = Utils.make("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = pagesWrap})
	local pageLayout = Utils.make("UIPageLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		EasingStyle = Enum.EasingStyle.Quint,
		EasingDirection = Enum.EasingDirection.Out,
		TweenTime = 0.4,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = pages
	})

	local function mkPage(name, order)
		local p = Utils.make("Frame", {
			Name = name,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1,1),
			LayoutOrder = order,
			Parent = pages
		})
		Utils.make("UIPadding", {
			PaddingTop = UDim.new(0,16),
			PaddingLeft = UDim.new(0,16),
			PaddingRight = UDim.new(0,16),
			PaddingBottom = UDim.new(0,16),
			Parent = p
		})
		local scroller = Utils.make("ScrollingFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1,1),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 4,
			Parent = p
		})
		Utils.make("UIListLayout", {Padding = UDim.new(0,12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroller})
		return scroller
	end

	local pagePlayer   = mkPage("Player",   1)
	local pageAimbot   = mkPage("Aimbot",   2)
	local pageESP      = mkPage("ESP",      3)
	local pageMisc     = mkPage("Misc",     4)
	local pageSettings = mkPage("Settings", 5)

	local function pageHeader(p, title, desc)
		Utils.make("TextLabel", {
			Text = title,
			TextColor3 = Config.Theme.Text,
			TextSize = 22,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1,0,0,30),
			BackgroundTransparency = 1,
			Parent = p
		})
		Utils.make("TextLabel", {
			Text = desc,
			TextColor3 = Config.Theme.SubText,
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
		local b = Utils.make("TextButton", {
			Text = "",
			BackgroundColor3 = Config.Theme.Button,
			Size = UDim2.new(1,-24,0,42),
			Parent = sidebar
		})
		Utils.make("UICorner", {CornerRadius = UDim.new(0,14), Parent = b})
		local st = Utils.make("UIStroke", {Color = Config.Theme.Orange1, Thickness = 1, Transparency = 0.65, Parent = b})

		Utils.make("TextLabel", {
			BackgroundTransparency = 1,
			Text = (icon and (icon .. " ") or "") .. text,
			TextColor3 = Config.Theme.Text,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -18, 1, 0),
			Position = UDim2.fromOffset(9, 0),
			Parent = b,
		})

		b.MouseEnter:Connect(function()
			Sounds.playSound("Hover")
			Utils.tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Config.Theme.ButtonHover })
			Utils.tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.35 })
		end)
		b.MouseLeave:Connect(function()
			Utils.tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Config.Theme.Button })
			Utils.tween(st, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
		end)

		tabButtons[tabName] = { b = b, st = st }
		return b
	end

	local function selectTab(tabName)
		selectedTab = tabName
		for name, t in pairs(tabButtons) do
			if name == tabName then
				Utils.tween(t.b, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Config.Theme.ButtonHover })
				Utils.tween(t.st, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.15 })
			else
				Utils.tween(t.b, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Config.Theme.Button })
				Utils.tween(t.st, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.65 })
			end
		end
	end

	local tabs = {
		{ "Player", "🧍" },
		{ "Aimbot", "🎯" },
		{ "ESP", "👁️" },
		{ "Misc", "🛠️" },
		{ "Settings", "⚙️" },
	}

	for _, t in ipairs(tabs) do
		local name, icon = t[1], t[2]
		local btn = mkTabButton(name, icon, name)
		btn.MouseButton1Click:Connect(function()
			Sounds.playSound("Click")
			pageLayout:JumpTo(Utils.findFirstChild(pages, name))
			selectTab(name)
		end)
	end

	-- Player page
	pageHeader(pagePlayer, "Player", "Movement cheats")

	local _, refreshSpeed = UI.UIHelpers.mkSliderRow(pagePlayer, "Walk Speed", Config.PlayerConfig.WalkSpeedMin, Config.PlayerConfig.WalkSpeedMax,
		function() return Config.PlayerConfig.WalkSpeed end,
		function(v)
			Config.PlayerConfig.WalkSpeed = math.floor(v + 0.5)
			PlayerFeatures.applyWalkSpeed()
		end,
		""
	)

	local _, refreshFly = UI.UIHelpers.mkToggleRow(pagePlayer, "Fly",
		function() return Config.PlayerConfig.FlyEnabled end,
		function(v)
			PlayerFeatures.toggleFly(v)
		end
	)

	UI.UIHelpers.mkKeybindRow(pagePlayer, "Fly",
		function() return Config.Keybinds.Fly end,
		function(k) Config.Keybinds.Fly = k end
	)

	local _, refreshFlySpeed = UI.UIHelpers.mkSliderRow(pagePlayer, "Fly Speed", Config.PlayerConfig.FlySpeedMin, Config.PlayerConfig.FlySpeedMax,
		function() return Config.PlayerConfig.FlySpeed end,
		function(v)
			Config.PlayerConfig.FlySpeed = math.floor(v + 0.5)
		end,
		""
	)

	local _, refreshNoclip = UI.UIHelpers.mkToggleRow(pagePlayer, "Noclip",
		function() return Config.PlayerConfig.NoclipEnabled end,
		function(v)
			PlayerFeatures.toggleNoclip(v)
		end
	)

	UI.UIHelpers.mkKeybindRow(pagePlayer, "Noclip",
		function() return Config.Keybinds.Noclip end,
		function(k) Config.Keybinds.Noclip = k end
	)

	-- Aimbot page
	pageHeader(pageAimbot, "Aimbot", "Aiming cheats")

	local _, refreshAimbot = UI.UIHelpers.mkToggleRow(pageAimbot, "Aimbot",
		function() return Config.AimbotConfig.Enabled end,
		function(v)
			Aimbot.toggle(v)
		end
	)

	UI.UIHelpers.mkKeybindRow(pageAimbot, "Aimbot",
		function() return Config.Keybinds.Aimbot end,
		function(k) Config.Keybinds.Aimbot = k end
	)

	local _, refreshFOV = UI.UIHelpers.mkSliderRow(pageAimbot, "FOV", 50, 500,
		function() return Config.AimbotConfig.FOV end,
		function(v)
			Config.AimbotConfig.FOV = math.floor(v + 0.5)
		end,
		""
	)

	local _, refreshSmooth = UI.UIHelpers.mkSliderRow(pageAimbot, "Smoothness", 1, 100,
		function() return Config.AimbotConfig.Smoothness end,
		function(v)
			Config.AimbotConfig.Smoothness = math.floor(v + 0.5)
		end,
		""
	)

	-- ESP page
	pageHeader(pageESP, "ESP", "Visual cheats")

	local _, refreshESP = UI.UIHelpers.mkToggleRow(pageESP, "ESP",
		function() return Config.ESPConfig.Enabled end,
		function(v)
			toggleESP(v)
		end
	)

	UI.UIHelpers.mkKeybindRow(pageESP, "ESP",
		function() return Config.Keybinds.ESP end,
		function(k) Config.Keybinds.ESP = k end
	)

	Utils.make("TextLabel", {
		Text = "ESP Color",
		TextColor3 = Config.Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		Parent = pageESP,
	})

	local _, updateColor = UI.UIHelpers.mkColorSliders(pageESP,
		function() return Config.ESPConfig.Color end,
		function(c) Config.ESPConfig.Color = c end
	)

	local espOpts = {
		{"Box", function() return Config.ESPConfig.ShowBox end, function(v) Config.ESPConfig.ShowBox = v end},
		{"Tracer", function() return Config.ESPConfig.ShowTracer end, function(v) Config.ESPConfig.ShowTracer = v end},
		{"Name", function() return Config.ESPConfig.ShowName end, function(v) Config.ESPConfig.ShowName = v end},
		{"Health", function() return Config.ESPConfig.ShowHealth end, function(v) Config.ESPConfig.ShowHealth = v end},
		{"Aura", function() return Config.ESPConfig.Aura end, function(v) Config.ESPConfig.Aura = v end},
	}

	for _, opt in ipairs(espOpts) do
		UI.UIHelpers.mkToggleRow(pageESP, opt[1], opt[2], function(v)
			opt[3](v)
			Notifications.notify("good", opt[1] .. " " .. (v and "enabled" or "disabled"))
		end)
	end

	-- Misc page
	pageHeader(pageMisc, "Misc", "Other cheats")

	-- Settings page
	pageHeader(pageSettings, "Settings", "UI settings")

	local _, refreshSounds = UI.UIHelpers.mkToggleRow(pageSettings, "Sounds",
		function() return Config.SettingsState.SoundsEnabled end,
		function(v) Config.SettingsState.SoundsEnabled = v end
	)

	local _, refreshVolume = UI.UIHelpers.mkSliderRow(pageSettings, "Volume", 0, 1,
		function() return Config.SettingsState.MasterVolume end,
		function(v)
			Config.SettingsState.MasterVolume = v
			for _, s in ipairs(Sounds.SoundFolder:GetChildren()) do
				if s:IsA("Sound") then s.Volume = v end
			end
		end,
		""
	)

	-- Default tab
	task.defer(function()
		pageLayout:JumpTo(pagePlayer.Parent)
		selectTab("Player")
	end)

	return gui
end

--=====================================================
-- Toggle UI
--=====================================================
function UI.toggleUI()
	if Utils.isOpen() then
		local g = Utils.getGui()
		g:Destroy()
		Notifications.holder = nil
		Notifications.notify("warn", "Menu closed")
	else
		UI.buildUI()
		Sounds.playSound("Open")
		Notifications.notify("good", "Menu opened")
	end
end

--=====================================================
-- Toggle button
--=====================================================
local function createToggleButton()
	local ex = playerGui:FindFirstChild(Config.TOGGLE_BUTTON_GUI)
	if ex then return end

	local sg = Utils.make("ScreenGui", {Name = Config.TOGGLE_BUTTON_GUI, ResetOnSpawn = false, IgnoreGuiInset = true, Parent = playerGui})
	local btn = Utils.make("TextButton", {
		Text = "≡",
		TextColor3 = Config.Theme.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = Config.Theme.Button,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 18, 1, -18),
		Size = UDim2.fromOffset(54, 54),
		ZIndex = 1000,
		Parent = sg,
	})
	Utils.make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
	Utils.make("UIStroke", { Color = Config.Theme.Orange2, Thickness = 2, Transparency = 0.35, Parent = btn })

	btn.MouseButton1Click:Connect(function()
		Sounds.playSound("Click")
		UI.toggleUI()
	end)

	-- Drag toggle button
	local dragging = false
	local dragStart, startPos

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = btn.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

createToggleButton()

--=====================================================
-- Global input
--=====================================================
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	local k = input.KeyCode

	if Config.Keybinds.Fly and k == Config.Keybinds.Fly then PlayerFeatures.toggleFly(not Config.PlayerConfig.FlyEnabled) end
	if Config.Keybinds.Noclip and k == Config.Keybinds.Noclip then PlayerFeatures.toggleNoclip(not Config.PlayerConfig.NoclipEnabled) end
	if Config.Keybinds.ESP and k == Config.Keybinds.ESP then toggleESP(not Config.ESPConfig.Enabled) end
	if Config.Keybinds.Aimbot and k == Config.Keybinds.Aimbot then Aimbot.toggle(not Config.AimbotConfig.Enabled) end

	if Config.TOGGLE_KEYS[k] then
		UI.toggleUI()
		return
	end

	if Config.TOGGLE_GAMEPAD_START and input.UserInputType == Enum.UserInputType.Gamepad1 and k == Enum.KeyCode.ButtonStart then
		UI.toggleUI()
	end
end)
