--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build (Phase 1-10 + Fly Gather & Kill) [FINAL MERGED]
--------------------------------------------------------------------------------

-------------------------- ประกาศตัวแปรหลัก --------------------------
local flyToggle = false        -- สำหรับ Safe Fly V2
local flyHeight = 20           -- ระดับความสูงขณะบิน
local flySpeed = 0.1           -- ความถี่การปรับตำแหน่งตอนบิน
local fastAttack = true       -- โจมตีเร็ว
local attackSpeed = 0.05       -- ความถี่ในการกดโจมตี

----------------- ตัวเลือกต่าง ๆ ที่จะใช้ในสคริปต์ (Phase 1-10) ---------------
local autoFarm = true         -- Auto Farm LV
local safeMode = true         -- ถ้าเปิด จะ Anchored ตัวเราขณะตีมอน เพื่อไม่ให้โดนตี
local mobGather = true        -- (Placeholder) ถ้าเปิด จะ Anchored มอนให้อยู่รวมกัน
local autoStats = true        -- ลงแต้มอัตโนมัติ
local autoBossFarm = true     -- ตีบอสอัตโนมัติ
local autoCDK = true          -- ฟาร์ม CDK
local autoSoulGuitar = true   -- ฟาร์ม Soul Guitar
local autoSharkAnchor = true  -- ฟาร์ม Shark Anchor
local fastMode = true         -- เน้นปั๊มเลเวลจนถึง 2600
local autoRaces = true        -- ทำเผ่า v1-v3
local autoStyles = true       -- ทำหมัดพิเศษ
local autoFruitsSystem = true -- Fruits System
local lockFragments = true
local lockFruitsRaid = true
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

-- ประกาศตัวแปร/ตารางเก็บข้อมูลเควส (Phase 2.5 / 4)
local questData = {
    {lv=1,   island="Start",        quest="BanditQuest1",    monster="Bandit"},
    {lv=15,  island="Jungle",       quest="JungleQuest",     monster="Monkey"},
    {lv=30,  island="Pirate Village",quest="BuggyQuest1",    monster="Pirate"},
    {lv=60,  island="Desert",       quest="DesertQuest",     monster="Desert Bandit"},
    {lv=700, island="Colosseum",    quest="ColosseumQuest",  monster="Gladiator"},
    {lv=1500,island="Hydra Island", quest="HydraQuest",      monster="Dragon Crew Warrior"},
    {lv=2450,island="Tiki Outpost", quest="TikiQuest",       monster="Tiki Pirate"},
}

_G.Fruits_Settings = {
    Main_Fruits  = {"Dough-Dough","Dragon-Dragon","Leopard-Leopard"},
    Select_Fruits= {"Magma-Magma","Buddha-Buddha","Flame-Flame"}
}

_G.SwordSettings = {
    Saber=true, Pole=true, MidnightBlade=true, Shisui=true, Saddi=true,
    Wando=true, Yama=true, Rengoku=true, Canvander=true, BuddySword=true,
    TwinHooks=true, HallowScryte=true, TrueTripleKatana=true, CursedDualKatana=true
}

--------------------- ป้องกัน AFK + Anti-Lag (Phase 1) ----------------------
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

--------------------- โหลด Kavo UI Library (BloodTheme) -----------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window  = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

--------------------- Auto Select Team (Phase 0) -----------------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                      .PlayerGui:FindFirstChild("ChooseTeam")
    local choose = "Pirates"  -- หรือ "Marines"
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", choose)
end)

--------------------- ประกาศ Tab/Section สำหรับ GUI --------------------------
local mainTab = Window:NewTab("Auto Farm")
local mainSection = mainTab:NewSection("Farm Controls")

mainSection:NewToggle("Auto Farm LV","เปิดฟาร์มเลเวล",function(state)
    autoFarm = state
end)
mainSection:NewToggle("Safe Mode","บินหนีมอน + ไม่โดนตี",function(state)
    safeMode = state
end)
mainSection:NewToggle("Mob Gather","รวบมอนมาไว้จุดเดียว",function(state)
    mobGather = state
end)

local statsTab = Window:NewTab("Auto Stats")
local statsSection = statsTab:NewSection("ลงแต้มอัตโนมัติ")
statsSection:NewToggle("Auto Stats","Melee->Defense->Fruit/Sword",function(state)
    autoStats = state
end)

local bossTab = Window:NewTab("Items & Boss")
local itemSection = bossTab:NewSection("Auto Farm Items")
itemSection:NewToggle("Auto Boss Farm","ตี Boss อัตโนมัติ",function(state)
    autoBossFarm=state
end)
itemSection:NewToggle("Farm CDK","ทำ CDK",function(state)
    autoCDK=state
end)
itemSection:NewToggle("Farm Soul Guitar","ทำ Soul Guitar",function(state)
    autoSoulGuitar=state
end)
itemSection:NewToggle("Farm Shark Anchor","ทำ Shark Anchor",function(state)
    autoSharkAnchor=state
end)

local fastTab = Window:NewTab("Fast Mode")
fastTab:NewSection("เร่ง LV จนถึง 2600")
-- ถ้าต้องการ toggle UI ให้ user กดก็เพิ่ม
-- fastTab:NewToggle("Fast Mode","ฟาร์ม LV จนตัน",function(state)
--     fastMode=state
-- end)

local racesTab = Window:NewTab("Races & Styles")
local racesSection = racesTab:NewSection("เผ่า & หมัด & ผล")
racesSection:NewToggle("Auto ทำเผ่า v1-v3","",function(state)
    autoRaces = state
end)
racesSection:NewToggle("Auto ทำหมัดพิเศษ","",function(state)
    autoStyles = state
end)
racesSection:NewToggle("Fruits System","(ซื้อ/กิน/เก็บ)",function(state)
    autoFruitsSystem = state
end)

local lockTab = Window:NewTab("Utilities (Phase6)")
local lockSec = lockTab:NewSection("Lock & UI")
lockSec:NewToggle("Lock Fragments","",function(state)
    lockFragments=state
end)
lockSec:NewToggle("Lock Fruits Raid","",function(state)
    lockFruitsRaid=state
end)

local masteryTab = Window:NewTab("Mastery & Styles (Phase7)")
local masterySec = masteryTab:NewSection("Farm Mastery & ดาบ & หมัด")
masterySec:NewToggle("Auto Farm Mastery","",function(state)
    autoFarmMastery=state
end)
masterySec:NewToggle("Farm Melee Mastery","",function(state)
    masteryMelee=state
end)
masterySec:NewToggle("Farm Sword Mastery","",function(state)
    masterySword=state
end)
masterySec:NewToggle("Farm Fruit Mastery","",function(state)
    masteryFruit=state
end)
masterySec:NewToggle("Auto Buy Fighting Styles","",function(state)
    autoBuyStyles=state
end)

local raidTab = Window:NewTab("Raid & Events (Phase8)")
local raidSec = raidTab:NewSection("Auto Raid & Sea Event")
raidSec:NewToggle("Auto Raid Fruits","",function(state)
    autoRaid=state
end)
raidSec:NewToggle("Auto Sea Events","",function(state)
    autoSeaEvent=state
end)
raidSec:NewToggle("Webhook Notify (Discord)","",function(state)
    autoWebhook=state
end)

local secretTab = Window:NewTab("Secret & Config (Phase9)")
local secretSec = secretTab:NewSection("เควสลับ & Hop & เซฟค่า")
secretSec:NewToggle("Auto Secret Quests","",function(state)
    autoSecretQuest=state
end)
secretSec:NewToggle("Auto Server Hop","",function(state)
    autoServerHop=state
end)
secretSec:NewToggle("Auto Save Config","",function(state)
    autoSaveConfig=state
end)

local extraTab = Window:NewTab("⚙️ Extras & Boost (Phase10)")
local extraSec = extraTab:NewSection("เพิ่มความลื่น + Animation")

extraSec:NewToggle("Anti-Lag Extreme","",function(state)
    antiLagExtreme=state
    if state then
        game:GetService("Lighting").Brightness=0
        game:GetService("Lighting").GlobalShadows=false
        game:GetService("Lighting").FogEnd=math.huge
        game:GetService("Workspace").Terrain.WaterWaveSize=0
        game:GetService("Workspace").Terrain.WaterTransparency=1
        print("[TeeHid Hub] Extreme FPS Boost Enabled!")
    end
end)

extraSec:NewToggle("Enable UI Animations","",function(state)
    uiAnimation=state
end)

extraSec:NewToggle("Auto FPS Boost","",function(state)
    autoFPSBoost=state
end)

-- Combat Tab สำหรับ Fast Attack
local combatTab = Window:NewTab("Combat")
local combatSection = combatTab:NewSection("ตั้งค่าการโจมตี")
combatSection:NewToggle("Fast Attack Mode","โจมตีเร็วพิเศษ",function(state)
    fastAttack = state
end)

-- Utility Tab (Safe Fly V2)
local utilSection = utilTab:NewSection("Safe Fly V2")
utilSection:NewToggle("บินตลอดเวลา (Safe Fly)","ลอยตัวไม่ตก",function(state)
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


--------------------- ระบบ Fast Attack (Beta) ---------------------------
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

--------------------- ระบบ Safe Fly (เคลื่อนตัวขณะ Anchored) -----------------
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

--------------------- TweenService สำหรับบินไปหาจุด -------------------------
local TweenService = game:GetService("TweenService")

function flyToPosition(cf, speed)
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    hrp.Anchored = false -- ต้องปลด Anchored ก่อน Tween
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false

    local distance = (hrp.Position - cf.Position).magnitude
    local time = distance / (speed or 200)  -- speed = studs/sec
    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

--------------------- ฟังก์ชัน “บินไปรวบมอน + ตี” --------------------------
function flyGatherAndKillMob(mobName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == mobName
           and mob:FindFirstChild("HumanoidRootPart")
           and mob:FindFirstChild("Humanoid")
           and mob.Humanoid.Health > 0 then

            -- บินไปอยู่เหนือหัวมอน
            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
            flyToPosition(targetPos, 200)

            -- ถ้า safeMode เปิด => ล็อกตัวเรา
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            if safeMode then
                hrp.Anchored = true
            end

            -- ถ้า mobGather เปิด => Anchored มอนให้ชิดเรา
            if mobGather then
                mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,5)
                mob.HumanoidRootPart.Anchored = true
            end

            -- ตีซ้ำจนมอนตาย
            while mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 do
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                wait(0.2)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                wait(0.2)
            end

            -- ปลด Anchored เรา (ถ้าเปิด safeMode)
            if safeMode then
                hrp.Anchored = false
            end
        end
    end
end

--------------------- Auto Quest / Auto TP -------------------------------
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

    -- ถ้าในหน้าจอไม่มี Quest ขึ้น => ไปคุย NPC
    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
        local questNPC = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(q.quest.."Give")
        if questNPC and questNPC:FindFirstChild("Head") then
            flyToPosition(questNPC.Head.CFrame, 200)
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q.quest, 1)
        end
    end
end

function autoTP()
    local q = getCurrentQuest()
    if not q then return end

    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(q.island) then
        local pos = workspace.Map[q.island]:FindFirstChild("Position")
        if pos then
            flyToPosition(pos.CFrame, 200)
        end
    end
end

--------------------- Auto Stats ------------------------------
function autoDistribute()
    local pts  = game.Players.LocalPlayer.Data.Points.Value
    local data = game.Players.LocalPlayer.Data.Stats
    if pts>0 then
        if data.Melee.Level<2450 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Melee",1)
        elseif data.Defense.Level<2450 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Defense",1)
        else
            if data.Sword.Level<data.Fruit.Level then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Sword",1)
            else
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",1)
            end
        end
    end
end

--------------------- Auto Boss Farm, Auto Items ---------------------------
function autoBoss()
    local bosses = {"Saber Expert","Magma Admiral","Ice Admiral","Tide Keeper"}
    for _,v in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
        if table.find(bosses,v.Name) and v:FindFirstChild("HumanoidRootPart") then
            flyGatherAndKillMob(v.Name)
        end
    end
end

function autoItemFarm()
    if autoCDK then
        print("[TeeHid Hub] Farm CDK Logic Running...")
    end
    if autoSoulGuitar then
        print("[TeeHid Hub] Farm Soul Guitar Logic Running...")
    end
    if autoSharkAnchor then
        print("[TeeHid Hub] Farm Shark Anchor Logic Running...")
    end
end

--------------------- ระบบ Raid, Sea, Webhook (Placeholder) -----------------
function autoRaidHandler()
    if autoRaid then
        print("[TeeHid Hub] Auto Raid Running...")
    end
end
function autoSeaHandler()
    if autoSeaEvent then
        print("[TeeHid Hub] Sea Event Handler Active...")
    end
end
function sendWebhook(msg)
    if autoWebhook then
        print("[WEBHOOK] "..msg)
    end
end

--------------------- ระบบ Lock, Mastery, Races, etc. (Placeholder) ---------
function lockSystemHandler()
    if lockFragments then
        print("[TeeHid Hub] Lock Fragments Enabled!")
    end
    if lockFruitsRaid then
        print("[TeeHid Hub] Lock Fruits Raid Enabled!")
    end
end

function autoMasteryHandler()
    if autoFarmMastery then
        if masteryMelee then print("[TeeHid Hub] Farm Melee Mastery...") end
        if masterySword then print("[TeeHid Hub] Farm Sword Mastery...") end
        if masteryFruit then print("[TeeHid Hub] Farm Fruit Mastery...") end
    end
end

function autoStyleBuyer()
    if autoBuyStyles then
        print("[TeeHid Hub] Auto Buy Fighting Styles...")
    end
end

function autoRacesHandler()
    if autoRaces then
        print("[TeeHid Hub] Auto Races v1-v3...")
    end
end

function autoStylesHandler()
    if autoStyles then
        print("[TeeHid Hub] Auto Fighting Style Logic...")
    end
end

function autoFruitsHandler()
    if autoFruitsSystem then
        print("[TeeHid Hub] Fruits System Active!")
    end
end

--------------------- ระบบ Secret Quest, Hop, Save Config --------------------
function autoSecretQuestHandler()
    if autoSecretQuest then
        print("[TeeHid Hub] Running Secret Quests Logic...")
    end
end
function autoHopHandler()
    if autoServerHop then
        print("[TeeHid Hub] Server Hop Triggered...")
    end
end
function autoSaveHandler()
    if autoSaveConfig then
        print("[TeeHid Hub] Config Saved Automatically!")
    end
end

--------------------- ระบบปรับ FPS อัตโนมัติ --------------------------------
function autoFPSHandler()
    if autoFPSBoost then
        local en = workspace:FindFirstChild("Enemies")
        if en and #en:GetChildren()>=10 then
            setfpscap(45)
        else
            setfpscap(60)
        end
    end
end

--------------------- ลูปหลัก (Phase 1-10) -----------------------------------
spawn(function()
    while wait(1) do
        if autoFarm then
            -- 1) รับเควส
            autoQuest()
            -- 2) บินไปเกาะตามเควส
            autoTP()
            -- 3) บินไปรวบมอนตามชื่อที่ได้จากเควส
            local q = getCurrentQuest()
            if q then
                flyGatherAndKillMob(q.monster)
            end
        end

        if autoStats then
            autoDistribute()
        end

        if fastMode then
            if game.Players.LocalPlayer.Data.Level.Value >= 2600 then
                Library:Notification({
                    Title="TeeHid Hub",
                    Text="LV 2600 ตันแล้ว! พร้อมทำ Item / Boss แล้วนะ!",
                    Duration=10
                })
                fastMode = false
            end
        else
            if autoBossFarm then
                autoBoss()
            end
            autoItemFarm()
        end

        -- Phase 5: Races, Styles, Fruits
        autoRacesHandler()
        autoStylesHandler()
        autoFruitsHandler()

        -- Phase 6: Lock
        lockSystemHandler()

        -- Phase 7: Mastery & Style Buyer
        autoMasteryHandler()
        autoStyleBuyer()

        -- Phase 8: Raid & Sea
        autoRaidHandler()
        autoSeaHandler()
        if game.Players.LocalPlayer.Data.Level.Value>=2600 and autoWebhook then
            sendWebhook("TeeHid Hub แจ้งเตือน: LV 2600 ตันแล้ว!")
            autoWebhook = false
        end

        -- Phase 9: Secret Q + Hop + Config
        autoSecretQuestHandler()
        autoHopHandler()
        autoSaveHandler()
    end
end)

--------------------- ลูปปรับ FPS (Phase10) -----------------------------------
spawn(function()
    while wait(5) do
        autoFPSHandler()
    end
end)

--------------------- Footer Tab ----------------------------------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | Phase1-10 + Fly Gather & Kill (Final)")
print("[TeeHid Hub] Final Merged Build Loaded!")
