-- AutoFram.lua

local AutoFarm = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

AutoFarm.Enabled = false
AutoFarm.FlyConnection = nil
AutoFarm.HitConnection = nil
AutoFarm.LockedEnemy = nil
AutoFarm.LastHitTime = 0
AutoFarm.HitDelay = 0.5 -- 0.5s/lần đánh
AutoFarm.EnemyFolder = workspace:FindFirstChild("Enemies") or workspace
AutoFarm.ItemFolder = workspace:FindFirstChild("Items") or workspace

-- Hàm tìm quái gần nhất
function AutoFarm.FindNearestEnemy()
    local nearestEnemy = nil
    local shortestDist = math.huge

    for _, enemy in pairs(AutoFarm.EnemyFolder:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            local enemyHumanoid = enemy:FindFirstChild("Humanoid")
            
            -- Kiểm tra quái còn sống
            if enemyHumanoid.Health > 0 then
                local distance = (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude
                
                if distance < shortestDist then
                    shortestDist = distance
                    nearestEnemy = enemy
                end
            end
        end
    end

    return nearestEnemy
end

-- Hàm bay lên trên đầu quái
function AutoFarm.FlyAboveEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local enemyPos = enemy.HumanoidRootPart.Position
    local targetPos = enemyPos + Vector3.new(0, 8, 0) -- Bay 8 units lên trên đầu quái

    local distance = (hrp.Position - targetPos).Magnitude
    
    if distance > 1 then
        -- Bay về phía quái
        local direction = (targetPos - hrp.Position).Unit
        local bodyVelocity = hrp:FindFirstChild("BON_FLY")
        
        if bodyVelocity then
            bodyVelocity.Velocity = direction * 60 -- Tốc độ bay
        end
        return false
    else
        -- Đã đến vị trí trên đầu quái
        local bodyVelocity = hrp:FindFirstChild("BON_FLY")
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.zero
        end
        return true
    end
end

-- Hàm tìm vũ khí melee gần nhất
function AutoFarm.FindMeleeWeapon()
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            -- Kiểm tra các loại vũ khí melee (có thể tùy chỉnh theo game)
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    return tool
                end
            end
        end
    end
    
    -- Kiểm tra trong tay
    if char:FindFirstChildOfClass("Tool") then
        return char:FindFirstChildOfClass("Tool")
    end
    
    return nil
end

-- Hàm tăng hitbox quái
function AutoFarm.ExpandEnemyHitbox(enemy)
    if not enemy then return end
    
    for _, part in pairs(enemy:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Tăng hitbox lên 10
            local originalSize = part.Size
            part.Size = originalSize * 10
            
            -- Giấu phần tử để đỡ khó nhìn
            if part:FindFirstChild("Mesh") then
                part:FindFirstChild("Mesh").Scale = Vector3.new(0.1, 0.1, 0.1)
            end
            if part:FindFirstChild("SpecialMesh") then
                part:FindFirstChild("SpecialMesh").Scale = Vector3.new(0.1, 0.1, 0.1)
            end
        end
    end
end

-- Hàm đánh quái
function AutoFarm.AttackEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("Humanoid") then
        return false
    end

    local humanoid = enemy:FindFirstChild("Humanoid")
    
    -- Kiểm tra quái còn sống
    if humanoid.Health <= 0 then
        AutoFarm.LockedEnemy = nil
        return false
    end

    -- Lấy vũ khí
    local weapon = AutoFarm.FindMeleeWeapon()
    
    if weapon then
        -- Trang bị vũ khí nếu chưa trang bị
        if not char:FindFirstChild(weapon.Name) then
            weapon.Parent = char
        end

        -- Kiểm tra thời gian đánh
        local currentTime = tick()
        if currentTime - AutoFarm.LastHitTime >= AutoFarm.HitDelay then
            -- Click/đánh quái
            if weapon:FindFirstChild("Handle") then
                -- Simulate attack - tùy vào game mechanics
                local remote = weapon:FindFirstChild("Hit") or weapon:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    remote:FireServer(enemy)
                else
                    -- Fallback: Activate tool
                    weapon:Activate()
                end
            end
            
            AutoFarm.LastHitTime = currentTime
        end
        
        return true
    end

    return false
end

-- Hàm chính của Auto Farm
function AutoFarm.Start()
    if AutoFarm.Enabled then return end
    AutoFarm.Enabled = true

    -- Bắt đầu bay với Fly module
    if _G.BON and _G.BON.Fly then
        _G.BON.Fly.Start()
    end

    -- Loop chính
    AutoFarm.FlyConnection = RunService.RenderStepped:Connect(function()
        if not AutoFarm.Enabled then return end

        char = player.Character or char
        hrp = char and char:FindFirstChild("HumanoidRootPart") or hrp

        if not hrp then return end

        -- Tìm quái nếu chưa lock
        if not AutoFarm.LockedEnemy or not AutoFarm.LockedEnemy:FindFirstChild("Humanoid") or AutoFarm.LockedEnemy.Humanoid.Health <= 0 then
            AutoFarm.LockedEnemy = AutoFarm.FindNearestEnemy()
            
            if AutoFarm.LockedEnemy then
                -- Tăng hitbox quái
                AutoFarm.ExpandEnemyHitbox(AutoFarm.LockedEnemy)
            end
        end

        if AutoFarm.LockedEnemy and AutoFarm.LockedEnemy:FindFirstChild("Humanoid") and AutoFarm.LockedEnemy.Humanoid.Health > 0 then
            -- Bay lên trên đầu quái
            local isAbove = AutoFarm.FlyAboveEnemy(AutoFarm.LockedEnemy)

            -- Nếu đã ở trên đầu quái, bắt đầu đánh
            if isAbove then
                AutoFarm.AttackEnemy(AutoFarm.LockedEnemy)
            end
        else
            -- Quái chết, dừng và chờ quái mới
            AutoFarm.LockedEnemy = nil
            
            local bodyVelocity = hrp:FindFirstChild("BON_FLY")
            if bodyVelocity then
                bodyVelocity.Velocity = Vector3.zero
            end
        end
    end)
end

function AutoFarm.Stop()
    AutoFarm.Enabled = false
    AutoFarm.LockedEnemy = nil

    if AutoFarm.FlyConnection then
        AutoFarm.FlyConnection:Disconnect()
        AutoFarm.FlyConnection = nil
    end

    if AutoFarm.HitConnection then
        AutoFarm.HitConnection:Disconnect()
        AutoFarm.HitConnection = nil
    end

    -- Dừng bay
    if _G.BON and _G.BON.Fly then
        _G.BON.Fly.Stop()
    end

    -- Giải tr除 vũ khí
    if char:FindFirstChildOfClass("Tool") then
        char:FindFirstChildOfClass("Tool").Parent = player:FindFirstChild("Backpack") or player
    end
end

function AutoFarm.Toggle()
    if AutoFarm.Enabled then
        AutoFarm.Stop()
    else
        AutoFarm.Start()
    end
end

return AutoFarm
