-- [[ WL HUB V32.0 - ULTRA HIJACKER ]] --

-- 1. NOTIFIKASI
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "WL HUB BOOTING",
    Text = "Cracking Identity...",
    Duration = 3
})

-- 2. LOAD ORIGINAL LOADER
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))()
    end)
end)

-- 3. BRUTE FORCE ENGINE
local function FixUI(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        -- Ganti semua variasi Sun Hub
        local oldText = obj.Text
        if oldText:find("SUN") or oldText:find("Sun") or oldText:find("hub") then
            obj.Text = oldText:gsub("SUN HUB", "WL HUB"):gsub("Sun Hub", "WL HUB"):gsub("SUN", "WL"):gsub("Sun", "WL")
            obj.TextColor3 = Color3.fromRGB(255, 0, 127) -- Pink Neon
        end
        
        -- Kunci Teks (Biar gak bisa diganti balik sama script asli)
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if obj.Text:find("SUN") or obj.Text:find("Sun") then
                obj.Text = obj.Text:gsub("SUN", "WL"):gsub("Sun", "WL")
            end
        end)
    end

    -- Ganti Warna Ijo jadi Pink
    if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
        if obj.BackgroundColor3 == Color3.fromRGB(0, 255, 0) or obj.ImageColor3 == Color3.fromRGB(0, 255, 0) then
            if obj:IsA("ImageLabel") then obj.ImageColor3 = Color3.fromRGB(255, 0, 127) end
            obj.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
        end
    end
end

-- Scan semua yang udah ada
for _, v in pairs(game.CoreGui:GetDescendants()) do
    FixUI(v)
end

-- Scan semua yang bakal muncul kemudian
game.CoreGui.DescendantAdded:Connect(function(v)
    task.wait(0.1) -- Tunggu render bentar
    FixUI(v)
end)

print("WL HUB: ALL SUN ELEMENTS PURGED.")
