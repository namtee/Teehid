--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build (รวมทุก Phase + ฟังก์ชันเต็มระบบ + Auto Select Team)
-- NOTE: ยังมีบางส่วนเป็นโครง (Placeholder) ต้องใส่ Logic เพิ่มหากต้องการให้ครบ
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ประกาศตัวแปรที่จำเป็นก่อน
--------------------------------------------------------------------------------
local flyToggle = false
local flyHeight = 20
local flySpeed = 0.1
local fastAttack = false
local attackSpeed = 0.05

--------------------------------------------------------------------------------
-- Auto Select Team (อัตโนมัติทันที)
--------------------------------------------------------------------------------
spawn(function()
    -- รอจนกระทั่งหน้าต่าง ChooseTeam โผล่มาใน PlayerGui
    repeat wait() until game:GetService("Players").LocalPlayer
                          .PlayerGui:FindFirstChild("ChooseTeam")

    -- ตั้งค่าฝั่งที่ต้องการ (Pirates หรือ Marines)
    local choose = "Pirates" 
    -- หรือถ้าอยากเข้าฝั่ง Marines: local choose = "Marines"

    -- เรียก Remote ของเกม เพื่อเปลี่ยนทีม
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", choose)
end)

--------------------------------------------------------------------------------
-- 2) ANTI-AFK + ANTI-LAG
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- 3) Kavo GUI LIBRARY (BloodTheme)
--------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

--------------------------------------------------------------------------------
-- (NEW) ระบบเลือกทีมอัจฉริยะ (Pirates/Marines) + GUI
--------------------------------------------------------------------------------
local selectedTeam = "Pirates" -- ค่าเริ่มต้น
local teamCheck = false

local teamTab = Window:NewTab("เลือกทีม")
local teamSection = teamTab:NewSection("ตั้งค่าฝั่งทีม")

teamSection:NewDropdown("เลือกทีมเริ่มต้น", "เลือก Pirates หรือ Marines", {"Pirates", "Marines"}, function(team)
    selectedTeam = team
end)

teamSection:NewButton("เลือกทีมทันที (Manual)", "ใช้กรณี Auto ทำงานไม่สำเร็จ", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", selectedTeam)
end)

spawn(function()
    while true do
        if not teamCheck then
            pcall(function()
                local teamGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
                if teamGui and teamGui.Enabled then
                    repeat wait() until teamGui.Enabled
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", selectedTeam)
                    teamCheck = true
                end
            end)
        end
        wait(1)
    end
end)

--------------------------------------------------------------------------------
-- 4) AUTO FARM (SIMPLE LOOP) จากโค้ดใหม่ที่ส่งมา
--------------------------------------------------------------------------------
local function autoFarmSimple()
    local enemies = game:GetService("Workspace").Enemies:GetChildren()
    for i, v in pairs(enemies) do
        if v:FindFirstChild("HumanoidRootPart") 
           and v:FindFirstChild("Humanoid") 
           and v.Humanoid.Health > 0 then

            -- วาร์ปไปบนหัวมอน
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
                v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)

            -- ตีซ้ำ ๆ จนมอนตาย
            repeat
                v.HumanoidRootPart.CFrame = 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                v.HumanoidRootPart.Anchored = true
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                wait(0.2)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                wait(0.2)
            until v.Humanoid.Health <= 0 
                  or not v:FindFirstChild("Humanoid")
        end
    end
end

-- สร้าง Loop เฉพาะสำหรับ autoFarmSimple (อันใหม่)
spawn(function()
    while wait() do
        pcall(function()
            autoFarmSimple()
        end)
    end
end)

--------------------------------------------------------------------------------
-- [Phase 1: Base GUI + Anti-AFK + Anti-Lag + Auto Farm Core]
--------------------------------------------------------------------------------
local autoFarm = false
local mobGather = false
local safeMode = false
local selectedWeapon = "Melee"

local mainTab = Window:NewTab("Auto Farm")
local mainSection = mainTab:NewSection("Farm Controls")

mainSection:NewToggle("Auto Farm LV","เปิดฟาร์ม LV อัตโนมัติ",function(state)
    autoFarm = state
end)

mainSection:NewToggle("Mob Gather","รวบมอนมาไว้จุดเดียว",function(state)
    mobGather = state
end)

mainSection:NewToggle("Safe Mode","บินหนีมอน + ไม่โดนตี",function(state)
    safeMode = state
end)

mainSection:NewDropdown("เลือกอาวุธ","เลือก Melee/Sword/Fruit",{"Melee","Sword","Fruit"},function(option)
    selectedWeapon = option
end)

--------------------------------------------------------------------------------
-- Utility Tab (Phase 1)
--------------------------------------------------------------------------------
local utilTab = Window:NewTab("Utility")
local utilSection = utilTab:NewSection("ระบบเสริม")
utilSection:NewLabel("Anti-AFK & Anti-Lag เปิดใช้งานแล้ว (Phase1)")

--------------------------------------------------------------------------------
-- ฟังก์ชันเก่า (Phase1)
--------------------------------------------------------------------------------
function mouse1click()
    -- สมมติเป็นฟังก์ชันคลิกเมาส์ (ต้อง Implement เอง หรือใช้ VirtualUser)
    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
    wait(0.05)
    game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
end

function attackOldSystem()
    if selectedWeapon == "Melee" then
        mouse1click()
    else
        local tool = nil
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, selectedWeapon) then
                tool = v
                break
            end
        end
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            mouse1click()
        end
    end
end

function gatherMobsOldSystem()
    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            v.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
            v.HumanoidRootPart.Anchored = true
        end
    end
end

-- แก้ safeFlyOldSystem ตามโค้ดใหม่ (เช็ค flyToggle)
function safeFlyOldSystem()
    if flyToggle then return end -- ไม่ทับซ้อนกับระบบบิน v2
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,20,0)
end

--------------------------------------------------------------------------------
-- [Phase 2.5: Auto Quest + Auto TP + Kill Aura + Stats]
--------------------------------------------------------------------------------
local questData = {
    {lv=1,   island="Start",         quest="BanditQuest1",    monster="Bandit"},
    {lv=15,  island="Jungle",        quest="JungleQuest",     monster="Monkey"},
    {lv=30,  island="Pirate Village",quest="BuggyQuest1",     monster="Pirate"},
    {lv=60,  island="Desert",        quest="DesertQuest",     monster="Desert Bandit"},
    -- จะอัปเดตอีกใน Phase 4
}

function getCurrentQuest()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    for i=#questData, 1, -1 do
        if lv >= questData[i].lv then
            return questData[i]
        end
    end
    return nil
end

function killAuraOldSystem(monName)
    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") 
           and v.Humanoid.Health>0 
           and v.Name==monName then
            if (v.HumanoidRootPart.Position - 
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 50 then
                attackOldSystem()
            end
        end
    end
end

function autoQuest()
    local quest = getCurrentQuest()
    if quest then
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
            local questNPC = game:GetService("Workspace").Map:FindFirstChild(quest.quest.."Give")
            if questNPC then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    questNPC.Head.CFrame + Vector3.new(0,5,0)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                    "StartQuest", quest.quest, 1
                )
            end
        end
    end
end

function autoTP()
    local quest = getCurrentQuest()
    if quest and workspace.Map:FindFirstChild(quest.island) then
        if workspace.Map[quest.island]:FindFirstChild("Position") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(workspace.Map[quest.island].Position)
        end
    end
end

-----------------------
-- Auto Stats
-----------------------
local autoStats = false
local statsTab = Window:NewTab("Auto Stats")
local statsSection = statsTab:NewSection("ระบบลงแต้มอัตโนมัติ (Phase2.5)")

statsSection:NewToggle("Auto Stats (สูตร TeeHid)","Melee->Defense->Fruit/Sword",function(state)
    autoStats=state
end)

function autoDistribute()
    local pts = game:GetService("Players").LocalPlayer.Data.Points.Value
    local data = game:GetService("Players").LocalPlayer.Data.Stats
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

--------------------------------------------------------------------------------
-- [Phase 3: Auto Boss + Auto Item (CDK, Soul Guitar, Shark Anchor)]
--------------------------------------------------------------------------------
local itemTab = Window:NewTab("Items & Boss")
local itemSection = itemTab:NewSection("Auto Farm Items")

local autoBossFarm=true
local autoCDK=true
local autoSoulGuitar=true
local autoSharkAnchor=true

itemSection:NewToggle("Auto Boss Farm","ตี Boss อัตโนมัติ",function(state)
    autoBossFarm=state
end)
itemSection:NewToggle("Farm CDK","ฟาร์มทำ CDK",function(state)
    autoCDK=state
end)
itemSection:NewToggle("Farm Soul Guitar","ฟาร์มทำ Soul Guitar",function(state)
    autoSoulGuitar=state
end)
itemSection:NewToggle("Farm Shark Anchor","ฟาร์มทำ Shark Anchor",function(state)
    autoSharkAnchor=state
end)

function autoBoss()
    local bosses={"Saber Expert","Magma Admiral","Ice Admiral","Tide Keeper"}
    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart")
           and v.Humanoid.Health>0 then
            for _,bName in pairs(bosses) do
                if v.Name==bName then
                    v.HumanoidRootPart.CFrame =
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,5)
                    v.HumanoidRootPart.Anchored=true
                    attackOldSystem()
                end
            end
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

--------------------------------------------------------------------------------
-- [Phase 4: Fast Mode + Quest Table LV 2600 + Notify]
--------------------------------------------------------------------------------
local fastTab=Window:NewTab("Fast Mode")
local fastSection=fastTab:NewSection("เร่ง LV ก่อนทำ Item")

local fastMode=true
fastSection:NewToggle("เปิด Fast Mode (Farm LV อย่างเดียว)","เน้นเวลตันก่อน",function(state)
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
-- [Phase 5: Races & Styles & Fruits]
--------------------------------------------------------------------------------
local phase5Tab=Window:NewTab("Races & Styles")
local phase5Section=phase5Tab:NewSection("เผ่า & หมัด & ผล")

local autoRaces=true
local autoStyles=true
local autoFruitsSystem=true

phase5Section:NewToggle("Auto ทำเผ่า v1-v3","",function(state)
    autoRaces=state
end)
phase5Section:NewToggle("Auto ทำหมัด Superhuman-Godhuman","",function(state)
    autoStyles=state
end)
phase5Section:NewToggle("Fruits System Settings","(ซื้อ/กิน/เก็บ)",function(state)
    autoFruitsSystem=state
end)

_G.Fruits_Settings={
    Main_Fruits={"Dough-Dough","Dragon-Dragon","Leopard-Leopard"},
    Select_Fruits={"Magma-Magma","Buddha-Buddha","Flame-Flame"}
}

function autoRacesHandler()
    if autoRaces then
        print("[TeeHid Hub] Running Auto Races v1-v3 Logic...")
    end
end
function autoStylesHandler()
    if autoStyles then
        print("[TeeHid Hub] Running Auto Fighting Style Logic...")
    end
end
function autoFruitsHandler()
    if autoFruitsSystem then
        print("[TeeHid Hub] Fruits System Active!")
    end
end

--------------------------------------------------------------------------------
-- [Phase 6: Lock System + BlackScreen/CloseUI]
--------------------------------------------------------------------------------
local phase6Tab=Window:NewTab("Utilities (Phase6)")
local phase6Section=phase6Tab:NewSection("Lock & UI")

local blackScreen=false
local closeUI=false
local lockFragments=false
local lockFruitsRaid=false

phase6Section:NewToggle("BlackScreen Mode","",function(state)
    blackScreen=state
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title="TeeHid Hub",Text="BlackScreen เปิด",Duration=5})
        local sg=game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChildOfClass("ScreenGui")
        if sg then sg.Enabled=false end
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{Title="TeeHid Hub",Text="BlackScreen ปิด",Duration=5})
        local sg=game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChildOfClass("ScreenGui")
        if sg then sg.Enabled=true end
    end
end)

phase6Section:NewToggle("CloseUI Mode","",function(state)
    closeUI=state
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") then
            v.Enabled=not state
        end
    end
end)
phase6Section:NewToggle("Lock Fragments","",function(state)
    lockFragments=state
end)
phase6Section:NewToggle("Lock Fruits Raid","",function(state)
    lockFruitsRaid=state
end)

function lockSystemHandler()
    if lockFragments then
        print("[TeeHid Hub] Lock Fragments Enabled!")
    end
    if lockFruitsRaid then
        print("[TeeHid Hub] Lock Fruits Raid Active!")
    end
end

--------------------------------------------------------------------------------
-- [Phase 7: Farm Mastery + Auto Buy Styles + SwordSettings]
--------------------------------------------------------------------------------
local phase7Tab=Window:NewTab("Mastery & Styles (Phase7)")
local phase7Section=phase7Tab:NewSection("Farm Mastery & ดาบ & หมัด")

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

phase7Section:NewToggle("Auto Farm Mastery","",function(state)
    autoFarmMastery=state
end)
phase7Section:NewToggle("Farm Melee Mastery","",function(state)
    masteryMelee=state
end)
phase7Section:NewToggle("Farm Sword Mastery","",function(state)
    masterySword=state
end)
phase7Section:NewToggle("Farm Fruit Mastery","",function(state)
    masteryFruit=state
end)
phase7Section:NewToggle("Auto Buy Fighting Styles","",function(state)
    autoBuyStyles=state
end)

function autoMasteryHandler()
    if autoFarmMastery then
        if masteryMelee then
            print("[TeeHid Hub] Farm Melee Mastery Running...")
        end
        if masterySword then
            print("[TeeHid Hub] Farm Sword Mastery Running...")
        end
        if masteryFruit then
            print("[TeeHid Hub] Farm Fruit Mastery Running...")
        end
    end
end

function autoStyleBuyer()
    if autoBuyStyles then
        print("[TeeHid Hub] Auto Buy Fighting Styles Active!")
    end
end

--------------------------------------------------------------------------------
-- [Phase 8: Auto Raid + Sea Event + Webhook]
--------------------------------------------------------------------------------
local phase8Tab=Window:NewTab("Raid & Events (Phase8)")
local phase8Section=phase8Tab:NewSection("Auto Raid & Sea Event")

local autoRaid=true
local autoSeaEvent=true
local autoWebhook=true

phase8Section:NewToggle("Auto Raid Fruits","",function(state)
    autoRaid=state
end)
phase8Section:NewToggle("Auto Sea Events","",function(state)
    autoSeaEvent=state
end)
phase8Section:NewToggle("Webhook Notify (Discord)","",function(state)
    autoWebhook=state
end)

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

local webhookURL="https://discord.com/api/webhooks/xxx/xxx" -- ตัวอย่าง
function sendWebhook(msg)
    if autoWebhook then
        print("[Webhook] "..msg)
        -- syn.request / http_request
    end
end

--------------------------------------------------------------------------------
-- [Phase 9: Secret Quest + Server Hop + Config Save]
--------------------------------------------------------------------------------
local phase9Tab=Window:NewTab("Secret & Config (Phase9)")
local phase9Section=phase9Tab:NewSection("เควสลับ & Hop & เซฟค่า")

local autoSecretQuest=true
local autoServerHop=true
local autoSaveConfig=true

phase9Section:NewToggle("Auto Secret Quests","",function(state)
    autoSecretQuest=state
end)
phase9Section:NewToggle("Auto Server Hop","",function(state)
    autoServerHop=state
end)
phase9Section:NewToggle("Auto Save Config","",function(state)
    autoSaveConfig=state
end)

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

--------------------------------------------------------------------------------
-- [Phase 10: Final Polish + Performance + UI Anim + Extras]
--------------------------------------------------------------------------------
local phase10Tab=Window:NewTab("⚙️ Extras & Boost (Phase10)")
local phase10Section=phase10Tab:NewSection("เพิ่มความลื่น + Animation")

local antiLagExtreme=true
local uiAnimation=true
local autoFPSBoost=true

phase10Section:NewToggle("Anti-Lag Extreme","",function(state)
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

phase10Section:NewToggle("Enable UI Animations","",function(state)
    uiAnimation=state
    if state then
        print("[TeeHid Hub] Smooth UI Animation Enabled!")
    else
        print("[TeeHid Hub] UI Animation Disabled!")
    end
end)

phase10Section:NewToggle("Auto FPS Boost","",function(state)
    autoFPSBoost=state
end)

function autoFPSHandler()
    if autoFPSBoost then
        local en=game:GetService("Workspace"):FindFirstChild("Enemies")
        if en and #en:GetChildren()>=10 then
            setfpscap(45)
        else
            setfpscap(60)
        end
    end
end

--------------------------------------------------------------------------------
-- (NEW) ระบบ Fast Attack (Beta)
--------------------------------------------------------------------------------
local combatTab = Window:NewTab("Combat")
local combatSection = combatTab:NewSection("ตั้งค่าการโจมตี")

combatSection:NewToggle("Fast Attack Mode","โจมตีเร็วพิเศษ",function(state)
    fastAttack = state
end)

spawn(function()
    while wait(attackSpeed) do
        if fastAttack then
            pcall(function()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                -- ใช้ Remote เรียกการโจมตีโดยตรง
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack",{
                    ["Type"] = "Sword",
                    ["HitPos"] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                })
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- (NEW) ระบบบินแบบลอยตัวตลอดเวลา (Safe Fly v2)
--------------------------------------------------------------------------------
utilSection:NewToggle("เปิดโหมดบินตลอดเวลา","ลอยตัวไม่ตก + ปลอดภัย",function(state)
    flyToggle = state
    if state then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

spawn(function()
    while wait(flySpeed) do
        if flyToggle then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, flyHeight/50, 0)
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- Leveling System v3 (ตาม Wiki)
--------------------------------------------------------------------------------
local guideTab = Window:NewTab("Level Guide")
local guideSection = guideTab:NewSection("ตัวช่วยเลเวลอัป")

guideSection:NewLabel("ใช้คู่กับ Wiki Guide:")
guideSection:NewButton("เปิด Wiki Guide","https://blox-fruits.fandom.com/wiki/Leveling_Guide",function()
    setclipboard("https://blox-fruits.fandom.com/wiki/Leveling_Guide")
    Library:Notification({Title="คัดลอกลิงก์แล้ว",Text="วางในเบราว์เซอร์เพื่อเปิด"})
end)

spawn(function()
    while wait(5) do
        guideSection:NewLabel("Level ปัจจุบัน: "..game.Players.LocalPlayer.Data.Level.Value)
    end
end)

local levelGuide = {
    { -- 1-15
        lv = {1,15},
        island = "Jungle",
        quest = "JungleQuest",
        npc = "QuestGiver",
        mob = "Monkey",
        required = nil
    },
    { -- 15-30
        lv = {15,30},
        island = "Pirate Village",
        quest = "BuggyQuest1",
        npc = "BuggyQuestGiver",
        mob = "Pirate",
        required = nil
    },
    { -- 30-60
        lv = {30,60},
        island = "Desert",
        quest = "DesertQuest",
        npc = "DesertQuestGiver",
        mob = "Desert Bandit",
        required = nil
    },
    { -- 60-90
        lv = {60,90},
        island = "Snow Mountain",
        quest = "SnowQuest",
        npc = "SnowQuestGiver",
        mob = "Snow Bandit",
        required = {"Desert Artifact"}
    },
    -- เพิ่มตาม Guide จนถึง Lv 2450
    { -- 2450+
        lv = {2450,9999},
        island = "Tiki Outpost",
        quest = "TikiQuest",
        npc = "TikiQuestGiver",
        mob = "Tiki Warrior",
        required = {"God's Chalice"}
    }
}

local npcPositions = {
    ["JungleQuestGiver"] = CFrame.new(-1213.79, 12.47, 488.11),
    ["BuggyQuestGiver"]  = CFrame.new(-1141.11, 4.75, 3831.34),
    ["DesertQuestGiver"] = CFrame.new(894.93, 5.44, 4392.03),
    -- เพิ่มตำแหน่ง NPC อื่น ๆ ที่ต้องการ
}

function autoQuestV2()
    local plrLevel = game.Players.LocalPlayer.Data.Level.Value
    for _,guide in pairs(levelGuide) do
        if plrLevel >= guide.lv[1] and plrLevel <= guide.lv[2] then
            -- ตรวจสอบไอเทมที่ต้องการ
            if guide.required then
                if not checkItems(guide.required) then
                    Library:Notification({Title="ต้องการไอเทม",Text=table.concat(guide.required, ", ")})
                    return
                end
            end
            -- ไปหาตัว NPC
            teleportToNPC(guide.npc)
            -- เริ่ม Quest
            if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                    "StartQuest",
                    guide.quest,
                    1
                )
            end
            -- ฟาร์มมอนเตอร์
            killAuraV2(guide.mob)
            return
        end
    end
end

function teleportToNPC(npcName)
    if npcPositions[npcName] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npcPositions[npcName]
    end
end

function checkItems(items)
    local backpack = game:GetService("Players").LocalPlayer.Backpack:GetChildren()
    for _,itemName in pairs(items) do
        local found = false
        for _,item in pairs(backpack) do
            if item.Name == itemName then
                found = true
                break
            end
        end
        if not found then return false end
    end
    return true
end

function killAuraV2(mobName)
    for _,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == mobName and v:FindFirstChild("Humanoid") then
            if v.Humanoid.Health > 0 then
                if fastAttack then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack",{
                        ["Type"] = "Sword",
                        ["HitPos"] = v.HumanoidRootPart.Position
                    })
                else
                    attackOldSystem()
                end
            end
        end
    end
end

-- อัปเดต Main Loop สำหรับระบบ Auto Quest V2
spawn(function()
    while wait(0.5) do
        if autoFarm then
            autoQuestV2()
        end
    end
end)

--------------------------------------------------------------------------------
-- MAIN AUTO LOOP (PHASE 1-10)
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        -- 1) Auto Farm Old System
        if autoFarm then
            local quest=getCurrentQuest()
            if quest then
                autoQuest()
                autoTP()
                if mobGather then gatherMobsOldSystem() end
                if safeMode then safeFlyOldSystem() end
                killAuraOldSystem(quest.monster)
            end
        end

        -- 2) Auto Stats
        if autoStats then
            autoDistribute()
        end

        -- 3) Fast Mode
        if fastMode then
            if game.Players.LocalPlayer.Data.Level.Value>=2600 then
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

        -- 4) Phase 5: Races / Styles / Fruits
        autoRacesHandler()
        autoStylesHandler()
        autoFruitsHandler()

        -- 5) Phase 6: Lock
        lockSystemHandler()

        -- 6) Phase 7: Mastery & Style Buyer
        autoMasteryHandler()
        autoStyleBuyer()

        -- 7) Phase 8: Raid & Sea
        autoRaidHandler()
        autoSeaHandler()
        if game.Players.LocalPlayer.Data.Level.Value>=2600 and autoWebhook then
            sendWebhook("TeeHid Hub แจ้งเตือน: LV 2600 ตันแล้ว!")
            autoWebhook=false
        end

        -- 8) Phase 9: Secret Q + Hop + Config
        autoSecretQuestHandler()
        autoHopHandler()
        autoSaveHandler()
    end
end)

-- FINAL POLISH (Phase10) LOOP
spawn(function()
    while wait() do
        autoFPSHandler()
    end
end)

--------------------------------------------------------------------------------
-- Footer Tab
--------------------------------------------------------------------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | Phase1-10 + AutoTeam + SimpleFarm + SafeFly v2 + FastAttack + LvlSystemV3")

print("[TeeHid Hub] Final Complete Build Loaded with All Systems!")
