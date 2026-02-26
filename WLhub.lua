-- [[ WL HUB V28.3: FINAL STABLE VERSION ]] --

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")

-- [[ CHARACTER HANDLER ]] --
local char, hum, hrp
local function UpdateVars(newChar)
    if not newChar then return end
    char = newChar
    hum = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
end
player.CharacterAdded:Connect(UpdateVars)
UpdateVars(player.Character or player.CharacterAdded:Wait())

-- [[ STEALTH & PHYSICS ]] --
_G.AutoGrab = false; _G.GrabRadius = 50
_G.Aimlock = false; _G.AutoHit = false
_G.AntiRagdoll = false; _G.CustomSpeed = 16

-- Movement Stabilizer
rs.Stepped:Connect(function()
    if _G.CustomSpeed > 16 and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.CustomSpeed / 150))
    end
end)

-- [[ UI ENGINE ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20); OpenBtn.Text = "WL"; OpenBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 18; OpenBtn.Draggable = true; OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 0, 127)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 127)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ COMPONENT MAKER ] --
local function CreateButton(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 130, 0, 35); Btn.Position = UDim2.new(0, 10, 0, pos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = "GothamSemibold"; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 45)
        callback(state)
    end)
end

CreateButton("AUTO GRAB", 70, function(s) _G.AutoGrab = s end)
CreateButton("AIMLOCK", 115, function(s) _G.Aimlock = s end)
CreateButton("AUTO HIT", 160, function(s) _G.AutoHit = s end)
CreateButton("ANTI RAGDOLL", 205, function(s) _G.AntiRagdoll = s end)
CreateButton("EXIT HUB", 250, function() ScreenGui:Destroy() end)

-- [[ COMBAT LOOPS ]] --
rs.RenderStepped:Connect(function()
    if not (hrp and hum) then return end
    
    if _G.AutoGrab then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent and (hrp.Position - v.Parent.Position).Magnitude <= _G.GrabRadius then
                pcall(function() firetouchinterest(hrp, v.Parent, 0); firetouchinterest(hrp, v.Parent, 1) end)
            end
        end
    end
    
    if _G.Aimlock or _G.AutoHit then
        local target, dist = nil, math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                local d = (hrp.Position - p.Character.Head.Position).Magnitude
                if d < dist then dist = d; target = p.Character end
            end
        end
        if target then
            if _G.Aimlock then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Head.Position) end
            if _G.AutoHit and dist <= 15 then 
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end -- FIXED: Hanya aktivasi jika tool tersedia
            end
        end
    end
end)
