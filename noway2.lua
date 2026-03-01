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

-- Body parts priority for aiming (head is highest priority)
local BODY_PARTS = {
    "Head",
    "UpperTorso",
    "HumanoidRootPart",
    "LowerTorso",
    "LeftUpperArm",
    "RightUpperArm",
    "LeftLowerArm",
    "RightLowerArm",
    "LeftUpperLeg",
    "RightUpperLeg",
    "LeftLowerLeg",
    "RightLowerLeg"
}

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
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character, outlinePart}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local rayResult = Workspace:Raycast(origin, direction, raycastParams)
    return rayResult == nil or rayResult.Instance:IsDescendantOf(character)
end

-- Improved function to get target body part with priority
local function getBestTargetPart(character)
    if not character then return nil end
    
    -- Try to get body parts in order of priority
    for _, partName in ipairs(BODY_PARTS) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    
    -- Fallback: find any BasePart
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "Handle" then
            return part
        end
    end
    
    return nil
end

local function updateTargetPart()
    if not currentTargetPlayer or not currentTargetPlayer.Character then
        return false
    end
    
    local newPart = getBestTargetPart(currentTargetPlayer.Character)
    if newPart then
        currentTarget = newPart
        return true
    end
    
    return false
end

local function findClosestTargetPlayerForLock()
    local closestPlayer = nil
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not isPlayerKnockedOrKO(player) then
                local targetPart = getBestTargetPart(player.Character)
                
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

local function getPredictedPosition(part, config)
    if not config['Use Prediction'] or not part then return part and part.Position or Vector3.new() end
    
    local velocity = part.AssemblyLinearVelocity
    local prediction = config['Prediction']
    
    local predValue
    if type(prediction) == "table" then
        predValue = prediction['X'] or prediction['Y'] or prediction['Z'] or 0.133
    else
        predValue = (prediction == 0) and 0.133 or prediction
    end
    
    return part.Position + Vector3.new(
        velocity.X * predValue, 
        velocity.Y * predValue, 
        velocity.Z * predValue
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
        if not updateTargetPart() then
            return
        end
    end
    
    if not currentTarget then return end
    
    local targetPos = getPredictedPosition(currentTarget, Config['Camera Lock'])
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
        
        updateTargetPart()
        
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
        updateTargetPart()
        
        if not currentTarget or not canSeeTarget(currentTarget) then return end
    end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        lastTriggerClick = tick()
    end
end

-- Improved Silent Aim with weapon type detection
local function isShotgun(tool)
    if not tool then return false end
    
    local toolName = tool.Name:lower()
    -- Common shotgun names in Da Hood
    local shotgunNames = {"shotgun", "db", "doublebarrel", "remington", "spas"}
    
    for _, name in ipairs(shotgunNames) do
        if toolName:find(name) then
            return true
        end
    end
    
    -- Check for shotgun-specific traits
    local handle = tool:FindFirstChild("Handle")
    if handle then
        -- Some shotguns might have specific attributes
        if handle:FindFirstChild("ShotgunPellet") or handle:FindFirstChild("Spread") then
            return true
        end
    end
    
    return false
end

-- Silent Aim
local grm = getrawmetatable(game)
local oldIndex = grm.__index
local oldNamecall = grm.__namecall
setreadonly(grm, false)

-- Override __index for Mouse.Hit
grm.__index = function(self, key)
    if not checkcaller() and self == Mouse then
        -- For Mouse.Hit (silent aim)
        if key == "Hit" and Config['Silent Aim']['Enabled'] then
            if currentTargetPlayer and currentTargetPlayer.Character then
                updateTargetPart()
                
                if currentTarget then
                    if Config['Settings']['Visible Check'] and not canSeeTarget(currentTarget) then
                        return oldIndex(self, key)
                    end
                    
                    local predictedPos = getPredictedPosition(currentTarget, Config['Silent Aim'])
                    
                    -- Check current tool to adjust aim position
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if isShotgun(tool) then
                        -- For shotguns, aim slightly higher to prevent floor aiming
                        predictedPos = predictedPos + Vector3.new(0, 1.5, 0)
                    end
                    
                    return CFrame.new(predictedPos)
                end
            end
            
            return oldIndex(self, key)
        end
        
        -- For Mouse.Target (optional, helps with raycast weapons)
        if key == "Target" and Config['Silent Aim']['Enabled'] then
            if currentTarget then
                return currentTarget
            end
        end
        
        -- For Mouse.UnitRay (used by some weapons)
        if key == "UnitRay" and Config['Silent Aim']['Enabled'] then
            if currentTarget then
                local direction = (currentTarget.Position - Camera.CFrame.Position).Unit
                return Ray.new(Camera.CFrame.Position, direction)
            end
        end
    end
    return oldIndex(self, key)
end

-- Override __namecall for FindPartOnRay (used by many weapons)
grm.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and Config['Silent Aim']['Enabled'] and currentTarget then
        -- Handle raycast methods
        if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
            local ray = self
            if type(ray) == "userdata" and tostring(ray):match("Ray") then
                -- Create a new ray pointing at the target
                local direction = (currentTarget.Position - ray.Origin).Unit * 1000
                local newRay = Ray.new(ray.Origin, direction)
                return oldNamecall(unpack({newRay, table.unpack(args, 2)}))
            end
        end
    end
    
    return oldNamecall(self, ...)
end

setreadonly(grm, true)

-- Spread control
local oldRandom
oldRandom = hookfunction(math.random, function(...)
    local args = {...}
    if checkcaller() then return oldRandom(...) end
    
    if (#args == 0) or (args[1] == -0.05 and args[2] == 0.05) or (args[1] == -0.1) or (args[1] == -0.05) then
        if Config['Spread']['Enabled'] then
            return oldRandom(...) * (Config['Spread']['Amount'] / 100)
        end
    end
    
    return oldRandom(...)
end)

-- ESP Functions (rest remains the same as original)
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
    esp.nameTag.ZIndex = 1000
    
    espLabels[player.UserId] = esp
end

local function removeESPFromPlayer(player)
    local esp = espLabels[player.UserId]
    if esp then
        esp.nameTag:Remove()
        espLabels[player.UserId] = nil
    end
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
            esp.nameTag.Visible = false
            esp.nameTag:Remove()
            espLabels[userId] = nil
            continue
        end
        
        if player.Character and player.Character.Parent and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                esp.nameTag.Visible = false
                continue
            end
            
            local rootPart = player.Character.HumanoidRootPart
            local espPosition, onScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2.8, 0))
            
            if onScreen and espPosition.Z > 0 then
                esp.nameTag.Position = Vector2.new(espPosition.X, espPosition.Y)
                esp.nameTag.Text = Config['Visual Awareness']['Use Display Name'] and player.DisplayName or player.Name
                
                if currentTargetPlayer == player then
                    esp.nameTag.Color = Config['Visual Awareness']['Target Color']
                else
                    esp.nameTag.Color = Config['Visual Awareness']['Color']
                end
                
                esp.nameTag.Visible = true
            else
                esp.nameTag.Visible = false
            end
        else
            esp.nameTag.Visible = false
        end
    end
end

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        addESPToPlayer(player)
    end
end

-- Player connection handling
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
    removeESPFromPlayer(player)
end)

local function setupCharacterMonitor(player)
    if player ~= currentTargetPlayer then return end
    
    player.CharacterAdded:Connect(function(character)
        if player == currentTargetPlayer then
            task.wait(0.5)
            local newPart = getBestTargetPart(character)
            if newPart then
                currentTarget = newPart
            end
        end
    end)
end

-- HITBOX MANAGEMENT FUNCTIONS
local function storeOriginalSize(part)
    if not part or originalSizes[part] then return end
    originalSizes[part] = part.Size
end

local function restoreOriginalSize(part)
    if part and originalSizes[part] then
        part.Size = originalSizes[part]
    end
end

local function expandHitbox(part, size)
    if not part then return end
    storeOriginalSize(part)
    part.Size = Vector3.new(size, size, size)
end

local function resetAllHitboxes()
    for part, originalSize in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = originalSize
        else
            originalSizes[part] = nil
        end
    end
end

local function applyHitboxExpansion()
    if not Config['Hitbox Expander']['Enabled'] then 
        resetAllHitboxes()
        return 
    end
    
    local expandSize = Config['Hitbox Expander']['Size']
    
    -- If we have a locked target
    if isLocking and currentTargetPlayer and currentTargetPlayer.Character then
        -- First, reset all players' hitboxes to normal
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    restoreOriginalSize(hrp)
                end
            end
        end
        
        -- Then ONLY expand the locked target's hitbox
        local targetHrp = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp then
            expandHitbox(targetHrp, expandSize)
        end
    else
        -- No target locked - expand EVERYONE'S hitbox (default behavior)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    expandHitbox(hrp, expandSize)
                end
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
            updateTargetPart()
        end
    elseif currentTargetPlayer and not currentTargetPlayer.Character then
        currentTarget = nil
    end
    
    TriggerBot()
    
    -- Speed
    if SpeedEnabled and Config['Speed']['Enabled'] then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = BaseSpeed * Config['Speed']['Multiplier']
        end
    end
    
    -- Hitbox Expander
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
    
    -- Target Lock
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']
        
        if mode == 'Toggle' then
            if Config['Settings']['Target Aim'] then
                if isLocking then
                    isLocking = false
                    currentTargetPlayer = nil
                    currentTarget = nil
                    targetLine.Visible = false
                else
                    local targetPlayer = findClosestTargetPlayerForLock()
                    if targetPlayer then
                        currentTargetPlayer = targetPlayer
                        setupCharacterMonitor(targetPlayer)
                        isLocking = true
                    end
                end
            else
                isLocking = not isLocking
                if not isLocking then
                    targetLine.Visible = false
                end
            end
        elseif mode == 'Hold' then
            if Config['Settings']['Target Aim'] then
                local targetPlayer = findClosestTargetPlayerForLock()
                if targetPlayer then
                    currentTargetPlayer = targetPlayer
                    setupCharacterMonitor(targetPlayer)
                    isLocking = true
                end
            else
                isLocking = true
            end
        end
    end
    
    -- Trigger Bot
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']
        
        if mode == 'Toggle' then
            triggerEnabled = not triggerEnabled
        elseif mode == 'Hold' then
            triggerEnabled = true
        end
    end
    
    -- Speed Toggle
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Speed']] then
        SpeedEnabled = not SpeedEnabled
        if not SpeedEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = BaseSpeed
            end
        end
    end
    
    -- ESP Toggle
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['ESP']] then
        Config['Visual Awareness']['Enabled'] = not Config['Visual Awareness']['Enabled']
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    
    -- Target Lock hold mode release
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']
        if mode == 'Hold' then
            isLocking = false
            currentTargetPlayer = nil
            currentTarget = nil
            targetLine.Visible = false
        end
    end
    
    -- Trigger Bot hold mode release
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']
        if mode == 'Hold' then
            triggerEnabled = false
        end
    end
end)




