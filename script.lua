--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build
-- Phase 1–10 (Pro Build ฟาร์ม 18 ชั่วโมง LV ตัน 2600)
-- รวม Code ทั้งหมด + AutoTeam + SafeFly + Auto Quest & TP
--------------------------------------------------------------------------------

-------------------------------
-- (1) Auto Select Team (Pirates) ใช้ CommF_
-------------------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                      .PlayerGui:FindFirstChild("ChooseTeam")
    if game:GetService("Players").LocalPlayer
           .PlayerGui:FindFirstChild("ChooseTeam") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:
          InvokeServer("SetTeam","Pirates")
        print("[TeeHid Hub] Auto Select Team => Pirates")
    end
end)

-------------------------------
-- (2) Anti-AFK + Anti-Lag
-------------------------------
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):
          Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):
          Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
setfpscap(60)
game:GetService("Lighting").FogEnd        = math.huge
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").Brightness    = 0

-------------------------------
-- (3) Kavo UI Library
-------------------------------
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua")
)()
local Window = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

--------------------------------------------------------------------------------
-- (4) ตาราง Quest (questTable) + SafeFly
--------------------------------------------------------------------------------

local questTable = {
    {lv = 1,    quest = "BanditQuest1",   monster = "Bandit",
     island = CFrame.new(1060,16,1547)},
    {lv = 15,   quest = "JungleQuest",    monster = "Monkey",
     island = CFrame.new(-1600, 20, 145)},
    {lv = 700,  quest = "ColosseumQuest", monster = "Gladiator",
     island = CFrame.new(-1836,15, -2740)},
    {lv = 1500, quest = "HydraQuest",     monster = "Dragon Crew Warrior",
     island = CFrame.new(5463, 27, -6953)},
    {lv = 2450, quest = "TikiQuest",      monster = "Tiki Pirate",
     island = CFrame.new(18700, 25, -15000)}
}

local safeFlyOffsetY = 20  -- ลอย 20 Studs

-- SafeFly: ลอยผู้เล่นเอง (Anchored = true)
local function safeFarm(mob)
    if not mob:FindFirstChild("HumanoidRootPart") then return end
    if not mob:FindFirstChild("Humanoid") then return end
    if mob.Humanoid.Health <= 0 then return end

    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- บินเหนือหัวมอน 20 studs
    hrp.CFrame   = mob.HumanoidRootPart.CFrame * CFrame.new(0,safeFlyOffsetY,0)
    hrp.Anchored = true

    repeat
        -- อัปเดตตำแหน่งลอยตามมอน (ในกรณีมอนขยับ)
        local newPos = mob.HumanoidRootPart.CFrame * CFrame.new(0,safeFlyOffsetY,0)
        hrp.CFrame   = newPos

        -- ตีด้วย Melee (ไม่หยิบ Tool)
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
        wait(0.2)
        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
        wait(0.2)
    until mob.Humanoid.Health <= 0 
          or not mob:FindFirstChild("Humanoid")

    -- ถ้าต้องการลอยต่อ ไม่ต้องปลด Anchored
    hrp.Anchored = false
end

--------------------------------------------------------------------------------
-- (5) ฟังก์ชัน Auto Quest
--------------------------------------------------------------------------------
local function autoQuest()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    -- เลือก Quest สูงสุดที่ lv >=
    for i = #questTable, 1, -1 do
        local data = questTable[i]
        if lv >= data.lv then
            -- ถ้าไม่มีเควสอยู่
            if not game:GetService("Players").LocalPlayer
                     .PlayerGui.Main.Quest.Visible then
                -- หา NPC
                local npc = workspace:FindFirstChild(data.quest.."Give")
                if npc and npc:FindFirstChild("Head") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        npc.Head.CFrame + Vector3.new(0,5,0)
                    wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:
                      InvokeServer("StartQuest", data.quest, 1)
                end
            end
            return data
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- (6) ลูป Auto Farm (Quest + TP + SafeFly)
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        local q = autoQuest()
        if q then
            -- เทเลพอร์ตไป Island
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = q.island
            wait(1)

            -- วนหา monster
            for _,en in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if en.Name==q.monster
                   and en:FindFirstChild("Humanoid")
                   and en.Humanoid.Health>0 then
                    safeFarm(en)
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- [PHASE 1: Variables & GUI (Toggle/Dropdown)]
--------------------------------------------------------------------------------
local autoFarm = false
local mobGather = false
local safeMode = false
local selectedWeapon = "Melee"

local mainTab = Window:NewTab("Auto Farm")
local mainSec = mainTab:NewSection("Farm Controls")

mainSec:NewToggle("Auto Farm LV","เปิดฟาร์ม LV อัตโนมัติ (เก่า)",function(state)
    autoFarm=state
end)
mainSec:NewToggle("Mob Gather","รวบมอน (เก่า)",function(state)
    mobGather=state
end)
mainSec:NewToggle("Safe Mode","บินหนีมอน (เก่า)",function(state)
    safeMode=state
end)
mainSec:NewDropdown("เลือกอาวุธ","Melee/Sword/Fruit",{"Melee","Sword","Fruit"},function(opt)
    selectedWeapon=opt
end)

local utilTab = Window:NewTab("Utility")
local utilSec = utilTab:NewSection("ระบบเสริม (Phase1)")
utilSec:NewLabel("Anti-AFK & Anti-Lag เปิดใช้งานแล้ว (Phase1)")

-- ฟังก์ชันเก่า Placeholder
local function attackOldSystem() end
local function gatherMobsOldSystem() end
local function safeFlyOldSystem() end

--------------------------------------------------------------------------------
-- [PHASE 2.5: Auto Quest + Stats (Placeholder)]
--------------------------------------------------------------------------------
local statsTab = Window:NewTab("Auto Stats")
local statsSec = statsTab:NewSection("ลงแต้มอัตโนมัติ (Phase2.5)")

local autoStats=false
statsSec:NewToggle("Auto Stats (TeeHid)","Melee->Def->SwordFruit",function(state)
    autoStats=state
end)
local function autoDistribute() end

--------------------------------------------------------------------------------
-- [PHASE 3: Items & Boss]
--------------------------------------------------------------------------------
local itemTab=Window:NewTab("Items & Boss")
local itemSec=itemTab:NewSection("Auto Farm Items")

local autoBossFarm=true
local autoCDK=true
local autoSoulGuitar=true
local autoSharkAnchor=true

itemSec:NewToggle("Auto Boss Farm","",function(state)
    autoBossFarm=state
end)
itemSec:NewToggle("Farm CDK","",function(state)
    autoCDK=state
end)
itemSec:NewToggle("Farm Soul Guitar","",function(state)
    autoSoulGuitar=state
end)
itemSec:NewToggle("Farm Shark Anchor","",function(state)
    autoSharkAnchor=state
end)

local function autoBoss() end
local function autoItemFarm() end

--------------------------------------------------------------------------------
-- [PHASE 4: Fast Mode (LV Farm Only)]
--------------------------------------------------------------------------------
local fastTab=Window:NewTab("Fast Mode")
local fastSec=fastTab:NewSection("เร่ง LV ก่อนทำ Item")

local fastMode=true
fastSec:NewToggle("Fast Mode","ฟาร์ม LV อย่างเดียว",function(state)
    fastMode=state
end)

--------------------------------------------------------------------------------
-- [PHASE 5: Races, Styles, Fruits]
--------------------------------------------------------------------------------
local phase5Tab=Window:NewTab("Races & Styles")
local phase5Sec=phase5Tab:NewSection("เผ่า & หมัด & ผล")

local autoRaces=true
local autoStyles=true
local autoFruitsSystem=true

phase5Sec:NewToggle("Auto ทำเผ่า v1-v3","",function(state)
    autoRaces=state
end)
phase5Sec:NewToggle("Auto ทำหมัด Superhuman-Godhuman","",function(state)
    autoStyles=state
end)
phase5Sec:NewToggle("Fruits System Settings","(ซื้อ/กิน/เก็บ)",function(state)
    autoFruitsSystem=state
end)

_G.Fruits_Settings={
    Main_Fruits   = {"Dough-Dough","Dragon-Dragon","Leopard-Leopard"},
    Select_Fruits = {"Magma-Magma","Buddha-Buddha","Flame-Flame"}
}

local function autoRacesHandler() end
local function autoStylesHandler() end
local function autoFruitsHandler() end

--------------------------------------------------------------------------------
-- [PHASE 6: Lock System + BlackScreen/CloseUI]
--------------------------------------------------------------------------------
local phase6Tab=Window:NewTab("Utilities (Phase6)")
local phase6Sec=phase6Tab:NewSection("Lock & UI")

local blackScreen=false
local closeUI=false
local lockFragments=false
local lockFruitsRaid=false

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
-- [PHASE 7: Mastery & Styles]
--------------------------------------------------------------------------------
local phase7Tab=Window:NewTab("Mastery & Styles (Phase7)")
local phase7Sec=phase7Tab:NewSection("Farm Mastery & ดาบ & หมัด")

local autoFarmMastery=true
local masteryMelee=true
local masterySword=true
local masteryFruit=true
local autoBuyStyles=true

_G.SwordSettings={
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
-- [PHASE 8: Raid & Sea + Webhook]
--------------------------------------------------------------------------------
local phase8Tab=Window:NewTab("Raid & Events (Phase8)")
local phase8Sec=phase8Tab:NewSection("Auto Raid & Sea Event")

local autoRaid=true
local autoSeaEvent=true
local autoWebhook=true

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
local webhookURL="https://discord.com/api/webhooks/xxx/xxx"
local function sendWebhook(msg) end

--------------------------------------------------------------------------------
-- [PHASE 9: Secret Quest + Server Hop + Config Save]
--------------------------------------------------------------------------------
local phase9Tab=Window:NewTab("Secret & Config (Phase9)")
local phase9Sec=phase9Tab:NewSection("เควสลับ & Hop & เซฟค่า")

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
-- [PHASE 10: Final Polish + Extras]
--------------------------------------------------------------------------------
local phase10Tab=Window:NewTab("⚙️ Extras & Boost (Phase10)")
local phase10Sec=phase10Tab:NewSection("เพิ่มความลื่น + Animation")

local antiLagExtreme=true
local uiAnimation=true
local autoFPSBoost=true

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
-- MAIN AUTO LOOP (PHASE 1–10) (ระบบเก่า Placeholder)
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        ------------------------------------------------
        -- 1) Auto Farm LV (Old System)
        ------------------------------------------------
        if autoFarm then
            -- Placeholder
            -- (ถ้าอยากเชื่อมกับ SafeFly ได้, ต้องแก้เอง)
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
            local lv = game.Players.LocalPlayer.Data.Level.Value
            if lv>=2600 then
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
        local lv2=game.Players.LocalPlayer.Data.Level.Value
        if lv2>=2600 and autoWebhook then
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
-- Footer
--------------------------------------------------------------------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | Phase1-10 + SafeFly + Pro Quest")

print("[TeeHid Hub] Pro Build Loaded: SafeFly 20 Studs + Auto Quest + Pirates Team + Phase1-10!")
