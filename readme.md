<h1 align="center">guil</h1>
<p align="center">a generic ui library for roblox</p>

#### example
```lua
local config = {
  BackgroundColor = Color3.fromRGB(30, 30, 30),
	TextColor = Color3.fromRGB(225, 225, 255),
	DecoColor = Color3.fromRGB(20, 20, 20),
	DecoColor2 = Color3.fromRGB(225, 225, 225),
	Font = Enum.Font.GothamSemibold,
}

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/p-t-h/guil/main/Main.lua"))()(config)

local window = lib:Window("window")

-- text label
local label = window:TextLabel("label")

-- button
window:Button("button", function() print("clicked") end)

-- toggle
local toggle = window:Toggle("toggle", function(v) print(v and "on" or "off") end)

-- textbox
local textbox = window:TextBox("textbox", "some text", print)

-- integer box
local intbox = window:IntegerBox("number", 16, 16, 250, print)

-- search box
local searchbox = window:SearchBox("search", "1", {"1", "2", "3"}, print)
searchbox:Update({"1", "2", "3", "4"})
```
