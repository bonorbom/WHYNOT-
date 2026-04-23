local Fly = require(script.Parent.Fly)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BONHUD"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,220)
frame.Position = UDim2.new(0.35,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0,220,0,40)
btn.Position = UDim2.new(0,20,0,60)
btn.Text = "Fly : OFF"

btn.MouseButton1Click:Connect(function()
    Fly.Toggle()

    if Fly.Enabled then
        btn.Text = "Fly : ON"
    else
        btn.Text = "Fly : OFF"
    end
end)