local Players = game:GetService("Players")
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
    {name = "🏬 ตลาดโลก", cframe = CFrame.new(2830.64, 16.15, 2088.41)},
    {name = "🏠 แลนฟ้า", cframe = CFrame.new(2412.7, 16.2, 2236.8)},
    {name = "🗼 โรงพยาบาล", cframe = CFrame.new(3419.51, 16.15, 2583.95)},
    {name = "🕵️ ตลาดมืด", cframe = CFrame.new(3204.26, 16.14, 2308.46)},
    {name = "🏞️ ร้านค้า-ตัวเมือง", cframe = CFrame.new(3022.05, 15.99, 1935.06)},
    {name = "🏫 ร้านขายรถ", cframe = CFrame.new(2913.12, 23.77, 2735.43)},
    {name = "🏥 สถานีตำรวจ", cframe = CFrame.new(3710.08, 16.13, 3572.60)},
    {name = "🚓 แลนแดง", cframe = CFrame.new(2563.22, 16.11, 531.47)},
    {name = "🏢 คริสมาส", cframe = CFrame.new(3857.90, 16.17, 385.22)},
    {name = "🏠 ดอกไม้", cframe = CFrame.new(3027.14, 16.01, -863.75)},
    {name = "🏠 กระหล่ำ", cframe = CFrame.new(2139.79, 16.02, -3332.01)},
    {name = "🛣️ ไม้", cframe = CFrame.new(1264.86, 16.03, -1704.10)},
    {name = "🌉 สตอเบอรี่", cframe = CFrame.new(-85.29, 90.27, -2993.89)},
    {name = "🛫 หิน", cframe = CFrame.new(-321.28, -93.90, -2021.31)},
    {name = "🚢 กล้วย", cframe = CFrame.new(70.07, 16.03, -366.41)},
    {name = "🏜️ แลกมะม่วง", cframe = CFrame.new(1060.44, 16.08, -521.77)},
    {name = "🏔️ ข้าวโพด", cframe = CFrame.new(-231.84, 51.61, 549.42)},
    {name = "🎢 เนื้อหมู", cframe = CFrame.new(-592.87, 16.02, 2340.24)},
    {name = "🧪 มะพร้าว", cframe = CFrame.new(-3321.94, 75.48, 1071.51)},
    {name = "🏬 หญ้า", cframe = CFrame.new(-2294.86, 235.47, 54.01)},
    {name = "🏠 องุ่น", cframe = CFrame.new(-2746.55, 75.01, -955.08)},
    {name = "🗼 พริก", cframe = CFrame.new(-2273.88, 49.32, -2297.65)},
    {name = "🕵️ จุดเบิกรถใกล้กับมะพร้าว", cframe = CFrame.new(-2692.62, 15.02, 3042.81)},
    {name = "🏞️ แปรรูปหิน", cframe = CFrame.new(-1907.78, 15.14, 3199.30)},
    {name = "🏫 เหล็ก", cframe = CFrame.new(1083.07, 15.19, 3699.13)},
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
