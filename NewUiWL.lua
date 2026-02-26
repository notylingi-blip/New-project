-- [[ WL HUB V33.1: STICKER EDITION - NEW ENGINE INTEGRATED ]] --

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local char, hum, hrp

-- [[ 1. CHARACTER SYSTEM ]] --
local function UpdateVars(newChar)
    if not newChar then return end
    char = newChar
    hum = char:WaitForChild("Humanoid", 15); hrp = char:WaitForChild("HumanoidRootPart", 15)
end
player.CharacterAdded:Connect(UpdateVars)
UpdateVars(player.Character or player.CharacterAdded:Wait())

-- Globals
_G.AutoGrab = false; _G.GrabRadius = 50
_G.AntiRagdoll = false; _G.InfJump = false
_G.PlayerESP = false; _G.Tracers = false; _G.ShowRadius = true

-- [[ 2. RADIUS RING ]] --
local RadiusRing = Instance.new("Part")
RadiusRing.Name = "WL_RadiusRing"; RadiusRing.Parent = workspace
RadiusRing.Shape = Enum.PartType.Cylinder; RadiusRing.Material = Enum.Material.ForceField
RadiusRing.Color = Color3.fromRGB(255, 0, 127); RadiusRing.Transparency = 0.5; RadiusRing.CanCollide = false; RadiusRing.Anchored = true

-- [[ 3. UI CONSTRUCTION (RAME & STICKER) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

-- STICKER [W] - LEFT TOP
local StickerW = Instance.new("TextLabel", Main)
StickerW.Text = "W"; StickerW.Size = UDim2.new(0, 60, 0, 60); StickerW.Position = UDim2.new(0, -20, 0, -20)
StickerW.Rotation = -15; StickerW.BackgroundColor3 = Color3.fromRGB(255, 0, 127); StickerW.TextColor3 = Color3.fromRGB(255, 255, 255)
StickerW.Font = "GothamBlack"; StickerW.TextSize = 40; Instance.new("UICorner", StickerW).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", StickerW).Thickness = 3

-- STICKER [L] - RIGHT BOTTOM
local StickerL = Instance.new("TextLabel", Main)
StickerL.Text = "L"; StickerL.Size = UDim2.new(0, 50, 0, 50); StickerL.Position = UDim2.new(1, -30, 1, -30)
StickerL.Rotation = 10; StickerL.BackgroundColor3 = Color3.fromRGB(40, 40, 40); StickerL.TextColor3 = Color3.fromRGB(150, 150, 150)
StickerL.Font = "GothamBlack"; StickerL.TextSize = 30; Instance.new("UICorner", StickerL).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", StickerL).Thickness = 2

-- Title Bar
local Title = Instance.new("TextLabel", Main)
Title.Text = "WL HUB V33.1 | THE BRAINROT GOD"; Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = "GothamBold"; Title.TextSize = 16

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -40, 1, -80); Content.Position = UDim2.new(0, 20, 0, 60); Content.BackgroundTransparency = 1

local Layout = Instance.new("UIGridLayout", Content)
Layout.CellSize = UDim2.new(0, 140, 0, 40); Layout.CellPadding = UDim2.new(0, 10, 0, 10)

local function AddToggle(name, callback)
    local Btn = Instance.new("TextButton", Content)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = "GothamBold"; Btn.TextSize = 11; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local s = false
    Btn.MouseButton1Click:Connect(function()
        s = not s; Btn.BackgroundColor3 = s and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 35)
        Btn.TextColor3 = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200); callback(s)
    end)
end

AddToggle("AUTO GRAB (V4)", function(s) 
    _G.AutoGrab = s; if s then loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))() end 
end)
AddToggle("ANTI RAGDOLL", function(s) _G.AntiRagdoll = s end)
AddToggle("INF JUMP", function(s) _G.InfJump = s end)
AddToggle("PLAYER ESP", function(s) _G.PlayerESP = s end)
AddToggle("TRACERS", function(s) _G.Tracers = s end)
AddToggle("SHOW RADIUS", function(s) _G.ShowRadius = s end)

-- [[ 4. ENGINE SYNC ]] --
uis.JumpRequest:Connect(function() if _G.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

rs.Heartbeat:Connect(function()
    if not (hrp and hum and hum.Health > 0) then RadiusRing.Transparency = 1; return end
    if _G.ShowRadius then
        local r = tonumber(_G.GrabRadius) or 50
        RadiusRing.Transparency = 0.6; RadiusRing.Size = Vector3.new(0.1, r*2, r*2); RadiusRing.CFrame = hrp.CFrame * CFrame.Angles(0,0,math.rad(90)) * CFrame.new(-3.5,0,0)
    else RadiusRing.Transparency = 1 end
    if _G.AntiRagdoll then
        hum.PlatformStand = false; hum.Sit = false; hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(-50, hrp.Velocity.Y), hrp.Velocity.Z)
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)

-- (Sistem ESP Sesuai Versi Sebelumnya Tetap Jalan di Background)
