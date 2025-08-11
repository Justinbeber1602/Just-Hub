-- 📌 ต้องรันใน LocalScript เท่านั้น
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
local UserInputService = game:GetService("UserinputService") or game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- 안전값 (ไม่ให้ตกแมพ)
local MIN_SAFE_Y = 10
local TELEPORT_RAISE = 5 -- ยกสูงขึ้น 5 studs เวลาวาร์ป เพื่อไม่ให้ติดพื้น/ตก

-- ================= Teleport Tab (ตำแหน่งสำเร็จรูป) =================
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
        local pos = loc.cframe.Position
        if pos.Y < MIN_SAFE_Y then pos = Vector3.new(pos.X, MIN_SAFE_Y, pos.Z) end
        root.CFrame = CFrame.new(pos + Vector3.new(0, TELEPORT_RAISE, 0))
    end)
end

-- ================= Teleport To Player Section =================
local TeleportPlayersSection = TeleportTab:NewSection("วาร์ปไปผู้เล่น")

-- เก็บปุ่มเพื่อจะลบเวลาผู้เล่นออก
local playerButtons = {}

local function safeRemoveButton(btn)
    if not btn then return end
    pcall(function()
        if type(btn.Remove) == "function" then
            btn:Remove()
        elseif type(btn.remove) == "function" then
            btn:remove()
        end
    end)
end

local function createPlayerButton(p)
    if p == player then return end
    -- สร้างปุ่มใหม่
    local ok, btn = pcall(function()
        return TeleportPlayersSection:NewButton(p.Name, "วาร์ปไปยัง " .. p.Name, function()
            if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                warn("ผู้เล่นเป้าหมายไม่มีตัวละคร")
                return
            end
            local targetPos = p.Character.HumanoidRootPart.Position
            if targetPos.Y < MIN_SAFE_Y then targetPos = Vector3.new(targetPos.X, MIN_SAFE_Y, targetPos.Z) end
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            root.CFrame = CFrame.new(targetPos + Vector3.new(0, TELEPORT_RAISE, 0))
        end)
    end)
    if ok and btn then
        playerButtons[p.UserId] = btn
    end
end

local function refreshPlayerButtons()
    -- ลบปุ่มเก่าทั้งหมดก่อน แล้วสร้างใหม่
    for id, btn in pairs(playerButtons) do
        safeRemoveButton(btn)
        playerButtons[id] = nil
    end
    for _, p in ipairs(Players:GetPlayers()) do
        createPlayerButton(p)
    end
end

-- สร้างตอนเริ่ม
refreshPlayerButtons()

-- อัพเดตเมื่มีผู้เล่นเข้า/ออก
Players.PlayerAdded:Connect(function(p)
    -- รอให้ตัวละครโหลดก่อนสร้างปุ่มก็ได้ (ไม่จำเป็น)
    createPlayerButton(p)
end)

Players.PlayerRemoving:Connect(function(p)
    if playerButtons[p.UserId] then
        safeRemoveButton(playerButtons[p.UserId])
        playerButtons[p.UserId] = nil
    end
end)

-- ================= Misc Tab (Noclip / Invisible / Godmode / Fly) =================
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("ฟีเจอร์เสริม")

-- Noclip
local noclipEnabled = false
local noclipConnection
local function EnableNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end
local function DisableNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    local char = player.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
MiscSection:NewToggle("เปิด/ปิด Noclip", "เปิดหรือปิดโหมดเดินทะลุ", function(v)
    noclipEnabled = v
    if v then EnableNoclip() else DisableNoclip() end
end)

-- Invisible (local) — NOTE: ถ้าต้องการให้คนอื่นมองไม่เห็น ต้องใช้ Server script (อธิบายไว้ก่อนหน้านี้)
local invisibleEnabled = false
local function SetInvisible(enabled)
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = enabled and 1 or 0
            part.CanCollide = not enabled
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = enabled and 1 or 0
        elseif part:IsA("ParticleEmitter") or part:IsA("Light") then
            part.Enabled = not enabled
        end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.NameDisplayDistance = enabled and 0 or 100
    end
end
MiscSection:NewToggle("เปิด/ปิด ล่องหน (local)", "ล่องหนเฉพาะเครื่องเราเอง", function(v)
    invisibleEnabled = v
    SetInvisible(v)
end)

-- Godmode (local): รีเซ็ตพลังชีวิตทันทีเมื่อถูกทำร้าย (local-only, server อาจเขียนทับ)
local godmodeEnabled = false
local godConnection
local function EnableGodmode()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    -- ตัด connection เก่า
    if godConnection then godConnection:Disconnect() godConnection = nil end
    humanoid.Health = humanoid.MaxHealth
    godConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if godmodeEnabled and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end
local function DisableGodmode()
    if godConnection then godConnection:Disconnect() godConnection = nil end
end
MiscSection:NewToggle("เปิด/ปิด God Mode (local)", "พยายามคง HP เต็ม (local only)", function(v)
    godmodeEnabled = v
    if v then EnableGodmode() else DisableGodmode() end
end)

-- Fly (space ขึ้น, shift ลง, WASD บังคับ)
local flying = false
local flySpeed = 60
local bodyGyro, bodyVelocity
local flyConnection
local ctrl = {f=0,b=0,l=0,r=0,up=0,down=0}

local function StartFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    humanoid.PlatformStand = true

    bodyGyro = Instance.new("BodyGyro", root)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.CFrame = root.CFrame

    bodyVelocity = Instance.new("BodyVelocity", root)
    bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
            if humanoid then humanoid.PlatformStand = false end
            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            return
        end

        local cam = Workspace.CurrentCamera
        local moveVector = (cam.CFrame.LookVector * (ctrl.f + ctrl.b)) + (cam.CFrame.RightVector * (ctrl.r + ctrl.l))
        local vertical = (ctrl.up + ctrl.down)
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * flySpeed
        else
            moveVector = Vector3.new(0,0,0)
        end
        bodyVelocity.Velocity = moveVector + Vector3.new(0, vertical * flySpeed, 0)
        if bodyGyro then bodyGyro.CFrame = cam.CFrame end
    end)
end

local function StopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

-- ควบคุม input สำหรับบิน
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 1
    elseif key == Enum.KeyCode.S then ctrl.b = -1
    elseif key == Enum.KeyCode.A then ctrl.l = -1
    elseif key == Enum.KeyCode.D then ctrl.r = 1
    elseif key == Enum.KeyCode.Space then ctrl.up = 1
    elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then ctrl.down = -1
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 0
    elseif key == Enum.KeyCode.S then ctrl.b = 0
    elseif key == Enum.KeyCode.A then ctrl.l = 0
    elseif key == Enum.KeyCode.D then ctrl.r = 0
    elseif key == Enum.KeyCode.Space then ctrl.up = 0
    elseif key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then ctrl.down = 0
    end
end)

MiscSection:NewToggle("เปิด/ปิด Fly", "W/A/S/D + Space ขึ้น + Shift ลง", function(v)
    flying = v
    if v then StartFly() else StopFly() end
end)

-- ================ จัดการกรณี respawn / รี-เช็ตสถานะ ================
-- เมื่อตัวละครถูก spawn ใหม่ ให้รีเซ็ตสถานะบางอย่าง (เช่น invisible/godmode/noclip)
local function OnCharacterAdded(char)
    -- รี-apply invisible ถ้าตั้งไว้
    if invisibleEnabled then
        SetInvisible(true)
    end
    -- รี-apply noclip ถ้าตั้งไว้
    if noclipEnabled then
        -- immediate set non-collide
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    -- รี-apply godmode
    if godmodeEnabled then
        EnableGodmode()
    end
end

player.CharacterAdded:Connect(OnCharacterAdded)
if player.Character then
    OnCharacterAdded(player.Character)
end

-- จบบริบูรณ์
