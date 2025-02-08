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

library.__index = library
tab.__index = tab

function library.new(data)

	local title = data.title or "flxzzr"

	local container = {
		utility:Create("ScreenGui", {
			Name = title,
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			Parent = run:IsStudio() and player:WaitForChild("PlayerGui") or CoreGui
		}, {
			utility:Create("Frame", {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.Background,
				Size = UDim2.new(0, 500, 0, 407),
				Position = UDim2.new(0.35294, 0, 0.75, 0),
				BorderColor3 = themes.Background,
				Name = "BG",
			}, {
				utility:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),

				utility:Create("Frame", {
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.DarkContrast,
					Size = UDim2.new(0, 150, 1, -30),
					Position = UDim2.new(0, 0, 0, 30),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "SB",
				}, {

					utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 4),

					}),

					utility:Create("Frame", {
						ZIndex = 3,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.DarkContrast,
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0.5, 0, 1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Name = "SB_EXTENSION",
					})

				}),

				utility:Create("Frame", {
					ZIndex = 4,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(1, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "Navigation",
					BackgroundTransparency = 1,
				}, {
					utility:Create("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					utility:Create("UIPadding", {
						PaddingTop = UDim.new(0, 8),
						PaddingLeft = UDim.new(0, 35),
					})
				}),

				utility:Create("Frame", {
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.Accent,
					Size = UDim2.new(1, 0, 0.075, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "TB",
				}, {
					utility:Create("UICorner", {
						CornerRadius = UDim.new(0, 4),
					}),
					utility:Create("Frame", {
						ZIndex = 5,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.Accent,
						AnchorPoint = Vector2.new(0, 1),
						Size = UDim2.new(1, 0, 0.5, 0),
						Position = UDim2.new(0, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Name = "TB_EXTENSION",
					}),
					utility:Create("TextLabel", {
						ZIndex = 6,
						BorderSizePixel = 0,
						TextSize = 14,
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
						TextColor3 = themes.TextColor,
						BackgroundTransparency = 1,
						Size = UDim2.new(0.5, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = title,
						Name = "TITLE",
					}, {
						utility:Create("UITextSizeConstraint", {
							MaxTextSize = 14,
						}),
						utility:Create("UIPadding", {
							PaddingLeft = UDim.new(0, 8),
						})
					})
				}),
				utility:Create("ImageLabel", {
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = themes.Glow,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = "rbxassetid://79305839788405",
					Size = UDim2.new(1.25, 0, 1.25, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Name = "Glow",
					Position = UDim2.new(0.5, 0, 0.5, 0),
				}),
				utility:Create("Frame", {
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(1, -166, 1, -46),
					Position = UDim2.new(0, 158, 0, 38),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "CO",
					BackgroundTransparency = 1,
				})
			})
		})
	}
end

function library.setTitle(library, title)
	local container = library.container
	container.Name = title
	container.Main.TopBar.Title.Text = title
end

function tab.new(library, title, icon)

	local button = {
		utility:Create("TextButton", {
			Name = title,
			Parent = library.Navigation,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 3,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
			TextSize = 14
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 40, 0.5, 0),
				Size = UDim2.new(0, 56, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.65,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			icon and utility:Create("ImageLabel", {
				ZIndex = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "http://www.roblox.com/asset/?id=" .. tostring(icon),
				ImageTransparency = 0.75,
				Size = UDim2.new(0, 16, 0, 16),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Name = "ICON",
				Position = UDim2.new(0, -8, 0.5, 0),
			}) or {}
		})
	}
	
	local container = {
		utility:Create("ScrollingFrame", {
			ZIndex = 3,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Name = title,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarImageColor3 = themes.DarkContrast,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 1,
			BackgroundTransparency = 1,
			Visible = false,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		}, {
			utility:Create("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				Padding = UDim.new(0, 8);
				SortOrder = Enum.SortOrder.LayoutOrder;
			})
		})
	}
	
	return setmetatable({
		library = library,
		container = container,
		button = button,
		sections = {}
	}, tab)

end

function library:setTheme(data)
	local theme = data.theme
	local color3 = data.color3

	themes[theme] = color3

	for property, objectss in pairs(objects[theme]) do
		for i, object in pairs(objectss) do
			if not object.Parent or (object.Name == "Button" and object.Parent.Name == "ColorPicker") then
				objectss[i] = nil
			else
				object[property] = color3
			end
		end
	end
end

function library:addTab(data)
	local title = data.title or "Page"
	local icon = data.icon

	local newTab = tab.new(self, title, icon)
	local button = newTab.button

	table.insert(self.tabs, newTab)
	self:reorderPageButtons()

	button.MouseButton1Click:Connect(function()
		self:SelectPage({
			page = newTab,
			toggle = true
		})
	end)

	return newTab
end

return library
