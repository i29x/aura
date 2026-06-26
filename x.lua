local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local Gui = {}
local Functions = {}

local OptionConfig = {
	Window = {
		Title = "axi",
		Subtitle = "on top"
	},
	Assets = {
		Logo = "rbxassetid://137296929509496",
		DominationIcon = "rbxthumb://type=Asset&id=83399776429635&w=150&h=150",
		PlayersIcon = "rbxthumb://type=Asset&id=127295787879229&w=150&h=150",
		AbyssIcon = "rbxthumb://type=Asset&id=122862993469061&w=150&h=150",
		SettingsIcon = "rbxthumb://type=Asset&id=109264660442602&w=150&h=150"
	},
	Tabs = {
		{
			Name = "Domination",
			Icon = "rbxthumb://type=Asset&id=83399776429635&w=150&h=150",
			Color = Color3.fromRGB(255, 74, 96),
			Sections = {
				{
					Name = "silent aim",
					Description = "Shiftlock FOV lock settings",
					Options = {
						{Type = "toggle", Name = "silent aim", Description = "Enable enemy FOV lock", Callback = "SetAutoXD", Default = false},
						{Type = "toggle", Name = "Show FOV", Description = "Show or hide FOV circle", Callback = "SetAutoXDFOVVisible", Default = false},
						{Type = "slider", Name = "FOV Size", Callback = "SetAutoXDFOV", Min = 50, Max = 500, Default = 155},
						{Type = "slider", Name = "Lock Strength", Callback = "SetAutoXDSmooth", Min = 5, Max = 100, Default = 42}
					}
				},
				{
					Name = "FOV Color",
					Description = "Customize the FOV circle color",
					Options = {
						{Type = "slider", Name = "Red", Callback = "SetAutoXDFOVRed", Min = 0, Max = 255, Default = 255},
						{Type = "slider", Name = "Green", Callback = "SetAutoXDFOVGreen", Min = 0, Max = 255, Default = 255},
						{Type = "slider", Name = "Blue", Callback = "SetAutoXDFOVBlue", Min = 0, Max = 255, Default = 255}
					}
				},
				{
					Name = "Main options",
					Description = "aim features",
					Options = {
						{Type = "toggle", Name = "autofire", Description = "Toggle silent aim auto fire", Callback = "SetOK", Default = false, Half = true},
						{Type = "toggle", Name = "anti ban", Description = "Toggle anti ban", Callback = "SetLOC", Default = false, Half = true}
					}
				},
				{
					Name = "Movement",
					Description = "Speed options",
					Options = {
						{Type = "toggle", Name = "Speed", Description = "Enable custom walkspeed", Callback = "SetSpeed", Default = false},
						{Type = "slider", Name = "Speed Amount", Callback = "SetSpeedValue", Min = 16, Max = 200, Default = 16},
						{Type = "toggle", Name = "Jump Power", Description = "Enable custom jump power", Callback = "SetJumpPower", Default = false},
						{Type = "slider", Name = "Jump Amount", Callback = "SetJumpPowerValue", Min = 50, Max = 250, Default = 50}
					}
				},
				{
					Name = "Extra",
					Description = "teleport to enemy/teammate can be useful",
					Options = {
						{Type = "button", Name = "TP Closest Enemy", Description = "Teleport to closest enemy", Callback = "ExtraSlotOne"},
						{Type = "button", Name = "TP Closest Teammate", Description = "Teleport to closest teammate", Callback = "ExtraSlotTwo"}
					}
				}
			}
		},
		{
			Name = "Players",
			Icon = "rbxthumb://type=Asset&id=127295787879229&w=150&h=150",
			Color = Color3.fromRGB(75, 158, 255),
			Sections = {
				{
					Name = "Players",
					Description = "Player esp options",
					Options = {
						{Type = "toggle", Name = "Enable Highlight Team", Description = "Separated highlight team function", Callback = "SetTeamHighlight", Default = false},
						{Type = "textbox", Name = "Copy Avatar", Description = "Put username and copy avatar", Placeholder = "Username", ButtonText = "Change", Callback = "CopyAvatar"},
						{Type = "button", Name = "Reset Avatar", Description = "Reset your avatar back", Callback = "ResetAvatar"}
					}
				},
				{
					Name = "Team Highlight RGB",
					Description = "Custom team esp color",
					Options = {
						{Type = "slider", Name = "Team Red", Callback = "SetTeamHighlightRed", Min = 0, Max = 255, Default = 0},
						{Type = "slider", Name = "Team Green", Callback = "SetTeamHighlightGreen", Min = 0, Max = 255, Default = 120},
						{Type = "slider", Name = "Team Blue", Callback = "SetTeamHighlightBlue", Min = 0, Max = 255, Default = 255}
					}
				},
				{
					Name = "Team Color Presets",
					Description = "Fast colors for team esp",
					Options = {
						{Type = "button", Name = "Team Red", Description = "Set team highlight to red", Callback = "TeamColorRed", Half = true},
						{Type = "button", Name = "Team Blue", Description = "Set team highlight to blue", Callback = "TeamColorBlue", Half = true},
						{Type = "button", Name = "Team Green", Description = "Set team highlight to green", Callback = "TeamColorGreen", Half = true},
						{Type = "button", Name = "Team Yellow", Description = "Set team highlight to yellow", Callback = "TeamColorYellow", Half = true},
						{Type = "button", Name = "Team Purple", Description = "Set team highlight to purple", Callback = "TeamColorPurple", Half = true},
						{Type = "button", Name = "Team Pink", Description = "Set team highlight to pink", Callback = "TeamColorPink", Half = true},
						{Type = "button", Name = "Team Cyan", Description = "Set team highlight to cyan", Callback = "TeamColorCyan", Half = true},
						{Type = "button", Name = "Team White", Description = "Set team highlight to white", Callback = "TeamColorWhite", Half = true},
						{Type = "toggle", Name = "Team Rainbow", Description = "Rainbow team highlight", Callback = "SetTeamRainbow", Default = false}
					}
				},
				{
					Name = "Enemy Highlight RGB",
					Description = "Custom enemy esp color",
					Options = {
						{Type = "slider", Name = "Enemy Red", Callback = "SetEnemyHighlightRed", Min = 0, Max = 255, Default = 255},
						{Type = "slider", Name = "Enemy Green", Callback = "SetEnemyHighlightGreen", Min = 0, Max = 255, Default = 0},
						{Type = "slider", Name = "Enemy Blue", Callback = "SetEnemyHighlightBlue", Min = 0, Max = 255, Default = 0}
					}
				},
				{
					Name = "Enemy Color Presets",
					Description = "Fast colors for enemy esp",
					Options = {
						{Type = "button", Name = "Enemy Red", Description = "Set enemy highlight to red", Callback = "EnemyColorRed", Half = true},
						{Type = "button", Name = "Enemy Blue", Description = "Set enemy highlight to blue", Callback = "EnemyColorBlue", Half = true},
						{Type = "button", Name = "Enemy Green", Description = "Set enemy highlight to green", Callback = "EnemyColorGreen", Half = true},
						{Type = "button", Name = "Enemy Yellow", Description = "Set enemy highlight to yellow", Callback = "EnemyColorYellow", Half = true},
						{Type = "button", Name = "Enemy Purple", Description = "Set enemy highlight to purple", Callback = "EnemyColorPurple", Half = true},
						{Type = "button", Name = "Enemy Pink", Description = "Set enemy highlight to pink", Callback = "EnemyColorPink", Half = true},
						{Type = "button", Name = "Enemy Cyan", Description = "Set enemy highlight to cyan", Callback = "EnemyColorCyan", Half = true},
						{Type = "button", Name = "Enemy White", Description = "Set enemy highlight to white", Callback = "EnemyColorWhite", Half = true},
						{Type = "toggle", Name = "Enemy Rainbow", Description = "Rainbow enemy highlight", Callback = "SetEnemyRainbow", Default = false}
					}
				}
			}
		},
		{
			Name = "Abyss",
			Icon = "rbxthumb://type=Asset&id=122862993469061&w=150&h=150",
			Color = Color3.fromRGB(120, 80, 255),
			Sections = {
				{
					Name = "Abyss",
					Description = "Op options",
					Options = {
						{Type = "toggle", Name = "Wall Phase", Description = "Go through walls", Callback = "SetAbyssToggle", Default = false},
						{Type = "slider", Name = "Phase Strength", Callback = "SetAbyssValue", Min = 1, Max = 100, Default = 50},
						{Type = "toggle", Name = "Hitbox Extender", Description = "enemy hitbox extender", Callback = "SetHitboxExtender", Default = false},
						{Type = "slider", Name = "Hitbox Size", Callback = "SetHitboxSize", Min = 2, Max = 25, Default = 8},
						{Type = "toggle", Name = "Transparent Hitbox", Description = "Make extended hitboxes invisible", Callback = "SetHitboxInvisible", Default = false}
					}
				},
				{
					Name = "Abyss fly",
					Description = "more op cheats can be good with wall phase",
					Options = {
						{Type = "button", Name = "Start Fly", Description = "Start fly mode", Callback = "AbyssSlotOne"},
						{Type = "button", Name = "Stop Fly", Description = "Stop fly mode", Callback = "AbyssSlotTwo"}
					}
				}
			}
		},
		{
			Name = "Settings",
			Icon = "rbxthumb://type=Asset&id=109264660442602&w=150&h=150",
			Color = Color3.fromRGB(180, 135, 255),
			Sections = {
				{
					Name = "Performance",
					Description = "Client settings",
					Options = {
						{Type = "toggle", Name = "Fast Flags", Description = "activate fast flags less laggy", Callback = "SetFastFlags", Default = false},
						{Type = "toggle", Name = "No Delay", Description = "no delay shooting", Callback = "SetNoDelay", Default = false}
					}
				},
				{
					Name = "Notifications",
					Description = "script notifications",
					Options = {
						{Type = "toggle", Name = "Notifications", Description = "Enable or disable notifications", Callback = "SetNotifications", Default = true}
					}
				}
			}
		}
	}
}

function Gui.Create(OptionConfig, Functions)
	local logoAsset = OptionConfig.Assets.Logo
	local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150"
	local camera = Workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local panelScale = isMobile and math.clamp(math.min((viewport.X - 24) / 835, (viewport.Y - 24) / 490), 0.52, 0.74) or 1
	local minClosedSize = isMobile and UDim2.fromOffset(60, 60) or UDim2.fromOffset(82, 82)
	local minStartSize = isMobile and UDim2.fromOffset(44, 44) or UDim2.fromOffset(58, 58)

	local old = pg:FindFirstChild("AxiAdminPanel")
	if old then old:Destroy() end

	local oldBlur = Lighting:FindFirstChild("AxiPanelBlur")
	if oldBlur then oldBlur:Destroy() end

	local oldHitboxFolder = Workspace:FindFirstChild("AxiHitboxes")
	if oldHitboxFolder then oldHitboxFolder:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AxiAdminPanel"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.DisplayOrder = 999999
	gui.Parent = pg

	local notificationHolder = Instance.new("Frame")
	notificationHolder.Name = "Notifications"
	notificationHolder.AnchorPoint = Vector2.new(1, 1)
	notificationHolder.Position = UDim2.new(1, -18, 1, -18)
	notificationHolder.Size = UDim2.fromOffset(isMobile and 250 or 300, isMobile and 190 or 220)
	notificationHolder.BackgroundTransparency = 1
	notificationHolder.ZIndex = 999999
	notificationHolder.Parent = gui

	local notificationList = Instance.new("UIListLayout")
	notificationList.Padding = UDim.new(0, 7)
	notificationList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationList.SortOrder = Enum.SortOrder.LayoutOrder
	notificationList.Parent = notificationHolder

	local function quickTween(obj, props, time)
		local t = TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	local function notifyCorner(obj, r)
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, r)
		c.Parent = obj
		return c
	end

	function Functions.Notify(title, text, duration)
		if Functions.States and Functions.States.Notifications == false then return end

		local card = Instance.new("Frame")
		card.Name = "Notify"
		card.Size = UDim2.fromOffset(isMobile and 230 or 278, isMobile and 54 or 58)
		card.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
		card.BackgroundTransparency = 0.12
		card.BorderSizePixel = 0
		card.ClipsDescendants = true
		card.ZIndex = 999999
		card.Parent = notificationHolder

		notifyCorner(card, 13)

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 0.83
		stroke.Thickness = 1
		stroke.Parent = card

		local glow = Instance.new("Frame")
		glow.Size = UDim2.new(1, 0, 1, 0)
		glow.BackgroundColor3 = Color3.fromRGB(180, 135, 255)
		glow.BackgroundTransparency = 0.94
		glow.BorderSizePixel = 0
		glow.ZIndex = card.ZIndex + 1
		glow.Parent = card
		notifyCorner(glow, 13)

		local accent = Instance.new("Frame")
		accent.Size = UDim2.new(0, 3, 1, -16)
		accent.Position = UDim2.fromOffset(9, 8)
		accent.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		accent.BorderSizePixel = 0
		accent.ZIndex = card.ZIndex + 2
		accent.Parent = card
		notifyCorner(accent, 4)

		local titleLabel = Instance.new("TextLabel")
		titleLabel.BackgroundTransparency = 1
		titleLabel.Position = UDim2.fromOffset(20, 7)
		titleLabel.Size = UDim2.new(1, -30, 0, 19)
		titleLabel.Font = Enum.Font.GothamBlack
		titleLabel.Text = tostring(title or "Axi")
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = isMobile and 12 or 13
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
		titleLabel.ZIndex = card.ZIndex + 3
		titleLabel.Parent = card

		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(20, 27)
		textLabel.Size = UDim2.new(1, -30, 0, 23)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = tostring(text or "")
		textLabel.TextColor3 = Color3.fromRGB(180, 186, 205)
		textLabel.TextSize = isMobile and 10 or 11
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.TextWrapped = true
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.ZIndex = card.ZIndex + 3
		textLabel.Parent = card

		card.Position = UDim2.fromOffset(34, 0)
		card.BackgroundTransparency = 1
		glow.BackgroundTransparency = 1
		accent.BackgroundTransparency = 1
		titleLabel.TextTransparency = 1
		textLabel.TextTransparency = 1
		stroke.Transparency = 1

		quickTween(card, {Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.12}, 0.2)
		quickTween(glow, {BackgroundTransparency = 0.94}, 0.2)
		quickTween(accent, {BackgroundTransparency = 0}, 0.2)
		quickTween(titleLabel, {TextTransparency = 0}, 0.2)
		quickTween(textLabel, {TextTransparency = 0}, 0.2)
		quickTween(stroke, {Transparency = 0.83}, 0.2)

		task.delay(duration or 1.9, function()
			if not card or not card.Parent then return end
			quickTween(card, {Position = UDim2.fromOffset(34, 0), BackgroundTransparency = 1}, 0.22)
			quickTween(glow, {BackgroundTransparency = 1}, 0.22)
			quickTween(accent, {BackgroundTransparency = 1}, 0.22)
			quickTween(titleLabel, {TextTransparency = 1}, 0.22)
			quickTween(textLabel, {TextTransparency = 1}, 0.22)
			quickTween(stroke, {Transparency = 1}, 0.22)
			task.wait(0.24)
			if card and card.Parent then
				card:Destroy()
			end
		end)
	end

	function Functions.SmallLoadedNotify()
		if Functions.States and Functions.States.Notifications == false then return end

		local card = Instance.new("Frame")
		card.Name = "LoadedNotify"
		card.Size = UDim2.fromOffset(isMobile and 240 or 292, 68)
		card.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
		card.BackgroundTransparency = 1
		card.BorderSizePixel = 0
		card.ClipsDescendants = true
		card.ZIndex = 999999
		card.Parent = notificationHolder

		notifyCorner(card, 14)

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 1
		stroke.Thickness = 1
		stroke.Parent = card

		local glow = Instance.new("Frame")
		glow.Size = UDim2.fromScale(1, 1)
		glow.BackgroundColor3 = Color3.fromRGB(180, 135, 255)
		glow.BackgroundTransparency = 1
		glow.BorderSizePixel = 0
		glow.ZIndex = card.ZIndex + 1
		glow.Parent = card
		notifyCorner(glow, 14)

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(16, 10)
		label.Size = UDim2.new(1, -32, 0, 22)
		label.Font = Enum.Font.GothamBlack
		label.Text = "axis loaded version (beta)"
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = isMobile and 12 or 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextTransparency = 1
		label.ZIndex = card.ZIndex + 2
		label.Parent = card

		local barBack = Instance.new("Frame")
		barBack.Position = UDim2.fromOffset(16, 42)
		barBack.Size = UDim2.new(1, -32, 0, 8)
		barBack.BackgroundColor3 = Color3.fromRGB(24, 24, 31)
		barBack.BackgroundTransparency = 1
		barBack.BorderSizePixel = 0
		barBack.ZIndex = card.ZIndex + 2
		barBack.Parent = card
		notifyCorner(barBack, 8)

		local bar = Instance.new("Frame")
		bar.Size = UDim2.fromScale(0, 1)
		bar.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		bar.BackgroundTransparency = 1
		bar.BorderSizePixel = 0
		bar.ZIndex = card.ZIndex + 3
		bar.Parent = barBack
		notifyCorner(bar, 8)

		card.Position = UDim2.fromOffset(34, 0)

		quickTween(card, {Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.1}, 0.22)
		quickTween(stroke, {Transparency = 0.8}, 0.22)
		quickTween(glow, {BackgroundTransparency = 0.94}, 0.22)
		quickTween(label, {TextTransparency = 0}, 0.22)
		quickTween(barBack, {BackgroundTransparency = 0.08}, 0.22)
		quickTween(bar, {BackgroundTransparency = 0, Size = UDim2.fromScale(1, 1)}, 1.25)

		task.delay(1.85, function()
			if not card or not card.Parent then return end
			quickTween(card, {Position = UDim2.fromOffset(34, 0), BackgroundTransparency = 1}, 0.25)
			quickTween(stroke, {Transparency = 1}, 0.25)
			quickTween(glow, {BackgroundTransparency = 1}, 0.25)
			quickTween(label, {TextTransparency = 1}, 0.25)
			quickTween(barBack, {BackgroundTransparency = 1}, 0.25)
			quickTween(bar, {BackgroundTransparency = 1}, 0.25)
			task.wait(0.27)
			if card and card.Parent then
				card:Destroy()
			end
		end)
	end

	function Functions.LoadScreen(doneCallback)
		local gameName = "Game"
		pcall(function()
			local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
			if info and info.Name then
				gameName = tostring(info.Name)
			end
		end)
		local overlay = Instance.new("Frame")
		overlay.Name = "AxiLoadingScreen"
		overlay.Size = UDim2.fromScale(1, 1)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.18
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 1000000
		overlay.Parent = gui

		local box = Instance.new("Frame")
		box.Name = "Loader"
		box.AnchorPoint = Vector2.new(0.5, 0.5)
		box.Position = UDim2.fromScale(0.5, 0.5)
		box.Size = UDim2.fromOffset(isMobile and 270 or 340, 126)
		box.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
		box.BackgroundTransparency = 0.06
		box.BorderSizePixel = 0
		box.ZIndex = overlay.ZIndex + 1
		box.Parent = overlay

		notifyCorner(box, 18)

		local boxStroke = Instance.new("UIStroke")
		boxStroke.Color = Color3.fromRGB(255, 255, 255)
		boxStroke.Transparency = 0.82
		boxStroke.Thickness = 1
		boxStroke.Parent = box

		local shade = Instance.new("Frame")
		shade.Size = UDim2.fromScale(1, 1)
		shade.BackgroundColor3 = Color3.fromRGB(180, 135, 255)
		shade.BackgroundTransparency = 0.95
		shade.BorderSizePixel = 0
		shade.ZIndex = box.ZIndex + 1
		shade.Parent = box
		notifyCorner(shade, 18)

		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Position = UDim2.fromOffset(18, 18)
		title.Size = UDim2.new(1, -36, 0, 26)
		title.Font = Enum.Font.GothamBlack
		title.Text = "loading game"
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextSize = isMobile and 15 or 17
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = box.ZIndex + 2
		title.Parent = box

		local sub = Instance.new("TextLabel")
		sub.BackgroundTransparency = 1
		sub.Position = UDim2.fromOffset(18, 45)
		sub.Size = UDim2.new(1, -36, 0, 22)
		sub.Font = Enum.Font.GothamBold
		sub.Text = gameName
		sub.TextColor3 = Color3.fromRGB(175, 181, 200)
		sub.TextSize = isMobile and 11 or 12
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.TextTruncate = Enum.TextTruncate.AtEnd
		sub.ZIndex = box.ZIndex + 2
		sub.Parent = box

		local percent = Instance.new("TextLabel")
		percent.BackgroundTransparency = 1
		percent.AnchorPoint = Vector2.new(1, 0)
		percent.Position = UDim2.new(1, -18, 0, 45)
		percent.Size = UDim2.fromOffset(60, 22)
		percent.Font = Enum.Font.GothamBlack
		percent.Text = "0%"
		percent.TextColor3 = Color3.fromRGB(255, 255, 255)
		percent.TextSize = isMobile and 11 or 12
		percent.TextXAlignment = Enum.TextXAlignment.Right
		percent.ZIndex = box.ZIndex + 3
		percent.Parent = box

		local barBack = Instance.new("Frame")
		barBack.Position = UDim2.fromOffset(18, 82)
		barBack.Size = UDim2.new(1, -36, 0, 10)
		barBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		barBack.BackgroundTransparency = 0.12
		barBack.BorderSizePixel = 0
		barBack.ZIndex = box.ZIndex + 2
		barBack.Parent = box
		notifyCorner(barBack, 10)

		local barStroke = Instance.new("UIStroke")
		barStroke.Color = Color3.fromRGB(255, 255, 255)
		barStroke.Transparency = 0.88
		barStroke.Thickness = 1
		barStroke.Parent = barBack

		local bar = Instance.new("Frame")
		bar.Size = UDim2.fromScale(0, 1)
		bar.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		bar.BorderSizePixel = 0
		bar.ZIndex = box.ZIndex + 3
		bar.Parent = barBack
		notifyCorner(bar, 10)

		local status = Instance.new("TextLabel")
		status.BackgroundTransparency = 1
		status.Position = UDim2.fromOffset(18, 97)
		status.Size = UDim2.new(1, -36, 0, 18)
		status.Font = Enum.Font.GothamBold
		status.Text = "preparing axis panel"
		status.TextColor3 = Color3.fromRGB(130, 136, 155)
		status.TextSize = isMobile and 9 or 10
		status.TextXAlignment = Enum.TextXAlignment.Left
		status.ZIndex = box.ZIndex + 2
		status.Parent = box

		local started = tick()
		local total = 10
		local connection

		connection = RunService.RenderStepped:Connect(function()
			local alpha = math.clamp((tick() - started) / total, 0, 1)
			bar.Size = UDim2.fromScale(alpha, 1)
			percent.Text = tostring(math.floor(alpha * 100)) .. "%"
			if alpha >= 0.33 and alpha < 0.66 then
				status.Text = "loading interface"
			elseif alpha >= 0.66 and alpha < 1 then
				status.Text = "finishing setup"
			elseif alpha >= 1 then
				status.Text = "done"
				if connection then
					connection:Disconnect()
					connection = nil
				end
				task.delay(0.18, function()
					quickTween(overlay, {BackgroundTransparency = 1}, 0.35)
					quickTween(box, {BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.52)}, 0.35)
					quickTween(boxStroke, {Transparency = 1}, 0.35)
					quickTween(shade, {BackgroundTransparency = 1}, 0.35)
					quickTween(title, {TextTransparency = 1}, 0.35)
					quickTween(sub, {TextTransparency = 1}, 0.35)
					quickTween(percent, {TextTransparency = 1}, 0.35)
					quickTween(barBack, {BackgroundTransparency = 1}, 0.35)
					quickTween(barStroke, {Transparency = 1}, 0.35)
					quickTween(bar, {BackgroundTransparency = 1}, 0.35)
					quickTween(status, {TextTransparency = 1}, 0.35)
					task.wait(0.38)
					if overlay and overlay.Parent then
						overlay:Destroy()
					end
					if doneCallback then
						task.spawn(doneCallback)
					end
				end)
			end
		end)
	end


	local blur = Instance.new("BlurEffect")
	blur.Name = "AxiPanelBlur"
	blur.Size = 0
	blur.Parent = Lighting

	local function tween(obj, props, time)
		local t = TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	local function corner(obj, r)
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, r)
		c.Parent = obj
		return c
	end

	local function stroke(obj, color, transparency, thickness)
		local s = Instance.new("UIStroke")
		s.Color = color
		s.Transparency = transparency
		s.Thickness = thickness
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = obj
		return s
	end

	local function gradient(obj, seq, rot, trans)
		local g = Instance.new("UIGradient")
		g.Color = seq
		g.Rotation = rot or 0
		if trans then g.Transparency = trans end
		g.Parent = obj
		return g
	end

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.Size = UDim2.fromOffset(835, 490)
	main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	main.BackgroundTransparency = 0.58
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Active = true
	main.ZIndex = 10
	main.Parent = gui

	local mainScale = Instance.new("UIScale")
	mainScale.Scale = panelScale
	mainScale.Parent = main

	corner(main, 32)
	stroke(main, Color3.fromRGB(255, 255, 255), 0.66, 1)

	gradient(main, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 42, 52))
	}), 135, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(0.5, 0.08),
		NumberSequenceKeypoint.new(1, 0.35)
	}))

	local shadow = Instance.new("ImageLabel")
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.Size = UDim2.new(1, 140, 1, 140)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.18
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.ZIndex = 9
	shadow.Parent = main

	local glass = Instance.new("Frame")
	glass.Size = UDim2.fromScale(1, 1)
	glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	glass.BackgroundTransparency = 0.965
	glass.BorderSizePixel = 0
	glass.ZIndex = 11
	glass.Parent = main

	corner(glass, 32)

	local logoWrap = Instance.new("Frame")
	logoWrap.AnchorPoint = Vector2.new(0, 0.5)
	logoWrap.Position = UDim2.fromOffset(31, 55)
	logoWrap.Size = UDim2.fromOffset(68, 68)
	logoWrap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	logoWrap.BackgroundTransparency = 0.55
	logoWrap.BorderSizePixel = 0
	logoWrap.ClipsDescendants = true
	logoWrap.ZIndex = 30
	logoWrap.Parent = main

	corner(logoWrap, 21)
	stroke(logoWrap, Color3.fromRGB(255, 255, 255), 0.7, 1)

	local logo = Instance.new("ImageLabel")
	logo.AnchorPoint = Vector2.new(0.5, 0.5)
	logo.Position = UDim2.fromScale(0.5, 0.5)
	logo.Size = UDim2.fromOffset(61, 61)
	logo.BackgroundTransparency = 1
	logo.Image = logoAsset
	logo.ScaleType = Enum.ScaleType.Fit
	logo.ZIndex = 31
	logo.Parent = logoWrap

	local topbar = Instance.new("Frame")
	topbar.Size = UDim2.new(1, 0, 0, 104)
	topbar.BackgroundTransparency = 1
	topbar.Active = true
	topbar.ZIndex = 25
	topbar.Parent = main

	local titleShadow = Instance.new("TextLabel")
	titleShadow.Size = UDim2.fromOffset(260, 50)
	titleShadow.Position = UDim2.fromOffset(115, 24)
	titleShadow.BackgroundTransparency = 1
	titleShadow.Text = OptionConfig.Window.Title
	titleShadow.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleShadow.TextTransparency = 0.68
	titleShadow.TextSize = 44
	titleShadow.Font = Enum.Font.FredokaOne
	titleShadow.TextXAlignment = Enum.TextXAlignment.Left
	titleShadow.ZIndex = 26
	titleShadow.Parent = topbar

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromOffset(260, 50)
	title.Position = UDim2.fromOffset(112, 21)
	title.BackgroundTransparency = 1
	title.Text = OptionConfig.Window.Title
	title.TextColor3 = Color3.fromRGB(0, 0, 0)
	title.TextSize = 44
	title.Font = Enum.Font.FredokaOne
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 27
	title.Parent = topbar

	local titleStroke = Instance.new("UIStroke")
	titleStroke.Color = Color3.fromRGB(255, 255, 255)
	titleStroke.Transparency = 0.28
	titleStroke.Thickness = 1
	titleStroke.Parent = title

	local tag = Instance.new("TextLabel")
	tag.Size = UDim2.fromOffset(245, 20)
	tag.Position = UDim2.fromOffset(116, 70)
	tag.BackgroundTransparency = 1
	tag.Text = OptionConfig.Window.Subtitle
	tag.TextColor3 = Color3.fromRGB(230, 235, 250)
	tag.TextSize = 13
	tag.Font = Enum.Font.GothamBlack
	tag.TextXAlignment = Enum.TextXAlignment.Left
	tag.ZIndex = 27
	tag.Parent = topbar

	local axisLine = Instance.new("TextLabel")
	axisLine.Size = UDim2.fromOffset(245, 18)
	axisLine.Position = UDim2.fromOffset(112, 85)
	axisLine.BackgroundTransparency = 1
	axisLine.Text = "━━━━━━━━━━━━━━━━━━━━━━"
	axisLine.TextSize = 14
	axisLine.Font = Enum.Font.GothamBlack
	axisLine.TextXAlignment = Enum.TextXAlignment.Left
	axisLine.TextColor3 = Color3.fromRGB(0, 0, 0)
	axisLine.ZIndex = 28
	axisLine.Parent = topbar

	local axisStroke = Instance.new("UIStroke")
	axisStroke.Color = Color3.fromRGB(255, 255, 255)
	axisStroke.Transparency = 0.42
	axisStroke.Thickness = 1
	axisStroke.Parent = axisLine

	local windowButtons = Instance.new("Frame")
	windowButtons.Size = UDim2.fromOffset(94, 40)
	windowButtons.Position = UDim2.new(1, -122, 0, 31)
	windowButtons.BackgroundTransparency = 1
	windowButtons.ZIndex = 40
	windowButtons.Parent = topbar

	local function windowButton(name, text, x)
		local b = Instance.new("TextButton")
		b.Name = name
		b.Size = UDim2.fromOffset(40, 40)
		b.Position = UDim2.fromOffset(x, 0)
		b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		b.BackgroundTransparency = 0.5
		b.BorderSizePixel = 0
		b.Text = ""
		b.AutoButtonColor = false
		b.ZIndex = 41
		b.Parent = windowButtons

		corner(b, 20)
		stroke(b, Color3.fromRGB(255, 255, 255), 0.78, 1)

		local icon = Instance.new("TextLabel")
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.fromScale(0.5, 0.47)
		icon.Size = UDim2.fromScale(1, 1)
		icon.BackgroundTransparency = 1
		icon.Text = text
		icon.TextColor3 = Color3.fromRGB(255, 255, 255)
		icon.TextSize = name == "Close" and 25 or 26
		icon.Font = Enum.Font.GothamBlack
		icon.ZIndex = 42
		icon.Parent = b

		return b
	end

	local minimize = windowButton("Minimize", "—", 0)
	local close = windowButton("Close", "×", 52)

	local body = Instance.new("Frame")
	body.Size = UDim2.new(1, -56, 1, -136)
	body.Position = UDim2.fromOffset(28, 116)
	body.BackgroundTransparency = 1
	body.ZIndex = 20
	body.Parent = main

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 254, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BackgroundTransparency = 0.58
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 21
	sidebar.Parent = body

	corner(sidebar, 24)
	stroke(sidebar, Color3.fromRGB(255, 255, 255), 0.78, 1)

	local tabsFrame = Instance.new("ScrollingFrame")
	tabsFrame.Size = UDim2.new(1, -34, 1, -112)
	tabsFrame.Position = UDim2.fromOffset(17, 24)
	tabsFrame.BackgroundTransparency = 1
	tabsFrame.BorderSizePixel = 0
	tabsFrame.ScrollBarThickness = 3
	tabsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	tabsFrame.ScrollBarImageTransparency = 0.55
	tabsFrame.CanvasSize = UDim2.fromOffset(0, 0)
	tabsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabsFrame.ZIndex = 24
	tabsFrame.Parent = sidebar

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.Padding = UDim.new(0, 13)
	tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsLayout.Parent = tabsFrame

	local profile = Instance.new("Frame")
	profile.AnchorPoint = Vector2.new(0.5, 1)
	profile.Size = UDim2.new(1, -34, 0, 63)
	profile.Position = UDim2.new(0.5, 0, 1, -17)
	profile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	profile.BackgroundTransparency = 0.48
	profile.BorderSizePixel = 0
	profile.ZIndex = 60
	profile.Parent = sidebar

	corner(profile, 19)
	stroke(profile, Color3.fromRGB(255, 255, 255), 0.8, 1)

	local avatarWrap = Instance.new("Frame")
	avatarWrap.Size = UDim2.fromOffset(45, 45)
	avatarWrap.Position = UDim2.fromOffset(9, 9)
	avatarWrap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	avatarWrap.BackgroundTransparency = 0.35
	avatarWrap.BorderSizePixel = 0
	avatarWrap.ZIndex = 61
	avatarWrap.Parent = profile

	corner(avatarWrap, 15)

	local avatar = Instance.new("ImageLabel")
	avatar.AnchorPoint = Vector2.new(0.5, 0.5)
	avatar.Position = UDim2.fromScale(0.5, 0.5)
	avatar.Size = UDim2.fromOffset(38, 38)
	avatar.BackgroundTransparency = 1
	avatar.Image = avatarImage
	avatar.ScaleType = Enum.ScaleType.Crop
	avatar.ZIndex = 62
	avatar.Parent = avatarWrap

	corner(avatar, 13)

	local displayName = Instance.new("TextLabel")
	displayName.Size = UDim2.new(1, -68, 0, 25)
	displayName.Position = UDim2.fromOffset(64, 9)
	displayName.BackgroundTransparency = 1
	displayName.Text = lp.DisplayName
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 13
	displayName.Font = Enum.Font.GothamBlack
	displayName.TextXAlignment = Enum.TextXAlignment.Left
	displayName.TextTruncate = Enum.TextTruncate.AtEnd
	displayName.ZIndex = 62
	displayName.Parent = profile

	local userName = Instance.new("TextLabel")
	userName.Size = UDim2.new(1, -68, 0, 21)
	userName.Position = UDim2.fromOffset(64, 33)
	userName.BackgroundTransparency = 1
	userName.Text = "@" .. lp.Name
	userName.TextColor3 = Color3.fromRGB(165, 170, 190)
	userName.TextSize = 11
	userName.Font = Enum.Font.GothamBold
	userName.TextXAlignment = Enum.TextXAlignment.Left
	userName.TextTruncate = Enum.TextTruncate.AtEnd
	userName.ZIndex = 62
	userName.Parent = profile

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -278, 1, 0)
	content.Position = UDim2.fromOffset(278, 0)
	content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	content.BackgroundTransparency = 0.6
	content.BorderSizePixel = 0
	content.ClipsDescendants = true
	content.ZIndex = 21
	content.Parent = body

	corner(content, 24)
	stroke(content, Color3.fromRGB(255, 255, 255), 0.78, 1)

	local pageTitle = Instance.new("TextLabel")
	pageTitle.Size = UDim2.new(1, -52, 0, 44)
	pageTitle.Position = UDim2.fromOffset(26, 24)
	pageTitle.BackgroundTransparency = 1
	pageTitle.Text = OptionConfig.Tabs[1].Name
	pageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	pageTitle.TextSize = 26
	pageTitle.Font = Enum.Font.FredokaOne
	pageTitle.TextXAlignment = Enum.TextXAlignment.Left
	pageTitle.ZIndex = 24
	pageTitle.Parent = content

	local emptyLine = Instance.new("Frame")
	emptyLine.Size = UDim2.new(1, -52, 0, 2)
	emptyLine.Position = UDim2.fromOffset(26, 78)
	emptyLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	emptyLine.BackgroundTransparency = 0.78
	emptyLine.BorderSizePixel = 0
	emptyLine.ZIndex = 24
	emptyLine.Parent = content

	local pages = Instance.new("Frame")
	pages.Size = UDim2.new(1, -52, 1, -104)
	pages.Position = UDim2.fromOffset(26, 94)
	pages.BackgroundTransparency = 1
	pages.ClipsDescendants = true
	pages.ZIndex = 24
	pages.Parent = content

	local pageObjects = {}
	local selectedTab
	local tabs = {}

	local function makePage(name)
		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = name
		scroll.Size = UDim2.fromScale(1, 1)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 4
		scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		scroll.ScrollBarImageTransparency = 0.45
		scroll.CanvasSize = UDim2.fromOffset(0, 0)
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll.Visible = false
		scroll.ZIndex = 24
		scroll.Parent = pages

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 14)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = scroll

		pageObjects[name] = scroll
		return scroll
	end

	local function makeSection(parent, titleText, subtitleText)
		local section = Instance.new("Frame")
		section.Size = UDim2.new(1, -8, 0, 0)
		section.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		section.BackgroundTransparency = 0.72
		section.BorderSizePixel = 0
		section.AutomaticSize = Enum.AutomaticSize.Y
		section.ZIndex = 25
		section.Parent = parent

		corner(section, 20)
		stroke(section, Color3.fromRGB(255, 255, 255), 0.86, 1)

		local header = Instance.new("Frame")
		header.Size = UDim2.new(1, 0, 0, subtitleText and 58 or 48)
		header.BackgroundTransparency = 1
		header.ZIndex = 26
		header.Parent = section

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -34, 0, 24)
		titleLabel.Position = UDim2.fromOffset(17, 11)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = titleText
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 16
		titleLabel.Font = Enum.Font.GothamBlack
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.ZIndex = 27
		titleLabel.Parent = header

		if subtitleText then
			local subtitleLabel = Instance.new("TextLabel")
			subtitleLabel.Size = UDim2.new(1, -34, 0, 20)
			subtitleLabel.Position = UDim2.fromOffset(17, 34)
			subtitleLabel.BackgroundTransparency = 1
			subtitleLabel.Text = subtitleText
			subtitleLabel.TextColor3 = Color3.fromRGB(150, 156, 175)
			subtitleLabel.TextSize = 12
			subtitleLabel.Font = Enum.Font.GothamBold
			subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			subtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
			subtitleLabel.ZIndex = 27
			subtitleLabel.Parent = header
		end

		local inner = Instance.new("Frame")
		inner.Size = UDim2.new(1, -22, 0, 0)
		inner.Position = UDim2.fromOffset(11, subtitleText and 58 or 48)
		inner.BackgroundTransparency = 1
		inner.AutomaticSize = Enum.AutomaticSize.Y
		inner.ZIndex = 26
		inner.Parent = section

		local padding = Instance.new("UIPadding")
		padding.PaddingBottom = UDim.new(0, 12)
		padding.Parent = inner

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 10)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = inner

		return inner
	end

	local function makeRow(parent)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 68)
		row.BackgroundTransparency = 1
		row.ZIndex = 26
		row.Parent = parent

		local layout = Instance.new("UIListLayout")
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 10)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = row

		return row
	end

	local function makeToggle(parent, data, half)
		local holder = Instance.new("TextButton")
		holder.Size = half and UDim2.new(0.5, -5, 1, 0) or UDim2.new(1, 0, 0, 68)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 0.5
		holder.BorderSizePixel = 0
		holder.Text = ""
		holder.AutoButtonColor = false
		holder.ZIndex = 27
		holder.Parent = parent

		corner(holder, 17)
		stroke(holder, Color3.fromRGB(255, 255, 255), 0.84, 1)

		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -88, 0, 25)
		name.Position = UDim2.fromOffset(16, 10)
		name.BackgroundTransparency = 1
		name.Text = data.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 14
		name.Font = Enum.Font.GothamBlack
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 28
		name.Parent = holder

		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -88, 0, 21)
		desc.Position = UDim2.fromOffset(16, 34)
		desc.BackgroundTransparency = 1
		desc.Text = data.Description or ""
		desc.TextColor3 = Color3.fromRGB(150, 156, 175)
		desc.TextSize = 11
		desc.Font = Enum.Font.GothamBold
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextTruncate = Enum.TextTruncate.AtEnd
		desc.ZIndex = 28
		desc.Parent = holder

		local toggle = Instance.new("Frame")
		toggle.AnchorPoint = Vector2.new(1, 0.5)
		toggle.Position = UDim2.new(1, -14, 0.5, 0)
		toggle.Size = UDim2.fromOffset(50, 28)
		toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		toggle.BackgroundTransparency = 0.14
		toggle.BorderSizePixel = 0
		toggle.ZIndex = 29
		toggle.Parent = holder

		corner(toggle, 14)
		stroke(toggle, Color3.fromRGB(255, 255, 255), 0.85, 1)

		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(20, 20)
		dot.Position = UDim2.fromOffset(4, 4)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dot.BackgroundTransparency = 0.05
		dot.BorderSizePixel = 0
		dot.ZIndex = 30
		dot.Parent = toggle

		corner(dot, 10)

		local enabled = data.Default == true

		local function setState(state, instant)
			enabled = state
			if instant then
				toggle.BackgroundColor3 = state and Color3.fromRGB(255, 74, 96) or Color3.fromRGB(20, 20, 24)
				dot.Position = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)
			else
				tween(toggle, {BackgroundColor3 = state and Color3.fromRGB(255, 74, 96) or Color3.fromRGB(20, 20, 24)}, 0.18)
				tween(dot, {Position = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)}, 0.18)
			end
			if data.Callback and Functions[data.Callback] and not instant then
				task.spawn(Functions[data.Callback], state)
				if Functions.Notify and data.Name ~= "Notifications" then
					Functions.Notify("Axi", data.Name .. (state and " enabled" or " disabled"), 1.6)
				end
			end
		end

		holder.MouseButton1Click:Connect(function()
			setState(not enabled, false)
		end)

		setState(enabled, true)
		return {Set = setState, Get = function() return enabled end}
	end

	local function makeSlider(parent, data)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 86)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 0.5
		holder.BorderSizePixel = 0
		holder.ZIndex = 27
		holder.Parent = parent

		corner(holder, 17)
		stroke(holder, Color3.fromRGB(255, 255, 255), 0.84, 1)

		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -90, 0, 26)
		name.Position = UDim2.fromOffset(16, 10)
		name.BackgroundTransparency = 1
		name.Text = data.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 14
		name.Font = Enum.Font.GothamBlack
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.ZIndex = 28
		name.Parent = holder

		local valueText = Instance.new("TextLabel")
		valueText.AnchorPoint = Vector2.new(1, 0)
		valueText.Position = UDim2.new(1, -16, 0, 12)
		valueText.Size = UDim2.fromOffset(65, 22)
		valueText.BackgroundTransparency = 1
		valueText.Text = tostring(data.Default)
		valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		valueText.TextSize = 13
		valueText.Font = Enum.Font.GothamBlack
		valueText.TextXAlignment = Enum.TextXAlignment.Right
		valueText.ZIndex = 28
		valueText.Parent = holder

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, -32, 0, 8)
		bar.Position = UDim2.fromOffset(16, 55)
		bar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		bar.BackgroundTransparency = 0.18
		bar.BorderSizePixel = 0
		bar.ZIndex = 28
		bar.Parent = holder

		corner(bar, 8)

		local min = data.Min or 0
		local max = data.Max or 100
		local default = data.Default or min
		local value = default
		local draggingSlider = false

		local fill = Instance.new("Frame")
		fill.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		fill.BorderSizePixel = 0
		fill.ZIndex = 29
		fill.Parent = bar

		corner(fill, 8)

		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Size = UDim2.fromOffset(18, 18)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		knob.ZIndex = 30
		knob.Parent = bar

		corner(knob, 9)

		local function setValue(v, instant)
			local rel = math.clamp((v - min) / (max - min), 0, 1)
			value = math.floor(min + (max - min) * rel)
			valueText.Text = tostring(value)
			fill.Size = UDim2.fromScale(rel, 1)
			knob.Position = UDim2.fromScale(rel, 0.5)
			if data.Callback and Functions[data.Callback] and not instant then
				task.spawn(Functions[data.Callback], value)
			end
		end

		local function setValueFromX(x)
			local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			setValue(min + (max - min) * rel, false)
		end

		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingSlider = true
				setValueFromX(input.Position.X)
			end
		end)

		bar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingSlider = false
				if Functions.Notify then
					Functions.Notify("Axi", data.Name .. " set to " .. tostring(value), 1.5)
				end
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setValueFromX(input.Position.X)
			end
		end)

		setValue(default, true)
		return {Set = setValue, Get = function() return value end}
	end

	local function makeButton(parent, data, half)
		local b = Instance.new("TextButton")
		b.Size = half and UDim2.new(0.5, -5, 1, 0) or UDim2.new(1, 0, 0, 62)
		b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		b.BackgroundTransparency = 0.5
		b.BorderSizePixel = 0
		b.Text = ""
		b.AutoButtonColor = false
		b.ZIndex = 27
		b.Parent = parent

		corner(b, 17)
		stroke(b, Color3.fromRGB(255, 255, 255), 0.84, 1)

		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -26, 0, 24)
		name.Position = UDim2.fromOffset(13, 10)
		name.BackgroundTransparency = 1
		name.Text = data.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 13
		name.Font = Enum.Font.GothamBlack
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 28
		name.Parent = b

		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -26, 0, 20)
		desc.Position = UDim2.fromOffset(13, 34)
		desc.BackgroundTransparency = 1
		desc.Text = data.Description or ""
		desc.TextColor3 = Color3.fromRGB(150, 156, 175)
		desc.TextSize = 10
		desc.Font = Enum.Font.GothamBold
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextTruncate = Enum.TextTruncate.AtEnd
		desc.ZIndex = 28
		desc.Parent = b

		b.MouseButton1Click:Connect(function()
			if data.Callback and Functions[data.Callback] then
				task.spawn(Functions[data.Callback])
				if Functions.Notify then
					Functions.Notify("Axi", data.Name .. " clicked", 1.5)
				end
			end
		end)

		return b
	end

	local function makeTextBox(parent, data)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 112)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 0.5
		holder.BorderSizePixel = 0
		holder.ZIndex = 27
		holder.Parent = parent

		corner(holder, 17)
		stroke(holder, Color3.fromRGB(255, 255, 255), 0.84, 1)

		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -32, 0, 24)
		name.Position = UDim2.fromOffset(16, 10)
		name.BackgroundTransparency = 1
		name.Text = data.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 14
		name.Font = Enum.Font.GothamBlack
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 28
		name.Parent = holder

		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -32, 0, 20)
		desc.Position = UDim2.fromOffset(16, 34)
		desc.BackgroundTransparency = 1
		desc.Text = data.Description or ""
		desc.TextColor3 = Color3.fromRGB(150, 156, 175)
		desc.TextSize = 11
		desc.Font = Enum.Font.GothamBold
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextTruncate = Enum.TextTruncate.AtEnd
		desc.ZIndex = 28
		desc.Parent = holder

		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, -148, 0, 38)
		box.Position = UDim2.fromOffset(16, 62)
		box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
		box.BackgroundTransparency = 0.1
		box.BorderSizePixel = 0
		box.Text = ""
		box.PlaceholderText = data.Placeholder or "Username"
		box.PlaceholderColor3 = Color3.fromRGB(145, 150, 170)
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.TextSize = 13
		box.Font = Enum.Font.GothamBlack
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ZIndex = 28
		box.Parent = holder

		corner(box, 12)
		stroke(box, Color3.fromRGB(255, 255, 255), 0.86, 1)

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 12)
		pad.PaddingRight = UDim.new(0, 12)
		pad.Parent = box

		local button = Instance.new("TextButton")
		button.Size = UDim2.fromOffset(112, 38)
		button.Position = UDim2.new(1, -128, 0, 62)
		button.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		button.BackgroundTransparency = 0.22
		button.BorderSizePixel = 0
		button.Text = data.ButtonText or "Apply"
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 13
		button.Font = Enum.Font.GothamBlack
		button.AutoButtonColor = false
		button.ZIndex = 28
		button.Parent = holder

		corner(button, 12)
		stroke(button, Color3.fromRGB(255, 255, 255), 0.74, 1)

		local function fire()
			local text = tostring(box.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
			if text ~= "" and data.Callback and Functions[data.Callback] then
				task.spawn(Functions[data.Callback], text)
				if Functions.Notify then
					Functions.Notify("Axi", data.Name .. " applied", 1.6)
				end
			end
		end

		button.MouseButton1Click:Connect(fire)
		box.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				fire()
			end
		end)

		return {Get = function() return box.Text end, Set = function(v) box.Text = tostring(v or "") end}
	end

	local function addOption(parent, data)
		if data.Type == "toggle" then
			makeToggle(parent, data, false)
		elseif data.Type == "slider" then
			makeSlider(parent, data)
		elseif data.Type == "button" then
			makeButton(parent, data, false)
		elseif data.Type == "textbox" then
			makeTextBox(parent, data)
		end
	end

	for _, tabData in ipairs(OptionConfig.Tabs) do
		local page = makePage(tabData.Name)

		if tabData.Sections and #tabData.Sections > 0 then
			for _, sectionData in ipairs(tabData.Sections) do
				local section = makeSection(page, sectionData.Name, sectionData.Description)
				local i = 1

				while i <= #sectionData.Options do
					local data = sectionData.Options[i]
					local nextData = sectionData.Options[i + 1]

					if data.Half and nextData and nextData.Half then
						local row = makeRow(section)
						if data.Type == "button" then makeButton(row, data, true) else makeToggle(row, data, true) end
						if nextData.Type == "button" then makeButton(row, nextData, true) else makeToggle(row, nextData, true) end
						i += 2
					else
						addOption(section, data)
						i += 1
					end
				end
			end
		else
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -8, 0, 48)
			empty.BackgroundTransparency = 1
			empty.Text = tabData.EmptyText or "Nothing here for now."
			empty.TextColor3 = Color3.fromRGB(185, 190, 210)
			empty.TextSize = 14
			empty.Font = Enum.Font.GothamBlack
			empty.TextXAlignment = Enum.TextXAlignment.Left
			empty.TextYAlignment = Enum.TextYAlignment.Top
			empty.ZIndex = 25
			empty.Parent = page
		end
	end

	local function showPage(name)
		for pageName, page in pairs(pageObjects) do
			page.Visible = pageName == name
		end
	end

	local function tabState(tab, active, instant)
		local color = Color3.fromRGB(tab:GetAttribute("R"), tab:GetAttribute("G"), tab:GetAttribute("B"))
		local st = tab:FindFirstChild("TabStroke")
		local accent = tab:FindFirstChild("Accent")
		local glow = tab:FindFirstChild("IconGlow")
		local icon = tab:FindFirstChild("Icon")
		local label = tab:FindFirstChild("Label")
		local shade = tab:FindFirstChild("TabShade")
		local bgT = active and 0.46 or 0.62
		local borderT = active and 0.58 or 0.82
		local shadeT = active and 0.82 or 0.94
		local accentT = active and 0.1 or 0.28
		local glowT = active and 0.68 or 0.86
		local iconColor = active and color or Color3.fromRGB(230, 235, 255)
		local textColor = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 216, 235)

		if instant then
			tab.BackgroundTransparency = bgT
			if st then st.Transparency = borderT end
			if shade then
				shade.BackgroundTransparency = shadeT
				shade.BackgroundColor3 = color
			end
			if accent then
				accent.BackgroundTransparency = accentT
				accent.BackgroundColor3 = color
			end
			if glow then
				glow.BackgroundTransparency = glowT
				glow.BackgroundColor3 = color
			end
			if icon then icon.ImageColor3 = iconColor end
			if label then label.TextColor3 = textColor end
		else
			tween(tab, {BackgroundTransparency = bgT}, 0.18)
			if st then tween(st, {Transparency = borderT}, 0.18) end
			if shade then tween(shade, {BackgroundTransparency = shadeT, BackgroundColor3 = color}, 0.18) end
			if accent then tween(accent, {BackgroundTransparency = accentT, BackgroundColor3 = color}, 0.18) end
			if glow then tween(glow, {BackgroundTransparency = glowT, BackgroundColor3 = color}, 0.18) end
			if icon then tween(icon, {ImageColor3 = iconColor}, 0.18) end
			if label then tween(label, {TextColor3 = textColor}, 0.18) end
		end
	end

	local function makeTab(tabData, order)
		local tab = Instance.new("TextButton")
		tab.Name = tabData.Name
		tab.Size = UDim2.new(1, -4, 0, 58)
		tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		tab.BackgroundTransparency = 0.62
		tab.BorderSizePixel = 0
		tab.Text = ""
		tab.AutoButtonColor = false
		tab.LayoutOrder = order
		tab.ZIndex = 25
		tab.Parent = tabsFrame

		local color = tabData.Color or Color3.fromRGB(255, 74, 96)

		tab:SetAttribute("R", math.floor(color.R * 255))
		tab:SetAttribute("G", math.floor(color.G * 255))
		tab:SetAttribute("B", math.floor(color.B * 255))

		corner(tab, 18)

		local tabStroke = stroke(tab, Color3.fromRGB(255, 255, 255), 0.82, 1)
		tabStroke.Name = "TabStroke"

		local tabShade = Instance.new("Frame")
		tabShade.Name = "TabShade"
		tabShade.Size = UDim2.fromScale(1, 1)
		tabShade.BackgroundColor3 = color
		tabShade.BackgroundTransparency = 0.94
		tabShade.BorderSizePixel = 0
		tabShade.ZIndex = 25
		tabShade.Parent = tab
		corner(tabShade, 18)

		local tabGlass = Instance.new("Frame")
		tabGlass.Size = UDim2.fromScale(1, 1)
		tabGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabGlass.BackgroundTransparency = 0.965
		tabGlass.BorderSizePixel = 0
		tabGlass.ZIndex = 26
		tabGlass.Parent = tab
		corner(tabGlass, 18)

		local accent = Instance.new("Frame")
		accent.Name = "Accent"
		accent.Size = UDim2.fromOffset(4, 33)
		accent.Position = UDim2.new(0, 6, 0.5, -16)
		accent.BackgroundColor3 = color
		accent.BackgroundTransparency = 0.28
		accent.BorderSizePixel = 0
		accent.ZIndex = 27
		accent.Parent = tab
		corner(accent, 4)

		local iconGlow = Instance.new("Frame")
		iconGlow.Name = "IconGlow"
		iconGlow.AnchorPoint = Vector2.new(0, 0.5)
		iconGlow.Position = UDim2.new(0, 19, 0.5, 0)
		iconGlow.Size = UDim2.fromOffset(40, 40)
		iconGlow.BackgroundColor3 = color
		iconGlow.BackgroundTransparency = 0.86
		iconGlow.BorderSizePixel = 0
		iconGlow.ZIndex = 27
		iconGlow.Parent = tab
		corner(iconGlow, 15)

		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.new(0, 39, 0.5, 0)
		icon.Size = UDim2.fromOffset(26, 26)
		icon.BackgroundTransparency = 1
		icon.Image = tabData.Icon
		icon.ImageColor3 = Color3.fromRGB(230, 235, 255)
		icon.ScaleType = Enum.ScaleType.Fit
		icon.ZIndex = 28
		icon.Parent = tab

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, -80, 1, 0)
		label.Position = UDim2.fromOffset(73, 0)
		label.BackgroundTransparency = 1
		label.Text = tabData.Name
		label.TextColor3 = Color3.fromRGB(210, 216, 235)
		label.TextSize = 15
		label.Font = Enum.Font.GothamBlack
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 28
		label.Parent = tab

		tab.MouseButton1Click:Connect(function()
			selectedTab = tab
			pageTitle.Text = tabData.Name
			showPage(tabData.Name)
			for _, other in ipairs(tabs) do
				tabState(other, other == selectedTab, false)
			end
			if Functions.Notify then
				Functions.Notify("Tab", tabData.Name .. " opened", 1.3)
			end
		end)

		table.insert(tabs, tab)
		if order == 1 then selectedTab = tab end
	end

	for i, tabData in ipairs(OptionConfig.Tabs) do
		makeTab(tabData, i)
	end

	for _, tab in ipairs(tabs) do
		tabState(tab, tab == selectedTab, true)
	end

	showPage(OptionConfig.Tabs[1].Name)

	local minimized = Instance.new("TextButton")
	minimized.Name = "Minimized"
	minimized.AnchorPoint = Vector2.new(0.5, 0.5)
	minimized.Position = UDim2.fromScale(0.5, 0.5)
	minimized.Size = minClosedSize
	minimized.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	minimized.BackgroundTransparency = 0.45
	minimized.BorderSizePixel = 0
	minimized.Text = ""
	minimized.AutoButtonColor = false
	minimized.Visible = false
	minimized.ZIndex = 100
	minimized.Parent = gui

	corner(minimized, isMobile and 20 or 27)
	stroke(minimized, Color3.fromRGB(255, 255, 255), 0.72, 1)

	local minLogo = Instance.new("ImageLabel")
	minLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	minLogo.Position = UDim2.fromScale(0.5, 0.42)
	minLogo.Size = isMobile and UDim2.fromOffset(38, 38) or UDim2.fromOffset(52, 52)
	minLogo.BackgroundTransparency = 1
	minLogo.Image = logoAsset
	minLogo.ScaleType = Enum.ScaleType.Fit
	minLogo.ZIndex = 101
	minLogo.Parent = minimized

	local openSize = main.Size
	local openPos = main.Position
	local busy = false
	local dragging = false
	local dragStart
	local startPos
	local minDragging = false
	local minDragStart
	local minStartPos
	local movedMin = false

	local function openPanel()
		if busy then return end
		if Functions.Notify then
			Functions.Notify("Axi", "Panel opened", 1.4)
		end
		busy = true
		minimized.Visible = false
		main.Visible = true
		main.Size = UDim2.fromOffset(640, 370)
		main.Position = UDim2.fromScale(0.5, 0.535)
		main.BackgroundTransparency = 1
		tween(blur, {Size = 10}, 0.35)
		local t = tween(main, {Size = openSize, Position = openPos, BackgroundTransparency = 0.58}, 0.45)
		t.Completed:Connect(function()
			busy = false
		end)
	end

	local function minimizePanel()
		if busy then return end
		if Functions.Notify then
			Functions.Notify("Axi", "Panel minimized", 1.4)
		end
		busy = true
		tween(blur, {Size = 0}, 0.25)
		local t = tween(main, {Size = UDim2.fromOffset(96, 76), Position = minimized.Position, BackgroundTransparency = 1}, 0.32)
		t.Completed:Connect(function()
			main.Visible = false
			minimized.Visible = true
			minimized.Size = minStartSize
			tween(minimized, {Size = minClosedSize}, 0.26)
			busy = false
		end)
	end

	local function closePanel()
		if busy then return end
		if Functions.Notify then
			Functions.Notify("Axi", "Panel closed", 1.2)
		end
		busy = true
		tween(blur, {Size = 0}, 0.25)
		local t = tween(main, {Size = UDim2.fromOffset(640, 370), Position = UDim2.fromScale(0.5, 0.54), BackgroundTransparency = 1}, 0.32)
		t.Completed:Connect(function()
			gui:Destroy()
			blur:Destroy()
		end)
	end

	minimize.MouseButton1Click:Connect(minimizePanel)
	close.MouseButton1Click:Connect(closePanel)

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	minimized.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			minDragging = true
			movedMin = false
			minDragStart = input.Position
			minStartPos = minimized.Position
		end
	end)

	minimized.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			task.defer(function()
				minDragging = false
				task.wait()
				movedMin = false
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			openPos = main.Position
		end

		if minDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - minDragStart
			if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
				movedMin = true
			end
			minimized.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y)
		end
	end)

	minimized.MouseButton1Click:Connect(function()
		if movedMin then return end
		openPanel()
	end)

	main.Visible = false
	main.Size = UDim2.fromOffset(640, 370)
	main.Position = UDim2.fromScale(0.5, 0.535)
	main.BackgroundTransparency = 1

	Functions.LoadScreen(function()
		main.Visible = true
		tween(blur, {Size = 10}, 0.35)
		tween(main, {Size = openSize, Position = openPos, BackgroundTransparency = 0.58}, 0.5)
		task.delay(0.65, function()
			if Functions.SmallLoadedNotify then
				Functions.SmallLoadedNotify()
			end
		end)
	end)
end

Functions.States = {
	TeamHighlight = false,
	AutoXD = false,
	AutoXDFOVVisible = false,
	OK = false,
	LOC = false,
	Speed = false,
	JumpPower = false,
	AbyssToggle = false,
	Flying = false,
	FastFlags = false,
	NoDelay = false,
	Notifications = true,
	HitboxExtender = false,
	HitboxInvisible = false,
	TeamRainbow = false,
	EnemyRainbow = false
}

Functions.Values = {
	Speed = 16,
	JumpPower = 50,
	AutoXDFOV = 155,
	AutoXDRange = 1000,
	AutoXDSmooth = 0.42,
	AutoXDFOVRed = 255,
	AutoXDFOVGreen = 255,
	AutoXDFOVBlue = 255,
	AutoXDFOVColor = Color3.fromRGB(255, 255, 255),
	AutoXDWallCheck = true,
	AutoXDTargetPart = "Head",
	AutoXDFOVVisible = false,
	OKFOV = 160,
	OKRange = 1200,
	OKCooldown = 0,
	OKTargetPart = "Head",
	TeamHighlightRed = 0,
	TeamHighlightGreen = 120,
	TeamHighlightBlue = 255,
	EnemyHighlightRed = 255,
	EnemyHighlightGreen = 0,
	EnemyHighlightBlue = 0,
	TeamHighlightColor = Color3.fromRGB(0, 120, 255),
	EnemyHighlightColor = Color3.fromRGB(255, 0, 0),
	AbyssValue = 50,
	HitboxSize = 8
}

Functions.TeamHighlights = {}
Functions.TeamHighlightConnections = {}
Functions.HitboxParts = {}
Functions.HitboxConnections = {}
Functions.LastAvatarUsername = nil

local function sideFromText(value)
	if value == nil then return nil end
	local text = tostring(value):lower()
	if text == "red" or text == "team1" or text == "team 1" or text == "side1" or text == "side 1" or text == "red team" or text:find("red") then return "red" end
	if text == "blue" or text == "team2" or text == "team 2" or text == "side2" or text == "side 2" or text == "blue team" or text:find("blue") then return "blue" end
	return nil
end

local function getSide(player)
	if not player then return nil end
	if player.Team then local side = sideFromText(player.Team.Name) if side then return side end end
	local side = sideFromText(player:GetAttribute("Team")) or sideFromText(player:GetAttribute("TeamName")) or sideFromText(player:GetAttribute("team")) or sideFromText(player:GetAttribute("teamName")) or sideFromText(player:GetAttribute("Side")) or sideFromText(player:GetAttribute("side"))
	if side then return side end
	local character = player.Character
	if character then
		side = sideFromText(character:GetAttribute("Team")) or sideFromText(character:GetAttribute("TeamName")) or sideFromText(character:GetAttribute("team")) or sideFromText(character:GetAttribute("teamName")) or sideFromText(character:GetAttribute("Side")) or sideFromText(character:GetAttribute("side"))
		if side then return side end
	end
	if player.TeamColor and player.TeamColor ~= BrickColor.new("Medium stone grey") then
		local color = player.TeamColor.Color
		if color.R > color.B then return "red" end
		if color.B > color.R then return "blue" end
	end
	return nil
end

local function isEnemy(player)
	if player == lp then return false end
	local mySide = getSide(lp)
	local theirSide = getSide(player)
	if mySide and theirSide then return mySide ~= theirSide end
	if lp.Team and player.Team then return lp.Team ~= player.Team end
	if lp.TeamColor and player.TeamColor and lp.TeamColor ~= BrickColor.new("Medium stone grey") and player.TeamColor ~= BrickColor.new("Medium stone grey") then return lp.TeamColor ~= player.TeamColor end
	return false
end

local function sameTeam(player)
	if player == lp then return true end
	local mySide = getSide(lp)
	local theirSide = getSide(player)
	if mySide and theirSide then return mySide == theirSide end
	if lp.Team and player.Team then return lp.Team == player.Team end
	if lp.TeamColor and player.TeamColor and lp.TeamColor ~= BrickColor.new("Medium stone grey") and player.TeamColor ~= BrickColor.new("Medium stone grey") then return lp.TeamColor == player.TeamColor end
	return false
end

local function isShiftlocked()
	return UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter or Functions.States.LOC == true
end

local function getTargetPart(character, mode)
	if not character then return nil end
	if mode == "Body" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head") end
	return character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
end

local function canSee(targetCharacter, targetPart)
	local camera = Workspace.CurrentCamera
	if not camera or not targetCharacter or not targetPart then return false end
	local localCharacter = lp.Character
	if not localCharacter then return false end
	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {localCharacter}
	params.IgnoreWater = true
	local result = Workspace:Raycast(origin, direction, params)
	return not result or result.Instance:IsDescendantOf(targetCharacter)
end

local function getTargetInView(fov, range, targetMode)
	local camera = Workspace.CurrentCamera
	if not camera then return nil end
	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local viewport = camera.ViewportSize
	local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
	local bestPart = nil
	local bestScreenDistance = fov
	local bestWorldDistance = range
	for _, player in ipairs(Players:GetPlayers()) do
		if isEnemy(player) then
			local enemyChar = player.Character
			local humanoid = enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")
			local enemyRoot = enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
			local part = enemyChar and getTargetPart(enemyChar, targetMode)
			if enemyChar and humanoid and humanoid.Health > 0 and enemyRoot and part then
				local worldDistance = (root.Position - enemyRoot.Position).Magnitude
				if worldDistance <= range and canSee(enemyChar, part) then
					local screenPosition, onScreen = camera:WorldToViewportPoint(part.Position)
					if onScreen and screenPosition.Z > 0 then
						local screenDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - center).Magnitude
						if screenDistance <= fov then
							if screenDistance < bestScreenDistance or (math.abs(screenDistance - bestScreenDistance) <= 5 and worldDistance < bestWorldDistance) then
								bestScreenDistance = screenDistance
								bestWorldDistance = worldDistance
								bestPart = part
							end
						end
					end
				end
			end
		end
	end
	return bestPart
end

local matchKeys = {
	"Match",
	"MatchId",
	"match",
	"matchId",
	"MatchID",
	"Game",
	"GameId",
	"game",
	"gameId",
	"GameID",
	"CurrentGame",
	"currentGame",
	"CurrentMatch",
	"currentMatch",
	"Round",
	"RoundId",
	"round",
	"roundId",
	"Arena",
	"ArenaId",
	"arena",
	"arenaId",
	"Duel",
	"DuelId",
	"duel",
	"duelId"
}

local function cleanMatchValue(value)
	if value == nil then return nil end
	value = tostring(value)
	if value == "" then return nil end
	local lower = value:lower()
	if lower == "nil" or lower == "none" or lower == "nothing" or lower == "false" or lower == "0" then
		return nil
	end
	return value
end

local function getMatchValueFromObject(obj)
	if not obj then return nil end

	for _, key in ipairs(matchKeys) do
		local value = cleanMatchValue(obj:GetAttribute(key))
		if value then
			return value
		end
	end

	for _, key in ipairs(matchKeys) do
		local child = obj:FindFirstChild(key)
		if child and child:IsA("ValueBase") then
			local value = cleanMatchValue(child.Value)
			if value then
				return value
			end
		end
	end

	return nil
end

local function getMatchContainer(character)
	if not character then return nil end

	local current = character.Parent
	while current and current ~= Workspace do
		local name = tostring(current.Name or ""):lower()
		if name:find("match", 1, true) or name:find("arena", 1, true) or name:find("round", 1, true) or name:find("duel", 1, true) or name:find("game", 1, true) then
			return current
		end
		current = current.Parent
	end

	return nil
end

local function getPlayerMatchValue(player)
	if not player then return nil end

	local value = getMatchValueFromObject(player)
	if value then
		return value
	end

	local character = player.Character
	value = getMatchValueFromObject(character)
	if value then
		return value
	end

	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	value = getMatchValueFromObject(humanoid)
	if value then
		return value
	end

	local root = character and character:FindFirstChild("HumanoidRootPart")
	value = getMatchValueFromObject(root)
	if value then
		return value
	end

	return nil
end

local function isSameMatch(player)
	if player == lp then return true end

	local myCharacter = lp.Character
	local targetCharacter = player.Character
	if not myCharacter or not targetCharacter then return false end

	local myMatch = getPlayerMatchValue(lp)
	local targetMatch = getPlayerMatchValue(player)

	if myMatch and targetMatch then
		return myMatch == targetMatch
	end

	local myContainer = getMatchContainer(myCharacter)
	local targetContainer = getMatchContainer(targetCharacter)

	if myContainer and targetContainer then
		return myContainer == targetContainer
	end

	return false
end

local function getClosestPlayerByCheck(checkFunction)
	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	local closestPlayer = nil
	local closestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp and isSameMatch(player) and checkFunction(player) then
			local targetCharacter = player.Character
			local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

			if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
				local distance = (root.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

local function teleportToPlayer(player)
	if not player then return false end
	if not isSameMatch(player) then return false end

	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local targetCharacter = player.Character
	local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

	if not root or not targetRoot then return false end

	root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
	return true
end

function Functions.UpdateAutoXDColor()
	Functions.Values.AutoXDFOVColor = Color3.fromRGB(math.clamp(Functions.Values.AutoXDFOVRed or 255, 0, 255), math.clamp(Functions.Values.AutoXDFOVGreen or 255, 0, 255), math.clamp(Functions.Values.AutoXDFOVBlue or 255, 0, 255))
end

function Functions.SetAutoXDFOVVisible(state)
	Functions.States.AutoXDFOVVisible = state
	Functions.Values.AutoXDFOVVisible = state
end

function Functions.SetAutoXDFOV(value)
	Functions.Values.AutoXDFOV = value
end

function Functions.SetAutoXDSmooth(value)
	Functions.Values.AutoXDSmooth = math.clamp(value / 100, 0.05, 1)
end

function Functions.SetAutoXDFOVRed(value)
	Functions.Values.AutoXDFOVRed = value
	Functions.UpdateAutoXDColor()
end

function Functions.SetAutoXDFOVGreen(value)
	Functions.Values.AutoXDFOVGreen = value
	Functions.UpdateAutoXDColor()
end

function Functions.SetAutoXDFOVBlue(value)
	Functions.Values.AutoXDFOVBlue = value
	Functions.UpdateAutoXDColor()
end

function Functions.SetAutoXD(state)
	Functions.States.AutoXD = state
	Functions.AutoXDId = (Functions.AutoXDId or 0) + 1
	local id = Functions.AutoXDId
	local playerGui = lp:WaitForChild("PlayerGui")
	if Functions.AutoXDRender then Functions.AutoXDRender:Disconnect() Functions.AutoXDRender = nil end
	local old = playerGui:FindFirstChild("AxiAutoXDFOV")
	if old then old:Destroy() end
	if not state then return end
	local fovGui = Instance.new("ScreenGui")
	fovGui.Name = "AxiAutoXDFOV"
	fovGui.IgnoreGuiInset = true
	fovGui.ResetOnSpawn = false
	fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	fovGui.DisplayOrder = 999998
	fovGui.Parent = playerGui
	local circle = Instance.new("Frame")
	circle.Name = "Circle"
	circle.AnchorPoint = Vector2.new(0.5, 0.5)
	circle.BackgroundTransparency = 1
	circle.Visible = false
	circle.ZIndex = 999998
	circle.Parent = fovGui
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle
	local circleStroke = Instance.new("UIStroke")
	circleStroke.Color = Functions.Values.AutoXDFOVColor
	circleStroke.Transparency = 0.18
	circleStroke.Thickness = 1.5
	circleStroke.Parent = circle
	Functions.AutoXDRender = RunService.RenderStepped:Connect(function()
		if not Functions.States.AutoXD or Functions.AutoXDId ~= id then
			if Functions.AutoXDRender then Functions.AutoXDRender:Disconnect() Functions.AutoXDRender = nil end
			local activeGui = playerGui:FindFirstChild("AxiAutoXDFOV")
			if activeGui then activeGui:Destroy() end
			return
		end
		local camera = Workspace.CurrentCamera
		if not camera then return end
		local viewport = camera.ViewportSize
		local fov = Functions.Values.AutoXDFOV or 155
		local shiftlocked = isShiftlocked()
		circle.Size = UDim2.fromOffset(fov * 2, fov * 2)
		circle.Position = UDim2.fromOffset(viewport.X / 2, viewport.Y / 2)
		circleStroke.Color = Functions.Values.AutoXDFOVColor or Color3.fromRGB(255, 255, 255)
		circle.Visible = Functions.Values.AutoXDFOVVisible and shiftlocked
		if not shiftlocked then return end
		local target = getTargetInView(fov, Functions.Values.AutoXDRange or 1000, Functions.Values.AutoXDTargetPart or "Head")
		if target then
			local smooth = math.clamp(Functions.Values.AutoXDSmooth or 0.42, 0.01, 1)
			local current = camera.CFrame
			local targetCFrame = CFrame.new(current.Position, target.Position)
			camera.CFrame = current:Lerp(targetCFrame, smooth)
		end
	end)
end

function Functions.SetOK(state)
	Functions.States.OK = state
	Functions.OKId = (Functions.OKId or 0) + 1
	local id = Functions.OKId
	if Functions.OKRender then Functions.OKRender:Disconnect() Functions.OKRender = nil end
	if not state then return end
	local lastShot = 0
	local function getEquippedGun()
		local character = lp.Character
		if not character then return nil end
		for _, tool in ipairs(character:GetChildren()) do
			if tool:IsA("Tool") then
				local name = tool.Name:lower()
				if name == "gun 2" or name == "gun2" or name:find("gun") then return tool end
			end
		end
		return nil
	end
	local function shoot()
		local gun = getEquippedGun()
		if not gun then return end
		local target = getTargetInView(Functions.Values.OKFOV or 160, Functions.Values.OKRange or 1200, Functions.Values.OKTargetPart or "Head")
		if not target then return end
		local now = os.clock()
		if now - lastShot < (Functions.Values.OKCooldown or 0) then return end
		lastShot = now
		pcall(function() gun:Activate() end)
	end
	Functions.OKRender = RunService.RenderStepped:Connect(function()
		if not Functions.States.OK or Functions.OKId ~= id then
			if Functions.OKRender then Functions.OKRender:Disconnect() Functions.OKRender = nil end
			return
		end
		if isShiftlocked() then shoot() end
	end)
end

function Functions.SetLOC(state)
	Functions.States.LOC = state
end

function Functions.SetSpeed(state)
	Functions.States.Speed = state
	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = state and Functions.Values.Speed or 16 end
end

function Functions.SetSpeedValue(value)
	Functions.Values.Speed = value
	if Functions.States.Speed then
		local character = lp.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = value end
	end
end

function Functions.SetJumpPower(state)
	Functions.States.JumpPower = state
	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		pcall(function()
			humanoid.UseJumpPower = true
		end)
		if state then
			humanoid.JumpPower = Functions.Values.JumpPower
		else
			humanoid.JumpPower = 50
		end
	end
end

function Functions.SetJumpPowerValue(value)
	Functions.Values.JumpPower = value
	if Functions.States.JumpPower then
		local character = lp.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function()
				humanoid.UseJumpPower = true
			end)
			humanoid.JumpPower = value
		end
	end
end

function Functions.CopyAvatar(username)
	username = tostring(username or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if username == "" then return end
	Functions.LastAvatarUsername = username
	task.spawn(function()
		local char = lp.Character or lp.CharacterAdded:Wait()
		local hum = char:WaitForChild("Humanoid", 10)
		if not hum then return end
		local targetPlayer = nil
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name:lower() == username:lower() or p.DisplayName:lower() == username:lower() then
				targetPlayer = p
				break
			end
		end
		local desc
		if targetPlayer and targetPlayer.Character then
			local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if targetHum then
				pcall(function()
					desc = targetHum:GetAppliedDescription()
				end)
			end
		end
		if not desc then
			local ok, userId = pcall(Players.GetUserIdFromNameAsync, Players, username)
			if not ok then warn("Not Found User") return end
			local ok2, d = pcall(Players.GetHumanoidDescriptionFromUserId, Players, userId)
			if not ok2 then warn("Bad") return end
			desc = d
		end
		for _, c in ipairs(char:GetChildren()) do
			if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("BodyColors") or c:IsA("CharacterMesh") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic") then
				c:Destroy()
			end
		end
		pcall(function()
			if hum.ApplyDescriptionClientServer then
				hum:ApplyDescriptionClientServer(desc)
			else
				hum:ApplyDescription(desc)
			end
		end)
		local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
		bc.Parent = char
		bc.HeadColor3 = desc.HeadColor
		bc.TorsoColor3 = desc.TorsoColor
		bc.LeftArmColor3 = desc.LeftArmColor
		bc.RightArmColor3 = desc.RightArmColor
		bc.LeftLegColor3 = desc.LeftLegColor
		bc.RightLegColor3 = desc.RightLegColor
	end)
end

function Functions.ResetAvatar()
	Functions.LastAvatarUsername = nil
	local char = lp.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local ok, desc = pcall(Players.GetHumanoidDescriptionFromUserId, Players, lp.UserId)
	if ok and desc then
		pcall(function()
			if hum.ApplyDescriptionClientServer then
				hum:ApplyDescriptionClientServer(desc)
			else
				hum:ApplyDescription(desc)
			end
		end)
	end
end

function Functions.UpdateHighlightColors()
	if not Functions.States.TeamRainbow then
		Functions.Values.TeamHighlightColor = Color3.fromRGB(math.clamp(Functions.Values.TeamHighlightRed or 0, 0, 255), math.clamp(Functions.Values.TeamHighlightGreen or 120, 0, 255), math.clamp(Functions.Values.TeamHighlightBlue or 255, 0, 255))
	end
	if not Functions.States.EnemyRainbow then
		Functions.Values.EnemyHighlightColor = Color3.fromRGB(math.clamp(Functions.Values.EnemyHighlightRed or 255, 0, 255), math.clamp(Functions.Values.EnemyHighlightGreen or 0, 0, 255), math.clamp(Functions.Values.EnemyHighlightBlue or 0, 0, 255))
	end
	for player, highlight in pairs(Functions.TeamHighlights) do
		if highlight and highlight.Parent then
			local color = sameTeam(player) and Functions.Values.TeamHighlightColor or Functions.Values.EnemyHighlightColor
			highlight.FillColor = color
			highlight.OutlineColor = color
		end
	end
end

function Functions.SetTeamColor(color)
	Functions.States.TeamRainbow = false
	Functions.Values.TeamHighlightRed = math.floor(color.R * 255)
	Functions.Values.TeamHighlightGreen = math.floor(color.G * 255)
	Functions.Values.TeamHighlightBlue = math.floor(color.B * 255)
	Functions.Values.TeamHighlightColor = color
	Functions.UpdateHighlightColors()
end

function Functions.SetEnemyColor(color)
	Functions.States.EnemyRainbow = false
	Functions.Values.EnemyHighlightRed = math.floor(color.R * 255)
	Functions.Values.EnemyHighlightGreen = math.floor(color.G * 255)
	Functions.Values.EnemyHighlightBlue = math.floor(color.B * 255)
	Functions.Values.EnemyHighlightColor = color
	Functions.UpdateHighlightColors()
end

function Functions.SetTeamHighlightRed(value) Functions.States.TeamRainbow = false Functions.Values.TeamHighlightRed = value Functions.UpdateHighlightColors() end
function Functions.SetTeamHighlightGreen(value) Functions.States.TeamRainbow = false Functions.Values.TeamHighlightGreen = value Functions.UpdateHighlightColors() end
function Functions.SetTeamHighlightBlue(value) Functions.States.TeamRainbow = false Functions.Values.TeamHighlightBlue = value Functions.UpdateHighlightColors() end
function Functions.SetEnemyHighlightRed(value) Functions.States.EnemyRainbow = false Functions.Values.EnemyHighlightRed = value Functions.UpdateHighlightColors() end
function Functions.SetEnemyHighlightGreen(value) Functions.States.EnemyRainbow = false Functions.Values.EnemyHighlightGreen = value Functions.UpdateHighlightColors() end
function Functions.SetEnemyHighlightBlue(value) Functions.States.EnemyRainbow = false Functions.Values.EnemyHighlightBlue = value Functions.UpdateHighlightColors() end
function Functions.TeamColorRed() Functions.SetTeamColor(Color3.fromRGB(255, 0, 0)) end
function Functions.TeamColorBlue() Functions.SetTeamColor(Color3.fromRGB(0, 120, 255)) end
function Functions.TeamColorGreen() Functions.SetTeamColor(Color3.fromRGB(0, 255, 80)) end
function Functions.TeamColorYellow() Functions.SetTeamColor(Color3.fromRGB(255, 230, 0)) end
function Functions.TeamColorPurple() Functions.SetTeamColor(Color3.fromRGB(160, 70, 255)) end
function Functions.TeamColorPink() Functions.SetTeamColor(Color3.fromRGB(255, 70, 190)) end
function Functions.TeamColorCyan() Functions.SetTeamColor(Color3.fromRGB(0, 255, 255)) end
function Functions.TeamColorWhite() Functions.SetTeamColor(Color3.fromRGB(255, 255, 255)) end
function Functions.EnemyColorRed() Functions.SetEnemyColor(Color3.fromRGB(255, 0, 0)) end
function Functions.EnemyColorBlue() Functions.SetEnemyColor(Color3.fromRGB(0, 120, 255)) end
function Functions.EnemyColorGreen() Functions.SetEnemyColor(Color3.fromRGB(0, 255, 80)) end
function Functions.EnemyColorYellow() Functions.SetEnemyColor(Color3.fromRGB(255, 230, 0)) end
function Functions.EnemyColorPurple() Functions.SetEnemyColor(Color3.fromRGB(160, 70, 255)) end
function Functions.EnemyColorPink() Functions.SetEnemyColor(Color3.fromRGB(255, 70, 190)) end
function Functions.EnemyColorCyan() Functions.SetEnemyColor(Color3.fromRGB(0, 255, 255)) end
function Functions.EnemyColorWhite() Functions.SetEnemyColor(Color3.fromRGB(255, 255, 255)) end

function Functions.StartHighlightRainbow()
	Functions.HighlightRainbowId = (Functions.HighlightRainbowId or 0) + 1
	local id = Functions.HighlightRainbowId
	task.spawn(function()
		while (Functions.States.TeamRainbow or Functions.States.EnemyRainbow) and Functions.HighlightRainbowId == id do
			local color = Color3.fromHSV((os.clock() * 0.22) % 1, 1, 1)
			if Functions.States.TeamRainbow then Functions.Values.TeamHighlightColor = color end
			if Functions.States.EnemyRainbow then Functions.Values.EnemyHighlightColor = color end
			Functions.UpdateHighlightColors()
			task.wait(0.05)
		end
	end)
end

function Functions.SetTeamRainbow(state)
	Functions.States.TeamRainbow = state
	Functions.StartHighlightRainbow()
	if not state then Functions.UpdateHighlightColors() end
end

function Functions.SetEnemyRainbow(state)
	Functions.States.EnemyRainbow = state
	Functions.StartHighlightRainbow()
	if not state then Functions.UpdateHighlightColors() end
end

function Functions.SetTeamHighlight(state)
	Functions.States.TeamHighlight = state
	Functions.TeamHighlights = Functions.TeamHighlights or {}
	Functions.TeamHighlightConnections = Functions.TeamHighlightConnections or {}
	Functions.TeamHighlightId = (Functions.TeamHighlightId or 0) + 1
	local id = Functions.TeamHighlightId
	local function clearHighlights()
		for _, highlight in pairs(Functions.TeamHighlights) do if highlight then highlight:Destroy() end end
		for _, connection in pairs(Functions.TeamHighlightConnections) do if connection then connection:Disconnect() end end
		Functions.TeamHighlights = {}
		Functions.TeamHighlightConnections = {}
	end
	local function removePlayer(player)
		local old = Functions.TeamHighlights[player]
		if old then old:Destroy() Functions.TeamHighlights[player] = nil end
	end
	local function applyPlayer(player)
		if not Functions.States.TeamHighlight or Functions.TeamHighlightId ~= id then return end
		if player == lp then removePlayer(player) return end
		local character = player.Character
		if not character then removePlayer(player) return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then removePlayer(player) return end
		local color = sameTeam(player) and Functions.Values.TeamHighlightColor or Functions.Values.EnemyHighlightColor
		local old = Functions.TeamHighlights[player]
		if old and old.Parent and old.Adornee == character then
			old.FillColor = color
			old.OutlineColor = color
			old.Enabled = true
			return
		end
		if old then old:Destroy() end
		local highlight = Instance.new("Highlight")
		highlight.Name = "TeamHighlight"
		highlight.Adornee = character
		highlight.FillColor = color
		highlight.OutlineColor = color
		highlight.FillTransparency = 0.35
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Enabled = true
		highlight.Parent = character
		Functions.TeamHighlights[player] = highlight
	end
	local function refresh()
		if not Functions.States.TeamHighlight or Functions.TeamHighlightId ~= id then clearHighlights() return end
		for _, player in ipairs(Players:GetPlayers()) do applyPlayer(player) end
		for player, highlight in pairs(Functions.TeamHighlights) do
			if not player.Parent or not player.Character or not highlight.Parent then removePlayer(player) end
		end
	end
	clearHighlights()
	if not state then return end
	Functions.UpdateHighlightColors()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp then
			Functions.TeamHighlightConnections[player] = player.CharacterAdded:Connect(function()
				task.wait(0.5)
				applyPlayer(player)
			end)
		end
	end
	Functions.TeamHighlightConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		Functions.TeamHighlightConnections[player] = player.CharacterAdded:Connect(function()
			task.wait(0.5)
			applyPlayer(player)
		end)
	end)
	Functions.TeamHighlightConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		removePlayer(player)
		local connection = Functions.TeamHighlightConnections[player]
		if connection then connection:Disconnect() Functions.TeamHighlightConnections[player] = nil end
	end)
	refresh()
	task.spawn(function()
		while Functions.States.TeamHighlight and Functions.TeamHighlightId == id do
			task.wait(2)
			refresh()
		end
	end)
end

function Functions.SetAbyssToggle(state)
	Functions.States.AbyssToggle = state
	Functions.AbyssId = (Functions.AbyssId or 0) + 1

	local id = Functions.AbyssId

	if Functions.AbyssConnection then
		Functions.AbyssConnection:Disconnect()
		Functions.AbyssConnection = nil
	end

	if not state then
		return
	end

	Functions.AbyssConnection = RunService.Stepped:Connect(function()
		if not Functions.States.AbyssToggle or Functions.AbyssId ~= id then
			if Functions.AbyssConnection then
				Functions.AbyssConnection:Disconnect()
				Functions.AbyssConnection = nil
			end
			return
		end

		local character = lp.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if character then
			for _, obj in ipairs(character:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.CanCollide = false
				end
			end
		end

		if humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
			local strength = math.clamp((Functions.Values.AbyssValue or 50) / 175, 0.01, 1)
			root.CFrame = root.CFrame + (humanoid.MoveDirection * strength)
		end
	end)
end

function Functions.SetAbyssValue(value)
	Functions.Values.AbyssValue = value
end

function Functions.StartFly()
	if Functions.States.Flying then return end

	Functions.States.Flying = true
	Functions.FlyId = (Functions.FlyId or 0) + 1

	local id = Functions.FlyId
	local character = lp.Character or lp.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	local velocity = Instance.new("BodyVelocity")
	velocity.Name = "AxiFlyVelocity"
	velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	velocity.Velocity = Vector3.zero
	velocity.Parent = root

	local gyro = Instance.new("BodyGyro")
	gyro.Name = "AxiFlyGyro"
	gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	gyro.P = 12000
	gyro.CFrame = root.CFrame
	gyro.Parent = root

	if humanoid then
		humanoid.PlatformStand = true
	end

	Functions.FlyVelocity = velocity
	Functions.FlyGyro = gyro

	if Functions.FlyConnection then
		Functions.FlyConnection:Disconnect()
		Functions.FlyConnection = nil
	end

	Functions.FlyConnection = RunService.RenderStepped:Connect(function()
		if not Functions.States.Flying or Functions.FlyId ~= id then
			Functions.StopFly()
			return
		end

		local currentCharacter = lp.Character
		local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
		local camera = Workspace.CurrentCamera

		if not currentRoot or not camera or not velocity or not velocity.Parent or not gyro or not gyro.Parent then
			Functions.StopFly()
			return
		end

		local direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			direction += camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			direction -= camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			direction -= camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			direction += camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.new(0, 1, 0)
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			direction -= Vector3.new(0, 1, 0)
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit
		end

		local speed = math.clamp((Functions.Values.AbyssValue or 50) * 2.2, 20, 220)

		velocity.Velocity = direction * speed
		gyro.CFrame = camera.CFrame
	end)
end

function Functions.StopFly()
	Functions.States.Flying = false
	Functions.FlyId = (Functions.FlyId or 0) + 1

	if Functions.FlyConnection then
		Functions.FlyConnection:Disconnect()
		Functions.FlyConnection = nil
	end

	if Functions.FlyVelocity then
		Functions.FlyVelocity:Destroy()
		Functions.FlyVelocity = nil
	end

	if Functions.FlyGyro then
		Functions.FlyGyro:Destroy()
		Functions.FlyGyro = nil
	end

	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.PlatformStand = false
	end
end

function Functions.AbyssSlotOne()
	Functions.StartFly()
end

function Functions.AbyssSlotTwo()
	Functions.StopFly()
end

function Functions.ExtraSlotOne()
	local target = getClosestPlayerByCheck(function(player)
		return isEnemy(player)
	end)

	if target then
		teleportToPlayer(target)
	else
		print("No enemy found in your match")
	end
end

function Functions.ExtraSlotTwo()
	local target = getClosestPlayerByCheck(function(player)
		return sameTeam(player) and player ~= lp
	end)

	if target then
		teleportToPlayer(target)
	else
		print("No teammate found in your match")
	end
end

function Functions.SetFastFlags(state)
	Functions.States.FastFlags = state
end

function Functions.SetNoDelay(state)
	Functions.States.NoDelay = state
end

function Functions.SetNotifications(state)
	Functions.States.Notifications = state
end

lp.CharacterAdded:Connect(function()
	task.wait(0.65)
	if Functions.States.Speed then Functions.SetSpeed(true) end
	if Functions.States.JumpPower then Functions.SetJumpPower(true) end
	if Functions.States.Flying then
		task.defer(function()
			Functions.StartFly()
		end)
	end
	if Functions.LastAvatarUsername then Functions.CopyAvatar(Functions.LastAvatarUsername) end
end)

Gui.Create(OptionConfig, Functions)
