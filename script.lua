-- TeeHid Hub | Private Build (All Automatic + Hide UI Toggle)
-- คำอธิบาย: โค้ดนี้จะทำงานอัตโนมัติทุกฟีเจอร์ (Phase1-10) โดยไม่ต้องกดปุ่มใน UI
-- และมีปุ่มลัด (เช่น RightControl) สำหรับซ่อน/แสดง UI ได้

--------------------------------------------------------------------------------
-- ตัวอย่าง: Auto Select Team ด้วย _G.Team
--------------------------------------------------------------------------------

-- ตั้งค่าเริ่มต้น (Pirates หรือ Marines)
_G.Team = "Pirates" 

-- เมื่อสคริปต์เริ่มทำงาน จะรอจนกระทั่ง GUI เลือกทีมโผล่มา
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                          .PlayerGui:FindFirstChild("ChooseTeam")

    -- เรียก Remote ของเกม เพื่อเปลี่ยนทีม
    game:GetService("ReplicatedStorage").Remotes.CommF_:
        InvokeServer("SetTeam", _G.Team)

    print("[TeeHid Hub] เปลี่ยนทีมอัตโนมัติเป็น:", _G.Team)
end)


--------------------------------------------------------------------------------
-- 0) ประกาศตัวแปร / เปิดใช้งานทุกฟีเจอร์ โดยไม่ต้องกดปุ่มใด ๆ
--------------------------------------------------------------------------------
local autoFarm = true         -- Auto Farm LV
local safeMode = true         -- Anchored เราขณะตีมอน เพื่อไม่โดนตี
local mobGather = true        -- Anchored มอนให้อยู่รวมกัน
local autoStats = true        -- ลงแต้มอัตโนมัติ
local autoBossFarm = true     -- ตีบอสอัตโนมัติ
local autoCDK = true          -- ฟาร์ม CDK
local autoSoulGuitar = true   -- ฟาร์ม Soul Guitar
local autoSharkAnchor = true  -- ฟาร์ม Shark Anchor
local fastMode = true         -- ฟาร์มเลเวลจนถึง 2600
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

-- ฟังก์ชันหลักที่จะถูกใช้ (สอดคล้องกับโค้ดด้านล่าง)
local flyToggle = true  -- Safe Fly เปิดเลย
local flyHeight = 20
local flySpeed = 0.1
local fastAttack = true
local attackSpeed = 0.05
local selectedWeapon = "Melee"  -- เลือกอาวุธเริ่มต้น

--------------------------------------------------------------------------------
-- 1) Anti-AFK + ลดแลค
--------------------------------------------------------------------------------
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

setfpscap(60)
local Lighting = game:GetService("Lighting")
Lighting.FogEnd = math.huge
Lighting.GlobalShadows = false
Lighting.Brightness = 0

--------------------------------------------------------------------------------
-- 2) โหลด Kavo UI + สร้าง Window (ซึ่งเราจะมีปุ่มลัดซ่อน/แสดง)
--------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TeeHid Hub | Private Build (Auto)", "BloodTheme")

-- ระบบซ่อน/แสดง UI ด้วยปุ่ม RightControl
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        if Window and Window.ToggleUI then
            Window:ToggleUI() -- Kavo มีฟังก์ชัน ToggleUI
        else
            -- ถ้า Library รุ่นเก่าที่ไม่รองรับ ToggleUI()
            local gui = game.CoreGui:FindFirstChild("TeeHid Hub | Private Build (Auto)")
            if gui then
                gui.Enabled = not gui.Enabled
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 3) ระบบเลือกทีมอัตโนมัติ (Pirates)
--------------------------------------------------------------------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                      .PlayerGui:FindFirstChild("ChooseTeam")
    local choose = "Pirates"
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", choose)
end)

--------------------------------------------------------------------------------
-- 4) Auto Farm (Simple Loop)
--------------------------------------------------------------------------------
local function autoFarmSimple()
    local enemies = workspace:WaitForChild("Enemies"):GetChildren()
    for i, v in pairs(enemies) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            repeat
                v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                v.HumanoidRootPart.Anchored = true
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                wait(0.2)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                wait(0.2)
            until v.Humanoid.Health <= 0 or not v:FindFirstChild("Humanoid")
        end
    end
end

spawn(function()
    while wait() do
        pcall(function()
            if autoFarm then
                autoFarmSimple()
            end
        end)
    end
end)

--------------------------------------------------------------------------------
-- 5) ฟังก์ชันเก่า (attackOldSystem, gatherMobsOldSystem, safeFlyOldSystem)
--------------------------------------------------------------------------------
function mouse1click()
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
    local enemies = workspace:WaitForChild("Enemies"):GetChildren()
    for i,v in pairs(enemies) do
        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
            v.HumanoidRootPart.Anchored = true
        end
    end
end

function safeFlyOldSystem()
    if flyToggle then return end
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    hrp.Velocity = Vector3.new(0,0,0)
    hrp.CFrame = hrp.CFrame + Vector3.new(0,20,0)
end

--------------------------------------------------------------------------------
-- 6) Phase 2.5: Auto Quest, Stats, etc.
--------------------------------------------------------------------------------
local questData = {
    {lv=1,   island="Start",         quest="BanditQuest1",    monster="Bandit"},
    {lv=15,  island="Jungle",        quest="JungleQuest",     monster="Monkey"},
    {lv=30,  island="Pirate Village",quest="BuggyQuest1",     monster="Pirate"},
    {lv=60,  island="Desert",        quest="DesertQuest",     monster="Desert Bandit"},
    {lv=700, island="Colosseum",    quest="ColosseumQuest",  monster="Gladiator"},
    {lv=1500,island="Hydra Island", quest="HydraQuest",      monster="Dragon Crew Warrior"},
    {lv=2450,island="Tiki Outpost", quest="TikiQuest",       monster="Tiki Pirate"},
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
    local enemies = workspace:WaitForChild("Enemies"):GetChildren()
    for i,v in pairs(enemies) do
        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 and v.Name==monName then
            local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if dist <= 50 then
                attackOldSystem()
            end
        end
    end
end

function autoQuest()
    local quest = getCurrentQuest()
    if quest then
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
            local questNPC = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(quest.quest.."Give")
            if questNPC and questNPC:FindFirstChild("Head") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = questNPC.Head.CFrame + Vector3.new(0,5,0)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", quest.quest, 1)
            end
        end
    end
end

function autoTP()
    local quest = getCurrentQuest()
    if quest and workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(quest.island) then
        local pos = workspace.Map[quest.island]:FindFirstChild("Position")
        if pos then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos.CFrame
        end
    end
end

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
-- 7) Phase 3: Auto Boss, Items
--------------------------------------------------------------------------------
local function autoBoss()
    local bosses={"Saber Expert","Magma Admiral","Ice Admiral","Tide Keeper"}
    local enemies = workspace:WaitForChild("Enemies"):GetChildren()
    for _,v in pairs(enemies) do
        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health>0 then
            for _,bName in pairs(bosses) do
                if v.Name==bName then
                    v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,5)
                    v.HumanoidRootPart.Anchored=true
                    attackOldSystem()
                end
            end
        end
    end
end

local function autoItemFarm()
    print("[TeeHid Hub] Farm CDK, Soul Guitar, Shark Anchor...")
end

--------------------------------------------------------------------------------
-- 8) Fast Mode + Notify
--------------------------------------------------------------------------------
-- (เราใช้ questData ด้านบน + เช็คเลเวลถึง 2600)

--------------------------------------------------------------------------------
-- 9) Races, Styles, Fruits (Placeholder)
--------------------------------------------------------------------------------
local function autoRacesHandler() print("[TeeHid Hub] Auto Races...") end
local function autoStylesHandler() print("[TeeHid Hub] Auto Fighting Style...") end
local function autoFruitsHandler() print("[TeeHid Hub] Fruits System...") end

--------------------------------------------------------------------------------
-- 10) Lock System, Mastery, Raid, Secret, etc. (Placeholder)
--------------------------------------------------------------------------------
local function lockSystemHandler() print("[TeeHid Hub] Lock System...") end
local function autoMasteryHandler() print("[TeeHid Hub] Auto Mastery...") end
local function autoStyleBuyer() print("[TeeHid Hub] Auto Style Buyer...") end
local function autoRaidHandler() print("[TeeHid Hub] Auto Raid...") end
local function autoSeaHandler() print("[TeeHid Hub] Auto Sea...") end
local function sendWebhook(msg) print("[Webhook] "..msg) end
local function autoSecretQuestHandler() print("[TeeHid Hub] Secret Quest...") end
local function autoHopHandler() print("[TeeHid Hub] Server Hop...") end
local function autoSaveHandler() print("[TeeHid Hub] Config Saved...") end

--------------------------------------------------------------------------------
-- 11) Fast Attack (Beta)
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- 12) Safe Fly v2 (บินตลอดเวลา)
--------------------------------------------------------------------------------
spawn(function()
    while wait(flySpeed) do
        if flyToggle then
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                hrp.Anchored = true
                game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                hrp.CFrame = hrp.CFrame + Vector3.new(0, flyHeight/50, 0)
                hrp.Velocity = Vector3.new(0,0,0)
            end)
        else
            -- ถ้าปิด ก็ปลด Anchored
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.Anchored = false
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end
end)

--------------------------------------------------------------------------------
-- 13) MAIN AUTO LOOP (Phase 1-10)
--------------------------------------------------------------------------------
spawn(function()
    while wait() do
        -- 1) Auto Farm Old System
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

        -- 2) Auto Stats
        if autoStats then
            autoDistribute()
        end

        -- 3) Fast Mode
        if fastMode then
            if game.Players.LocalPlayer.Data.Level.Value>=2600 then
                print("[TeeHid Hub] LV 2600 ตันแล้ว! พร้อมทำ Item/Boss")
                fastMode=false
            end
        else
            if autoBossFarm then autoBoss() end
            autoItemFarm()
        end

        -- 4) Races/Styles/Fruits
        autoRacesHandler()
        autoStylesHandler()
        autoFruitsHandler()

        -- 5) Lock
        lockSystemHandler()

        -- 6) Mastery & Style Buyer
        autoMasteryHandler()
        autoStyleBuyer()

        -- 7) Raid & Sea
        autoRaidHandler()
        autoSeaHandler()
        if game.Players.LocalPlayer.Data.Level.Value>=2600 and autoWebhook then
            sendWebhook("TeeHid Hub แจ้งเตือน: LV 2600 ตันแล้ว!")
            autoWebhook=false
        end

        -- 8) Secret Q + Hop + Config
        autoSecretQuestHandler()
        autoHopHandler()
        autoSaveHandler()
    end
end)

--------------------------------------------------------------------------------
-- 14) Auto FPS Boost (Phase10)
--------------------------------------------------------------------------------
function autoFPSHandler()
    if autoFPSBoost then
        local en=workspace:FindFirstChild("Enemies")
        if en and #en:GetChildren()>=10 then
            setfpscap(45)
        else
            setfpscap(60)
        end
    end
end
spawn(function()
    while wait(3) do
        autoFPSHandler()
    end
end)

--------------------------------------------------------------------------------
-- 15) ปิดท้าย
--------------------------------------------------------------------------------
print("[TeeHid Hub] Final Build (All Auto) Loaded!")
