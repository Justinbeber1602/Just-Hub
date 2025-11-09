local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ================== UI หลัก ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JustHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 60, 60)
stroke.Thickness = 3
stroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔥 JustHub UI 🔥"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)
title.Parent = mainFrame

-- ปุ่มกากบาท (Close Button)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- ปุ่มเปิดใหม่ (Hotkey: F4)
UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F4 then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- ================== Tab Container ==================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 10)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Scrollable Container
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = contentFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- ================== สร้างปุ่ม Helper ==================
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Parent = scroll

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 90, 90)
	s.Thickness = 2
	s.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	end)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- ================== Tabs System ==================
local tabs = {}
local currentTab = nil

local function switchTab(name)
	if currentTab == name then return end
	currentTab = name
	for tabName, buttons in pairs(tabs) do
		for _, b in ipairs(buttons) do
			b.Visible = (tabName == name)
		end
	end
end

local function createTab(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Parent = tabFrame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 120, 120)
	s.Thickness = 1.5
	s.Parent = btn

	tabs[name] = {}

	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	return function(text, callback)
		local b = createButton(text, callback)
		b.Visible = false
		table.insert(tabs[name], b)
	end
end

-- ================== Teleport Tab ==================
local Teleport = createTab("Teleport")

local locations = {
    {name = "ตลาดโลก", cframe = CFrame.new(2846.01, 16.55, 2108.39)},
    {name = "ATM ตลาดโลก", cframe = CFrame.new(2999.37, 16.60, 2278.67)},
    {name = "ผับ", cframe = CFrame.new(3158.82, 16.69, 2300.57)},
    {name = "ร้านอาหาร", cframe = CFrame.new(3486.12, 18.24, 2581.56)},
    {name = "อู่", cframe = CFrame.new(2814.99, 18.24, 2671.00)},
    {name = "โรงพยาบาล", cframe = CFrame.new(3012.29, 16.64, 3526.09)},
    {name = "สถานีตำรวจ", cframe = CFrame.new(3632.24, 24.07, 3215.28)},
    {name = "หมู", cframe = CFrame.new(-533.00, 58.63, 3132.92)},
    {name = "กล้วย", cframe = CFrame.new(-1099.27, 130.38, 2420.52)},
    {name = "ดอกไม้", cframe = CFrame.new(-1790.67, 130.10, 1135.51)},
    {name = "มะพร้าว", cframe = CFrame.new(-2832.60, 20.46, 2197.16)},
    {name = "แลนแดง", cframe = CFrame.new(-3891.84, 76.42, -486.54)},
    {name = "เหล็ก1", cframe = CFrame.new(-4078.10, 70.95, -2818.08)},
    {name = "หญ้า", cframe = CFrame.new(-2445.71, 74.97, -2037.70)},
    {name = "พริก", cframe = CFrame.new(-611.63, 16.96, -3343.03)},
    {name = "หิน", cframe = CFrame.new(-191.36, 17.35, -2391.63)},
    {name = "แลกมะม่วง", cframe = CFrame.new(1060.44, 18.08, -521.77)},
    {name = "ไม้", cframe = CFrame.new(2410.08, 33.03, -2410.61)},
    {name = "แปรรูปหิน", cframe = CFrame.new(6149.76, 51.03, -4225.38)},
    {name = "ร้านค้าและปั้ม", cframe = CFrame.new(5668.79, 50.98, -3112.81)},
    {name = "ข้าวโพด", cframe = CFrame.new(5207.04, 47.10, -2238.00)},
    {name = "องุ่น", cframe = CFrame.new(5460.13, 49.22, -1191.45)},
    {name = "สตอร์เบอรี่", cframe = CFrame.new(5949.39, 50.97, -1699.58)},
    {name = "กระหล่ำ", cframe = CFrame.new(6085.44, 51.19, -2235.12)},
}
for _, loc in ipairs(locations) do
	Teleport("วาร์ปไป: "..loc.name, function()
		local char = player.Character or player.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		root.CFrame = loc.cframe
	end)
end

-- ================== Misc Tab ==================
local Misc = createTab("⚡ Misc")

local noclipEnabled = false
local noclipConnection

local function enableNoclip()
	if noclipConnection then noclipConnection:Disconnect() end
	noclipConnection = RunService.Stepped:Connect(function()
		if noclipEnabled and player.Character then
			for _, part in ipairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end

local function disableNoclip()
	if noclipConnection then noclipConnection:Disconnect() end
	if player.Character then
		for _, part in ipairs(player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

Misc("🔘 Toggle Noclip", function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		enableNoclip()
	else
		disableNoclip()
	end
end)

-- ================== เปิด Tab เริ่มต้น ==================
switchTab("🚀 Teleport")
