-- main.lua (LocalScript) - StarterPlayerScripts
-- Features: ESP (wallhack mode), TriggerBot, Stealthier Aimbot, Menu toggle = L

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local SoundService      = game:GetService("SoundService")
local Workspace         = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

--=====================================================
-- Config
--=====================================================
local UI_NAME = "SingularityMenu"
local TOGGLE_BUTTON_GUI = "SingularityMenu_ToggleButton"

-- Menu toggle key (L)
local MENU_TOGGLE_KEY = Enum.KeyCode.L

local TOGGLE_KEYS = {
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.RightControl] = true,
	[Enum.KeyCode.Escape] = true,
	[MENU_TOGGLE_KEY] = true,
}
local TOGGLE_GAMEPAD_START = true

local SOUND_IDS = { Open = "", Close = "", Click = "", Hover = "", Notify = "" }

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
	WalkSpeed      = 16, WalkSpeedMin = 16, WalkSpeedMax = 100,
	FlyEnabled     = false, FlySpeed = 60, FlySpeedMin = 20, FlySpeedMax = 150,
	NoclipEnabled  = false,
}

-- ESP features + Wallhack
local ESPConfig = {
	Enabled       = false,
	Color         = Color3.fromRGB(255, 80, 60),
	WallColor     = Color3.fromRGB(180, 50, 255), -- purple-ish for occluded
	ShowBox       = true,
	ShowTracer    = true,
	ShowName      = true,
	ShowHealth    = false,
	Aura          = false,
	Wallhack      = true,           -- show through walls
	WallTransparency = 0.65,        -- lower = more visible through walls
}

-- Aimbot features (stealthier)
local AimbotConfig = {
	Enabled       = false,
	Silent        = true,
	Aimlock       = false,
	AimPart       = "Head",
	FOV           = 180,
	Smoothness    = 0.38,          -- lower = faster but more obvious
	Prediction    = 0.142,
	TeamCheck     = true,
	WallCheck     = true,
	ToggleMode    = false,         -- true = toggle, false = hold
	HoldKey       = Enum.KeyCode.LeftAlt,
}

-- TriggerBot
local TriggerConfig = {
	Enabled       = false,
	Delay         = 0.02,          -- seconds between shots
	TeamCheck     = true,
	WallCheck     = true,
}

-- Keybinds
local Keybinds = {
	Fly       = nil,
	Noclip    = nil,
	ESP       = nil,
	Aimbot    = nil,
	Trigger   = nil,
}

local SettingsState = { SoundsEnabled = true, MasterVolume = 0.8 }

--=====================================================
-- Utilities + Mouse simulation for stealth aim
--=====================================================
local function make(class, props) -- unchanged
	-- ... (your make function)
end

local function tween(obj, info, props) -- unchanged
	-- ... (your tween function)
end

local function clamp(v, min, max) return math.clamp(v, min, max) end

-- Simple mouse movement simulation (stealthier than CFrame)
local function moveMouse(dx, dy)
	mousemoverel(dx, dy)
end

--=====================================================
-- TriggerBot
--=====================================================
local triggerDebounce = false

local function triggerBotLoop()
	if not TriggerConfig.Enabled or triggerDebounce then return end

	local target = mouse.Target
	if not target then return end

	local char = target:FindFirstAncestorWhichIsA("Model")
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	local plr = Players:GetPlayerFromCharacter(char)
	if not plr or (TriggerConfig.TeamCheck and plr.Team == player.Team) then return end

	-- Wall check
	if TriggerConfig.WallCheck then
		local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.Position - camera.CFrame.Position).Unit * 500)
		local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character or {}})
		if hit and hit:IsDescendantOf(char) then
			-- ok
		else
			return
		end
	end

	triggerDebounce = true
	mouse1click()
	task.delay(TriggerConfig.Delay, function() triggerDebounce = false end)
end

RunService.Heartbeat:Connect(triggerBotLoop)

local function toggleTrigger(v)
	TriggerConfig.Enabled = v
	notify(v and "good" or "warn", "TriggerBot " .. (v and "ON" or "OFF"))
end

--=====================================================
-- ESP - Wallhack mode
--=====================================================
local ESP = { espObjects = {}, conn = nil }

local function createESP(plr)
	if ESP.espObjects[plr] or plr == player then return end

	local box = Drawing.new("Square")
	box.Thickness = 1.4
	box.Filled = false
	box.Transparency = 1
	box.Visible = false

	local tracer = Drawing.new("Line")
	tracer.Thickness = 1
	tracer.Transparency = 1
	tracer.Visible = false

	local nameTxt = Drawing.new("Text")
	nameTxt.Size = 13
	nameTxt.Center = true
	nameTxt.Outline = true
	nameTxt.Visible = false

	local healthTxt = Drawing.new("Text")
	healthTxt.Size = 12
	healthTxt.Center = true
	healthTxt.Outline = true
	healthTxt.Visible = false

	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 0.7
	highlight.OutlineTransparency = 0.3
	highlight.Enabled = false

	ESP.espObjects[plr] = {
		box = box, tracer = tracer, name = nameTxt, health = healthTxt, highlight = highlight
	}
end

local function updateESP()
	for plr, data in pairs(ESP.espObjects) do
		local char = plr.Character
		if not char then continue end

		local root = char:FindFirstChild("HumanoidRootPart")
		local hum   = char:FindFirstChild("Humanoid")
		local head  = char:FindFirstChild("Head")
		if not root or not hum or hum.Health <= 0 then
			data.box.Visible = false
			data.tracer.Visible = false
			data.name.Visible = false
			data.health.Visible = false
			data.highlight.Enabled = false
			continue
		end

		local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
		if not onScreen then
			data.box.Visible = false
			data.tracer.Visible = false
			data.name.Visible = false
			data.health.Visible = false
			data.highlight.Enabled = false
			continue
		end

		local visible = ESPConfig.Enabled
		local occluded = false

		-- Wallhack check
		if ESPConfig.Wallhack then
			local ray = Ray.new(camera.CFrame.Position, (root.Position - camera.CFrame.Position).Unit * 999)
			local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character or {}})
			if hit and not hit:IsDescendantOf(char) then
				occluded = true
			end
		end

		local col = occluded and ESPConfig.WallColor or ESPConfig.Color
		local trans = occluded and ESPConfig.WallTransparency or 1

		data.box.Visible       = visible and ESPConfig.ShowBox
		data.tracer.Visible    = visible and ESPConfig.ShowTracer
		data.name.Visible      = visible and ESPConfig.ShowName
		data.health.Visible    = visible and ESPConfig.ShowHealth
		data.highlight.Enabled = visible and ESPConfig.Aura

		if visible then
			-- Box
			local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.6,0))
			local legPos  = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3.5,0))
			local size    = Vector2.new(math.abs(headPos.X - legPos.X)*2.2, math.abs(headPos.Y - legPos.Y)*1.1)

			data.box.Size     = size
			data.box.Position = Vector2.new(rootPos.X - size.X/2, rootPos.Y - size.Y/2)
			data.box.Color    = col
			data.box.Transparency = trans

			-- Tracer
			data.tracer.From  = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
			data.tracer.To    = Vector2.new(rootPos.X, rootPos.Y)
			data.tracer.Color = col
			data.tracer.Transparency = trans

			-- Name & Health
			data.name.Text     = plr.Name
			data.name.Position = Vector2.new(rootPos.X, rootPos.Y - size.Y/2 - 18)
			data.name.Color    = col
			data.name.Transparency = trans

			data.health.Text   = math.floor(hum.Health).."/"..hum.MaxHealth
			data.health.Position = Vector2.new(rootPos.X + size.X/2 + 6, rootPos.Y - size.Y/2)
			data.health.Color  = Color3.fromHSV(hum.Health/hum.MaxHealth * 0.33, 1, 1)
			data.health.Transparency = trans

			-- Aura (Highlight)
			data.highlight.Adornee     = char
			data.highlight.FillColor   = col
			data.highlight.OutlineColor = col
		end
	end
end

local function toggleESP(v)
	ESPConfig.Enabled = v
	notify(v and "good" or "warn", "ESP "..(v and "enabled" or "disabled"))

	if v then
		for _, p in Players:GetPlayers() do if p ~= player then createESP(p) end end
		ESP.conn = RunService.RenderStepped:Connect(updateESP)
	else
		if ESP.conn then ESP.conn:Disconnect() ESP.conn = nil end
		for p in pairs(ESP.espObjects) do
			local d = ESP.espObjects[p]
			d.box:Remove()
			d.tracer:Remove()
			d.name:Remove()
			d.health:Remove()
			if d.highlight then d.highlight:Destroy() end
		end
		ESP.espObjects = {}
	end
end

Players.PlayerAdded:Connect(function(p)
	if ESPConfig.Enabled and p ~= player then createESP(p) end
end)

Players.PlayerRemoving:Connect(function(p)
	if ESP.espObjects[p] then
		local d = ESP.espObjects[p]
		d.box:Remove() d.tracer:Remove() d.name:Remove() d.health:Remove()
		if d.highlight then d.highlight:Destroy() end
		ESP.espObjects[p] = nil
	end
end)

for _, p in Players:GetPlayers() do
	if p ~= player then createESP(p) end
end

--=====================================================
-- Stealthier Aimbot + Trigger integration
--=====================================================
local aimTarget = nil
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Radius = AimbotConfig.FOV
fovCircle.Color = Color3.fromRGB(220, 60, 90)
fovCircle.Transparency = 0.9
fovCircle.Filled = false
fovCircle.Visible = false

local function isValidTarget(targPlayer)
	if not targPlayer or targPlayer == player then return false end
	if AimbotConfig.TeamCheck and targPlayer.Team == player.Team then return false end

	local char = targPlayer.Character
	if not char then return false end

	local part = char:FindFirstChild(AimbotConfig.AimPart) or char:FindFirstChild("HumanoidRootPart")
	if not part then return false end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end

	if AimbotConfig.WallCheck then
		local origin = camera.CFrame.Position
		local dir = (part.Position - origin)
		local raycast = Workspace:Raycast(origin, dir.Unit * dir.Magnitude, RaycastParams.new({
			FilterDescendantsInstances = {player.Character or {}},
			FilterType = Enum.RaycastFilterType.Blacklist
		}))
		if raycast and raycast.Instance:IsDescendantOf(char) then
			-- visible
		else
			return false
		end
	end

	return true, part
end

local function getClosestToCrosshair()
	local closestDist = AimbotConfig.FOV
	local closestPart = nil

	for _, p in Players:GetPlayers() do
		local valid, part = isValidTarget(p)
		if not valid then continue end

		local screen, onScr = camera:WorldToViewportPoint(part.Position)
		if not onScr then continue end

		local dist = (Vector2.new(screen.X, screen.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
		if dist < closestDist then
			closestDist = dist
			closestPart = part
			aimTarget = p
		end
	end

	return closestPart
end

RunService.RenderStepped:Connect(function(dt)
	fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
	fovCircle.Radius = AimbotConfig.FOV
	fovCircle.Visible = AimbotConfig.Enabled

	if not AimbotConfig.Enabled then
		aimTarget = nil
		return
	end

	local pressing = AimbotConfig.ToggleMode and AimbotConfig.Enabled or UserInputService:IsKeyDown(AimbotConfig.HoldKey)

	if pressing then
		local targetPart = getClosestToCrosshair()

		if targetPart then
			local predPos = targetPart.Position + (targetPart.Velocity * AimbotConfig.Prediction)

			if AimbotConfig.Silent then
				-- Silent aim - move mouse very slightly toward target (stealth)
				local screenPos = camera:WorldToViewportPoint(predPos)
				local delta = Vector2.new(screenPos.X - mouse.X, screenPos.Y - mouse.Y)
				local moveAmount = delta * (1 - AimbotConfig.Smoothness) * 0.6
				mousemoverel(moveAmount.X, moveAmount.Y)
			end

			if AimbotConfig.Aimlock then
				-- Visible camera aim (less stealthy)
				local targetCFrame = CFrame.new(camera.CFrame.Position, predPos)
				camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1 - AimbotConfig.Smoothness)
			end
		end
	else
		aimTarget = nil
	end
end)

local function toggleAimbot(v)
	AimbotConfig.Enabled = v
	notify(v and "good" or "warn", "Aimbot "..(v and "ON" or "OFF"))
end

--=====================================================
-- UI Updates (add Trigger & update Aimbot page)
--=====================================================
-- In buildUI() function, update Aimbot page:

-- Aimbot page
pageHeader(pageAimbot, "Aimbot", "Silent / Aimlock / Trigger")

do
	local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageAimbot})
	make("UIListLayout", {Padding = UDim.new(0,10), Parent = list})

	mkToggleRow(list, "Aimbot Enabled", function() return AimbotConfig.Enabled end, toggleAimbot)
	mkKeybindRow(list, "Aimbot", function() return Keybinds.Aimbot end, function(k) Keybinds.Aimbot = k end)

	mkToggleRow(list, "Silent Aim", function() return AimbotConfig.Silent end,
		function(v) AimbotConfig.Silent = v end)

	mkToggleRow(list, "Aimlock (Camera)", function() return AimbotConfig.Aimlock end,
		function(v) AimbotConfig.Aimlock = v end)

	mkToggleRow(list, "Toggle Mode (not hold)", function() return AimbotConfig.ToggleMode end,
		function(v) AimbotConfig.ToggleMode = v end)

	mkSliderRow(list, "FOV", 40, 600, function() return AimbotConfig.FOV end,
		function(v) AimbotConfig.FOV = math.floor(v) end)

	mkSliderRow(list, "Smoothness", 0.05, 0.9, function() return AimbotConfig.Smoothness end,
		function(v) AimbotConfig.Smoothness = v end)

	mkSliderRow(list, "Prediction", 0, 0.25, function() return AimbotConfig.Prediction end,
		function(v) AimbotConfig.Prediction = v end)
end

-- Add TriggerBot to Misc or Aimbot tab (here in Misc for example)
pageHeader(pageMisc, "Misc", "TriggerBot & more")

do
	local list = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=pageMisc})
	make("UIListLayout", {Padding = UDim.new(0,12), Parent = list})

	mkToggleRow(list, "TriggerBot", function() return TriggerConfig.Enabled end, toggleTrigger)
	mkKeybindRow(list, "Trigger", function() return Keybinds.Trigger end, function(k) Keybinds.Trigger = k end)

	mkSliderRow(list, "Trigger Delay", 0.01, 0.15,
		function() return TriggerConfig.Delay end,
		function(v) TriggerConfig.Delay = v end, " sec")

	mkToggleRow(list, "Trigger Team Check", function() return TriggerConfig.TeamCheck end,
		function(v) TriggerConfig.TeamCheck = v end)

	mkToggleRow(list, "Trigger Wall Check", function() return TriggerConfig.WallCheck end,
		function(v) TriggerConfig.WallCheck = v end)
end

--=====================================================
-- Keybinds listener - updated for L
--=====================================================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local k = input.KeyCode

	-- Custom L key handling
	if k == MENU_TOGGLE_KEY then
		toggleUI()
		return
	end

	if Keybinds.Fly    and k == Keybinds.Fly    then toggleFly(not PlayerConfig.FlyEnabled) end
	if Keybinds.Noclip and k == Keybinds.Noclip then toggleNoclip(not PlayerConfig.NoclipEnabled) end
	if Keybinds.ESP    and k == Keybinds.ESP    then toggleESP(not ESPConfig.Enabled) end
	if Keybinds.Aimbot and k == Keybinds.Aimbot then toggleAimbot(not AimbotConfig.Enabled) end
	if Keybinds.Trigger and k == Keybinds.Trigger then toggleTrigger(not TriggerConfig.Enabled) end

	for tk in pairs(TOGGLE_KEYS) do
		if k == tk then toggleUI() return end
	end

	if TOGGLE_GAMEPAD_START and input.UserInputType == Enum.UserInputType.Gamepad1 and k == Enum.KeyCode.ButtonStart then
		toggleUI()
	end
end)

-- [Rest of your code - openUI, closeUI, createToggleButton, etc. remains unchanged]
