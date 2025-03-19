-- TeeHid Hub | Private Build (Pro Build ฟาร์ม 18 ชั่วโมง LV ตัน 2600)

-- ตั้งค่า Team
_G.Team = "Pirates"

-- Auto Select Team
spawn(function()
    repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
    game:GetService("ReplicatedStorage").Remotes:InvokeServer("SetTeam", _G.Team)
    print("[TeeHid Hub] เปลี่ยนทีมอัตโนมัติเป็น:", _G.Team)
    wait(2)
    startAutoFarm()
    startAutoRaid()
end)

-- Anti-AFK + Anti-Lag
spawn(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
setfpscap(60)
game:GetService("Lighting").FogEnd = math.huge
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").Brightness = 0

-- Auto Equip Melee ก่อนตีมอน
spawn(function()
    while wait(2) do
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end)

-- Auto Raid System (Pro Build)
function startAutoRaid()
    spawn(function()
        while wait(10) do
            local raidNPC = workspace:FindFirstChild("RaidNpc")
            if raidNPC and game.Players.LocalPlayer.Data.Level.Value >= 1100 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = raidNPC.Head.CFrame + Vector3.new(0, 5, 0)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Flame")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Start")
            end
        end
    end)
end

-- Auto Farm System + Safe Fly
function startAutoFarm()
    spawn(function()
        while wait() do
            local lv = game.Players.LocalPlayer.Data.Level.Value
            local questTable = {
                {lv = 1, quest = "BanditQuest1", monster = "Bandit", island = CFrame.new(1060,16,1547)},
                {lv = 15, quest = "JungleQuest", monster = "Monkey", island = CFrame.new(-1600, 20, 145)},
                {lv = 700, quest = "ColosseumQuest", monster = "Gladiator", island = CFrame.new(-1836,15, -2740)},
                {lv = 1500, quest = "HydraQuest", monster = "Dragon Crew Warrior", island = CFrame.new(5463, 27, -6953)},
                {lv = 2450, quest = "TikiQuest", monster = "Tiki Pirate", island = CFrame.new(18700, 25, -15000)}
            }
            for i = #questTable, 1, -1 do
                if lv >= questTable[i].lv then
                    local q = questTable[i]
                    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                        local npc = workspace:FindFirstChild(q.quest .. "Give")
                        if npc then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0,5,0)
                            wait(1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q.quest, 1)
                        end
                    end
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == q.monster and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                            hrp.Anchored = true
                            hrp.Velocity = Vector3.new(0,0,0)
                            hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,30,0)
                            v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -30, 0)
                            v.HumanoidRootPart.Anchored = true
                            -- ตีด้วย Melee จริง
                            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                repeat
                                    tool:Activate()
                                    wait(0.1)
                                until v.Humanoid.Health <= 0 or not v:FindFirstChild("Humanoid")
                            end
                        end
                    end
                    break
                end
            end
        end
    end)
end

print("[TeeHid Hub] พร้อมฟาร์ม Auto Quest + Safe Mode + Auto Equip + Constant Fly + Auto Raid Pro")
