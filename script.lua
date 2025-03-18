--------------------------------------------------------------------------------
-- TeeHid Hub | Private Build (Pro Build ฟาร์ม 18 ชั่วโมง LV ตัน 2600)
-- รวม: Auto Select Team, SafeFly 20 studs, Attack เร็ว, Gather Mob, Auto Quest + TP
-- พร้อม Placeholder Phase 1-10 (Lock System, Mastery, Raid, etc.)
--------------------------------------------------------------------------------

-------------------------------
-- (0) แสดง Logo / ชื่อหลังโหลดโปร
-------------------------------
game.StarterGui:SetCore("SendNotification", {
    Title = "TeeHid Hub",
    Text  = "Pro Build Loaded Successfully!",
    Duration = 5
})
print("[TeeHid Hub] Loaded: Pro Build ฟาร์ม 18 ชม. LV ตัน 2600 | พร้อมฟีเจอร์ครบ")

-------------------------------
-- (1) Auto Select Team (Pirates) via CommF_
-------------------------------
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer
                      .PlayerGui:FindFirstChild("ChooseTeam")
    game:GetService("ReplicatedStorage").Remotes.CommF_:
      InvokeServer("SetTeam","Pirates")
    print("[TeeHid Hub] Auto-Selected Team => Pirates")
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
-- (3) Kavo UI Library (BloodTheme)
-------------------------------
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua")
)()
local Window = Library.CreateLib("TeeHid Hub | Private Build", "BloodTheme")

-------------------------------
-- (4) ตาราง Quest + SafeFly & Gather
-------------------------------
local questTable = {
    {lv=1,    quest="BanditQuest1",   monster="Bandit", island=CFrame.new(1060,16,1547)},
    {lv=15,   quest="JungleQuest",    monster="Monkey", island=CFrame.new(-1600,20,145)},
    {lv=700,  quest="ColosseumQuest", monster="Gladiator", island=CFrame.new(-1836,15,-2740)},
    {lv=1500, quest="HydraQuest",     monster="Dragon Crew Warrior", island=CFrame.new(5463,27,-6953)},
    {lv=2450, quest="TikiQuest",      monster="Tiki Pirate", island=CFrame.new(18700,25,-15000)}
}

-- รวบมอนทั้งหมด ชื่อเดียวกัน มาที่ใต้เท้าผู้เล่น
local function gatherMobs(monName)
    local enFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
    if enFolder then
        for _, mob in pairs(enFolder:GetChildren()) do
            if mob.Name==monName 
               and mob:FindFirstChild("HumanoidRootPart")
               and mob:FindFirstChild("Humanoid")
               and mob.Humanoid.Health>0 then
                mob.HumanoidRootPart.CFrame =
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *
                    CFrame.new(0, -5, 0)
                mob.HumanoidRootPart.Anchored=true
            end
        end
    end
end

-- SafeFly Attack: บินลอย 20 Studs เหนือ, ตีเร็ว (0.05 วินาที)
local safeFlyOffsetY = 20

local function safeFlyAttack(monName)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ลอยตัวเอง Anchored
    hrp.Anchored = true
    hrp.CFrame   = hrp.CFrame + Vector3.new(0, safeFlyOffsetY, 0)

    local run = true
    while run do
        local found = false
        local enFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
        if not enFolder then break end

        for _, mob in pairs(enFolder:GetChildren()) do
            if mob.Name==monName 
               and mob:FindFirstChild("Humanoid")
               and mob.Humanoid.Health>0 then
                found = true
                -- ตีเร็ว: 0.05 วินาที
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                wait(0.05)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                wait(0.05)
            end
        end

        if not found then
            run=false
        end
        wait()
    end

    hrp.Anchored = false
end

-- Auto Quest
local function autoQuest()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    local best = nil
    for i=#questTable,1,-1 do
        if lv>=questTable[i].lv then
            best = questTable[i]
            break
        end
    end
    if not best then return nil end

    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
        local npc = workspace:FindFirstChild(best.quest.."Give")
        if npc and npc:FindFirstChild("Head") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                npc.Head.CFrame + Vector3.new(0,5,0)
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:
              InvokeServer("StartQuest", best.quest, 1)
        end
    end
    return best
end

-- ลูปฟาร์ม
spawn(function()
    while wait() do
        local q = autoQuest()
        if q then
            -- TP เกาะ
            local hrp = game.Players.LocalPlayer.Character
                       and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = q.island
                wait(1)
            end

            -- รวบมอน
            gatherMobs(q.monster)
            wait(0.5)

            -- SafeFly Attack
            safeFlyAttack(q.monster)
        end
    end
end)

--------------------------------------------------------------------------------
-- 5) Toggle “Close UI”
--------------------------------------------------------------------------------
local uiTab  = Window:NewTab("UI Settings")
local uiSec  = uiTab:NewSection("ปิด/เปิด UI")

uiSec:NewLabel("ปิดหน้าจอทั้งหมดใน PlayerGui")

local closeUI = false
uiSec:NewToggle("Close UI","ปิด/เปิด ScreenGui ทั้งหมด",function(state)
    closeUI = state
    local pg = game:GetService("Players").LocalPlayer.PlayerGui
    for _, sc in pairs(pg:GetChildren()) do
        if sc:IsA("ScreenGui") then
            sc.Enabled = not state
        end
    end
end)

--------------------------------------------------------------------------------
-- 6) Placeholder Phase 1–10 (Lock System, Mastery, Raid, Secret Quest...)
--------------------------------------------------------------------------------

local mainTab = Window:NewTab("Auto Farm (Placeholder)")
local mainSec = mainTab:NewSection("Phase 1 placeholders")

mainSec:NewLabel("Mob Gather/SafeMode(เก่า) - unused now")

-- ฯลฯ

--------------------------------------------------------------------------------
-- Footer
--------------------------------------------------------------------------------
Window:NewTab("TeeHid Hub"):NewSection("Private Build | SafeFly+FastAttack+Gather+CloseUI")
print("[TeeHid Hub] Pro Build Ready: ตีเร็ว บินสูง รวบมอน ปิดUI Logo OK!")
