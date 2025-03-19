--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build (ตัวอย่างที่รวมระบบ Auto Fly Gather + Kill อัตโนมัติ)
--------------------------------------------------------------------------------

------------------ ประกาศตัวแปรหลัก ------------------
local flyToggle = false        -- สำหรับโหมดบิน
local flyHeight = 20           -- ความสูงที่บินจากพื้น
local flySpeed = 0.1           -- ความถี่ในการปรับตำแหน่งตอนบิน
local fastAttack = false       -- โจมตีเร็ว
local attackSpeed = 0.05       -- ความถี่โจมตี (sec)

local autoFarm = false         -- เปิด/ปิด Auto Farm
local autoStats = false        -- ลงแต้มอัตโนมัติ
local autoBossFarm = true      -- ตี Boss อัตโนมัติ
local autoCDK = true           -- ฟาร์มทำ CDK
local autoSoulGuitar = true    -- ฟาร์มทำ Soul Guitar
local autoSharkAnchor = true   -- ฟาร์มทำ Shark Anchor
local fastMode = true          -- เน้นฟาร์มเลเวลจนตัน
local autoRaces = true
local autoStyles = true
local autoFruitsSystem = true
local lockFragments = false
local lockFruitsRaid = false
local autoFarmMastery = true
local masteryMelee = true
local masterySword = true
local masteryFruit = true
local autoBuyStyles = true
local autoRaid = true
local autoSeaEvent = true
local autoWebhook = true
local autoSecretQuest = true
local autoServerHop = true
local autoSaveConfig = true
local antiLagExtreme = true
local uiAnimation = true
local autoFPSBoost = true

------------------ ป้องกัน AFK + ลดแลค ------------------
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

setfpscap(60)
game:GetService("Lighting").FogEnd = math.huge
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").Brightness = 0

------------------ โหลด Kavo UI Library ------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window  = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

------------------ ระบบเลือกทีมอัตโนมัติ ------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                      .PlayerGui:FindFirstChild("ChooseTeam")
    local choose = "Pirates" -- เปลี่ยนเป็น "Marines" ได้ถ้าต้องการ
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", choose)
end)

------------------ สร้าง Tab/Section ต่าง ๆ ------------------
local teamTab = Window:NewTab("เลือกทีม")
local teamSection = teamTab:NewSection("ตั้งค่าฝั่งทีม")
teamSection:NewLabel("ระบบ Auto เลือก Team ถูกตั้งค่าเป็น Pirates โดยค่าเริ่มต้น")

-- ตัวอย่างระบบ Combat
local combatTab = Window:NewTab("Combat")
local combatSection = combatTab:NewSection("ตั้งค่าการโจมตี")
combatSection:NewToggle("Fast Attack Mode","โจมตีเร็วพิเศษ",function(state)
    fastAttack = state
end)

-- Auto Farm Tab
local mainTab = Window:NewTab("Auto Farm")
local mainSection = mainTab:NewSection("Farm Controls")
mainSection:NewToggle("Auto Farm LV","เปิดฟาร์ม LV อัตโนมัติ",function(state)
    autoFarm = state
end)

-- Utility Tab
local utilTab = Window:NewTab("Utility")
local utilSection = utilTab:NewSection("ระบบเสริม")

utilSection:NewLabel("Anti-AFK & Anti-Lag เปิดใช้งานแล้ว")

-- บินลอยตัวตลอดเวลา (Safe Fly v2)
utilSection:NewToggle("เปิดโหมดบินตลอดเวลา","ลอยตัวไม่ตก + ปลอดภัย",function(state)
    flyToggle = state
    local char = game.Players.LocalPlayer.Character
    if state then
        char.HumanoidRootPart.Anchored = true
        char.Humanoid.PlatformStand = true
    else
        char.HumanoidRootPart.Anchored = false
        char.Humanoid.PlatformStand = false
    end
end)

------------------ ระบบบินให้ขยับเรื่อย ๆ ------------------
spawn(function()
    while wait(flySpeed) do
        if flyToggle then
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame + Vector3.new(0, flyHeight/50, 0)
                hrp.Velocity = Vector3.new(0,0,0)
            end)
        end
    end
end)

------------------ ระบบ Fast Attack (Beta) ------------------
spawn(function()
    while wait(attackSpeed) do
        if fastAttack then
            pcall(function()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack",{
                    ["Type"] = "Sword",
                    ["HitPos"] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                })
            end)
        end
    end
end)

------------------ ฟังก์ชัน TweenService เพื่อบินไปหามอน ------------------
local TweenService = game:GetService("TweenService")

function flyToPosition(cf, speed)
    local player = game.Players.LocalPlayer
    local hrp = player.Character:WaitForChild("HumanoidRootPart")

    local distance = (hrp.Position - cf.Position).magnitude
    local time = distance / (speed or 150) -- speed = studs/sec
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, info, {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

------------------ ฟังก์ชัน รวบมอน (บินไป - Anchored - ตี) ------------------
function flyGatherAndKillMob(mobName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == mobName and
           mob:FindFirstChild("HumanoidRootPart") and
           mob:FindFirstChild("Humanoid") and
           mob.Humanoid.Health > 0 then

            -- ปิด Anchored เราก่อน เพื่อให้ TweenService ขยับได้
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.Anchored = false
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false

            -- บินไปอยู่เหนือหัวมอน (สัก 20 studs)
            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
            flyToPosition(targetPos, 200) 

            -- ล็อกเรา และล็อกมอน
            hrp.Anchored = true
            mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,5)
            mob.HumanoidRootPart.Anchored = true

            -- ตีซ้ำจนมอนตาย
            while mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 do
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                wait(0.2)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                wait(0.2)
            end

            -- ปลด Anchored เรา เพื่อไปหามอนตัวถัดไป
            hrp.Anchored = false
        end
    end
end

------------------ Auto Quest & Auto TP (Phase 2.5/4/ฯลฯ) ------------------
local questData = {
    {lv=1,    island="Start",         quest="BanditQuest1",     monster="Bandit"},
    {lv=15,   island="Jungle",        quest="JungleQuest",      monster="Monkey"},
    {lv=30,   island="Pirate Village",quest="BuggyQuest1",      monster="Pirate"},
    {lv=60,   island="Desert",        quest="DesertQuest",      monster="Desert Bandit"},
    {lv=700,  island="Colosseum",     quest="ColosseumQuest",   monster="Gladiator"},
    {lv=1500, island="Hydra Island",  quest="HydraQuest",       monster="Dragon Crew Warrior"},
    {lv=2450, island="Tiki Outpost",  quest="TikiQuest",        monster="Tiki Pirate"},
}

function getCurrentQuest()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    for i=#questData,1,-1 do
        if lv >= questData[i].lv then
            return questData[i]
        end
    end
    return nil
end

function autoQuest()
    local q = getCurrentQuest()
    if not q then return end

    -- ถ้าหน้าต่างเควสยังไม่ขึ้น => ไปคุย NPC
    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
        local questNPC = game:GetService("Workspace").Map:FindFirstChild(q.quest.."Give")
        if questNPC and questNPC:FindFirstChild("Head") then
            -- Teleport ไปหา NPC
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.Anchored = false
            flyToPosition(questNPC.Head.CFrame, 200) -- บินไปหา NPC
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q.quest, 1)
        end
    end
end

function autoTP()
    local q = getCurrentQuest()
    if not q then return end

    if workspace.Map:FindFirstChild(q.island) then
        local pos = workspace.Map[q.island]:FindFirstChild("Position")
        if pos then
            flyToPosition(pos.CFrame, 250) -- บินไปยังเกาะ
        end
    end
end

------------------ Auto Stats ------------------
function autoDistribute()
    local pts  = game:GetService("Players").LocalPlayer.Data.Points.Value
    local data = game:GetService("Players").LocalPlayer.Data.Stats
    if pts>0 then
        if data.Melee.Level < 2450 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Melee",1)
        elseif data.Defense.Level < 2450 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Defense",1)
        else
            if data.Sword.Level < data.Fruit.Level then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Sword",1)
            else
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",1)
            end
        end
    end
end

------------------ ตัวอย่าง Auto Boss, Auto Item ฯลฯ ------------------
function autoBoss()
    local bosses = {"Saber Expert","Magma Admiral","Ice Admiral","Tide Keeper"}
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if table.find(bosses,v.Name) and v:FindFirstChild("HumanoidRootPart") then
            -- บินไปตี Boss เหมือนกัน
            flyGatherAndKillMob(v.Name)
        end
    end
end

function autoItemFarm()
    if autoCDK then print("[TeeHid Hub] Farm CDK...") end
    if autoSoulGuitar then print("[TeeHid Hub] Farm Soul Guitar...") end
    if autoSharkAnchor then print("[TeeHid Hub] Farm Shark Anchor...") end
end

------------------ ตัวอย่าง Fast Mode ------------------
local fastTab=Window:NewTab("Fast Mode")
fastTab:NewSection("เน้นฟาร์มเลเวลจนตัน")

------------------ สร้างลูปหลัก Auto Farm ------------------
spawn(function()
    while wait(1) do
        if autoFarm then
            -- 1) เริ่มเควสก่อน
            autoQuest()
            -- 2) วาร์ปไปเกาะตามเควส
            autoTP()

            -- 3) รู้ชื่อมอนจาก questData
            local quest = getCurrentQuest()
            if quest then
                -- บินไปรวบมอน (mobName) แล้วตี
                flyGatherAndKillMob(quest.monster)
            end
        end

        -- 4) Auto Stats
        if autoStats then
            autoDistribute()
        end

        -- 5) ถ้า fastMode เปิด => เช็คเลเวล
        if fastMode and game.Players.LocalPlayer.Data.Level.Value>=2600 then
            Library:Notification({
                Title="TeeHid Hub",
                Text="LV 2600 เต็มแล้ว! พร้อมทำ Item/Boss!",
                Duration=10
            })
            fastMode=false
        else
            -- ตรงนี้ตัวอย่าง Auto Boss / Item
            if autoBossFarm then autoBoss() end
            autoItemFarm()
        end
    end
end)

------------------ (Phase อื่น ๆ: Races, Raid, ฯลฯ) ------------------
-- ส่วนนี้เป็น placeholder สามารถใส่หรือคงไว้เหมือนในโค้ดเก่าได้

------------------ Footer ------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | Auto Fly Gather & Kill, Remove old code")

print("[TeeHid Hub] Final - Auto Fly Gather + Kill พร้อมระบบทำงานอัตโนมัติแล้ว!")
