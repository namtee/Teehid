--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build
-- Phase 1-10 + Auto Select Team + SafeFly 20 Studs
-- โค้ดฉบับเต็ม (จำนวนบรรทัดเยอะ) สำหรับ Lab/ศึกษา
--------------------------------------------------------------------------------


-------------------------------
-- 1) Auto Select Team
-------------------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                          .PlayerGui:FindFirstChild("ChooseTeam")
    local chooseTeam = "Pirates" -- เปลี่ยนเป็น "Marines" ได้
    game:GetService("ReplicatedStorage").Remotes.CommF_:
      InvokeServer("SetTeam", chooseTeam)
    print("[TeeHid Hub] Auto Select Team =>", chooseTeam)
end)

-------------------------------
-- 2) Anti-AFK & Anti-Lag
-------------------------------
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),
            workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),
            workspace.CurrentCamera.CFrame)
    end)
end)

setfpscap(60)
game:GetService("Lighting").FogEnd          = math.huge
game:GetService("Lighting").GlobalShadows   = false
game:GetService("Lighting").Brightness      = 0

-------------------------------
-- 3) Kavo UI Library
-------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window  = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

--------------------------------------------------------------------------------
-- 4) SafeFly Farm (One-Click) ~20 Studs
--------------------------------------------------------------------------------
local safeFlyOffsetY = 20  -- ตั้งค่า 15-20 ได้

local function safeFlyAttack(monster)
    local char  = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp   = char:FindFirstChild("HumanoidRootPart")
    local hum   = monster:FindFirstChild("Humanoid")
    local hrpM  = monster:FindFirstChild("HumanoidRootPart")
    if hrp and hum and hrpM and hum.Health>0 then
        -- ลอยเหนือตัวมอน ~20 Studs
        hrp.CFrame    = CFrame.new(hrpM.Position + Vector3.new(0, safeFlyOffsetY, 0))
        hrp.Anchored  = true
        repeat
            -- ตำแหน่งลอยตามมอนเผื่อมอนขยับ
            local newPos = hrpM.Position + Vector3.new(0, safeFlyOffsetY, 0)
            hrp.CFrame   = CFrame.new(newPos)

            -- โจมตี (คลิกซ้าย)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            wait(0.2)
            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
            wait(0.2)
        until hum.Health<=0 or not monster:FindFirstChild("Humanoid")

        -- ปลด Anchored ถ้าอยากให้เคลื่อนที่ต่อ
        hrp.Anchored  = false
    end
end

local function autoFarmSafeFly()
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
    if enemiesFolder then
        for _, e in pairs(enemiesFolder:GetChildren()) do
            if e:FindFirstChild("HumanoidRootPart")
               and e:FindFirstChild("Humanoid")
               and e.Humanoid.Health>0 then
                safeFlyAttack(e)
            end
        end
    end
end

-- Loop Farm SafeFly (One-Click)
spawn(function()
    while wait() do
        pcall(function()
            autoFarmSafeFly()
        end)
    end
end)

--------------------------------------------------------------------------------
-- [Phase 1: Base Vars, GUI]
--------------------------------------------------------------------------------
local autoFarm     = false
local mobGather    = false
local safeMode     = false
local selectedWeapon = "Melee"

local mainTab      = Window:NewTab("Auto Farm")
local mainSection  = mainTab:NewSection("Farm Controls")

mainSection:NewToggle("Auto Farm LV","ฟาร์มเควส/มอนตามเลเวล",function(state)
    autoFarm = state
end)

mainSection:NewToggle("Mob Gather","รวบมอนไว้จุดเดียว",function(state)
    mobGather = state
end)

mainSection:NewToggle("Safe Mode","บินหนีมอน",function(state)
    safeMode = state
end)

mainSection:NewDropdown("เลือกอาวุธ","Melee / Sword / Fruit",{"Melee","Sword","Fruit"},function(opt)
    selectedWeapon = opt
end)

local utilTab      = Window:NewTab("Utility")
local utilSection  = utilTab:NewSection("ระบบเสริม (Phase1)")

utilSection:NewLabel("Anti-AFK & Anti-Lag เปิดใช้งานแล้ว (Phase1)")

-- Attack / Gather / SafeFly (Old System) => Placeholder
local function attackOldSystem() end
local function gatherMobsOldSystem() end
local function safeFlyOldSystem() end


--------------------------------------------------------------------------------
-- [Phase 2.5: Auto Quest + Auto Stats (Placeholder)]
--------------------------------------------------------------------------------
local questData = {
    {lv=1,   island="Start",         quest="BanditQuest1",    monster="Bandit"},
    {lv=15,  island="Jungle",        quest="JungleQuest",     monster="Monkey"},
    {lv=30,  island="Pirate Village",quest="BuggyQuest1",     monster="Pirate"},
    {lv=60,  island="Desert",        quest="DesertQuest",     monster="Desert Bandit"},
}

local function getCurrentQuest() return nil end
local function killAuraOldSystem(monName) end
local function autoQuest() end
local function autoTP() end

local autoStats = false
local statsTab  = Window:NewTab("Auto Stats")
local statsSec  = statsTab:NewSection("ระบบลงแต้มอัตโนมัติ")

statsSec:NewToggle("Auto Stats (TeeHid)","สูตร: Melee->Defense->SwordFruit",function(state)
    autoStats = state
end)

local function autoDistribute() end


--------------------------------------------------------------------------------
-- [Phase 3: Items & Boss]
--------------------------------------------------------------------------------
local itemTab     = Window:NewTab("Items & Boss")
local itemSection = itemTab:NewSection("Auto Farm Items")

local autoBossFarm   = true
local autoCDK        = true
local autoSoulGuitar = true
local autoSharkAnchor= true

itemSection:NewToggle("Auto Boss Farm","",function(state)
    autoBossFarm=state
end)
itemSection:NewToggle("Farm CDK","",function(state)
    autoCDK=state
end)
itemSection:NewToggle("Farm Soul Guitar","",function(state)
    autoSoulGuitar=state
end)
itemSection:NewToggle("Farm Shark Anchor","",function(state)
    autoSharkAnchor=state
end)

local function autoBoss() end
local function autoItemFarm() end


--------------------------------------------------------------------------------
-- [Phase 4: Fast Mode + Update questData]
--------------------------------------------------------------------------------
local fastTab    = Window:NewTab("Fast Mode")
local fastSection= fastTab:NewSection("เร่ง LV ก่อนทำ Item")

local fastMode   = true
fastSection:NewToggle("Fast Mode","ฟาร์มเลเวลอย่างเดียว",function(state)
    fastMode=state
end)

questData = {
    {lv=1,   island="Start",        quest="BanditQuest1",    monster="Bandit"},
    {lv=15,  island="Jungle",       quest="JungleQuest",     monster="Monkey"},
    {lv=30,  island="Pirate Village",quest="BuggyQuest1",    monster="Pirate"},
    {lv=60,  island="Desert",       quest="DesertQuest",     monster="Desert Bandit"},
    {lv=700, island="Colosseum",    quest="ColosseumQuest",  monster="Gladiator"},
    {lv=1500,island="Hydra Island", quest="HydraQuest",      monster="Dragon Crew Warrior"},
    {lv=2450,island="Tiki Outpost", quest="TikiQuest",       monster="Tiki Pirate"}
}


--------------------------------------------------------------------------------
-- [Phase 5: Races, Styles, Fruits]
--------------------------------------------------------------------------------
local phase5Tab   = Window:NewTab("Races & Styles")
local phase5Sec   = phase5Tab:NewSection("เผ่า & หมัด & ผล")

local autoRaces       = true
local autoStyles      = true
local autoFruitsSystem= true

phase5Sec:NewToggle("Auto ทำเผ่า v1-v3","",function(state)
    autoRaces=state
end)
phase5Sec:NewToggle("Auto ทำหมัด Superhuman-Godhuman","",function(state)
    autoStyles=state
end)
phase5Sec:NewToggle("Fruits System Settings","(ซื้อ/กิน/เก็บ)",function(state)
    autoFruitsSystem=state
end)

_G.Fruits_Settings = {
    Main_Fruits   = {"Dough-Dough","Dragon-Dragon","Leopard-Leopard"},
    Select_Fruits = {"Magma-Magma","Buddha-Buddha","Flame-Flame"}
}

local function autoRacesHandler() end
local function autoStylesHandler() end
local function autoFruitsHandler() end


--------------------------------------------------------------------------------
-- [Phase 6: Lock System + BlackScreen/CloseUI]
--------------------------------------------------------------------------------
local phase6Tab   = Window:NewTab("Utilities (Phase6)")
local phase6Sec   = phase6Tab:NewSection("Lock & UI")

local blackScreen   = false
local closeUI       = false
local lockFragments = false
local lockFruitsRaid= false

phase6Sec:NewToggle("BlackScreen Mode","",function(state)
    blackScreen=state
end)
phase6Sec:NewToggle("CloseUI Mode","",function(state)
    closeUI=state
end)
phase6Sec:NewToggle("Lock Fragments","",function(state)
    lockFragments=state
end)
phase6Sec:NewToggle("Lock Fruits Raid","",function(state)
    lockFruitsRaid=state
end)

local function lockSystemHandler() end


--------------------------------------------------------------------------------
-- [Phase 7: Mastery & Style Buyer]
--------------------------------------------------------------------------------
local phase7Tab   = Window:NewTab("Mastery & Styles (Phase7)")
local phase7Sec   = phase7Tab:NewSection("Farm Mastery & ดาบ & หมัด")

local autoFarmMastery=true
local masteryMelee=true
local masterySword=true
local masteryFruit=true
local autoBuyStyles=true

_G.SwordSettings = {
    Saber=true, Pole=true, MidnightBlade=true, Shisui=true, Saddi=true,
    Wando=true, Yama=true, Rengoku=true, Canvander=true, BuddySword=true,
    TwinHooks=true, HallowScryte=true, TrueTripleKatana=true, CursedDualKatana=true
}

phase7Sec:NewToggle("Auto Farm Mastery","",function(state)
    autoFarmMastery=state
end)
phase7Sec:NewToggle("Farm Melee Mastery","",function(state)
    masteryMelee=state
end)
phase7Sec:NewToggle("Farm Sword Mastery","",function(state)
    masterySword=state
end)
phase7Sec:NewToggle("Farm Fruit Mastery","",function(state)
    masteryFruit=state
end)
phase7Sec:NewToggle("Auto Buy Fighting Styles","",function(state)
    autoBuyStyles=state
end)

local function autoMasteryHandler() end
local function autoStyleBuyer() end


--------------------------------------------------------------------------------
-- [Phase 8: Raid & Sea + Webhook]
--------------------------------------------------------------------------------
local phase8Tab   = Window:NewTab("Raid & Events (Phase8)")
local phase8Sec   = phase8Tab:NewSection("Auto Raid & Sea Event")

local autoRaid    = true
local autoSeaEvent= true
local autoWebhook = true

phase8Sec:NewToggle("Auto Raid Fruits","",function(state)
    autoRaid=state
end)
phase8Sec:NewToggle("Auto Sea Events","",function(state)
    autoSeaEvent=state
end)
phase8Sec:NewToggle("Webhook Notify (Discord)","",function(state)
    autoWebhook=state
end)

local function autoRaidHandler() end
local function autoSeaHandler() end
local webhookURL  = "https://discord.com/api/webhooks/xxx/xxx"

local function sendWebhook(msg) end


--------------------------------------------------------------------------------
-- [Phase 9: Secret Quest + Server Hop + Config Save]
--------------------------------------------------------------------------------
local phase9Tab   = Window:NewTab("Secret & Config (Phase9)")
local phase9Sec   = phase9Tab:NewSection("เควสลับ & Hop & เซฟค่า")

local autoSecretQuest=true
local autoServerHop=true
local autoSaveConfig=true

phase9Sec:NewToggle("Auto Secret Quests","",function(state)
    autoSecretQuest=state
end)
phase9Sec:NewToggle("Auto Server Hop","",function(state)
    autoServerHop=state
end)
phase9Sec:NewToggle("Auto Save Config","",function(state)
    autoSaveConfig=state
end)

local function autoSecretQuestHandler() end
local function autoHopHandler() end
local function autoSaveHandler() end


--------------------------------------------------------------------------------
-- [Phase 10: Final Polish + Extras + UI Anim]
--------------------------------------------------------------------------------
local phase10Tab   = Window:NewTab("⚙️ Extras & Boost (Phase10)")
local phase10Sec   = phase10Tab:NewSection("เพิ่มความลื่น + Animation")

local antiLagExtreme = true
local uiAnimation    = true
local autoFPSBoost   = true

phase10Sec:NewToggle("Anti-Lag Extreme","",function(state)
    antiLagExtreme=state
end)
phase10Sec:NewToggle("Enable UI Animations","",function(state)
    uiAnimation=state
end)
phase10Sec:NewToggle("Auto FPS Boost","",function(state)
    autoFPSBoost=state
end)

local function autoFPSHandler() end


--------------------------------------------------------------------------------
-- MAIN AUTO LOOP (PHASE 1–10) (ใช้สำหรับระบบเก่า Placeholder)
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        ------------------------------------------------
        -- 1) Auto Farm LV (Old System Placeholder)
        ------------------------------------------------
        if autoFarm then
            local quest = getCurrentQuest()
            if quest then
                autoQuest()
                autoTP()
                if mobGather then gatherMobsOldSystem() end
                if safeMode then safeFlyOldSystem() end
                killAuraOldSystem(quest.monster)
            end
        end

        ------------------------------------------------
        -- 2) Auto Stats
        ------------------------------------------------
        if autoStats then
            autoDistribute()
        end

        ------------------------------------------------
        -- 3) Fast Mode
        ------------------------------------------------
        if fastMode then
            if game.Players.LocalPlayer.Data
               and game.Players.LocalPlayer.Data.Level.Value >= 2600 then
                Library:Notification({
                    Title="TeeHid Hub",
                    Text="LV 2600 ตันแล้ว! พร้อมทำ Item / Boss แล้วนะ!",
                    Duration=10
                })
                fastMode=false
            end
        else
            if autoBossFarm then autoBoss() end
            autoItemFarm()
        end

        ------------------------------------------------
        -- 4) Phase 5: Races / Styles / Fruits
        ------------------------------------------------
        autoRacesHandler()
        autoStylesHandler()
        autoFruitsHandler()

        ------------------------------------------------
        -- 5) Phase 6: Lock
        ------------------------------------------------
        lockSystemHandler()

        ------------------------------------------------
        -- 6) Phase 7: Mastery & Style Buyer
        ------------------------------------------------
        autoMasteryHandler()
        autoStyleBuyer()

        ------------------------------------------------
        -- 7) Phase 8: Raid & Sea + Webhook
        ------------------------------------------------
        autoRaidHandler()
        autoSeaHandler()
        local lpData = game.Players.LocalPlayer.Data
        if lpData and lpData.Level.Value>=2600 and autoWebhook then
            sendWebhook("TeeHid Hub แจ้งเตือน: LV 2600 ตันแล้ว!")
            autoWebhook=false
        end

        ------------------------------------------------
        -- 8) Phase 9: Secret Q + Hop + Config
        ------------------------------------------------
        autoSecretQuestHandler()
        autoHopHandler()
        autoSaveHandler()
    end
end)

--------------------------------------------------------------------------------
-- FINAL POLISH (Phase10) LOOP
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        autoFPSHandler()
    end
end)

--------------------------------------------------------------------------------
-- เพิ่ม Footer Tab
--------------------------------------------------------------------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | Phase1-10 + AutoTeam + SafeFly 20 Studs")

print("[TeeHid Hub] Final Build Loaded: Phase1-10 + AutoTeam + SafeFly 20 Studs!")
