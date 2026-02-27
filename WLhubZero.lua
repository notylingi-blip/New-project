--[[
    WL HUB V32.0 - FULL STABLE BUILD
    Features: 
    - Minimize & Toggle (RightControl)
    - Anti-Ragdoll & InfJump (Fixed Respawn)
    - Luarmor Hybrid Integration
    - Metatable Anti-Kick
]]

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- [[ GLOBAL SETTINGS ]] --
_G.InfJump = false
_G.AntiRagdoll = false
local toggled = true
local minimized = false

-- [[ CHARACTER HANDLER (ANTI-ERROR) ]] --
local char, hum, hrp
local function GetChar()
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid", 10)
    hrp = char:WaitForChild("HumanoidRootPart", 10)
end
player.CharacterAdded:Connect(GetChar)
GetChar()

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "WL_CORE_SYSTEM"

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 480, 0, 350)
Main.Position = UDim2.new(0.5, -240, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 127)
Stroke.Thickness = 1.8

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "WL HUB V32.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Minimize Button
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -45, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MinBtn)

-- Sidebar (Scrollable)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Instance.new("UICorner", Sidebar)

local Scroll = Instance.new("ScrollingFrame", Sidebar)
Scroll.Size = UDim2.new(1, -10, 1, -10)
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 8)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ BUTTON CREATOR ]] --
local function CreateButton(name, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -5, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Instance.new("UICorner", Btn)

    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        ts:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(35, 35, 45)}):Play()
        ts:Create(Btn, TweenInfo.new(0.3), {TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)}):Play()
        callback(active)
    end)
end

-- [[ FEATURES ASSIGNMENT ]] --
CreateButton("ACTIVATE LOADER", function(s) 
    if s then 
        getgenv().ScriptTitle = "WL"
        Main.Visible = false
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c5ed96fe96878d4c553e836e674afb17.lua"))() 
    end 
end)

CreateButton("ANTI RAGDOLL", function(s) _G.AntiRagdoll = s end)
CreateButton("INFINITE JUMP", function(s) _G.InfJump = s end)
CreateButton("EXIT HUB", function() ScreenGui:Destroy() end)

-- [[ MASTER ENGINE (STABLE) ]] --

-- 1. Anti-Kick (Metatable Hook)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 2. Toggle UI (Right Control)
uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        toggled = not toggled
        Main.Visible = toggled
    end
end)

-- 3. Minimize Logic
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ts:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = minimized and UDim2.new(0, 480, 0, 45) or UDim2.new(0, 480, 0, 350)
    }):Play()
    MinBtn.Text = minimized and "+" or "-"
    Main.ClipsDescendants = true
end)

-- 4. Infinite Jump Execution
uis.JumpRequest:Connect(function()
    if _G.InfJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 5. Anti-Ragdoll Loop
rs.Heartbeat:Connect(function()
    if _G.AntiRagdoll and hum and hum.Parent then
        hum.PlatformStand = false
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

print("WL HUB V32.0 LOADED SUCCESSFULLY, BOSS!")
