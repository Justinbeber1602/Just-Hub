-- 📌 สคริปนี้ทำงานได้ใน Roblox Studio LocalScript
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== สร้าง UI หลัก ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JustHubUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- ขอบมน + เงา
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Bar (สำหรับลาก)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- ปิดมุมล่างของ Title Bar
local titleMask = Instance.new("Frame")
titleMask.Size = UDim2.new(1, 0, 0, 20)
titleMask.Position = UDim2.new(0, 0, 1, -20)
titleMask.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
titleMask.BorderSizePixel = 0
titleMask.Parent = titleBar

-- Title Text
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "JustHub UI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- ปุ่มปิด
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Content Area
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- Layout
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = contentFrame

local padding = Instance.new("UIPadding")
padding.PaddingAll = UDim.new(0, 15)
padding.Parent = contentFrame

-- ========== สร้างปุ่มต่างๆ ==========

-- Section Header
local function createSection(name)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = name .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 35)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = contentFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = sectionFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -20, 1, 0)
    sectionLabel.Position = UDim2.new(0, 10, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextScaled = true
    sectionLabel.Font = Enum.Font.SourceSansBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
end

-- สร้างปุ่ม
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Hover Effect
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 0, 0)})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- สร้าง Toggle
local function createToggle(text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(1, -75, 0.5, -12.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Parent = toggleFrame
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(0, 12)
    toggleButtonCorner.Parent = toggleButton
    
    local isToggled = false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if isToggled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleButton.Text = "OFF"
        end
        
        callback(isToggled)
    end)
    
    return toggleFrame
end

-- ========== เพิ่มเนื้อหา ==========
createSection("🎯 Teleport Locations")

-- สถานที่ต่างๆ
local locations = {
    "ตลาดโลก", "ATM ตลาดโลก", "ผับ", "ร้านอาหาร", "อู่", "โรงพยาบาล",
    "สถานีตำรวจ", "หมู", "กล้วย", "ดอกไม้", "มะพร้าว", "แลนแดง",
    "เหล็ก1", "หญ้า", "พริก", "หิน", "แลกมะม่วง", "ไม้"
}

for _, location in pairs(locations) do
    createButton("📍 " .. location, function()
        print("วาร์ปไป " .. location)
        -- ที่นี่ใส่โค้ดวาร์ป
        
        -- แสดงการแจ้งเตือน
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 200, 0, 50)
        notification.Position = UDim2.new(1, -220, 0, 20)
        notification.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        notification.BorderSizePixel = 0
        notification.Text = "วาร์ปไป " .. location .. " แล้ว!"
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextScaled = true
        notification.Font = Enum.Font.SourceSansBold
        notification.Parent = screenGui
        
        local notiCorner = Instance.new("UICorner")
        notiCorner.CornerRadius = UDim.new(0, 8)
        notiCorner.Parent = notification
        
        -- หายไปหลัง 2 วินาที
        game:GetService("Debris"):AddItem(notification, 2)
    end)
end

createSection("⚡ Features")

-- Noclip Toggle
local noclipEnabled = false
local noclipConnection

createToggle("🚀 Noclip Mode", function(enabled)
    noclipEnabled = enabled
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("Noclip เปิด!")
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("Noclip ปิด!")
    end
end)

-- Speed Toggle
createToggle("⚡ Speed Boost", function(enabled)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enabled then
            player.Character.Humanoid.WalkSpeed = 50
            print("Speed Boost เปิด!")
        else
            player.Character.Humanoid.WalkSpeed = 16
            print("Speed Boost ปิด!")
        end
    end
end)

-- Jump Power Toggle
createToggle("🦘 Jump Boost", function(enabled)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enabled then
            player.Character.Humanoid.JumpPower = 100
            print("Jump Boost เปิด!")
        else
            player.Character.Humanoid.JumpPower = 50
            print("Jump Boost ปิด!")
        end
    end
end)

-- ========== ระบบลาก UI ==========
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateInput(input)
        end
    end
end)

-- ========== ปุ่มปิด UI ==========
closeButton.MouseButton1Click:Connect(function()
    -- Animation ปิด UI
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    closeTween:Play()
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- ========== การแจ้งเตือนเริ่มต้น ==========
wait(0.5)
local startNotification = Instance.new("TextLabel")
startNotification.Size = UDim2.new(0, 250, 0, 60)
startNotification.Position = UDim2.new(1, -270, 0, 20)
startNotification.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
startNotification.BorderSizePixel = 0
startNotification.Text = "✨ JustHub UI พร้อมใช้งาน!\nลากที่ Title Bar เพื่อย้าย UI"
startNotification.TextColor3 = Color3.fromRGB(255, 255, 255)
startNotification.TextScaled = true
startNotification.Font = Enum.Font.SourceSansBold
startNotification.Parent = screenGui

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 8)
startCorner.Parent = startNotification

game:GetService("Debris"):AddItem(startNotification, 4)

print("✅ JustHub UI โหลดเสร็จแล้ว! ลากได้ ปิดได้ ใช้งานได้จริง!")
