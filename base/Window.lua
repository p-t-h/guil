local TweenService = game:GetService("TweenService")

return function(self, Title)
	local IsOpen = true

	local Base = Instance.new("Frame")
	Base.Active = true
	Base.BackgroundColor3 = self.Configuration.BackgroundColor
	Base.BorderSizePixel = 0
	Base.Draggable = true
	Base.Name = Title .. "Window"
	Base.Size = UDim2.new(0, 150, 0, 30)

	local BaseYSize = Instance.new("IntValue")
	BaseYSize.Name = "BaseYSize"
	BaseYSize.Parent = Base

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Parent = Base
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	TitleLabel.TextColor3 = self.Configuration.TextColor
	TitleLabel.RichText = true
	TitleLabel.Text = ("<b>%s</b>"):format(Title)
	TitleLabel.TextSize = 14
	TitleLabel.Font = self.Configuration.Font

	local Container1 = Instance.new("Frame")
	Container1.BackgroundTransparency = 1
	Container1.Parent = Base
	Container1.Name = "Container"
	Container1.Size = UDim2.new(1, 0, 0, BaseYSize.Value + 10)
	Container1.Position = UDim2.new(0, 0, 1, 0)

	local UIListLayout1 = Instance.new("UIListLayout")
	UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout1.Parent = Container1

	local Container2 = Instance.new("Frame")
	Container2.Parent = Container1
	Container2.BackgroundTransparency = 1
	Container2.Size = UDim2.new(1, 0, 0, 0)

	local UIListLayout2 = Instance.new("UIListLayout")
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Parent = Container2

	local CollapseButton = Instance.new("TextButton")
	CollapseButton.Parent = Container1
	CollapseButton.BackgroundColor3 = self.Configuration.BackgroundColor
	CollapseButton.BorderSizePixel = 0
	CollapseButton.Name = "CollapseButton"
	CollapseButton.Size = UDim2.new(1, 0, 0, 10)
	CollapseButton.Text = ""

	local CollapseButtonDeco = Instance.new("Frame")
	CollapseButtonDeco.AnchorPoint = Vector2.new(0.5, 0.5)
	CollapseButtonDeco.Parent = CollapseButton
	CollapseButtonDeco.BackgroundColor3 = self.Configuration.DecoColor2
	CollapseButtonDeco.BorderSizePixel = 0
	CollapseButtonDeco.Name = "Deco"
	CollapseButtonDeco.Position = UDim2.new(0.5, 0, 0.5, 0)
	CollapseButtonDeco.Size = UDim2.new(0.5, 0, 0.5, 0)

	BaseYSize.Changed:Connect(function(value)
		Container2.Size = UDim2.new(1, 0, 0, value)
	end)

	CollapseButton.MouseButton1Click:Connect(function()
		IsOpen = not IsOpen
		local TI = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local Tween = TweenService:Create(Container2, TI, {Size = UDim2.new(1, 0, 0, IsOpen and BaseYSize.Value or 0)})
		local Tween2 = TweenService:Create(CollapseButtonDeco, TI, {BackgroundColor3 = IsOpen and self.Configuration.DecoColor2 or self.Configuration.DecoColor})
		if not IsOpen then
			Container2.ClipsDescendants = true
		else
			Tween.Completed:Connect(function()
				Container2.ClipsDescendants = false
			end)
		end
		Tween:Play()
		Tween2:Play()
	end)

	return Base, BaseYSize
end