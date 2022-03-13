<h1 align="center">guil</h1>
<p align="center">a generic ui library for roblox</p>

#### example
```lua
local lib = loadstring("https://raw.githubusercontent.com/p-t-h/guil/main/Main.lua")()()

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
```
