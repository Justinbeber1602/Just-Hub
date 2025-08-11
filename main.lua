-- 📌 ต้องรันใน LocalScript เท่านั้น
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("JustHub", "BloodTheme")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ================= Teleport Tab =================
local TeleportTab = Window:NewTab("Teleport")
local LocationSection = TeleportTab:NewSection("เลือกสถานที่")

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
    LocationSection:NewButton(loc.name, "กดเพื่อวาร์ปไปยัง " .. loc.name, function()
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        root.CFrame = loc.cframe
    end)
end

-- ================= Misc Tab =================
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("ฟีเจอร์เสริม")

-- Noclip variables
local noclipEnabled = false
local noclipConnection

local function EnableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function DisableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local character = player.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Fly variables
local flying = false
local speed = 50
local bodyGyro
local bodyVelocity

local ctrl = {f = 0, b = 0, l = 0, r = 0}

local userInputBeganConn
local userInputEndedConn

local flyConnection

local function StartFly()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    humanoid.PlatformStand = true

    bodyGyro = Instance.new("BodyGyro", root)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = root.CFrame

    bodyVelocity = Instance.new("BodyVelocity", root)
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

    -- ฟังชั่นจับปุ่ม
    userInputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.W then ctrl.f = 1
        elseif key == Enum.KeyCode.S then ctrl.b = -1
        elseif key == Enum.KeyCode.A then ctrl.l = -1
        elseif key == Enum.KeyCode.D then ctrl.r = 1
        elseif key == Enum.KeyCode.Space then
            bodyVelocity.velocity = Vector3.new(0, speed, 0) -- บินขึ้น
        elseif key == Enum.KeyCode.LeftControl then
            bodyVelocity.velocity = Vector3.new(0, -speed, 0) -- บินลง
        end
    end)

    userInputEndedConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.W then ctrl.f = 0
        elseif key == Enum.KeyCode.S then ctrl.b = 0
        elseif key == Enum.KeyCode.A then ctrl.l = 0
        elseif key == Enum.KeyCode.D then ctrl.r = 0
        elseif key == Enum.KeyCode.Space or key == Enum.KeyCode.LeftControl then
            bodyVelocity.velocity = Vector3.new(0, 0, 0) -- หยุดขึ้นลงเมื่อปล่อย
        end
    end)

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
            if userInputBeganConn then userInputBeganConn:Disconnect() end
            if userInputEndedConn then userInputEndedConn:Disconnect() end
            flyConnection:Disconnect()
            return
        end

        local camCF = workspace.CurrentCamera.CFrame
        local moveVector = (camCF.LookVector * (ctrl.f + ctrl.b)) + (camCF.RightVector * (ctrl.r + ctrl.l))
        if moveVector.Magnitude > 0 then
            bodyVelocity.velocity = moveVector.Unit * speed + Vector3.new(0, bodyVelocity.velocity.Y, 0)
        else
            bodyVelocity.velocity = Vector3.new(0, bodyVelocity.velocity.Y, 0)
        end
        bodyGyro.cframe = camCF
    end)
end

local function StopFly()
    flying = false
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if userInputBeganConn then userInputBeganConn:Disconnect() end
    if userInputEndedConn then userInputEndedConn:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
end

-- Invisible variables
local invisibleEnabled = false
local function SetInvisible(enabled)
    local character = player.Character
    if not character then return end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = enabled and 1 or 0
            part.CanCollide = not enabled
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = enabled and 1 or 0
        elseif part:IsA("ParticleEmitter") or part:IsA("Light") then
            part.Enabled = not enabled
        end
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.NameDisplayDistance = enabled and 0 or 100 -- ซ่อน/แสดงชื่อ
    end
end

-- สร้าง Toggle สำหรับ Noclip
MiscSection:NewToggle("เปิด/ปิด Noclip", "เปิดหรือปิดโหมดเดินทะลุ", function(value)
    noclipEnabled = value
    if noclipEnabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)

-- สร้าง Toggle สำหรับ Fly
MiscSection:NewToggle("เปิด/ปิด Fly", "กดเพื่อบินขึ้น-ลง (ใช้ W A S D + Space + Ctrl)", function(value)
    flying = value
    if flying then
        StartFly()
    else
        StopFly()
    end
end)

-- สร้าง Toggle สำหรับ Invisible
MiscSection:NewToggle("เปิด/ปิด ล่องหน", "ทำให้ตัวละครล่องหนและไม่ชน", function(value)
    invisibleEnabled = value
    SetInvisible(invisibleEnabled)
end)
