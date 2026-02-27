local p, c, u, r, ts = game.Players.LocalPlayer, game:GetService("CoreGui"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("TweenService")

-- Anti-Double Load
if c:FindFirstChild("WL_LUXURY") then c.WL_LUXURY:Destroy() end

getgenv().S, getgenv().V, getgenv().AR, getgenv().IJ = false, 16, false, false

-- [[ MAIN UI CONSTRUCTION ]] --
local sg = Instance.new("ScreenGui", c); sg.Name = "WL_LUXURY"; sg.ResetOnSpawn = false
local M = Instance.new("Frame", sg); M.Size = UDim2.new(0, 480, 0, 320); M.Position = UDim2.new(0.5, -240, 0.5, -160); M.BackgroundColor3 = Color3.fromRGB(10, 10, 12); M.BorderSizePixel = 0; M.Active, M.Draggable = true, true
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 12)

-- Neon Glow Outline
local Out = Instance.new("UIStroke", M); Out.Thickness = 2.5; Out.ApplyStrokeMode = "Border"
local Grad = Instance.new("UIGradient", Out)
Grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 255))}

-- Sidebar (Luxury Look)
local SBar = Instance.new("Frame", M); SBar.Size = UDim2.new(0, 140, 1, 0); SBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", SBar)
local Title = Instance.new("TextLabel", SBar); Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = "WL HUB"; Title.TextColor3 = Color3.fromRGB(255, 0, 127); Title.Font = "GothamBold"; Title.TextSize = 24; Title.BackgroundTransparency = 1

local Ver = Instance.new("TextLabel", SBar); Ver.Size = UDim2.new(1, 0, 0, 20); Ver.Position = UDim2.new(0, 0, 1, -30); Ver.Text = "v32.0 Premium"; Ver.TextColor3 = Color3.fromRGB(100, 100, 120); Ver.Font = "Gotham"; Ver.TextSize = 12; Ver.BackgroundTransparency = 1

-- Content Area
local Cont = Instance.new("ScrollingFrame", M); Cont.Size = UDim2.new(1, -160, 1, -20); Cont.Position = UDim2.new(0, 150, 0, 10); Cont.BackgroundTransparency = 1; Cont.ScrollBarThickness = 0
Instance.new("UIListLayout", Cont).Padding = UDim.new(0, 8)

-- [[ UI FUNCTIONS ]] --
local function AddToggle(txt, func)
    local Frame = Instance.new("Frame", Cont); Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Frame)
    
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(1, -60, 1, 0); Lbl.Position = UDim2.new(0, 15, 0, 0); Lbl.Text = txt; Lbl.TextColor3 = Color3.new(1,1,1); Lbl.Font = "GothamSemibold"; Lbl.TextSize = 13; Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1
    
    local Tgl = Instance.new("TextButton", Frame); Tgl.Size = UDim2.new(0, 40, 0, 20); Tgl.Position = UDim2.new(1, -50, 0.5, -10); Tgl.BackgroundColor3 = Color3.fromRGB(40, 40, 50); Tgl.Text = ""; Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", Tgl); Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = UDim2.new(0, 2, 0.5, -8); Dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local act = false
    Tgl.MouseButton1Click:Connect(function()
        act = not act
        ts:Create(Tgl, TweenInfo.new(0.3), {BackgroundColor3 = act and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(40, 4
