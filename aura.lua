local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = nil

pcall(function()
	VirtualInputManager = game:GetService("VirtualInputManager")
end)

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local allowedGameIds = {
	[7219654364] = true,
	[9582119606] = true
}

local allowedRootPlaceIds = {
	[135856908115931] = true,
	[116817810725116] = true
}

local supportedGame = allowedGameIds[game.GameId] == true
	or allowedRootPlaceIds[game.PlaceId] == true

if not supportedGame then
	local oldFail = pg:FindFirstChild("AxiFailedLoad")
	if oldFail then
		oldFail:Destroy()
	end

	local failGui = Instance.new("ScreenGui")
	failGui.Name = "AxiFailedLoad"
	failGui.IgnoreGuiInset = true
	failGui.ResetOnSpawn = false
	failGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	failGui.DisplayOrder = 999999
	failGui.Parent = pg

	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.fromScale(0.5, 0.5)
	box.Size = UDim2.fromOffset(340, 118)
	box.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	box.BackgroundTransparency = 0.05
	box.BorderSizePixel = 0
	box.ZIndex = 10
	box.Parent = failGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 74, 96)
	stroke.Transparency = 0.25
	stroke.Thickness = 1
	stroke.Parent = box

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(18, 20)
	title.Size = UDim2.new(1, -36, 0, 30)
	title.Font = Enum.Font.GothamBlack
	title.Text = "game not supported"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 19
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 11
	title.Parent = box

	local desc = Instance.new("TextLabel")
	desc.BackgroundTransparency = 1
	desc.Position = UDim2.fromOffset(18, 55)
	desc.Size = UDim2.new(1, -36, 0, 36)
	desc.Font = Enum.Font.GothamBold
	desc.Text = "this game is not supported by axi"
	desc.TextColor3 = Color3.fromRGB(180, 186, 205)
	desc.TextSize = 13
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.ZIndex = 11
	desc.Parent = box

	return
end

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
		MatchTeleportIcon = "rbxthumb://type=Asset&id=104884198091376&w=150&h=150",
		EventIcon = "rbxthumb://type=Asset&id=76358039663036&w=150&h=150",
		GunIcon = "rbxthumb://type=Asset&id=78135843224493&w=150&h=150",
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
					Name = "Auto XD",
					Description = "Shiftlock FOV lock settings",
					Options = {
						{Type = "toggle", Name = "Auto XD", Description = "Enable enemy FOV lock", Callback = "SetAutoXD", Default = false},
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
					Name = "Main Controls",
					Description = "Core domination features",
					Options = {
						{Type = "toggle", Name = "OK", Description = "Toggle OK function", Callback = "SetOK", Default = false, Half = true},
						{Type = "toggle", Name = "LOC", Description = "Toggle LOC function", Callback = "SetLOC", Default = false, Half = true}
					}
				},
				{
					Name = "Movement",
					Description = "Speed options separated from main controls",
					Options = {
						{Type = "toggle", Name = "Speed", Description = "Enable custom walkspeed", Callback = "SetSpeed", Default = false},
						{Type = "slider", Name = "Speed Amount", Callback = "SetSpeedValue", Min = 16, Max = 200, Default = 16},
						{Type = "toggle", Name = "Jump Power", Description = "Enable custom jump power", Callback = "SetJumpPower", Default = false},
						{Type = "slider", Name = "Jump Amount", Callback = "SetJumpPowerValue", Min = 50, Max = 250, Default = 50}
					}
				},
				{
					Name = "Extra",
					Description = "More buttons for later",
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
					Description = "Player related options",
					Options = {
						{Type = "toggle", Name = "Enable Highlight Team", Description = "Separated highlight team function", Callback = "SetTeamHighlight", Default = false},
						{Type = "textbox", Name = "Copy Avatar", Description = "Put username and copy avatar", Placeholder = "Username", ButtonText = "Change", Callback = "CopyAvatar"},
						{Type = "button", Name = "Reset Avatar", Description = "Reset your avatar back", Callback = "ResetAvatar"}
					}
				},
				{
					Name = "Team Highlight RGB",
					Description = "Custom team highlight color",
					Options = {
						{Type = "slider", Name = "Team Red", Callback = "SetTeamHighlightRed", Min = 0, Max = 255, Default = 0},
						{Type = "slider", Name = "Team Green", Callback = "SetTeamHighlightGreen", Min = 0, Max = 255, Default = 120},
						{Type = "slider", Name = "Team Blue", Callback = "SetTeamHighlightBlue", Min = 0, Max = 255, Default = 255}
					}
				},
				{
					Name = "Team Color Presets",
					Description = "Fast colors for team highlight",
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
					Description = "Custom enemy highlight color",
					Options = {
						{Type = "slider", Name = "Enemy Red", Callback = "SetEnemyHighlightRed", Min = 0, Max = 255, Default = 255},
						{Type = "slider", Name = "Enemy Green", Callback = "SetEnemyHighlightGreen", Min = 0, Max = 255, Default = 0},
						{Type = "slider", Name = "Enemy Blue", Callback = "SetEnemyHighlightBlue", Min = 0, Max = 255, Default = 0}
					}
				},
				{
					Name = "Enemy Color Presets",
					Description = "Fast colors for enemy highlight",
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
					Name = "Abyss Main",
					Description = "Extra admin options",
					Options = {
						{Type = "toggle", Name = "Wall Phase", Description = "Go through walls", Callback = "SetAbyssToggle", Default = false},
						{Type = "slider", Name = "Phase Strength", Callback = "SetAbyssValue", Min = 1, Max = 100, Default = 50},
						{Type = "toggle", Name = "Xray", Description = "Optimized map xray", Callback = "SetXray", Default = false},
						{Type = "slider", Name = "Xray Power", Callback = "SetXrayPower", Min = 10, Max = 90, Default = 55},
						{Type = "toggle", Name = "Hitbox Extender", Description = "Client sided enemy hitbox extender", Callback = "SetHitboxExtender", Default = false},
						{Type = "slider", Name = "Hitbox Size", Callback = "SetHitboxSize", Min = 2, Max = 25, Default = 8},
						{Type = "toggle", Name = "Transparent Hitbox", Description = "Make extended hitboxes invisible", Callback = "SetHitboxInvisible", Default = false}
					}
				},
				{
					Name = "Abyss Controls",
					Description = "Quick controls",
					Options = {
						{Type = "textbox", Name = "Xray Amount", Description = "Put 10-90 then apply", Placeholder = "55", ButtonText = "Apply", Callback = "SetXrayPowerText"},
						{Type = "button", Name = "Refresh Xray", Description = "Re-scan map parts", Callback = "RefreshXrayButton"},
						{Type = "button", Name = "Start Fly", Description = "Start fly mode", Callback = "AbyssSlotOne"},
						{Type = "button", Name = "Stop Fly", Description = "Stop fly mode", Callback = "AbyssSlotTwo"}
					}
				}
			}
		},
		{
			Name = "Event",
			Icon = "rbxthumb://type=Asset&id=76358039663036&w=150&h=150",
			Color = Color3.fromRGB(70, 210, 255),
			Sections = {
				{
					Name = "Event Admin",
					Description = "Admin utility controls",
					Options = {
						{Type = "toggle", Name = "Auto Pickup", Description = "Collect event tridents only while you are in an active match", Callback = "SetAutoCollect", Default = false},
						{Type = "toggle", Name = "Auto Open Chest", Description = "Open at most one Atlantis chest per delay", Callback = "SetAutoOpenChest", Default = false},
						{Type = "toggle", Name = "Auto Buy Event Chest", Description = "Buy at most one event chest per delay", Callback = "SetAutoBuyEventChest", Default = false},
						{Type = "slider", Name = "Buy Chest Amount", Callback = "SetEventBuyAmount", Min = 1, Max = 25, Default = 1},
						{Type = "textbox", Name = "Auto Open Delay", Description = "Seconds between auto open attempts, minimum 60", Placeholder = "60", ButtonText = "Set", Callback = "SetAutoOpenDelay"},
						{Type = "textbox", Name = "Auto Buy Delay", Description = "Seconds between auto buy attempts, minimum 90", Placeholder = "60", ButtonText = "Set", Callback = "SetAutoBuyDelay"},
						{Type = "button", Name = "Buy Event Chest", Description = "Buy selected amount manually with safe delay", Callback = "BuyEventChest"},
						{Type = "button", Name = "Open Atlantis Chest", Description = "Open one Atlantis event chest manually", Callback = "OpenAtlantisChest"}
					}
				}
			}
		},
		{
			Name = "Gun",
			Icon = "rbxthumb://type=Asset&id=78135843224493&w=150&h=150",
			Color = Color3.fromRGB(255, 115, 70),
			Sections = {
				{
					Name = "Gun Toggle",
					Description = "Enable or disable weapon keybind handling",
					Options = {
						{Type = "toggle", Name = "Enable Gun Keybind", Description = "Allow custom gun keybind", Callback = "SetGunEnabled", Default = false},
						{Type = "toggle", Name = "Enable Knife Keybind", Description = "Allow custom knife keybind", Callback = "SetKnifeEnabled", Default = false}
					}
				},
				{
					Name = "Gun Keybinds",
					Description = "Choose custom keys",
					Options = {
						{Type = "textbox", Name = "Gun Keybind", Description = "MouseButton1, Q, F, etc", Placeholder = "MouseButton1", ButtonText = "Set", Callback = "SetGunKeybind"},
						{Type = "textbox", Name = "Knife Keybind", Description = "E, Q, F, etc", Placeholder = "E", ButtonText = "Set", Callback = "SetKnifeKeybind"}
					}
				},
				{
					Name = "Weapon Delay",
					Description = "Set weapon delays without spam",
					Options = {
						{Type = "textbox", Name = "Gun Delay", Description = "Seconds between gun shots, example 0.35", Placeholder = "0.35", ButtonText = "Set", Callback = "SetGunDelay"},
						{Type = "textbox", Name = "Knife Delay", Description = "Seconds between knife uses, example 0.35", Placeholder = "0.35", ButtonText = "Set", Callback = "SetKnifeDelay"},
						{Type = "textbox", Name = "OK Delay", Description = "Seconds between OK shots, example 0.25", Placeholder = "0.25", ButtonText = "Set", Callback = "SetOKDelay"}
					}
				},
				{
					Name = "Manual Use",
					Description = "Use detected weapon once",
					Options = {
						{Type = "button", Name = "Use Gun", Description = "Equip gun, click once, then unequip safely", Callback = "UseDetectedGun", Half = true},
						{Type = "button", Name = "Use Knife", Description = "Equip knife, press E once, then unequip safely", Callback = "UseDetectedKnife", Half = true}
					}
				}
			}
		},
		{
			Name = "Match Teleport",
			Icon = "rbxthumb://type=Asset&id=104884198091376&w=150&h=150",
			Color = Color3.fromRGB(255, 190, 80),
			Sections = {
				{
					Name = "Match Mode",
					Description = "Choose the queue size",
					Options = {
						{Type = "button", Name = "1v1", Description = "Use 1v1 lobby circles", Callback = "SelectMatch1v1", Half = true, SelectionGroup = "MatchMode", SelectionValue = "1v1", SelectedDefault = true},
						{Type = "button", Name = "2v2", Description = "Use 2v2 lobby circles", Callback = "SelectMatch2v2", Half = true, SelectionGroup = "MatchMode", SelectionValue = "2v2"},
						{Type = "button", Name = "3v3", Description = "Use 3v3 lobby circles", Callback = "SelectMatch3v3", Half = true, SelectionGroup = "MatchMode", SelectionValue = "3v3"},
						{Type = "button", Name = "4v4", Description = "Use 4v4 lobby circles", Callback = "SelectMatch4v4", Half = true, SelectionGroup = "MatchMode", SelectionValue = "4v4"},
						{Type = "button", Name = "5v5", Description = "Use 5v5 lobby circles", Callback = "SelectMatch5v5", SelectionGroup = "MatchMode", SelectionValue = "5v5"}
					}
				},
				{
					Name = "Arena",
					Description = "Choose which lobby arena row",
					Options = {
						{Type = "button", Name = "Arena 1", Description = "Use first arena", Callback = "SelectMatchArena1", Half = true, SelectionGroup = "MatchArena", SelectionValue = "1", SelectedDefault = true},
						{Type = "button", Name = "Arena 2", Description = "Use second arena", Callback = "SelectMatchArena2", Half = true, SelectionGroup = "MatchArena", SelectionValue = "2"}
					}
				},
				{
					Name = "Circle Side",
					Description = "Choose the exact circle side",
					Options = {
						{Type = "button", Name = "Left Circle", Description = "Use left circle", Callback = "SelectMatchLeft", Half = true, SelectionGroup = "MatchSide", SelectionValue = "Left", SelectedDefault = true},
						{Type = "button", Name = "Right Circle", Description = "Use right circle", Callback = "SelectMatchRight", Half = true, SelectionGroup = "MatchSide", SelectionValue = "Right"}
					}
				},
				{
					Name = "Teleport Controls",
					Description = "Selected mode, arena and side are used here",
					Options = {
						{Type = "button", Name = "Teleport Selected", Description = "Teleport to current selected circle", Callback = "TeleportSelectedMatch"},
						{Type = "toggle", Name = "Auto Match Teleport", Description = "Teleport immediately outside matches, pause during matches, resume when they end", Callback = "SetAutoMatchTeleport", Default = false},
						{Type = "separator", Name = "---------------------"},
						{Type = "toggle", Name = "Auto Teleport User", Description = "1v1 only. Follow the opponent during the match. admin movement option", Callback = "SetAutoTeleportUser", Default = false},
						{Type = "separator", Name = "---------------------"},
						{Type = "toggle", Name = "Auto Knife", Description = "1v1 only. Keep the knife equipped. admin movement option", Callback = "SetAutoKnife", Default = false},
						{Type = "separator", Name = "---------------------"},
						{Type = "toggle", Name = "Auto Swing", Description = "1v1 only. Uses knife while held and falls back to gun if knife is missing. admin movement option", Callback = "SetAutoSwing", Default = false}
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
						{Type = "toggle", Name = "Fast Flags", Description = "Placeholder setting", Callback = "SetFastFlags", Default = false},
						{Type = "toggle", Name = "No Delay", Description = "Placeholder setting", Callback = "SetNoDelay", Default = false}
					}
				},
				{
					Name = "Notifications",
					Description = "Panel notifications",
					Options = {
						{Type = "toggle", Name = "Notifications", Description = "Enable or disable notifications", Callback = "SetNotifications", Default = true}
					}
				},
				{
					Name = "Config Save",
					Description = "Save or load local Axi settings",
					Options = {
						{Type = "button", Name = "Save Config", Description = "Save current toggles, delays and keybinds", Callback = "SaveConfig", Half = true},
						{Type = "button", Name = "Load Config", Description = "Load saved toggles, delays and keybinds", Callback = "LoadConfig", Half = true},
						{Type = "button", Name = "Delete Config", Description = "Delete saved axi_config files", Callback = "DeleteConfig", Half = true},
						{Type = "button", Name = "Config Status", Description = "Check if axi_config file API and saved file work", Callback = "ConfigStatus", Half = true},
						{Type = "toggle", Name = "Auto Load Config", Description = "Automatically load saved config when the panel starts", Callback = "SetAutoLoadConfig", Default = false},
						{Type = "toggle", Name = "Auto Save Config", Description = "Automatically save config on a safe interval without spam", Callback = "SetAutoSaveConfig", Default = false},
						{Type = "textbox", Name = "Auto Save Delay", Description = "Seconds between auto saves, minimum 90", Placeholder = "60", ButtonText = "Set", Callback = "SetAutoSaveDelay"}
					}
				},
				{
					Name = "Keybinds",
					Description = "Menu controls",
					Options = {
						{Type = "textbox", Name = "Menu Keybind", Description = "Put L, K, RightShift, etc", Placeholder = "L", ButtonText = "Set", Callback = "SetMenuKeybind"},
						{Type = "toggle", Name = "Hide Logo", Description = "Hide the small logo and reopen with keybind", Callback = "SetHideLogo", Default = false},
						{Type = "toggle", Name = "Anti AFK", Description = "Keep the admin session active while idle", Callback = "SetAntiAFK", Default = false},
						{Type = "toggle", Name = "Auto Close Match Stats", Description = "Automatically close match stats when shown without spamming REMOVE", Callback = "SetAutoCloseStats", Default = false},
						{Type = "button", Name = "Remove Game Stats", Description = "Fire REMOVE once with cooldown and hide stats", Callback = "CloseMatchStats"}
					}
				}
			}
		}
	}
}

local function censorProfileName(value)
	local text = tostring(value or "user")
	local visible = text:sub(1, 3)
	if visible == "" then
		visible = "usr"
	end
	return visible .. "***"
end

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

	Functions.OptionControls = Functions.OptionControls or {}
	Functions.OptionControlsByName = Functions.OptionControlsByName or {}
	Functions.UIConfig = Functions.UIConfig or {}

	local function saveOptionValue(data, value)
		if not data then
			return
		end

		local key = data.Callback or data.Name

		if not key then
			return
		end

		Functions.UIConfig[key] = value
	end

	local function registerOptionControl(data, control)
		if not data or not control then
			return control
		end

		if data.Callback then
			Functions.OptionControls[data.Callback] = control
		end

		if data.Name then
			Functions.OptionControlsByName[data.Name] = control
		end

		return control
	end

	function Functions.Notify(title, text, duration)
		if Functions.States and Functions.States.Notifications == false then return end

		local notifyKey = tostring(title or "Axi") .. ":" .. tostring(text or "")
		local now = os.clock()

		if Functions.LastNotifyText == notifyKey
			and Functions.LastNotifyClock
			and now - Functions.LastNotifyClock < 10
		then
			return
		end

		Functions.LastNotifyText = notifyKey
		Functions.LastNotifyClock = now

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
		return false
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
		local total = 3
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
	displayName.Text = censorProfileName(lp.DisplayName)
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
	userName.Text = "@" .. censorProfileName(lp.Name)
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
			saveOptionValue(data, state)
			if instant then
				toggle.BackgroundColor3 = state and Color3.fromRGB(255, 74, 96) or Color3.fromRGB(20, 20, 24)
				dot.Position = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)
			else
				tween(toggle, {BackgroundColor3 = state and Color3.fromRGB(255, 74, 96) or Color3.fromRGB(20, 20, 24)}, 0.18)
				tween(dot, {Position = state and UDim2.fromOffset(26, 4) or UDim2.fromOffset(4, 4)}, 0.18)
			end
			if data.Callback and Functions[data.Callback] and not instant then
				pcall(function()
					Functions[data.Callback](state)
				end)

				if Functions.QueueConfigSave then
					Functions.QueueConfigSave()
				end
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
			saveOptionValue(data, value)
			valueText.Text = tostring(value)
			fill.Size = UDim2.fromScale(rel, 1)
			knob.Position = UDim2.fromScale(rel, 0.5)
			if data.Callback and Functions[data.Callback] and not instant then
				pcall(function()
					Functions[data.Callback](value)
				end)

				if Functions.QueueConfigSave then
					Functions.QueueConfigSave()
				end
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

	local function makeSeparator(parent, data)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 26)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ZIndex = 27
		holder.Parent = parent

		local line = Instance.new("Frame")
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.Position = UDim2.fromScale(0.5, 0.5)
		line.Size = UDim2.new(1, -28, 0, 1)
		line.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		line.BackgroundTransparency = 0.35
		line.BorderSizePixel = 0
		line.ZIndex = 28
		line.Parent = holder

		local label = Instance.new("TextLabel")
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Position = UDim2.fromScale(0.5, 0.5)
		label.Size = UDim2.fromOffset(150, 18)
		label.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
		label.BackgroundTransparency = 0.08
		label.BorderSizePixel = 0
		label.Text = data.Name or "---------------------"
		label.TextColor3 = Color3.fromRGB(255, 74, 96)
		label.TextSize = 11
		label.Font = Enum.Font.GothamBlack
		label.ZIndex = 29
		label.Parent = holder

		return holder
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

		local selectionAccent

		if data.SelectionGroup then
			selectionAccent = Instance.new("Frame")
			selectionAccent.Name = "SelectionAccent"
			selectionAccent.Size = UDim2.new(1, -18, 0, 3)
			selectionAccent.Position = UDim2.new(0, 9, 1, -7)
			selectionAccent.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
			selectionAccent.BackgroundTransparency = data.SelectedDefault and 0 or 1
			selectionAccent.BorderSizePixel = 0
			selectionAccent.ZIndex = 30
			selectionAccent.Parent = b

			corner(selectionAccent, 3)

			Functions.SelectionButtons = Functions.SelectionButtons or {}
			Functions.SelectedButtons = Functions.SelectedButtons or {}
			Functions.SelectionButtons[data.SelectionGroup] = Functions.SelectionButtons[data.SelectionGroup] or {}

			local selectionValue = data.SelectionValue or data.Name

			Functions.SelectionButtons[data.SelectionGroup][selectionValue] = {
				Button = b,
				Accent = selectionAccent
			}

			if data.SelectedDefault then
				Functions.SelectedButtons[data.SelectionGroup] = selectionValue
			end
		end

		b.MouseButton1Click:Connect(function()
			if data.SelectionGroup then
				Functions.SelectedButtons = Functions.SelectedButtons or {}
				local selectionValue = data.SelectionValue or data.Name
				Functions.SelectedButtons[data.SelectionGroup] = selectionValue
				Functions.UIConfig = Functions.UIConfig or {}
				Functions.UIConfig["Selection:" .. tostring(data.SelectionGroup)] = selectionValue

				local group = Functions.SelectionButtons
					and Functions.SelectionButtons[data.SelectionGroup]

				if group then
					for value, info in pairs(group) do
						if info.Accent and info.Accent.Parent then
							tween(
								info.Accent,
								{
									BackgroundTransparency =
										value == selectionValue and 0 or 1
								},
								0.16
							)
						end
					end
				end

				if Functions.QueueConfigSave then
					Functions.QueueConfigSave()
				end
			end

			if data.Callback and Functions[data.Callback] then
				local ok, result = pcall(Functions[data.Callback])

				if Functions.QueueConfigSave then
					Functions.QueueConfigSave()
				end

				if Functions.Notify then
					if ok then
						Functions.Notify("Axi", data.Name .. (result == false and " failed" or " clicked"), 1.5)
					else
						Functions.Notify("Axi", data.Name .. " error", 2)
					end
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
			if text ~= "" then
				saveOptionValue(data, text)
			end

			if text ~= "" and data.Callback and Functions[data.Callback] then
				pcall(function()
					Functions[data.Callback](text)
				end)

				if Functions.QueueConfigSave then
					Functions.QueueConfigSave()
				end
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

		return {
			Get = function()
				return box.Text
			end,
			Set = function(v)
				local textValue = tostring(v or "")
				box.Text = textValue
				saveOptionValue(data, textValue)
			end
		}
	end

	local function addOption(parent, data)
		if data.Type == "toggle" then
			return registerOptionControl(data, makeToggle(parent, data, false))
		elseif data.Type == "slider" then
			return registerOptionControl(data, makeSlider(parent, data))
		elseif data.Type == "button" then
			return registerOptionControl(data, makeButton(parent, data, false))
		elseif data.Type == "textbox" then
			return registerOptionControl(data, makeTextBox(parent, data))
		elseif data.Type == "separator" then
			return makeSeparator(parent, data)
		end

		return nil
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
						if data.Type == "button" then registerOptionControl(data, makeButton(row, data, true)) else registerOptionControl(data, makeToggle(row, data, true)) end
						if nextData.Type == "button" then registerOptionControl(nextData, makeButton(row, nextData, true)) else registerOptionControl(nextData, makeToggle(row, nextData, true)) end
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
	Functions.MenuKeybind = Functions.MenuKeybind or Enum.KeyCode.L
	Functions.GuiObjects = {
		Main = main,
		Minimized = minimized,
		Blur = blur
	}
	Functions.GuiLoaded = false

	local function setMinimizedVisible(state)
		minimized.Visible = state
			and Functions.GuiLoaded == true
			and not Functions.States.HideLogo
			and main.Visible == false
	end

	local function openPanel()
		if busy then return end
		busy = true
		Functions.GuiLoaded = true
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
		busy = true
		tween(blur, {Size = 0}, 0.25)
		local t = tween(main, {Size = UDim2.fromOffset(96, 76), Position = minimized.Position, BackgroundTransparency = 1}, 0.32)
		t.Completed:Connect(function()
			main.Visible = false
			setMinimizedVisible(true)
			minimized.Size = minStartSize
			if minimized.Visible then
				tween(minimized, {Size = minClosedSize}, 0.26)
			end
			busy = false
		end)
	end

	local closeConfirmOpen = false
	local closeConfirmToken = 0

	local function closePanel()
		if busy or closeConfirmOpen then
			return
		end

		closeConfirmOpen = true
		closeConfirmToken += 1

		local token = closeConfirmToken
		local confirm = Instance.new("Frame")
		confirm.Name = "CloseConfirm"
		confirm.AnchorPoint = Vector2.new(0.5, 0.5)
		confirm.Position = UDim2.fromScale(0.5, 0.5)
		confirm.Size = UDim2.fromOffset(360, 176)
		confirm.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
		confirm.BackgroundTransparency = 0.04
		confirm.BorderSizePixel = 0
		confirm.ZIndex = 500
		confirm.Parent = main
		corner(confirm, 18)
		stroke(confirm, Color3.fromRGB(255, 74, 96), 0.28, 1)

		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Position = UDim2.fromOffset(20, 18)
		title.Size = UDim2.new(1, -40, 0, 28)
		title.Font = Enum.Font.GothamBlack
		title.Text = "close axi?"
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = 501
		title.Parent = confirm

		local desc = Instance.new("TextLabel")
		desc.BackgroundTransparency = 1
		desc.Position = UDim2.fromOffset(20, 52)
		desc.Size = UDim2.new(1, -40, 0, 44)
		desc.Font = Enum.Font.GothamBold
		desc.Text = "This will fully close the admin panel."
		desc.TextColor3 = Color3.fromRGB(175, 181, 200)
		desc.TextSize = 12
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextYAlignment = Enum.TextYAlignment.Top
		desc.ZIndex = 501
		desc.Parent = confirm

		local cancel = Instance.new("TextButton")
		cancel.Size = UDim2.new(0.5, -25, 0, 42)
		cancel.Position = UDim2.fromOffset(20, 114)
		cancel.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
		cancel.BackgroundTransparency = 0.12
		cancel.BorderSizePixel = 0
		cancel.Text = "Cancel"
		cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
		cancel.TextSize = 13
		cancel.Font = Enum.Font.GothamBlack
		cancel.AutoButtonColor = false
		cancel.ZIndex = 501
		cancel.Parent = confirm
		corner(cancel, 12)

		local yes = Instance.new("TextButton")
		yes.Size = UDim2.new(0.5, -25, 0, 42)
		yes.Position = UDim2.new(0.5, 5, 0, 114)
		yes.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		yes.BackgroundTransparency = 0.16
		yes.BorderSizePixel = 0
		yes.Text = "Close"
		yes.TextColor3 = Color3.fromRGB(255, 255, 255)
		yes.TextSize = 13
		yes.Font = Enum.Font.GothamBlack
		yes.AutoButtonColor = false
		yes.ZIndex = 501
		yes.Parent = confirm
		corner(yes, 12)

		cancel.MouseButton1Click:Connect(function()
			if token ~= closeConfirmToken then
				return
			end

			closeConfirmOpen = false

			if confirm and confirm.Parent then
				confirm:Destroy()
			end
		end)

		yes.MouseButton1Click:Connect(function()
			if token ~= closeConfirmToken or busy then
				return
			end

			closeConfirmOpen = false
			busy = true

			if Functions.Notify then
				Functions.Notify("Axi", "Panel closed", 1.2)
			end

			tween(blur, {Size = 0}, 0.25)

			local t = tween(
				main,
				{
					Size = UDim2.fromOffset(640, 370),
					Position = UDim2.fromScale(0.5, 0.54),
					BackgroundTransparency = 1
				},
				0.32
			)

			t.Completed:Connect(function()
				gui:Destroy()
				blur:Destroy()
			end)
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

	if Functions.PendingConfigData then
		task.defer(function()
			Functions.ApplyConfigToUI(Functions.PendingConfigData)
			Functions.PendingConfigData = nil
		end)
	end



	UserInputService.InputBegan:Connect(function(input, typing)
		if typing then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.KeyCode == Enum.KeyCode.ButtonR2
		then
			Functions.AttackInputHeld = true
		end

		if input.KeyCode == Functions.MenuKeybind then
			if main.Visible then
				minimizePanel()
			else
				openPanel()
			end
		end

		local gunPressed = false

		if Functions.GunKeybind.EnumType == Enum.UserInputType then
			gunPressed = input.UserInputType == Functions.GunKeybind
		elseif Functions.GunKeybind.EnumType == Enum.KeyCode then
			gunPressed = input.KeyCode == Functions.GunKeybind
		end

		if gunPressed
			and Functions.States.GunEnabled
			and Functions.CanUseMatchWeapon
			and Functions.CanUseMatchWeapon()
			and not Functions.GunBusy
		then
			Functions.GunBusy = true
			Functions.UseDetectedGun()
			task.delay(math.clamp(tonumber(Functions.Values.GunDelay) or 10, 10, 60), function()
				Functions.GunBusy = false
			end)
		elseif input.KeyCode == Functions.KnifeKeybind
			and Functions.States.KnifeEnabled
			and Functions.CanUseMatchWeapon
			and Functions.CanUseMatchWeapon()
			and not Functions.KnifeBusy
		then
			Functions.KnifeBusy = true
			Functions.UseDetectedKnife()
			task.delay(math.clamp(tonumber(Functions.Values.KnifeDelay) or 10, 10, 60), function()
				Functions.KnifeBusy = false
			end)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.KeyCode == Enum.KeyCode.ButtonR2
		then
			Functions.AttackInputHeld = false
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
		Functions.GuiLoaded = true
		minimized.Visible = false
		main.Visible = true
		tween(blur, {Size = 10}, 0.35)
		tween(main, {Size = openSize, Position = openPos, BackgroundTransparency = 0.58}, 0.5)
		task.defer(function()
			minimized.Visible = false
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
	GunTrespasser = false,
	Xray = false,
	HideLogo = false,
	TeamRainbow = false,
	EnemyRainbow = false,
	AutoMatchTeleport = false,
	AutoTeleportUser = false,
	AutoKnife = false,
	AutoSwing = false,
	AntiAFK = false,
	AutoLoadConfig = false,
	AutoSaveConfig = false,
	AutoCollect = false,
	AutoOpenChest = false,
	AutoBuyEventChest = false,
	AutoCloseStats = false,
	GunEnabled = false,
	KnifeEnabled = false
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
	OKCooldown = 0.25,
	OKTargetPart = "Head",
	GunDelay = 10,
	KnifeDelay = 10,
	TeamHighlightRed = 0,
	TeamHighlightGreen = 120,
	TeamHighlightBlue = 255,
	EnemyHighlightRed = 255,
	EnemyHighlightGreen = 0,
	EnemyHighlightBlue = 0,
	TeamHighlightColor = Color3.fromRGB(0, 120, 255),
	EnemyHighlightColor = Color3.fromRGB(255, 0, 0),
	AbyssValue = 50,
	HitboxSize = 8,
	EventBuyAmount = 1,
	AutoOpenDelay = 60,
	AutoBuyDelay = 90,
	ManualEventBuyDelay = 10,
	ManualEventOpenDelay = 10,
	AutoSaveDelay = 60
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


Functions.MatchLocations = {
	["1v1"] = {
		[1] = {
			Left = Vector3.new(-303.084808349609375, 241.808029174804688, -0.373334735631943),
			Right = Vector3.new(-297.515106201171875, 241.808029174804688, -0.543307602405548)
		},
		[2] = {
			Left = Vector3.new(-302.945404052734375, 241.808029174804688, 31.215753555297852),
			Right = Vector3.new(-295.819274902343750, 241.808029174804688, 32.124301910400391)
		}
	},
	["2v2"] = {
		[1] = {
			Left = Vector3.new(-286.341491699218750, 241.808029174804688, 0.298778653144836),
			Right = Vector3.new(-279.289367675781250, 241.808029174804688, -0.390891194343567)
		},
		[2] = {
			Left = Vector3.new(-287.076629638671875, 241.808029174804688, 31.265998840332031),
			Right = Vector3.new(-279.128540039062500, 241.808044433593750, 31.554454803466797)
		}
	},
	["3v3"] = {
		[1] = {
			Left = Vector3.new(-269.742797851562500, 241.808029174804688, 0.103964291512966),
			Right = Vector3.new(-263.713165283203125, 241.808029174804688, 0.278522223234177)
		},
		[2] = {
			Left = Vector3.new(-270.615203857421875, 241.808029174804688, 31.554899215698242),
			Right = Vector3.new(-263.200988769531250, 241.808029174804688, 31.007457733154297)
		}
	},
	["4v4"] = {
		[1] = {
			Left = Vector3.new(-253.807815551757812, 241.808029174804688, -0.435267329216003),
			Right = Vector3.new(-247.181716918945312, 241.808029174804688, 0.491979122161865)
		},
		[2] = {
			Left = Vector3.new(-253.991012573242188, 241.808029174804688, 32.312515258789062),
			Right = Vector3.new(-246.484161376953125, 241.808044433593750, 32.115348815917969)
		}
	},
	["5v5"] = {
		[1] = {
			Left = Vector3.new(-237.325988769531250, 241.808029174804688, 0.465870589017868),
			Right = Vector3.new(-229.069747924804688, 241.808044433593750, 0.269989609718323)
		},
		[2] = {
			Left = Vector3.new(-237.791717529296875, 241.808029174804688, 31.399333953857422),
			Right = Vector3.new(-228.998733520507812, 241.808029174804688, 31.571865081787109)
		}
	}
}

Functions.SelectedMatchMode = "1v1"
Functions.SelectedMatchArena = 1
Functions.SelectedMatchSide = "Left"
Functions.GunKeybind = Enum.UserInputType.MouseButton1
Functions.KnifeKeybind = Enum.KeyCode.E
Functions.GunBusy = false
Functions.KnifeBusy = false

local eventMatchKeys = {
	"Match",
	"MatchId",
	"match",
	"matchId",
	"MatchID",
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

local function cleanEventMatchValue(value)
	if value == nil then return nil end
	value = tostring(value)
	if value == "" then return nil end
	local lower = value:lower()
	if lower == "nil" or lower == "none" or lower == "nothing" or lower == "false" or lower == "0" then
		return nil
	end
	return value
end

local function getEventMatchValue(obj)
	if not obj then return nil end

	for _, key in ipairs(eventMatchKeys) do
		local value = cleanEventMatchValue(obj:GetAttribute(key))
		if value then
			return value
		end
	end

	for _, key in ipairs(eventMatchKeys) do
		local child = obj:FindFirstChild(key)
		if child and child:IsA("ValueBase") then
			local value = cleanEventMatchValue(child.Value)
			if value then
				return value
			end
		end
	end

	return nil
end

local function isGuiActuallyVisible(guiObject)
	if not guiObject or not guiObject:IsDescendantOf(pg) then
		return false
	end

	local current = guiObject

	while current and current ~= pg do
		if current:IsA("GuiObject") and not current.Visible then
			return false
		end

		if current:IsA("ScreenGui") and not current.Enabled then
			return false
		end

		current = current.Parent
	end

	return true
end

local function getMatchStatsGuiForCheck()
	local mainGui = pg:FindFirstChild("Main")
	local mainGameFrame = mainGui and mainGui:FindFirstChild("MainGameFrame")
	local gameStats = mainGameFrame and mainGameFrame:FindFirstChild("GameStats")

	if gameStats and gameStats:IsA("GuiObject") then
		return gameStats
	end

	return nil
end

local function isLocalPlayerInMatch()
	local character = lp.Character
	if not character then
		return false
	end

	local objects = {
		lp,
		character,
		character:FindFirstChildOfClass("Humanoid"),
		character:FindFirstChild("HumanoidRootPart")
	}

	for _, obj in ipairs(objects) do
		if obj and getEventMatchValue(obj) then
			return true
		end
	end

	local current = character.Parent

	while current and current ~= Workspace do
		local name = tostring(current.Name or ""):lower()

		if name:find("match", 1, true)
			or name:find("arena", 1, true)
			or name:find("round", 1, true)
			or name:find("duel", 1, true)
		then
			return true
		end

		current = current.Parent
	end

	return false
end

local function getNearestMatchQueueDistance()
	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return math.huge
	end

	local best = math.huge

	for _, modeData in pairs(Functions.MatchLocations) do
		for _, arenaData in pairs(modeData) do
			for _, position in pairs(arenaData) do
				local distance = (root.Position - position).Magnitude

				if distance < best then
					best = distance
				end
			end
		end
	end

	return best
end

function Functions.CanUseMatchWeapon()
	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return false
	end

	return isLocalPlayerInMatch()
end

function Functions.SelectMatch1v1()
	Functions.SelectedMatchMode = "1v1"
end

function Functions.SelectMatch2v2()
	Functions.SelectedMatchMode = "2v2"
end

function Functions.SelectMatch3v3()
	Functions.SelectedMatchMode = "3v3"
end

function Functions.SelectMatch4v4()
	Functions.SelectedMatchMode = "4v4"
end

function Functions.SelectMatch5v5()
	Functions.SelectedMatchMode = "5v5"
end

function Functions.SelectMatchArena1()
	Functions.SelectedMatchArena = 1
end

function Functions.SelectMatchArena2()
	Functions.SelectedMatchArena = 2
end

function Functions.SelectMatchLeft()
	Functions.SelectedMatchSide = "Left"
end

function Functions.SelectMatchRight()
	Functions.SelectedMatchSide = "Right"
end

local function getSelectedMatchPosition()
	local modeData = Functions.MatchLocations[Functions.SelectedMatchMode]
	local arenaData = modeData and modeData[Functions.SelectedMatchArena]
	return arenaData and arenaData[Functions.SelectedMatchSide]
end

local function getOppositeMatchPosition()
	local modeData = Functions.MatchLocations[Functions.SelectedMatchMode]
	local arenaData = modeData and modeData[Functions.SelectedMatchArena]

	if not arenaData then
		return nil
	end

	if Functions.SelectedMatchSide == "Left" then
		return arenaData.Right
	end

	return arenaData.Left
end

local function getPlayersNearQueue(radius)
	local result = {}
	local selectedPosition = getSelectedMatchPosition()
	local oppositePosition = getOppositeMatchPosition()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp then
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if root and humanoid and humanoid.Health > 0 then
				local nearSelected = selectedPosition
					and (root.Position - selectedPosition).Magnitude <= radius

				local nearOpposite = oppositePosition
					and (root.Position - oppositePosition).Magnitude <= radius

				if nearSelected or nearOpposite then
					result[player] = root.Position
				end
			end
		end
	end

	return result
end

local function resetMatchTeleportWatcher()
	Functions.MatchTeleportObservedPlayers = {}
	Functions.MatchTeleportStartHoldUntil = 0
	Functions.MatchTeleportWasInMatch = false
end

local function shouldPauseAutoMatchTeleport()
	local now = os.clock()
	local inMatch = isLocalPlayerInMatch()

	if inMatch then
		Functions.MatchTeleportWasInMatch = true
		return true
	end

	if Functions.MatchTeleportWasInMatch then
		Functions.MatchTeleportWasInMatch = false
		Functions.MatchTeleportStartHoldUntil = now + 0.35
	end

	local current = getPlayersNearQueue(16)
	local previous = Functions.MatchTeleportObservedPlayers or {}
	local hadPlayer = next(previous) ~= nil
	local hasPlayer = next(current) ~= nil

	if hadPlayer and not hasPlayer then
		Functions.MatchTeleportStartHoldUntil = math.max(
			Functions.MatchTeleportStartHoldUntil or 0,
			now + 6
		)
	end

	Functions.MatchTeleportObservedPlayers = current

	return now < (Functions.MatchTeleportStartHoldUntil or 0)
end

function Functions.TeleportSelectedMatch(ignoreMatchCheck)
	local position = getSelectedMatchPosition()

	if not position then
		return false
	end

	if not ignoreMatchCheck and isLocalPlayerInMatch() then
		return false
	end

	local character = lp.Character or lp.CharacterAdded:Wait()
	local root = character:FindFirstChild("HumanoidRootPart")
		or character:WaitForChild("HumanoidRootPart", 5)

	if not root then
		return false
	end

	local targetCFrame = CFrame.new(position)

	for _ = 1, 4 do
		if not character.Parent or not root.Parent then
			return false
		end

		if not ignoreMatchCheck and isLocalPlayerInMatch() then
			return false
		end

		character:PivotTo(targetCFrame)
		root.CFrame = targetCFrame
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		task.wait(0.08)
	end

	return true
end

function Functions.SetAutoMatchTeleport(state)
	Functions.States.AutoMatchTeleport = state
	Functions.AutoMatchTeleportId = (Functions.AutoMatchTeleportId or 0) + 1

	resetMatchTeleportWatcher()

	local id = Functions.AutoMatchTeleportId

	if not state then
		return
	end

	task.spawn(function()
		local lastTeleport = 0

		while Functions.States.AutoMatchTeleport
			and Functions.AutoMatchTeleportId == id
		do
			local now = os.clock()

			if shouldPauseAutoMatchTeleport() then
				task.wait(0.04)
			elseif now - lastTeleport >= 0.85 then
				lastTeleport = now
				Functions.TeleportSelectedMatch(false)
			else
				task.wait(0.04)
			end
		end
	end)
end

local function getOneVsOneOpponent()
	if Functions.SelectedMatchMode ~= "1v1" then
		return nil
	end

	if not isLocalPlayerInMatch() then
		return nil
	end

	local localCharacter = lp.Character
	local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

	if not localRoot then
		return nil
	end

	local bestPlayer
	local bestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp then
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if root and humanoid and humanoid.Health > 0 then
				local distance = (root.Position - localRoot.Position).Magnitude

				if distance < bestDistance then
					bestDistance = distance
					bestPlayer = player
				end
			end
		end
	end

	return bestPlayer
end

function Functions.SetAutoTeleportUser(state)
	Functions.States.AutoTeleportUser = state
	Functions.AutoTeleportUserId = (Functions.AutoTeleportUserId or 0) + 1

	local id = Functions.AutoTeleportUserId

	if not state then
		return
	end

	task.spawn(function()
		while Functions.States.AutoTeleportUser
			and Functions.AutoTeleportUserId == id
		do
			if Functions.SelectedMatchMode == "1v1" and isLocalPlayerInMatch() then
				local opponent = getOneVsOneOpponent()
				local character = lp.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				local opponentCharacter = opponent and opponent.Character
				local opponentRoot = opponentCharacter
					and opponentCharacter:FindFirstChild("HumanoidRootPart")

				if root and opponentRoot then
					local target = opponentRoot.CFrame * CFrame.new(0, 0, 3)

					if Functions.States.AutoTeleportUser
						and Functions.SelectedMatchMode == "1v1"
						and isLocalPlayerInMatch()
					then
						character:PivotTo(target)
						root.AssemblyLinearVelocity = Vector3.zero
						root.AssemblyAngularVelocity = Vector3.zero
					end
				end

				task.wait(10)
			else
				task.wait(10)
			end
		end
	end)
end

local TRIDENT_MESH = "97342506881515"
local TRIDENT_TEXTURE = "74965169667348"

local function assetDigits(value)
	local text = tostring(value or "")
	return text:match("(%d+)$") or text:match("(%d+)")
end

local function isEventTrident(model)
	if not model or not model:IsA("Model") then
		return false
	end

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("MeshPart")
			and assetDigits(obj.MeshId) == TRIDENT_MESH
			and assetDigits(obj.TextureID) == TRIDENT_TEXTURE
		then
			return true
		end
	end

	return false
end

local function bringEventTrident(model)
	if not isLocalPlayerInMatch() then
		return false
	end

	local character = lp.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root or not model or not model.Parent then
		return false
	end

	local targetCFrame = root.CFrame
	local moved = false
	local touch = model:FindFirstChild("Touch", true)

	if touch and touch:IsA("BasePart") then
		pcall(function()
			touch.CFrame = targetCFrame
			touch.AssemblyLinearVelocity = Vector3.zero
			touch.AssemblyAngularVelocity = Vector3.zero
			moved = true
		end)
	end

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("BasePart") then
			pcall(function()
				obj.CFrame = targetCFrame
				obj.AssemblyLinearVelocity = Vector3.zero
				obj.AssemblyAngularVelocity = Vector3.zero
				moved = true
			end)
		end
	end

	return moved
end

function Functions.CollectEventItems()
	if not isLocalPlayerInMatch() then
		return false
	end

	local folder = Workspace:FindFirstChild("SpawnablesClient")

	if not folder then
		return false
	end

	local collected = false

	for _, model in ipairs(folder:GetChildren()) do
		if isEventTrident(model) and bringEventTrident(model) then
			collected = true
		end
	end

	return collected
end

function Functions.SetAutoCollect(state)
	Functions.States.AutoCollect = state
	Functions.AutoCollectId = (Functions.AutoCollectId or 0) + 1

	local id = Functions.AutoCollectId

	if Functions.AutoCollectChildAdded then
		Functions.AutoCollectChildAdded:Disconnect()
		Functions.AutoCollectChildAdded = nil
	end

	if not state then
		return
	end

	local folder = Workspace:FindFirstChild("SpawnablesClient")
	if not folder then
		folder = Workspace:WaitForChild("SpawnablesClient", 10)
	end

	if folder then
		Functions.AutoCollectChildAdded = folder.ChildAdded:Connect(function(model)
			task.spawn(function()
				while Functions.States.AutoCollect
					and Functions.AutoCollectId == id
					and model
					and model.Parent
				do
					if isLocalPlayerInMatch() and isEventTrident(model) then
						if bringEventTrident(model) then
							task.wait(10)
						else
							task.wait(10)
						end
					else
						task.wait(10)
					end
				end
			end)
		end)
	end

	task.spawn(function()
		while Functions.States.AutoCollect and Functions.AutoCollectId == id do
			if isLocalPlayerInMatch() then
				Functions.CollectEventItems()
				task.wait(10)
			else
				task.wait(10)
			end
		end
	end)
end

local function findRemoteFunctionByName(name)
	local packages = ReplicatedStorage:FindFirstChild("Packages")
	local networking = packages and packages:FindFirstChild("Networking")

	if networking then
		local remote = networking:FindFirstChild(name)
		if remote and remote:IsA("RemoteFunction") then
			return remote
		end
	end

	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteFunction") and obj.Name == name then
			return obj
		end
	end

	return nil
end

function Functions.SetEventBuyAmount(value)
	Functions.Values.EventBuyAmount = math.clamp(value or 1, 1, 25)
end

local function remoteCooldown(key, delayTime)
	delayTime = math.max(tonumber(delayTime) or 10, 10)
	Functions.RemoteCooldowns = Functions.RemoteCooldowns or {}

	local now = os.clock()
	local last = Functions.RemoteCooldowns[key]

	if last and now - last < delayTime then
		return false
	end

	Functions.RemoteCooldowns[key] = now
	return true
end

local function safeInvokeRemote(remote, key, delayTime, ...)
	if not remoteCooldown(key, delayTime) then
		return false
	end

	local args = {...}
	local ok, result1, result2 = pcall(function()
		return remote:InvokeServer(table.unpack(args))
	end)

	if not ok then
		return false
	end

	return true, result1, result2
end

local function safeFireRemote(remote, key, delayTime, ...)
	if not remoteCooldown(key, delayTime) then
		return false
	end

	local args = {...}
	local ok = pcall(function()
		remote:FireServer(table.unpack(args))
	end)

	return ok == true
end


function Functions.BuyEventChest(silent, autoMode)
	local now = os.clock()
	local delayValue = autoMode
		and math.clamp(tonumber(Functions.Values.AutoBuyDelay) or 90, 90, 600)
		or math.clamp(tonumber(Functions.Values.ManualEventBuyDelay) or 10, 10, 60)

	if Functions.LastEventBuyAttempt
		and now - Functions.LastEventBuyAttempt < delayValue
	then
		if not silent and Functions.Notify then
			local left = math.ceil(delayValue - (now - Functions.LastEventBuyAttempt))
			Functions.Notify("Axi", "Buy cooldown: " .. tostring(left) .. "s", 2)
		end

		return false
	end

	if Functions.EventBuyBusy then
		return false
	end

	Functions.LastEventBuyAttempt = now
	Functions.EventBuyBusy = true

	local packages = ReplicatedStorage:FindFirstChild("Packages")
	local networking = packages and packages:FindFirstChild("Networking")
	local buyRemote = networking and networking:FindFirstChild("RF/Events/BuyEventItem")

	if not buyRemote or not buyRemote:IsA("RemoteFunction") then
		Functions.EventBuyBusy = false

		if not silent and Functions.Notify then
			Functions.Notify("Axi", "BuyEventItem remote missing", 2)
		end

		return false
	end

	local amount = autoMode and 1 or math.clamp(Functions.Values.EventBuyAmount or 1, 1, 25)
	local successCount = 0

	for _ = 1, amount do
		local cooldownKey = autoMode and "AutoBuyEventChest" or "ManualBuyEventChest"
		local ok, result = safeInvokeRemote(buyRemote, cooldownKey, autoMode and delayValue or math.clamp(tonumber(Functions.Values.ManualEventBuyDelay) or 10, 10, 60), 1)

		if ok and result == true then
			successCount += 1
		end

		if amount > 1 then
			task.wait(math.clamp(tonumber(Functions.Values.ManualEventBuyDelay) or 10, 10, 60))
		end
	end

	Functions.EventBuyBusy = false

	if not silent and Functions.Notify then
		Functions.Notify(
			"Axi",
			"Event chest buys: " .. tostring(successCount) .. "/" .. tostring(amount),
			2
		)
	end

	return successCount > 0
end

function Functions.SetAutoBuyEventChest(state)
	Functions.States.AutoBuyEventChest = state

	if state then
		Functions.LastAutoBuyChestCheck = os.clock()
		Functions.LastEventBuyAttempt = Functions.LastEventBuyAttempt or 0
	end
end

local function findAtlantisCrateInCrateTable(crateTable)
	if type(crateTable) ~= "table" then
		return nil
	end

	for uuid, crate in pairs(crateTable) do
		if type(crate) == "table" and crate.name == "AtlantisCrate" then
			return tostring(uuid)
		end
	end

	return nil
end

local function findAtlantisCrateInDataTable(data)
	if type(data) ~= "table" then
		return nil
	end

	if type(data.Data) == "table" then
		data = data.Data
	end

	local inventory = data.Inventory

	if type(inventory) ~= "table" then
		return nil
	end

	return findAtlantisCrateInCrateTable(inventory.Crate)
end

local function searchPublishedTables(root, maxDepth)
	if type(root) ~= "table" then
		return nil
	end

	local seen = {}

	local function walk(value, depth)
		if type(value) ~= "table" or seen[value] or depth > maxDepth then
			return nil
		end

		seen[value] = true

		local direct = findAtlantisCrateInDataTable(value)
		if direct then
			return direct
		end

		for _, child in pairs(value) do
			if type(child) == "table" then
				local found = walk(child, depth + 1)
				if found then
					return found
				end
			end
		end

		return nil
	end

	return walk(root, 0)
end

local function findAtlantisCrateId()
	if type(Functions.InventoryDataProvider) == "function" then
		local ok, data = pcall(Functions.InventoryDataProvider)

		if ok then
			local uuid = findAtlantisCrateInDataTable(data)
			if uuid then
				return uuid
			end
		end
	end

	local published = {
		rawget(_G, "Data"),
		rawget(_G, "PlayerData"),
		rawget(_G, "InventoryData"),
		rawget(shared, "Data"),
		rawget(shared, "PlayerData"),
		rawget(shared, "InventoryData"),
		_G,
		shared
	}

	for _, data in ipairs(published) do
		local uuid = searchPublishedTables(data, 5)

		if uuid then
			return uuid
		end
	end

	return nil
end

function Functions.OpenAtlantisChest(silent, autoMode)
	local now = os.clock()
	local delayValue = autoMode
		and math.clamp(tonumber(Functions.Values.AutoOpenDelay) or 60, 60, 300)
		or math.clamp(tonumber(Functions.Values.ManualEventOpenDelay) or 10, 10, 60)

	if Functions.LastEventOpenAttempt
		and now - Functions.LastEventOpenAttempt < delayValue
	then
		if not silent and Functions.Notify then
			local left = math.ceil(delayValue - (now - Functions.LastEventOpenAttempt))
			Functions.Notify("Axi", "Open cooldown: " .. tostring(left) .. "s", 2)
		end

		return false
	end

	if Functions.EventOpenBusy then
		return false
	end

	Functions.LastEventOpenAttempt = now
	Functions.EventOpenBusy = true

	local packages = ReplicatedStorage:FindFirstChild("Packages")
	local networking = packages and packages:FindFirstChild("Networking")
	local openRemote = networking and networking:FindFirstChild("RF/Inventory/OpenCrate")

	if not openRemote or not openRemote:IsA("RemoteFunction") then
		Functions.EventOpenBusy = false

		if not silent and Functions.Notify then
			Functions.Notify("Axi", "OpenCrate remote missing", 2)
		end

		return false
	end

	local crateUuid = findAtlantisCrateId()

	if not crateUuid then
		Functions.EventOpenBusy = false

		if not silent and Functions.Notify then
			Functions.Notify("Axi", "No Atlantis crates found", 2)
		end

		return false
	end

	local cooldownKey = autoMode and "AutoOpenAtlantisChest" or "ManualOpenAtlantisChest"
	local ok, result, item = safeInvokeRemote(openRemote, cooldownKey, delayValue, crateUuid)

	local success = ok and result == true
	Functions.EventOpenBusy = false

	if not silent and Functions.Notify then
		Functions.Notify(
			"Axi",
			success and "Atlantis chest opened" or "Atlantis chest open rejected",
			2
		)
	end

	return success, item
end

function Functions.SetAutoOpenChest(state)
	Functions.States.AutoOpenChest = state

	if state then
		Functions.LastAutoOpenChestCheck = os.clock()
		Functions.LastEventOpenAttempt = Functions.LastEventOpenAttempt or 0
	end
end

local function getAdminTools()
	local result = {}
	local character = lp.Character
	local backpack = lp:FindFirstChild("Backpack")

	if character then
		for _, obj in ipairs(character:GetChildren()) do
			if obj:IsA("Tool") then
				result[#result + 1] = obj
			end
		end
	end

	if backpack then
		for _, obj in ipairs(backpack:GetChildren()) do
			if obj:IsA("Tool") then
				result[#result + 1] = obj
			end
		end
	end

	return result
end

local function adminToolHasRemote(tool, name)
	for _, obj in ipairs(tool:GetDescendants()) do
		if obj:IsA("RemoteEvent") and obj.Name:lower() == name:lower() then
			return true
		end
	end

	return false
end

local function scoreAdminKnife(tool)
	local score = 0
	local name = tool.Name:lower()

	if name:find("knife", 1, true) then
		score += 100
	end

	if adminToolHasRemote(tool, "Slash") then score += 50 end
	if adminToolHasRemote(tool, "Throw") then score += 50 end
	if adminToolHasRemote(tool, "FlingKnifeEvent") then score += 50 end
	if adminToolHasRemote(tool, "SlashStart") then score += 30 end

	local animations = tool:FindFirstChild("Animations")
	if animations then
		if animations:FindFirstChild("Throw") then score += 30 end
		if animations:FindFirstChild("Slash") then score += 30 end
	end

	return score
end

local function scoreAdminGun(tool)
	local score = 0
	local name = tool.Name:lower()

	for _, key in ipairs({
		"gun",
		"cannon",
		"revolver",
		"pistol",
		"rifle",
		"blaster",
		"shotgun"
	}) do
		if name:find(key, 1, true) then
			score += 100
		end
	end

	if adminToolHasRemote(tool, "kill") then score += 25 end
	if adminToolHasRemote(tool, "shoot") then score += 60 end
	if adminToolHasRemote(tool, "fire") then score += 60 end

	return score
end

local function detectAdminTool(scoreFunction, excluded)
	local bestTool
	local bestScore = 0

	for _, tool in ipairs(getAdminTools()) do
		if tool ~= excluded then
			local score = scoreFunction(tool)
			if score > bestScore then
				bestScore = score
				bestTool = tool
			end
		end
	end

	return bestTool
end

local function detectAdminKnife()
	return detectAdminTool(scoreAdminKnife)
end

local function detectAdminGun()
	local knife = detectAdminKnife()
	return detectAdminTool(scoreAdminGun, knife)
end

local function getCharacterHumanoid()
	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not character or not humanoid or humanoid.Health <= 0 then
		return nil, nil
	end

	return character, humanoid
end

local function equipAdminTool(tool)
	if not tool then
		return false, nil, nil
	end

	local character, humanoid = getCharacterHumanoid()

	if not character or not humanoid then
		return false, nil, nil
	end

	if tool.Parent ~= character then
		pcall(function()
			humanoid:EquipTool(tool)
		end)

		task.wait(0.22)
	end

	if tool.Parent ~= character then
		return false, character, humanoid
	end

	return true, character, humanoid
end

local function unequipAdminTool(tool, delayTime)
	delayTime = tonumber(delayTime) or 0.22

	task.delay(delayTime, function()
		local character, humanoid = getCharacterHumanoid()

		if not character or not humanoid then
			return
		end

		if tool and tool.Parent == character then
			pcall(function()
				humanoid:UnequipTools()
			end)
		end
	end)
end

local function sendKeyOnce(keyCode)
	if VirtualInputManager then
		local ok = pcall(function()
			VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
			task.wait(0.08)
			VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
		end)

		if ok then
			return true
		end
	end

	return false
end

local function sendMouseClickOnce()
	if VirtualInputManager then
		local location = UserInputService:GetMouseLocation()
		local ok = pcall(function()
			VirtualInputManager:SendMouseButtonEvent(location.X, location.Y, 0, true, game, 0)
			task.wait(0.12)
			VirtualInputManager:SendMouseButtonEvent(location.X, location.Y, 0, false, game, 0)
		end)

		if ok then
			return true
		end
	end

	return false
end

local function useAdminTool(tool, actionType, unequipDelay)
	local equipped = equipAdminTool(tool)

	if not equipped then
		return false
	end

	task.wait(0.25)

	if actionType == "knife" then
		if not sendKeyOnce(Enum.KeyCode.E) then
			pcall(function()
				tool:Activate()
			end)
		end
	elseif actionType == "gun" then
		if not sendMouseClickOnce() then
			pcall(function()
				tool:Activate()
			end)
		end
	else
		pcall(function()
			tool:Activate()
		end)
	end

	unequipAdminTool(tool, unequipDelay or 0.25)
	return true
end

local function parseAdminKey(text)
	text = tostring(text or ""):gsub("%s+", "")
	if text == "" then
		return nil
	end

	return Enum.KeyCode[text]
		or Enum.KeyCode[text:upper()]
		or Enum.KeyCode[text:sub(1, 1):upper() .. text:sub(2)]
end

local CONFIG_FILE_NAME = "axi_config.json"
local CONFIG_FILE_BACKUP = "axi/axi_config.json"
local CONFIG_FOLDER_NAME = "axi"

local function getConfigApi(name)
	if name == "writefile" and type(writefile) == "function" then return writefile end
	if name == "readfile" and type(readfile) == "function" then return readfile end
	if name == "isfile" and type(isfile) == "function" then return isfile end
	if name == "delfile" and type(delfile) == "function" then return delfile end
	if name == "deletefile" and type(deletefile) == "function" then return deletefile end
	if name == "isfolder" and type(isfolder) == "function" then return isfolder end
	if name == "makefolder" and type(makefolder) == "function" then return makefolder end

	local env

	pcall(function()
		if type(getgenv) == "function" then
			env = getgenv()
		end
	end)

	if type(env) == "table" and type(rawget(env, name)) == "function" then
		return rawget(env, name)
	end

	if type(_G) == "table" and type(rawget(_G, name)) == "function" then
		return rawget(_G, name)
	end

	return nil
end

local function ensureConfigFolder()
	local isfolderFn = getConfigApi("isfolder")
	local makefolderFn = getConfigApi("makefolder")

	if not isfolderFn or not makefolderFn then
		return
	end

	local ok, exists = pcall(function()
		return isfolderFn(CONFIG_FOLDER_NAME)
	end)

	if ok and exists then
		return
	end

	pcall(function()
		makefolderFn(CONFIG_FOLDER_NAME)
	end)
end

local function configSupported()
	return getConfigApi("writefile") ~= nil
		and getConfigApi("readfile") ~= nil
		and getConfigApi("isfile") ~= nil
end

local function configDeleteSupported()
	return getConfigApi("delfile") ~= nil
		or getConfigApi("deletefile") ~= nil
		or getConfigApi("writefile") ~= nil
end

local function configPaths()
	return {
		CONFIG_FILE_NAME,
		CONFIG_FILE_BACKUP
	}
end

local function configExistsAt(path)
	local isfileFn = getConfigApi("isfile")

	if not isfileFn then
		return false
	end

	local ok, result = pcall(function()
		return isfileFn(path)
	end)

	return ok and result == true
end

local function configExists()
	for _, path in ipairs(configPaths()) do
		if configExistsAt(path) then
			return true
		end
	end

	return false
end

local function writePath(path, text)
	local writefileFn = getConfigApi("writefile")

	if not writefileFn then
		return false
	end

	if path == CONFIG_FILE_BACKUP then
		ensureConfigFolder()
	end

	local ok = pcall(function()
		writefileFn(path, text)
	end)

	return ok == true
end

local function readPath(path)
	local readfileFn = getConfigApi("readfile")

	if not readfileFn or not configExistsAt(path) then
		return nil
	end

	local ok, result = pcall(function()
		return readfileFn(path)
	end)

	if ok and type(result) == "string" and result ~= "" then
		return result
	end

	return nil
end

local function writeConfigText(text)
	local wrotePrimary = writePath(CONFIG_FILE_NAME, text)
	local wroteBackup = writePath(CONFIG_FILE_BACKUP, text)

	if not wrotePrimary and not wroteBackup then
		return false
	end

	for _, path in ipairs(configPaths()) do
		local saved = readPath(path)

		if saved == text then
			return true
		end
	end

	return false
end

local function readConfigText()
	for _, path in ipairs(configPaths()) do
		local text = readPath(path)

		if text then
			return text
		end
	end

	return nil
end

local function deletePath(path)
	local delfileFn = getConfigApi("delfile") or getConfigApi("deletefile")

	if delfileFn and configExistsAt(path) then
		local ok = pcall(function()
			delfileFn(path)
		end)

		return ok == true
	end

	if getConfigApi("writefile") and configExistsAt(path) then
		return writePath(path, "")
	end

	return true
end

local function deleteConfigFile()
	local okOne = deletePath(CONFIG_FILE_NAME)
	local okTwo = deletePath(CONFIG_FILE_BACKUP)
	return okOne and okTwo
end

local function serializeKeybind(value)
	if typeof(value) == "EnumItem" then
		return tostring(value)
	end

	return tostring(value or "")
end

local function parseSerializedKeybind(value)
	local text = tostring(value or "")

	if text:find("Enum.UserInputType.MouseButton1", 1, true) then
		return Enum.UserInputType.MouseButton1
	end

	local key = text:match("Enum%.KeyCode%.(.+)$")

	if key and Enum.KeyCode[key] then
		return Enum.KeyCode[key]
	end

	return nil
end

local function getConfigData()
	return {
		MenuKeybind = serializeKeybind(Functions.MenuKeybind),
		GunKeybind = serializeKeybind(Functions.GunKeybind),
		KnifeKeybind = serializeKeybind(Functions.KnifeKeybind),
		States = {
			Notifications = Functions.States.Notifications,
			AntiAFK = Functions.States.AntiAFK,
			AutoLoadConfig = Functions.States.AutoLoadConfig,
			AutoSaveConfig = Functions.States.AutoSaveConfig,
			AutoCloseStats = Functions.States.AutoCloseStats,
			GunEnabled = Functions.States.GunEnabled,
			KnifeEnabled = Functions.States.KnifeEnabled,
			AutoMatchTeleport = Functions.States.AutoMatchTeleport,
			AutoTeleportUser = Functions.States.AutoTeleportUser,
			AutoKnife = Functions.States.AutoKnife,
			AutoSwing = Functions.States.AutoSwing,
			AutoCollect = Functions.States.AutoCollect,
			AutoOpenChest = Functions.States.AutoOpenChest,
			AutoBuyEventChest = Functions.States.AutoBuyEventChest
		},
		Values = {
			GunDelay = Functions.Values.GunDelay,
			KnifeDelay = Functions.Values.KnifeDelay,
			OKCooldown = Functions.Values.OKCooldown,
			OKFOV = Functions.Values.OKFOV,
			OKRange = Functions.Values.OKRange,
			EventBuyAmount = Functions.Values.EventBuyAmount,
			AutoOpenDelay = Functions.Values.AutoOpenDelay,
			AutoBuyDelay = Functions.Values.AutoBuyDelay,
			AutoSaveDelay = Functions.Values.AutoSaveDelay
		},
		Match = {
			Mode = Functions.SelectedMatchMode,
			Arena = Functions.SelectedMatchArena,
			Side = Functions.SelectedMatchSide
		},
		UIConfig = Functions.UIConfig or {}
	}
end

function Functions.SetAutoLoadConfig(state)
	Functions.States.AutoLoadConfig = state == true

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetAutoSaveConfig(state)
	Functions.States.AutoSaveConfig = state == true
	Functions.AutoSaveConfigId = (Functions.AutoSaveConfigId or 0) + 1

	local id = Functions.AutoSaveConfigId

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end

	if not Functions.States.AutoSaveConfig then
		return
	end

	task.spawn(function()
		Functions.SaveConfig(true, true)
		local lastSave = os.clock()

		while Functions.States.AutoSaveConfig
			and Functions.AutoSaveConfigId == id
		do
			local delayValue = math.clamp(tonumber(Functions.Values.AutoSaveDelay) or 60, 30, 600)
			local now = os.clock()

			if now - lastSave >= delayValue then
				lastSave = now
				Functions.SaveConfig(true, true)
			end

			task.wait(1)
		end
	end)
end

function Functions.SaveConfig(silent, force)
	local now = os.clock()

	if silent
		and not force
		and Functions.LastSilentConfigSave
		and now - Functions.LastSilentConfigSave < 5
	then
		return false
	end

	if silent and not force then
		Functions.LastSilentConfigSave = now
	end

	if not configSupported() then
		if not silent and Functions.Notify then
			Functions.Notify("Axi", "Config file API not supported", 3)
		end

		return false
	end

	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(getConfigData())
	end)

	if not ok or type(encoded) ~= "string" then
		if not silent and Functions.Notify then
			Functions.Notify("Axi", "Config encode failed", 3)
		end

		return false
	end

	local saved = writeConfigText(encoded)

	if not silent and Functions.Notify then
		Functions.Notify("Axi", saved and "Config saved and verified" or "Config save failed readback", 3)
	end

	return saved
end

function Functions.QueueConfigSave()
	if Functions.ConfigLoading then
		return
	end

	Functions.ConfigSaveQueueId = (Functions.ConfigSaveQueueId or 0) + 1

	local id = Functions.ConfigSaveQueueId

	task.delay(0.35, function()
		if Functions.ConfigSaveQueueId ~= id then
			return
		end

		Functions.SaveConfig(true, true)
	end)
end

function Functions.ApplyConfigToUI(data)
	if type(data) ~= "table" then
		return
	end

	local controls = Functions.OptionControls or {}

	if not next(controls) then
		Functions.PendingConfigData = data
		return
	end

	local function setControl(callback, value)
		local control = controls[callback]

		if control and control.Set then
			pcall(function()
				control.Set(value, true)
			end)
		end
	end

	local function safeApplyUiCallback(callback, value)
		if type(callback) == "string"
			and callback:sub(1, 10) ~= "Selection:"
			and callback ~= "GuiTheme"
			and type(Functions[callback]) == "function"
		then
			pcall(function()
				Functions[callback](value)
			end)
		end
	end

	if type(data.States) == "table" then
		setControl("SetNotifications", data.States.Notifications)
		setControl("SetAntiAFK", data.States.AntiAFK)
		setControl("SetAutoLoadConfig", data.States.AutoLoadConfig)
		setControl("SetAutoSaveConfig", data.States.AutoSaveConfig)
		setControl("SetAutoCloseStats", data.States.AutoCloseStats)
		setControl("SetGunEnabled", data.States.GunEnabled)
		setControl("SetKnifeEnabled", data.States.KnifeEnabled)
		setControl("SetAutoMatchTeleport", data.States.AutoMatchTeleport)
		setControl("SetAutoTeleportUser", data.States.AutoTeleportUser)
		setControl("SetAutoKnife", data.States.AutoKnife)
		setControl("SetAutoSwing", data.States.AutoSwing)
		setControl("SetAutoOpenChest", data.States.AutoOpenChest)
		setControl("SetAutoBuyEventChest", data.States.AutoBuyEventChest)
		setControl("SetAutoCollect", data.States.AutoCollect)
	end

	if type(data.Values) == "table" then
		setControl("SetGunDelay", data.Values.GunDelay)
		setControl("SetKnifeDelay", data.Values.KnifeDelay)
		setControl("SetOKDelay", data.Values.OKCooldown)
		setControl("SetAutoOpenDelay", data.Values.AutoOpenDelay)
		setControl("SetAutoBuyDelay", data.Values.AutoBuyDelay)
		setControl("SetAutoSaveDelay", data.Values.AutoSaveDelay)

	end

	if type(data.UIConfig) == "table" then
		for key, value in pairs(data.UIConfig) do
			local control = controls[key]

			if control and control.Set then
				pcall(function()
					control.Set(value, true)
				end)
				safeApplyUiCallback(key, value)
			elseif type(key) == "string" and key:sub(1, 10) == "Selection:" then
				local groupName = key:sub(11)
				local group = Functions.SelectionButtons and Functions.SelectionButtons[groupName]

				if group then
					for groupValue, info in pairs(group) do
						if info.Accent and info.Accent.Parent then
							info.Accent.BackgroundTransparency = tostring(groupValue) == tostring(value) and 0 or 1
						end
					end
				end

				Functions.SelectedButtons = Functions.SelectedButtons or {}
				Functions.SelectedButtons[groupName] = value
			end
		end
	end

	if type(data.Match) == "table" and Functions.SelectionButtons then
		local groups = {
			MatchMode = data.Match.Mode,
			MatchArena = data.Match.Arena and tostring(data.Match.Arena),
			MatchSide = data.Match.Side
		}

		for groupName, selectedValue in pairs(groups) do
			local group = Functions.SelectionButtons[groupName]

			if group then
				for value, info in pairs(group) do
					if info.Accent and info.Accent.Parent then
						info.Accent.BackgroundTransparency = tostring(value) == tostring(selectedValue) and 0 or 1
					end
				end
			end

			Functions.SelectedButtons = Functions.SelectedButtons or {}
			Functions.SelectedButtons[groupName] = selectedValue
		end
	end
end

function Functions.LoadConfig(silent)
	if not configSupported() or not configExists() then
		if not silent and Functions.Notify then
			Functions.Notify("Axi", "No config found", 3)
		end

		return false
	end

	local configText = readConfigText()

	if type(configText) ~= "string" or configText == "" then
		if not silent and Functions.Notify then
			Functions.Notify("Axi", "No config found", 3)
		end

		return false
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(configText)
	end)

	if not ok or type(data) ~= "table" then
		if not silent and Functions.Notify then
			Functions.Notify("Axi", "Config load failed decode", 3)
		end

		return false
	end

	Functions.ConfigLoading = true

	if type(data.UIConfig) == "table" then
		Functions.UIConfig = data.UIConfig
	end

	local function safeCall(callback, value)
		if type(Functions[callback]) == "function" then
			pcall(function()
				Functions[callback](value)
			end)
		end
	end

	if type(data.UIConfig) == "table" then
		for key, value in pairs(data.UIConfig) do
			if type(key) == "string"
				and key:sub(1, 10) ~= "Selection:"
				and key ~= "GuiTheme"
			then
				safeCall(key, value)
			end
		end
	end

	local menu = parseSerializedKeybind(data.MenuKeybind)
	local gun = parseSerializedKeybind(data.GunKeybind)
	local knife = parseSerializedKeybind(data.KnifeKeybind)

	if menu then Functions.MenuKeybind = menu end
	if gun then Functions.GunKeybind = gun end
	if knife then Functions.KnifeKeybind = knife end

	if type(data.Values) == "table" then
		if tonumber(data.Values.GunDelay) then
			Functions.Values.GunDelay = math.clamp(tonumber(data.Values.GunDelay), 10, 60)
		end

		if tonumber(data.Values.KnifeDelay) then
			Functions.Values.KnifeDelay = math.clamp(tonumber(data.Values.KnifeDelay), 10, 60)
		end

		if tonumber(data.Values.OKCooldown) then
			Functions.Values.OKCooldown = math.clamp(tonumber(data.Values.OKCooldown), 0.08, 5)
		end

		if tonumber(data.Values.OKFOV) then
			Functions.Values.OKFOV = math.clamp(tonumber(data.Values.OKFOV), 25, 800)
		end

		if tonumber(data.Values.OKRange) then
			Functions.Values.OKRange = math.clamp(tonumber(data.Values.OKRange), 50, 5000)
		end

		if tonumber(data.Values.EventBuyAmount) then
			Functions.Values.EventBuyAmount = math.clamp(math.floor(tonumber(data.Values.EventBuyAmount)), 1, 25)
		end

		if tonumber(data.Values.AutoOpenDelay) then
			Functions.Values.AutoOpenDelay = math.clamp(tonumber(data.Values.AutoOpenDelay), 60, 300)
		end

		if tonumber(data.Values.AutoBuyDelay) then
			Functions.Values.AutoBuyDelay = math.clamp(tonumber(data.Values.AutoBuyDelay), 90, 600)
		end

		if tonumber(data.Values.AutoSaveDelay) then
			Functions.Values.AutoSaveDelay = math.clamp(tonumber(data.Values.AutoSaveDelay), 30, 600)
		end

	end

	if type(data.Match) == "table" then
		if Functions.MatchLocations[data.Match.Mode] then
			Functions.SelectedMatchMode = data.Match.Mode
		end

		if data.Match.Arena == 1 or data.Match.Arena == 2 then
			Functions.SelectedMatchArena = data.Match.Arena
		end

		if data.Match.Side == "Left" or data.Match.Side == "Right" then
			Functions.SelectedMatchSide = data.Match.Side
		end
	end

	if type(data.States) == "table" then
		if type(data.States.Notifications) == "boolean" then
			Functions.States.Notifications = data.States.Notifications
		end

		if type(data.States.AutoLoadConfig) == "boolean" then
			safeCall("SetAutoLoadConfig", data.States.AutoLoadConfig)
		end

		if type(data.States.AutoSaveConfig) == "boolean" then
			safeCall("SetAutoSaveConfig", data.States.AutoSaveConfig)
		end

		if type(data.States.AntiAFK) == "boolean" then
			safeCall("SetAntiAFK", data.States.AntiAFK)
		end

		if type(data.States.AutoCloseStats) == "boolean" then
			safeCall("SetAutoCloseStats", data.States.AutoCloseStats)
		end

		if type(data.States.GunEnabled) == "boolean" then
			safeCall("SetGunEnabled", data.States.GunEnabled)
		end

		if type(data.States.KnifeEnabled) == "boolean" then
			safeCall("SetKnifeEnabled", data.States.KnifeEnabled)
		end

		if type(data.States.AutoMatchTeleport) == "boolean" then
			safeCall("SetAutoMatchTeleport", data.States.AutoMatchTeleport)
		end

		if type(data.States.AutoTeleportUser) == "boolean" then
			safeCall("SetAutoTeleportUser", data.States.AutoTeleportUser)
		end

		if type(data.States.AutoKnife) == "boolean" then
			safeCall("SetAutoKnife", data.States.AutoKnife)
		end

		if type(data.States.AutoSwing) == "boolean" then
			safeCall("SetAutoSwing", data.States.AutoSwing)
		end

		if type(data.States.AutoCollect) == "boolean" then
			safeCall("SetAutoCollect", data.States.AutoCollect)
		end

		if type(data.States.AutoOpenChest) == "boolean" then
			safeCall("SetAutoOpenChest", data.States.AutoOpenChest)
		end

		if type(data.States.AutoBuyEventChest) == "boolean" then
			safeCall("SetAutoBuyEventChest", data.States.AutoBuyEventChest)
		end
	end

	Functions.LastLoadedConfigData = data

	if Functions.ApplyConfigToUI then
		Functions.ApplyConfigToUI(data)
	end


	Functions.ConfigLoading = false

	if not silent and Functions.Notify then
		Functions.Notify("Axi", "Config loaded and applied", 3)
	end

	return true
end

function Functions.DeleteConfig()
	if not configDeleteSupported() then
		if Functions.Notify then
			Functions.Notify("Axi", "Config delete not supported", 3)
		end

		return false
	end

	Functions.SetAutoLoadConfig(false)
	Functions.SetAutoSaveConfig(false)

	local deleted = deleteConfigFile()

	if Functions.Notify then
		Functions.Notify("Axi", deleted and "Config deleted" or "Config delete failed", 3)
	end

	return deleted
end

function Functions.ConfigStatus()
	local supported = configSupported()
	local exists = configExists()
	local canRead = readConfigText() ~= nil

	if Functions.Notify then
		Functions.Notify(
			"Axi",
			"axi_config.json | API: " .. tostring(supported) .. " | Saved: " .. tostring(exists) .. " | Read: " .. tostring(canRead) .. " | UI: " .. tostring(Functions.OptionControls ~= nil),
			5
		)
	end

	return supported and exists and canRead
end

local function shouldAutoLoadConfig()
	return configSupported() and configExists()
end

function Functions.AutoLoadConfigOnStart()
	if Functions.AutoLoadConfigStarted then
		return false
	end

	Functions.AutoLoadConfigStarted = true

	task.defer(function()
		task.wait(3.6)

		if not shouldAutoLoadConfig() then
			return
		end

		Functions.LoadConfig(true)

		if Functions.GuiObjects and Functions.GuiObjects.Minimized and Functions.GuiObjects.Main and Functions.GuiObjects.Main.Visible then
			Functions.GuiObjects.Minimized.Visible = false
		end
	end)

	return true
end

local function parseDelayText(text, fallback, minimum, maximum)
	local value = tonumber(tostring(text or ""):gsub(",", "."))

	if not value then
		return fallback
	end

	return math.clamp(value, minimum, maximum)
end

function Functions.SetAutoSaveDelay(text)
	Functions.Values.AutoSaveDelay = parseDelayText(text, Functions.Values.AutoSaveDelay or 60, 30, 600)

	if Functions.Notify then
		Functions.Notify("Axi", "Auto save delay set to " .. tostring(Functions.Values.AutoSaveDelay), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetGunDelay(text)
	Functions.Values.GunDelay = parseDelayText(text, Functions.Values.GunDelay or 10, 10, 60)

	if Functions.Notify then
		Functions.Notify("Axi", "Gun delay set to " .. tostring(Functions.Values.GunDelay), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetKnifeDelay(text)
	Functions.Values.KnifeDelay = parseDelayText(text, Functions.Values.KnifeDelay or 10, 10, 60)

	if Functions.Notify then
		Functions.Notify("Axi", "Knife delay set to " .. tostring(Functions.Values.KnifeDelay), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetOKDelay(text)
	Functions.Values.OKCooldown = parseDelayText(text, Functions.Values.OKCooldown or 0.25, 0.08, 5)

	if Functions.Notify then
		Functions.Notify("Axi", "OK delay set to " .. tostring(Functions.Values.OKCooldown), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetAutoOpenDelay(text)
	Functions.Values.AutoOpenDelay = parseDelayText(text, Functions.Values.AutoOpenDelay or 60, 60, 300)

	if Functions.Notify then
		Functions.Notify("Axi", "Auto open delay set to " .. tostring(Functions.Values.AutoOpenDelay), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetAutoBuyDelay(text)
	Functions.Values.AutoBuyDelay = parseDelayText(text, Functions.Values.AutoBuyDelay or 90, 90, 600)

	if Functions.Notify then
		Functions.Notify("Axi", "Auto buy delay set to " .. tostring(Functions.Values.AutoBuyDelay), 1.5)
	end

	if not Functions.ConfigLoading then
		task.defer(function()
			Functions.SaveConfig(true, true)
		end)
	end
end

function Functions.SetGunKeybind(text)
	text = tostring(text or ""):gsub("%s+", "")

	if text:lower() == "mousebutton1"
		or text:lower() == "m1"
		or text:lower() == "leftclick"
	then
		Functions.GunKeybind = Enum.UserInputType.MouseButton1
		return
	end

	local key = parseAdminKey(text)
	if key then
		Functions.GunKeybind = key
	end
end

function Functions.SetKnifeKeybind(text)
	local key = parseAdminKey(text)
	if key then
		Functions.KnifeKeybind = key
	end
end

function Functions.SetGunEnabled(state)
	Functions.States.GunEnabled = state
end

function Functions.SetKnifeEnabled(state)
	Functions.States.KnifeEnabled = state
end

function Functions.UseDetectedGun()
	if not Functions.CanUseMatchWeapon() then
		return false
	end

	local now = os.clock()
	local delayValue = math.clamp(tonumber(Functions.Values.GunDelay) or 10, 10, 60)

	if Functions.LastManualGunUse
		and now - Functions.LastManualGunUse < delayValue
	then
		return false
	end

	local gun = detectAdminGun()

	if not gun then
		return false
	end

	Functions.LastManualGunUse = now
	return useAdminTool(gun, "gun", 0.45)
end

function Functions.UseDetectedKnife()
	if not Functions.CanUseMatchWeapon() then
		return false
	end

	local now = os.clock()
	local delayValue = math.clamp(tonumber(Functions.Values.KnifeDelay) or 10, 10, 60)

	if Functions.LastManualKnifeUse
		and now - Functions.LastManualKnifeUse < delayValue
	then
		return false
	end

	local knife = detectAdminKnife()

	if not knife then
		return false
	end

	Functions.LastManualKnifeUse = now
	return useAdminTool(knife, "knife", 0.45)
end

local function findKnifeForAutoEquip()
	local knife = detectAdminKnife()

	if knife and knife:IsA("Tool") then
		return knife
	end

	local containers = {
		lp.Character,
		lp:FindFirstChild("Backpack")
	}

	for _, container in ipairs(containers) do
		if container then
			for _, obj in ipairs(container:GetChildren()) do
				if obj:IsA("Tool") then
					local name = obj.Name:lower()

					if name:find("knife", 1, true)
						or name:find("blade", 1, true)
						or name:find("dagger", 1, true)
					then
						return obj
					end

					for _, descendant in ipairs(obj:GetDescendants()) do
						if descendant:IsA("RemoteEvent")
							or descendant:IsA("RemoteFunction")
						then
							local remoteName = descendant.Name:lower()

							if remoteName:find("slash", 1, true)
								or remoteName:find("throw", 1, true)
								or remoteName:find("knife", 1, true)
								or remoteName:find("fling", 1, true)
							then
								return obj
							end
						end
					end
				end
			end
		end
	end

	return nil
end

local function equipKnifeForAuto()
	local character = lp.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not character or not humanoid or humanoid.Health <= 0 then
		return false, nil
	end

	local knife = findKnifeForAutoEquip()

	if not knife or not knife:IsA("Tool") then
		return false, nil
	end

	if knife.Parent == character then
		return true, knife
	end

	local backpack = lp:FindFirstChild("Backpack")

	if knife.Parent ~= backpack then
		return false, knife
	end

	local ok = pcall(function()
		humanoid:EquipTool(knife)
	end)

	if not ok then
		return false, knife
	end

	for _ = 1, 5 do
		if knife.Parent == character then
			return true, knife
		end

		task.wait(0.04)
	end

	return false, knife
end

function Functions.SetAutoKnife(state)
	Functions.States.AutoKnife = state
	Functions.AutoKnifeId = (Functions.AutoKnifeId or 0) + 1

	local id = Functions.AutoKnifeId

	if not state then
		return
	end

	task.spawn(function()
		while Functions.States.AutoKnife
			and Functions.AutoKnifeId == id
		do
			if Functions.SelectedMatchMode == "1v1" then
				equipKnifeForAuto()
				task.wait(0.1)
			else
				task.wait(10)
			end
		end
	end)
end

function Functions.SetAutoSwing(state)
	Functions.States.AutoSwing = state
	Functions.AutoSwingId = (Functions.AutoSwingId or 0) + 1

	local id = Functions.AutoSwingId

	if not state then
		return
	end

	task.spawn(function()
		local lastGunUse = 0

		while Functions.States.AutoSwing
			and Functions.AutoSwingId == id
		do
			if Functions.SelectedMatchMode == "1v1"
				and isLocalPlayerInMatch()
				and Functions.AttackInputHeld
			then
				local equipped, knife = equipKnifeForAuto()

				if equipped and knife then
					pcall(function()
						knife:Activate()
					end)

					task.wait(math.clamp(tonumber(Functions.Values.KnifeDelay) or 10, 10, 60))
				else
					local now = os.clock()

					if now - lastGunUse >= math.clamp(tonumber(Functions.Values.GunDelay) or 10, 10, 60) then
						local gun = detectAdminGun()

						if gun then
							lastGunUse = now
							pcall(function()
								useAdminTool(gun, "gun", 0.45)
							end)
						end
					end

					task.wait(10)
				end
			else
				task.wait(0.08)
			end
		end
	end)
end

local function getMatchStatsGui()
	local mainGui = pg:FindFirstChild("Main")
	local mainGameFrame = mainGui and mainGui:FindFirstChild("MainGameFrame")
	local gameStats = mainGameFrame and mainGameFrame:FindFirstChild("GameStats")

	if gameStats and gameStats:IsA("GuiObject") then
		return gameStats
	end

	return nil
end

Functions.MatchStatsConnections = Functions.MatchStatsConnections or {}

local function disconnectMatchStatsConnections()
	for _, connection in pairs(Functions.MatchStatsConnections) do
		if connection then
			connection:Disconnect()
		end
	end

	Functions.MatchStatsConnections = {}
end

function Functions.CloseMatchStats()
	local now = os.clock()

	if Functions.LastMatchStatsRemove
		and now - Functions.LastMatchStatsRemove < 10
	then
		local gameStats = getMatchStatsGui()

		if gameStats then
			gameStats.Visible = false
		end

		return false
	end

	local gameStats = getMatchStatsGui()

	if not gameStats or gameStats.Visible == false then
		return false
	end

	local packages = ReplicatedStorage:FindFirstChild("Packages")
	local networking = packages and packages:FindFirstChild("Networking")
	local stateRemote = networking and networking:FindFirstChild("RE/Match/SetStatePlr")

	if not stateRemote or not stateRemote:IsA("RemoteEvent") then
		if Functions.Notify then
			Functions.Notify("Axi", "Match cleanup remote missing", 2)
		end

		return false
	end

	if not remoteCooldown("MatchStatsRemove", 10) then
		gameStats.Visible = false
		return false
	end

	Functions.LastMatchStatsRemove = now

	local ok = pcall(function()
		stateRemote:FireServer("REMOVE")
	end)

	if not ok then
		if Functions.Notify then
			Functions.Notify("Axi", "Match cleanup failed", 2)
		end

		return false
	end

	gameStats.Visible = false
	return true
end

local function bindMatchStatsAutoClose()
	disconnectMatchStatsConnections()

	local function handleStatsShown()
		local gameStats = getMatchStatsGui()

		if not gameStats or gameStats.Visible == false then
			return
		end

		if Functions.States.AutoMatchTeleport then
			local now = os.clock()

			if not Functions.LastStatsTeleport
				or now - Functions.LastStatsTeleport >= 10
			then
				Functions.LastStatsTeleport = now

				task.delay(2, function()
					if Functions.States.AutoMatchTeleport then
						Functions.TeleportSelectedMatch()
					end
				end)
			end
		end

		if Functions.States.AutoCloseStats then
			local now = os.clock()

			if not Functions.LastAutoCloseStats
				or now - Functions.LastAutoCloseStats >= 10
			then
				Functions.LastAutoCloseStats = now
				task.delay(2, Functions.CloseMatchStats)
			end
		end
	end

	local function bindOne(gameStats)
		if not gameStats or not gameStats:IsA("GuiObject") then
			return
		end

		Functions.MatchStatsConnections.Visible =
			gameStats:GetPropertyChangedSignal("Visible"):Connect(function()
				if gameStats.Visible then
					handleStatsShown()
				end
			end)

		if gameStats.Visible then
			handleStatsShown()
		end
	end

	local gameStats = getMatchStatsGui()

	if gameStats then
		bindOne(gameStats)
	end

	Functions.MatchStatsConnections.GuiAdded = pg.DescendantAdded:Connect(function(obj)
		if obj.Name == "GameStats" and obj:IsA("GuiObject") then
			task.delay(0.35, function()
				bindMatchStatsAutoClose()
			end)
		end
	end)
end

function Functions.SetAntiAFK(state)
	Functions.States.AntiAFK = state

	if Functions.AntiAFKConnection then
		Functions.AntiAFKConnection:Disconnect()
		Functions.AntiAFKConnection = nil
	end

	if not state then
		return
	end

	Functions.AntiAFKConnection = lp.Idled:Connect(function()
		if not Functions.States.AntiAFK then
			return
		end

		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(0, 0))
		end)
	end)
end

function Functions.SetAutoCloseStats(state)
	Functions.States.AutoCloseStats = state
	bindMatchStatsAutoClose()

	if state then
		local gameStats = getMatchStatsGui()

		if gameStats and gameStats.Visible == true then
			Functions.CloseMatchStats()
		end
	end
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

	if Functions.OKRender then
		Functions.OKRender:Disconnect()
		Functions.OKRender = nil
	end

	if not state then
		return
	end

	local lastShot = 0

	local function shoot()
		if not Functions.States.OK or Functions.OKId ~= id then
			return
		end

		if not Functions.CanUseMatchWeapon() then
			return
		end

		if not isShiftlocked() then
			return
		end

		local target = getTargetInView(
			Functions.Values.OKFOV or 160,
			Functions.Values.OKRange or 1200,
			Functions.Values.OKTargetPart or "Head"
		)

		if not target then
			return
		end

		local now = os.clock()
		local okDelay = math.clamp(tonumber(Functions.Values.OKCooldown) or 0.25, 0.08, 5)
		local gunDelay = math.clamp(tonumber(Functions.Values.GunDelay) or 10, 10, 60)
		local cooldown = math.max(okDelay, gunDelay)

		if now - lastShot < cooldown then
			return
		end

		local gun = detectAdminGun()

		if not gun then
			return
		end

		local character = lp.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if not character or not humanoid or humanoid.Health <= 0 then
			return
		end

		if gun.Parent ~= character then
			pcall(function()
				humanoid:EquipTool(gun)
			end)

			task.wait(0.08)
		end

		if gun.Parent ~= character then
			return
		end

		lastShot = now

		pcall(function()
			gun:Activate()
		end)
	end

	Functions.OKRender = RunService.Heartbeat:Connect(function()
		if not Functions.States.OK or Functions.OKId ~= id then
			if Functions.OKRender then
				Functions.OKRender:Disconnect()
				Functions.OKRender = nil
			end

			return
		end

		shoot()
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
			task.wait(0.08)
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
				task.wait(10)
				applyPlayer(player)
			end)
		end
	end
	Functions.TeamHighlightConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		Functions.TeamHighlightConnections[player] = player.CharacterAdded:Connect(function()
			task.wait(10)
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
			task.wait(10)
			refresh()
		end
	end)
end

Functions.GunTrespasserParts = Functions.GunTrespasserParts or {}

function Functions.IsCharacterPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and part:IsDescendantOf(character) then
			return true
		end
	end

	return false
end

function Functions.IsGunTrespasserPart(part)
	if not part or not part:IsA("BasePart") then return false end
	if lp.Character and part:IsDescendantOf(lp.Character) then return false end
	if Functions.IsCharacterPart(part) then return false end
	if Workspace.CurrentCamera and part:IsDescendantOf(Workspace.CurrentCamera) then return false end
	if part.Name == "AxiHitbox" or part.Name == "AxiHitboxVisual" then return false end

	local name = tostring(part.Name):lower()
	local parentName = part.Parent and tostring(part.Parent.Name):lower() or ""

	if name:find("hitbox", 1, true) or parentName:find("hitbox", 1, true) then
		return false
	end

	if name:find("spawn", 1, true) or parentName:find("spawn", 1, true) then
		return false
	end

	if name:find("baseplate", 1, true) or parentName:find("baseplate", 1, true) then
		return false
	end

	return part:IsDescendantOf(Workspace)
end

function Functions.ApplyGunTrespasserPart(part)
	if not Functions.IsGunTrespasserPart(part) then return end

	if not Functions.GunTrespasserParts[part] then
		Functions.GunTrespasserParts[part] = part.CanQuery
	end

	pcall(function()
		part.CanQuery = false
	end)
end

function Functions.RestoreGunTrespasser()
	if Functions.GunTrespasserAddedConnection then
		Functions.GunTrespasserAddedConnection:Disconnect()
		Functions.GunTrespasserAddedConnection = nil
	end

	for part, oldCanQuery in pairs(Functions.GunTrespasserParts) do
		if part and part.Parent then
			pcall(function()
				part.CanQuery = oldCanQuery
			end)
		end
	end

	Functions.GunTrespasserParts = {}
end

function Functions.RefreshGunTrespasser()
	if not Functions.States.GunTrespasser then
		Functions.RestoreGunTrespasser()
		return
	end

	local scanned = 0

	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and Functions.IsGunTrespasserPart(obj) then
			Functions.ApplyGunTrespasserPart(obj)
			scanned += 1

			if scanned % 350 == 0 then
				task.wait()
			end
		end
	end
end

function Functions.SetGunTrespasser(state)
	Functions.States.GunTrespasser = state

	if not state then
		Functions.RestoreGunTrespasser()
		return
	end

	task.spawn(function()
		Functions.RefreshGunTrespasser()
	end)

	if Functions.GunTrespasserAddedConnection then
		Functions.GunTrespasserAddedConnection:Disconnect()
		Functions.GunTrespasserAddedConnection = nil
	end

	Functions.GunTrespasserAddedConnection = Workspace.DescendantAdded:Connect(function(obj)
		if not Functions.States.GunTrespasser then return end
		if obj:IsA("BasePart") then
			task.defer(function()
				if Functions.States.GunTrespasser then
					Functions.ApplyGunTrespasserPart(obj)
				end
			end)
		end
	end)
end

Functions.XrayParts = Functions.XrayParts or {}

function Functions.IsCharacterPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and part:IsDescendantOf(character) then
			return true
		end
	end

	return false
end

function Functions.IsXrayPart(part)
	if not part or not part:IsA("BasePart") then return false end
	if lp.Character and part:IsDescendantOf(lp.Character) then return false end
	if Functions.IsCharacterPart(part) then return false end
	if Workspace.CurrentCamera and part:IsDescendantOf(Workspace.CurrentCamera) then return false end
	if part.Name == "AxiHitbox" or part.Name == "AxiHitboxVisual" then return false end

	local n = tostring(part.Name):lower()
	local p = part.Parent and tostring(part.Parent.Name):lower() or ""

	if n:find("hitbox", 1, true) or p:find("hitbox", 1, true) then return false end
	if n:find("spawn", 1, true) or p:find("spawn", 1, true) then return false end

	if part.Transparency >= 1 then return false end
	if part.Size.Magnitude < 1 then return false end

	return part:IsDescendantOf(Workspace)
end

function Functions.ApplyXrayPart(part)
	if not Functions.IsXrayPart(part) then return end

	if not Functions.XrayParts[part] then
		Functions.XrayParts[part] = part.LocalTransparencyModifier
	end

	pcall(function()
		part.LocalTransparencyModifier = math.clamp((Functions.Values.XrayPower or 55) / 100, 0.1, 0.9)
	end)
end

function Functions.RestoreXray()
	if Functions.XrayAddedConnection then
		Functions.XrayAddedConnection:Disconnect()
		Functions.XrayAddedConnection = nil
	end

	for part, oldModifier in pairs(Functions.XrayParts) do
		if part and part.Parent then
			pcall(function()
				part.LocalTransparencyModifier = oldModifier
			end)
		end
	end

	Functions.XrayParts = {}
end

function Functions.RefreshXray()
	if not Functions.States.Xray then
		Functions.RestoreXray()
		return
	end

	local count = 0

	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and Functions.IsXrayPart(obj) then
			Functions.ApplyXrayPart(obj)
			count += 1
			if count % 250 == 0 then
				task.wait()
			end
		end
	end
end

function Functions.SetXray(state)
	Functions.States.Xray = state

	if not state then
		Functions.RestoreXray()
		return
	end

	task.spawn(function()
		Functions.RefreshXray()
	end)

	if Functions.XrayAddedConnection then
		Functions.XrayAddedConnection:Disconnect()
	end

	Functions.XrayAddedConnection = Workspace.DescendantAdded:Connect(function(obj)
		if not Functions.States.Xray then return end
		if obj:IsA("BasePart") then
			task.defer(function()
				if Functions.States.Xray then
					Functions.ApplyXrayPart(obj)
				end
			end)
		end
	end)
end

function Functions.SetXrayPower(value)
	Functions.Values.XrayPower = math.clamp(value or 55, 10, 90)

	if Functions.States.Xray then
		for part in pairs(Functions.XrayParts) do
			if part and part.Parent then
				pcall(function()
					part.LocalTransparencyModifier = math.clamp((Functions.Values.XrayPower or 55) / 100, 0.1, 0.9)
				end)
			end
		end
	end
end

function Functions.SetXrayPowerText(text)
	local value = tonumber(text)
	if value then
		Functions.SetXrayPower(value)
	end
end

function Functions.RefreshXrayButton()
	if Functions.States.Xray then
		task.spawn(function()
			Functions.RefreshXray()
		end)
	end
end

function Functions.GetHitboxTargetPart(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

function Functions.CleanOldHitboxes()
	local oldFolder = Workspace:FindFirstChild("AxiHitboxes")
	if oldFolder then
		oldFolder:Destroy()
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character then
			for _, obj in ipairs(character:GetDescendants()) do
				if obj.Name == "AxiHitbox" or obj.Name == "AxiHitboxVisual" then
					obj:Destroy()
				end
			end
		end
	end
end

function Functions.ResetHitboxPlayer(player)
	local data = Functions.HitboxParts[player]
	if data then
		if data.Visual and data.Visual.Parent then
			data.Visual:Destroy()
		end
		if data.Part and data.Part.Parent then
			data.Part:Destroy()
		end
		Functions.HitboxParts[player] = nil
	end
end

function Functions.ResetAllHitboxes()
	for player in pairs(Functions.HitboxParts) do
		Functions.ResetHitboxPlayer(player)
	end
	Functions.CleanOldHitboxes()
end

function Functions.UpdateHitboxVisual(data)
	if not data or not data.Part then return end

	if Functions.States.HitboxInvisible then
		if data.Visual then
			data.Visual.Visible = false
		end
		return
	end

	if not data.Visual or not data.Visual.Parent then
		local visual = Instance.new("BoxHandleAdornment")
		visual.Name = "AxiHitboxVisual"
		visual.Adornee = data.Part
		visual.AlwaysOnTop = true
		visual.ZIndex = 10
		visual.Color3 = Color3.fromRGB(255, 0, 0)
		visual.Transparency = 0.55
		visual.Parent = data.Part
		data.Visual = visual
	end

	data.Visual.Visible = true
	data.Visual.Size = data.Part.Size
end

function Functions.ApplyHitboxPlayer(player)
	if not Functions.States.HitboxExtender then return end
	if player == lp then return end
	if not isEnemy(player) or not isSameMatch(player) then
		Functions.ResetHitboxPlayer(player)
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = Functions.GetHitboxTargetPart(character)

	if not character or not humanoid or humanoid.Health <= 0 or not root then
		Functions.ResetHitboxPlayer(player)
		return
	end

	local data = Functions.HitboxParts[player]
	local part = data and data.Part

	if not part or not part.Parent then
		part = Instance.new("Part")
		part.Name = "AxiHitbox"
		part.Shape = Enum.PartType.Block
		part.Material = Enum.Material.SmoothPlastic
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Anchored = true
		part.Massless = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = true
		part.CastShadow = false
		part.Transparency = 1
		part.Parent = character

		data = {
			Part = part,
			Root = root,
			Visual = nil
		}

		Functions.HitboxParts[player] = data
	else
		data.Root = root
		if part.Parent ~= character then
			part.Parent = character
		end
	end

	local size = math.clamp(Functions.Values.HitboxSize or 8, 2, 25)

	pcall(function()
		part.Anchored = true
		part.Massless = true
		part.Size = Vector3.new(size, size, size)
		part.CFrame = root.CFrame
		part.Transparency = 1
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = true
		part.CastShadow = false
	end)

	Functions.UpdateHitboxVisual(data)
end

function Functions.RefreshHitboxes()
	if not Functions.States.HitboxExtender then
		Functions.ResetAllHitboxes()
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		Functions.ApplyHitboxPlayer(player)
	end

	for player in pairs(Functions.HitboxParts) do
		if not player.Parent or not player.Character then
			Functions.ResetHitboxPlayer(player)
		end
	end
end

function Functions.SetHitboxSize(value)
	Functions.Values.HitboxSize = math.clamp(value or 8, 2, 25)
	if Functions.States.HitboxExtender then
		Functions.RefreshHitboxes()
	end
end

function Functions.SetHitboxInvisible(state)
	Functions.States.HitboxInvisible = state
	if Functions.States.HitboxExtender then
		Functions.RefreshHitboxes()
	end
end

function Functions.SetHitboxExtender(state)
	Functions.States.HitboxExtender = state
	Functions.HitboxId = (Functions.HitboxId or 0) + 1

	local id = Functions.HitboxId

	for _, connection in pairs(Functions.HitboxConnections) do
		if connection then
			connection:Disconnect()
		end
	end

	Functions.HitboxConnections = {}

	if not state then
		Functions.ResetAllHitboxes()
		return
	end

	Functions.CleanOldHitboxes()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp then
			Functions.HitboxConnections[player] = player.CharacterAdded:Connect(function()
				task.wait(10)
				Functions.ApplyHitboxPlayer(player)
			end)
		end
	end

	Functions.HitboxConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		Functions.HitboxConnections[player] = player.CharacterAdded:Connect(function()
			task.wait(10)
			Functions.ApplyHitboxPlayer(player)
		end)
	end)

	Functions.HitboxConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		Functions.ResetHitboxPlayer(player)
		local connection = Functions.HitboxConnections[player]
		if connection then
			connection:Disconnect()
			Functions.HitboxConnections[player] = nil
		end
	end)

	Functions.HitboxConnections.Render = RunService.RenderStepped:Connect(function()
		if not Functions.States.HitboxExtender or Functions.HitboxId ~= id then
			if Functions.HitboxConnections.Render then
				Functions.HitboxConnections.Render:Disconnect()
				Functions.HitboxConnections.Render = nil
			end
			return
		end

		Functions.RefreshHitboxes()
	end)

	Functions.RefreshHitboxes()
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

function Functions.SetMenuKeybind(text)
	text = tostring(text or ""):gsub("%s+", "")
	if text == "" then return end

	local keyName = text:sub(1, 1):upper() .. text:sub(2)
	local key = Enum.KeyCode[keyName] or Enum.KeyCode[text:upper()] or Enum.KeyCode[text]

	if key then
		Functions.MenuKeybind = key
	end
end

function Functions.SetHideLogo(state)
	Functions.States.HideLogo = state

	if Functions.GuiObjects and Functions.GuiObjects.Minimized then
		local minimized = Functions.GuiObjects.Minimized
		local main = Functions.GuiObjects.Main

		if state then
			minimized.Visible = false
		elseif Functions.GuiLoaded == true and main and not main.Visible then
			minimized.Visible = true
		else
			minimized.Visible = false
		end
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

local function bindDeathSafety(character)
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	humanoid.Died:Connect(function()
		Functions.AttackInputHeld = false

		if Functions.States.AutoTeleportUser then
			Functions.SetAutoTeleportUser(false)
		end

		if Functions.States.AutoMatchTeleport then
			Functions.SetAutoMatchTeleport(false)
		end

		if Functions.States.AutoKnife then
			Functions.SetAutoKnife(false)
		end

		if Functions.States.AutoSwing then
			Functions.SetAutoSwing(false)
		end
	end)
end

if lp.Character then
	bindDeathSafety(lp.Character)
end

lp.CharacterAdded:Connect(function(character)
	bindDeathSafety(character)
	task.wait(0.65)
	if Functions.States.Speed then Functions.SetSpeed(true) end
	if Functions.States.JumpPower then Functions.SetJumpPower(true) end
	if Functions.States.Flying then
		task.defer(function()
			Functions.StartFly()
		end)
	end
	if Functions.States.HitboxExtender then
		task.defer(function()
			Functions.RefreshHitboxes()
		end)
	end
	if Functions.States.GunTrespasser then
		task.defer(function()
			Functions.RefreshGunTrespasser()
		end)
	end
	if Functions.States.Xray then
		task.defer(function()
			Functions.RefreshXray()
		end)
	end
	if Functions.LastAvatarUsername then Functions.CopyAvatar(Functions.LastAvatarUsername) end
end)


bindMatchStatsAutoClose()

task.spawn(function()
	while task.wait(10) do
		local now = os.clock()

		if Functions.States.AutoOpenChest
			and not Functions.EventOpenBusy
		then
			local openDelay = math.clamp(tonumber(Functions.Values.AutoOpenDelay) or 60, 60, 300)

			if not Functions.LastAutoOpenChestCheck
				or now - Functions.LastAutoOpenChestCheck >= openDelay
			then
				Functions.LastAutoOpenChestCheck = now
				task.spawn(function()
					Functions.OpenAtlantisChest(true, true)
				end)
			end
		end

		if Functions.States.AutoBuyEventChest
			and not Functions.EventBuyBusy
		then
			local buyDelay = math.clamp(tonumber(Functions.Values.AutoBuyDelay) or 90, 90, 600)

			if not Functions.LastAutoBuyChestCheck
				or now - Functions.LastAutoBuyChestCheck >= buyDelay
			then
				Functions.LastAutoBuyChestCheck = now
				task.spawn(function()
					Functions.BuyEventChest(true, true)
				end)
			end
		end
	end
end)

Gui.Create(OptionConfig, Functions)
Functions.AutoLoadConfigOnStart()

