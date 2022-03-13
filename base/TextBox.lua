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
	Input.Size = UDim2.new(1, -4, 1, -4)
	Input.Position = UDim2.new(0.5, 0, 0.5, 0)
	Input.Parent = Base
	Input.Font = self.Configuration.Font
	Input.PlaceholderText = Title
	Input.Text = Default
	Input.TextColor3 = self.Configuration.TextColor
	Input.TextSize = 14
	Input.TextXAlignment = Enum.TextXAlignment.Left

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

	return Base
end