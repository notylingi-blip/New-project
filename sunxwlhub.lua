-- [[ WL HUB V32.0 - WATERMARK EDITION ]] --

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- [[ SETTINGS ]] --
_G.InfJump = false
_G.AntiRagdoll = false
_G.Watermark = true

-- [[ CHARACTER & WATERMARK LOGIC ]] --
local char, hum, hrp
local function CreateWatermark(targetChar)
    if not targetChar:FindFirstChild("WL_Tag") then
        local head = targetChar:WaitForChild("Head", 10)
        local billboard = Instance.new("BillboardGui", head)
        billboard.Name = "WL_Tag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)

        local text = Instance.new("TextLabel", billboard)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "★ WL HUB USER ★"
        text.TextColor3 = Color3.fromRGB(255, 0, 127) -- Pink Neon
        text.Font = Enum.Font.GothamBold
        text.TextSize = 14
        
        -- Animasi muter/naik turun dikit biar keren
        rs.RenderStepped:Connect(function()
            if billboard and billboard.Parent then
                billboard.ExtentsOffset = Vector3.new(0, 3 + math.sin(tick() * 2) * 0.5, 0)
            end
        end)
    end
end

local function GetChar()
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid", 10)
    hrp = char:WaitForChild("HumanoidRootPart", 10)
    if _G.Watermark then CreateWatermark(char) end
end
player.CharacterAdded:Connect(GetChar)
GetChar()

-- [[ UI CONSTRUCTION (WL HUB) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 350)
Main.Position = UDim2.new(0.5, -240, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 127)
Stroke.Thickness = 1.8

-- [ TOMBOL-TOMBOL ]
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0, 160, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

local function CreateBtn(name, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -5, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = "GothamSemibold"; Btn.TextSize = 11
    Instance.new("UICorner", Btn)
    local act = false
    Btn.MouseButton1Click:Connect(function()
        act = not act
        ts:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = act and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(35, 35, 45)}):Play()
        callback(act)
    end)
end

CreateBtn("ACTIVATE LOADER", function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))() end)
CreateBtn("TOGGLE WATERMARK", function(s) 
    _G.Watermark = s 
    if char:FindFirstChild("Head"):FindFirstChild("WL_Tag") then
        char.Head.WL_Tag.Enabled = s
    end
end)
CreateBtn("WL ANTI-RAGDOLL", function(s) _G.AntiRagdoll = s end)
CreateBtn("WL INF-JUMP", function(s) _G.InfJump = s end)

-- [[ ENGINE ]] --
uis.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)
uis.JumpRequest:Connect(function() if _G.InfJump and hum then hum:ChangeState(3) end end)
rs.Heartbeat:Connect(function()
    if _G.AntiRagdoll and hum then
        hum.PlatformStand = false
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
