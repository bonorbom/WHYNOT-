local Fly = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

Fly.Enabled = false
Fly.Speed = 60
Fly.Connection = nil

function Fly.Start()
    if Fly.Enabled then return end
    Fly.Enabled = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local bv = Instance.new("BodyVelocity")
    bv.Name = "BON_FLY"
    bv.MaxForce = Vector3.new(999999,999999,999999)
    bv.Parent = hrp

    Fly.Connection = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end

        if moveDir.Magnitude > 0 then
            bv.Velocity = moveDir.Unit * Fly.Speed
        else
            bv.Velocity = Vector3.zero
        end
    end)
end

function Fly.Stop()
    Fly.Enabled = false

    if Fly.Connection then
        Fly.Connection:Disconnect()
        Fly.Connection = nil
    end

    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local old = char.HumanoidRootPart:FindFirstChild("FLY")
        if old then old:Destroy() end
    end
end

function Fly.Toggle()
    if Fly.Enabled then
        Fly.Stop()
    else
        Fly.Start()
    end
end

return Fly