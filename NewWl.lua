-- [[ WL HUB V30.7: THE FINAL STABLE BUILD - REPO VERSION ]] --

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")

-- [[ 1. CHARACTER SYSTEM ]] --
local char, hum, hrp
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
local lastGrab = 0

-- [[ 2. UI CONSTRUCTION (PIXEL-PERFECT V30) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 300); Main.Position = UDim2.new(0.5, -230, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 127)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20); OpenBtn.Text = "WL"; OpenBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 18; OpenBtn.Draggable = true; OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 0, 127)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- UI Generators
local function CreateButton(name, pos, callback)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0, 120, 0, 35); Btn.Position = UDim2.new(0, 10, 0, pos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Font = "GothamSemibold"
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local state = false
    Btn.MouseButton1Click:Connect(function() state = not state; Btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 45); callback(state) end)
end

local function CreateInput(label, pos, default, callback)
    local Lbl = Instance.new("TextLabel", Main)
    Lbl.Text = label; Lbl.Size = UDim2.new(0, 120, 0, 30); Lbl.Position = UDim2.new(0, 160, 0, pos); Lbl.TextColor3 = Color3.fromRGB(180, 180, 180); Lbl.Font = "Gotham"; Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1
    local Box = Instance.new("TextBox", Main)
    Box.Size = UDim2.new(0, 130, 0, 30); Box.Position = UDim2.new(0, 310, 0, pos); Box.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Box.Text = tostring(default); Box.TextColor3 = Color3.fromRGB(255, 255, 255); Box.Font = "GothamBold"; Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    Box.FocusLost:Connect(function() callback(tonumber(Box.Text) or default) end)
end

CreateButton("AUTO GRAB", 60, function(s) _G.AutoGrab = s end)
CreateButton("AIMLOCK", 105, function(s) _G.Aimlock = s end)
CreateButton("AUTO HIT", 150, function(s) _G.AutoHit = s end)
CreateButton("ANTI RAGDOLL", 195, function(s) _G.AntiRagdoll = s end)
CreateButton("EXIT HUB", 245, function() ScreenGui:Destroy() end)

CreateInput("GRAB RADIUS", 62, 50, function(v) _G.GrabRadius = v end)
CreateInput("WALK SPEED", 107, 16, function(v) _G.CustomSpeed = math.clamp(v, 0, 100) end)

-- [[ 3. THE MASTER ENGINE ]] --
rs.Heartbeat:Connect(function(delta)
    if not (hrp and hum and hum.Health > 0) then return end

    -- HYPER GRAB (Anti-Lag Optimized)
    if _G.AutoGrab and (tick() - lastGrab > 0.1) then
        lastGrab = tick()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") or v:IsA("ClickDetector") or v:IsA("TouchTransmitter") then
                local target = v.Parent
                if target and target:IsA("BasePart") then
                    if (hrp.Position - target.Position).Magnitude <= tonumber(_G.GrabRadius) then
                        if v:IsA("ProximityPrompt") then v.HoldDuration = 0; fireproximityprompt(v)
                        elseif v:IsA("ClickDetector") then fireclickdetector(v)
                        elseif v:IsA("TouchTransmitter") then pcall(function() firetouchinterest(hrp, target, 0); firetouchinterest(hrp, target, 1) end) end
                    end
                end
            end
        end
    end

    -- SMOOTH HYPER-SPEED (Anti-Kill Bypass)
    if _G.CustomSpeed > 16 and hum.MoveDirection.Magnitude > 0 then
        local targetPos = hrp.Position + (hum.MoveDirection * (_G.CustomSpeed * delta))
        hrp.CFrame = CFrame.new(targetPos, targetPos + hrp.CFrame.LookVector)
    end

    -- GOD-STAND ANTI RAGDOLL
    if _G.AntiRagdoll then
        hum.PlatformStand = false
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = Vector3.new(0,0,0); hrp.RotVelocity = Vector3.new(0,0,0)
        end
    end
    
    -- COMBAT LOGIC
    if (_G.Aimlock or _G.AutoHit) then
        local target, dist = nil, math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                local d = (hrp.Position - p.Character.Head.Position).Magnitude
                if d < dist then dist = d; target = p.Character end
            end
        end
        if target then
            if _G.Aimlock then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Head.Position) end
            if _G.AutoHit and dist <= 15 then local tool = char:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end
        end
    end
end)
