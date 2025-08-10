local playerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "TeleportUI"
screenGui.ResetOnSpawn = false

local font = Enum.Font.GothamSemibold

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "📦 Teleport Menu By JustShop"
titleLabel.Font = font
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minimizeButton = Instance.new("TextButton", topBar)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 2)
minimizeButton.Text = "➖"
minimizeButton.Font = font
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
minimizeButton.BorderColor3 = Color3.fromRGB(255, 0, 0)

local bodyFrame = Instance.new("Frame", mainFrame)
bodyFrame.Position = UDim2.new(0, 0, 0, 35)
bodyFrame.Size = UDim2.new(1, 0, 1, -35)
bodyFrame.BackgroundTransparency = 1

local searchBox = Instance.new("TextBox", bodyFrame)
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 10)
searchBox.PlaceholderText = "🔍 Search location..."
searchBox.Font = font
searchBox.TextSize = 18
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
searchBox.ClearTextOnFocus = false

local scrollFrame = Instance.new("ScrollingFrame", bodyFrame)
scrollFrame.Position = UDim2.new(0, 10, 0, 55)
scrollFrame.Size = UDim2.new(1, -20, 1, -65)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout", scrollFrame)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local locations = {
    {name = "ตลาดโลก", cframe = CFrame.new(2846.01, 14.55, 2108.39)},
    {name = "ATM ตลาดโลก", cframe = CFrame.new(2999.37, 14.60, 2278.67)},
    {name = "ผับ", cframe = CFrame.new(3158.82, 14.69, 2300.57)},
    {name = "ร้านอาหาร", cframe = CFrame.new(3158.82, 14.69, 2300.57)},
    {name = "อู่", cframe = CFrame.new(32864.30, 23.00, 2716.44)},
    {name = "โรงพยาบาล", cframe = CFrame.new(3012.29, 14.64, 3526.09)},
    {name = "สถานีตำรวจ", cframe = CFrame.new(3632.24, 22.07, 3215.28)},
    {name = "หมู", cframe = CFrame.new(-533.00, 56.63, 3132.92)},
    {name = "กล้วย", cframe = CFrame.new(-1099.27, 128.38, 2420.52)},
    {name = "ดอกไม้", cframe = CFrame.new(-1790.67, 128.10, 1135.51)},
    {name = "มะพร้าว", cframe = CFrame.new(-2832.60, 18.46, 2197.16)},
    {name = "แลนแดง", cframe = CFrame.new(-3891.84, 74.42, -486.54)},
    {name = "เหล็ก1", cframe = CFrame.new(-4078.10, 68.95, -2818.08)},
    {name = "หญ้า", cframe = CFrame.new(-2445.71, 72.97, -2037.70)},
    {name = "พริก", cframe = CFrame.new(-611.63, 13.96, -3343.03)},
    {name = "เหล็ก", cframe = CFrame.new(-191.36, 15.35, -2391.63)},
    {name = "แลกมะม่วง", cframe = CFrame.new(1060.44, 16.08, -521.77)},
    {name = "ไม้", cframe = CFrame.new(2410.08, 31.03, -2410.61)},
    {name = "แปรรูปหิน", cframe = CFrame.new(6149.76, 49.03, -4225.38)},
    {name = "ร้านค้าและปั้ม", cframe = CFrame.new(5668.79, 48.98, -3112.81)},
    {name = "ข้าวโพด", cframe = CFrame.new(5207.04, 45.10, -2238.00)},
    {name = "องุ่น", cframe = CFrame.new(5460.13, 47.22, -1191.45)},
    {name = "สตอร์เบอรี่", cframe = CFrame.new(5949.39, 48.97, -1699.58)},
    {name = "กระหล่ำ", cframe = CFrame.new(6085.44, 49.19, -2235.12)},
}
local function createTPItem(location)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = location.name
    btn.Font = font
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.AutoButtonColor = false
    btn.Name = location.name:lower()

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    btn.MouseButton1Click:Connect(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        root.CFrame = location.cframe
    end)

    btn.MouseButton2Click:Connect(function()
        setclipboard("CFrame.new(" .. tostring(location.cframe) .. ")")
        btn.Text = "📋 Copied!"
        task.delay(1, function()
            btn.Text = location.name
        end)
    end)

    btn.Parent = scrollFrame
end

local function filterButtons(query)
    query = query:lower()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = (query == "") or (string.find(child.Name, query) ~= nil)
        end
    end
end

-- ค้นหา
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterButtons(searchBox.Text)
end)

-- สร้างปุ่มสำหรับแต่ละจุด
for _, loc in ipairs(locations) do
    createTPItem(loc)
end

-- ปุ่มย่อ/ขยาย bodyFrame
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    bodyFrame.Visible = not minimized
    minimizeButton.Text = minimized and "➕" or "➖"
end)

-- ปุ่ม Ctrl ซ่อน/แสดง UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ปุ่ม Toggle หุบ/ขยาย UI (มุมขวาล่าง)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 1, -50)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
toggleButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "📦"
toggleButton.Font = font
toggleButton.TextSize = 20
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Draggable = true

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

