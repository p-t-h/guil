--!nolint
--!nocheck
local gUIl = {WindowCount = 0}
local DEFAULT_CONFIG = {
	BackgroundColor = Color3.fromRGB(30, 30, 30),
	TextColor = Color3.fromRGB(225, 225, 255),
	DecoColor = Color3.fromRGB(20, 20, 20),
	DecoColor2 = Color3.fromRGB(225, 225, 225),
	Font = Enum.Font.GothamSemibold,
}

function _require(f)
	if game["Run Service"]:IsStudio() then
		return require(script.Parent.class[f])
	else
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/p-t-h/guil/main/base/" ..f.. ".lua"))
	end
end

local Window = {} Window.__index = Window
local TextLabel = {} TextLabel.__index = TextLabel
local Toggle = {} Toggle.__index = Toggle
local TextBox = {} TextBox.__index = TextBox
local IntBox = {} IntBox.__index = IntBox
local SearchBox = {} SearchBox.__index = SearchBox

local Name
if syn then
	Name = syn.crypt.random(64) 
else
	Name = game.HttpService:GenerateGUID(false)
end

function gUIl:Window(Title)
	local Meta = setmetatable({}, Window)

	gUIl.WindowCount += 1
	local Base, BaseYSize = _require("Window")(self, Title)

	Base.Position = UDim2.new(0, (150 * (gUIl.WindowCount - 1)) + (15 * gUIl.WindowCount), 0, 15)
	Base.Parent = self.Root

	Meta.Configuration = self.Configuration
	Meta.Base = Base
	Meta.BaseYSize = BaseYSize

	return Meta
end

function Window:TextLabel(Text)
	local Meta = setmetatable({}, TextLabel)
	self.BaseYSize.Value += 20

	local Base = _require("TextLabel")(self, Text)
	Base.Parent = self.Base.Container.Frame

	Meta.__label = Base
	return Meta
end

function TextLabel:Update(Text)
	self.__label.Text = Text
end

function Window:Button(Text, OnClick)
	self.BaseYSize.Value += 30

	local Base = _require("Button")(self, Text)
	Base.Parent = self.Base.Container.Frame

	Base.MouseButton1Click:Connect(function()
		OnClick()
	end)
end

function Window:Toggle(Text, OnToggle)
	local Meta = setmetatable({}, Toggle)
	Meta.Enabled = false
	self.BaseYSize.Value += 30

	local Base = _require("Button")(self, Text) -- lol
	Base.Parent = self.Base.Container.Frame
	Meta.Base = Base
	Meta.update = function()
		Base.Deco.BackgroundColor3 = self.Enabled and self.Configuration.DecoColor2 or self.Configuration.DecoColor
		OnToggle(self.Enabled)
	end

	Base.MouseButton1Click:Connect(function()
		self.Enabled = not self.Enabled
		local TI = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local Tween = game:GetService("TweenService"):Create(Base.Deco, TI, {BackgroundColor3 = self.Enabled
			and self.Configuration.DecoColor2 or self.Configuration.DecoColor})

		Tween:Play()
		OnToggle(self.Enabled)
	end)
end

function Toggle:Get()
	return self.Enabled
end

function Toggle:Set(v)
	self.Enabled = v
	self.update()
end

function Window:TextBox(Placeholder, Default, OnChange)
	local Meta = setmetatable({}, TextBox)
	self.BaseYSize.Value += 30

	local Base = _require("TextBox")(self, Placeholder, Default)
	Base.Parent = self.Base.Container.Frame
	Meta.Base = Base

	Meta.event = OnChange

	Base.Input.FocusLost:Connect(function()
		OnChange(Base.Input.Text)
	end)
end

function TextBox:Get()
	return self.Base.Input.Text
end

function TextBox:Set(v)
	self.Base.Input.Text = v
	self.event(v)
end

function Window:IntegerBox(Placeholder, Default, Min, Max, OnChange)
	local Meta = setmetatable({}, IntBox)
	self.BaseYSize.Value += 30

	local Base = _require("IntBox")(self, Placeholder, Default)
	Base.Parent = self.Base.Container.Frame

	Meta.Value = Default

	local IncButton = Base.Increment
	local DecButton = Base.Decrement

	Meta.update = function(v)
		v = math.clamp(v, Min, Max)
		OnChange(v)

		Meta.Value = v

		DecButton.TextColor3 = v == Min and self.Configuration.DecoColor or self.Configuration.DecoColor2
		IncButton.TextColor3 = v == Max and self.Configuration.DecoColor or self.Configuration.DecoColor2

		Base.Input.Text = v
	end

	Meta.update(Default)

	IncButton.MouseButton1Click:Connect(function()
		Meta.update(Meta.Value + 1)
	end)

	DecButton.MouseButton1Click:Connect(function()
		Meta.update(Meta.Value - 1)
	end)

	Base.Input.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			Base.Input.Text = Meta.Value
		else
			if Base.Input.Text ~= "" then
				Meta.update(tonumber(Base.Input.Text))
			else
				Base.Input.Text = Meta.Value
			end
		end
	end)

	return Meta
end

function IntBox:Get()
	return self.Value
end

function IntBox:Set(v)
	self.update(v)
end

function Window:SearchBox(Placeholder, Default, Values, OnChange)
	local Meta = setmetatable({}, SearchBox)
	self.BaseYSize.Value += 30

	local Base, Update = _require("TextBox")(self, Placeholder, Default)
	Base.Parent = self.Base.Container.Frame
	Meta.Base = Base

	Meta.event = OnChange
	Meta.Update = Update
	
	local List = Instance.new("Frame", Base)
	List.BackgroundTransparency = 1
	List.BorderSizePixel = 0
	List.Visible = false
	List.Size = UDim2.new(1, 0, 0, 0)
	List.Position = UDim2.new(0, 0, 1, 0)
	List.ClipsDescendants = true
	List.ZIndex = 5
	
	local LO = Instance.new("UIListLayout", List)
	LO.SortOrder = Enum.SortOrder.LayoutOrder
	
	Meta.refresh = function(e)
		List.Size = UDim2.new(1, 0, 0, 0)
		
		for _, C in pairs(List:GetChildren()) do
			if C:IsA("TextButton") then
				print(C.Text)
				C:Destroy()
			end
		end
		
		for _, Entry in pairs(e) do
			local B = Instance.new("TextButton", List)
			B.ZIndex = 6
			B.BackgroundColor3 = gUIl.Configuration.BackgroundColor
			B.BorderSizePixel = 0
			B.Text = Entry
			B.Size = UDim2.new(1, 0, 0, 15)
			B.TextColor3 = gUIl.Configuration.TextColor
			B.Font = gUIl.Configuration.Font
			B.TextSize = 14
			
			List.Size += UDim2.new(0, 0, 0, 15)
			
			B.MouseButton1Down:Connect(function()
				Base.Input.Text = Entry
				List.Visible = false
				OnChange(Entry)
			end)
		end
	end
	
	Meta.refresh(Values)
	
	Base.Input.Focused:Connect(function() List.Visible = true end)
	Base.Input.FocusLost:Connect(function() wait(0.05) List.Visible = false end)
	
	Base.Input:GetPropertyChangedSignal("Text"):Connect(function()
		local InputText = Base.Input.Text
		for _, c in pairs(List:GetChildren()) do
			if c:IsA("TextButton") then
				local inp_len = InputText:len()
				local s2 = c.Text:sub(0, inp_len)
				if InputText:sub(0, inp_len) == s2 or InputText == "" then
					c.Visible = true
				else
					c.Visible = false
				end
			end
		end
	end)
	
	return Meta
end

function SearchBox:Update(NewList)
	self.refresh(NewList)
end

return function(Configuration)
	local s = pcall(function() return game.CoreGui.SelectionImageObject end)
	local GUI = s and game.CoreGui or game.Players.LocalPlayer.PlayerGui
	
	if _G.LAST_NAME ~= nil then
		game.CoreGui[_G.LAST_NAME]:Destroy()
		_G.LAST_NAME = nil
	end

	if Configuration == nil then Configuration = {} end
	for k, v in pairs(DEFAULT_CONFIG) do
		if (Configuration[k] == nil) then
			Configuration[k] = v
		end
	end

	gUIl.Configuration = Configuration
	table.freeze(gUIl.Configuration)

	local Root = Instance.new("ScreenGui", GUI)
	Root.Name = Name
	_G.LAST_NAME = Name

	gUIl.Root = Root
	gUIl.Root.Parent = GUI

	return gUIl
end
