local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- ตั้ง SECRET_KEY ให้ตรงกับ collect.php
local SECRET_KEY = "fdc27308-229e-4746-91a5-cfc960f88819"

local function getBloxFruitsData()
    -- เตรียม table สำหรับเก็บอาวุธ (equipment) + mastery
    local equipment = {
        melee = "None",
        sword = "None",
        fruit = "None",
        gun   = "None",
        accessory = "None"
    }
    local mastery = {
        melee = 0,
        sword = 0,
        fruit = 0,
        gun   = 0
    }

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Debug เพื่อดูว่าชื่อ item เป็นอะไร
                print("Backpack tool:", tool.Name, "ToolTip:", tool.ToolTip)

                -- สมมติ ToolTip = "Melee" => เป็น melee, ToolTip = "Blox Fruit" => เป็นผลไม้
                if tool.ToolTip == "Melee" then
                    equipment.melee = tool.Name
                elseif tool.ToolTip == "Sword" then
                    equipment.sword = tool.Name
                elseif tool.ToolTip == "Blox Fruit" then
                    equipment.fruit = tool.Name
                elseif tool.ToolTip == "Gun" then
                    equipment.gun = tool.Name
                elseif tool.ToolTip == "Accessory" then
                    equipment.accessory = tool.Name
                end
            end
        end
    end

    -- ต่อไปเป็นตัวอย่างการเอา Mastery จาก Data
    -- (ขึ้นอยู่กับว่า Blox Fruits เก็บค่าไหนใน Player.Data หรือ event ใด)
    -- สมมติ Data: player.Data.MeleeMastery, player.Data.SwordMastery ฯลฯ
    local dataFolder = player:FindFirstChild("Data")
    if dataFolder then
        if dataFolder:FindFirstChild("MeleeMastery") then
            mastery.melee = dataFolder.MeleeMastery.Value
        end
        if dataFolder:FindFirstChild("SwordMastery") then
            mastery.sword = dataFolder.SwordMastery.Value
        end
        if dataFolder:FindFirstChild("BloxFruitMastery") then
            mastery.fruit = dataFolder.BloxFruitMastery.Value
        end
        if dataFolder:FindFirstChild("GunMastery") then
            mastery.gun = dataFolder.GunMastery.Value
        end
    end

    -- สรุป return สอง table
    return equipment, mastery
end

local function getFullStats()
    -- เรียกฟังก์ชันดึงข้อมูล BloxFruits
    local equipment, mastery = getBloxFruitsData()

    local data = {
        username = player.Name,
        userId   = player.UserId,

        level  = player.leaderstats and player.leaderstats.Level.Value or 0,
        bounty = player.leaderstats and player.leaderstats.Bounty.Value or 0,

        position = tostring(
            player.Character 
            and player.Character:FindFirstChild("HumanoidRootPart") 
            and player.Character.HumanoidRootPart.Position 
            or Vector3.new(0,0,0)
        ),

        hwid = HttpService:GenerateGUID(false),

        -- ใส่ key ด้วย
        key = SECRET_KEY,

        -- เก็บลง data เหมือน collect.php อัปเดตไว้
        equipment = equipment, -- {melee="...",sword="...",fruit="...",gun="...",accessory="..."}
        mastery   = mastery    -- {melee=..., sword=..., fruit=..., gun=...}
    }

    return data
end

local function sendStats()
    local data = getFullStats()

    -- Debug print JSON ก่อนส่ง
    print("[Rip inda Admin] Sending Data: " .. HttpService:JSONEncode(data))

    local success, response = pcall(function()
        return HttpService:PostAsync(
            "https://teehid.xyz/v1/api/collect.php",
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if success then
        print("[Rip inda Admin] Data sent successfully! Server Response:", response)
    else
        warn("[Rip inda Admin] Failed to send data:", response)
    end
end

while wait(30) do
    sendStats()
end
