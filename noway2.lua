-- ============= SIMPLE KEY SYSTEM (NO GUI) =============
local KeySystem = {
    ['Enabled'] = true,
    ['ValidKeys'] = {
        ['9X7K-2M4P-8R6T-1W3Z-5Y7A-9B2C'] = true,  -- Customer 5
        -- Add your keys here
    },
}

-- Simple key verification
local function checkKey()
    if not KeySystem.Enabled then return true end
    
    -- Check for global variable set by user
    if _G.GLORY_KEY and KeySystem.ValidKeys[_G.GLORY_KEY] then
        print("✓ Key accepted!")
        return true
    end
    
    -- Also check ENTERED_KEY as fallback
    if _G.ENTERED_KEY and KeySystem.ValidKeys[_G.ENTERED_KEY] then
        print("✓ Key accepted!")
        return true
    end
    
    print("✗ Invalid or missing key!")
    print("Usage: _G.GLORY_KEY = 'YOUR-KEY-HERE' before loading")
    return false
end

-- Run key check
local keyValid = checkKey()
if not keyValid then
    print("Script blocked: Invalid key")
    return  -- Stop the script
end

print("✓ Glory Script loading...")
-- ============= END KEY SYSTEM =============

local Config = shared.Glory
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local currentTarget = nil
local currentTargetPlayer = nil
local isLocking = false
local triggerEnabled = false
local espLabels = {}
local SpeedEnabled = false
local BaseSpeed = 16
local lastTriggerClick = 0

-- Store original hitbox sizes
local originalSizes = {}

-- Visual elements
local outlinePart = Instance.new("Part")
outlinePart.Anchored = true
outlinePart.CanCollide = false
outlinePart.Transparency = 0.85
outlinePart.BrickColor = BrickColor.new("Grey")
outlinePart.Material = Enum.Material.Neon
outlinePart.Name = "FOVOutline3D"
outlinePart.Parent = Workspace

local targetLine = Drawing.new("Line")
targetLine.Visible = false
targetLine.Thickness = Config['Target Line']['Thickness']
targetLine.Transparency = Config['Target Line']['Transparency']
targetLine.ZIndex = 999

-- Helper Functions
local function isPlayerKnockedOrKO(player)
    if not Config['Settings']['Knock Check'] then return false end
    
    if player and player.Character then
        local bodyEffects = player.Character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local ko = bodyEffects:FindFirstChild("K.O")
            if ko and ko.Value == true then return true end
            
            local knocked = bodyEffects:FindFirstChild("Knocked")
            if knocked and knocked.Value == true then return true end
        end
    end
    return false
end

local function isSelfKnocked()
    if not Config['Settings']['Self Knock Check'] then return false end
    
    if LocalPlayer.Character then
        local bodyEffects = LocalPlayer.Character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local ko = bodyEffects:FindFirstChild("K.O")
            if ko and ko.Value == true then return true end
            
            local knocked = bodyEffects:FindFirstChild("Knocked")
            if knocked and knocked.Value == true then return true end
        end
    end
    return false
end

local function canSeeTarget(part)
    if not Config['Settings']['Visible Check'] then return true end
    if not part or not part.Parent then return false end
    
    local character = part.Parent
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local rayResult = Workspace:Raycast(origin, direction, raycastParams)
    return rayResult == nil or rayResult.Instance:IsDescendantOf(character)
end

-- Simple function to get UpperTorso always
local function getTargetPart(character)
    if not character then return nil end
    
    -- Always try to get UpperTorso first
    local upperTorso = character:FindFirstChild("UpperTorso")
    if upperTorso then
        return upperTorso
    end
    
    -- Fallback to HumanoidRootPart
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp
    end
    
    -- Last resort: any part
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "Handle" then
            return part
        end
    end
    
    return nil
end

local function updateTarget()
    if not currentTargetPlayer or not currentTargetPlayer.Character then
        return false
    end
    
    local newPart = getTargetPart(currentTargetPlayer.Character)
    if newPart then
        currentTarget = newPart
        return true
    end
    
    return false
end

local function findClosestTarget()
    local closestPlayer = nil
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not isPlayerKnockedOrKO(player) then
                local targetPart = getTargetPart(player.Character)
                
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = player
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end
    
    if closestPlayer then
        currentTarget = closestPart
        return closestPlayer
    end
    
    return nil
end

local function getPredictedPosition(part)
    if not Config['Silent Aim']['Use Prediction'] or not part then 
        return part and part.Position or Vector3.new() 
    end
    
    local velocity = part.AssemblyLinearVelocity
    local pred = Config['Silent Aim']['Prediction']
    
    return part.Position + Vector3.new(
        velocity.X * pred.X, 
        velocity.Y * pred.Y, 
        velocity.Z * pred.Z
    )
end

local function applyCameraLock()
    if not isLocking then return end
    if isSelfKnocked() then
        isLocking = false
        targetLine.Visible = false
        return
    end
    
    if not currentTarget or not currentTarget.Parent then
        if not updateTarget() then
            return
        end
    end
    
    if not currentTarget then return end
    
    local targetPos = currentTarget.Position
    if Config['Camera Lock']['Use Prediction'] then
        local velocity = currentTarget.AssemblyLinearVelocity
        local pred = Config['Camera Lock']['Prediction']
        targetPos = targetPos + Vector3.new(velocity.X * pred.X, velocity.Y * pred.Y, velocity.Z * pred.Z)
    end
    
    local cameraCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(cameraCFrame.Position, targetPos)
    
    local smoothConfig = Config['Camera Lock']['Smoothing']
    local alpha = 1 / ((smoothConfig['X'] + smoothConfig['Y'] + smoothConfig['Z']) / 3)
    
    Camera.CFrame = cameraCFrame:Lerp(targetCFrame, alpha)
end

local function update3DFOVBox()
    if not Config['FOV']['Enabled'] or not Config['FOV']['Visible'] then
        outlinePart.Transparency = 1
        return
    end
    
    if currentTargetPlayer and currentTargetPlayer.Character then
        local rootPart = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local offset = Config['FOV']['Size']
            outlinePart.Size = rootPart.Size + Vector3.new(offset, offset, offset)
            outlinePart.CFrame = rootPart.CFrame
            outlinePart.Transparency = 0.85
        else
            outlinePart.Transparency = 1
        end
    else
        outlinePart.Transparency = 1
    end
end

local function updateTargetLine()
    if not Config['Target Line']['Enabled'] or not currentTargetPlayer or not currentTargetPlayer.Character or not isLocking then
        targetLine.Visible = false
        return
    end
    
    local rootPart = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        targetLine.Visible = false
        return
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    
    if onScreen and screenPos.Z > 0 then
        local mousePos = UserInputService:GetMouseLocation()
        
        targetLine.From = Vector2.new(mousePos.X, mousePos.Y)
        targetLine.To = Vector2.new(screenPos.X, screenPos.Y)
        targetLine.Thickness = Config['Target Line']['Thickness']
        targetLine.Transparency = Config['Target Line']['Transparency']
        
        updateTarget()
        
        if currentTarget and canSeeTarget(currentTarget) then
            targetLine.Color = Config['Target Line']['Vulnerable']
        else
            targetLine.Color = Config['Target Line']['Invulnerable']
        end
        
        targetLine.Visible = true
    else
        targetLine.Visible = false
    end
end

local function TriggerBot()
    if not Config['Trigger Bot']['Enabled'] or not triggerEnabled then return end
    if tick() - lastTriggerClick < Config['Trigger Bot']['Delay'] then return end
    
    if Config['Trigger Bot']['Require Target'] and not currentTargetPlayer then return end
    
    if currentTargetPlayer and currentTargetPlayer.Character then
        updateTarget()
        if not currentTarget or not canSeeTarget(currentTarget) then return end
    end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        lastTriggerClick = tick()
    end
end

-- SIMPLE SILENT AIM - Always aims at UpperTorso
local grm = getrawmetatable(game)
local oldIndex = grm.__index
local oldNamecall = grm.__namecall
setreadonly(grm, false)

-- Override Mouse.Hit (works for most weapons)
grm.__index = function(self, key)
    if not checkcaller() and self == Mouse and Config['Silent Aim']['Enabled'] then
        if key == "Hit" then
            if currentTargetPlayer and currentTargetPlayer.Character then
                local targetPart = getTargetPart(currentTargetPlayer.Character)
                if targetPart then
                    if Config['Settings']['Visible Check'] and not canSeeTarget(targetPart) then
                        return oldIndex(self, key)
                    end
                    
                    local targetPos = getPredictedPosition(targetPart)
                    return CFrame.new(targetPos)
                end
            end
            return oldIndex(self, key)
        end
    end
    return oldIndex(self, key)
end

-- Override raycast methods (for shotguns and other weapons)
grm.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and Config['Silent Aim']['Enabled'] and currentTargetPlayer and currentTargetPlayer.Character then
        local targetPart = getTargetPart(currentTargetPlayer.Character)
        
        if targetPart and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
            if Config['Settings']['Visible Check'] and not canSeeTarget(targetPart) then
                return oldNamecall(self, ...)
            end
            
            local targetPos = getPredictedPosition(targetPart)
            
            if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" then
                local ray = self
                if typeof(ray) == "Ray" then
                    local newRay = Ray.new(ray.Origin, (targetPos - ray.Origin).Unit * 1000)
                    
                    if method == "FindPartOnRay" then
                        return oldNamecall(newRay)
                    else
                        return oldNamecall(newRay, args[2])
                    end
                end
            elseif method == "Raycast" then
                local origin = args[1]
                local direction = args[2]
                if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                    args[2] = (targetPos - origin).Unit * direction.Magnitude
                    return oldNamecall(self, unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end

setreadonly(grm, true)

-- Simple spread control
local oldRandom = hookfunction(math.random, function(...)
    local args = {...}
    if checkcaller() then return oldRandom(...) end
    
    if Config['Spread']['Enabled'] then
        if (#args == 0) or (args[1] == -0.05 and args[2] == 0.05) then
            return oldRandom(...) * (Config['Spread']['Amount'] / 100)
        end
    end
    
    return oldRandom(...)
end)

-- ESP Functions (simplified)
local function addESPToPlayer(player)
    if player == LocalPlayer then return end
    
    local esp = {
        player = player,
        nameTag = Drawing.new("Text"),
    }
    
    esp.nameTag.Size = 14
    esp.nameTag.Center = true
    esp.nameTag.Outline = true
    esp.nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.nameTag.Color = Config['Visual Awareness']['Color']
    esp.nameTag.Font = Drawing.Fonts.Plex
    esp.nameTag.Visible = false
    
    espLabels[player.UserId] = esp
end

local function refreshESP()
    if not Config['Visual Awareness']['Enabled'] then
        for _, esp in pairs(espLabels) do
            esp.nameTag.Visible = false
        end
        return
    end
    
    for userId, esp in pairs(espLabels) do
        local player = esp.player
        if not player or not player.Parent then
            esp.nameTag:Remove()
            espLabels[userId] = nil
            continue
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local espPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2.8, 0))
            
            if onScreen and espPos.Z > 0 then
                esp.nameTag.Position = Vector2.new(espPos.X, espPos.Y)
                esp.nameTag.Text = Config['Visual Awareness']['Use Display Name'] and player.DisplayName or player.Name
                esp.nameTag.Color = (currentTargetPlayer == player) and Config['Visual Awareness']['Target Color'] or Config['Visual Awareness']['Color']
                esp.nameTag.Visible = true
            else
                esp.nameTag.Visible = false
            end
        else
            esp.nameTag.Visible = false
        end
    end
end

-- Initialize ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        addESPToPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        addESPToPlayer(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if currentTargetPlayer == player then
        currentTargetPlayer = nil
        currentTarget = nil
        isLocking = false
    end
    local esp = espLabels[player.UserId]
    if esp then
        esp.nameTag:Remove()
        espLabels[player.UserId] = nil
    end
end)

-- Hitbox Expander (simplified)
local function expandHitbox(part, size)
    if not part then return end
    if not originalSizes[part] then
        originalSizes[part] = part.Size
    end
    part.Size = Vector3.new(size, size, size)
end

local function resetHitboxes()
    for part, size in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = size
        end
    end
    table.clear(originalSizes)
end

local function applyHitboxExpansion()
    if not Config['Hitbox Expander']['Enabled'] then 
        resetHitboxes()
        return 
    end
    
    local expandSize = Config['Hitbox Expander']['Size']
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                expandHitbox(hrp, expandSize)
            end
        end
    end
end

-- Main loop
RunService.RenderStepped:Connect(function()
    if isSelfKnocked() and isLocking then
        isLocking = false
        targetLine.Visible = false
    end
    
    if currentTargetPlayer and currentTargetPlayer.Character then
        if not currentTarget or not currentTarget.Parent then
            updateTarget()
        end
    end
    
    TriggerBot()
    
    if SpeedEnabled and Config['Speed']['Enabled'] then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = BaseSpeed * Config['Speed']['Multiplier']
        end
    end
    
    applyHitboxExpansion()
    update3DFOVBox()
    updateTargetLine()
    refreshESP()
    
    if Config['Camera Lock']['Enabled'] then
        applyCameraLock()
    end
end)

-- Input handling
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']
        
        if mode == 'Toggle' then
            if isLocking then
                isLocking = false
                currentTargetPlayer = nil
                currentTarget = nil
                targetLine.Visible = false
            else
                local targetPlayer = findClosestTarget()
                if targetPlayer then
                    currentTargetPlayer = targetPlayer
                    isLocking = true
                end
            end
        elseif mode == 'Hold' then
            local targetPlayer = findClosestTarget()
            if targetPlayer then
                currentTargetPlayer = targetPlayer
                isLocking = true
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']
        triggerEnabled = (mode == 'Toggle') and not triggerEnabled or true
    end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Speed']] then
        SpeedEnabled = not SpeedEnabled
        if not SpeedEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = BaseSpeed
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['ESP']] then
        Config['Visual Awareness']['Enabled'] = not Config['Visual Awareness']['Enabled']
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        if Config['Keybinds']['Target Lock']['Mode'] == 'Hold' then
            isLocking = false
            currentTargetPlayer = nil
            currentTarget = nil
            targetLine.Visible = false
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        if Config['Keybinds']['Trigger Bot']['Mode'] == 'Hold' then
            triggerEnabled = false
        end
    end
end)

