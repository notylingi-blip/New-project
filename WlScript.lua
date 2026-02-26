-- [[ WL HUB V30.6: THE CLEANEST STABLE BUILD ]] --

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local char, hum, hrp

-- Character Handler
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
_G.AntiRagdoll = false; _G.CustomSpeed = 16
local lastGrab = 0

-- [[ CORE ENGINE LOOP ]] --
rs.Heartbeat:Connect(function(delta)
    if not (hrp and hum and hum.Health > 0) then return end

    -- 1. OPTIMIZED INSTANT GRAB (Anti-Lag)
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

    -- 2. HYPER SPEED (Smooth Movement)
    if _G.CustomSpeed > 16 and hum.MoveDirection.Magnitude > 0 then
        local targetPos = hrp.Position + (hum.MoveDirection * (_G.CustomSpeed * delta))
        hrp.CFrame = CFrame.new(targetPos, targetPos + hrp.CFrame.LookVector)
    end

    -- 3. GOD-STAND ANTI RAGDOLL
    if _G.AntiRagdoll then
        hum.PlatformStand = false
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = Vector3.new(0,0,0); hrp.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)
