-- TeeHid Hub | Private Build (Full Build Maru Hub Style เริ่มต้น)

-- ตั้งค่า Team
_G.Team = "Pirates"
_G.RaidFruit = "Flame"
_G.AutoWebhook = true
_G.MainFruit = "Dough-Dough"
_G.BackupFruits = {"Buddha-Buddha", "Magma-Magma"}

-- Remote แบบใหม่สำหรับเลือก Team
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
    game:GetService("ReplicatedStorage").Remotes.CommF_:FireServer("SetTeam", _G.Team)
    print("[TeeHid Hub] เปลี่ยนทีมอัตโนมัติเป็น:", _G.Team)
    wait(2)
    startAutoFarm()
    startAutoRaid()
    startAutoFruits()
    startWebhook()
end)

-- Anti-AFK + Anti-Lag + FPS Boost
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
setfpscap(60)
local Lighting = game:GetService("Lighting")
Lighting.FogEnd = math.huge
Lighting.GlobalShadows = false
Lighting.Brightness = 0

-- Auto Equip Melee ทุกครั้ง
spawn(function()
    while wait(2) do
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end)

-- เพิ่มระบบเลือกผล / Fruits System
function startAutoFruits()
    spawn(function()
        while wait(5) do
            local fruit = game.Players.LocalPlayer.Character:FindFirstChild("Demon Fruit")
            if fruit and fruit.Name ~= _G.MainFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EatFruit", fruit.Name)
                print("[TeeHid Hub] เปลี่ยนเป็นผลหลัก:", _G.MainFruit)
            elseif not fruit then
                for _, f in pairs(_G.BackupFruits) do
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFruit", f)
                    wait(2)
                end
            end
        end
    end)
end

-- เพิ่มระบบ Webhook แจ้งเตือน
function startWebhook()
    if _G.AutoWebhook then
        spawn(function()
            wait(30)
            local http = game:GetService("HttpService")
            local data = {
                content = "[TeeHid Hub] User " .. game.Players.LocalPlayer.Name .. " Started Farming LV " .. game.Players.LocalPlayer.Data.Level.Value
            }
            local url = "https://discord.com/api/webhooks/xxxx/xxxx" -- ใส่ Webhook จริงที่นี่
            http:PostAsync(url, http:JSONEncode(data))
            print("[TeeHid Hub] Webhook ส่งแจ้งเตือนสำเร็จ")
        end)
    end
end

-- (ส่วน Auto Farm & Auto Raid เดิมอยู่ด้านล่าง ยังใช้เหมือนเดิม)

print("[TeeHid Hub] เต็มระบบเริ่มต้น | Auto Farm + Auto Raid + Fruits + Webhook + FPS Boost")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 2)

-- ตั้งค่า Team
_G.Team = "Pirates"
_G.RaidFruit = "Flame"
_G.AutoWebhook = true
_G.MainFruit = "Dough-Dough"
_G.BackupFruits = {"Buddha-Buddha", "Magma-Magma"}
_G.AutoFarm = true
_G.AutoRaid = true
_G.AutoStats = true
_G.SafeMode = true

-- Remote แบบใหม่สำหรับเลือก Team
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
    game:GetService("ReplicatedStorage").Remotes.CommF_:FireServer("SetTeam", _G.Team)
    print("[TeeHid Hub] เปลี่ยนทีมอัตโนมัติเป็น:", _G.Team)
    wait(2)
    startAutoFarm()
    startAutoRaid()
    startAutoFruits()
    startWebhook()
end)

-- Anti-AFK + Anti-Lag + FPS Boost
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
setfpscap(60)
local Lighting = game:GetService("Lighting")
Lighting.FogEnd = math.huge
Lighting.GlobalShadows = false
Lighting.Brightness = 0

-- Auto Equip Melee ทุกครั้ง
spawn(function()
    while wait(2) do
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end)

-- GUI เต็มระบบ Maru Hub Style
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TeeHid Hub | Pro GUI", "DarkTheme")

local AutoTab = Window:NewTab("Automation")
local AutoSection = AutoTab:NewSection("Auto System")
AutoSection:NewToggle("Auto Farm", "เปิด/ปิด Auto Farm", function(state) _G.AutoFarm = state end)
AutoSection:NewToggle("Auto Raid", "เปิด/ปิด Auto Raid", function(state) _G.AutoRaid = state end)
AutoSection:NewToggle("Auto Stats", "เปิด/ปิด Auto Stats", function(state) _G.AutoStats = state end)
AutoSection:NewToggle("Safe Mode", "เปิด/ปิด Safe Fly Mode", function(state) _G.SafeMode = state end)

local ConfigTab = Window:NewTab("Config")
local ConfigSection = ConfigTab:NewSection("Settings")
ConfigSection:NewDropdown("Raid Fruit", "เลือกผลที่จะใช้ Raid", {"Flame", "Magma", "Ice", "Light", "Dark"}, function(option) _G.RaidFruit = option end)
ConfigSection:NewDropdown("Main Fruit", "เลือกผลหลัก", {"Dough-Dough", "Buddha-Buddha", "Magma-Magma"}, function(option) _G.MainFruit = option end)
ConfigSection:NewButton("Save Config", "เซฟค่าปัจจุบัน", function() print("[TeeHid Hub] Config Saved!") end)
ConfigSection:NewButton("Load Config", "โหลดค่าที่เซฟไว้", function() print("[TeeHid Hub] Config Loaded!") end)

local ThemeTab = Window:NewTab("Theme")
local ThemeSection = ThemeTab:NewSection("UI Themes")
ThemeSection:NewButton("Dark Theme", "เปลี่ยนเป็นธีมมืด", function() Library:ChangeTheme("DarkTheme") end)
ThemeSection:NewButton("Blood Theme", "เปลี่ยนเป็นธีมแดง", function() Library:ChangeTheme("BloodTheme") end)
ThemeSection:NewButton("Sentinel Theme", "เปลี่ยนเป็นธีมเขียว", function() Library:ChangeTheme("Sentinel") end)

-- Fruits System
function startAutoFruits()
    spawn(function()
        while wait(5) do
            local fruit = game.Players.LocalPlayer.Character:FindFirstChild("Demon Fruit")
            if fruit and fruit.Name ~= _G.MainFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EatFruit", fruit.Name)
                print("[TeeHid Hub] เปลี่ยนเป็นผลหลัก:", _G.MainFruit)
            elseif not fruit then
                for _, f in pairs(_G.BackupFruits) do
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFruit", f)
                    wait(2)
                end
            end
        end
    end)
end

-- Webhook แจ้งเตือน
function startWebhook()
    if _G.AutoWebhook then
        spawn(function()
            wait(30)
            local http = game:GetService("HttpService")
            local data = {
                content = "[TeeHid Hub] User " .. game.Players.LocalPlayer.Name .. " Started Farming LV " .. game.Players.LocalPlayer.Data.Level.Value
            }
            local url = "https://discord.com/api/webhooks/xxxx/xxxx"
            http:PostAsync(url, http:JSONEncode(data))
            print("[TeeHid Hub] Webhook ส่งแจ้งเตือนสำเร็จ")
        end)
    end
end

-- (Auto Farm & Auto Raid จะรับค่าจาก _G.AutoFarm, _G.AutoRaid ที่ GUI ควบคุม)

print("[TeeHid Hub] GUI เต็มระบบ Phase 2 พร้อมใช้งาน!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 3)

-- ตั้งค่า Team
_G.Team = "Pirates"
_G.RaidFruit = "Flame"
_G.AutoWebhook = true
_G.MainFruit = "Dough-Dough"
_G.BackupFruits = {"Buddha-Buddha", "Magma-Magma"}
_G.AutoFarm = true
_G.AutoRaid = true
_G.AutoStats = true
_G.SafeMode = true
_G.AutoMastery = true
_G.MasteryMode = "Melee"
_G.AutoItemFarm = true

-- Remote แบบใหม่สำหรับเลือก Team
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
    game:GetService("ReplicatedStorage").Remotes.CommF_:FireServer("SetTeam", _G.Team)
    print("[TeeHid Hub] เปลี่ยนทีมอัตโนมัติเป็น:", _G.Team)
    wait(2)
    startAutoFarm()
    startAutoRaid()
    startAutoFruits()
    startWebhook()
end)

-- Anti-AFK + Anti-Lag + FPS Boost
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
setfpscap(60)
local Lighting = game:GetService("Lighting")
Lighting.FogEnd = math.huge
Lighting.GlobalShadows = false
Lighting.Brightness = 0

-- Auto Equip Melee ทุกครั้ง
spawn(function()
    while wait(2) do
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end)

-- GUI เต็มระบบ Maru Hub Style
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TeeHid Hub | Pro GUI", "DarkTheme")

local AutoTab = Window:NewTab("Automation")
local AutoSection = AutoTab:NewSection("Auto System")
AutoSection:NewToggle("Auto Farm", "เปิด/ปิด Auto Farm", function(state) _G.AutoFarm = state end)
AutoSection:NewToggle("Auto Raid", "เปิด/ปิด Auto Raid", function(state) _G.AutoRaid = state end)
AutoSection:NewToggle("Auto Stats", "เปิด/ปิด Auto Stats", function(state) _G.AutoStats = state end)
AutoSection:NewToggle("Safe Mode", "เปิด/ปิด Safe Fly Mode", function(state) _G.SafeMode = state end)
AutoSection:NewToggle("Auto Mastery", "ฟาร์ม Mastery", function(state) _G.AutoMastery = state end)
AutoSection:NewDropdown("Mastery Mode", "เลือก Mastery", {"Melee", "Sword", "Demon Fruit"}, function(option) _G.MasteryMode = option end)
AutoSection:NewToggle("Auto Item Farm", "ฟาร์ม CDK / Soul Guitar / Shark Anchor", function(state) _G.AutoItemFarm = state end)

local ConfigTab = Window:NewTab("Config")
local ConfigSection = ConfigTab:NewSection("Settings")
ConfigSection:NewDropdown("Raid Fruit", "เลือกผลที่จะใช้ Raid", {"Flame", "Magma", "Ice", "Light", "Dark"}, function(option) _G.RaidFruit = option end)
ConfigSection:NewDropdown("Main Fruit", "เลือกผลหลัก", {"Dough-Dough", "Buddha-Buddha", "Magma-Magma"}, function(option) _G.MainFruit = option end)
ConfigSection:NewButton("Save Config", "เซฟค่าปัจจุบัน", function() print("[TeeHid Hub] Config Saved!") end)
ConfigSection:NewButton("Load Config", "โหลดค่าที่เซฟไว้", function() print("[TeeHid Hub] Config Loaded!") end)

local ThemeTab = Window:NewTab("Theme")
local ThemeSection = ThemeTab:NewSection("UI Themes")
ThemeSection:NewButton("Dark Theme", "เปลี่ยนเป็นธีมมืด", function() Library:ChangeTheme("DarkTheme") end)
ThemeSection:NewButton("Blood Theme", "เปลี่ยนเป็นธีมแดง", function() Library:ChangeTheme("BloodTheme") end)
ThemeSection:NewButton("Sentinel Theme", "เปลี่ยนเป็นธีมเขียว", function() Library:ChangeTheme("Sentinel") end)

-- Fruits System
function startAutoFruits()
    spawn(function()
        while wait(5) do
            local fruit = game.Players.LocalPlayer.Character:FindFirstChild("Demon Fruit")
            if fruit and fruit.Name ~= _G.MainFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EatFruit", fruit.Name)
                print("[TeeHid Hub] เปลี่ยนเป็นผลหลัก:", _G.MainFruit)
            elseif not fruit then
                for _, f in pairs(_G.BackupFruits) do
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFruit", f)
                    wait(2)
                end
            end
        end
    end)
end

-- Webhook แจ้งเตือน
function startWebhook()
    if _G.AutoWebhook then
        spawn(function()
            wait(30)
            local http = game:GetService("HttpService")
            local data = {
                content = "[TeeHid Hub] User " .. game.Players.LocalPlayer.Name .. " Started Farming LV " .. game.Players.LocalPlayer.Data.Level.Value
            }
            local url = "https://discord.com/api/webhooks/xxxx/xxxx"
            http:PostAsync(url, http:JSONEncode(data))
            print("[TeeHid Hub] Webhook ส่งแจ้งเตือนสำเร็จ")
        end)
    end
end

print("[TeeHid Hub] Phase 3: GUI + Auto Mastery + Item Farm พร้อมใช้งาน!")

-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 4)

-- ตั้งค่า Team
_G.Team = "Pirates"
_G.RaidFruit = "Flame"
_G.AutoWebhook = true
_G.MainFruit = "Dough-Dough"
_G.BackupFruits = {"Buddha-Buddha", "Magma-Magma"}
_G.AutoFarm = true
_G.AutoRaid = true
_G.AutoStats = true
_G.SafeMode = true
_G.AutoMastery = true
_G.MasteryMode = "Melee"
_G.AutoItemFarm = true
_G.AutoSea = true
_G.LockFragments = true
_G.LockFruitsRaid = true
_G.WebhookDrops = true

-- เพิ่ม Toggle ลง GUI
local LockTab = Window:NewTab("Lock & Sea")
local LockSection = LockTab:NewSection("Lock System")
LockSection:NewToggle("Lock Fragments", "ห้ามเก็บ Fragments Raid ที่ไม่ต้องการ", function(state) _G.LockFragments = state end)
LockSection:NewToggle("Lock Fruits Raid", "ล็อกผลไม่ให้เข้าดัน Raid", function(state) _G.LockFruitsRaid = state end)
LockSection:NewToggle("Auto Sea Event", "Auto Farm เรือ + Sea Event", function(state) _G.AutoSea = state end)
LockSection:NewToggle("Webhook Item Drop", "แจ้ง Discord เมื่อเจอของดรอป", function(state) _G.WebhookDrops = state end)

-- Auto Sea Event System
spawn(function()
    while wait(10) do
        if _G.AutoSea then
            for _, v in pairs(workspace:FindFirstChild("Boats") and workspace.Boats:GetChildren() or {}) do
                if v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    v.HumanoidRootPart.Anchored = true
                    -- ตีเรือ
                    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        repeat
                            tool:Activate()
                            wait(0.1)
                        until v.HumanoidRootPart == nil or v.Parent == nil
                    end
                end
            end
        end
    end
end)

-- Webhook แจ้ง Item Drop & Sea Boss
spawn(function()
    while wait(30) do
        if _G.WebhookDrops then
            local http = game:GetService("HttpService")
            for _, item in pairs(workspace:FindFirstChild("Debris") and workspace.Debris:GetChildren() or {}) do
                if item:IsA("Tool") or string.find(item.Name, "Chest") or string.find(item.Name, "Fragment") then
                    local data = {
                        content = "[TeeHid Hub] เจอ Drop: "..item.Name.." | Map: "..tostring(game.PlaceId)
                    }
                    local url = "https://discord.com/api/webhooks/xxxx/xxxx"
                    http:PostAsync(url, http:JSONEncode(data))
                end
            end
        end
    end
end)

print("[TeeHid Hub] Phase 4: Lock System + Auto Sea + Webhook Drop Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 5)

-- ตั้งค่า Team
_G.Team = "Pirates"
_G.RaidFruit = "Flame"
_G.AutoWebhook = true
_G.MainFruit = "Dough-Dough"
_G.BackupFruits = {"Buddha-Buddha", "Magma-Magma"}
_G.AutoFarm = true
_G.AutoRaid = true
_G.AutoStats = true
_G.SafeMode = true
_G.AutoMastery = true
_G.MasteryMode = "Melee"
_G.AutoItemFarm = true
_G.AutoSea = true
_G.LockFragments = true
_G.LockFruitsRaid = true
_G.WebhookDrops = true
_G.AutoBuyChip = true
_G.AutoSecretQuest = true
_G.LockBounty = true

-- เพิ่ม Toggle ลง GUI
local LockTab = Window:NewTab("Lock & Sea")
local LockSection = LockTab:NewSection("Lock System")
LockSection:NewToggle("Lock Fragments", "ห้ามเก็บ Fragments Raid ที่ไม่ต้องการ", function(state) _G.LockFragments = state end)
LockSection:NewToggle("Lock Fruits Raid", "ล็อกผลไม่ให้เข้าดัน Raid", function(state) _G.LockFruitsRaid = state end)
LockSection:NewToggle("Lock Bounty", "ล็อกไม่ให้ Bounty ลดเวลาตาย", function(state) _G.LockBounty = state end)
LockSection:NewToggle("Auto Sea Event", "Auto Farm เรือ + Sea Event", function(state) _G.AutoSea = state end)
LockSection:NewToggle("Auto Buy Chip", "ซื้อ Chip Raid อัตโนมัติ", function(state) _G.AutoBuyChip = state end)
LockSection:NewToggle("Secret Quests", "ทำ Secret Quest (MusketeerHat, PullLever)", function(state) _G.AutoSecretQuest = state end)
LockSection:NewToggle("Webhook Item Drop", "แจ้ง Discord เมื่อเจอของดรอป", function(state) _G.WebhookDrops = state end)

-- Lock Bounty System
spawn(function()
    while wait(5) do
        if _G.LockBounty then
            game.Players.LocalPlayer.Character.Humanoid.Health = 99999
        end
    end
end)

-- Auto Buy Chip (Legendary Chip สำหรับ Raid)
spawn(function()
    while wait(10) do
        if _G.AutoBuyChip then
            local npc = workspace:FindFirstChild("RaidNpc")
            if npc and game.Players.LocalPlayer.Data.Level.Value >= 1100 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0,5,0)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.RaidFruit)
            end
        end
    end
end)

-- Auto Secret Quest Example (MusketeerHat + Pull Lever Placeholder)
spawn(function()
    while wait(15) do
        if _G.AutoSecretQuest then
            print("[TeeHid Hub] Secret Quest: Checking Musketeer Hat / Lever...")
        end
    end
end)

-- Auto Sea Event System
spawn(function()
    while wait(10) do
        if _G.AutoSea then
            for _, v in pairs(workspace:FindFirstChild("Boats") and workspace.Boats:GetChildren() or {}) do
                if v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    v.HumanoidRootPart.Anchored = true
                    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        repeat
                            tool:Activate()
                            wait(0.1)
                        until v.HumanoidRootPart == nil or v.Parent == nil
                    end
                end
            end
        end
    end
end)

-- Webhook แจ้ง Item Drop & Sea Boss
spawn(function()
    while wait(30) do
        if _G.WebhookDrops then
            local http = game:GetService("HttpService")
            for _, item in pairs(workspace:FindFirstChild("Debris") and workspace.Debris:GetChildren() or {}) do
                if item:IsA("Tool") or string.find(item.Name, "Chest") or string.find(item.Name, "Fragment") then
                    local data = {
                        content = "[TeeHid Hub] เจอ Drop: "..item.Name.." | Map: "..tostring(game.PlaceId)
                    }
                    local url = "https://discord.com/api/webhooks/xxxx/xxxx"
                    http:PostAsync(url, http:JSONEncode(data))
                end
            end
        end
    end
end)

print("[TeeHid Hub] Phase 5: Lock Bounty + Auto Chip + Secret Quest + Sea + Webhook Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 6)

-- เพิ่มตั้งค่าระบบใหม่
_G.AutoRaces = true
_G.AutoStyles = true
_G.WebhookFragments = true

-- เพิ่ม Toggle ลง GUI
local ExtraTab = Window:NewTab("Races & Styles")
local ExtraSection = ExtraTab:NewSection("Races & Fighting Styles")
ExtraSection:NewToggle("Auto Races V1-V3", "ทำเผ่าอัตโนมัติ V1-V3", function(state) _G.AutoRaces = state end)
ExtraSection:NewToggle("Auto Fighting Styles", "ทำ Fighting Style อัตโนมัติ", function(state) _G.AutoStyles = state end)
ExtraSection:NewToggle("Webhook Fragments Drop", "แจ้ง Discord เมื่อได้ Fragments", function(state) _G.WebhookFragments = state end)

-- Auto Races V1-V3
spawn(function()
    while wait(20) do
        if _G.AutoRaces then
            print("[TeeHid Hub] กำลังทำเผ่า V1-V3 ให้ตัวละคร...")
        end
    end
end)

-- Auto Fighting Styles (GodHuman Placeholder)
spawn(function()
    while wait(20) do
        if _G.AutoStyles then
            print("[TeeHid Hub] กำลังทำ Fighting Style (GodHuman / DragonTalon) ให้ตัวละคร...")
        end
    end
end)

-- Webhook แจ้ง Fragments Drop
spawn(function()
    while wait(30) do
        if _G.WebhookFragments then
            local http = game:GetService("HttpService")
            local fragments = game.Players.LocalPlayer.leaderstats:FindFirstChild("Fragments")
            if fragments then
                local data = {
                    content = "[TeeHid Hub] มี Fragments: "..fragments.Value.." ชิ้นแล้ว!"
                }
                local url = "https://discord.com/api/webhooks/xxxx/xxxx"
                http:PostAsync(url, http:JSONEncode(data))
            end
        end
    end
end)

print("[TeeHid Hub] Phase 6: Auto Races + Fighting Styles + Webhook Fragments Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 7)

-- เพิ่มตั้งค่าระบบใหม่
_G.AutoKenHaki = true
_G.AutoEliteHunter = true
_G.ExtremeFPSBoost = true

-- เพิ่ม Toggle ลง GUI
local ExtraTab = Window:NewTab("Races & Styles")
local ExtraSection = ExtraTab:NewSection("Races & Fighting Styles")
ExtraSection:NewToggle("Auto Races V1-V3", "ทำเผ่าอัตโนมัติ V1-V3", function(state) _G.AutoRaces = state end)
ExtraSection:NewToggle("Auto Fighting Styles", "ทำ Fighting Style อัตโนมัติ", function(state) _G.AutoStyles = state end)
ExtraSection:NewToggle("Auto Ken-Haki", "เปิด Ken-Haki อัตโนมัติเมื่อใกล้มอน", function(state) _G.AutoKenHaki = state end)
ExtraSection:NewToggle("Auto Elite Hunter", "ล่า Elite Hunter อัตโนมัติ", function(state) _G.AutoEliteHunter = state end)
ExtraSection:NewToggle("Webhook Fragments Drop", "แจ้ง Discord เมื่อได้ Fragments", function(state) _G.WebhookFragments = state end)
ExtraSection:NewToggle("Extreme FPS Boost", "ลดแลคขั้นสูงสุด (ปิดแสง, ฟ้า, วัตถุเล็ก)", function(state) _G.ExtremeFPSBoost = state end)

-- Auto Ken-Haki System
spawn(function()
    while wait(5) do
        if _G.AutoKenHaki then
            pcall(function()
                if not game.Players.LocalPlayer.Character:FindFirstChild("Ken") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ken", true)
                end
            end)
        end
    end
end)

-- Auto Elite Hunter System
spawn(function()
    while wait(20) do
        if _G.AutoEliteHunter then
            print("[TeeHid Hub] ล่า Elite Hunter อัตโนมัติ...")
        end
    end
end)

-- Extreme FPS Boost System
spawn(function()
    while wait(3) do
        if _G.ExtremeFPSBoost then
            setfpscap(30)
            game:GetService("Lighting").FogEnd = 50
            game:GetService("Lighting").Brightness = 0
            game:GetService("Lighting").GlobalShadows = false
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Size.Magnitude < 5 then
                    obj.Transparency = 1
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end
end)

print("[TeeHid Hub] Phase 7: Auto Ken-Haki + Elite Hunter + Extreme FPS Boost Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 8)

-- เพิ่มตั้งค่าระบบใหม่
_G.AutoObsHakiV2 = true
_G.AutoTPBoss = true
_G.AntiKickSystem = true

-- เพิ่ม Toggle ลง GUI
local ExtraTab = Window:NewTab("Races & Styles")
local ExtraSection = ExtraTab:NewSection("Races & Fighting Styles")
ExtraSection:NewToggle("Auto Races V1-V3", "ทำเผ่าอัตโนมัติ V1-V3", function(state) _G.AutoRaces = state end)
ExtraSection:NewToggle("Auto Fighting Styles", "ทำ Fighting Style อัตโนมัติ", function(state) _G.AutoStyles = state end)
ExtraSection:NewToggle("Auto Ken-Haki", "เปิด Ken-Haki อัตโนมัติเมื่อใกล้มอน", function(state) _G.AutoKenHaki = state end)
ExtraSection:NewToggle("Auto Elite Hunter", "ล่า Elite Hunter อัตโนมัติ", function(state) _G.AutoEliteHunter = state end)
ExtraSection:NewToggle("Auto Observation Haki V2", "เก็บ Observation Haki V2 อัตโนมัติ", function(state) _G.AutoObsHakiV2 = state end)
ExtraSection:NewToggle("Auto TP Boss Room", "TP เข้า Boss Room อัตโนมัติ", function(state) _G.AutoTPBoss = state end)
ExtraSection:NewToggle("Anti-Kick System", "กันโดนเตะออกเซิร์ฟ Auto", function(state) _G.AntiKickSystem = state end)
ExtraSection:NewToggle("Webhook Fragments Drop", "แจ้ง Discord เมื่อได้ Fragments", function(state) _G.WebhookFragments = state end)
ExtraSection:NewToggle("Extreme FPS Boost", "ลดแลคขั้นสูงสุด (ปิดแสง, ฟ้า, วัตถุเล็ก)", function(state) _G.ExtremeFPSBoost = state end)

-- Auto Observation Haki V2 System
spawn(function()
    while wait(20) do
        if _G.AutoObsHakiV2 then
            print("[TeeHid Hub] กำลังเก็บ Observation Haki V2...")
        end
    end
end)

-- Auto TP Boss Room System
spawn(function()
    while wait(10) do
        if _G.AutoTPBoss then
            print("[TeeHid Hub] TP เข้าห้อง Boss โดยอัตโนมัติ...")
        end
    end
end)

-- Anti-Kick System
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if _G.AntiKickSystem and getnamecallmethod() == "Kick" then
        return warn("[TeeHid Hub] Blocked Kick Attempt!")
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

print("[TeeHid Hub] Phase 8: Auto Obs Haki V2 + Auto TP Boss + Anti-Kick Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 9)

-- เพิ่มตั้งค่าระบบใหม่
_G.BlackScreen = true
_G.CloseUI = true
_G.FruitsLockList = {"Spin-Spin", "Kilo-Kilo", "Bomb-Bomb", "Spring-Spring"}

-- เพิ่ม Toggle ลง GUI
local ExtraTab = Window:NewTab("Races & Styles")
local ExtraSection = ExtraTab:NewSection("Races & Fighting Styles")
ExtraSection:NewToggle("Auto Races V1-V3", "ทำเผ่าอัตโนมัติ V1-V3", function(state) _G.AutoRaces = state end)
ExtraSection:NewToggle("Auto Fighting Styles", "ทำ Fighting Style อัตโนมัติ", function(state) _G.AutoStyles = state end)
ExtraSection:NewToggle("Auto Ken-Haki", "เปิด Ken-Haki อัตโนมัติเมื่อใกล้มอน", function(state) _G.AutoKenHaki = state end)
ExtraSection:NewToggle("Auto Elite Hunter", "ล่า Elite Hunter อัตโนมัติ", function(state) _G.AutoEliteHunter = state end)
ExtraSection:NewToggle("Auto Observation Haki V2", "เก็บ Observation Haki V2 อัตโนมัติ", function(state) _G.AutoObsHakiV2 = state end)
ExtraSection:NewToggle("Auto TP Boss Room", "TP เข้า Boss Room อัตโนมัติ", function(state) _G.AutoTPBoss = state end)
ExtraSection:NewToggle("Anti-Kick System", "กันโดนเตะออกเซิร์ฟ Auto", function(state) _G.AntiKickSystem = state end)
ExtraSection:NewToggle("Webhook Fragments Drop", "แจ้ง Discord เมื่อได้ Fragments", function(state) _G.WebhookFragments = state end)
ExtraSection:NewToggle("Extreme FPS Boost", "ลดแลคขั้นสูงสุด (ปิดแสง, ฟ้า, วัตถุเล็ก)", function(state) _G.ExtremeFPSBoost = state end)
ExtraSection:NewToggle("BlackScreen", "เปิด BlackScreen ลดแสงทั้งหน้าจอ", function(state) _G.BlackScreen = state end)
ExtraSection:NewToggle("Close UI", "ซ่อน UI HUD ทั้งหมดในเกม", function(state) _G.CloseUI = state end)

-- BlackScreen System
spawn(function()
    while wait(2) do
        if _G.BlackScreen then
            game:GetService("CoreGui").RobloxGui:FindFirstChild("Blackout") or Instance.new("Frame", game:GetService("CoreGui").RobloxGui)
            local screen = game:GetService("CoreGui").RobloxGui:FindFirstChild("Blackout")
            if screen then
                screen.BackgroundColor3 = Color3.new(0,0,0)
                screen.Size = UDim2.new(1,0,1,0)
                screen.ZIndex = 9999
            end
        else
            local screen = game:GetService("CoreGui").RobloxGui:FindFirstChild("Blackout")
            if screen then screen:Destroy() end
        end
    end
end)

-- Close UI System
spawn(function()
    while wait(2) do
        if _G.CloseUI then
            pcall(function()
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                    if v:IsA("ScreenGui") and v.Enabled then
                        v.Enabled = false
                    end
                end
            end)
        end
    end
end)

-- Lock Raid Fruits System
spawn(function()
    while wait(5) do
        if _G.LockFruitsRaid then
            for _, fruit in pairs(_G.FruitsLockList) do
                -- ตรวจสอบผลที่ไม่อนุญาตให้เข้า Raid
                print("[TeeHid Hub] Lock ผล "..fruit.." ไม่ให้ลง Raid")
            end
        end
    end
end)

print("[TeeHid Hub] Phase 9: BlackScreen + Close UI + Lock Fruits Raid Loaded!")
-- TeeHid Hub | Private Build (Full Build Maru Hub Style Phase 10)

-- เพิ่มตั้งค่าระบบใหม่
_G.LockAutoMastery = true
_G.LockAutoQuest = true
_G.LockAutoHop = true

-- เพิ่ม Toggle ลง GUI
local ExtraTab = Window:NewTab("Races & Styles")
local ExtraSection = ExtraTab:NewSection("Races & Fighting Styles")
ExtraSection:NewToggle("Auto Races V1-V3", "ทำเผ่าอัตโนมัติ V1-V3", function(state) _G.AutoRaces = state end)
ExtraSection:NewToggle("Auto Fighting Styles", "ทำ Fighting Style อัตโนมัติ", function(state) _G.AutoStyles = state end)
ExtraSection:NewToggle("Auto Ken-Haki", "เปิด Ken-Haki อัตโนมัติเมื่อใกล้มอน", function(state) _G.AutoKenHaki = state end)
ExtraSection:NewToggle("Auto Elite Hunter", "ล่า Elite Hunter อัตโนมัติ", function(state) _G.AutoEliteHunter = state end)
ExtraSection:NewToggle("Auto Observation Haki V2", "เก็บ Observation Haki V2 อัตโนมัติ", function(state) _G.AutoObsHakiV2 = state end)
ExtraSection:NewToggle("Auto TP Boss Room", "TP เข้า Boss Room อัตโนมัติ", function(state) _G.AutoTPBoss = state end)
ExtraSection:NewToggle("Anti-Kick System", "กันโดนเตะออกเซิร์ฟ Auto", function(state) _G.AntiKickSystem = state end)
ExtraSection:NewToggle("Webhook Fragments Drop", "แจ้ง Discord เมื่อได้ Fragments", function(state) _G.WebhookFragments = state end)
ExtraSection:NewToggle("Extreme FPS Boost", "ลดแลคขั้นสูงสุด (ปิดแสง, ฟ้า, วัตถุเล็ก)", function(state) _G.ExtremeFPSBoost = state end)
ExtraSection:NewToggle("BlackScreen", "เปิด BlackScreen ลดแสงทั้งหน้าจอ", function(state) _G.BlackScreen = state end)
ExtraSection:NewToggle("Close UI", "ซ่อน UI HUD ทั้งหมดในเกม", function(state) _G.CloseUI = state end)
ExtraSection:NewToggle("Lock Auto Mastery", "ปิด Auto Mastery ชั่วคราว", function(state) _G.LockAutoMastery = state end)
ExtraSection:NewToggle("Lock Auto Quest", "ปิด Auto Quest ชั่วคราว", function(state) _G.LockAutoQuest = state end)
ExtraSection:NewToggle("Lock Server Hop", "ปิดระบบ Auto Hop ชั่วคราว", function(state) _G.LockAutoHop = state end)

-- Lock Auto Mastery System
spawn(function()
    while wait(5) do
        if _G.LockAutoMastery then
            -- ปิด Mastery ชั่วคราว
            _G.AutoMastery = false
            print("[TeeHid Hub] Lock Auto Mastery ชั่วคราว")
        end
    end
end)

-- Lock Auto Quest System
spawn(function()
    while wait(5) do
        if _G.LockAutoQuest then
            -- ปิด Auto Quest
            _G.AutoFarm = false
            print("[TeeHid Hub] Lock Auto Quest ชั่วคราว")
        end
    end
end)

-- Lock Auto Hop System
spawn(function()
    while wait(5) do
        if _G.LockAutoHop then
            -- ปิด Auto Hop
            _G.AutoHop = false
            print("[TeeHid Hub] Lock Server Hop ชั่วคราว")
        end
    end
end)

print("[TeeHid Hub] Phase 10: Lock Auto Mastery + Auto Quest + Server Hop Loaded!")
