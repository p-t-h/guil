return function(self, Text)
	local Base = Instance.new("TextLabel")
	Base.BackgroundColor3 = self.Configuration.BackgroundColor
	Base.BorderSizePixel = 0
	Base.Name = "Label"
	Base.Size = UDim2.new(1, 0, 0, 20)
	Base.Font = self.Configuration.Font
	Base.Text = Text
	Base.TextColor3 = self.Configuration.TextColor
	Base.TextSize = 14

	return Base
end