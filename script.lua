-- Roblox LocalScript
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- Hook RemoteEvent (ส่อง Remote ใน Network tab แล้วใส่ให้ถูก)
local remote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StatsEvent")

-- ฟังก์ชันดึงข้อมูล
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
        hwid = HttpService:GenerateGUID(false) -- Mock HWID (จริง ๆ จะใช้ module เสริมดึง hardware id จริง)
    }
    return data
end

-- GUI Overlay แบบง่าย ๆ
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundTransparency = 0.3

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1, 0, 1, 0)
text.TextScaled = true
text.Text = "Sending Data..."
text.TextColor3 = Color3.new(1,1,1)
text.BackgroundTransparency = 1

-- ส่ง API
local function sendStats()
    local data = getFullStats()
    local success, response = pcall(function()
        return HttpService:PostAsync(
            "https://teehid.xyz/blox-dashboard/collect.php",
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        text.Text = "Data Sent! ✅"
    else
        text.Text = "Send Failed ❌"
    end
end

-- loop ส่งข้อมูลทุก 30 วิ
while wait(30) do
    sendStats()
end
