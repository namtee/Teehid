local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local function getFullStats()
    local data = {
        username = player.Name,
        userId = player.UserId,
        level = player.leaderstats and player.leaderstats.Level.Value or "N/A",
        bounty = player.leaderstats and player.leaderstats.Bounty.Value or "N/A",
        fruit = player:FindFirstChild("Backpack") and player.Backpack:FindFirstChildOfClass("Tool") and player.Backpack:FindFirstChildOfClass("Tool").Name or "None",
        position = tostring(player.Character and player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)),
        health = player.Character and player.Character.Humanoid.Health or 0,
        maxHealth = player.Character and player.Character.Humanoid.MaxHealth or 0,
        hwid = HttpService:GenerateGUID(false)
    }
    return data
end

-- ส่งข้อมูลไป API
local function sendStats()
    local data = getFullStats()
    local success, response = pcall(function()
        return HttpService:PostAsync(
            "https://teehid.xyz/v1/api/collect.php",
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        print("Data sent successfully!")
    else
        warn("Failed to send data: " .. tostring(response))
    end
end

-- loop ส่งทุก 30 วินาที
while wait(30) do
    sendStats()
end
