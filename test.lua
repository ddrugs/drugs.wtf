shared.drugs = {
    ['Settings'] = {
        ['Target Aim'] = true,
        ['Knock Check'] = true,
        ['Visible Check'] = true,
        ['Self Knock Check'] = true,
        ['Force Field Check'] = true,
    },

    ['Keybinds'] = {
        ['Target Lock'] = {
            ['Key'] = 'C',
            ['Mode'] = 'Toggle',
        },
        ['Trigger Bot'] = {
            ['Key'] = 'V',
            ['Mode'] = 'Hold',
        },
        ['Speed'] = 'Z',
        ['ESP'] = 'Y',
    },

    ['FOV'] = {
        ['Enabled'] = false,
        ['Visible'] = true,
        ['Thickness'] = 4,
        ['Active Color'] = Color3.fromRGB(0, 17, 255),
        ['Size'] = 10,
    },

    ['Target Line'] = {
        ['Enabled'] = true,
        ['Thickness'] = 2.2,
        ['Transparency'] = 0.8,
        ['Vulnerable'] = Color3.fromRGB(255, 85, 127),
        ['Invulnerable'] = Color3.fromRGB(150, 150, 150),
    },

    ['Silent Aim'] = {
        ['Enabled'] = true,
        ['Hit Part'] = 'UpperTorso',
        ['Preferred Part'] = 'UpperTorso',
        ['Fallback Part'] = 'UpperTorso',
        ['Use Prediction'] = true,
        ['Prediction'] = {
            ['X'] = 0,
            ['Y'] = 0,
            ['Z'] = 0.046,
        },
    },

    ['Camera Lock'] = {
        ['Enabled'] = false,
        ['Hit Part'] = 'Head',
        ['Smoothing'] = {
            ['X'] = 40,
            ['Y'] = 40,
            ['Z'] = 40,
        },
        ['Use Prediction'] = true,
        ['Prediction'] = {
            ['X'] = 0.133,
            ['Y'] = 0.133,
            ['Z'] = 0.133,
        },
    },

    ['Trigger Bot'] = {
        ['Enabled'] = true,
        ['Delay'] = 0.01,
        ['Require Target'] = false,
        ['Specific Weapons'] = {
            ['Enabled'] = false,
            ['Weapons'] = {
                '[Double-Barrel SG]',
                '[Revolver]',
                '[TacticalShotgun]',
            },
        },
    },

    ['Spread'] = {
        ['Enabled'] = false,
        ['Amount'] = 1,
        ['Specific Weapons'] = {
            ['Enabled'] = false,
            ['Weapons'] = {
                '[Double-Barrel SG]',
                '[TacticalShotgun]',
            },
        },
    },

    ['Speed'] = {
        ['Enabled'] = true,
        ['Multiplier'] = 35,
        ['Anti Fling'] = false,
    },

    ['Hitbox Expander'] = {
        ['Enabled'] = true,
        ['Size'] = 20,
    },

    ['Spiderman'] = {
        ['Enabled'] = true,
    },

    ['Visual Awareness'] = {
        ['Enabled'] = true,
        ['Color'] = Color3.fromRGB(255, 255, 255),
        ['Target Color'] = Color3.fromRGB(255, 0, 0),
        ['Use Display Name'] = false,
        ['Name Above'] = false,
    },

    ['ESP Settings'] = {
        ['Enabled'] = true,
        ['Boxes'] = {
            ['Enabled'] = true,
            ['Color'] = Color3.fromRGB(255, 255, 255),
            ['Target Color'] = Color3.fromRGB(255, 0, 0),
            ['Thickness'] = 2,
            ['Transparency'] = 0.5,
            ['Fill'] = false,
            ['Fill Color'] = Color3.fromRGB(255, 255, 255),
            ['Fill Transparency'] = 0.8,
            ['Scale'] = 1.1,
            ['Width Ratio'] = 0.6,
        },
        ['Name'] = {
            ['Enabled'] = true,
            ['Color'] = Color3.fromRGB(255, 255, 255),
            ['Target Color'] = Color3.fromRGB(255, 0, 0),
            ['Size'] = 14,
            ['Position'] = 'Top',
            ['Offset X'] = 0,
            ['Offset Y'] = 0,
            ['Use Display Name'] = false,
        },
        ['Distance'] = {
            ['Enabled'] = true,
            ['Color'] = Color3.fromRGB(255, 255, 255),
            ['Target Color'] = Color3.fromRGB(255, 0, 0),
            ['Size'] = 12,
            ['Position'] = 'Bottom',
            ['Offset X'] = 0,
            ['Offset Y'] = 0,
            ['Format'] = '{} studs',
        },
        ['Weapons'] = {
            ['Enabled'] = true,
            ['Color'] = Color3.fromRGB(255, 255, 255),
            ['Target Color'] = Color3.fromRGB(255, 0, 0),
            ['Size'] = 12,
            ['Position'] = 'Top',
            ['Offset X'] = 0,
            ['Offset Y'] = 15,
            ['ShowAmmo'] = true,
            ['Format'] = '{}',
        },
        ['Tracers'] = {
            ['Enabled'] = false,
            ['Color'] = Color3.fromRGB(255, 255, 255),
            ['Target Color'] = Color3.fromRGB(255, 0, 0),
            ['Thickness'] = 1.5,
            ['Transparency'] = 0.5,
            ['Origin'] = 'Bottom',
        },
    },
}

local Config = shared.drugs
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local currentTargetPlayer = nil  -- The player we are locked onto
local currentTargetPart = nil    -- Current part of that player
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
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character, outlinePart}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    local rayResult = Workspace:Raycast(origin, direction, raycastParams)
    return rayResult == nil or rayResult.Instance:IsDescendantOf(character)
end

-- Robust part finder for Da Hood (works with R6 and R15)
local function findCharacterPart(character, preferredName)
    if not character then return nil end

    -- Try exact match first
    local part = character:FindFirstChild(preferredName)
    if part and part:IsA("BasePart") then return part end

    -- Common fallbacks
    local fallbackOrder = {
        "Head",
        "HumanoidRootPart",
        "Torso",        -- R6
        "UpperTorso",   -- R15
        "LowerTorso",
        "Right Arm",
        "Left Arm",
        "Right Leg",
        "Left Leg"
    }

    for _, name in ipairs(fallbackOrder) do
        part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end

    -- Last resort: any BasePart
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Handle" then
            return child
        end
    end

    return nil
end

local function getBestTargetPart(character)
    return findCharacterPart(character, "Head") -- for target line/lock we prefer head
end

local function updateTargetPart()
    if not currentTargetPlayer or not currentTargetPlayer.Character then
        return false
    end

    local newPart = getBestTargetPart(currentTargetPlayer.Character)
    if newPart then
        currentTargetPart = newPart
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
            -- Don't filter by knock anymore - we want to lock even on knocked players
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

    if closestPlayer then
        currentTargetPart = closestPart
        return closestPlayer
    end

    return nil
end

local function getPredictedPosition(part, config)
    if not config['Use Prediction'] or not part then return part and part.Position or Vector3.new() end

    local velocity = part.AssemblyLinearVelocity
    local prediction = config['Prediction']

    return part.Position + Vector3.new(
        velocity.X * (prediction.X or 0),
        velocity.Y * (prediction.Y or 0),
        velocity.Z * (prediction.Z or 0)
    )
end

local function applyCameraLock()
    if not isLocking then return end
    if isSelfKnocked() then
        isLocking = false
        targetLine.Visible = false
        return
    end

    -- Still lock even if target is knocked/dead - camera will follow the respawn
    if not currentTargetPlayer then return end
    
    -- Try to get/update the target part
    if not currentTargetPart or not currentTargetPart.Parent then
        if not updateTargetPart() then
            return
        end
    end

    if not currentTargetPart then return end

    local targetPos = getPredictedPosition(currentTargetPart, Config['Camera Lock'])
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
    if not Config['Target Line']['Enabled'] or not currentTargetPlayer or not isLocking then
        targetLine.Visible = false
        return
    end

    -- Show line even if character doesn't exist yet (waiting for respawn)
    if not currentTargetPlayer.Character then
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

        if currentTargetPart and canSeeTarget(currentTargetPart) then
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
        if not currentTargetPart or not canSeeTarget(currentTargetPart) then return end
    end

    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        lastTriggerClick = tick()
    end
end

-- Silent Aim (NEVER UNLOCKS - PERSISTENT THROUGH DEATH/RESPAWN)
local grm = getrawmetatable(game)
local oldIndex = grm.__index
setreadonly(grm, false)

grm.__index = function(self, key)
    if not checkcaller() and self == Mouse and Config['Silent Aim']['Enabled'] then
        if key == "Hit" then
            -- If we have a locked target (persists through death)
            if currentTargetPlayer then
                -- Even if target is knocked or dead, we still want to aim at them
                -- When they respawn, this will automatically work again
                
                -- Check if they have a character
                if currentTargetPlayer.Character then
                    -- Find the exact part based on config (with robust fallbacks)
                    local character = currentTargetPlayer.Character
                    local hitPartName = Config['Silent Aim']['Hit Part']
                    local targetPart = findCharacterPart(character, hitPartName)

                    -- If we found a part, aim at it
                    if targetPart then
                        -- Visibility check (optional)
                        if Config['Settings']['Visible Check'] and not canSeeTarget(targetPart) then
                            return oldIndex(self, key)
                        end

                        -- Calculate position (with prediction)
                        local targetPos = targetPart.Position
                        if Config['Silent Aim']['Use Prediction'] then
                            local vel = targetPart.AssemblyLinearVelocity
                            local pred = Config['Silent Aim']['Prediction']
                            targetPos = targetPart.Position + Vector3.new(
                                vel.X * (pred.X or 0),
                                vel.Y * (pred.Y or 0),
                                vel.Z * (pred.Z or 0.046)
                            )
                        end

                        return CFrame.new(targetPos)
                    end
                end
                -- If no character yet (dead/respawning), return ground/normal aim
                -- This prevents errors but keeps the lock for when they respawn
                return oldIndex(self, key)
            end
            -- No locked target -> return original Mouse.Hit
            return oldIndex(self, key)
        end
    end
    return oldIndex(self, key)
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

-- ESP Functions (unchanged)
local function getPlayerWeapon(player)
    if not player or not player.Character then return "None" end

    local tool = player.Character:FindFirstChildOfClass("Tool")
    if tool then
        local weaponName = tool.Name
        local ammo = ""
        if Config['ESP Settings']['Weapons']['ShowAmmo'] then
            local ammoValue = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo")
            if ammoValue then
                ammo = " [" .. tostring(ammoValue.Value) .. "]"
            end
        end
        return weaponName .. ammo
    end
    return "None"
end

local function getPlayerDistance(player)
    if not player or not player.Character or not LocalPlayer.Character then return 0 end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootPart and myRoot then
        return math.floor((rootPart.Position - myRoot.Position).Magnitude)
    end
    return 0
end

local function getPlayerBoxCorners(player)
    if not player or not player.Character then return nil end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local head = player.Character:FindFirstChild("Head")

    if not humanoid or not rootPart or not head then return nil end

    local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local rootPos, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2, 0))

    if not headOnScreen or not rootOnScreen or headPos.Z <= 0 or rootPos.Z <= 0 then return nil end

    local rawHeight = math.abs(headPos.Y - rootPos.Y)
    local boxScale = Config['ESP Settings']['Boxes']['Scale'] or 1.1
    local height = rawHeight * boxScale
    local widthRatio = Config['ESP Settings']['Boxes']['Width Ratio'] or 0.6
    local width = height * widthRatio

    local centerY = (headPos.Y + rootPos.Y) / 2
    local center = Vector2.new(rootPos.X, centerY)

    return {
        TopLeft = Vector2.new(center.X - width/2, center.Y - height/2),
        TopRight = Vector2.new(center.X + width/2, center.Y - height/2),
        BottomLeft = Vector2.new(center.X - width/2, center.Y + height/2),
        BottomRight = Vector2.new(center.X + width/2, center.Y + height/2),
        Center = center,
        Height = height,
        Width = width
    }
end

local function calculatePosition(corners, position, offsetX, offsetY, elementType)
    if not corners then return Vector2.new(0, 0) end

    local pos = Vector2.new(0, 0)
    local baseOffset = 0

    if elementType == "name" then
        baseOffset = 20
    elseif elementType == "weapon" then
        baseOffset = 35
    elseif elementType == "distance" then
        baseOffset = 5
    end

    if position == 'Top' then
        pos = Vector2.new(corners.Center.X, corners.TopLeft.Y - baseOffset)
    elseif position == 'Bottom' then
        pos = Vector2.new(corners.Center.X, corners.BottomLeft.Y + baseOffset)
    elseif position == 'Left' then
        pos = Vector2.new(corners.TopLeft.X - 50, corners.Center.Y)
    elseif position == 'Right' then
        pos = Vector2.new(corners.TopRight.X + 50, corners.Center.Y)
    elseif position == 'TopLeft' then
        pos = Vector2.new(corners.TopLeft.X - 30, corners.TopLeft.Y - baseOffset)
    elseif position == 'TopRight' then
        pos = Vector2.new(corners.TopRight.X + 30, corners.TopRight.Y - baseOffset)
    elseif position == 'BottomLeft' then
        pos = Vector2.new(corners.BottomLeft.X - 30, corners.BottomLeft.Y + baseOffset)
    elseif position == 'BottomRight' then
        pos = Vector2.new(corners.BottomRight.X + 30, corners.BottomRight.Y + baseOffset)
    end

    return Vector2.new(pos.X + offsetX, pos.Y + offsetY)
end

local function drawBox(esp, corners, isTarget)
    if not corners then return end

    local boxColor = isTarget and Config['ESP Settings']['Boxes']['Target Color'] or Config['ESP Settings']['Boxes']['Color']
    local thickness = Config['ESP Settings']['Boxes']['Thickness']
    local transparency = Config['ESP Settings']['Boxes']['Transparency']

    for i = 1, 4 do
        esp.lines[i].Visible = true
        esp.lines[i].Color = boxColor
        esp.lines[i].Thickness = thickness
        esp.lines[i].Transparency = transparency
    end

    esp.lines[1].From, esp.lines[1].To = corners.TopLeft, corners.TopRight
    esp.lines[2].From, esp.lines[2].To = corners.TopRight, corners.BottomRight
    esp.lines[3].From, esp.lines[3].To = corners.BottomRight, corners.BottomLeft
    esp.lines[4].From, esp.lines[4].To = corners.BottomLeft, corners.TopLeft

    if Config['ESP Settings']['Boxes']['Fill'] then
        if not esp.fillSquare then
            esp.fillSquare = Drawing.new("Square")
            esp.fillSquare.Filled = true
            esp.fillSquare.Thickness = 0
        end
        esp.fillSquare.Visible = true
        esp.fillSquare.Color = Config['ESP Settings']['Boxes']['Fill Color']
        esp.fillSquare.Transparency = Config['ESP Settings']['Boxes']['Fill Transparency']
        esp.fillSquare.Size = Vector2.new(corners.Width, corners.Height)
        esp.fillSquare.Position = corners.TopLeft
    elseif esp.fillSquare then
        esp.fillSquare.Visible = false
    end
end

local function drawTracer(esp, corners, isTarget)
    if not corners then return end

    local screenSize = Camera.ViewportSize
    local tracerOrigin = Config['ESP Settings']['Tracers']['Origin']
    local tracerColor = isTarget and Config['ESP Settings']['Tracers']['Target Color'] or Config['ESP Settings']['Tracers']['Color']

    local startPos
    if tracerOrigin == 'Bottom' then
        startPos = Vector2.new(screenSize.X/2, screenSize.Y)
    elseif tracerOrigin == 'Top' then
        startPos = Vector2.new(screenSize.X/2, 0)
    elseif tracerOrigin == 'Middle' then
        startPos = Vector2.new(screenSize.X/2, screenSize.Y/2)
    elseif tracerOrigin == 'Mouse' then
        startPos = UserInputService:GetMouseLocation()
    end

    if not esp.tracerLine then
        esp.tracerLine = Drawing.new("Line")
    end

    esp.tracerLine.From = startPos
    esp.tracerLine.To = corners.Center
    esp.tracerLine.Color = tracerColor
    esp.tracerLine.Thickness = Config['ESP Settings']['Tracers']['Thickness']
    esp.tracerLine.Transparency = Config['ESP Settings']['Tracers']['Transparency']
    esp.tracerLine.Visible = true
end

local function addESPToPlayer(player)
    if player == LocalPlayer then return end

    local esp = {
        player = player,
        nameTag = Drawing.new("Text"),
        distanceText = Drawing.new("Text"),
        weaponText = Drawing.new("Text"),
        lines = {},
    }

    for i = 1, 4 do
        esp.lines[i] = Drawing.new("Line")
        esp.lines[i].Visible = false
        esp.lines[i].ZIndex = 1000
    end

    esp.nameTag.Size = Config['ESP Settings']['Name']['Size']
    esp.nameTag.Center = true
    esp.nameTag.Outline = true
    esp.nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.nameTag.Font = Drawing.Fonts.Plex
    esp.nameTag.Visible = false
    esp.nameTag.ZIndex = 1000

    esp.distanceText.Size = Config['ESP Settings']['Distance']['Size']
    esp.distanceText.Center = true
    esp.distanceText.Outline = true
    esp.distanceText.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.distanceText.Font = Drawing.Fonts.Plex
    esp.distanceText.Visible = false
    esp.distanceText.ZIndex = 1000

    esp.weaponText.Size = Config['ESP Settings']['Weapons']['Size']
    esp.weaponText.Center = true
    esp.weaponText.Outline = true
    esp.weaponText.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.weaponText.Font = Drawing.Fonts.Plex
    esp.weaponText.Visible = false
    esp.weaponText.ZIndex = 1000

    espLabels[player.UserId] = esp
end

local function removeESPFromPlayer(player)
    local esp = espLabels[player.UserId]
    if esp then
        esp.nameTag:Remove()
        esp.distanceText:Remove()
        esp.weaponText:Remove()
        for _, line in pairs(esp.lines) do
            line:Remove()
        end
        if esp.fillSquare then esp.fillSquare:Remove() end
        if esp.tracerLine then esp.tracerLine:Remove() end
        espLabels[player.UserId] = nil
    end
end

local function refreshESP()
    if not Config['ESP Settings']['Enabled'] then
        for _, esp in pairs(espLabels) do
            esp.nameTag.Visible = false
            esp.distanceText.Visible = false
            esp.weaponText.Visible = false
            for _, line in pairs(esp.lines) do
                line.Visible = false
            end
            if esp.fillSquare then esp.fillSquare.Visible = false end
            if esp.tracerLine then esp.tracerLine.Visible = false end
        end
        return
    end

    for userId, esp in pairs(espLabels) do
        local player = esp.player
        if not player or not player.Parent then
            removeESPFromPlayer(player)
            continue
        end

        if player.Character and player.Character.Parent then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                esp.nameTag.Visible = false
                esp.distanceText.Visible = false
                esp.weaponText.Visible = false
                for _, line in pairs(esp.lines) do
                    line.Visible = false
                end
                if esp.fillSquare then esp.fillSquare.Visible = false end
                if esp.tracerLine then esp.tracerLine.Visible = false end
                continue
            end

            local isTarget = (currentTargetPlayer == player)
            local corners = getPlayerBoxCorners(player)

            if corners then
                if Config['ESP Settings']['Boxes']['Enabled'] then
                    drawBox(esp, corners, isTarget)
                else
                    for _, line in pairs(esp.lines) do
                        line.Visible = false
                    end
                end

                if Config['ESP Settings']['Tracers']['Enabled'] then
                    drawTracer(esp, corners, isTarget)
                elseif esp.tracerLine then
                    esp.tracerLine.Visible = false
                end

                if Config['ESP Settings']['Name']['Enabled'] then
                    local namePos = calculatePosition(
                        corners,
                        Config['ESP Settings']['Name']['Position'],
                        Config['ESP Settings']['Name']['Offset X'],
                        Config['ESP Settings']['Name']['Offset Y'],
                        "name"
                    )
                    esp.nameTag.Position = namePos
                    esp.nameTag.Text = Config['ESP Settings']['Name']['Use Display Name'] and player.DisplayName or player.Name
                    esp.nameTag.Color = isTarget and Config['ESP Settings']['Name']['Target Color'] or Config['ESP Settings']['Name']['Color']
                    esp.nameTag.Visible = true
                else
                    esp.nameTag.Visible = false
                end

                if Config['ESP Settings']['Distance']['Enabled'] then
                    local distance = getPlayerDistance(player)
                    local distPos = calculatePosition(
                        corners,
                        Config['ESP Settings']['Distance']['Position'],
                        Config['ESP Settings']['Distance']['Offset X'],
                        Config['ESP Settings']['Distance']['Offset Y'],
                        "distance"
                    )
                    esp.distanceText.Position = distPos
                    esp.distanceText.Text = Config['ESP Settings']['Distance']['Format']:gsub("{}", tostring(distance))
                    esp.distanceText.Color = isTarget and Config['ESP Settings']['Distance']['Target Color'] or Config['ESP Settings']['Distance']['Color']
                    esp.distanceText.Visible = true
                else
                    esp.distanceText.Visible = false
                end

                if Config['ESP Settings']['Weapons']['Enabled'] then
                    local weapon = getPlayerWeapon(player)
                    local weaponPos = calculatePosition(
                        corners,
                        Config['ESP Settings']['Weapons']['Position'],
                        Config['ESP Settings']['Weapons']['Offset X'],
                        Config['ESP Settings']['Weapons']['Offset Y'],
                        "weapon"
                    )
                    esp.weaponText.Position = weaponPos
                    esp.weaponText.Text = Config['ESP Settings']['Weapons']['Format']:gsub("{}", weapon)
                    esp.weaponText.Color = isTarget and Config['ESP Settings']['Weapons']['Target Color'] or Config['ESP Settings']['Weapons']['Color']
                    esp.weaponText.Visible = true
                else
                    esp.weaponText.Visible = false
                end
            else
                esp.nameTag.Visible = false
                esp.distanceText.Visible = false
                esp.weaponText.Visible = false
                for _, line in pairs(esp.lines) do
                    line.Visible = false
                end
                if esp.fillSquare then esp.fillSquare.Visible = false end
                if esp.tracerLine then esp.tracerLine.Visible = false end
            end
        else
            esp.nameTag.Visible = false
            esp.distanceText.Visible = false
            esp.weaponText.Visible = false
            for _, line in pairs(esp.lines) do
                line.Visible = false
            end
            if esp.fillSquare then esp.fillSquare.Visible = false end
            if esp.tracerLine then esp.tracerLine.Visible = false end
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
        currentTargetPart = nil
        isLocking = false
    end
    removeESPFromPlayer(player)
end)

-- Monitor target player for respawns
local function setupTargetMonitor(player)
    if player ~= currentTargetPlayer then return end
    
    -- When target respawns, update the part reference
    player.CharacterAdded:Connect(function(character)
        if player == currentTargetPlayer then
            -- Wait a moment for the character to fully load
            task.wait(0.5)
            updateTargetPart()
        end
    end)
end

-- Hitbox Expander (only expands when target is alive)
local function storeOriginalSize(part)
    if not part or originalSizes[part] then return end
    originalSizes[part] = part.Size
end

local function restoreOriginalSize(part)
    if part and originalSizes[part] then
        pcall(function()
            part.Size = originalSizes[part]
        end)
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
            pcall(function()
                part.Size = originalSize
            end)
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

    -- First reset all hitboxes
    resetAllHitboxes()

    -- Then expand ONLY the locked target's HumanoidRootPart if they have a character
    if isLocking and currentTargetPlayer and currentTargetPlayer.Character then
        local targetHrp = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp then
            expandHitbox(targetHrp, expandSize)
        end
    end
    -- If not locking, no hitboxes are expanded
end

-- Main loop
RunService.RenderStepped:Connect(function()
    if isSelfKnocked() and isLocking then
        isLocking = false
        targetLine.Visible = false
    end

    -- Update target part if needed
    if currentTargetPlayer then
        -- If target has a character but we don't have a valid part, update it
        if currentTargetPlayer.Character then
            if not currentTargetPart or not currentTargetPart.Parent then
                updateTargetPart()
            end
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
            if Config['Settings']['Target Aim'] then
                if isLocking then
                    isLocking = false
                    currentTargetPlayer = nil
                    currentTargetPart = nil
                    targetLine.Visible = false
                else
                    local targetPlayer = findClosestTargetPlayerForLock()
                    if targetPlayer then
                        currentTargetPlayer = targetPlayer
                        setupTargetMonitor(targetPlayer)
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
                    setupTargetMonitor(targetPlayer)
                    isLocking = true
                end
            else
                isLocking = true
            end
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']

        if mode == 'Toggle' then
            triggerEnabled = not triggerEnabled
        elseif mode == 'Hold' then
            triggerEnabled = true
        end
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
        Config['ESP Settings']['Enabled'] = not Config['ESP Settings']['Enabled']
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']
        if mode == 'Hold' then
            isLocking = false
            currentTargetPlayer = nil
            currentTargetPart = nil
            targetLine.Visible = false
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']
        if mode == 'Hold' then
            triggerEnabled = false
        end
    end
end)

local function hasForceField(player)
    if not player or not player.Character then return false end

    -- Check character for ForceField instance
    if player.Character:FindFirstChildOfClass("ForceField") then
        return true
    end

    -- Some games parent the ForceField under the Humanoid or HRP
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:FindFirstChildOfClass("ForceField") then
        return true
    end

    -- Fallback: BodyEffects flag used by some Da Hood-style games
    local bodyEffects = player.Character:FindFirstChild("BodyEffects")
    if bodyEffects then
        local ff = bodyEffects:FindFirstChild("ForceField") or bodyEffects:FindFirstChild("Godmode")
        if ff and ff.Value == true then
            return true
        end
    end

    return false
end

local function isSelfForceField()
    return hasForceField(LocalPlayer)
end

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--==============================================================
-- drugs.hub :: GUI v2  (retro-cyber, with runtime fixes)
-- Drop AFTER the main script (shared.drugs must already exist)
--==============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()
local Camera      = Workspace.CurrentCamera
local Config      = shared.drugs
assert(Config, "shared.drugs must be loaded before the GUI")

--==============================================================
-- Patch new config sections (no-ops if already present)
--==============================================================
Config['Noclip']    = Config['Noclip']    or { ['Enabled'] = false }
Config['Spiderman'] = Config['Spiderman'] or { ['Enabled'] = false }

local ESP = Config['ESP Settings']
ESP['Name'    ]['Position'] = ESP['Name'    ]['Position'] or 'Top'
ESP['Distance']['Position'] = ESP['Distance']['Position'] or 'Bottom'
ESP['Weapons' ]['Position'] = ESP['Weapons' ]['Position'] or 'Top'
ESP['Tracers' ]['Origin']   = ESP['Tracers' ]['Origin']   or 'Bottom'

--==============================================================
-- Theme
--==============================================================
local T = {
    Bg          = Color3.fromRGB(8, 11, 22),
    BgDeep      = Color3.fromRGB(4, 7, 16),
    Header      = Color3.fromRGB(12, 18, 36),
    GroupBg     = Color3.fromRGB(11, 16, 30),
    GroupTitle  = Color3.fromRGB(16, 24, 46),
    Border      = Color3.fromRGB(50, 90, 170),
    BorderSoft  = Color3.fromRGB(28, 48, 90),
    BorderGlow  = Color3.fromRGB(80, 160, 255),
    Text        = Color3.fromRGB(225, 235, 250),
    TextDim     = Color3.fromRGB(130, 150, 185),
    Accent      = Color3.fromRGB(90, 170, 255),
    AccentAlt   = Color3.fromRGB(200, 100, 255),
    AccentBar   = Color3.fromRGB(70, 140, 230),
    Check       = Color3.fromRGB(140, 200, 255),
    Tab         = Color3.fromRGB(14, 22, 40),
    TabActive   = Color3.fromRGB(34, 60, 110),
    Bad         = Color3.fromRGB(255, 90, 100),
}
local FONT     = Enum.Font.Code
local FONT_BLD = Enum.Font.Code

local function new(class, props)
    local i = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then i[k] = v end
        end
        if props.Parent then i.Parent = props.Parent end
    end
    return i
end

local function stroke(p, c, t, trans)
    return new("UIStroke", {
        Color = c or T.Border,
        Thickness = t or 1,
        Transparency = trans or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = p,
    })
end

local function tween(o, time, props)
    TweenService:Create(o, TweenInfo.new(time or 0.12, Enum.EasingStyle.Quad), props):Play()
end

--==============================================================
-- RUNTIME PATCHES (FOV circle, Noclip, Spiderman swing)
--==============================================================

-- Hide the legacy 3D FOV part from the main script
local oldFovPart = Workspace:FindFirstChild("FOVOutline3D")
if oldFovPart then
    oldFovPart.Transparency = 1
    oldFovPart.Size = Vector3.new(0.05, 0.05, 0.05)
end

-- Proper FOV circle (Drawing) — follows the mouse
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness    = Config['FOV']['Thickness'] or 2
fovCircle.NumSides     = 64
fovCircle.Radius       = (Config['FOV']['Size'] or 100)
fovCircle.Filled       = false
fovCircle.Visible      = false
fovCircle.Transparency = 1
fovCircle.Color        = Config['FOV']['Active Color'] or T.Accent

-- Noclip
local noclipConn
local function setNoclip(on)
    if on and not noclipConn then
        noclipConn = RunService.Stepped:Connect(function()
            if not Config['Noclip']['Enabled'] then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end)
    elseif (not on) and noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

-- Spiderman web-swing (LMB to fire web, release to detach)
local web = { rope = nil, attach1 = nil, attach2 = nil, anchor = nil }
local function clearWeb()
    if web.rope then web.rope:Destroy() end
    if web.attach1 then web.attach1:Destroy() end
    if web.attach2 then web.attach2:Destroy() end
    if web.anchor then web.anchor:Destroy() end
    web.rope, web.attach1, web.attach2, web.anchor = nil, nil, nil, nil
end

local function fireWeb()
    if not Config['Spiderman']['Enabled'] then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local origin = Camera.CFrame.Position
    local dir = (Mouse.Hit.Position - origin)
    if dir.Magnitude > 500 then dir = dir.Unit * 500 else dir = dir.Unit * dir.Magnitude end

    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = { char }
    rp.FilterType = Enum.RaycastFilterType.Exclude

    local result = Workspace:Raycast(origin, dir, rp)
    if not result then return end

    clearWeb()

    local anchor = Instance.new("Part")
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.Transparency = 1
    anchor.Size = Vector3.new(0.2, 0.2, 0.2)
    anchor.Position = result.Position
    anchor.Parent = Workspace

    local a1 = Instance.new("Attachment", hrp)
    local a2 = Instance.new("Attachment", anchor)

    local rope = Instance.new("RopeConstraint")
    rope.Attachment0 = a1
    rope.Attachment1 = a2
    rope.Visible = true
    rope.Color = BrickColor.new("Institutional white")
    rope.Thickness = 0.08
    rope.Length = (hrp.Position - result.Position).Magnitude * 0.85
    rope.Restitution = 0.1
    rope.Parent = hrp

    web.rope, web.attach1, web.attach2, web.anchor = rope, a1, a2, anchor
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
       and Config['Spiderman']['Enabled'] then
        fireWeb()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        clearWeb()
    end
end)
LocalPlayer.CharacterAdded:Connect(function() clearWeb() end)

-- FOV update loop
RunService.RenderStepped:Connect(function()
    if Config['FOV']['Enabled'] and Config['FOV']['Visible'] then
        local mp = UserInputService:GetMouseLocation()
        fovCircle.Position  = Vector2.new(mp.X, mp.Y)
        fovCircle.Radius    = math.max(1, (Config['FOV']['Size'] or 100))
        fovCircle.Thickness = math.max(1, (Config['FOV']['Thickness'] or 2))
        fovCircle.Color     = Config['FOV']['Active Color'] or T.Accent
        fovCircle.Visible   = true
    else
        fovCircle.Visible = false
    end
end)

--==============================================================
-- Root window
--==============================================================
local existing = CoreGui:FindFirstChild("DrugsHub")
if existing then existing:Destroy() end
if LocalPlayer:FindFirstChild("PlayerGui") then
    local e = LocalPlayer.PlayerGui:FindFirstChild("DrugsHub")
    if e then e:Destroy() end
end

local screen = new("ScreenGui", {
    Name = "DrugsHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
local ok = pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screen) end
    screen.Parent = CoreGui
end)
if not ok then screen.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local window = new("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(580, 460),
    Position = UDim2.new(0.5, -290, 0.5, -230),
    BackgroundColor3 = T.Bg,
    BorderSizePixel = 0,
    Parent = screen,
})
stroke(window, T.Border, 1)

new("ImageLabel", {
    Image = "rbxassetid://5028857084",
    ImageColor3 = T.BorderGlow,
    ImageTransparency = 0.78,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 24, 1, 24),
    Position = UDim2.new(0, -12, 0, -12),
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(24, 24, 276, 276),
    ZIndex = 0,
    Parent = window,
})

local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundColor3 = T.Header,
    BorderSizePixel = 0,
    Parent = window,
})
new("UIGradient", {
    Color = ColorSequence.new(T.Header, Color3.fromRGB(20, 30, 60)),
    Rotation = 0,
    Parent = header,
})
stroke(header, T.Border, 1)

local brandDot = new("Frame", {
    Size = UDim2.fromOffset(6, 6),
    Position = UDim2.new(0, 10, 0.5, -3),
    BackgroundColor3 = T.Accent,
    BorderSizePixel = 0,
    Parent = header,
})
new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = brandDot })

new("TextLabel", {
    Text = "drugs.hub",
    Font = FONT_BLD, TextSize = 13,
    TextColor3 = T.Text,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(80, 26),
    Position = UDim2.fromOffset(22, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})
new("TextLabel", {
    Text = "//  da_hood enhancements  //  v2.0",
    Font = FONT, TextSize = 11,
    TextColor3 = T.TextDim,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(260, 26),
    Position = UDim2.fromOffset(110, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})

local fpsLabel = new("TextLabel", {
    Text = "FPS: 60",
    Font = FONT, TextSize = 11,
    TextColor3 = T.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(70, 26),
    Position = UDim2.new(1, -130, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = header,
})

local closeBtn = new("TextButton", {
    Text = "X",
    Font = FONT_BLD, TextSize = 12,
    TextColor3 = T.TextDim,
    BackgroundColor3 = T.Header,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -26, 0, 0),
    Parent = header,
})
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = T.Bad end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = T.TextDim end)
closeBtn.MouseButton1Click:Connect(function() screen:Destroy() end)

do
    local dragging, sp, sm
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; sp = window.Position; sm = i.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - sm
            window.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local tabBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 26),
    Position = UDim2.new(0, 0, 0, 26),
    BackgroundColor3 = T.BgDeep,
    BorderSizePixel = 0,
    Parent = window,
})
stroke(tabBar, T.Border, 1)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = tabBar,
})

local statusBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 1, -18),
    BackgroundColor3 = T.BgDeep,
    BorderSizePixel = 0,
    Parent = window,
})
stroke(statusBar, T.Border, 1)
local statusLeft = new("TextLabel", {
    Text = "  [ ready ]",
    Font = FONT, TextSize = 11,
    TextColor3 = T.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.5, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = statusBar,
})
new("TextLabel", {
    Text = "RightShift to toggle  |  ",
    Font = FONT, TextSize = 11,
    TextColor3 = T.TextDim,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.5, -4, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = statusBar,
})

local content = new("Frame", {
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundTransparency = 1,
    Parent = window,
})

local tabs, currentTab = {}, nil
local function selectTab(t)
    if currentTab == t then return end
    if currentTab then
        tween(currentTab.btn, 0.1, { BackgroundColor3 = T.Tab })
        currentTab.btn.TextColor3 = T.TextDim
        currentTab.bottom.Visible = false
        currentTab.page.Visible = false
    end
    currentTab = t
    tween(t.btn, 0.1, { BackgroundColor3 = T.TabActive })
    t.btn.TextColor3 = T.Text
    t.bottom.Visible = true
    t.page.Visible = true
    statusLeft.Text = "  [ " .. t.name .. " ]"
end

local function addTab(name)
    local btn = new("TextButton", {
        Text = "  " .. name .. "  ",
        Font = FONT, TextSize = 12,
        TextColor3 = T.TextDim,
        BackgroundColor3 = T.Tab,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(0, 26),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = tabBar,
    })
    stroke(btn, T.BorderSoft, 1)

    local bottom = new("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Visible = false,
        Parent = btn,
    })
    new("UIGradient", {
        Color = ColorSequence.new(T.Accent, T.AccentAlt),
        Rotation = 0,
        Parent = bottom,
    })

    local page = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 600),
        Visible = false,
        Parent = content,
    })

    local t = { name = name, btn = btn, bottom = bottom, page = page }
    btn.MouseButton1Click:Connect(function() selectTab(t) end)
    btn.MouseEnter:Connect(function()
        if currentTab ~= t then tween(btn, 0.08, { BackgroundColor3 = Color3.fromRGB(22, 36, 66) }) end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= t then tween(btn, 0.08, { BackgroundColor3 = T.Tab }) end
    end)
    table.insert(tabs, t)
    return page
end

--==============================================================
-- Group box (gradient title strip + bracket corner accents)
--==============================================================
local function addGroup(parent, title, x, y, w, h)
    local g = new("Frame", {
        BackgroundColor3 = T.GroupBg,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Parent = parent,
    })
    stroke(g, T.Border, 1, 0.2)

    local titleStrip = new("Frame", {
        BackgroundColor3 = T.GroupTitle,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 16),
        Parent = g,
    })
    new("UIGradient", {
        Color = ColorSequence.new(T.GroupTitle, Color3.fromRGB(24, 38, 70)),
        Rotation = 0,
        Parent = titleStrip,
    })
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel = 0,
        Parent = titleStrip,
    })

    local function bracket(pos)
        new("Frame", {
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(6, 1),
            Position = pos,
            Parent = titleStrip,
        })
        new("Frame", {
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(1, 6),
            Position = pos,
            Parent = titleStrip,
        })
    end
    bracket(UDim2.fromOffset(2, 2))
    bracket(UDim2.new(1, -8, 0, 2))

    new("TextLabel", {
        Text = " " .. title:upper() .. " ",
        Font = FONT_BLD, TextSize = 11,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = titleStrip,
    })

    local body = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -22),
        Position = UDim2.fromOffset(5, 19),
        Parent = g,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = body,
    })
    return body
end

--==============================================================
-- Color picker panel (lazy-built per swatch)
--==============================================================
local function buildColorPanel(parent, getter, setter)
    local panel = new("Frame", {
        BackgroundColor3 = T.GroupBg,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(160, 130),
        Position = UDim2.new(1, -162, 0, 18),
        Visible = false,
        ZIndex = 30,
        Parent = parent,
    })
    stroke(panel, T.Border, 1)

    local sv = new("ImageLabel", {
        Image = "rbxassetid://4155801252",
        BackgroundColor3 = Color3.fromHSV(0, 1, 1),
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(108, 108),
        Position = UDim2.fromOffset(6, 6),
        ZIndex = 31,
        Parent = panel,
    })
    local hue = new("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(20, 108),
        Position = UDim2.fromOffset(124, 6),
        ZIndex = 31,
        Parent = panel,
    })
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
        }),
        Rotation = 90,
        Parent = hue,
    })

    local h, s, v = getter():ToHSV()
    local refreshSwatch = function() end
    local function update()
        local c = Color3.fromHSV(h, s, v)
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        setter(c)
        refreshSwatch(c)
    end

    local svDrag, hueDrag = false, false
    sv.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = true end end)
    hue.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = true end end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag, hueDrag = false, false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if svDrag then
            local rx = math.clamp((i.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            local ry = math.clamp((i.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            s = rx; v = 1 - ry; update()
        elseif hueDrag then
            local ry = math.clamp((i.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
            h = ry; update()
        end
    end)

    return panel, function(cb) refreshSwatch = cb end
end

--==============================================================
-- Widgets
--==============================================================
local function addToggle(parent, text, getter, setter, bindGetter, bindSetter, colorGetter, colorSetter)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local box = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = T.BgDeep,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(11, 11),
        Position = UDim2.new(0, 2, 0.5, -5),
        Parent = row,
    })
    stroke(box, T.Border, 1)
    local fill = new("Frame", {
        BackgroundColor3 = T.Check,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = box,
    })

    local lbl = new("TextLabel", {
        Text = text,
        Font = FONT, TextSize = 12,
        TextColor3 = T.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local function refresh()
        if getter() then
            tween(fill, 0.1, { Size = UDim2.fromOffset(7, 7) })
            tween(lbl,  0.1, { TextColor3 = T.Text })
        else
            tween(fill, 0.1, { Size = UDim2.fromOffset(0, 0) })
            tween(lbl,  0.1, { TextColor3 = T.TextDim })
        end
    end
    box.MouseButton1Click:Connect(function() setter(not getter()); refresh() end)
    refresh()

    local rightX = -2
    if colorGetter then
        local sw = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = colorGetter(),
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(18, 10),
            Position = UDim2.new(1, rightX - 18, 0.5, -5),
            Parent = row,
        })
        stroke(sw, T.Border, 1)
        rightX = rightX - 22

        local panel, onChange = buildColorPanel(row, colorGetter, colorSetter)
        onChange(function(c) sw.BackgroundColor3 = c end)
        sw.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)
    end

    if bindGetter then
        local bindBtn = new("TextButton", {
            Text = "[" .. tostring(bindGetter()) .. "]",
            Font = FONT, TextSize = 11,
            TextColor3 = T.Accent,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Size = UDim2.fromOffset(50, 14),
            Position = UDim2.new(1, rightX - 50, 0.5, -7),
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = row,
        })
        bindBtn.MouseButton1Click:Connect(function()
            bindBtn.Text = "[...]"
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    bindSetter(input.KeyCode.Name)
                    bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                    conn:Disconnect()
                end
            end)
        end)
    end
    return row
end

local function addSlider(parent, text, min, max, decimals, getter, setter, suffix)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local function fmt(v)
        local s = (decimals and decimals > 0) and string.format("%." .. decimals .. "f", v) or tostring(math.floor(v + 0.5))
        return text .. ": " .. s .. (suffix or "")
    end

    local barBg = new("Frame", {
        BackgroundColor3 = T.BgDeep,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -4, 0, 14),
        Position = UDim2.new(0, 2, 0, 2),
        Parent = row,
    })
    stroke(barBg, T.BorderSoft, 1)

    local fill = new("Frame", {
        BackgroundColor3 = T.AccentBar,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = barBg,
    })
    new("UIGradient", {
        Color = ColorSequence.new(T.AccentBar, T.AccentAlt),
        Rotation = 0,
        Parent = fill,
    })

    local lbl = new("TextLabel", {
        Text = fmt(getter()),
        Font = FONT, TextSize = 12,
        TextColor3 = T.Text,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = barBg,
    })

    local function refresh()
        local v = getter()
        local p = math.clamp((v - min) / (max - min), 0, 1)
        fill.Size = UDim2.fromScale(p, 1)
        lbl.Text = fmt(v)
    end
    local dragging = false
    local function setFromX(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local v = min + (max - min) * rel
        if not decimals or decimals == 0 then v = math.floor(v + 0.5) end
        setter(v); refresh()
    end
    barBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; setFromX(i.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then setFromX(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    refresh()
    return row
end

local function addDropdownInline(parent, text, options, getter, setter)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Text = text,
        Font = FONT, TextSize = 12,
        TextColor3 = T.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -2, 1, 0),
        Position = UDim2.new(0, 2, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local btn = new("TextButton", {
        Text = " " .. tostring(getter()),
        Font = FONT, TextSize = 11,
        TextColor3 = T.Accent,
        BackgroundColor3 = T.BgDeep,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -4, 0, 14),
        Position = UDim2.new(0.5, 2, 0.5, -7),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    stroke(btn, T.BorderSoft, 1)
    new("TextLabel", {
        Text = "v ",
        Font = FONT, TextSize = 10,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(12, 14),
        Position = UDim2.new(1, -12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = btn,
    })

    local list = new("Frame", {
        BackgroundColor3 = T.GroupBg,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(0, 0),
        Visible = false,
        ZIndex = 200,
        Parent = screen,
    })
    stroke(list, T.Border, 1)
    new("UIListLayout", { Parent = list })
    for _, opt in ipairs(options) do
        local o = new("TextButton", {
            Text = " " .. tostring(opt),
            Font = FONT, TextSize = 11,
            TextColor3 = T.TextDim,
            BackgroundColor3 = T.GroupBg,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 201,
            Parent = list,
        })
        o.MouseEnter:Connect(function() o.BackgroundColor3 = T.TabActive; o.TextColor3 = T.Text end)
        o.MouseLeave:Connect(function() o.BackgroundColor3 = T.GroupBg; o.TextColor3 = T.TextDim end)
        o.MouseButton1Click:Connect(function()
            setter(opt); btn.Text = " " .. tostring(opt)
            list.Visible = false
        end)
    end
    btn.MouseButton1Click:Connect(function()
        if list.Visible then
            list.Visible = false
            return
        end
        local ap = btn.AbsolutePosition
        local as = btn.AbsoluteSize
        list.Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 1)
        list.Size = UDim2.fromOffset(as.X, #options * 14)
        list.Visible = true
    end)
    btn.AncestryChanged:Connect(function(_, parent)
        if not parent then list:Destroy() end
    end)
    return row
end

local function addColor(parent, text, getter, setter)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Text = text,
        Font = FONT, TextSize = 12,
        TextColor3 = T.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.new(0, 2, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local sw = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = getter(),
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(20, 10),
        Position = UDim2.new(1, -22, 0.5, -5),
        Parent = row,
    })
    stroke(sw, T.Border, 1)
    local panel, onChange = buildColorPanel(row, getter, setter)
    onChange(function(c) sw.BackgroundColor3 = c end)
    sw.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)
    return row
end

--==============================================================
-- Pages
--==============================================================
local COL_W   = 280
local COL_GAP = 8

------------------------- MAIN -------------------------
local mainPage = addTab("main")
mainPage.CanvasSize = UDim2.new(0, 0, 0, 600)

-- Patch missing prediction axes if the original config only had Z
for _, sec in ipairs({ Config['Silent Aim']['Prediction'], Config['Camera Lock']['Prediction'] }) do
    sec['X'] = sec['X'] or 0
    sec['Y'] = sec['Y'] or 0
    sec['Z'] = sec['Z'] or 0
end

-- silent aim
local g = addGroup(mainPage, "silent aim", 6, 6, COL_W, 130)
addToggle(g, "enabled",
    function() return Config['Silent Aim']['Enabled'] end,
    function(v) Config['Silent Aim']['Enabled'] = v end)
addToggle(g, "visible check",
    function() return Config['Settings']['Visible Check'] end,
    function(v) Config['Settings']['Visible Check'] = v end)
addToggle(g, "use prediction",
    function() return Config['Silent Aim']['Use Prediction'] end,
    function(v) Config['Silent Aim']['Use Prediction'] = v end)
addSlider(g, "prediction x", 0, 0.5, 3,
    function() return Config['Silent Aim']['Prediction']['X'] end,
    function(v) Config['Silent Aim']['Prediction']['X'] = v end)
addSlider(g, "prediction y", 0, 0.5, 3,
    function() return Config['Silent Aim']['Prediction']['Y'] end,
    function(v) Config['Silent Aim']['Prediction']['Y'] = v end)
addSlider(g, "prediction z", 0, 0.5, 3,
    function() return Config['Silent Aim']['Prediction']['Z'] end,
    function(v) Config['Silent Aim']['Prediction']['Z'] = v end)

-- camlock
g = addGroup(mainPage, "camlock", 6 + COL_W + COL_GAP, 6, COL_W, 130)
addToggle(g, "enabled",
    function() return Config['Camera Lock']['Enabled'] end,
    function(v) Config['Camera Lock']['Enabled'] = v end,
    function() return Config['Keybinds']['Target Lock']['Key'] end,
    function(v) Config['Keybinds']['Target Lock']['Key'] = v end)
addToggle(g, "use prediction",
    function() return Config['Camera Lock']['Use Prediction'] end,
    function(v) Config['Camera Lock']['Use Prediction'] = v end)
addSlider(g, "smoothing", 1, 100, 0,
    function() return Config['Camera Lock']['Smoothing']['X'] end,
    function(v)
        Config['Camera Lock']['Smoothing']['X'] = v
        Config['Camera Lock']['Smoothing']['Y'] = v
        Config['Camera Lock']['Smoothing']['Z'] = v
    end)
addSlider(g, "prediction x", 0, 0.5, 3,
    function() return Config['Camera Lock']['Prediction']['X'] end,
    function(v) Config['Camera Lock']['Prediction']['X'] = v end)
addSlider(g, "prediction y", 0, 0.5, 3,
    function() return Config['Camera Lock']['Prediction']['Y'] end,
    function(v) Config['Camera Lock']['Prediction']['Y'] = v end)
addSlider(g, "prediction z", 0, 0.5, 3,
    function() return Config['Camera Lock']['Prediction']['Z'] end,
    function(v) Config['Camera Lock']['Prediction']['Z'] = v end)

g = addGroup(mainPage, "targeting", 6, 142, COL_W, 110)
addToggle(g, "target aim",
    function() return Config['Settings']['Target Aim'] end,
    function(v) Config['Settings']['Target Aim'] = v end)
addToggle(g, "knock check",
    function() return Config['Settings']['Knock Check'] end,
    function(v) Config['Settings']['Knock Check'] = v end)
addToggle(g, "self knock check",
    function() return Config['Settings']['Self Knock Check'] end,
    function(v) Config['Settings']['Self Knock Check'] = v end)
addToggle(g, "force field check",
    function() return Config['Settings']['Force Field Check'] end,
    function(v) Config['Settings']['Force Field Check'] = v end)
addToggle(g, "self force field",
    function() return Config['Settings']['Self Force Field Check'] end,
    function(v) Config['Settings']['Self Force Field Check'] = v end)

g = addGroup(mainPage, "hitbox expander", 6 + COL_W + COL_GAP, 142, COL_W, 60)
addToggle(g, "enabled",
    function() return Config['Hitbox Expander']['Enabled'] end,
    function(v) Config['Hitbox Expander']['Enabled'] = v end)
addSlider(g, "size", 1, 50, 0,
    function() return Config['Hitbox Expander']['Size'] end,
    function(v) Config['Hitbox Expander']['Size'] = v end)

g = addGroup(mainPage, "spread", 6 + COL_W + COL_GAP, 208, COL_W, 60)
addToggle(g, "enabled",
    function() return Config['Spread']['Enabled'] end,
    function(v) Config['Spread']['Enabled'] = v end)
addSlider(g, "amount", 0, 100, 0,
    function() return Config['Spread']['Amount'] end,
    function(v) Config['Spread']['Amount'] = v end, "%")

g = addGroup(mainPage, "triggerbot", 6, 258, COL_W, 80)
addToggle(g, "enabled",
    function() return Config['Trigger Bot']['Enabled'] end,
    function(v) Config['Trigger Bot']['Enabled'] = v end,
    function() return Config['Keybinds']['Trigger Bot']['Key'] end,
    function(v) Config['Keybinds']['Trigger Bot']['Key'] = v end)
addToggle(g, "require target",
    function() return Config['Trigger Bot']['Require Target'] end,
    function(v) Config['Trigger Bot']['Require Target'] = v end)
addSlider(g, "delay", 0, 0.5, 2,
    function() return Config['Trigger Bot']['Delay'] end,
    function(v) Config['Trigger Bot']['Delay'] = v end, "s")

g = addGroup(mainPage, "hit parts", 6 + COL_W + COL_GAP, 274, COL_W, 60)
addDropdownInline(g, "silent aim",
    {"Head","UpperTorso","Torso","HumanoidRootPart","LowerTorso"},
    function() return Config['Silent Aim']['Hit Part'] end,
    function(v) Config['Silent Aim']['Hit Part'] = v end)
addDropdownInline(g, "camlock",
    {"Head","UpperTorso","HumanoidRootPart"},
    function() return Config['Camera Lock']['Hit Part'] end,
    function(v) Config['Camera Lock']['Hit Part'] = v end)

g = addGroup(mainPage, "modes", 6, 344, COL_W, 60)
addDropdownInline(g, "target lock", {"Toggle","Hold"},
    function() return Config['Keybinds']['Target Lock']['Mode'] end,
    function(v) Config['Keybinds']['Target Lock']['Mode'] = v end)
addDropdownInline(g, "trigger bot", {"Toggle","Hold"},
    function() return Config['Keybinds']['Trigger Bot']['Mode'] end,
    function(v) Config['Keybinds']['Trigger Bot']['Mode'] = v end)

------------------------- VISUAL -------------------------
local visPage = addTab("visual")
visPage.CanvasSize = UDim2.new(0, 0, 0, 540)

g = addGroup(visPage, "fov circle", 6, 6, COL_W, 90)
addToggle(g, "enabled",
    function() return Config['FOV']['Enabled'] end,
    function(v) Config['FOV']['Enabled'] = v end)
addToggle(g, "visible",
    function() return Config['FOV']['Visible'] end,
    function(v) Config['FOV']['Visible'] = v end)
addSlider(g, "radius", 10, 500, 0,
    function() return Config['FOV']['Size'] end,
    function(v) Config['FOV']['Size'] = v end, "px")
addSlider(g, "thickness", 1, 8, 0,
    function() return Config['FOV']['Thickness'] end,
    function(v) Config['FOV']['Thickness'] = v end)
addColor(g, "color",
    function() return Config['FOV']['Active Color'] end,
    function(v) Config['FOV']['Active Color'] = v end)

g = addGroup(visPage, "target line", 6 + COL_W + COL_GAP, 6, COL_W, 90)
addToggle(g, "enabled",
    function() return Config['Target Line']['Enabled'] end,
    function(v) Config['Target Line']['Enabled'] = v end)
addSlider(g, "thickness", 0.5, 6, 1,
    function() return Config['Target Line']['Thickness'] end,
    function(v) Config['Target Line']['Thickness'] = v end)
addSlider(g, "transparency", 0, 1, 2,
    function() return Config['Target Line']['Transparency'] end,
    function(v) Config['Target Line']['Transparency'] = v end)
addColor(g, "vulnerable",
    function() return Config['Target Line']['Vulnerable'] end,
    function(v) Config['Target Line']['Vulnerable'] = v end)
addColor(g, "invulnerable",
    function() return Config['Target Line']['Invulnerable'] end,
    function(v) Config['Target Line']['Invulnerable'] = v end)

g = addGroup(visPage, "esp - master", 6, 102, COL_W, 50)
addToggle(g, "enabled",
    function() return ESP['Enabled'] end,
    function(v) ESP['Enabled'] = v end,
    function() return Config['Keybinds']['ESP'] end,
    function(v) Config['Keybinds']['ESP'] = v end)

g = addGroup(visPage, "esp - boxes", 6 + COL_W + COL_GAP, 102, COL_W, 90)
addToggle(g, "boxes",
    function() return ESP['Boxes']['Enabled'] end,
    function(v) ESP['Boxes']['Enabled'] = v end,
    nil, nil,
    function() return ESP['Boxes']['Color'] end,
    function(v) ESP['Boxes']['Color'] = v end)
addToggle(g, "fill",
    function() return ESP['Boxes']['Fill'] end,
    function(v) ESP['Boxes']['Fill'] = v end,
    nil, nil,
    function() return ESP['Boxes']['Fill Color'] end,
    function(v) ESP['Boxes']['Fill Color'] = v end)
addSlider(g, "fill transparency", 0, 1, 2,
    function() return ESP['Boxes']['Fill Transparency'] end,
    function(v) ESP['Boxes']['Fill Transparency'] = v end)
addSlider(g, "box transparency", 0, 1, 2,
    function() return ESP['Boxes']['Transparency'] end,
    function(v) ESP['Boxes']['Transparency'] = v end)

g = addGroup(visPage, "esp - names", 6, 158, COL_W, 78)
addToggle(g, "enabled",
    function() return ESP['Name']['Enabled'] end,
    function(v) ESP['Name']['Enabled'] = v end,
    nil, nil,
    function() return ESP['Name']['Color'] end,
    function(v) ESP['Name']['Color'] = v end)
addToggle(g, "use display name",
    function() return ESP['Name']['Use Display Name'] end,
    function(v) ESP['Name']['Use Display Name'] = v end)
addDropdownInline(g, "position",
    {"Top","Bottom","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight"},
    function() return ESP['Name']['Position'] end,
    function(v) ESP['Name']['Position'] = v end)

g = addGroup(visPage, "esp - distance", 6 + COL_W + COL_GAP, 198, COL_W, 60)
addToggle(g, "enabled",
    function() return ESP['Distance']['Enabled'] end,
    function(v) ESP['Distance']['Enabled'] = v end,
    nil, nil,
    function() return ESP['Distance']['Color'] end,
    function(v) ESP['Distance']['Color'] = v end)
addDropdownInline(g, "position",
    {"Top","Bottom","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight"},
    function() return ESP['Distance']['Position'] end,
    function(v) ESP['Distance']['Position'] = v end)

g = addGroup(visPage, "esp - weapons", 6, 242, COL_W, 78)
addToggle(g, "enabled",
    function() return ESP['Weapons']['Enabled'] end,
    function(v) ESP['Weapons']['Enabled'] = v end,
    nil, nil,
    function() return ESP['Weapons']['Color'] end,
    function(v) ESP['Weapons']['Color'] = v end)
addToggle(g, "show ammo",
    function() return ESP['Weapons']['ShowAmmo'] end,
    function(v) ESP['Weapons']['ShowAmmo'] = v end)
addDropdownInline(g, "position",
    {"Top","Bottom","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight"},
    function() return ESP['Weapons']['Position'] end,
    function(v) ESP['Weapons']['Position'] = v end)

g = addGroup(visPage, "esp - tracers", 6 + COL_W + COL_GAP, 264, COL_W, 78)
addToggle(g, "enabled",
    function() return ESP['Tracers']['Enabled'] end,
    function(v) ESP['Tracers']['Enabled'] = v end,
    nil, nil,
    function() return ESP['Tracers']['Color'] end,
    function(v) ESP['Tracers']['Color'] = v end)
addSlider(g, "thickness", 0.5, 5, 1,
    function() return ESP['Tracers']['Thickness'] end,
    function(v) ESP['Tracers']['Thickness'] = v end)
addDropdownInline(g, "origin", {"Bottom","Top","Middle","Mouse"},
    function() return ESP['Tracers']['Origin'] end,
    function(v) ESP['Tracers']['Origin'] = v end)

g = addGroup(visPage, "esp - target highlight", 6, 326, COL_W * 2 + COL_GAP, 40)
addColor(g, "target color (applies to all)",
    function() return ESP['Boxes']['Target Color'] end,
    function(v)
        ESP['Boxes']['Target Color']    = v
        ESP['Name']['Target Color']     = v
        ESP['Distance']['Target Color'] = v
        ESP['Weapons']['Target Color']  = v
        ESP['Tracers']['Target Color']  = v
    end)

------------------------- CHARACTER -------------------------
local charPage = addTab("character")
charPage.CanvasSize = UDim2.new(0, 0, 0, 300)

g = addGroup(charPage, "speed", 6, 6, COL_W, 75)
addToggle(g, "enabled",
    function() return Config['Speed']['Enabled'] end,
    function(v) Config['Speed']['Enabled'] = v end,
    function() return Config['Keybinds']['Speed'] end,
    function(v) Config['Keybinds']['Speed'] = v end)
addSlider(g, "multiplier", 1, 100, 0,
    function() return Config['Speed']['Multiplier'] end,
    function(v) Config['Speed']['Multiplier'] = v end)

g = addGroup(charPage, "noclip", 6 + COL_W + COL_GAP, 6, COL_W, 50)
addToggle(g, "enabled",
    function() return Config['Noclip']['Enabled'] end,
    function(v) Config['Noclip']['Enabled'] = v; setNoclip(v) end)

g = addGroup(charPage, "anti fling", 6, 87, COL_W, 50)
addToggle(g, "enabled",
    function() return Config['Speed']['Anti Fling'] end,
    function(v) Config['Speed']['Anti Fling'] = v end)

g = addGroup(charPage, "spiderman", 6 + COL_W + COL_GAP, 62, COL_W, 75)
addToggle(g, "enabled",
    function() return Config['Spiderman']['Enabled'] end,
    function(v) Config['Spiderman']['Enabled'] = v; if not v then clearWeb() end end)
new("TextLabel", {
    Text = " hold LMB to swing",
    Font = FONT, TextSize = 11,
    TextColor3 = T.TextDim,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -4, 0, 14),
    Parent = g,
})

--==============================================================
-- Init
--==============================================================
selectTab(tabs[1])

do
    local last, frames = tick(), 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - last >= 0.5 then
            fpsLabel.Text = "FPS: " .. tostring(math.floor(frames / (tick() - last)))
            last, frames = tick(), 0
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        window.Visible = not window.Visible
    end
end)

if Config['Noclip']['Enabled'] then setNoclip(true) end
