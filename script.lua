----------------------------
-- 📌 Client Script Section
----------------------------

-- 📌 วางใน LocalScript เช่น StarterPlayerScripts หรือ StarterCharacterScripts
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ดึง RemoteEvent จาก ReplicatedStorage
local RemoteEvent = ReplicatedStorage:WaitForChild("BFDataEvent")

-- ฟังก์ชันดึงข้อมูล player
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

    -- เก็บข้อมูลต่างๆ
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

-- ส่งข้อมูลไปยัง Server ผ่าน RemoteEvent
RemoteEvent:FireServer(getPlayerData())
print("[Client] ส่งข้อมูล player ไปยัง Server แล้ว")


----------------------------
-- 📌 Server Script Section
----------------------------

-- 📌 วางใน Script ปกติ เช่นใน ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- สร้าง RemoteEvent (จะสร้างเฉพาะในฝั่ง Server)
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "BFDataEvent"
RemoteEvent.Parent = ReplicatedStorage

-- Event รับข้อมูลจาก Client
RemoteEvent.OnServerEvent:Connect(function(player, data)
    print("[Server] ได้รับข้อมูลจาก", player.Name, data)

    -- แปลงข้อมูลเป็น JSON
    local jsonData = HttpService:JSONEncode(data)

    -- ส่ง POST ไปยังเว็บ API
    local url = "https://teehid.xyz/blox-dashboard/receive.php"
    local success, response = pcall(function()
        return HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[Server] ส่งข้อมูลไปยังเว็บเรียบร้อย =>", response)
    else
        warn("[Server] ส่งข้อมูลไม่สำเร็จ:", response)
    end
end)
