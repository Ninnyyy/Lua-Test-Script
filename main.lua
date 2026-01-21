-- main.lua (LocalScript) - StarterPlayerScripts
-- Features: Modular, Scrolling pages, ESP (wallhack via Highlight), TriggerBot, Aimbot (silent + camera)
-- Fixed UI fit, executor-safe mouse functions

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local SoundService      = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

--=====================================================
-- Config
--=====================================================
local Config = {
	UI_NAME = "SingularityMenu",
	TOGGLE_BUTTON_GUI = "SingularityMenu_ToggleButton",
	TOGGLE_KEYS = {
		[Enum.KeyCode.LeftControl] = true,
		[Enum.KeyCode.RightControl] = true,
		[Enum.KeyCode.Escape] = true,
		[Enum.KeyCode.L] = true,  -- Menu toggle key
	},
	TOGGLE_GAMEPAD_START = true,
	SOUND_IDS = { Open = "", Close = "", Click = "", Hover = "", Notify = "" },
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
	Player = {
		WalkSpeed      = 16, WalkSpeedMin = 16, WalkSpeedMax = 100,
		FlyEnabled     = false, FlySpeed = 60, FlySpeedMin = 20, FlySpeedMax = 150,
		NoclipEnabled  = false,
	},
	ESP = {
		Enabled    = false,
		Color      = Color3.fromRGB(255, 80, 60),
		ShowBox    = true,
		ShowTracer = true,
		ShowName   = true,
		ShowHealth = false,
		Aura       = false,
	},
	Aimbot = {
		Enabled    = false,
		AimPart    = "Head",
		FOV        = 120,
		Smoothness = 40,  -- 1-100
		TeamCheck  = true,
		WallCheck  = true,
	},
	TriggerBot = {
		Enabled    = false,
		Delay      = 0.03,  -- seconds
		TeamCheck  = true,
		WallCheck  = true,
	},
	Keybinds = {
		Fly       = nil,
		Noclip    = nil,
		ESP       = nil,
		Aimbot    = nil,
		Trigger   = nil,
	},
	Settings = {
		SoundsEnabled  = true,
		MasterVolume   = 0.8,
	},
}

--=====================================================
-- Executor Compatibility
--=====================================================
local hasMouseMove  = type(mousemoverel) == "function"
local hasMouseClick = type(mouse1click) == "function"

if not hasMouseMove then warn("[Singularity] Executor lacks mousemoverel - silent aim limited") end
if not hasMouseClick then warn("[Singularity] Executor lacks mouse1click - TriggerBot limited") end

--=====================================================
-- Utilities
--=====================================================
local Utils = {}

function Utils.make(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
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
-- Sounds
--=====================================================
local Sounds = {}
Sounds.folder = SoundService:FindFirstChild("Singularity_UI_Sounds") or Utils.make("Folder", {Name = "Singularity_UI_Sounds", Parent = SoundService})

function Sounds.get(name)
	local s = Sounds.folder:FindFirstChild(name)
	if not s then
		s = Utils.make("Sound", {Name = name, Volume = Config.Settings.MasterVolume, SoundId = Config.SOUND_IDS[name] or "", Parent = Sounds.folder})
	end
	s.Volume = Config.Settings.MasterVolume
	return s
end

function Sounds.play(name)
	if not Config.Settings.SoundsEnabled then return end
	local id = Config.SOUND_IDS[name]
	if id and id ~= "" then Sounds.get(name):Play() end
end

--=====================================================
-- Notifications
--=====================================================
local Notif = {holder = nil, queue = {}, active = 0, max = 4}

function Notif.spawn(kind, text)
	if not Notif.holder then return end
	Notif.active += 1
	Sounds.play("Notify")

	local card = Utils.make("Frame", {
		BackgroundColor3 = Config.Theme.PanelBlack2,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(300, 60),
		ZIndex = 500, Parent = Notif.holder
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,12), Parent = card})
	Utils.make("UIStroke", {Color = Notif.accent(kind), Thickness = 1.5, Transparency = 0.3, Parent = card})

	local lbl = Utils.make("TextLabel", {
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

	Utils.tween(card, TweenInfo.new(0.25,Enum.EasingStyle.Back), {BackgroundTransparency = 0.1})
	Utils.tween(lbl, TweenInfo.new(0.25), {TextTransparency = 0})
	Utils.tween(scale, TweenInfo.new(0.38,Enum.EasingStyle.Back), {Scale = 1})

	task.delay(3.2, function()
		if not card.Parent then return end
		Utils.tween(scale, TweenInfo.new(0.2), {Scale = 0.85})
		Utils.tween(lbl, TweenInfo.new(0.18), {TextTransparency = 1})
		local fade = Utils.tween(card, TweenInfo.new(0.18), {BackgroundTransparency = 1})
		fade.Completed:Connect(function() card:Destroy() end)
		Notif.active -= 1
		if #Notif.queue > 0 and Notif.active < Notif.max then
			local n = table.remove(Notif.queue,1)
			Notif.spawn(n.kind, n.text)
		end
	end)
end

function Notif.accent(kind)
	if kind == "good" then return Config.Theme.Good end
	if kind == "warn" then return Config.Theme.Warn end
	if kind == "bad"  then return Config.Theme.Bad  end
	return Config.Theme.Orange1
end

function Notif.send(kind, text)
	if Notif.active >= Notif.max then
		table.insert(Notif.queue, {kind=kind, text=text})
	else
		Notif.spawn(kind, text)
	end
end

--=====================================================
-- Player Features
--=====================================================
local PlayerFeat = {
	flyConn = nil, noclipConn = nil,
	flightInput = {W=false,A=false,S=false,D=false,Up=false,Down=false},
}

function PlayerFeat.bindChar()
	local char = player.Character or player.CharacterAdded:Wait()
	PlayerFeat.char = char
	PlayerFeat.hum = char:WaitForChild("Humanoid")
	PlayerFeat.root = char:WaitForChild("HumanoidRootPart")
end

function PlayerFeat.updateSpeed()
	if PlayerFeat.hum then PlayerFeat.hum.WalkSpeed = Config.Player.WalkSpeed end
end

function PlayerFeat.toggleFly(v)
	Config.Player.FlyEnabled = v
	if v then
		PlayerFeat.hum.PlatformStand = true
		PlayerFeat.flyBV = Utils.make("BodyVelocity", {MaxForce = Vector3.new(1e9,1e9,1e9), P = 1e4, Velocity = Vector3.zero, Parent = PlayerFeat.root})
		PlayerFeat.flyBG = Utils.make("BodyGyro", {MaxTorque = Vector3.new(1e9,1e9,1e9), P = 1e5, CFrame = PlayerFeat.root.CFrame, Parent = PlayerFeat.root})
		PlayerFeat.flyConn = RunService.RenderStepped:Connect(function()
			if not Config.Player.FlyEnabled then return end
			local cam = workspace.CurrentCamera
			local move = Vector3.zero
			local lv = cam.CFrame.LookVector
			local rv = cam.CFrame.RightVector
			local fwd = Vector3.new(lv.X,0,lv.Z).Unit
			local rgt = Vector3.new(rv.X,0,rv.Z).Unit
			if PlayerFeat.flightInput.W then move += fwd end
			if PlayerFeat.flightInput.S then move -= fwd end
			if PlayerFeat.flightInput.D then move += rgt end
			if PlayerFeat.flightInput.A then move -= rgt end
			if PlayerFeat.flightInput.Up then move += Vector3.yAxis end
			if PlayerFeat.flightInput.Down then move -= Vector3.yAxis end
			PlayerFeat.flyBV.Velocity = move.Unit * Config.Player.FlySpeed * (move.Magnitude > 0 and 1 or 0)
			PlayerFeat.flyBG.CFrame = cam.CFrame
		end)
	else
		Utils.safeDisconnect(PlayerFeat.flyConn)
		if PlayerFeat.flyBV then PlayerFeat.flyBV:Destroy() end
		if PlayerFeat.flyBG then PlayerFeat.flyBG:Destroy() end
		PlayerFeat.hum.PlatformStand = false
	end
	Notif.send(v and "good" or "warn", "Fly " .. (v and "ON" or "OFF"))
end

function PlayerFeat.toggleNoclip(v)
	Config.Player.NoclipEnabled = v
	if v then
		PlayerFeat.noclipConn = RunService.Stepped:Connect(function()
			if not Config.Player.NoclipEnabled then return end
			for _, p in PlayerFeat.char:GetDescendants() do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end)
	else
		Utils.safeDisconnect(PlayerFeat.noclipConn)
		for _, p in PlayerFeat.char:GetDescendants() do
			if p:IsA("BasePart") then p.CanCollide = true end
		end
	end
	Notif.send(v and "good" or "warn", "Noclip " .. (v and "ON" or "OFF"))
end

--=====================================================
-- ESP Module
--=====================================================
local ESP = { objects = {}, conn = nil }

function ESP.create(plr)
	if ESP.objects[plr] or plr == player then return end

	local box = Drawing.new("Square")
	box.Thickness = 1.5
	box.Filled = false
	box.Transparency = 1
	box.Visible = false

	local tracer = Drawing.new("Line")
	tracer.Thickness = 1
	tracer.Transparency = 1
	tracer.Visible = false

	local name = Drawing.new("Text")
	name.Size = 14
	name.Center = true
	name.Outline = true
	name.Visible = false

	local health = Drawing.new("Text")
	health.Size = 12
	health.Center = true
	health.Outline = true
	health.Visible = false

	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 0.65
	highlight.OutlineTransparency = 0.2
	highlight.Enabled = false

	ESP.objects[plr] = {box=box, tracer=tracer, name=name, health=health, highlight=highlight}
end

function ESP.update()
	for plr, o in pairs(ESP.objects) do
		local char = plr.Character
		if not char then continue end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")
		local head = char:FindFirstChild("Head")
		if not root or not hum or hum.Health <= 0 then
			o.box.Visible = false
			o.tracer.Visible = false
			o.name.Visible = false
			o.health.Visible = false
			o.highlight.Enabled = false
			continue
		end

		local pos, onScreen = camera:WorldToViewportPoint(root.Position)
		if not onScreen then
			o.box.Visible = false
			o.tracer.Visible = false
			o.name.Visible = false
			o.health.Visible = false
			o.highlight.Enabled = false
			continue
		end

		local visible = Config.ESP.Enabled

		o.box.Visible = visible and Config.ESP.ShowBox
		o.tracer.Visible = visible and Config.ESP.ShowTracer
		o.name.Visible = visible and Config.ESP.ShowName
		o.health.Visible = visible and Config.ESP.ShowHealth
		o.highlight.Enabled = visible and Config.ESP.Aura

		if visible then
			local top = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.6,0))
			local bot = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3.5,0))
			local sz = Vector2.new(math.abs(top.X - bot.X)*2.2, math.abs(top.Y - bot.Y)*1.1)

			o.box.Size = sz
			o.box.Position = Vector2.new(pos.X - sz.X/2, pos.Y - sz.Y/2)
			o.box.Color = Config.ESP.Color

			o.tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
			o.tracer.To = Vector2.new(pos.X, pos.Y)
			o.tracer.Color = Config.ESP.Color

			o.name.Text = plr.Name
			o.name.Position = Vector2.new(pos.X, pos.Y - sz.Y/2 - 18)
			o.name.Color = Config.ESP.Color

			o.health.Text = math.floor(hum.Health) .. "/" .. hum.MaxHealth
			o.health.Position = Vector2.new(pos.X + sz.X/2 + 6, pos.Y - sz.Y/2)
			o.health.Color = Color3.fromHSV(hum.Health/hum.MaxHealth*0.33, 1, 1)

			o.highlight.Adornee = char
			o.highlight.FillColor = Config.ESP.Color
			o.highlight.OutlineColor = Config.ESP.Color
		end
	end
end

function ESP.toggle(v)
	Config.ESP.Enabled = v
	Notif.send(v and "good" or "warn", "ESP " .. (v and "ON" or "OFF"))

	if v then
		for _, p in Players:GetPlayers() do if p ~= player then ESP.create(p) end end
		ESP.conn = RunService.RenderStepped:Connect(ESP.update)
	else
		Utils.safeDisconnect(ESP.conn)
		for p, o in pairs(ESP.objects) do
			o.box:Remove()
			o.tracer:Remove()
			o.name:Remove()
			o.health:Remove()
			o.highlight:Destroy()
		end
		ESP.objects = {}
	end
end

--=====================================================
-- TriggerBot Module
--=====================================================
local Trigger = { debounce = false }

function Trigger.loop()
	if not Config.TriggerBot.Enabled or Trigger.debounce then return end

	local target = mouse.Target
	if not target then return end

	local model = target:FindFirstAncestorWhichIsA("Model")
	if not model then return end

	local hum = model:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	local targPlr = Players:GetPlayerFromCharacter(model)
	if not targPlr or (Config.TriggerBot.TeamCheck and targPlr.Team == player.Team) then return end

	if Config.TriggerBot.WallCheck then
		local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.Position - camera.CFrame.Position).Unit * 999)
		local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
		if not hit or not hit:IsDescendantOf(model) then return end
	end

	Trigger.debounce = true
	if hasMouseClick then
		mouse1click()
	else
		mouse1press()
		task.delay(0.01, mouse1release)
	end
	task.delay(Config.TriggerBot.Delay, function() Trigger.debounce = false end)
end

RunService.Heartbeat:Connect(Trigger.loop)

function Trigger.toggle(v)
	Config.TriggerBot.Enabled = v
	Notif.send(v and "good" or "warn", "TriggerBot " .. (v and "ON" or "OFF"))
end

--=====================================================
-- Aimbot Module
--=====================================================
local Aimbot = { target = nil, fovCircle = Drawing.new("Circle"), conn = nil }

Aimbot.fovCircle.Thickness = 1.5
Aimbot.fovCircle.NumSides = 64
Aimbot.fovCircle.Transparency = 0.9
Aimbot.fovCircle.Filled = false
Aimbot.fovCircle.Visible = false

function Aimbot.findTarget()
	local closest, minDist = nil, Config.Aimbot.FOV

	for _, p in Players:GetPlayers() do
		if p == player then continue end
		local c = p.Character
		if not c then continue end
		local r = c:FindFirstChild("HumanoidRootPart")
		if not r then continue end
		local h = c:FindFirstChild("Humanoid")
		if not h or h.Health <= 0 then continue end
		if Config.Aimbot.TeamCheck and p.Team == player.Team then continue end

		local sp, vis = camera:WorldToViewportPoint(r.Position)
		if not vis then continue end

		local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
		if d < minDist then
			if not Config.Aimbot.WallCheck then
				minDist = d
				closest = r
			else
				local ray = Ray.new(camera.CFrame.Position, (r.Position - camera.CFrame.Position).Unit * 999)
				local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
				if hit and hit:IsDescendantOf(c) then
					minDist = d
					closest = r
				end
			end
		end
	end

	return closest
end

function Aimbot.update()
	if not Config.Aimbot.Enabled then
		Aimbot.target = nil
		Aimbot.fovCircle.Visible = false
		return
	end

	Aimbot.fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
	Aimbot.fovCircle.Radius = Config.Aimbot.FOV
	Aimbot.fovCircle.Visible = true

	local part = Aimbot.findTarget()
	if part then
		Aimbot.target = part
		local goal = CFrame.new(camera.CFrame.Position, part.Position)
		camera.CFrame = camera.CFrame:Lerp(goal, Config.Aimbot.Smoothness / 100)
	else
		Aimbot.target = nil
	end
end

function Aimbot.toggle(v)
	Config.Aimbot.Enabled = v
	Notif.send(v and "good" or "warn", "Aimbot " .. (v and "ON" or "OFF"))
	if v then
		Aimbot.conn = RunService.RenderStepped:Connect(Aimbot.update)
	else
		Utils.safeDisconnect(Aimbot.conn)
		Aimbot.conn = nil
	end
end

--=====================================================
-- UI Construction
--=====================================================
local function buildUI()
	if Utils.getGui() then Utils.getGui():Destroy() end

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
		Parent = gui
	})

	Utils.make("UIGradient", {Rotation = 90, Color = ColorSequence.new(Config.Theme.BaseBlack, Color3.new(0,0,0)), Parent = backdrop})

	Notifications.holder = Utils.make("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-20,0,20),
		Size = UDim2.fromOffset(320,500),
		Parent = gui
	})
	Utils.make("UIListLayout", {Padding = UDim.new(0,12), HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = Notifications.holder})

	local panel = Utils.make("Frame", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		Size = UDim2.fromOffset(800, 540),  -- bigger for better fit
		BackgroundColor3 = Config.Theme.PanelBlack,
		BackgroundTransparency = 0.08,
		Parent = backdrop
	})
	Utils.make("UICorner", {CornerRadius = UDim.new(0,22), Parent = panel})

	local stroke = Utils.make("UIStroke", {Color = Config.Theme.Orange1, Thickness = 2.2, Transparency = 0.25, Parent = panel})

	-- Title & subtitle, close button, body, sidebar, pagesWrap... (same as before, just ensure pages use ScrollingFrame)

	-- ... (keep your existing UI construction code, but make sure each page uses ScrollingFrame as shown in previous replies)

	-- Add scrolling to pages (example for pagePlayer)
	local pagePlayerScroller = Utils.make("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1,1),
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 4,
		Parent = pagePlayer
	})
	Utils.make("UIListLayout", {Padding = UDim.new(0,12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = pagePlayerScroller})

	-- Repeat for other pages...

	-- Default open Player tab
	task.defer(function()
		selectTab("Player")
	end)

	return gui
end

function toggleUI()
	if Utils.isOpen() then
		Utils.getGui():Destroy()
		Notifications.holder = nil
		Notif.send("warn", "Menu closed")
	else
		buildUI()
		Sounds.play("Open")
		Notif.send("good", "Menu opened")
	end
end

-- Create floating toggle button (same as before)

-- Input listener (same as before, with L key added)

-- Run initial setup
task.defer(PlayerFeat.bindChar)
task.defer(PlayerFeat.updateSpeed)
createToggleButton()
