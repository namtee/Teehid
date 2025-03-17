-- ServerScriptService/ServerHandler.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- สร้าง RemoteEvent สำหรับรับข้อมูลจาก Client
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "BFDataEvent" 
RemoteEvent.Parent = ReplicatedStorage

-- เมื่อมี Client ยิง Event นี้มา จะ OnServerEvent
RemoteEvent.OnServerEvent:Connect(function(player, data)
    -- data คือตาราง (table) ที่ฝั่ง Client ส่งมา เช่น {username=..., avatar=..., bloxfruit=...}
    print("[Server] ได้ข้อมูลจาก", player.Name, data)

    -- แปลงเป็น JSON
    local jsonData = HttpService:JSONEncode(data)

    -- ยิง POST ออกไปยังเว็บ
    local url = "https://teehid.xyz/blox-dashboard/receive.php"
    local success, response = pcall(function()
        return HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[Server] ส่งข้อมูลไปยังเว็บสำเร็จ => Response:", response)
    else
        warn("[Server] ส่งข้อมูลไม่สำเร็จ:", response)
    end
end)
