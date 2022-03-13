local TweenService = game:GetService("TweenService")

return function(self, Title, Default)
	local Base = Instance.new("Frame")
	Base.BackgroundColor3 = self.Configuration.BackgroundColor
	Base.BorderSizePixel = 0
	Base.Name = Title .. "-Textbox"
	Base.Size = UDim2.new(1, 0, 0, 30)

	local Input = Instance.new("TextBox")
	Input.AnchorPoint = Vector2.new(0.5, 0.5)
	Input.BackgroundTransparency = 1
	Input.Name = "Input"
	Input.Size = UDim2.new(1, -56, 1, 0)
	Input.Position = UDim2.new(0.5, 0, 0.5, 0)
	Input.Parent = Base
	Input.Font = self.Configuration.Font
	Input.PlaceholderText = Title
	Input.Text = Default
	Input.TextColor3 = self.Configuration.TextColor
	Input.TextSize = 14

	local Padding = Instance.new("UIPadding")
	Padding.PaddingBottom = UDim.new(0, 4)
	Padding.PaddingLeft = UDim.new(0, 4)
	Padding.PaddingRight = UDim.new(0, 4)
	Padding.PaddingTop = UDim.new(0, 4)
	Padding.Parent = Base

	local Inc = Instance.new("TextButton")
	Inc.AnchorPoint = Vector2.new(0, 0.5)
	Inc.BackgroundTransparency = 1
	Inc.Name = "Increment"
	Inc.Size = UDim2.new(0, 26, 0, 26)
	Inc.Position = UDim2.new(1, -26, 0.5, 0)
	Inc.Parent = Base
	Inc.Font = self.Configuration.Font
	Inc.Text = "+"
	Inc.TextColor3 = self.Configuration.DecoColor2
	Inc.TextSize = 14

	local Dec = Instance.new("TextButton")
	Dec.AnchorPoint = Vector2.new(0, 0.5)
	Dec.BackgroundTransparency = 1
	Dec.Name = "Decrement"
	Dec.Size = UDim2.new(0, 26, 0, 26)
	Dec.Position = UDim2.new(0, 0, 0.5, 0)
	Dec.Parent = Base
	Dec.Font = self.Configuration.Font
	Dec.Text = "-"
	Dec.TextColor3 = self.Configuration.DecoColor2
	Dec.TextSize = 14

	local BtmLine = Instance.new("Frame")
	BtmLine.BackgroundColor3 = self.Configuration.DecoColor
	BtmLine.BorderSizePixel = 0
	BtmLine.Size = UDim2.new(1, 0, 0, 1)
	BtmLine.Position = UDim2.new(0, 0, 1, 0)
	BtmLine.Parent = Input

	Input.Focused:Connect(function()
		local TI = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local Tween = TweenService:Create(BtmLine, TI, {BackgroundColor3 = self.Configuration.DecoColor2})
		Tween:Play()
	end)

	Input.FocusLost:Connect(function()
		local TI = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local Tween = TweenService:Create(BtmLine, TI, {BackgroundColor3 = self.Configuration.DecoColor})
		Tween:Play()
	end)

	Input:GetPropertyChangedSignal("Text"):Connect(function()
		Input.Text = Input.Text:gsub('%D+', '');
	end)

	return Base
end