local DEVELOPER_MODE = true
local DEFAULT_CONFIG = {
	BackgroundColor = Color3.fromRGB(30, 30, 30),
	TextColor = Color3.fromRGB(225, 225, 255),
	DecoColor = Color3.fromRGB(20, 20, 20),
	DecoColor2 = Color3.fromRGB(225, 225, 225),
	Font = Enum.Font.GothamSemibold,
}
local Name = syn.crypt.random(64)

--#region Setup
local gUIl = {} gUIl.__index = gUIl
local Window = {} Window.__index = Window
local TextLabel = {} TextLabel.__index = TextLabel
local Toggle = {} Toggle.__index = Toggle
local TextBox = {} TextBox.__index = TextBox
local IntBox = {} IntBox.__index = IntBox

gUIl.WindowCount = 0
--#endregion
--#region Functions
function gUIl.Require(Path)
	if DEVELOPER_MODE then
		return loadfile("gUIl\\" .. Path)()
	else
		Path = Path:gsub("\\", "/")
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/p-t-h/guil/main" .. Path, true))()
	end
end
--#endregion
--#region Window class functions
function gUIl:Window(Title)
	local Meta = setmetatable({}, Window)

	gUIl.WindowCount += 1
	local Base, BaseYSize = gUIl.Require("base\\Window.lua")(self, Title)

	Base.Position = UDim2.new(0, (150 * (gUIl.WindowCount - 1)) + (15 * gUIl.WindowCount), 0, 15)
	Base.Parent = self.Root

	Meta.Configuration = self.Configuration
	Meta.Base = Base
	Meta.BaseYSize = BaseYSize

	return Meta
end
--#endregion
--#region Text label functions
function Window:TextLabel(Text)
	local Meta = setmetatable({}, TextLabel)
	self.BaseYSize.Value += 20

	local Base = gUIl.Require("base\\TextLabel.lua")(self, Text)
	Base.Parent = self.Base.Container.Frame

	Meta.__label = Base
	return Meta
end

function TextLabel:Update(Text)
	self.__label.Text = Text
end
--#endregion
--#region Button functions
function Window:Button(Text, OnClick)
	self.BaseYSize.Value += 30

	local Base = gUIl.Require("base\\Button.lua")(self, Text)
	Base.Parent = self.Base.Container.Frame

	Base.MouseButton1Click:Connect(function()
		OnClick()
	end)
end
--#endregion
--#region Toggle functions
function Window:Toggle(Text, OnToggle)
	local Meta = setmetatable({}, Toggle)
	Meta.Enabled = false
	self.BaseYSize.Value += 30

	local Base = gUIl.Require("base\\Button.lua")(self, Text) -- lol
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
--#endregion
--#region Textbox functions
function Window:TextBox(Placeholder, Default, OnChange)
	local Meta = setmetatable({}, TextBox)
	self.BaseYSize.Value += 30

	local Base = gUIl.Require("base\\TextBox.lua")(self, Placeholder, Default)
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
--#endregion
--#region Integerbox functions
function Window:IntegerBox(Placeholder, Default, Min, Max, OnChange)
	local Meta = setmetatable({}, IntBox)
	self.BaseYSize.Value += 30

	local Base = gUIl.Require("base\\IntBox.lua")(self, Placeholder, Default)
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
--#endregion
--#region Init
return function(Configuration)
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

	local Root = gUIl.Require("base\\Root.lua")()
	Root.Name = Name
	_G.LAST_NAME = Name

	gUIl.Root = Root
	gUIl.Root.Parent = game.CoreGui

	return gUIl
end
--#endregion