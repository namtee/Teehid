local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- ตั้ง SECRET_KEY ให้ตรงกับที่ collect.php ใช้
local SECRET_KEY = "fdc27308-229e-4746-91a5-cfc960f88819"

local function getFullStats()
    local data = {
        username = player.Name,
        userId = player.UserId,
        level = player.leaderstats and player.leaderstats.Level.Value or 0,
        bounty = player.leaderstats and player.leaderstats.Bounty.Value or 0,
        position = tostring(player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)),
        hwid = HttpService:GenerateGUID(false),
        
        -- ใส่ key ตรงนี้ด้วย
        key = SECRET_KEY
    }
    return data
end

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

while wait(30) do
    sendStats()
end
