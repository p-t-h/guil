return function(self, Text)
	local Base = Instance.new("TextButton")
	Base.BackgroundColor3 = self.Configuration.BackgroundColor
	Base.BorderSizePixel = 0
	Base.Name = Text .. "-Button"
	Base.Size = UDim2.new(1, 0, 0, 30)
	Base.TextColor3 = self.Configuration.TextColor
	Base.Text = Text
	Base.Font = self.Configuration.Font
	Base.TextSize = 14

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.Parent = Base

	local Deco = Instance.new("Frame")
	Deco.BackgroundColor3 = self.Configuration.DecoColor
	Deco.BorderSizePixel = 0
	Deco.Size = UDim2.new(0, 4, 1, 0)
	Deco.Parent = Base
	Deco.Name = "Deco"

	return Base
end