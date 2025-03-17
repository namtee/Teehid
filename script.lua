-- client.lua ฝั่ง GitHub

local HttpService = game:GetService("HttpService")

local function getPlayerData()
    local player = game.Players.LocalPlayer

    -- ตรวจสอบผลไม้ใน backpack
    local fruit = nil
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            fruit = tool.Name
            break
        end
    end

    -- เก็บข้อมูล
    local data = {
        Status = "Online",
        PC = tostring(player.UserId), -- หรือ Hardware ID ถ้ามี
        Username = player.Name,
        Type = player.AccountAge > 30 and "Main" or "Alt",
        Level = player:FindFirstChild("Data") and player.Data.Level.Value or 0,
        Melee = player:FindFirstChild("Data") and player.Data.Melee.Value or 0,
        ["Devil Fruit"] = fruit or "ไม่มี",
        ["Fruit Inventory"] = "Empty",
        World = player:FindFirstChild("Data") and player.Data.World.Value or "Unknown",
        Money = player.leaderstats and player.leaderstats.Beli.Value or 0,
        Fragment = player.leaderstats and player.leaderstats.Fragment.Value or 0,
        Race = player:FindFirstChild("Data") and player.Data.Race.Value or "Unknown",
        Mirror = player:FindFirstChild("Data") and player.Data.Mirror.Value or 0,
        Valkyrie = player:FindFirstChild("Data") and player.Data.Valkyrie.Value or 0,
        Lever = player:FindFirstChild("Data") and player.Data.Lever.Value or 0,
        ["Leviathan Heart"] = player:FindFirstChild("Data") and player.Data.LeviathanHeart.Value or 0,
        ["Dark Fragment"] = player:FindFirstChild("Data") and player.Data.DarkFragment.Value or 0,
        Time = os.date("%Y-%m-%d %H:%M:%S")
    }

    return data
end

-- ส่ง POST ไปยัง API URL โดยตรง
local function postDataToAPI(data)
    local url = "https://teehid.xyz/blox-dashboard/receive.php"

    local jsonData = HttpService:JSONEncode(data)

    local success, response = pcall(function()
        return HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[Client] ส่งข้อมูลสำเร็จ:", response)
    else
        warn("[Client] ส่งข้อมูลไม่สำเร็จ:", response)
    end
end

-- ทำงาน
local data = getPlayerData()
postDataToAPI(data)
