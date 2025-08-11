-- 📌 ต้องรันใน LocalScript เท่านั้น (เช่น ใส่ใน StarterPlayerScripts)

local success, lib = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua")
end)
if not success or not lib or lib == "" then
    warn("ไม่สามารถโหลด Kavo UI Library ได้")
    return
end

local Library = loadstring(lib)()
local Window = Library.CreateLib("JustHub", "BloodTheme")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ================= Teleport Tab =================
local TeleportTab = Window:NewTab("Teleport")
local LocationSection = TeleportTab:NewSection("เลือกสถานที่")
local TeleportToPlayerSection = TeleportTab:NewSection("เทเลพอร์ตไปยังผู้เล่น")

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

-- ฟังก์ชัน Teleport ป้องกันตกแมพ
local function safeTeleport(targetCFrame)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- ตรวจสอบตำแหน่งบนพื้น (ประมาณ)
    local rayOrigin = targetCFrame.Position + Vector3.new(0, 50, 0)
    local rayDirection = Vector3.new(0, -100, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult and raycastResult.Position then
        -- ถ้ามีพื้นอยู่ด้านล่าง ก็เทเลพอร์ตไปพื้นนั้น (สูงกว่าพื้น 5 studs)
        local safePos = raycastResult.Position + Vector3.new(0, 5, 0)
        root.CFrame = CFrame.new(safePos) * CFrame.new(targetCFrame.LookVector)
    else
        warn("ไม่สามารถเทเลพอร์ต: ไม่มีพื้นรองรับตำแหน่งนี้")
    end
end

-- สร้าง Dropdown รายชื่อผู้เล่นให้เลือก teleport ไป
local function updatePlayerList()
    TeleportToPlayerSection:Clear() -- ล้างปุ่มเก่าออกก่อน
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            TeleportToPlayerSection:NewButton(plr.Name, "Teleport ไปหา " .. plr.Name, function()
                local targetChar = plr.Character
                if targetChar then
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        safeTeleport(targetRoot.CFrame + Vector3.new(0, 5, 0))
                    else
                        warn(plr.Name .. " ไม่มี HumanoidRootPart")
                    end
                else
                    warn(plr.Name .. " ไม่มีตัวละคร")
                end
            end)
        end
    end
end

-- เรียกตอนเริ่มแรก และสามารถเรียกใหม่ได้ถ้าผู้เล่นเปลี่ยน
updatePlayerList()

Players.PlayerAdded:Connect(function()
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList()
end)

-- ================= Misc Tab =================
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("ฟีเจอร์เสริม")

-- Noclip
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

-- Invisible
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

-- God Mode (สุขภาพไม่ลด)
local godmodeEnabled = false
local function SetGodMode(enabled)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if enabled then
        humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        humanoid.Health = humanoid.MaxHealth
    end
end

-- Fly
local flying = false
local speed = 50
local bodyGyro
local bodyVelocity
local flyConnection
local ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}

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

    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.W then
            ctrl.f = 1
        elseif key == Enum.KeyCode.S then
            ctrl.b = -1
        elseif key == Enum.KeyCode.A then
            ctrl.l = -1
        elseif key == Enum.KeyCode.D then
            ctrl.r = 1
        elseif key == Enum.KeyCode.Space then
            ctrl.u = 1
        elseif key == Enum.KeyCode.LeftShift then
            ctrl.d = -1
        end
    end

    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.W then
            ctrl.f = 0
        elseif key == Enum.KeyCode.S then
            ctrl.b = 0
        elseif key == Enum.KeyCode.A then
            ctrl.l = 0
        elseif key == Enum.KeyCode.D then
            ctrl.r = 0
        elseif key == Enum.KeyCode.Space then
            ctrl.u = 0
        elseif key == Enum.KeyCode.LeftShift then
            ctrl.d = 0
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
            if flyConnection then flyConnection:Disconnect() end
            return
        end

        local moveVec = (workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) +
                        (workspace.CurrentCamera.CFrame.RightVector * (ctrl.r + ctrl.l)) +
                        Vector3.new(0, ctrl.u + ctrl.d, 0)

        if moveVec.Magnitude > 0 then
            bodyVelocity.velocity = moveVec.Unit * speed
            bodyGyro.cframe = workspace.CurrentCamera.CFrame
        else
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFly()
    flying = false
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Toggle Fly
MiscSection:NewToggle("เปิด/ปิด Fly", "บินโดยกด W A S D, Space ขึ้น, Shift ลง", function(value)
    flying = value
    if flying then
        StartFly()
    else
        StopFly()
    end
end)

-- Toggle Noclip
MiscSection:NewToggle("เปิด/ปิด Noclip", "เปิดหรือปิดโหมดเดินทะลุ", function(value)
    noclipEnabled = value
    if noclipEnabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)

-- Toggle Invisible
MiscSection:NewToggle("เปิด/ปิด ล่องหน", "ทำให้ตัวละครล่องหนและไม่ชน", function(value)
    invisibleEnabled = value
    SetInvisible(invisibleEnabled)
end)

-- Toggle God Mode
MiscSection:NewToggle("เปิด/ปิด God Mode", "ป้องกันไม่ให้เลือดลด", function(value)
    godmodeEnabled = value
    if godmodeEnabled then
        SetGodMode(true)
    end
end)
