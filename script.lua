-- client.lua (ฝั่ง GitHub)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("BFDataEvent")

local function getPlayerData()
    local player = game.Players.LocalPlayer

    -- ตรวจสอบว่ามีผลไม้หรือไม่
    local fruit = nil
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            fruit = tool.Name
            break
        end
    end

    local data = {
        username = player.Name,
        userId = player.UserId,
        avatar = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png",
        bloxfruit = fruit or "ไม่มี",
        level = player.Data.Level.Value or 0,
        bounty = player.leaderstats.Bounty.Value or 0
    }

    return data
end

RemoteEvent:FireServer(getPlayerData())
print("[Client] ส่งข้อมูล player ไปยัง Server แล้ว")
