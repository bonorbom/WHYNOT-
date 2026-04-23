-- HUD.lua

pcall(function()
    game.CoreGui.BONHUD:Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "BONHUD"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0.35,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "BON HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold

local line = Instance.new("Frame")
line.Parent = frame
line.Size = UDim2.new(1,0,0,1)
line.Position = UDim2.new(0,0,0,35)
line.BackgroundColor3 = Color3.fromRGB(45,45,45)
line.BorderSizePixel = 0

local flyBtn = Instance.new("TextButton")
flyBtn.Parent = frame
flyBtn.Size = UDim2.new(0,220,0,40)
flyBtn.Position = UDim2.new(0,20,0,60)
flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.TextSize = 18
flyBtn.Font = Enum.Font.Gotham
flyBtn.Text = "Fly : OFF"
flyBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,8)
btnCorner.Parent = flyBtn

flyBtn.MouseButton1Click:Connect(function()
    _G.BON.Fly.Toggle()

    if _G.BON.Fly.Enabled then
        flyBtn.Text = "Fly : ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0,170,80)
    else
        flyBtn.Text = "Fly : OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    end
end)