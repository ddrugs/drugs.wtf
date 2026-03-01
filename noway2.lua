-- ============= SIMPLE KEY SYSTEM (NO GUI) =============
local KeySystem = {
    ['Enabled'] = true,
    ['ValidKeys'] = {
        ['ABC-123'] = true,  -- Customer 5
        -- Add your keys here
    },
}

-- Simple console-based key verification
local function checkKey()
    if not KeySystem.Enabled then return true end
    
    print("=== GLORY SCRIPT - KEY REQUIRED ===")
    print("Please enter your key:")
    
    local success, key = pcall(function()
        return syn and syn.request and syn.request({
            Url = "http://httpbin.org/get",  -- Dummy request to pause
            Method = "GET"
        })
    end)
    
    -- Simpler approach: check if key exists in script args
    local args = {...}  -- Get script arguments
    
    -- Method 1: Check if key is in the script's arguments (for injectors that support it)
    for i, arg in ipairs(args) do
        if KeySystem.ValidKeys[tostring(arg)] then
            print("✓ Key accepted!")
            return true
        end
    end
    
    -- Method 2: Check for global variable set by user
    if _G.ENTERED_KEY and KeySystem.ValidKeys[_G.ENTERED_KEY] then
        print("✓ Key accepted!")
        return true
    end
    
    -- Method 3: Check a specific global variable name
    if _G.GLORY_KEY and KeySystem.ValidKeys[_G.GLORY_KEY] then
        print("✓ Key accepted!")
        return true
    end
    
    print("✗ Invalid or missing key!")
    print("Valid keys: " .. table.concat(table.getkeys(KeySystem.ValidKeys), ", "))
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
local lastHitboxUpdate = 0

-- Store original hitbox sizes (use weak keys to prevent memory leaks)
local originalSizes = setmetatable({}, {__mode = "k"})

-- Visual elements
local outlinePart = Instance.new("Part")
outlinePart.Anchored = true
outlinePart.CanCollide = false
outlinePart.Transparency = 1 -- Start invisible
outlinePart.BrickColor = BrickColor.new("Grey")
outlinePart.Material = Enum.Material.Neon
outlinePart.Name = "FOVOutline3D"
outlinePart.Size = Vector3.new(1, 1, 1)
outlinePart.Parent = Workspace

local targetLine = Drawing.new("Line")
targetLine.Visible = false
targetLine.Thickness = Config['Target Line']['Thickness'] or 2
targetLine.Transparency = Config['Target Line']['Transparency'] or 1
targetLine.ZIndex = 999

-- Cache for frequently accessed values
local knockCheck = Config['Settings']['Knock Check']
local selfKnockCheck = Config['Settings']['Self Knock Check']
local visibleCheck = Config['Settings']['Visible Check']
local targetAimMode = Config['Settings']['Target Aim']

-- Optimized helper functions
local function isPlayerKnockedOrKO(player)
    if not knockCheck or not player or not player.Character then return false end
    
    local bodyEffects = player.Character:FindFirstChild("BodyEffects")
    if bodyEffects then
        return (bodyEffects:FindFirstChild("K.O") and bodyEffects:FindFirstChild("K.O").Value == true) or
               (bodyEffects:FindFirstChild("Knocked") and bodyEffects:FindFirstChild("Knocked").Value == true)
    end
    return false
end

local function isSelfKnocked()
    if not selfKnockCheck or not LocalPlayer.Character then return false end
    
    local bodyEffects = LocalPlayer.Character:FindFirstChild("BodyEffects")
    if bodyEffects then
        return (bodyEffects:FindFirstChild("K.O") and bodyEffects:FindFirstChild("K.O").Value == true) or
               (bodyEffects:FindFirstChild("Knocked") and bodyEffects:FindFirstChild("Knocked").Value == true)
    end
    return false
end

local function canSeeTarget(part)
    if not visibleCheck or not part or not part.Parent then return true end
    
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

-- Cache part priorities
local partPriority = {
    Head = 5,
    UpperTorso = 4,
    HumanoidRootPart = 3,
    LowerTorso = 2,
    Torso = 1
}

local function getBestTargetPart(character)
    if not character then return nil end
    
    local bestPart = nil
    local bestPriority = -1
    
    -- Check for high priority parts first
    for partName, priority in pairs(partPriority) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if priority > bestPriority then
                bestPart = part
                bestPriority = priority
            end
        end
    end
    
    -- If we found a good part, return it
    if bestPart then return bestPart end
    
    -- Fallback to any BasePart
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "Handle" then
            return part
        end
    end
    
    return nil
end

local function updateTargetPart()
    if not currentTargetPlayer or not currentTargetPlayer.Character then return false end
    
    local newPart = getBestTargetPart(currentTargetPlayer.Character)
    if newPart and newPart ~= currentTarget then
        currentTarget = newPart
        return true
    end
    return false
end

-- Optimized target finding
local function findClosestTargetPlayerForLock()
    local closestPlayer = nil
    local closestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not isPlayerKnockedOrKO(player) then
            local targetPart = getBestTargetPart(player.Character)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDistance then
                        closestDistance = dist
                        closestPlayer = player
                        currentTarget = targetPart
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function getPredictedPosition(part, config)
    if not config['Use Prediction'] or not part then 
        return part and part.Position or Vector3.new()
    end
    
    local velocity = part.AssemblyLinearVelocity
    local prediction = config['Prediction']
    local predValue = type(prediction) == "table" and (prediction.X or 0.133) or (prediction == 0 and 0.133 or prediction)
    
    return part.Position + velocity * predValue
end

-- Optimized camera lock with smoothing
local function applyCameraLock()
    if not isLocking or isSelfKnocked() then 
        if isSelfKnocked() then
            isLocking = false
            targetLine.Visible = false
        end
        return 
    end
    
    if not currentTarget or not currentTarget.Parent then
        if not updateTargetPart() then return end
    end
    
    if not currentTarget then return end
    
    local targetPos = getPredictedPosition(currentTarget, Config['Camera Lock'])
    local smoothConfig = Config['Camera Lock']['Smoothing']
    local smoothValue = (smoothConfig.X + smoothConfig.Y + smoothConfig.Z) / 3
    local alpha = math.min(1, 1 / math.max(1, smoothValue))
    
    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha)
end

local function update3DFOVBox()
    if not Config['FOV']['Enabled'] or not Config['FOV']['Visible'] or not currentTargetPlayer or not currentTargetPlayer.Character then
        outlinePart.Transparency = 1
        return
    end
    
    local rootPart = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local offset = Config['FOV']['Size']
        outlinePart.Size = rootPart.Size + Vector3.new(offset, offset, offset)
        outlinePart.CFrame = rootPart.CFrame
        outlinePart.Transparency = 0.85
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

-- Optimized trigger bot
local function TriggerBot()
    if not Config['Trigger Bot']['Enabled'] or not triggerEnabled then return end
    
    local currentTime = tick()
    if currentTime - lastTriggerClick < Config['Trigger Bot']['Delay'] then return end
    
    if Config['Trigger Bot']['Require Target'] and not currentTargetPlayer then return end
    
    if currentTargetPlayer and currentTargetPlayer.Character then
        updateTargetPart()
        if not currentTarget or not canSeeTarget(currentTarget) then return end
    end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        lastTriggerClick = currentTime
    end
end

-- Silent Aim (keep as is, it's fine)
local grm = getrawmetatable(game)
local oldIndex = grm.__index
setreadonly(grm, false)

grm.__index = function(self, key)
    if not checkcaller() and self == Mouse and Config['Silent Aim']['Enabled'] then
        if key == "Hit" and currentTargetPlayer and currentTargetPlayer.Character then
            updateTargetPart()
            if currentTarget and (not visibleCheck or canSeeTarget(currentTarget)) then
                return CFrame.new(getPredictedPosition(currentTarget, Config['Silent Aim']))
            end
        end
    end
    return oldIndex(self, key)
end

setreadonly(grm, true)

-- Spread control (keep as is)
local oldRandom = hookfunction(math.random, function(...)
    if not checkcaller() then
        local args = {...}
        if (#args == 0 or (args[1] == -0.05 and args[2] == 0.05)) and Config['Spread']['Enabled'] then
            return oldRandom(...) * (Config['Spread']['Amount'] / 100)
        end
    end
    return oldRandom(...)
end)

-- ESP Functions (optimized)
local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        player = player,
        text = Drawing.new("Text")
    }
    
    esp.text.Size = 14
    esp.text.Center = true
    esp.text.Outline = true
    esp.text.OutlineColor = Color3.new(0, 0, 0)
    esp.text.Color = Config['Visual Awareness']['Color']
    esp.text.Font = Drawing.Fonts.Plex
    esp.text.Visible = false
    
    espLabels[player] = esp
end

local function removeESP(player)
    local esp = espLabels[player]
    if esp then
        esp.text:Remove()
        espLabels[player] = nil
    end
end

local function updateESP()
    if not Config['Visual Awareness']['Enabled'] then
        for _, esp in pairs(espLabels) do
            esp.text.Visible = false
        )
        return
    end
    
    for player, esp in pairs(espLabels) do
        if not player or not player.Parent then
            esp.text:Remove()
            espLabels[player] = nil
            continue
        end
        
        if player.Character and player.Character.Parent then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2.8, 0))
                
                if onScreen and pos.Z > 0 then
                    esp.text.Position = Vector2.new(pos.X, pos.Y)
                    esp.text.Text = Config['Visual Awareness']['Use Display Name'] and player.DisplayName or player.Name
                    esp.text.Color = (currentTargetPlayer == player) and Config['Visual Awareness']['Target Color'] or Config['Visual Awareness']['Color']
                    esp.text.Visible = true
                    continue
                end
            end
        end
        esp.text.Visible = false
    end
end

-- Initialize ESP
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if currentTargetPlayer == player then
        currentTargetPlayer = nil
        currentTarget = nil
        isLocking = false
    end
    removeESP(player)
end)

-- HITBOX MANAGEMENT - COMPLETELY REWRITTEN
local function applyHitboxExpansion()
    if not Config['Hitbox Expander']['Enabled'] then 
        -- Restore all hitboxes
        for part, originalSize in pairs(originalSizes) do
            if part and part.Parent then
                pcall(function()
                    part.Size = originalSize
                end)
            end
        end
        -- Clear the table
        for part in pairs(originalSizes) do
            originalSizes[part] = nil
        end
        return 
    end
    
    local expandSize = Config['Hitbox Expander']['Size']
    local playersToExpand = {}
    
    -- Determine which players to expand
    if isLocking and currentTargetPlayer and currentTargetPlayer.Character then
        -- Only expand the locked target
        local hrp = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            table.insert(playersToExpand, hrp)
        end
    else
        -- Expand all players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    table.insert(playersToExpand, hrp)
                end
            end
        end
    end
    
    -- First, restore any parts that shouldn't be expanded anymore
    for part, originalSize in pairs(originalSizes) do
        local shouldKeep = false
        for _, targetPart in ipairs(playersToExpand) do
            if part == targetPart then
                shouldKeep = true
                break
            end
        end
        
        if not shouldKeep and part and part.Parent then
            pcall(function()
                part.Size = originalSize
            end)
            originalSizes[part] = nil
        end
    end
    
    -- Then expand the current targets
    for _, part in ipairs(playersToExpand) do
        if not originalSizes[part] then
            originalSizes[part] = part.Size
        end
        
        -- Only expand if size is different (prevents constant updating)
        if (part.Size.X - expandSize) > 0.1 or (part.Size.X - expandSize) < -0.1 then
            pcall(function()
                part.Size = Vector3.new(expandSize, expandSize, expandSize)
            end)
        end
    end
end

-- Speed management
local function updateSpeed()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if SpeedEnabled and Config['Speed']['Enabled'] then
        local targetSpeed = BaseSpeed * Config['Speed']['Multiplier']
        if math.abs(humanoid.WalkSpeed - targetSpeed) > 0.1 then
            humanoid.WalkSpeed = targetSpeed
        end
    elseif humanoid.WalkSpeed ~= BaseSpeed then
        humanoid.WalkSpeed = BaseSpeed
    end
end

-- Main optimized loop
RunService.RenderStepped:Connect(function()
    local frame = RunService:GetFrameCount()
    
    -- Update target if locking
    if isLocking then
        if isSelfKnocked() then
            isLocking = false
            targetLine.Visible = false
        elseif currentTargetPlayer and currentTargetPlayer.Character then
            if not currentTarget or not currentTarget.Parent then
                updateTargetPart()
            end
        elseif currentTargetPlayer and not currentTargetPlayer.Character then
            currentTarget = nil
        end
    end
    
    -- Trigger bot
    TriggerBot()
    
    -- Speed (run every frame but with check to avoid unnecessary changes)
    updateSpeed()
    
    -- Hitbox expansion (run every 10 frames to reduce lag)
    if frame % 10 == 0 then
        applyHitboxExpansion()
    end
    
    -- Visual updates (only if needed)
    if Config['FOV']['Enabled'] then
        update3DFOVBox()
    elseif outlinePart.Transparency ~= 1 then
        outlinePart.Transparency = 1
    end
    
    if Config['Target Line']['Enabled'] then
        updateTargetLine()
    elseif targetLine.Visible then
        targetLine.Visible = false
    end
    
    -- ESP update (run every 2 frames)
    if frame % 2 == 0 then
        updateESP()
    end
    
    -- Camera lock
    if Config['Camera Lock']['Enabled'] and isLocking then
        applyCameraLock()
    end
end)

-- Input handling (simplified)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    local key = input.KeyCode
    
    -- Target Lock
    if key == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']
        
        if mode == 'Toggle' then
            if isLocking then
                isLocking = false
                currentTargetPlayer = nil
                currentTarget = nil
                targetLine.Visible = false
            else
                local target = findClosestTargetPlayerForLock()
                if target then
                    currentTargetPlayer = target
                    isLocking = true
                end
            end
        elseif mode == 'Hold' then
            local target = findClosestTargetPlayerForLock()
            if target then
                currentTargetPlayer = target
                isLocking = true
            end
        end
    end
    
    -- Trigger Bot
    if key == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        triggerEnabled = Config['Keybinds']['Trigger Bot']['Mode'] == 'Toggle' and not triggerEnabled or true
    end
    
    -- Speed Toggle
    if key == Enum.KeyCode[Config['Keybinds']['Speed']] then
        SpeedEnabled = not SpeedEnabled
        if not SpeedEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = BaseSpeed
            end
        end
    end
    
    -- ESP Toggle
    if key == Enum.KeyCode[Config['Keybinds']['ESP']] then
        Config['Visual Awareness']['Enabled'] = not Config['Visual Awareness']['Enabled']
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    
    -- Release holds
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] and Config['Keybinds']['Target Lock']['Mode'] == 'Hold' then
        isLocking = false
        currentTargetPlayer = nil
        currentTarget = nil
        targetLine.Visible = false
    end
    
    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] and Config['Keybinds']['Trigger Bot']['Mode'] == 'Hold' then
        triggerEnabled = false
    end
end)

-- Cleanup
LocalPlayer.CharacterRemoving:Connect(function()
    -- Reset everything on death
    isLocking = false
    SpeedEnabled = false
    targetLine.Visible = false
    
    -- Restore all hitboxes
    for part, originalSize in pairs(originalSizes) do
        if part and part.Parent then
            pcall(function()
                part.Size = originalSize
            end)
        end
    end
    
    -- Clear the table
    for part in pairs(originalSizes) do
        originalSizes[part] = nil
    end
end)

