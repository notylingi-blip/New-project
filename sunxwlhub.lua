-- [[ WL HUB V32.0 - IDENTITY OVERRIDE ]] --

-- 1. LOAD ENGINE UTAMA
local success, err = pcall(function()
    -- Luarmor Loader yang lu pake
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))()
end)

if not success then
    warn("Gagal load loader utama, Boss!")
end

-- 2. WL HUB HIJACKER ENGINE
-- Script ini bakal terus-menerus ganti nama UI biar tetep WL HUB
task.spawn(function()
    while task.wait(0.2) do -- Scan sangat cepat biar user gak liat nama aslinya
        for _, obj in pairs(game:GetService("CoreGui"):GetDescendants()) do
            -- Hijack semua tulisan
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                -- Ganti Sun Hub jadi WL Hub
                if obj.Text:find("SUN HUB") or obj.Text:find("Sun Hub") then
                    obj.Text = obj.Text:gsub("SUN HUB", "WL HUB"):gsub("Sun Hub", "WL HUB")
                    obj.TextColor3 = Color3.fromRGB(255, 0, 127) -- Paksa warna PINK NEON
                end

                -- Ganti Sun Booster jadi WL Booster
                if obj.Text:find("SUN BOOSTER") or obj.Text:find("Sun Booster") then
                    obj.Text = obj.Text:gsub("SUN", "WL"):gsub("Sun", "WL")
                end

                -- Ganti link Discord jadi slogan lu
                if obj.Text:find("discord.gg") then
                    obj.Text = "WL HUB ON TOP!"
                    obj.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end

            -- Hijack Aksen Warna (Ganti semua yang Hijau jadi Pink)
            if obj:IsA("Frame") or obj:IsA("TextButton") then
                if obj.BackgroundColor3 == Color3.fromRGB(0, 255, 0) or obj.BackgroundColor3 == Color3.fromRGB(0, 170, 0) then
                    obj.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
                end
            end
            
            -- Hijack Image/Logo
            if obj:IsA("ImageLabel") and obj.ImageColor3 == Color3.fromRGB(0, 255, 0) then
                obj.ImageColor3 = Color3.fromRGB(255, 0, 127)
            end
        end
    end
end)

-- 3. NOTIFIKASI SUKSES
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "WL HUB",
    Text = "Identity Swapped Successfully!",
    Icon = "rbxassetid://6023457100",
    Duration = 5
})

print("WL HUB V32.0 LOADED AND HIJACKED.")
