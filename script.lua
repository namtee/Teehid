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
