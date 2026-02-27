-- [[ WL HUB V32.0 - ALL-IN-ONE EDITION ]] --
local player = game.Players.LocalPlayer
local core = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

-- Bersihin UI lama agar tidak menumpuk
if core:FindFirstChild("WL_HUB_V32") then core.WL_HUB_V32:Destroy() end

-- Global Settings
getgenv().InfJump = false
getgenv().AntiRagdoll = false
getgenv().Fly = false
getgenv().AutoSteal = false
getgenv().FlySpeed = 50

-- [[ 1. FOCUS STEAL ENGINE ]] --
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoSteal then
            for _, v in pairs(workspace:GetDescendants()) do
                -- Fokus klik pada objek yang punya interaksi "Steal"
                if v:IsA("ClickDetector") then
                    fireclickdetector(v)
                elseif v:IsA("ProximityPrompt") then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)

-- [[ 2. CORE FEATURES LOGIC ]] --
-- Anti-Ragdoll
rs.Heartbeat:Connect(function()
    if getgenv().AntiRagdoll and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(12) end
        end
    end
end)

-- Fly Mode
task.spawn(function()
    while task.wait() do
        if getgenv().Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local moveDir = hum.MoveDirection
            hrp.Velocity = (moveDir * getgenv().FlySpeed) + (uis:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0,50,0) or uis:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0,-50,0) or Vector3.new(0,0,0))
        end
    end
end)

-- Inf Jump
uis.JumpRequest:Connect(function()
    if getgenv().InfJump and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- [[ 3. UI CONSTRUCTION (WL HUB STYLE) ]] --
local WL = Instance.new("ScreenGui", core); WL.Name = "WL_HUB_V32"
local Main = Instance.new("Frame", WL)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 127)

local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 140, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UICorner", Side)
local Title = Instance.new("TextLabel", Side); Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "WL HUB"; Title.TextColor3 = Color3.fromRGB(255, 0, 127); Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -155, 1, -20); Container.Position = UDim2.new(0, 150, 0, 10); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

local function NewToggle(text, callback)
    local Frame = Instance.new("Frame", Container); Frame.Size = UDim2.new(1, -5, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", Frame)
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(1, -60, 1, 0); Lbl.Position = UDim2.new(0, 15, 0, 0); Lbl.Text = text; Lbl.TextColor3 = Color3.new(1,1,1); Lbl.Font = "GothamSemibold"; Lbl.

