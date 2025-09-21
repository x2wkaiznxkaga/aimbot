-- variable
local AIM_ENABLED = false
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- func
local function getHead(targetPlayer)
    local character = targetPlayer.Character
    if character then
        return character:FindFirstChild("Head")
    end
    return nil
end

-- check player
local function isInLineOfSight(targetPart)
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).unit * 1000
    local ray = Ray.new(origin, direction)
    local hit, position = workspace:FindPartOnRay(ray, player.Character)

    return hit and hit:IsDescendantOf(targetPart.Parent)
end

-- team check
local function teamsExist()
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer.Team then
            return true
        end
    end
    return false
end

-- enemy detector
local function isEnemy(targetPlayer)
    if teamsExist() then
        return targetPlayer.Team ~= player.Team
    else
        return true  -- If no teams, consider everyone as a target
    end
end

-- check alive
local function isAlive(targetPlayer)
    local character = targetPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            return true
        end
    end
    return false
end

-- check force field
local function hasForceField(targetPlayer)
    local character = targetPlayer.Character
    if character then
        return character:FindFirstChild("ForceField") ~= nil
    end
    return false
end

-- aimbot head
local function aimAtHead()
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer ~= player and isEnemy(targetPlayer) and isAlive(targetPlayer) and not hasForceField(targetPlayer) then
            local head = getHead(targetPlayer)
            if head and isInLineOfSight(head) then
                -- Aim the camera at the head
                camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
                break
            end
        end
    end
end

-- aim assist
local function toggleAim()
    AIM_ENABLED = not AIM_ENABLED
    if AIM_ENABLED then
        print("Aim assist enabled")
    else
        print("Aim assist disabled")
    end
end

-- press P for aimbot enable
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.P and not processed then
        toggleAim()
    end
end)

-- check aimassist enable?
game:GetService("RunService").RenderStepped:Connect(function()
    if AIM_ENABLED then
        aimAtHead()
    end
end)
