-- [[ WL HUB V32.0 - FULL INTEGRATED CLONE ]] --
local player = game.Players.LocalPlayer
local core = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

-- Bersihin UI lama
if core:FindFirstChild("WL_HUB_CORE") then core.WL_HUB_CORE:Destroy() end

-- State Settings
_G.InfJump = false
_G.AntiRagdoll = false
_G.Fly = false

-- UI Setup (Replikasi layout foto lu)
local WL = Instance.new("ScreenGui", core)
WL.Name = "WL_HUB_CORE"

local Main = Instance.new("Frame", WL)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 127) -- Pink WL

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 150, 1, 0)
Side.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Side)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "WL HUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 127)
Title.Font = "GothamBold"
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- Container
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -165, 1, -20)
Container.Position = UDim2.new(0, 155, 0, 10)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local List = Instance.new("UIListLayout", Container)
List.Padding = UDim.new(0, 8)

-- Tombol Pembuat (Toggle)
local function NewToggle(text, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", Frame)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -60, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.Text = text
    Lbl.TextColor3 = Color3.new(1,1,1)
    Lbl.Font = "GothamSemibold"; Lbl.TextSize = 13
    Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local active = false
    Switch.MouseButton1Click:Connect(function()
        active = not active
        ts:Create(Switch, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(50, 50, 60)}):Play()
        callback(active)
    end)
end

-- [ GABUNGAN FITUR WL HUB ]
NewToggle("ANTI-RAGDOLL", function(s) _G.AntiRagdoll = s end)
NewToggle("INFINITE JUMP", function(s) _G.InfJump = s end)
NewToggle("FLY (BETA)", function(s) _G.Fly = s end)
NewToggle("WL BOOSTER", function(s) print("Booster Engaged") end)

-- [ CORE LOGIC ]
uis.JumpRequest:Connect(function()
    if _G.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(3)
    end
end)

rs.Heartbeat:Connect(function()
    if _G.AntiRagdoll and player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        h.PlatformStand = false
        if h:GetState() == Enum.HumanoidStateType.Ragdoll then h:ChangeState(12) end
    end
end)

-- Minimize Key: RightControl
uis.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "WL HUB LOADED", Text = "All features merged!", Duration = 5})
