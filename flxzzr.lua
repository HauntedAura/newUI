local UI = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()

local Utility = {}
local Objects = {}

local ToggledUI = true

function UI:DraggingEnabled(frame, parent)

	parent = parent or frame

	-- stolen from wally or kiriot, kek
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = parent.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	input.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end

function Utility:TweenObject(obj, properties, duration, ...)
	tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local themes = {
	Background = Color3.fromRGB(74, 99, 135),
	LightContrast = Color3.fromRGB(36, 37, 43),
	Accent = Color3.fromRGB(28, 29, 34),
	TextColor = Color3.fromRGB(255,255,255),
	DarkContrast = Color3.fromRGB(32, 32, 38),
	Glow = Color3.fromRGB(0, 0, 0)
}
local themeStyles = {
	Dark = {
		Background = Color3.fromRGB(25, 25, 25),
		LightContrast = Color3.fromRGB(20, 20, 20),
		Accent = Color3.fromRGB(10, 10, 10),
		TextColor = Color3.fromRGB(255,255,255),
		DarkContrast = Color3.fromRGB(15, 15, 15),
		Glow = Color3.fromRGB(0, 0, 0)
	},
	Light = {
		Background = Color3.fromRGB(230, 230, 230),
		LightContrast = Color3.fromRGB(225, 225, 225),
		Accent = Color3.fromRGB(210, 210, 210),
		TextColor = Color3.fromRGB(100, 100, 100),
		DarkContrast = Color3.fromRGB(215, 215, 215),
		Glow = Color3.fromRGB(150, 150, 150)
	},
	Midnight = {
		Background = Color3.fromRGB(0, 10, 25),
		LightContrast = Color3.fromRGB(0, 16, 40),
		Accent = Color3.fromRGB(0, 7, 18),
		TextColor = Color3.fromRGB(255,255,255),
		DarkContrast = Color3.fromRGB(0, 12, 31),
		Glow = Color3.fromRGB(0, 16, 39)
	},
	Ocean = {
		Background = Color3.fromRGB(0, 100, 150),
		LightContrast = Color3.fromRGB(0, 93, 140),
		Accent = Color3.fromRGB(0, 80, 120),
		TextColor = Color3.fromRGB(255, 255, 255),
		DarkContrast = Color3.fromRGB(0, 83, 125),
		Glow = Color3.fromRGB(0, 63, 100)
	},
	Love = {
		Background = Color3.fromRGB(255, 105, 192),
		LightContrast = Color3.fromRGB(245, 105, 192),
		Accent = Color3.fromRGB(220, 105, 192),
		TextColor = Color3.fromRGB(255, 255, 255),
		DarkContrast = Color3.fromRGB(230, 105, 192),
		Glow = Color3.fromRGB(205, 105, 192)
	},
	Grape = {
		Background = Color3.fromRGB(87, 0, 150),
		LightContrast = Color3.fromRGB(82, 0, 140),
		Accent = Color3.fromRGB(70, 0, 120),
		TextColor = Color3.fromRGB(255, 255, 255),
		DarkContrast = Color3.fromRGB(73, 0, 125),
		Glow = Color3.fromRGB(58, 0, 100)
	}
}
local oldTheme = ""

local SettingsT = {

}

local LibName = "flxzzrlib"

function UI:ToggleUI()
	if ToggledUI then
		ToggledUI = false
		Utility:TweenObject(game.CoreGui[LibName].Main.Topbar, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)
		wait(0.2)
		Utility:TweenObject(game.CoreGui[LibName].Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.2)
		wait(0.15)
		game.CoreGui[LibName].Main.Visible = false
	else
		ToggledUI = true
		game.CoreGui[LibName].Main.Visible = true
		Utility:TweenObject(game.CoreGui[LibName].Main, {Size = UDim2.new(0, 500, 0, 350)}, 0.2)
		wait(0.2)
		Utility:TweenObject(game.CoreGui[LibName].Main.Topbar, {Size = UDim2.new(1, 0, 0, 30)}, 0.2)
	end
end

function UI.CreateLib(libName, themeList)
	
	if not themeList then
		themeList = themes
	end
	if themeList == "Dark" then
		themeList = themeStyles.Dark
	elseif themeList == "Light" then
		themeList = themeStyles.Light
	elseif themeList == "Midnight" then
		themeList = themeStyles.Midnight
	elseif themeList == "Ocean" then
		themeList = themeStyles.Ocean
	elseif themeList == "Love" then
		themeList = themeStyles.Love
	elseif themeList == "Grape" then
		themeList = themeStyles.Grape
	else
		if themeList.Background == nil then
			themeList.Background = Color3.fromRGB(74, 99, 135)
		elseif themeList.LightContrast == nil then
			themeList.LightContrast = Color3.fromRGB(36, 37, 43)
		elseif themeList.Accent == nil then
			themeList.Accent = Color3.fromRGB(28, 29, 34)
		elseif themeList.TextColor == nil then
			themeList.TextColor = Color3.fromRGB(255,255,255)
		elseif themeList.DarkContrast == nil then
			themeList.DarkContrast = Color3.fromRGB(32, 32, 38)
		elseif themeList.Glow == nil then
			themeList.Glow = Color3.fromRGB(0, 0, 0)
		end
	end

	themeList = themeList or {}
	local selectedTab 
	libName = libName or "Library"
	table.insert(UI, libName)
	for i,v in pairs(game.CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == LibName then
			v:Destroy()
		end
	end

	local GUI = Instance.new("ScreenGui")
	local Main = Instance.new("ImageLabel")
	local Glow = Instance.new("ImageLabel")
	local Sidebar = Instance.new("ImageLabel")
	local Holder = Instance.new("ScrollingFrame")
	local Topbar = Instance.new("ImageLabel")
	local Menu = Instance.new("ImageButton")
	local Title = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")
	local Holder_2 = Instance.new("Frame")

	UI:DraggingEnabled(Topbar, Main)

	input.InputBegan:Connect(function(input, gpe)
		if gpe then return end
	
		if input.KeyCode == Enum.KeyCode.H then
			UI:ToggleUI()
		end
	end)

	GUI.Name = LibName
	GUI.Parent = game.CoreGui
	GUI.ResetOnSpawn = false

	Main.Name = "Main"
	Main.Parent = GUI
	Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Main.BackgroundTransparency = 1.000
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0, 575, 0, 50)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Image = "rbxassetid://106029421612493"
	Main.ImageColor3 = themeList.Background
	Main.ScaleType = Enum.ScaleType.Slice
	Main.SliceCenter = Rect.new(4, 4, 496, 346)

	Glow.Name = "Glow"
	Glow.Parent = Main
	Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Glow.BackgroundTransparency = 1.000
	Glow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Glow.BorderSizePixel = 0
	Glow.Position = UDim2.new(0, -15, 0, -15)
	Glow.Size = UDim2.new(1, 30, 1, 30)
	Glow.ZIndex = 0
	Glow.Image = "rbxassetid://87592519230697"
	Glow.ImageColor3 = themeList.Glow
	Glow.ScaleType = Enum.ScaleType.Slice
	Glow.SliceCenter = Rect.new(4, 4, 528, 378)

	Sidebar.Name = "Sidebar"
	Sidebar.Parent = Main
	Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Sidebar.BackgroundTransparency = 1.000
	Sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 30)
	Sidebar.Size = UDim2.new(0, 0, 1, -30)
	Sidebar.ZIndex = 2
	Sidebar.Image = "rbxassetid://119633088413426"
	Sidebar.ImageColor3 = themeList.DarkContrast
	Sidebar.ScaleType = Enum.ScaleType.Slice
	Sidebar.SliceCenter = Rect.new(4, 4, 116, 316)
	Sidebar.ClipsDescendants = true

	Holder.Name = "Holder"
	Holder.Parent = Sidebar
	Holder.Active = true
	Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Holder.BackgroundTransparency = 1.000
	Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Holder.BorderSizePixel = 0
	Holder.Position = UDim2.new(0, 0, 0, 10)
	Holder.Size = UDim2.new(1, 0, 1, -20)
	Holder.ZIndex = 3
	Holder.CanvasSize = UDim2.new(0, 0, 0, 0)
	Holder.ScrollBarThickness = 0
	Holder.ClipsDescendants = true

	UIListLayout.Parent = Holder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	Topbar.Name = "Topbar"
	Topbar.Parent = Main
	Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Topbar.BackgroundTransparency = 1.000
	Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(1, 0, 0, 30)
	Topbar.ZIndex = 11
	Topbar.Image = "rbxassetid://117608839266988"
	Topbar.ImageColor3 = themeList.Accent
	Topbar.ScaleType = Enum.ScaleType.Slice
	Topbar.SliceCenter = Rect.new(4, 4, 496, 26)
	Topbar.ClipsDescendants = false

	Menu.Name = "Menu"
	Menu.Parent = Topbar
	Menu.Active = false
	Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Menu.BackgroundTransparency = 1.000
	Menu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Menu.BorderSizePixel = 0
	Menu.Position = UDim2.new(0, 7, 0, 7)
	Menu.Selectable = false
	Menu.Size = UDim2.new(0, 16, 0, 16)
	Menu.ZIndex = 11
	Menu.Image = "rbxassetid://93279066440915"
	Menu.ImageColor3 = themeList.TextColor

	Title.Name = "Title"
	Title.Parent = Topbar
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0, 33, 0, 0)
	Title.Size = UDim2.new(0, 200, 0, 30)
	Title.ZIndex = 11
	Title.Font = Enum.Font.GothamSemibold
	Title.Text = libName
	Title.TextColor3 = themeList.TextColor
	Title.TextSize = 14.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Holder_2.Name = "Holder"
	Holder_2.Parent = Main
	Holder_2.AnchorPoint = Vector2.new(1, 0)
	Holder_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Holder_2.BackgroundTransparency = 1
	Holder_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Holder_2.BorderSizePixel = 0
	Holder_2.Position = UDim2.new(1, -10, 0, 40)
	Holder_2.Size = UDim2.new(1, -20, 1, -50)
	Holder_2.ZIndex = 2
	Holder_2.ClipsDescendants = true

	coroutine.wrap(function()
		while wait() do
			Main.BackgroundColor3 = themeList.Background
			Glow.BackgroundColor3 = themeList.Glow
			Sidebar.BackgroundColor3 = themeList.DarkContrast
			Topbar.BackgroundColor3 = themeList.Accent
		end
	end)()

	function UI:ChangeColor(prope, color)
		if prope == "Background" then
			themeList.Background = color
		elseif prope == "LightContrast" then
			themeList.LightContrast = color
		elseif prope == "Header" then
			themeList.Accent = color
		elseif prope == "TextColor" then
			themeList.TextColor = color
		elseif prope == "DarkContrast" then
			themeList.DarkContrast = color
		elseif prope == "Glow" then
			themeList.Glow = color
		end
	end

	Menu.MouseButton1Click:Connect(function()

		if Sidebar.Size == UDim2.new(0, 120, 1, -30) then
			Utility:TweenObject(Sidebar, {Size = UDim2.new(0, 0, 1, -30)}, 0.2)
			Utility:TweenObject(Holder_2, {Size = UDim2.new(1, -20, 1, -50)}, 0.2)
		else
			Utility:TweenObject(Sidebar, {Size = UDim2.new(0, 120, 1, -30)}, 0.2)
			Utility:TweenObject(Holder_2, {Size = UDim2.new(1, -140, 1, -50)}, 0.2)
		end

	end)

	local Tabs = {}

	local first = true

	function Tabs:NewTab(tabName)
		tabName = tabName or "Tab"
		local Tab = Instance.new("TextButton")
		local Title = Instance.new("TextLabel")
		local Selected = Instance.new("Frame")
		local Tab_2 = Instance.new("Frame")
		local Container = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Title_6 = Instance.new("TextLabel")

		Tab.Name = "Tab"
		Tab.Parent = Holder
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, 0, 0, 20)
		Tab.ZIndex = 4
		Tab.AutoButtonColor = false
		Tab.Font = Enum.Font.SourceSans
		Tab.Text = ""
		Tab.TextColor3 = Color3.fromRGB(0, 0, 0)
		Tab.TextSize = 14.000

		Title.Name = "Title"
		Title.Parent = Tab
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 10, 0, 0)
		Title.Size = UDim2.new(1, -20, 1, 0)
		Title.ZIndex = 5
		Title.Font = Enum.Font.Gotham
		Title.Text = tabName
		Title.TextColor3 = Color3.fromRGB(100, 100, 100)
		Title.TextSize = 12.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.TextTransparency = 0.650

		Selected.Name = "TabSelected"
		Selected.Parent = Tab
		Selected.AnchorPoint = Vector2.new(0, 1)
		Selected.BackgroundColor3 = themeList.TextColor
		Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Selected.BorderSizePixel = 0
		Selected.Position = UDim2.new(0, 10, 1, 0)
		Selected.Size = UDim2.new(0, 0, 0, 1)
		Selected.ZIndex = 6

		Tab_2.Name = tabName
		Tab_2.Parent = Holder_2
		Tab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab_2.BackgroundTransparency = 1.000
		Tab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab_2.BorderSizePixel = 0
		Tab_2.Size = UDim2.new(1, 0, 1, 0)
		Tab_2.Visible = false

		Container.Name = "Container"
		Container.Parent = Tab_2
		Container.Active = true
		Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Container.BackgroundTransparency = 1.000
		Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Container.BorderSizePixel = 0
		Container.Position = UDim2.new(0, 0, 0, 30)
		Container.Size = UDim2.new(1, 0, 1, -30)
		Container.ZIndex = 3
		Container.CanvasSize = UDim2.new(0, 0, 0, 0)
		Container.ScrollBarThickness = 3
		Container.CanvasSize = UDim2.new(0, 0, 0, 0)
		Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

		UIListLayout_2.Parent = Container
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 10)
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center

		Title_6.Name = "Title"
		Title_6.Parent = Tab_2
		Title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title_6.BackgroundTransparency = 1.000
		Title_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title_6.BorderSizePixel = 0
		Title_6.Size = UDim2.new(1, 0, 0, 30)
		Title_6.ZIndex = 5
		Title_6.Font = Enum.Font.GothamSemibold
		Title_6.Text = tabName
		Title_6.TextColor3 = themeList.TextColor
		Title_6.TextSize = 20.000
		Title_6.TextXAlignment = Enum.TextXAlignment.Left

		if first then
			first = false
			Tab_2.Visible = true
			Title.TextTransparency = 0
			Utility:TweenObject(Selected, {Size = UDim2.new(0, 15, 0, 1)}, 0.1)
		else
			Tab_2.Visible = false
			Title.TextTransparency = 0.65
			Utility:TweenObject(Selected, {Size = UDim2.new(0, 0, 0, 1)}, 0.1)
		end

		table.insert(Tabs, tabName)

		Tab.MouseButton1Click:Connect(function()
			for i,v in next, Holder_2:GetChildren() do
				v.Visible = false
			end
			Tab_2.Visible = true

			for i,v in next, Holder:GetChildren() do
				if v:IsA("TextButton") then
					Utility:TweenObject(v.Title, {TextTransparency = 0.65}, 0.2)
					Utility:TweenObject(v.TabSelected, {Size = UDim2.new(0, 0, 0, 1)}, 0.1)
				end
			end

			Utility:TweenObject(Title, {TextTransparency = 0}, 0.2)
			Utility:TweenObject(Selected, {Size = UDim2.new(0, 15, 0, 1)}, 0.1)
		end)

		local Sections = {}
		local focusing = false
		local viewDe = false

		coroutine.wrap(function()
			while wait() do
				Container.ScrollBarImageColor3 = themeList.DarkContrast
				Title.TextColor3 = themeList.TextColor
			end
		end)()

		function Sections:NewSection(secName, hidden)
			secName = secName or "Section"
			local sectionFunctions = {}
			local modules = {}
			hidden = hidden or false

			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local SectionTitle = Instance.new("TextLabel")
			local UIPadding = Instance.new("UIPadding")
			local SectionLayout = Instance.new("UIListLayout")

			Section.Name = secName
			Section.Parent = Container
			Section.BackgroundColor3 = themeList.LightContrast
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(1, -20, 0, 50)

			UICorner.Parent = Section
			UICorner.CornerRadius = UDim.new(0, 8)

			SectionTitle.Parent = Section
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 1.000
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Position = UDim2.new(0, 10, 0, 0)
			SectionTitle.Size = UDim2.new(1, -20, 0, 30)
			SectionTitle.Font = Enum.Font.GothamMedium
			SectionTitle.TextColor3 = themeList.TextColor
			SectionTitle.TextSize = 16.000
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Text = secName

			UIPadding.Parent = Section
			UIPadding.PaddingTop = UDim.new(0, 10)

			SectionLayout.Parent = Section
			SectionLayout.Padding = UDim.new(0, 10)
			SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder


			coroutine.wrap(function()
				while wait() do
					Section.BackgroundColor3 = themeList.LightContrast
					SectionTitle.TextColor3 = themeList.TextColor
				end
			end)()

			SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Utility:TweenObject(Section, {Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 20)}, 0.1)
			end)

			local Elements = {}

			function Elements:AddButton(bname, callback)
				local ButtonFunction = {}
				bname = bname or "Click Me!"
				callback = callback or function() end

				table.insert(modules, bname)

				local Button = Instance.new("ImageButton")
				local ButtonCorner = Instance.new("UICorner")
				local ButtontTitle = Instance.new("TextLabel")

				Button.Name = bname
				Button.Parent = Section
				Button.BackgroundColor3 = themeList.DarkContrast
				Button.BackgroundTransparency = 1.000
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, -20, 0, 30)
				Button.ZIndex = 6
				Button.AutoButtonColor = false
				Button.Image = "rbxassetid://108618179346949"
				Button.ImageColor3 = themeList.DarkContrast
				Topbar.ScaleType = Enum.ScaleType.Slice
				Topbar.SliceCenter = Rect.new(4, 4, 336, 26)

				ButtonCorner.Parent = Button
				ButtonCorner.CornerRadius = UDim.new(0, 8)

				ButtontTitle.Name = "Title"
				ButtontTitle.Parent = Button
				ButtontTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtontTitle.BackgroundTransparency = 1.000
				ButtontTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtontTitle.BorderSizePixel = 0
				ButtontTitle.Size = UDim2.new(1, 0, 1, 0)
				ButtontTitle.ZIndex = 7
				ButtontTitle.Font = Enum.Font.Gotham
				ButtontTitle.Text = bname
				ButtontTitle.TextColor3 = themeList.TextColor
				ButtontTitle.TextSize = 12.000

				local debounce
				local text = ButtontTitle

				Button.MouseButton1Click:Connect(function()
					
					local clone = Button:Clone()

					if debounce then
						return
					end

					debounce = true

					callback()

					clone.AnchorPoint = Vector2.new(0.5, 0.5)
					clone.Size = clone.Size - UDim2.new(1, -66, 0, 26)
					clone.Position = UDim2.new(0.5, 0, 0.5, 0)

					clone.Parent = Button
					clone:ClearAllChildren()

					Button.ImageTransparency = 1
					Utility:TweenObject(clone, {Size = Button.Size}, 0.2)

					spawn(function()
						wait(0.2)

						Button.ImageTransparency = 0
						clone:Destroy()
					end)
					
					text.TextSize = 0
					Utility:TweenObject(Button.Title, {TextSize = 14}, 0.2)

					wait(0.2)
					Utility:TweenObject(Button.Title, {TextSize = 12}, 0.2)

					debounce = false
				end)
				
				coroutine.wrap(function()
					while wait() do
						Button.BackgroundColor3 = themeList.DarkContrast
						ButtontTitle.TextColor3 = themeList.TextColor
					end
				end)()

				return ButtonFunction
			end
			
			function Elements:AddToggle(tname, callback)
				local TogFunction = {}
				tname = tname or "Toggle"
				callback = callback or function() end
				local toggled = false
				table.insert(SettingsT, tname)
				
				local Toggle = Instance.new("TextButton")
				local UICorner_2 = Instance.new("UICorner")
				local tTitle = Instance.new("TextLabel")
				local tHolder = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local Toggle_2 = Instance.new("Frame")
				local UICorner_4 = Instance.new("UICorner")
				
				Toggle.Name = tname
				Toggle.Parent = Section
				Toggle.BackgroundColor3 = themeList.DarkContrast
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.Position = UDim2.new(0, 10, 0, 80)
				Toggle.Size = UDim2.new(1, -20, 0, 30)
				Toggle.ZIndex = 6
				Toggle.AutoButtonColor = false
				Toggle.Font = Enum.Font.Gotham
				Toggle.Text = ""
				Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.TextSize = 12.000

				UICorner_2.Parent = Toggle
				UICorner_2.CornerRadius = UDim.new(0, 8)

				tTitle.Name = "Title"
				tTitle.Parent = Toggle
				tTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				tTitle.BackgroundTransparency = 1.000
				tTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tTitle.BorderSizePixel = 0
				tTitle.Position = UDim2.new(0, 10, 0, 0)
				tTitle.Size = UDim2.new(0.5, -10, 1, 0)
				tTitle.ZIndex = 7
				tTitle.Font = Enum.Font.Gotham
				tTitle.Text = tname
				tTitle.TextColor3 = themeList.TextColor
				tTitle.TextSize = 12.000
				tTitle.TextXAlignment = Enum.TextXAlignment.Left

				tHolder.Name = "Holder"
				tHolder.Parent = Toggle
				tHolder.AnchorPoint = Vector2.new(1, 0)
				tHolder.BackgroundColor3 = themeList.LightContrast
				tHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tHolder.BorderSizePixel = 0
				tHolder.Position = UDim2.new(1, -5, 0, 5)
				tHolder.Size = UDim2.new(0, 50, 0, 20)
				tHolder.ZIndex = 7

				UICorner_3.Parent = tHolder
				UICorner_3.CornerRadius = UDim.new(0, 8)

				Toggle_2.Name = "Toggle"
				Toggle_2.Parent = tHolder
				Toggle_2.AnchorPoint = Vector2.new(0, 0.5)
				Toggle_2.BackgroundColor3 = themeList.TextColor
				Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle_2.BorderSizePixel = 0
				Toggle_2.Position = UDim2.new(0, 3, 0.5, 0)
				Toggle_2.Size = UDim2.new(0, 21, 0, 16)
				Toggle_2.ZIndex = 8

				UICorner_4.Parent = Toggle_2
				UICorner_4.CornerRadius = UDim.new(0, 6)
				
				local debounce
				
				Toggle.MouseButton1Click:Connect(function()
					if debounce then
						return
					end

					debounce = true
					
					if toggled then
						Utility:TweenObject(Toggle_2, {Size = UDim2.new(0, 18, 0, 13)}, 0.1)
						Utility:TweenObject(Toggle_2, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.1)
						wait(0.1)
						Utility:TweenObject(Toggle_2, {Size = UDim2.new(0, 21, 0, 16)}, 0.1)
					else
						Utility:TweenObject(Toggle_2, {Size = UDim2.new(0, 18, 0, 13)}, 0.1)
						Utility:TweenObject(Toggle_2, {Position = UDim2.new(0, 25, 0.5, 0)}, 0.1)
						wait(0.1)
						Utility:TweenObject(Toggle_2, {Size = UDim2.new(0, 21, 0, 16)}, 0.1)
					end
					
					toggled = not toggled

					callback(toggled)
					
					wait(0.1)
					

					debounce = false
				end)
				
				coroutine.wrap(function()
					while wait() do
						Toggle.BackgroundColor3 = themeList.DarkContrast
						Title.TextColor3 = themeList.TextColor
						Toggle_2.BackgroundColor3 = themeList.TextColor
						Holder.BackgroundColor3 = themeList.LightContrast
					end
				end)()
				
				return TogFunction
			end
			
			function Elements:AddSlider(sname, min, max, default, callback)
				
				local SliderFunction = {}
				
				sname = sname or "Slider"
				max = max or 500
				min = min or 16
				default = default or min
				callback = callback or function() end
				
				local Slider = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local sTitle = Instance.new("TextLabel")
				local SliderBack = Instance.new("ImageLabel")
				local Fill = Instance.new("ImageLabel")
				local ValHolder = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Value = Instance.new("TextBox")

				Slider.Name = sname
				Slider.Parent = Section
				Slider.AnchorPoint = Vector2.new(0.5, 0)
				Slider.BackgroundColor3 = themeList.DarkContrast
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.Position = UDim2.new(0.5, 0, 0, 40)
				Slider.Size = UDim2.new(1, -20, 0, 50)
				Slider.ZIndex = 6
				Slider.AutoButtonColor = false
				Slider.Font = Enum.Font.Gotham
				Slider.Text = ""
				Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
				Slider.TextSize = 12.000

				UICorner.Parent = Slider

				sTitle.Name = "Title"
				sTitle.Parent = Slider
				sTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				sTitle.BackgroundTransparency = 1.000
				sTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sTitle.BorderSizePixel = 0
				sTitle.Position = UDim2.new(0, 10, 0, 0)
				sTitle.Size = UDim2.new(0.5, -10, 0, 30)
				sTitle.ZIndex = 7
				sTitle.Font = Enum.Font.Gotham
				sTitle.Text = sname
				sTitle.TextColor3 = themeList.TextColor
				sTitle.TextSize = 12.000
				sTitle.TextXAlignment = Enum.TextXAlignment.Left

				SliderBack.Name = "SliderBack"
				SliderBack.Parent = Slider
				SliderBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				SliderBack.BackgroundTransparency = 1.000
				SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBack.BorderSizePixel = 0
				SliderBack.Position = UDim2.new(0, 10, 0, 35)
				SliderBack.Size = UDim2.new(1, -20, 0, 5)
				SliderBack.ZIndex = 7
				SliderBack.Image = "rbxassetid://94347535578018"
				SliderBack.ImageColor3 = themeList.LightContrast
				SliderBack.ScaleType = Enum.ScaleType.Slice
				SliderBack.SliceCenter = Rect.new(4, 0, 324, 5)

				Fill.Name = "Fill"
				Fill.Parent = SliderBack
				Fill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Fill.BackgroundTransparency = 1.000
				Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Fill.BorderSizePixel = 0
				Fill.Size = UDim2.new(0.5, 0, 0, 5)
				Fill.ZIndex = 7
				Fill.Image = "rbxassetid://94347535578018"
				Fill.ImageColor3 = themeList.TextColor
				Fill.ScaleType = Enum.ScaleType.Slice
				Fill.SliceCenter = Rect.new(4, 0, 324, 5)

				ValHolder.Name = "ValHolder"
				ValHolder.Parent = Slider
				ValHolder.AnchorPoint = Vector2.new(1, 0)
				ValHolder.BackgroundColor3 = themeList.LightContrast
				ValHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ValHolder.BorderSizePixel = 0
				ValHolder.Position = UDim2.new(1, -5, 0, 5)
				ValHolder.Size = UDim2.new(0, 50, 0, 20)
				ValHolder.ZIndex = 8

				UICorner_2.Parent = ValHolder

				Value.Name = "Value"
				Value.Parent = ValHolder
				Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Value.BackgroundTransparency = 1.000
				Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Value.BorderSizePixel = 0
				Value.Size = UDim2.new(1, 0, 1, 0)
				Value.ZIndex = 9
				Value.Font = Enum.Font.GothamMedium
				Value.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
				Value.Text = default
				Value.TextColor3 = themeList.TextColor
				Value.TextSize = 12.000
				
				local ms = game.Players.LocalPlayer:GetMouse()
				local uis = game:GetService("UserInputService")
				local btn = Slider
				
				function SliderFunction:SetValue(v)

					if v == nil then
						local percentage = math.clamp((ms.X - SliderBack.AbsolutePosition.X) / (SliderBack.AbsoluteSize.X), 0, 1)
						local value = math.floor(((max - min) * percentage) + min)

						Value.Text = tostring(value)
						Fill.Size = UDim2.fromScale(percentage, 1)
					else
						if v > max then
							v = max
						elseif v < min then
							v = min
						end
						Value.Text = tostring(v)
						Fill.Size = UDim2.fromScale(((v - min) / (max - min)), 1)
					end

					callback(SliderFunction:GetValue())
				end

				function SliderFunction:GetValue()
					return tonumber(Value.Text)
				end

				
				SliderFunction:SetValue(default)
				local Connection = nil
				
				btn.MouseButton1Down:Connect(function()
					if not Connection then
						Connection = run.RenderStepped:Connect(function()
							SliderFunction:SetValue()
						end)
					end

				end)
				
				btn.MouseButton1Up:Connect(function()
					if Connection then Connection:Disconnect() end
					Connection = nil
				end)
				
				btn.MouseLeave:Connect(function()
					if Connection then Connection:Disconnect() end
					Connection = nil
				end)
				
				Value.FocusLost:Connect(function()
					SliderFunction:SetValue(tonumber(Value.Text))
				end)
				
				coroutine.wrap(function()
					while wait() do
						Slider.BackgroundColor3 = themeList.DarkContrast
						Title.TextColor3 = themeList.TextColor
						SliderBack.BackgroundColor3 = themeList.LightContrast
						Fill.BackgroundColor3 = themeList.TextColor
						ValHolder.BackgroundColor3 = themeList.LightContrast
						Value.TextColor3 = themeList.TextColor
					end
				end)()
				
				return SliderFunction
				
			end
			
			function Elements:AddDropdown(dropname, list, callback)
				local DropFunction = {}
				dropname = dropname or "Dropdown"
				list = list or {}
				callback = callback or function() end   
				
				local Dropdown = Instance.new("Frame")
				local dropCorner = Instance.new("UICorner")
				local dropTitle = Instance.new("TextLabel")
				local dropButton = Instance.new("TextButton")
				local Icon = Instance.new("ImageLabel")
				local List = Instance.new("ScrollingFrame")
				local listLayout = Instance.new("UIListLayout")
				
				Dropdown.Name = dropname
				Dropdown.Parent = Section
				Dropdown.BackgroundColor3 = themeList.DarkContrast
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.ClipsDescendants = true
				Dropdown.Position = UDim2.new(0, 10, 0, 0)
				Dropdown.Size = UDim2.new(1, -20, 0, 30)
				Dropdown.ZIndex = 7

				dropCorner.Parent = Dropdown
				dropCorner.CornerRadius = UDim.new(0, 8)

				dropTitle.Name = "Title"
				dropTitle.Parent = Dropdown
				dropTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				dropTitle.BackgroundTransparency = 1.000
				dropTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				dropTitle.BorderSizePixel = 0
				dropTitle.Position = UDim2.new(0, 10, 0, 0)
				dropTitle.Size = UDim2.new(0.5, -10, 0, 30)
				dropTitle.ZIndex = 8
				dropTitle.Font = Enum.Font.Gotham
				dropTitle.Text = dropname
				dropTitle.TextColor3 = themeList.TextColor
				dropTitle.TextSize = 12.000
				dropTitle.TextXAlignment = Enum.TextXAlignment.Left

				dropButton.Name = "Button"
				dropButton.Parent = Dropdown
				dropButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				dropButton.BackgroundTransparency = 1.000
				dropButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				dropButton.BorderSizePixel = 0
				dropButton.Size = UDim2.new(1, 0, 0, 30)
				dropButton.ZIndex = 8
				dropButton.AutoButtonColor = false
				dropButton.Font = Enum.Font.SourceSans
				dropButton.Text = ""
				dropButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				dropButton.TextSize = 14.000

				Icon.Name = "Icon"
				Icon.Parent = Dropdown
				Icon.AnchorPoint = Vector2.new(1, 0)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(1, -7, 0, 7)
				Icon.Size = UDim2.new(0, 16, 0, 16)
				Icon.ZIndex = 8
				Icon.Image = "rbxassetid://118908870216643"
				Icon.ImageColor3 = themeList.TextColor

				List.Name = "List"
				List.Parent = Dropdown
				List.Active = true
				List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				List.BackgroundTransparency = 1.000
				List.BorderColor3 = Color3.fromRGB(0, 0, 0)
				List.BorderSizePixel = 0
				List.Position = UDim2.new(0, 10, 0, 40)
				List.Size = UDim2.new(1, -20, 0, 110)
				List.ZIndex = 8
				List.CanvasSize = UDim2.new(0, 0, 0, 0)
				List.AutomaticCanvasSize = Enum.AutomaticSize.Y
				List.ScrollBarThickness = 0

				listLayout.Parent = List
				listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				listLayout.SortOrder = Enum.SortOrder.LayoutOrder
				listLayout.Padding = UDim.new(0, 10)
				
				coroutine.wrap(function()
					while wait() do
						Dropdown.BackgroundColor3 = themeList.DarkContrast
						dropTitle.TextColor3 = themeList.TextColor
						Icon.ImageColor3 = themeList.TextColor
					end
				end)()
				
				local dropped

				dropButton.MouseButton1Click:Connect(function()
					
					if dropped then
						Utility:TweenObject(Dropdown, {Size = UDim2.new(1, -20, 0, 30)}, 0.2)
						dropped = false
					else
						Utility:TweenObject(Dropdown, {Size = UDim2.new(1, -20, 0, 160)}, 0.2)
						dropped = true
					end
					
				end)
				
				for _, item in list do
					local itemName = item or "Option"
					
					local item = Instance.new("ImageButton")
					local itemTitle = Instance.new("TextLabel")
					
					item.Name = "Button"
					item.Parent = List
					item.AnchorPoint = Vector2.new(0.5, 0)
					item.BackgroundColor3 = themeList.LightContrast
					item.BackgroundTransparency = 1.000
					item.BorderColor3 = Color3.fromRGB(0, 0, 0)
					item.BorderSizePixel = 0
					item.Position = UDim2.new(0.5, 0, 0, 40)
					item.Size = UDim2.new(1, 0, 0, 30)
					item.ZIndex = 8
					item.AutoButtonColor = false
					item.Image = "rbxassetid://108618179346949"
					item.ImageColor3 = themeList.LightContrast
					item.ScaleType = Enum.ScaleType.Slice
					item.SliceCenter = Rect.new(4, 4, 336, 26)

					itemTitle.Name = "Title"
					itemTitle.Parent = item
					itemTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					itemTitle.BackgroundTransparency = 1.000
					itemTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					itemTitle.BorderSizePixel = 0
					itemTitle.Size = UDim2.new(1, 0, 1, 0)
					itemTitle.ZIndex = 9
					itemTitle.Font = Enum.Font.Gotham
					itemTitle.Text = itemName
					itemTitle.TextColor3 = themeList.TextColor
					itemTitle.TextSize = 12.000
					
					local itemtext = itemTitle
					
					item.MouseButton1Click:Connect(function()
						
						dropTitle.Text = itemName
						
						local clone = item:Clone()

						callback(itemName)

						clone.AnchorPoint = Vector2.new(0.5, 0.5)
						clone.Size = clone.Size - UDim2.new(1, -66, 0, 26)
						clone.Position = UDim2.new(0.5, 0, 0.5, 0)

						clone.Parent = item
						clone:ClearAllChildren()

						item.ImageTransparency = 1
						Utility:TweenObject(clone, {Size = item.Size}, 0.2)

						spawn(function()
							wait(0.2)

							item.ImageTransparency = 0
							clone:Destroy()
						end)

						itemtext.TextSize = 0
						Utility:TweenObject(item.Title, {TextSize = 14}, 0.2)

						wait(0.2)
						Utility:TweenObject(Dropdown, {Size = UDim2.new(1, -20, 0, 30)}, 0.2)
						dropped = false
						
						Utility:TweenObject(item.Title, {TextSize = 12}, 0.2)
						
					end)
					
					coroutine.wrap(function()
						while wait() do
							item.ImageColor3 = themeList.LightContrast
							itemTitle.TextColor3 = themeList.TextColor
						end
					end)()
					
				end
				return DropFunction
			end
			
			return Elements
		end
		return Sections
	end
	return Tabs
end

return UI
