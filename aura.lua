local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local Gui = {}

function Gui.Create(OptionConfig, Functions)
	local logoAsset = OptionConfig.Assets.Logo
	local dominationIcon = OptionConfig.Assets.DominationIcon
	local playersIcon = OptionConfig.Assets.PlayersIcon
	local settingsIcon = OptionConfig.Assets.SettingsIcon
	local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150"

	local old = pg:FindFirstChild("AxiAdminPanel")
	if old then old:Destroy() end

	local oldBlur = Lighting:FindFirstChild("AxiPanelBlur")
	if oldBlur then oldBlur:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AxiAdminPanel"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.DisplayOrder = 999999
	gui.Parent = pg

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

	gradient(glass, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(70, 70, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}), 120, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.72),
		NumberSequenceKeypoint.new(0.45, 0.98),
		NumberSequenceKeypoint.new(1, 0.86)
	}))

	local shine = Instance.new("Frame")
	shine.AnchorPoint = Vector2.new(0.5, 0.5)
	shine.Position = UDim2.fromScale(0.35, 0.14)
	shine.Size = UDim2.fromOffset(540, 62)
	shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shine.BackgroundTransparency = 0.95
	shine.BorderSizePixel = 0
	shine.Rotation = -17
	shine.ZIndex = 13
	shine.Parent = main

	corner(shine, 32)

	gradient(shine, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}), 0, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.28),
		NumberSequenceKeypoint.new(1, 1)
	}))

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

		b.MouseEnter:Connect(function()
			tween(b, {BackgroundTransparency = 0.3}, 0.15)
			tween(icon, {TextColor3 = name == "Close" and Color3.fromRGB(255, 95, 120) or Color3.fromRGB(255, 255, 255)}, 0.15)
		end)

		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 0.5}, 0.15)
			tween(icon, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
		end)

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

	gradient(sidebar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 48)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 43))
	}), 90, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.32),
		NumberSequenceKeypoint.new(0.5, 0.08),
		NumberSequenceKeypoint.new(1, 0.32)
	}))

	local tabsFrame = Instance.new("Frame")
	tabsFrame.Size = UDim2.new(1, -34, 0, 215)
	tabsFrame.Position = UDim2.fromOffset(17, 24)
	tabsFrame.BackgroundTransparency = 1
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

	gradient(content, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 46)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 44))
	}), 135, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.32),
		NumberSequenceKeypoint.new(0.5, 0.08),
		NumberSequenceKeypoint.new(1, 0.32)
	}))

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
		local holder = Instance.new("Frame")
		holder.Size = half and UDim2.new(0.5, -5, 1, 0) or UDim2.new(1, 0, 0, 68)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 0.5
		holder.BorderSizePixel = 0
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

		local toggle = Instance.new("TextButton")
		toggle.AnchorPoint = Vector2.new(1, 0.5)
		toggle.Position = UDim2.new(1, -14, 0.5, 0)
		toggle.Size = UDim2.fromOffset(50, 28)
		toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		toggle.BackgroundTransparency = 0.14
		toggle.BorderSizePixel = 0
		toggle.Text = ""
		toggle.AutoButtonColor = false
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

			if data.Callback and Functions[data.Callback] then
				task.spawn(Functions[data.Callback], state)
			end
		end

		toggle.MouseButton1Click:Connect(function()
			setState(not enabled)
		end)

		holder.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				setState(not enabled)
			end
		end)

		setState(enabled, true)

		return {
			Set = setState,
			Get = function()
				return enabled
			end
		}
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
		local relDefault = math.clamp((default - min) / (max - min), 0, 1)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(relDefault, 1)
		fill.BackgroundColor3 = Color3.fromRGB(255, 74, 96)
		fill.BorderSizePixel = 0
		fill.ZIndex = 29
		fill.Parent = bar

		corner(fill, 8)

		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.fromScale(relDefault, 0.5)
		knob.Size = UDim2.fromOffset(18, 18)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		knob.ZIndex = 30
		knob.Parent = bar

		corner(knob, 9)

		local value = default
		local draggingSlider = false

		local function setValue(v)
			local rel = math.clamp((v - min) / (max - min), 0, 1)
			value = math.floor(min + (max - min) * rel)
			valueText.Text = tostring(value)
			fill.Size = UDim2.fromScale(rel, 1)
			knob.Position = UDim2.fromScale(rel, 0.5)

			if data.Callback and Functions[data.Callback] then
				task.spawn(Functions[data.Callback], value)
			end
		end

		local function setValueFromX(x)
			local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			setValue(min + (max - min) * rel)
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
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setValueFromX(input.Position.X)
			end
		end)

		setValue(default)

		return {
			Set = setValue,
			Get = function()
				return value
			end
		}
	end

	local function makeButton(parent, data)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 62)
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
		name.Size = UDim2.new(1, -74, 0, 24)
		name.Position = UDim2.fromOffset(16, 10)
		name.BackgroundTransparency = 1
		name.Text = data.Name
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 14
		name.Font = Enum.Font.GothamBlack
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 28
		name.Parent = b

		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -74, 0, 20)
		desc.Position = UDim2.fromOffset(16, 34)
		desc.BackgroundTransparency = 1
		desc.Text = data.Description or ""
		desc.TextColor3 = Color3.fromRGB(150, 156, 175)
		desc.TextSize = 11
		desc.Font = Enum.Font.GothamBold
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextTruncate = Enum.TextTruncate.AtEnd
		desc.ZIndex = 28
		desc.Parent = b

		local arrow = Instance.new("TextLabel")
		arrow.AnchorPoint = Vector2.new(1, 0.5)
		arrow.Position = UDim2.new(1, -20, 0.5, 0)
		arrow.Size = UDim2.fromOffset(24, 24)
		arrow.BackgroundTransparency = 1
		arrow.Text = "›"
		arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
		arrow.TextSize = 28
		arrow.Font = Enum.Font.GothamBlack
		arrow.ZIndex = 28
		arrow.Parent = b

		b.MouseEnter:Connect(function()
			tween(b, {BackgroundTransparency = 0.4}, 0.15)
		end)

		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 0.5}, 0.15)
		end)

		b.MouseButton1Click:Connect(function()
			if data.Callback and Functions[data.Callback] then
				task.spawn(Functions[data.Callback])
			end
		end)

		return b
	end

	local function addOption(parent, data)
		if data.Type == "toggle" then
			makeToggle(parent, data, false)
		elseif data.Type == "slider" then
			makeSlider(parent, data)
		elseif data.Type == "button" then
			makeButton(parent, data)
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
						makeToggle(row, data, true)
						makeToggle(row, nextData, true)
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
			if shade then shade.BackgroundTransparency = shadeT shade.BackgroundColor3 = color end
			if accent then accent.BackgroundTransparency = accentT accent.BackgroundColor3 = color end
			if glow then glow.BackgroundTransparency = glowT glow.BackgroundColor3 = color end
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
		tab.Size = UDim2.new(1, 0, 0, 58)
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

		gradient(tabGlass, ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 90)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
		}), 120, NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.84),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(1, 0.92)
		}))

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

		tab.MouseEnter:Connect(function()
			if selectedTab ~= tab then
				tween(tab, {BackgroundTransparency = 0.5}, 0.15)
				tween(iconGlow, {BackgroundTransparency = 0.72}, 0.15)
				tween(icon, {ImageColor3 = color}, 0.15)
				tween(label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
			end
		end)

		tab.MouseLeave:Connect(function()
			if selectedTab ~= tab then
				tabState(tab, false, false)
			end
		end)

		tab.MouseButton1Click:Connect(function()
			selectedTab = tab
			pageTitle.Text = tabData.Name
			showPage(tabData.Name)
			for _, other in ipairs(tabs) do
				tabState(other, other == selectedTab, false)
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

	local bottomDecor = Instance.new("TextLabel")
	bottomDecor.AnchorPoint = Vector2.new(0.5, 1)
	bottomDecor.Position = UDim2.new(0.5, 0, 1, -6)
	bottomDecor.Size = UDim2.new(1, -18, 0, 30)
	bottomDecor.BackgroundTransparency = 1
	bottomDecor.Text = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	bottomDecor.TextSize = 21
	bottomDecor.Font = Enum.Font.GothamBlack
	bottomDecor.TextColor3 = Color3.fromRGB(0, 0, 0)
	bottomDecor.TextXAlignment = Enum.TextXAlignment.Center
	bottomDecor.ZIndex = 45
	bottomDecor.Parent = main

	local bottomStroke = Instance.new("UIStroke")
	bottomStroke.Color = Color3.fromRGB(255, 255, 255)
	bottomStroke.Transparency = 0.52
	bottomStroke.Thickness = 1
	bottomStroke.Parent = bottomDecor

	local minimized = Instance.new("TextButton")
	minimized.Name = "Minimized"
	minimized.AnchorPoint = Vector2.new(0.5, 0.5)
	minimized.Position = UDim2.fromScale(0.5, 0.5)
	minimized.Size = UDim2.fromOffset(82, 82)
	minimized.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	minimized.BackgroundTransparency = 0.45
	minimized.BorderSizePixel = 0
	minimized.Text = ""
	minimized.AutoButtonColor = false
	minimized.Visible = false
	minimized.ZIndex = 100
	minimized.Parent = gui

	corner(minimized, 27)
	stroke(minimized, Color3.fromRGB(255, 255, 255), 0.72, 1)

	local minLogo = Instance.new("ImageLabel")
	minLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	minLogo.Position = UDim2.fromScale(0.5, 0.42)
	minLogo.Size = UDim2.fromOffset(52, 52)
	minLogo.BackgroundTransparency = 1
	minLogo.Image = logoAsset
	minLogo.ScaleType = Enum.ScaleType.Fit
	minLogo.ZIndex = 101
	minLogo.Parent = minimized

	local minText = Instance.new("TextLabel")
	minText.AnchorPoint = Vector2.new(0.5, 1)
	minText.Position = UDim2.new(0.5, 0, 1, -6)
	minText.Size = UDim2.new(1, 0, 0, 18)
	minText.BackgroundTransparency = 1
	minText.Text = OptionConfig.Window.Title
	minText.TextColor3 = Color3.fromRGB(0, 0, 0)
	minText.TextSize = 13
	minText.Font = Enum.Font.FredokaOne
	minText.ZIndex = 101
	minText.Parent = minimized

	local minStroke = Instance.new("UIStroke")
	minStroke.Color = Color3.fromRGB(255, 255, 255)
	minStroke.Transparency = 0.35
	minStroke.Thickness = 1
	minStroke.Parent = minText

	local warningOverlay = Instance.new("Frame")
	warningOverlay.Size = UDim2.fromScale(1, 1)
	warningOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	warningOverlay.BackgroundTransparency = 1
	warningOverlay.BorderSizePixel = 0
	warningOverlay.Visible = false
	warningOverlay.ZIndex = 200
	warningOverlay.Parent = gui

	local warningBox = Instance.new("Frame")
	warningBox.AnchorPoint = Vector2.new(0.5, 0.5)
	warningBox.Position = UDim2.fromScale(0.5, 0.5)
	warningBox.Size = UDim2.fromOffset(390, 210)
	warningBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	warningBox.BackgroundTransparency = 0.48
	warningBox.BorderSizePixel = 0
	warningBox.ZIndex = 201
	warningBox.Parent = warningOverlay

	corner(warningBox, 24)
	stroke(warningBox, Color3.fromRGB(255, 255, 255), 0.72, 1)

	local warningTitle = Instance.new("TextLabel")
	warningTitle.Size = UDim2.new(1, -52, 0, 36)
	warningTitle.Position = UDim2.fromOffset(26, 25)
	warningTitle.BackgroundTransparency = 1
	warningTitle.Text = "Close panel?"
	warningTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	warningTitle.TextSize = 23
	warningTitle.Font = Enum.Font.FredokaOne
	warningTitle.TextXAlignment = Enum.TextXAlignment.Left
	warningTitle.ZIndex = 202
	warningTitle.Parent = warningBox

	local warningText = Instance.new("TextLabel")
	warningText.Size = UDim2.new(1, -52, 0, 50)
	warningText.Position = UDim2.fromOffset(26, 74)
	warningText.BackgroundTransparency = 1
	warningText.Text = "Are you sure you want to close " .. OptionConfig.Window.Title .. "? This will remove the panel from your screen."
	warningText.TextColor3 = Color3.fromRGB(190, 195, 210)
	warningText.TextSize = 13
	warningText.Font = Enum.Font.GothamMedium
	warningText.TextWrapped = true
	warningText.TextXAlignment = Enum.TextXAlignment.Left
	warningText.TextYAlignment = Enum.TextYAlignment.Top
	warningText.ZIndex = 202
	warningText.Parent = warningBox

	local function warnButton(name, text, pos, danger)
		local b = Instance.new("TextButton")
		b.Name = name
		b.Size = UDim2.fromOffset(154, 42)
		b.Position = pos
		b.BackgroundColor3 = danger and Color3.fromRGB(255, 90, 110) or Color3.fromRGB(0, 0, 0)
		b.BackgroundTransparency = danger and 0.26 or 0.5
		b.BorderSizePixel = 0
		b.Text = text
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.TextSize = 13
		b.Font = Enum.Font.GothamBlack
		b.AutoButtonColor = false
		b.ZIndex = 202
		b.Parent = warningBox

		corner(b, 13)
		stroke(b, Color3.fromRGB(255, 255, 255), 0.75, 1)

		return b
	end

	local cancelWarning = warnButton("Cancel", "Cancel", UDim2.fromOffset(34, 145), false)
	local confirmClose = warnButton("ConfirmClose", "Close", UDim2.fromOffset(202, 145), true)

	local openSize = main.Size
	local openPos = main.Position
	local busy = false
	local warningOpen = false
	local dragging = false
	local dragStart
	local startPos
	local minDragging = false
	local minDragStart
	local minStartPos
	local movedMin = false

	local function showWarning()
		if busy or warningOpen then return end
		warningOpen = true
		warningOverlay.Visible = true
		warningOverlay.BackgroundTransparency = 1
		warningBox.Size = UDim2.fromOffset(345, 185)
		warningBox.BackgroundTransparency = 1
		tween(warningOverlay, {BackgroundTransparency = 0.42}, 0.22)
		tween(warningBox, {Size = UDim2.fromOffset(390, 210), BackgroundTransparency = 0.48}, 0.26)
	end

	local function hideWarning()
		if not warningOpen then return end
		warningOpen = false
		tween(warningOverlay, {BackgroundTransparency = 1}, 0.2)
		local t = tween(warningBox, {Size = UDim2.fromOffset(345, 185), BackgroundTransparency = 1}, 0.2)
		t.Completed:Connect(function()
			if not warningOpen then warningOverlay.Visible = false end
		end)
	end

	local function openPanel()
		if busy then return end
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
		if busy or warningOpen then return end
		busy = true
		tween(blur, {Size = 0}, 0.25)
		local t = tween(main, {Size = UDim2.fromOffset(96, 76), Position = minimized.Position, BackgroundTransparency = 1}, 0.32)
		t.Completed:Connect(function()
			main.Visible = false
			minimized.Visible = true
			minimized.Size = UDim2.fromOffset(58, 58)
			tween(minimized, {Size = UDim2.fromOffset(82, 82)}, 0.26)
			busy = false
		end)
	end

	local function closePanel()
		if busy then return end
		busy = true
		tween(blur, {Size = 0}, 0.25)
		tween(warningOverlay, {BackgroundTransparency = 1}, 0.18)
		tween(warningBox, {Size = UDim2.fromOffset(345, 185), BackgroundTransparency = 1}, 0.18)
		local t = tween(main, {Size = UDim2.fromOffset(640, 370), Position = UDim2.fromScale(0.5, 0.54), BackgroundTransparency = 1}, 0.32)
		t.Completed:Connect(function()
			gui:Destroy()
			blur:Destroy()
		end)
	end

	minimize.MouseButton1Click:Connect(minimizePanel)
	close.MouseButton1Click:Connect(showWarning)
	cancelWarning.MouseButton1Click:Connect(hideWarning)
	confirmClose.MouseButton1Click:Connect(closePanel)

	topbar.InputBegan:Connect(function(input)
		if warningOpen then return end
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

	main.Size = UDim2.fromOffset(640, 370)
	main.Position = UDim2.fromScale(0.5, 0.535)
	main.BackgroundTransparency = 1

	tween(blur, {Size = 10}, 0.35)
	tween(main, {
		Size = openSize,
		Position = openPos,
		BackgroundTransparency = 0.58
	}, 0.5)
end

local OptionConfig = {
	Window = {
		Title = "axi",
		Subtitle = "on top"
	},
	Assets = {
		Logo = "rbxassetid://137296929509496",
		DominationIcon = "rbxthumb://type=Asset&id=83399776429635&w=150&h=150",
		PlayersIcon = "rbxthumb://type=Asset&id=127295787879229&w=150&h=150",
		SettingsIcon = "rbxthumb://type=Asset&id=109264660442602&w=150&h=150"
	},
	Tabs = {
		{
			Name = "Domination",
			Icon = "rbxthumb://type=Asset&id=83399776429635&w=150&h=150",
			Color = Color3.fromRGB(255, 74, 96),
			Sections = {
				{
					Name = "Main Controls",
					Description = "Core domination features",
					Options = {
						{
							Type = "toggle",
							Name = "Auto XD",
							Description = "Runs Auto XD function",
							Callback = "SetAutoXD",
							Default = false
						},
						{
							Type = "toggle",
							Name = "OK",
							Description = "Toggle OK function",
							Callback = "SetOK",
							Default = false,
							Half = true
						},
						{
							Type = "toggle",
							Name = "LOC",
							Description = "Toggle LOC function",
							Callback = "SetLOC",
							Default = false,
							Half = true
						}
					}
				},
				{
					Name = "Movement",
					Description = "Speed options separated from main controls",
					Options = {
						{
							Type = "toggle",
							Name = "Speed",
							Description = "Enable custom walkspeed",
							Callback = "SetSpeed",
							Default = false
						},
						{
							Type = "slider",
							Name = "Speed Amount",
							Callback = "SetSpeedValue",
							Min = 16,
							Max = 200,
							Default = 16
						}
					}
				},
				{
					Name = "Extra",
					Description = "More buttons for later",
					Options = {
						{
							Type = "button",
							Name = "Extra Slot",
							Description = "Empty button placeholder",
							Callback = "ExtraSlotOne"
						},
						{
							Type = "button",
							Name = "Extra Slot 2",
							Description = "Empty button placeholder",
							Callback = "ExtraSlotTwo"
						}
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
						{
							Type = "toggle",
							Name = "Enable Highlight Team",
							Description = "Separated highlight team function",
							Callback = "SetTeamHighlight",
							Default = false
						}
					}
				}
			}
		},
		{
			Name = "Settings",
			Icon = "rbxthumb://type=Asset&id=109264660442602&w=150&h=150",
			Color = Color3.fromRGB(180, 135, 255),
			Sections = {},
			EmptyText = "Nothing here for now."
		}
	}
}

local Functions = {}

Functions.States = {
	TeamHighlight = false,
	AutoXD = false,
	OK = false,
	LOC = false,
	Speed = false
}

Functions.Values = {
	Speed = 16
}

function Functions.SetTeamHighlight(state)
	Functions.States.TeamHighlight = state
	Functions.TeamHighlights = Functions.TeamHighlights or {}
	Functions.TeamHighlightRefreshId = (Functions.TeamHighlightRefreshId or 0) + 1

	local refreshId = Functions.TeamHighlightRefreshId
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	local function clear()
		for _, h in pairs(Functions.TeamHighlights) do
			if h then
				h:Destroy()
			end
		end
		Functions.TeamHighlights = {}
	end

	local function readTeam(player)
		local character = player.Character
		local list = {}

		local function add(v)
			if v ~= nil then
				table.insert(list, tostring(v):lower())
			end
		end

		if player.Team and player.Team.Name and player.Team.Name ~= "" then
			add(player.Team.Name)
		end

		if player.TeamColor and player.TeamColor ~= BrickColor.new("Medium stone grey") then
			add(player.TeamColor.Name)
		end

		add(player:GetAttribute("Team"))
		add(player:GetAttribute("TeamName"))
		add(player:GetAttribute("team"))
		add(player:GetAttribute("teamName"))
		add(player:GetAttribute("Side"))
		add(player:GetAttribute("side"))

		if character then
			add(character:GetAttribute("Team"))
			add(character:GetAttribute("TeamName"))
			add(character:GetAttribute("team"))
			add(character:GetAttribute("teamName"))
			add(character:GetAttribute("Side"))
			add(character:GetAttribute("side"))

			for _, v in ipairs(character:GetDescendants()) do
				if v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("BoolValue") then
					local n = v.Name:lower()
					if n:find("team") or n:find("side") or n:find("color") then
						add(v.Name)
						add(v.Value)
					end
				end
			end
		end

		for _, v in ipairs(player:GetDescendants()) do
			if v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("BoolValue") then
				local n = v.Name:lower()
				if n:find("team") or n:find("side") or n:find("color") then
					add(v.Name)
					add(v.Value)
				end
			end
		end

		return table.concat(list, " ")
	end

	local function getSide(player)
		local myTeam = readTeam(LocalPlayer)
		local theirTeam = readTeam(player)

		local myRed = myTeam:find("red") or myTeam:find("team1") or myTeam:find("team 1") or myTeam:find("1")
		local myBlue = myTeam:find("blue") or myTeam:find("team2") or myTeam:find("team 2") or myTeam:find("2")
		local theirRed = theirTeam:find("red") or theirTeam:find("team1") or theirTeam:find("team 1") or theirTeam:find("1")
		local theirBlue = theirTeam:find("blue") or theirTeam:find("team2") or theirTeam:find("team 2") or theirTeam:find("2")

		if myRed and theirRed then
			return "team"
		end

		if myBlue and theirBlue then
			return "team"
		end

		if myRed and theirBlue then
			return "enemy"
		end

		if myBlue and theirRed then
			return "enemy"
		end

		if LocalPlayer.Team ~= nil and player.Team ~= nil and LocalPlayer.Team ~= player.Team then
			return "enemy"
		end

		if LocalPlayer.Team ~= nil and player.Team ~= nil and LocalPlayer.Team == player.Team then
			return "team"
		end

		if LocalPlayer.TeamColor ~= nil and player.TeamColor ~= nil and LocalPlayer.TeamColor ~= BrickColor.new("Medium stone grey") and player.TeamColor ~= BrickColor.new("Medium stone grey") then
			if LocalPlayer.TeamColor == player.TeamColor then
				return "team"
			else
				return "enemy"
			end
		end

		if theirRed then
			return "enemy"
		end

		if theirBlue then
			return "team"
		end

		return "enemy"
	end

	local function getColor(player)
		if getSide(player) == "team" then
			return Color3.fromRGB(0, 120, 255)
		end

		return Color3.fromRGB(255, 0, 0)
	end

	local function refresh()
		if not Functions.States.TeamHighlight then
			clear()
			return
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = player.Character

				if character then
					local old = Functions.TeamHighlights[player]

					if old and (not old.Parent or old.Adornee ~= character) then
						old:Destroy()
						Functions.TeamHighlights[player] = nil
						old = nil
					end

					local color = getColor(player)

					if old then
						old.FillColor = color
						old.OutlineColor = color
						old.Enabled = true
					else
						local h = Instance.new("Highlight")
						h.Name = "TeamHighlight"
						h.Adornee = character
						h.FillColor = color
						h.OutlineColor = color
						h.FillTransparency = 0.35
						h.OutlineTransparency = 0
						h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						h.Enabled = true
						h.Parent = character

						Functions.TeamHighlights[player] = h
					end
				end
			end
		end

		for player, h in pairs(Functions.TeamHighlights) do
			if not player.Parent or not player.Character then
				if h then
					h:Destroy()
				end
				Functions.TeamHighlights[player] = nil
			end
		end
	end

	clear()

	if not state then
		return
	end

	refresh()

	task.spawn(function()
		while Functions.States.TeamHighlight and Functions.TeamHighlightRefreshId == refreshId do
			task.wait(5)
			if Functions.States.TeamHighlight and Functions.TeamHighlightRefreshId == refreshId then
				refresh()
			end
		end
	end)
end



function Functions.SetAutoXD(state)
	Functions.States.AutoXD = state
	Functions.AutoXDId = (Functions.AutoXDId or 0) + 1

	local id = Functions.AutoXDId
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = Players.LocalPlayer
	local Range = 160
	local CheckDelay = 0.5

	if Functions.AutoXDConnection then
		task.cancel(Functions.AutoXDConnection)
		Functions.AutoXDConnection = nil
	end

	local function sideFromText(v)
		if v == nil then
			return nil
		end

		local s = tostring(v):lower()

		if s == "red" or s == "team1" or s == "team 1" or s == "side1" or s == "side 1" or s == "1" or s:find("red") then
			return "red"
		end

		if s == "blue" or s == "team2" or s == "team 2" or s == "side2" or s == "side 2" or s == "2" or s:find("blue") then
			return "blue"
		end

		return nil
	end

	local function getSide(player)
		if player.Team then
			local side = sideFromText(player.Team.Name)
			if side then
				return side
			end
		end

		local side =
			sideFromText(player:GetAttribute("Team")) or
			sideFromText(player:GetAttribute("TeamName")) or
			sideFromText(player:GetAttribute("team")) or
			sideFromText(player:GetAttribute("teamName")) or
			sideFromText(player:GetAttribute("Side")) or
			sideFromText(player:GetAttribute("side"))

		if side then
			return side
		end

		local character = player.Character
		if character then
			side =
				sideFromText(character:GetAttribute("Team")) or
				sideFromText(character:GetAttribute("TeamName")) or
				sideFromText(character:GetAttribute("team")) or
				sideFromText(character:GetAttribute("teamName")) or
				sideFromText(character:GetAttribute("Side")) or
				sideFromText(character:GetAttribute("side"))

			if side then
				return side
			end
		end

		if player.TeamColor and player.TeamColor ~= BrickColor.new("Medium stone grey") then
			local c = player.TeamColor.Color

			if c.R > c.B then
				return "red"
			end

			if c.B > c.R then
				return "blue"
			end
		end

		return nil
	end

	local function isEnemy(player)
		if player == LocalPlayer then
			return false
		end

		local mySide = getSide(LocalPlayer)
		local theirSide = getSide(player)

		if mySide and theirSide then
			return mySide ~= theirSide
		end

		if LocalPlayer.Team and player.Team then
			return LocalPlayer.Team ~= player.Team
		end

		if LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor ~= BrickColor.new("Medium stone grey") and player.TeamColor ~= BrickColor.new("Medium stone grey") then
			return LocalPlayer.TeamColor ~= player.TeamColor
		end

		return false
	end

	local function inMatch()
		return getSide(LocalPlayer) ~= nil or LocalPlayer.Team ~= nil or (LocalPlayer.TeamColor and LocalPlayer.TeamColor ~= BrickColor.new("Medium stone grey"))
	end

	local function getGun()
		local character = LocalPlayer.Character
		local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

		if character then
			for _, tool in ipairs(character:GetChildren()) do
				if tool:IsA("Tool") then
					local n = tool.Name:lower()
					if n == "gun 2" or n == "gun2" or n:find("gun") then
						return tool, true
					end
				end
			end
		end

		if backpack then
			for _, tool in ipairs(backpack:GetChildren()) do
				if tool:IsA("Tool") then
					local n = tool.Name:lower()
					if n == "gun 2" or n == "gun2" or n:find("gun") then
						return tool, false
					end
				end
			end
		end

		return nil, false
	end

	local function canSee(enemyCharacter, targetPart)
		local character = LocalPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not character or not root or not enemyCharacter or not targetPart then
			return false
		end

		local origin = root.Position + Vector3.new(0, 1.7, 0)
		local direction = targetPart.Position - origin

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {character}
		params.IgnoreWater = true

		local result = Workspace:Raycast(origin, direction, params)

		return not result or result.Instance:IsDescendantOf(enemyCharacter)
	end

	local function getTarget()
		local character = LocalPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not root then
			return nil
		end

		local closestHead = nil
		local closestDistance = Range

		for _, player in ipairs(Players:GetPlayers()) do
			if isEnemy(player) then
				local enemyCharacter = player.Character
				local enemyHumanoid = enemyCharacter and enemyCharacter:FindFirstChildOfClass("Humanoid")
				local enemyRoot = enemyCharacter and enemyCharacter:FindFirstChild("HumanoidRootPart")
				local enemyHead = enemyCharacter and enemyCharacter:FindFirstChild("Head")

				if enemyCharacter and enemyHumanoid and enemyHumanoid.Health > 0 and enemyRoot and enemyHead then
					local distance = (root.Position - enemyRoot.Position).Magnitude

					if distance <= closestDistance and canSee(enemyCharacter, enemyHead) then
						closestDistance = distance
						closestHead = enemyHead
					end
				end
			end
		end

		return closestHead
	end

	local function fireTool(tool, target)
		pcall(function()
			tool:Activate()
		end)

		for _, v in ipairs(tool:GetChildren()) do
			if v:IsA("RemoteEvent") then
				pcall(function()
					v:FireServer(target.Position, target)
				end)

				pcall(function()
					v:FireServer(target)
				end)

				pcall(function()
					v:FireServer({
						Position = target.Position,
						Target = target,
						Hit = target,
						Part = target
					})
				end)
			end
		end
	end

	local function shoot(target)
		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if not character or not humanoid or not target then
			return
		end

		local tool, equipped = getGun()

		if not tool then
			return
		end

		if not equipped then
			humanoid:EquipTool(tool)
			tool.Parent = character
		end

		fireTool(tool, target)
	end

	if not state then
		return
	end

	Functions.AutoXDConnection = task.spawn(function()
		while Functions.States.AutoXD and Functions.AutoXDId == id do
			if inMatch() then
				local target = getTarget()
				if target then
					shoot(target)
				end
			end

			task.wait(CheckDelay)
		end
	end)
end


function Functions.SetOK(state)
	Functions.States.OK = state
end

function Functions.SetLOC(state)
	Functions.States.LOC = state
end

function Functions.SetSpeed(state)
	Functions.States.Speed = state
	local char = lp.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = state and Functions.Values.Speed or 16
	end
end

function Functions.SetSpeedValue(value)
	Functions.Values.Speed = value
	if Functions.States.Speed then
		local char = lp.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = value
		end
	end
end

function Functions.ExtraSlotOne()
end

function Functions.ExtraSlotTwo()
end

lp.CharacterAdded:Connect(function()
	task.wait(0.5)
	if Functions.States.Speed then
		Functions.SetSpeed(true)
	end
end)

Gui.Create(OptionConfig, Functions)
