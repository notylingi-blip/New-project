-- [[ WL HUB V32.0: THE FINAL LUARMOR HYBRID BUILD ]] --

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local char, hum, hrp

-- [[ 1. CHARACTER SYSTEM ]] --
local function UpdateVars(newChar)
    if not newChar then return end
    char = newChar
    hum = char:WaitForChild("Humanoid", 15)
    hrp = char:WaitForChild("HumanoidRootPart", 15)
end
player.CharacterAdded:Connect(UpdateVars)
UpdateVars(player.Character or player.CharacterAdded:Wait())

-- Globals
_G.AutoGrab = false
_G.AntiRagdoll = false
_G.InfJump = false
_G.PlayerESP = false
_G.Tracers = false
_G.ShowRadius = true
_G.GrabRadius = 50

-- [[ 2. VISUAL RADIUS RING ]] --
local RadiusRing = Instance.new("Part")
RadiusRing.Name = "WL_RadiusRing"; RadiusRing.Parent = workspace
RadiusRing.Shape = Enum.PartType.Cylinder; RadiusRing.Material = Enum.Material.ForceField
RadiusRing.Color = Color3.fromRGB(255, 0, 127); RadiusRing.Transparency = 0.5
RadiusRing.CanCollide = false; RadiusRing.Anchored = true

-- [[ 3. UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 420); Main.Position = UDim2.new(0.5, -230, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 127)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local function CreateButton(name, pos, callback)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0, 120, 0, 30); Btn.Position = UDim2.new(0, 10, 0, pos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = "GothamBold"; Btn.TextSize = 9
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local state = (name == "SHOW RADIUS")
    if state then Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 127) end
    Btn.MouseButton1Click:Connect(function() 
        state = not state; Btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 45); callback(state) 
    end)
end

-- Controls
CreateButton("AUTO GRAB", 50, function(s) 
    _G.AutoGrab = s 
    if s then 
        -- Memanggil Script Luarmor Pilihan Lu
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))()
    end 
end)
CreateButton("ANTI RAGDOLL", 90, function(s) _G.AntiRagdoll = s end)
CreateButton("INFINITE JUMP", 130, function(s) _G.InfJump = s end)
CreateButton("PLAYER ESP", 170, function(s) _G.PlayerESP = s end)
CreateButton("TRACERS", 210, function(s) _G.Tracers = s end)
CreateButton("SHOW RADIUS", 250, function(s) _G.ShowRadius = s end)
CreateButton("EXIT HUB", 350, function() ScreenGui:Destroy(); RadiusRing:Destroy() end)

-- [[ 4. ESP SYSTEM ]] --
local function CreateESP(p)
    local Box = Drawing.new("Square"); Box.Visible = false; Box.Color = Color3.fromRGB(255, 0, 127); Box.Thickness = 1
    local Line = Drawing.new("Line"); Line.Visible = false; Line.Color = Color3.fromRGB(255, 0, 127); Line.Thickness = 1
    rs.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= player then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if _G.PlayerESP and onScreen then
                Box.Size = Vector2.new(1000/pos.Z, 1500/pos.Z); Box.Position = Vector2.new(pos.X-Box.Size.X/2, pos.Y-Box.Size.Y/2); Box.Visible = true
            else Box.Visible = false end
            if _G.Tracers and onScreen then
                Line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); Line.To = Vector2.new(pos.X, pos.Y); Line.Visible = true
            else Line.Visible = false end
        else Box.Visible = false; Line.Visible = false end
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do CreateESP(p) end
game.Players.PlayerAdded:Connect(CreateESP)

-- [[ 5. MASTER ENGINE ]] --
uis.JumpRequest:Connect(function() if _G.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

rs.Heartbeat:Connect(function()
    if not (hrp and hum and hum.Health > 0) then RadiusRing.Transparency = 1; return end
    
    -- Visual Ring
    if _G.ShowRadius then
        local r = tonumber(_G.GrabRadius) or 50
        RadiusRing.Transparency = 0.6; RadiusRing.Size = Vector3.new(0.1, r*2, r*2)
        RadiusRing.CFrame = hrp.CFrame * CFrame.Angles(0,0,math.rad(90)) * CFrame.new(-3.2,0,0)
    else RadiusRing.Transparency = 1 end

    -- Physics Override
    if _G.AntiRagdoll then
        hum.PlatformStand = false; hum.Sit = false
        hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(-50, hrp.Velocity.Y), hrp.Velocity.Z)
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
