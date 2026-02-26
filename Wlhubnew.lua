-- [[ WL HUB V29.2: FIX UI LAYOUT & ALIGNMENT ]] --

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local char, hum, hrp

-- Update Variables (Anti-Death)
local function UpdateVars(newChar)
    if not newChar then return end
    char = newChar
    hum = char:WaitForChild("Humanoid", 10)
    hrp = char:WaitForChild("HumanoidRootPart", 10)
end
player.CharacterAdded:Connect(UpdateVars)
UpdateVars(player.Character or player.CharacterAdded:Wait())

-- Globals
_G.AutoGrab = false; _G.GrabRadius = 50
_G.Aimlock = false; _G.AutoHit = false
_G.AntiRagdoll = false; _G.CustomSpeed = 16

-- [[ 1. MAIN UI CONTAINER ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "WL_Main"; Main.Size = UDim2.new(0, 450, 0, 280)
Main.Position = UDim2.new(0.5, -225, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2; Stroke.Color = Color3.fromRGB(255, 0, 127)

-- Sidebar Background
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Text = "WL HUB <font color='#FF007F'>V29.2</font>"; Title.RichText = true
Title.Size = UDim2.new(0, 140, 0, 50); Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1

-- [[ 2. BUTTONS (SIDEBAR - LEFT) ]] --
local function CreateButton(name, pos, callback)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0, 120, 0, 32); Btn.Position = UDim2.new(0, 10, 0, pos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Font = "GothamSemibold"; Btn.TextSize = 11
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 45)
        Btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

CreateButton("AUTO GRAB", 60, function(s) _G.AutoGrab = s end)
CreateButton("AIMLOCK", 100, function(s) _G.Aimlock = s end)
CreateButton("AUTO HIT", 140, function(s) _G.AutoHit = s end)
CreateButton("ANTI RAGDOLL", 180, function(s) _G.AntiRagdoll = s end)
CreateButton("EXIT HUB", 230, function() ScreenGui:Destroy() end)

-- [[ 3. SETTINGS (MAIN PANEL - RIGHT) ]] --
local SettingsLabel = Instance.new("TextLabel", Main)
SettingsLabel.Text = "CONFIGURATIONS"; SettingsLabel.Size = UDim2.new(0, 280, 0, 50)
SettingsLabel.Position = UDim2.new(0, 155, 0, 0); SettingsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SettingsLabel.Font = "GothamBold"; SettingsLabel.TextSize = 14; SettingsLabel.BackgroundTransparency = 1; SettingsLabel.TextXAlignment = "Left"

local function CreateInput(label, pos, default, callback)
    local Lbl = Instance.new("TextLabel", Main)
    Lbl.Text = label; Lbl.Size = UDim2.new(0, 120, 0, 30); Lbl.Position = UDim2.new(0, 155, 0, pos)
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200); Lbl.Font = "Gotham"; Lbl.TextSize = 12; Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1
    
    local Box = Instance.new("TextBox", Main)
    Box.Size = UDim2.new(0, 120, 0, 30); Box.Position = UDim2.new(0, 310, 0, pos)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Box.Text = default; Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.Font = "GothamBold"; Box.TextSize = 13; Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Box).Color = Color3.fromRGB(45, 45, 60)
    
    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

CreateInput("AUTO GRAB RADIUS", 60, "50", function(t) _G.GrabRadius = tonumber(t) or 50 end)
CreateInput("WALK SPEED MOD", 100, "50", function(t) _G.CustomSpeed = math.clamp(tonumber(t) or 16, 0, 80) end)

-- [[ 4. TOGGLE BUTTON (FLOATING WL) ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20); OpenBtn.Text = "WL"; OpenBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 18; OpenBtn.Draggable = true; OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 0, 127)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ 5. ENGINE LOOPS ]] --
rs.Stepped:Connect(function()
    if _G.CustomSpeed > 16 and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.CustomSpeed / 150))
    end
end)

rs.RenderStepped:Connect(function()
    if _G.AutoGrab and hrp then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent and (hrp.Position - v.Parent.Position).Magnitude <= _G.GrabRadius then
                pcall(function() firetouchinterest(hrp, v.Parent, 0); firetouchinterest(hrp, v.Parent, 1) end)
            end
        end
    end
    -- Combat Logic (Aimlock/AutoHit) Continue...
end)
