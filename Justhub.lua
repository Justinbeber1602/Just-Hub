local SCRIPT_URL = "https://script.google.com/macros/s/AKfycbzAERdtX5nc_GE0QdJhF-oDcKeBtHsJ02UDnvHIY2n5Wu65dUoLUIOhABxa1Eng22--3Q/exec" 
local WEBHOOK_URL = "https://discord.com/api/webhooks/1485633903711617115/cxUNwhz1SIz5gNPjiRTnulqpOU9rA8N0N13uCROx3yzzNwZboM6dcp_QSGw5NYADIpyv"

local p = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local timeLeft = 0
local isLifetime = false
local autoFarm = false 
local speed = 0.4 
local pos_brew = Vector3.new(-4997.778, 6.204, -794.327)
local pos_serve = Vector3.new(-4995.671, 6.385, -759.613)

-- === [ 1. ระบบดึงและหักเวลา ] ===
local function syncTime(action, seconds)
    local url = SCRIPT_URL .. "?user=" .. p.Name .. "&action=" .. action .. "&use=" .. (seconds or 0)
    local success, res = pcall(function() return game:HttpGet(url) end)
    if success then
        if res == "not_found" then p:Kick("ไม่พบชื่อในระบบ") end
        if res == "true" then isLifetime = true return end
        timeLeft = (tonumber(res) or 0) * 3600
        return true
    end
    return false
end

-- เช็คสิทธิ์ก่อนเริ่ม
syncTime("check")

-- === [ 2. ระบบ Webhook ] ===
local function sendWebhook(status, detail)
    local data = {
        ["embeds"] = {{
            ["title"] = "🕒 JUST PRESTIGE LOG",
            ["color"] = (status:find("Start")) and 65280 or 16711680,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = p.Name, ["inline"] = true},
                {["name"] = "📢 Status", ["value"] = status, ["inline"] = true},
                {["name"] = "⏳ Info", ["value"] = detail, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%X")},
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=420&height=420&format=png"}
        }}
    }
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

sendWebhook("🚀 Start Session", isLifetime and "สิทธิ์ถาวร" or "เวลาคงเหลือ: " .. string.format("%.2f", timeLeft/3600) .. " ชม.")

-- === [ 3. สร้าง UI (Mobile & PC Optimized) ] ===
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.ResetOnSpawn = false

-- ปุ่มโลโก้ (สำหรับเปิดตอนซ่อน)
local logoBtn = Instance.new("ImageButton", sg)
logoBtn.Size = UDim2.new(0, 45, 0, 45)
logoBtn.Position = UDim2.new(0, 10, 0.5, -22)
logoBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
logoBtn.Image = "rbxassetid://16428383182"
logoBtn.Visible = false
Instance.new("UICorner", logoBtn).CornerRadius = UDim.new(1, 0)

-- หน้าต่างหลัก
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 180, 0, 130) -- เพิ่มที่ว่างให้โชว์เวลา
main.Position = UDim2.new(0.5, -90, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- ระบบลาก UI (Mobile/PC)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
makeDraggable(main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "JUST PRESTIGE"
title.TextColor3 = Color3.fromRGB(255, 165, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local timeDisplay = Instance.new("TextLabel", main)
timeDisplay.Size = UDim2.new(1, 0, 0, 20)
timeDisplay.Position = UDim2.new(0, 0, 0.22, 0)
timeDisplay.Text = "Syncing..."
timeDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
timeDisplay.BackgroundTransparency = 1
timeDisplay.Font = Enum.Font.Gotham

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleBtn.Text = "FARM: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggleBtn)

local hideBtn = Instance.new("TextButton", main)
hideBtn.Size = UDim2.new(0, 20, 0, 20)
hideBtn.Position = UDim2.new(1, -25, 0, 5)
hideBtn.Text = "×"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.BackgroundTransparency = 1

hideBtn.MouseButton1Click:Connect(function() main.Visible = false logoBtn.Visible = true end)
logoBtn.MouseButton1Click:Connect(function() main.Visible = true logoBtn.Visible = false end)

-- === [ 4. ฟังก์ชันการทำงานเดิม (ขยายโซนส้ม + เดิน + กด) ] ===

local function expandOrangeZone()
    task.spawn(function()
        local t = tick()
        while autoFarm and (tick() - t) < 8 do
            for _, v in pairs(p.PlayerGui:GetDescendants()) do
                if v:IsA("Frame") or v:IsA("ImageLabel") then
                    if v.Name:lower():find("orange") or v.Name:lower():find("target") or v.Name:lower():find("sweet") then
                        v.Size = UDim2.new(1, 0, 1, 0)
                        v.Position = UDim2.new(0, 0, 0, 0)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function safeInteract(hold)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - (v.Parent:IsA("Model") and v.Parent:GetModelCFrame().Position or v.Parent.Position)).Magnitude < 12 then
                if fireproximityprompt then fireproximityprompt(v) else
                    v:InputHoldBegin() task.wait(hold or 0.2) v:InputHoldEnd()
                end
                break
            end
        end
    end
end

local function microWarp(target)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    while autoFarm do
        local diff = (Vector3.new(target.X, hrp.Position.Y, target.Z) - hrp.Position)
        if diff.Magnitude > 1.2 then
            hrp.CFrame = hrp.CFrame + (diff.Unit * speed)
            hrp.Velocity = Vector3.new(0,0,0)
        else break end
        task.wait(0.01)
    end
end

-- === [ 5. Main Loop ควบคุมเวลาและการฟาร์ม ] ===
task.spawn(function()
    local saveCounter = 0
    while true do
        task.wait(1)
        
        -- จัดการเวลา
        if isLifetime then
            timeDisplay.Text = "Access: Lifetime"
        elseif timeLeft > 0 then
            timeLeft = timeLeft - 1
            saveCounter = saveCounter + 1
            local h, m, s = math.floor(timeLeft/3600), math.floor((timeLeft%3600)/60), timeLeft%60
            timeDisplay.Text = string.format("Time: %02d:%02d:%02d", h, m, s)
            
            if saveCounter >= 60 then
                syncTime("update", 60)
                saveCounter = 0
            end
        else
            sendWebhook("🛑 Time Expired", "หมดเวลาใช้งาน")
            p:Kick("หมดเวลาการใช้งานแล้วครับ")
            break
        end

        -- จัดการฟาร์ม
        if autoFarm then
            microWarp(pos_brew)
            task.wait(0.5)
            safeInteract(0.2) 
            task.wait(1.5)
            if autoFarm then
                expandOrangeZone()
                task.wait(5) 
            end
            if autoFarm then
                microWarp(pos_serve)
                task.wait(0.5)
                safeInteract(3.6) 
                task.wait(math.random(3, 5))
            end
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    toggleBtn.Text = autoFarm and "FARM: ON" or "FARM: OFF"
    toggleBtn.BackgroundColor3 = autoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(180, 50, 50)
end)

game:BindToClose(function()
    if not isLifetime then syncTime("update", 60) end
end)

print("✅ JUST: Hybrid System Ready!")
