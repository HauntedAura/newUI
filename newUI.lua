-- init
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- services
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new

-- additional
local utility = {}

-- themes
local objects = {}
local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),
	TextColor = Color3.fromRGB(255, 255, 255)
}

do
	function utility:Create(instance, properties, children)
		local object = Instance.new(instance)

		for i, v in pairs(properties or {}) do
			object[i] = v

			if typeof(v) == "Color3" then -- save for theme changer later
				local theme = utility:Find(themes, v)

				if theme then
					objects[theme] = objects[theme] or {}
					objects[theme][i] = objects[theme][i] or setmetatable({}, {_mode = "k"})

					objects[theme][i][#objects[theme][i] + 1] = object
				end
			end
		end

		for i, module in pairs(children or {}) do
			module.Parent = object
		end

		return object
	end

	function utility:Tween(instance, properties, duration, ...)
		tween:Create(instance, tweeninfo(duration, ...), properties):Play()
	end

	function utility:Wait()
		run.RenderStepped:Wait()
		return true
	end

	function utility:Find(table, value) -- table.find doesn't work for dictionaries
		for i, v in  pairs(table) do
			if v == value then
				return i
			end
		end
	end

	function utility:Sort(pattern, values)
		local new = {}
		pattern = pattern:lower()

		if pattern == "" then
			return values
		end

		for i, value in pairs(values) do
			if tostring(value):lower():find(pattern) then
				new[#new + 1] = value
			end
		end

		return new
	end

	function utility:Pop(object, shrink)
		local clone = object:Clone()

		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Size = clone.Size - UDim2.new(0, shrink, 0, shrink)
		clone.Position = UDim2.new(0.5, 0, 0.5, 0)

		clone.Parent = object
		clone:ClearAllChildren()

		object.ImageTransparency = 1
		utility:Tween(clone, {Size = object.Size}, 0.2)

		coroutine.wrap(function()
			wait(0.2)

			object.ImageTransparency = 0
			clone:Destroy()
		end)()

		return clone
	end

	function utility:InitializeKeybind()
		self.keybinds = {}
		self.ended = {}

		input.InputBegan:Connect(function(key, gameProcessedEvent)
			if self.keybinds[key.KeyCode] then
				for i, bind in pairs(self.keybinds[key.KeyCode]) do
					if (bind.gameProcessedEvent == gameProcessedEvent) then
						bind.callback()
					end
				end
			end
		end)

		input.InputEnded:Connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				for i, callback in pairs(self.ended) do
					callback()
				end
			end
		end)
	end

	function utility:BindToKey(key, callback, gameProcessedEvent)

		self.keybinds[key] = self.keybinds[key] or {}

		table.insert(self.keybinds[key], {callback = callback, gameProcessedEvent = gameProcessedEvent or false})

		return {
			UnBind = function()
				for i, keybindData in pairs(self.keybinds[key]) do
					if keybindData.callback == callback then
						table.remove(self.keybinds[key], i)
					end
				end
			end
		}
	end

	function utility:KeyPressed() -- yield until next key is pressed
		local key = input.InputBegan:Wait()

		while key.UserInputType ~= Enum.UserInputType.Keyboard	 do
			key = input.InputBegan:Wait()
		end

		wait() -- overlapping connection

		return key
	end

	function utility:DraggingEnabled(frame, parent)

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

	function utility:DraggingEnded(callback)
		self.ended[#self.ended + 1] = callback
	end

end

-- classes

local library = {}
local tab = {}
local section = {}

library.__index = library
tab.__index = tab
section.__index = section

function library.new(data)
	
	local title = data.title or "flxzzr"
	
	local container = utility:Create("ScreenGui", {
		Name = title,
		Parent = player:WaitForChild("PlayerGui")
	}, {
		utility:Create("ImageLabel", {
			Name = "Main",
			Position = UDim2.new(0.25, 0, 0.052435593, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 500, 0, 407),
			Image = "rbxassetid://107571530410271",
			ImageColor3 = themes.Background,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 296, 296),
		}, {
			utility:Create("ImageLabel", {
				Name = "Glow",
				ZIndex = 0,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -10, 0, -10),
				Size = UDim2.new(1, 20, 1, 20),
				Image = "rbxassetid://84674677057008",
				ImageColor3 = themes.Glow,
			}),
			
			utility:Create("ImageLabel", {
				Name = "Tabs",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 38),
				Size = UDim2.new(0, 126, 1, -38),
				Image = "rbxassetid://96173951457280",
				ImageColor3 = themes.DarkContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 296, 296),
			}, {
				utility:Create("ScrollingFrame", {
					Name = "Tabs_Container",
					Active = true,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 10),
					Size = UDim2.new(1, 0, 1, -20),
					CanvasSize = UDim2.new(0, 0, 0, 314),
					ScrollBarThickness = 0,
				}, {
					utility:Create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10),
					})
				})
			}),
			
			utility:Create("ImageLabel", {
				Name = "TopBar",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
				Image = "rbxassetid://136855631686492",
				ImageColor3 = themes.Accent,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 296, 296),
			}, {
				utility:Create("TextLabel", {
					Name = "Title",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 19),
					Size = UDim2.new(1, -46, 0, 16),
					Font = Enum.Font.GothamBold,
					Text = title,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
				})
			})
			
		})
	})
	
	utility:InitializeKeybind()
	utility:DraggingEnabled(container.Main.TopBar, container.Main)

	return setmetatable({
		container = container,
		tabsContainer = container.Main.Tabs.Tabs_Container,
		tabs = {}
	}, library)
	
end

function library.setTitle(library, title)
	local container = library.container
	container.Name = title
	container.Main.TopBar.Title.Text = title
end

function tab.new(library, title, icon)
	local button = utility:Create("TextButton", {
		Name = title,
		Parent = library.tabsContainer,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 26),
		ZIndex = 3,
		AutoButtonColor = false,
		Font = Enum.Font.Gotham,
		Text = "",
		TextColor3 = themes.TextColor,
		TextSize = 14,
	}, {
		utility:Create("TextLabel", {
			Name = "Title",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 40, 0.5, 0),
			Size = UDim2.new(0, 76, 1, 0),
			ZIndex = 3,
			Font = Enum.Font.Gotham,
			Text = title,
			TextColor3 = themes.TextColor,
			TextSize = 12,
			TextTransparency = 0.65,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		icon and utility:Create("ImageLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "http://www.roblox.com/asset/?id=" .. tostring(icon),
			ImageColor3 = themes.TextColor,
			ImageTransparency = 0.65,
		}) or {}
	})
	
	local container = utility:Create("ScrollingFrame", {
		Name = "Tab",
		Parent = library.container.Main,
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 134, 0, 46),
		Size = UDim2.new(1, -142, 1, -54),
		CanvasSize = UDim2.new(0, 0, 0, 466),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = themes.DarkContrast,
		Visible = false,
	}, {
		utility:Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
		})
	})
	
	return setmetatable({
		library = library,
		container = container,
		button = button,
		sections = {}
	}, tab)
end

function section.new(tab, title)
	
	local container = utility:Create("ImageLabel", {
		Name = title,
		Parent = tab.container,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -10, 0, 28),
		Image = "rbxassetid://76828361147692",
		ImageColor3 = Color3.fromRGB(20, 20, 20),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(4, 4, 296, 296),
		ClipsDescendants = true,
		ZIndex = 2,
	}, {
		utility:Create("Frame", {
			Name = "Container",
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 8, 0, 8),
			Size = UDim2.new(1, -16, 1, -16),
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 20),
				ZIndex = 2,
				Font = Enum.Font.GothamSemibold,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			utility:Create("UIPadding", {
				PaddingLeft = UDim.new(0, 4)
			})
		}),
	})
	
	return setmetatable({
		tab = tab,
		container = container.Container,
		colorpickers = {},
		modules = {},
		binds = {},
		lists = {},
	}, section)
end

function library:addTab(data)
	local title = data.title or "Tab"
	local icon = data.icon

	local newTab = tab.new(self, title, icon)
	local button = newTab.button

	table.insert(self.tabs, newTab)
	self:reorderTabButtons()

	button.MouseButton1Click:Connect(function()
		self:SelectTab({
			tab = newTab,
			toggle = true
		})
	end)

	return newTab
end


function tab:setOrderPos(newPos)
	local libraryTab = self.library.tabs

	if (newPos > #libraryTab) then
		return error("newPos exceeds number of tabs available")
	end

	local foundi = table.find(libraryTab, self)
	if (foundi) then
		table.remove(libraryTab, foundi)
	end

	table.insert(libraryTab, newPos, self)

	self.library:reorderTabButtons()
end

function tab:addSection(data)
	local title = data.title or "Section"

	local newSection = section.new(self, title)

	self.sections[#self.sections + 1] = newSection

	return newSection
end

function library:reorderTabButtons()
	for i, tab in ipairs(self.tabs) do
		tab.button.LayoutOrder = i
	end
end

function library:setTheme(data)
	local theme = data.theme
	local color3 = data.color3

	themes[theme] = color3

	for property, objectss in pairs(objects[theme]) do
		for i, object in pairs(objectss) do
			if not object.Parent or (object.Name == "Button" and object.Parent.Name == "ColorPicker") then
				objectss[i] = nil -- i can do this because weak tables :D
			else
				object[property] = color3
			end
		end
	end
end

function library:toggle()

	if self.toggling then
		return
	end

	self.toggling = true

	local container = self.container.Main
	local topbar = container.TopBar

	if self.position then
		utility:Tween(container, {
			Size = UDim2.new(0, 500, 0, 428),
			Position = self.position
		}, 0.2)
		wait(0.2)

		utility:Tween(topbar, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
		wait(0.2)

		container.ClipsDescendants = false
		self.position = nil
	else
		self.position = container.Position
		container.ClipsDescendants = true

		utility:Tween(topbar, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)
		wait(0.2)

		utility:Tween(container, {
			Size = UDim2.new(0, 500, 0, 0),
			Position = self.position + UDim2.new(0, 0, 0, 428)
		}, 0.2)
		wait(0.2)
	end

	self.toggling = false
end

function library:SelectTab(data)
	local selectedTab = data.tab
	local toggle = data.toggle

	if toggle and self.focusedtab == tab then -- already selected
		return
	end

	local button = selectedTab.button

	if toggle then
		-- tab button
		button.Title.TextTransparency = 0
		button.Title.Font = Enum.Font.GothamSemibold

		if button:FindFirstChild("Icon") then
			button.Icon.ImageTransparency = 0
		end

		-- update selected tab
		local focusedtab = self.focusedtab
		self.focusedtab = selectedTab

		if focusedtab then
			self:SelectTab({
				tab = focusedtab
			})
		end

		-- sections
		local existingSections = focusedtab and #focusedtab.sections or 0
		local sectionsRequired = #selectedTab.sections - existingSections

		selectedTab:Resize()

		for i = 1, #selectedTab.sections do
			local tabSection = selectedTab.sections[i]
			tabSection.container.Parent.ImageTransparency = 0
		end
		if sectionsRequired < 0 then -- "hides" some sections
			for i = existingSections, #selectedTab.sections + 1, -1 do
				local tabSection = focusedtab.sections[i].container.Parent

				utility:Tween(tabSection, {ImageTransparency = 1}, 0.1)
			end
		end

		wait(0.1)
		selectedTab.container.Visible = true

		if focusedtab then
			focusedtab.container.Visible = false
		end

		if sectionsRequired > 0 then -- "creates" more section
			for i = existingSections + 1, #selectedTab.sections do
				local tabSection = selectedTab.sections[i].container.Parent

				tabSection.ImageTransparency = 1
				utility:Tween(tabSection, {ImageTransparency = 0}, 0.05)
			end
		end

		wait(0.05)

		for i = 1, #selectedTab.sections do
			local tabSection = selectedTab.sections[i]
			utility:Tween(tabSection.container.Title, {TextTransparency = 0}, 0.1)
			tabSection:Resize(true)

			wait(0.05)
		end

		wait(0.05)
		selectedTab:Resize(true)
	else
		-- tab button
		button.Title.Font = Enum.Font.Gotham
		button.Title.TextTransparency = 0.65

		if button:FindFirstChild("Icon") then
			button.Icon.ImageTransparency = 0.65
		end

		-- sections
		for i = 1, #selectedTab.sections do
			local tabSection = selectedTab.sections[i]
			utility:Tween(tabSection.container.Parent, {Size = UDim2.new(1, -10, 0, 28)}, 0.1)
			utility:Tween(tabSection.container.Title, {TextTransparency = 1}, 0.1)
		end

		wait(0.1)

		selectedTab.lastPosition = selectedTab.container.CanvasPosition.Y
		selectedTab:Resize()
	end
end

function tab:Resize(scroll)
	local padding = 10
	local size = 0

	for i = 1, #self.sections do
		local tabSection = self.sections[i]
		size = size + tabSection.container.Parent.AbsoluteSize.Y + padding
	end

	self.container.CanvasSize = UDim2.new(0, 0, 0, size)
	self.container.ScrollBarImageTransparency = size > self.container.AbsoluteSize.Y

	if scroll then
		utility:Tween(self.container, {CanvasPosition = Vector2.new(0, self.lastPosition or 0)}, 0.2)
	end
end

function section:Resize(smooth)

	if self.tab.library.focusedtab ~= self.tab then
		return
	end

	local padding = 4
	local size = (4 * padding) + self.container.Title.AbsoluteSize.Y -- offset

	for i, module in pairs(self.modules) do
		size = size + module.Instance.AbsoluteSize.Y + padding
	end

	if smooth then
		utility:Tween(self.container.Parent, {Size = UDim2.new(1, -10, 0, size)}, 0.05)
	else
		self.container.Parent.Size = UDim2.new(1, -10, 0, size)
		self.tab:Resize()
	end
end

return library
