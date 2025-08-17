local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("JustHub", "BloodTheme")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Player
local player: Player = Players.LocalPlayer

-- ================= Teleport Tab =================
local TeleportTab = Window:NewTab("Teleport")
local LocationSection = TeleportTab:NewSection("เลือกสถานที่")

-- กำหนด type ของ location
type Location = {
    name: string,
    cframe: CFrame
}

local locations: {Location} = {
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

for _, loc: Location in ipairs(locations) do
    LocationSection:NewButton(loc.name, "กดเพื่อวาร์ปไปยัง " .. loc.name, function()
        local character = player.Character or player.CharacterAdded:Wait()
        local root: BasePart = character:WaitForChild("HumanoidRootPart") :: BasePart
        root.CFrame = loc.cframe
    end)
end

-- ================= Misc Tab =================
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("ฟีเจอร์เสริม")

-- Noclip variables
local noclipEnabled = false
local noclipConnection: RBXScriptConnection? = nil

local function EnableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local character = player.Character
        if character then
            for _, part in character:GetChildren() do
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
        for _, part in character:GetChildren() do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Toggle Noclip
MiscSection:NewToggle("เปิด/ปิด Noclip", "เปิดหรือปิดโหมดเดินทะลุ", function(value: boolean)
    noclipEnabled = value
    if noclipEnabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)
