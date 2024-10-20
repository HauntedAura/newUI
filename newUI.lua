local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local Library = {}

Themelist = {
	Light = {
		Main = Color3.fromRGB(255, 255, 255),
		MainText = Color3.fromRGB(100, 100, 100),
		SecondaryText = Color3.fromRGB(130, 130, 130),
		Images = Color3.fromRGB(100, 100, 100),
		Tabs = Color3.fromRGB(0, 0, 0),
		Dropdown = Color3.fromRGB(175, 175, 175),
		Other = Color3.fromRGB(20, 20, 20)
	};
	Dark = {
		Main = Color3.fromRGB(20, 20, 20),
		MainText = Color3.fromRGB(255, 255, 255),
		SecondaryText = Color3.fromRGB(200, 200, 200),
		Images = Color3.fromRGB(255, 255, 255),
		Tabs = Color3.fromRGB(255, 255, 255),
		Dropdown = Color3.fromRGB(36, 36, 36),
		Other = Color3.fromRGB(255, 255, 255)
	}
}

function Library:changeTheme(parent, theme)
	for i, ui in pairs(parent:GetDescendants()) do
		if ui:IsA("ImageLabel") and ui.Name == "main" then
			ui.ImageColor3 = theme.Main
		elseif ui:IsA("ImageLabel") and ui.Name ~= "main" and ui.Name ~="selected" and ui.Name ~= "slider" then
			ui.ImageColor3 = theme.Images
		end
		
		if ui:IsA("TextLabel") and ui.FontFace == Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal) then
			ui.TextColor3 = theme.MainText
		elseif ui:IsA("TextLabel") and Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal) then
			ui.TextColor3 = theme.SecondaryText
		end
		
		if ui:IsA("Frame") or ui:IsA("TextLabel") then
			if ui.Name ~= "sliderback" and ui.Name ~= "selections" and ui.Name ~= "UIStroke" and ui.Name ~= "selected" then
				ui.BackgroundColor3 = theme.Tabs
			elseif ui.Name == "sliderback" then
				print(ui.Name)
				ui.BackgroundColor3 = theme.Other
			elseif ui:IsA("Frame") and ui.Name == "selections" then
				print(ui.Name)
				ui.BackgroundColor3 = theme.Dropdown
			elseif ui.Name == "UIStroke" then
				ui.Color = theme.Other
			end
		end
		
	end
end

local selectedTheme = Themelist.Dark

function Library:DraggingEnabled(frame, parent)

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

	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end


function Library:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:CreateLib()
	local GUI = {
		CurrentTab = nil,
		closeMouseDown = false,
		closeHover = false,
		minimizeMouseDown = false,
		minimizeHover = false,
		hidden = false
	}

	GUI["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
	GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
	GUI["1"]["Name"] = [[Arsonist V1]]
	GUI["1"]["ResetOnSpawn"] = false
	GUI["1"]["IgnoreGuiInset"] = true
	
	GUI["2"] = Instance.new("Frame", GUI["1"]);
	GUI["2"]["BorderSizePixel"] = 0;
	GUI["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["2"]["BackgroundTransparency"] = 0.99;
	GUI["2"]["Size"] = UDim2.new(0, 624, 0, 45);
	GUI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["2"]["Name"] = [[topbar]];
	GUI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
	GUI["2"]["Position"] = UDim2.new(0.5, 0, 0.2, 0);

	GUI["3"] = Instance.new("ImageLabel", GUI["2"]);
	GUI["3"]["BorderSizePixel"] = 0;
	GUI["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["3"]["AnchorPoint"] = Vector2.new(1, 0);
	GUI["3"]["Image"] = [[rbxassetid://128416204137894]];
	GUI["3"]["Size"] = UDim2.new(0, 624, 0, 559);
	GUI["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["3"]["BackgroundTransparency"] = 1;
	GUI["3"]["ImageTransparency"] = 0.5;
	GUI["3"]["ImageColor3"] = selectedTheme.Main;
	GUI["3"]["Position"] = UDim2.new(1, 0, 0, 0);
	GUI["3"]["Name"] = [[main]];

	GUI["4"] = Instance.new("Frame", GUI["3"]);
	GUI["4"]["BorderSizePixel"] = 0;
	GUI["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["4"]["AnchorPoint"] = Vector2.new(0.5, 0);
	GUI["4"]["BackgroundTransparency"] = 0.8999999761581421;
	GUI["4"]["Size"] = UDim2.new(1, -2, 0, 1);
	GUI["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["4"]["Position"] = UDim2.new(0.5, 0, 0, 45);
	GUI["4"]["Name"] = [[line]];

	GUI["5"] = Instance.new("TextLabel", GUI["3"]);
	GUI["5"]["BorderSizePixel"] = 0;
	GUI["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["5"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	GUI["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
	GUI["5"]["TextSize"] = 14;
	GUI["5"]["TextColor3"] = selectedTheme.MainText;
	GUI["5"]["Size"] = UDim2.new(0, 200, 0, 44);
	GUI["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["5"]["Text"] = [[flxzzr hub | Arsonist v1]];
	GUI["5"]["Name"] = [[title]];
	GUI["5"]["BackgroundTransparency"] = 1;
	GUI["5"]["Position"] = UDim2.new(0, 10, 0, 0);

	GUI["6"] = Instance.new("ImageLabel", GUI["3"]);
	GUI["6"]["BorderSizePixel"] = 0;
	GUI["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["6"]["AnchorPoint"] = Vector2.new(1, 0.5);
	GUI["6"]["Image"] = [[rbxassetid://140025424115400]];
	GUI["6"]["ImageColor3"] = selectedTheme.Images;
	GUI["6"]["Size"] = UDim2.new(0, 20, 0, 20);
	GUI["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["6"]["Name"] = [[minimize]];
	GUI["6"]["BackgroundTransparency"] = 1;
	GUI["6"]["Position"] = UDim2.new(1, -44, 0, 22);

	GUI["7"] = Instance.new("ImageLabel", GUI["3"]);
	GUI["7"]["BorderSizePixel"] = 0;
	GUI["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["7"]["AnchorPoint"] = Vector2.new(1, 0.5);
	GUI["7"]["Image"] = [[rbxassetid://109054904309151]];
	GUI["7"]["Size"] = UDim2.new(0, 24, 0, 24);
	GUI["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["7"]["Name"] = [[close]];
	GUI["7"]["BackgroundTransparency"] = 1;
	GUI["7"]["Position"] = UDim2.new(1, -10, 0, 22);
	GUI["7"]["ImageColor3"] = selectedTheme.Images;

	GUI["8"] = Instance.new("Frame", GUI["3"]);
	GUI["8"]["BorderSizePixel"] = 0;
	GUI["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["8"]["AnchorPoint"] = Vector2.new(0, 1);
	GUI["8"]["BackgroundTransparency"] = 1;
	GUI["8"]["Size"] = UDim2.new(0.30000001192092896, 0, 1, -55);
	GUI["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["8"]["Position"] = UDim2.new(0, 0, 1, 0);
	GUI["8"]["Name"] = [[navigation]];
	
	GUI["f"] = Instance.new("UIListLayout", GUI["8"]);
	GUI["f"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
	GUI["f"]["Padding"] = UDim.new(0, 10);
	GUI["f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
	
	-- StarterTab.ScreenTab.ImageLabel.container
	GUI["22"] = Instance.new("Frame", GUI["3"]);
	GUI["22"]["BorderSizePixel"] = 0;
	GUI["22"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["22"]["AnchorPoint"] = Vector2.new(0, 1);
	GUI["22"]["BackgroundTransparency"] = 1;
	GUI["22"]["Size"] = UDim2.new(1, -217, 1, -65);
	GUI["22"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["22"]["Position"] = UDim2.new(0, 207, 1, -10);
	GUI["22"]["Name"] = [[container]];
	
	Library.DraggingEnabled(GUI["2"], GUI["2"])

	GUI["7"].MouseEnter:Connect(function()
		GUI.closeHover = true
	end)

	GUI["6"].MouseEnter:Connect(function()
		GUI.minimizeHover = true
	end)

	GUI["7"].MouseLeave:Connect(function()
		GUI.closeHover = false
	end)

	GUI["6"].MouseLeave:Connect(function()
		GUI.minimizeHover = false
	end)

	uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 and GUI.closeHover then
			Library:notify(5, "UI CLOSED", "Thank you for using flxzzr hub.")
		end
	end)

	uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 and GUI.minimizeHover then
			GUI["2"]["Visible"] = false
			GUI.hidden = true
		end
	end)

	uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		if input.KeyCode == Enum.KeyCode.RightShift and GUI.hidden then
			GUI["2"]["Visible"] = true
			GUI.hidden = false
		end
	end)

	function GUI:CreateTab(Name, Icon)
		local Tab = {
			Hover = false,
			Active = false
		}
		
		if GUI.CurrentTab == nil then
			GUI.CurrentTab = Tab

		end

		Tab["9"] = Instance.new("TextLabel", GUI["8"]);
		Tab["9"]["BorderSizePixel"] = 0;
		Tab["9"]["BackgroundColor3"] = selectedTheme.Tabs;
		Tab["9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		Tab["9"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
		Tab["9"]["TextSize"] = 14;
		Tab["9"]["TextColor3"] = selectedTheme.MainText;
		Tab["9"]["AnchorPoint"] = Vector2.new(1, 0);
		Tab["9"]["Size"] = UDim2.new(0.8999999761581421, 0, 0, 40);
		Tab["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["9"]["Text"] = Name;
		Tab["9"]["Name"] = Name;
		Tab["9"]["BackgroundTransparency"] = 1;
		Tab["9"]["Position"] = UDim2.new(1, 0, 0, 0);

		-- StarterTab.ScreenTab.ImageLabel.navigation.tab.UICorner
		Tab["a"] = Instance.new("UICorner", Tab["9"]);
		Tab["a"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

		-- StarterTab.ScreenTab.ImageLabel.navigation.tab.UIPadding
		Tab["b"] = Instance.new("UIPadding", Tab["9"]);
		Tab["b"]["PaddingLeft"] = UDim.new(0, 36);

		-- StarterTab.ScreenTab.ImageLabel.navigation.tab.icon
		Tab["c"] = Instance.new("ImageLabel", Tab["9"]);
		Tab["c"]["BorderSizePixel"] = 0;
		Tab["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Tab["c"]["AnchorPoint"] = Vector2.new(0, 0.5);
		Tab["c"]["Image"] = Icon;
		Tab["c"]["Size"] = UDim2.new(0, 24, 0, 24);
		Tab["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["c"]["ImageColor3"] = selectedTheme.Images;
		Tab["c"]["Name"] = [[icon]];
		Tab["c"]["BackgroundTransparency"] = 1;
		Tab["c"]["Position"] = UDim2.new(0, -28, 0.5, 0);

		-- StarterTab.ScreenTab.ImageLabel.navigation.tab.selected
		Tab["d"] = Instance.new("Frame", Tab["9"]);
		Tab["d"]["BorderSizePixel"] = 0;
		Tab["d"]["BackgroundColor3"] = Color3.fromRGB(63, 124, 255);
		Tab["d"]["AnchorPoint"] = Vector2.new(0, 0.5);
		Tab["d"]["Size"] = UDim2.new(0, 4, 0.5, 0);
		Tab["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["d"]["Position"] = UDim2.new(0, -36, 0.5, 0);
		Tab["d"]["Name"] = [[selected]];
		Tab["d"]["BackgroundTransparency"] = 1

		-- StarterTab.ScreenTab.ImageLabel.navigation.tab.selected.UICorner
		Tab["e"] = Instance.new("UICorner", Tab["d"]);
		Tab["e"]["CornerRadius"] = UDim.new(1, 0);

		-- StarterTab.ScreenTab.ImageLabel.container.Player
		Tab["23"] = Instance.new("Frame", GUI["22"]);
		Tab["23"]["BorderSizePixel"] = 0;
		Tab["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Tab["23"]["BackgroundTransparency"] = 1;
		Tab["23"]["Size"] = UDim2.new(1, 0, 1, 0);
		Tab["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["23"]["Name"] = Name;
		Tab["23"]["Visible"] = false

		-- StarterTab.ScreenTab.ImageLabel.container.Player.title
		Tab["24"] = Instance.new("TextLabel", Tab["23"]);
		Tab["24"]["TextWrapped"] = true;
		Tab["24"]["BorderSizePixel"] = 0;
		Tab["24"]["TextScaled"] = true;
		Tab["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Tab["24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		Tab["24"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
		Tab["24"]["TextSize"] = 14;
		Tab["24"]["TextColor3"] = selectedTheme.MainText;
		Tab["24"]["Size"] = UDim2.new(0.5, 0, 0.05000000074505806, 0);
		Tab["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["24"]["Text"] = Name;
		Tab["24"]["Name"] = [[title]];
		Tab["24"]["BackgroundTransparency"] = 1;

		-- StarterTab.ScreenTab.ImageLabel.container.Player.ScrollingFrame
		Tab["25"] = Instance.new("ScrollingFrame", Tab["23"]);
		Tab["25"]["Active"] = false;
		Tab["25"]["BorderSizePixel"] = 0;
		Tab["25"]["ScrollBarImageTransparency"] = 0.8999999761581421;
		Tab["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Tab["25"]["BackgroundTransparency"] = 1;
		Tab["25"]["Size"] = UDim2.new(1, 0, 1, -34);
		Tab["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Tab["25"]["ScrollBarThickness"] = 4;
		Tab["25"]["Position"] = UDim2.new(0, 0, 0, 34);
		Tab["25"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
		Tab["25"]["CanvasSize"] = UDim2.new(0, 0, 0.9, 0)
		Tab["25"]["Selectable"] = false

		-- StarterTab.ScreenTab.ImageLabel.container.Player.ScrollingFrame.UIListLayout
		Tab["26"] = Instance.new("UIListLayout", Tab["25"]);
		Tab["26"]["Padding"] = UDim.new(0, 5);
		Tab["26"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
		
		Tab["27"] = Instance.new("UIPadding", Tab["25"]);
		Tab["27"]["PaddingLeft"] = UDim.new(0, 1);
		
		Tab["9"].MouseEnter:Connect(function()
			Tab.Hover = true
			
			if not Tab.Active then
				Library:tween(Tab["9"], {BackgroundTransparency = 0.95}) 
			end
		end)

		Tab["9"].MouseLeave:Connect(function()
			Tab.Hover = false
			
			if not Tab.Active then
				Library:tween(Tab["9"], {BackgroundTransparency = 1}) 
			end
		end)

		uis.InputBegan:Connect(function(input, gpe)
			if gpe then return end

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Tab.Hover then
					Tab:Activate()

				end
			end
		end)
		
		function Tab:Activate()
			if not Tab.Active then
				if GUI.CurrentTab ~= nil then
					GUI.CurrentTab:Deactivate()
				end
				Tab.Active = true

				Library:tween(Tab["9"], {BackgroundTransparency = 0.95}) 
				Library:tween(Tab["d"], {BackgroundTransparency = 0})
				
				Tab["23"]["Visible"] = true

				GUI.CurrentTab = Tab
			end
		end

		function Tab:Deactivate()
			if Tab.Active then
				Tab.Active = false

				Tab["9"]["BackgroundTransparency"] = 1
				Tab["d"]["BackgroundTransparency"] = 1
				
				Tab["23"]["Visible"] = false

				Tab.Hover = false
			end


		end
		
		if GUI.CurrentTab == Tab then
			Tab:Activate()
		end
		
		function Tab:CreateSection(name)
			
			local Section = {}
			
			Section["27"] = Instance.new("TextLabel", Tab["25"]);
			Section["27"]["TextWrapped"] = true;
			Section["27"]["BorderSizePixel"] = 0;
			Section["27"]["TextScaled"] = true;
			Section["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Section["27"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Section["27"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
			Section["27"]["TextSize"] = 14;
			Section["27"]["TextColor3"] = selectedTheme.MainText;
			Section["27"]["Size"] = UDim2.new(0, 203, 0, 19);
			Section["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Section["27"]["Text"] = name;
			Section["27"]["Name"] = name;
			Section["27"]["BackgroundTransparency"] = 1;
			
			return Section
		end

		function Tab:CreateButton(name, desc, callback)
			
			local Button = {
				Hover = false,
				MouseDown = false
			}
			
			-- StarterTab.ScreenTab.ImageLabel.container.Player.ScrollingFrame.button
			Button["28"] = Instance.new("Frame", Tab["25"]);
			Button["28"]["BorderSizePixel"] = 0;
			Button["28"]["BackgroundColor3"] = selectedTheme.Tabs;
			Button["28"]["BackgroundTransparency"] = 0.95;
			Button["28"]["Size"] = UDim2.new(0, 386, 0, 59);
			Button["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["28"]["Name"] = name;

			-- StarterButton.ScreenButton.ImageLabel.container.Player.ScrollingFrame.button.UICorner
			Button["29"] = Instance.new("UICorner", Button["28"]);
			Button["29"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			-- StarterButton.ScreenButton.ImageLabel.container.Player.ScrollingFrame.button.name
			Button["2a"] = Instance.new("TextLabel", Button["28"]);
			Button["2a"]["BorderSizePixel"] = 0;
			Button["2a"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
			Button["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Button["2a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["2a"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Button["2a"]["TextSize"] = 14;
			Button["2a"]["TextColor3"] = selectedTheme.MainText;
			Button["2a"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Button["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["2a"]["Text"] = name;
			Button["2a"]["Name"] = [[name]];
			Button["2a"]["BackgroundTransparency"] = 1;
			Button["2a"]["Position"] = UDim2.new(0, 7, 0, 0);

			-- StarterButton.ScreenButton.ImageLabel.container.Player.ScrollingFrame.button.desc
			Button["2b"] = Instance.new("TextLabel", Button["28"]);
			Button["2b"]["TextWrapped"] = true;
			Button["2b"]["BorderSizePixel"] = 0;
			Button["2b"]["TextYAlignment"] = Enum.TextYAlignment.Top;
			Button["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Button["2b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["2b"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Button["2b"]["TextSize"] = 12;
			Button["2b"]["TextColor3"] = selectedTheme.SecondaryText;
			Button["2b"]["AnchorPoint"] = Vector2.new(0, 1);
			Button["2b"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Button["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["2b"]["Text"] = desc;
			Button["2b"]["Name"] = [[desc]];
			Button["2b"]["BackgroundTransparency"] = 1;
			Button["2b"]["Position"] = UDim2.new(0, 7, 1, 0);

			-- StarterButton.ScreenButton.ImageLabel.container.Player.ScrollingFrame.button.icon
			Button["2c"] = Instance.new("ImageLabel", Button["28"]);
			Button["2c"]["BorderSizePixel"] = 0;
			Button["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Button["2c"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Button["2c"]["Image"] = [[rbxassetid://78806396278850]];
			Button["2c"]["Size"] = UDim2.new(0, 24, 0, 24);
			Button["2c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["2c"]["Name"] = [[icon]];
			Button["2c"]["BackgroundTransparency"] = 1;
			Button["2c"]["Position"] = UDim2.new(1, -10, 0.5, 0);
			Button["2c"]["ImageColor3"] = selectedTheme.Images;
			
			Button["28"].MouseEnter:Connect(function()
				Button.Hover = true

				if not Button.MouseDown then
					Library:tween(Button["28"], {BackgroundTransparency = 0.9})
				end
			end)

			Button["28"].MouseLeave:Connect(function()
				Button.Hover = false

				if not Button.MouseDown then
					Library:tween(Button["28"], {BackgroundTransparency = 0.95})
				end
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
					Button.MouseDown = true
						Library:tween(Button["28"], {BackgroundTransparency = 0.95})
						callback()
				end
			end)

			uis.InputEnded:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Button.MouseDown = false
					if Button.Hover then
						Library:tween(Button["28"], {BackgroundTransparency = 0.9})
					else
						Library:tween(Button["28"], {BackgroundTransparency = 0.95})
					end	
				end
			end)
			
			return Button
		end

		function Tab:CreateToggle(name, desc, callback)
			
			local Toggle = {
				MouseDown = false,
				Hover = false,
				State = false
			}
			
			Toggle["3e"] = Instance.new("Frame", Tab["25"]);
			Toggle["3e"]["BorderSizePixel"] = 0;
			Toggle["3e"]["BackgroundColor3"] = selectedTheme.Tabs;
			Toggle["3e"]["BackgroundTransparency"] = 0.949999988079071;
			Toggle["3e"]["Size"] = UDim2.new(0, 386, 0, 59);
			Toggle["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["3e"]["Name"] = name;
			
			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.UICorner
			Toggle["3f"] = Instance.new("UICorner", Toggle["3e"]);
			Toggle["3f"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.name
			Toggle["40"] = Instance.new("TextLabel", Toggle["3e"]);
			Toggle["40"]["BorderSizePixel"] = 0;
			Toggle["40"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
			Toggle["40"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["40"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Toggle["40"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Toggle["40"]["TextSize"] = 14;
			Toggle["40"]["TextColor3"] = selectedTheme.MainText;
			Toggle["40"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Toggle["40"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["40"]["Text"] = name;
			Toggle["40"]["Name"] = [[name]];
			Toggle["40"]["BackgroundTransparency"] = 1;
			Toggle["40"]["Position"] = UDim2.new(0, 7, 0, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.desc
			Toggle["41"] = Instance.new("TextLabel", Toggle["3e"]);
			Toggle["41"]["TextWrapped"] = true;
			Toggle["41"]["BorderSizePixel"] = 0;
			Toggle["41"]["TextYAlignment"] = Enum.TextYAlignment.Top;
			Toggle["41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["41"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Toggle["41"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Toggle["41"]["TextSize"] = 12;
			Toggle["41"]["TextColor3"] = selectedTheme.SecondaryText;
			Toggle["41"]["AnchorPoint"] = Vector2.new(0, 1);
			Toggle["41"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Toggle["41"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["41"]["Text"] = desc;
			Toggle["41"]["Name"] = [[desc]];
			Toggle["41"]["BackgroundTransparency"] = 1;
			Toggle["41"]["Position"] = UDim2.new(0, 7, 1, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.off
			Toggle["42"] = Instance.new("Frame", Toggle["3e"]);
			Toggle["42"]["BorderSizePixel"] = 0;
			Toggle["42"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["42"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Toggle["42"]["BackgroundTransparency"] = 1;
			Toggle["42"]["Size"] = UDim2.new(0, 40, 0, 20);
			Toggle["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["42"]["Position"] = UDim2.new(1, -10, 0.5, 0);
			Toggle["42"]["Name"] = [[off]];

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.off.UICorner
			Toggle["43"] = Instance.new("UICorner", Toggle["42"]);
			Toggle["43"]["CornerRadius"] = UDim.new(1, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.off.UIStroke
			Toggle["44"] = Instance.new("UIStroke", Toggle["42"]);
			Toggle["44"]["Color"] = selectedTheme.Other;
			Toggle["44"]["Thickness"] = 1.5;
			Toggle["44"]["Transparency"] = 0.8999999761581421;

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.off.ImageLabel
			Toggle["45"] = Instance.new("ImageLabel", Toggle["42"]);
			Toggle["45"]["BorderSizePixel"] = 0;
			Toggle["45"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["45"]["ImageTransparency"] = 0.8999999761581421;
			Toggle["45"]["AnchorPoint"] = Vector2.new(0, 0.5);
			Toggle["45"]["Image"] = [[rbxassetid://135315650441805]];
			Toggle["45"]["Size"] = UDim2.new(0, 20, 0, 20);
			Toggle["45"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["45"]["ImageColor3"] = selectedTheme.Images;
			Toggle["45"]["BackgroundTransparency"] = 1;
			Toggle["45"]["Position"] = UDim2.new(0, 0, 0.5, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.on
			Toggle["46"] = Instance.new("Frame", Toggle["3e"]);
			Toggle["46"]["BorderSizePixel"] = 0;
			Toggle["46"]["BackgroundColor3"] = Color3.fromRGB(63, 124, 255);
			Toggle["46"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Toggle["46"]["Size"] = UDim2.new(0, 40, 0, 20);
			Toggle["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["46"]["Position"] = UDim2.new(1, -10, 0.5, 0);
			Toggle["46"]["Visible"] = false;
			Toggle["46"]["Name"] = [[on]];

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.on.UICorner
			Toggle["47"] = Instance.new("UICorner", Toggle["46"]);
			Toggle["47"]["CornerRadius"] = UDim.new(1, 0);

			-- StarterToggle.ScreenToggle.ImageLabel.container.Player.ScrollingFrame.toggle.on.ImageLabel
			Toggle["48"] = Instance.new("ImageLabel", Toggle["46"]);
			Toggle["48"]["BorderSizePixel"] = 0;
			Toggle["48"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Toggle["48"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Toggle["48"]["Image"] = [[rbxassetid://135315650441805]];
			Toggle["48"]["Size"] = UDim2.new(0, 20, 0, 20);
			Toggle["48"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Toggle["48"]["BackgroundTransparency"] = 1;
			Toggle["48"]["Position"] = UDim2.new(1, 0, 0.5, 0);
			
			function Toggle:Toggle(b)
				if b == nil then
					Toggle.State = not Toggle.State 
				else
					Toggle.State = b
				end

				if Toggle.State then
					Toggle["46"]["Visible"] = true
					Toggle["42"]["Visible"] = false
				else
					Toggle["46"]["Visible"] = false
					Toggle["42"]["Visible"] = true
				end

				callback(Toggle.State)
			end
			
			Toggle["3e"].MouseEnter:Connect(function()
				Toggle.Hover = true

				if not Toggle.MouseDown then
					Library:tween(Toggle["3e"], {BackgroundTransparency = 0.9})
				end
			end)

			Toggle["3e"].MouseLeave:Connect(function()
				Toggle.Hover = false

				if not Toggle.MouseDown then
					Library:tween(Toggle["3e"], {BackgroundTransparency = 0.95})
				end
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggle.Hover then
					Toggle.MouseDown = true
					
					Library:tween(Toggle["3e"], {BackgroundTransparency = 0.9})
					Library:tween(Toggle["3e"], {BackgroundTransparency = 0.95})
					
					Toggle:Toggle()
				end
			end)

			uis.InputEnded:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Toggle.MouseDown = false

					if Toggle.Hover then
						Library:tween(Toggle["3e"], {BackgroundTransparency = 0.9})
					else
						Library:tween(Toggle["3e"], {BackgroundTransparency = 0.95})
					end

					if Toggle.Connection then
						Toggle.Connection:Disconnect()
						Toggle.Connection = nil
					end
				end
			end)
			
			return Toggle
			
		end
		
		function Tab:CreateSlider(name, desc, min, max, callback)
			
			local Slider = {
				Hover = false,
				MouseDown = false,
				Connection = nil
			}
			
			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider
			Slider["49"] = Instance.new("Frame", Tab["25"]);
			Slider["49"]["BorderSizePixel"] = 0;
			Slider["49"]["BackgroundColor3"] = selectedTheme.Tabs;
			Slider["49"]["BackgroundTransparency"] = 0.949999988079071;
			Slider["49"]["Size"] = UDim2.new(0, 386, 0, 59);
			Slider["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["49"]["Name"] = name;

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.UICorner
			Slider["4a"] = Instance.new("UICorner", Slider["49"]);
			Slider["4a"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.name
			Slider["4b"] = Instance.new("TextLabel", Slider["49"]);
			Slider["4b"]["BorderSizePixel"] = 0;
			Slider["4b"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
			Slider["4b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["4b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Slider["4b"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Slider["4b"]["TextSize"] = 14;
			Slider["4b"]["TextColor3"] = selectedTheme.MainText;
			Slider["4b"]["Size"] = UDim2.new(0.30000001192092896, 0, 0.5, 0);
			Slider["4b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["4b"]["Text"] = name;
			Slider["4b"]["Name"] = [[name]];
			Slider["4b"]["BackgroundTransparency"] = 1;
			Slider["4b"]["Position"] = UDim2.new(0, 7, 0, 0);

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.desc
			Slider["4c"] = Instance.new("TextLabel", Slider["49"]);
			Slider["4c"]["BorderSizePixel"] = 0;
			Slider["4c"]["TextYAlignment"] = Enum.TextYAlignment.Top;
			Slider["4c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["4c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Slider["4c"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Slider["4c"]["TextSize"] = 12;
			Slider["4c"]["TextColor3"] = selectedTheme.SecondaryText;
			Slider["4c"]["AnchorPoint"] = Vector2.new(0, 1);
			Slider["4c"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Slider["4c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["4c"]["Text"] = desc;
			Slider["4c"]["Name"] = [[desc]];
			Slider["4c"]["BackgroundTransparency"] = 1;
			Slider["4c"]["Position"] = UDim2.new(0, 7, 1, 0);

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.sliderback
			Slider["4d"] = Instance.new("Frame", Slider["49"]);
			Slider["4d"]["BorderSizePixel"] = 0;
			Slider["4d"]["BackgroundColor3"] = selectedTheme.Other;
			Slider["4d"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Slider["4d"]["BackgroundTransparency"] = 0.75;
			Slider["4d"]["Size"] = UDim2.new(0.3499999940395355, 0, 0, 4);
			Slider["4d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["4d"]["Position"] = UDim2.new(1, -10, 0.4000000059604645, 0);
			Slider["4d"]["Name"] = [[sliderback]];

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.sliderback.UICorner
			Slider["4e"] = Instance.new("UICorner", Slider["4d"]);
			Slider["4e"]["CornerRadius"] = UDim.new(0.5, 0);

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.sliderback.slider
			Slider["4f"] = Instance.new("ImageLabel", Slider["4d"]);
			Slider["4f"]["BorderSizePixel"] = 0;
			Slider["4f"]["BackgroundTransparency"] = 1;
			Slider["4f"]["Size"] = UDim2.new(0, 10, 0, 10);
			Slider["4f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["4f"]["Image"] = [[rbxassetid://82313944772383]]
			Slider["4f"]["ImageColor3"] = Color3.fromRGB(63, 124, 255)
			Slider["4f"]["Name"] = [[slider]];
			Slider["4f"]["Position"] = UDim2.new(0, 0, 0.5, 0);
			Slider["4f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);

			-- StarterSlider.ScreenSlider.ImageLabel.container.Player.ScrollingFrame.slider.val
			Slider["50"] = Instance.new("TextLabel", Slider["49"]);
			Slider["50"]["BorderSizePixel"] = 0;
			Slider["50"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Slider["50"]["TextXAlignment"] = Enum.TextXAlignment.Right;
			Slider["50"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Slider["50"]["TextSize"] = 12;
			Slider["50"]["TextColor3"] = selectedTheme.MainText;
			Slider["50"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Slider["50"]["Size"] = UDim2.new(0, 10, 0.5, 0);
			Slider["50"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["50"]["Text"] = tostring(min);
			Slider["50"]["Name"] = [[val]];
			Slider["50"]["BackgroundTransparency"] = 1;
			Slider["50"]["Position"] = UDim2.new(1, -160, 0.4000000059604645, 0);
			
			function Slider:SetValue(v)

				if v == nil then
					local percentage = math.clamp((mouse.X - Slider["4d"].AbsolutePosition.X) / (Slider["4d"].AbsoluteSize.X), 0, 1)
					local value = math.floor(((max - min) * percentage) + min)
					
					Slider["50"].Text = tostring(value)
					Slider["4f"].Position = UDim2.fromScale(percentage, .5)
				else
					Slider["50"].Text = tostring(v)
					Slider["4f"].Position = UDim2.fromScale(((v - min) / (max - min)), 1)
				end

				callback(Slider:GetValue())
			end

			function Slider:GetValue()
				return tonumber(Slider["50"].Text)
			end
			
			Slider["49"].MouseEnter:Connect(function()
				Slider.Hover = true

				if not Slider.MouseDown then
					Library:tween(Slider["49"], {BackgroundTransparency = 0.9})
				end
			end)

			Slider["49"].MouseLeave:Connect(function()
				Slider.Hover = false

				if not Slider.MouseDown then
					Library:tween(Slider["49"], {BackgroundTransparency = 0.95})
				end
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Hover then
					Slider.MouseDown = true

					Library:tween(Slider["49"], {BackgroundTransparency = 0.9})

					if not Slider.Connection then
						Slider.Connection = runService.RenderStepped:Connect(function()
							Slider:SetValue()
						end)
					end
				end					
			end)

			uis.InputEnded:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Slider.MouseDown = false

					if Slider.Hover then
						Library:tween(Slider["49"], {BackgroundTransparency = 0.9})

					else
						Library:tween(Slider["49"], {BackgroundTransparency = 0.95})
					end

					if Slider.Connection then Slider.Connection:Disconnect() end
					Slider.Connection = nil
				end
			end)
			
			return Slider
			
		end
		
		function Tab:CreateDropdown(name, desc, msg, list, callback)
			local Dropdown = {
				Hover = false,
				IsDropped = false,
				SelectedOption = nil
			}
			
			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown
			Dropdown["2d"] = Instance.new("Frame", Tab["25"]);
			Dropdown["2d"]["BorderSizePixel"] = 0;
			Dropdown["2d"]["BackgroundColor3"] = selectedTheme.Tabs;
			Dropdown["2d"]["BackgroundTransparency"] = 0.949999988079071;
			Dropdown["2d"]["Size"] = UDim2.new(0, 386, 0, 59);
			Dropdown["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["2d"]["Name"] = name;

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.UICorner
			Dropdown["2e"] = Instance.new("UICorner", Dropdown["2d"]);
			Dropdown["2e"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.name
			Dropdown["2f"] = Instance.new("TextLabel", Dropdown["2d"]);
			Dropdown["2f"]["BorderSizePixel"] = 0;
			Dropdown["2f"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
			Dropdown["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Dropdown["2f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Dropdown["2f"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Dropdown["2f"]["TextSize"] = 14;
			Dropdown["2f"]["TextColor3"] = selectedTheme.MainText;
			Dropdown["2f"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Dropdown["2f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["2f"]["Text"] = name;
			Dropdown["2f"]["Name"] = [[name]];
			Dropdown["2f"]["BackgroundTransparency"] = 1;
			Dropdown["2f"]["Position"] = UDim2.new(0, 7, 0, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.desc
			Dropdown["30"] = Instance.new("TextLabel", Dropdown["2d"]);
			Dropdown["30"]["TextWrapped"] = true;
			Dropdown["30"]["BorderSizePixel"] = 0;
			Dropdown["30"]["TextYAlignment"] = Enum.TextYAlignment.Top;
			Dropdown["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Dropdown["30"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Dropdown["30"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Dropdown["30"]["TextSize"] = 12;
			Dropdown["30"]["TextColor3"] = selectedTheme.SecondaryText;
			Dropdown["30"]["AnchorPoint"] = Vector2.new(0, 1);
			Dropdown["30"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
			Dropdown["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["30"]["Text"] = desc;
			Dropdown["30"]["Name"] = [[desc]];
			Dropdown["30"]["BackgroundTransparency"] = 1;
			Dropdown["30"]["Position"] = UDim2.new(0, 7, 1, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selected
			Dropdown["31"] = Instance.new("Frame", Dropdown["2d"]);
			Dropdown["31"]["BorderSizePixel"] = 0;
			Dropdown["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Dropdown["31"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Dropdown["31"]["BackgroundTransparency"] = 0.949999988079071;
			Dropdown["31"]["Size"] = UDim2.new(0.4000000059604645, 0, 0.5, 0);
			Dropdown["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["31"]["Position"] = UDim2.new(1, -10, 0.5, 0);
			Dropdown["31"]["Name"] = [[selected]];

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selected.UICorner
			Dropdown["32"] = Instance.new("UICorner", Dropdown["31"]);
			Dropdown["32"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selected.icon
			Dropdown["33"] = Instance.new("ImageLabel", Dropdown["31"]);
			Dropdown["33"]["BorderSizePixel"] = 0;
			Dropdown["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Dropdown["33"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Dropdown["33"]["ImageColor3"] = selectedTheme.Images
			Dropdown["33"]["Image"] = [[rbxassetid://86834882432406]];
			Dropdown["33"]["Size"] = UDim2.new(0, 15, 0, 15);
			Dropdown["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["33"]["Name"] = [[icon]];
			Dropdown["33"]["Rotation"] = 90;
			Dropdown["33"]["BackgroundTransparency"] = 1;
			Dropdown["33"]["Position"] = UDim2.new(1, -10, 0.5, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selected.TextLabel
			Dropdown["34"] = Instance.new("TextLabel", Dropdown["31"]);
			Dropdown["34"]["BorderSizePixel"] = 0;
			Dropdown["34"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Dropdown["34"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Dropdown["34"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Dropdown["34"]["TextSize"] = 14;
			Dropdown["34"]["TextColor3"] = selectedTheme.MainText;
			Dropdown["34"]["Size"] = UDim2.new(0.699999988079071, 0, 1, 0);
			Dropdown["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["34"]["Text"] = msg;
			Dropdown["34"]["BackgroundTransparency"] = 1;
			Dropdown["34"]["Position"] = UDim2.new(0, 10, 0, 0);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions
			Dropdown["35"] = Instance.new("Frame", Dropdown["2d"]);
			Dropdown["35"]["BorderSizePixel"] = 0;
			Dropdown["35"]["BackgroundColor3"] = selectedTheme.Dropdown;
			Dropdown["35"]["AnchorPoint"] = Vector2.new(1, 0);
			Dropdown["35"]["Size"] = UDim2.new(0, 159, 0, 34);
			Dropdown["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Dropdown["35"]["Position"] = UDim2.new(1, -6, 0, 13);
			Dropdown["35"]["Name"] = [[selections]];
			Dropdown["35"]["Visible"] = false

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.UICorner
			Dropdown["36"] = Instance.new("UICorner", Dropdown["35"]);
			Dropdown["36"]["CornerRadius"] = UDim.new(0, 6);

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.UIListLayout
			Dropdown["3c"] = Instance.new("UIListLayout", Dropdown["35"]);
			Dropdown["3c"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
			Dropdown["3c"]["Padding"] = UDim.new(0, 2);
			Dropdown["3c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

			-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.UIPadding
			Dropdown["3d"] = Instance.new("UIPadding", Dropdown["35"]);
			Dropdown["3d"]["PaddingTop"] = UDim.new(0, 2);
			
			if #list > 1 then
				Dropdown["35"]["Size"] = UDim2.new(0, 159, 0, Dropdown["35"]["Size"]["Y"]["Offset"] + ((#list - 1) * 31));
			end

			Dropdown["2d"].MouseEnter:Connect(function()
				Dropdown.Hover = true

				if not Dropdown.MouseDown then
					Library:tween(Dropdown["2d"], {BackgroundTransparency = 0.9})
				end
			end)

			Dropdown["2d"].MouseLeave:Connect(function()
				Dropdown.Hover = false

				if not Dropdown.MouseDown then
					Library:tween(Dropdown["2d"], {BackgroundTransparency = 0.95})
				end
			end)

			Dropdown["31"].InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.Hover then
					Dropdown.MouseDown = true

					Library:tween(Dropdown["2d"], {BackgroundTransparency = 0.9})

					Dropdown["35"]["Visible"] = true
					Dropdown.IsDropped = true

				end
			end)

			Dropdown["31"].InputEnded:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dropdown.MouseDown = false

					if Dropdown.Hover then
						Library:tween(Dropdown["2d"], {BackgroundTransparency = 0.9})

					else
						Library:tween(Dropdown["2d"], {BackgroundTransparency = 0.95})


					end

					if Dropdown.Connection then
						Dropdown.Connection:Disconnect()
						Dropdown.Connection = nil
					end
				end
			end)
			
			for i, v in next, list do
				
				local Option = {
					Hover = false,
					Selected = false,
				}

				-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.selection
				Option["37"] = Instance.new("Frame", Dropdown["35"]);
				Option["37"]["BorderSizePixel"] = 0;
				Option["37"]["BackgroundColor3"] = selectedTheme.Tabs;
				Option["37"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
				Option["37"]["BackgroundTransparency"] = 1;
				Option["37"]["Size"] = UDim2.new(0, 154, 0, 29);
				Option["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Option["37"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
				Option["37"]["Name"] = v
				Option["37"]["ZIndex"] = 3;

				-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.selection.UICorner
				Option["38"] = Instance.new("UICorner", Option["37"]);
				Option["38"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

				-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.selection.TextLabel
				Option["39"] = Instance.new("TextLabel", Option["37"]);
				Option["39"]["BorderSizePixel"] = 0;
				Option["39"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Option["39"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Option["39"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Option["39"]["TextSize"] = 14;
				Option["39"]["TextColor3"] = selectedTheme.MainText;
				Option["39"]["Size"] = UDim2.new(0.699999988079071, 0, 1, 0);
				Option["39"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Option["39"]["Text"] = v;
				Option["39"]["BackgroundTransparency"] = 1;
				Option["39"]["Position"] = UDim2.new(0, 14, 0, 0);

				-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.selection.selected
				Option["3a"] = Instance.new("Frame", Option["37"]);
				Option["3a"]["BorderSizePixel"] = 0;
				Option["3a"]["BackgroundColor3"] = Color3.fromRGB(63, 124, 255);
				Option["3a"]["AnchorPoint"] = Vector2.new(0, 0.5);
				Option["3a"]["Size"] = UDim2.new(0, 4, 0.5, 0);
				Option["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Option["3a"]["Position"] = UDim2.new(0, 0, 0.5, 0);
				Option["3a"]["BackgroundTransparency"] = 1;
				Option["3a"]["Name"] = [[selected]];

				-- StarterDropdown.ScreenDropdown.ImageLabel.container.Player.ScrollingFrame.dropdown.selctions.selection.selected.UICorner
				Option["3b"] = Instance.new("UICorner", Option["3a"]);
				Option["3b"]["CornerRadius"] = UDim.new(1, 0);

				Option["37"].MouseEnter:Connect(function()
					Option.Hover = true
					if not Option.Selected then
						Library:tween(Option["37"], {BackgroundTransparency = 0.95})
					end
				end)

				Option["37"].MouseLeave:Connect(function()
					Option.Hover = false
					if not Option.Selected then
						Library:tween(Option["37"], {BackgroundTransparency = 1})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Option.Hover then
							Option:Select()
					
						end
					end
				end)

				function Option:Select()
					if not Option.Selected then
						if Dropdown.SelectedOption ~= nil then
							Dropdown.SelectedOption:Deselect()
						end
						Option.Selected = true

						Library:tween(Option["37"], {BackgroundTransparency = 0.95}) 
						Library:tween(Option["3a"], {BackgroundTransparency = 0})
						
						Dropdown["34"]["Text"] = v
						
						Dropdown["35"]["Visible"] = false
						Dropdown.IsDropped = false
						
						callback(v)

						Dropdown.SelectedOption = Option
					end
				end

				function Option:Deselect()
					if Option.Selected then
						Option.Selected = false

						Option["37"]["BackgroundTransparency"] = 1
						Option["3a"]["BackgroundTransparency"] = 1

						Option.Hover = false
					end


				end

			end
			
			return Dropdown
		end

		return Tab
	end

	return GUI
end

return Library
