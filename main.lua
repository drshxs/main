local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Signal | Universal",
    Icon = 0,
    LoadingTitle = "Signal | Universal",
    LoadingSubtitle = "by Signal",
    Theme = "Dark",
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, 
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Signal"
    },
 
    Discord = {
       Enabled = false, 
       Invite = "noinvitelink",
       RememberJoins = true 
    },
 
    KeySystem = true,
    KeySettings = {
       Title = "Signal [UNI]",
       Subtitle = "Key System",
       Note = "Ask the provider of the script for the key",
       FileName = "Signal", 
       SaveKey = false, 
       GrabKeyFromSite = false, 
       Key = {"signal"}
    }
})

local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local aimTab = Window:CreateTab("Aim", 4483362458) 
local visualTab = Window:CreateTab("Visuals", 4483362458)
local plrTab = Window:CreateTab("Player", 4483362458)
local miscTab = Window:CreateTab("Miscellaneous", 4483362458)

local holdingRMB = false
local aimingEnabled = false
local teamCheckEnabled = false
local targetPart = "Head"
local smoothing = 0
local lockedTarget = nil
local distanceThreshold = 20
local checkInterval = 0.5
local lastPosition = nil
local lastCheckTime = 0

local lineESPEnabled = false
local headESPEnabled = false
local boxESPEnabled = false
local healthESPEnabled = false
local highlightESPEnabled = false

local lineTransparency = 1
local headTransparency = 1
local boxTransparency = 1

local lineESP = {}
local headESP = {}
local boxESP = {}
local healthESP = {}
local highlightESP = {}

local Toggle = aimTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "aimEnabled", 
    Callback = function(Value)
        aimingEnabled = Value
    end,
})

local TeamCheckToggle = aimTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "teamCheckEnabled",
    Callback = function(Value)
        teamCheckEnabled = Value
    end,
})

local Slider = aimTab:CreateSlider({
    Name = "Smoothing",
    Range = {1, 50},
    Increment = 0.01,
    Suffix = "smoothing",
    CurrentValue = 0,
    Flag = "smoothValue", 
    Callback = function(Value)
        smoothing = Value
    end,
})

local Dropdown = aimTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(selected)
        targetPart = selected
    end,
 })

local LineESPToggle = visualTab:CreateToggle({
    Name = "Line ESP",
    CurrentValue = false,
    Flag = "lineESPEnabled",
    Callback = function(Value)
        lineESPEnabled = Value
        if not Value then
            for _, esp in pairs(lineESP) do
                if esp then
                    esp:Remove()
                end
            end
            lineESP = {}
        end
    end,
})

local Slider = visualTab:CreateSlider({
    Name = "Line Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "transparency",
    CurrentValue = 1,
    Flag = "lineESPTransparency", 
    Callback = function(Value)
        lineTransparency = Value
        for _, line in pairs(lineESP) do
            line.Transparency = lineTransparency
        end
    end,
})

local HeadESPToggle = visualTab:CreateToggle({
    Name = "Head ESP",
    CurrentValue = false,
    Flag = "headESPEnabled",
    Callback = function(Value)
        headESPEnabled = Value
        if not Value then
            for _, esp in pairs(headESP) do
                if esp then
                    esp:Remove()
                end
            end
            headESP = {}
        end
    end,
})

local Slider = visualTab:CreateSlider({
    Name = "Head ESP Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "transparency",
    CurrentValue = 1,
    Flag = "headESPTransparency", 
    Callback = function(Value)
        headTransparency = Value
        for _, circle in pairs(headESP) do
            circle.Transparency = headTransparency
        end
    end,
})

local BoxESPToggle = visualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "boxESPEnabled",
    Callback = function(Value)
        boxESPEnabled = Value
        if not Value then
            for _, esp in pairs(boxESP) do
                if esp then
                    esp:Remove()
                end
            end
            boxESP = {}
        end
    end,
})

local Slider = visualTab:CreateSlider({
    Name = "Box Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "transparency",
    CurrentValue = 1,
    Flag = "boxESPTransparency", 
    Callback = function(Value)
        boxTransparency = Value
        for _, box in pairs(boxESP) do
            box.Transparency = boxTransparency
        end
    end,
})

local HealthESPToggle = visualTab:CreateToggle({
    Name = "Health ESP",
    CurrentValue = false,
    Flag = "healthESPEnabled",
    Callback = function(Value)
        healthESPEnabled = Value
        if not Value then
            for _, esp in pairs(healthESP) do
                if esp then
                    esp:Remove()
                end
            end
            healthESP = {}
        end
    end,
})

local HighlightESPToggle = visualTab:CreateToggle({
    Name = "Highlight ESP",
    CurrentValue = false,
    Flag = "highlightESPEnabled",
    Callback = function(Value)
        highlightESPEnabled = Value
        if not Value then
            for _, esp in pairs(highlightESP) do
                if esp then
                    esp:Destroy()
                end
            end
            highlightESP = {}
        end
    end,
})

local Button = miscTab:CreateButton({
    Name = "Unload UI",
    Callback = function()
        lineESPEnabled = false
        headESPEnabled = false
        boxESPEnabled = false
        healthESPEnabled = false
        highlightESPEnabled = false

        for _, esp in pairs(lineESP) do
            if esp then
                esp:Remove()
            end
        end
        for _, esp in pairs(headESP) do
            if esp then
                esp:Remove()
            end
        end
        for _, esp in pairs(boxESP) do
            if esp then
                esp:Remove()
            end
        end
        for _, esp in pairs(healthESP) do
            if esp then
                esp:Remove()
            end
        end
        for _, esp in pairs(highlightESP) do
            if esp then
                esp:Remove()
            end
        end

        lineESP = {}
        headESP = {}
        boxESP = {}
        healthESP = {}
        highlightESP = {}

        aimingEnabled = false
        teamCheckEnabled = false
        smoothing = 0
        targetPart = nil
        lockedTarget = nil
        Rayfield:Destroy()
    end,
})

local bhopToggle = plrTab:CreateToggle({
    Name = "BHOP",
    CurrentValue = false,
    Flag = "bhopEnabled",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local savedWS = humanoid.WalkSpeed
        
        if humanoid then
            if Value then
                humanoid.WalkSpeed = 50
                local bhopEnabled = true
                humanoid.StateChanged:Connect(function(_, newState)
                    if bhopEnabled and newState == Enum.HumanoidStateType.Landed then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                humanoid.WalkSpeed = savedWS
                bhopEnabled = false
            end
        end
    end,
})

players.PlayerRemoving:Connect(function(player)
    if lineESP[player] then
        lineESP[player]:Remove()
        lineESP[player] = nil
    end
    if headESP[player] then
        headESP[player]:Remove()
        headESP[player] = nil
    end
    if boxESP[player] then
        boxESP[player]:Remove()
        boxESP[player] = nil
    end
    if healthESP[player] then
        healthESP[player]:Remove()
        healthESP[player] = nil
    end
    if highlightESP[player] then
        highlightESP[player]:Remove()
        highlightESP[player] = nil
    end
end)

runService.Heartbeat:Connect(function()
    -- Line ESP
    if lineESPEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local line = lineESP[player]
                
                if teamCheckEnabled and player.Team == localPlayer.Team then
                    if lineESP[player] then
                        lineESP[player].Visible = false
                    end
                    continue
                end

                if not line then
                    line = Drawing.new("Line")
                    line.Thickness = 1
                    line.Transparency = lineTransparency
                    line.Color = Color3.fromRGB(255, 255, 255)
                    lineESP[player] = line
                end

                local character = player.Character
                local head = character:FindFirstChild("Head")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                
                if head and humanoidRootPart then
                    local headPos = head.Position
                    local rootPos = humanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
                    local rootScreenPos, rootOnScreen = camera:WorldToViewportPoint(rootPos)

                    if onScreen then
                        if boxESP[player] and boxESP[player].Visible then
                            local box = boxESP[player]
                            local boxBottomCenter = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y + box.Size.Y)
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = boxBottomCenter
                        else
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(screenPos.X, screenPos.Y)
                        end
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                end
            elseif lineESP[player] then
                lineESP[player]:Remove()
                lineESP[player] = nil
            end
        end
    end

    -- Head ESP
    if headESPEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                if teamCheckEnabled and player.Team == localPlayer.Team then
                    if headESP[player] then
                        headESP[player].Visible = false
                    end
                    continue
                end

                if not headESP[player] then
                    local circle = Drawing.new("Circle")
                    circle.Thickness = 1
                    circle.Transparency = headTransparency
                    circle.Color = Color3.fromRGB(255, 255, 255)
                    circle.Filled = false
                    headESP[player] = circle
                end

                local head = player.Character.Head
                local headPos = head.Position
                local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
                local circle = headESP[player]

                if onScreen then
                    local distance = (camera.CFrame.Position - headPos).Magnitude
                    local scaleFactor = 425 
                    local headSize = (head.Size.X + head.Size.Y + head.Size.Z) / 3
                    circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                    circle.Radius = (headSize * scaleFactor) / distance
                    circle.Visible = true
                else
                    circle.Visible = false
                end
            elseif headESP[player] then
                headESP[player]:Remove()
                headESP[player] = nil
            end
        end
    end

    -- Box ESP
    if boxESPEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if teamCheckEnabled and player.Team == localPlayer.Team then
                    if boxESP[player] then
                        boxESP[player].Visible = false
                    end
                    continue
                end
        
                if not boxESP[player] then
                    local box = Drawing.new("Square")
                    box.Thickness = 1
                    box.Transparency = boxTransparency
                    box.Color = Color3.fromRGB(255, 255, 255)
                    box.Filled = false
                    boxESP[player] = box
                end
        
                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local rootPos = humanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(rootPos)
        
                    if onScreen then
                        local distance = (camera.CFrame.Position - rootPos).Magnitude
                        local scaleFactor = math.max(1000 / distance, 0.5)
                        local extentsSize = character:GetExtentsSize()
                        local width = extentsSize.X * scaleFactor
                        local height = extentsSize.Y * scaleFactor
        
                        local box = boxESP[player]
                        local characterPos = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
        
                        box.Position = characterPos
                        box.Size = Vector2.new(width, height)
                        box.Visible = true
                    else
                        if boxESP[player] then
                            boxESP[player].Visible = false
                        end
                    end
                end
            elseif boxESP[player] then
                boxESP[player]:Remove()
                boxESP[player] = nil
            end
        end
    end

    -- Health ESP
    if healthESPEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if teamCheckEnabled and player.Team == localPlayer.Team then
                    if healthESP[player] then
                        healthESP[player].Visible = false
                    end
                    continue
                end

                if not healthESP[player] then
                    local text = Drawing.new("Text")
                    text.Size = 12
                    text.Color = Color3.fromRGB(0, 255, 0)
                    text.Transparency = 1
                    text.Outline = true
                    healthESP[player] = text
                end

                local humanoid = player.Character:FindFirstChild("Humanoid")
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoidRootPart then
                    local torsoPos = humanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(torsoPos)
                    local health = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                    local text = healthESP[player]

                    if onScreen then
                        if boxESPEnabled and boxESP[player] and boxESP[player].Visible then
                            local box = boxESP[player]
                            text.Position = Vector2.new(
                                box.Position.X + box.Size.X + 5,
                                box.Position.Y
                            )
                        else
                            local textWidth = text.TextBounds.X
                            local textHeight = text.TextBounds.Y
                            text.Position = Vector2.new(
                                screenPos.X - (textWidth / 2),
                                screenPos.Y - (textHeight / 2)
                            )
                        end

                        text.Text = string.format("HP: %d", health)
                        text.Visible = true
                    else
                        text.Visible = false
                    end
                else
                    if healthESP[player] then
                        healthESP[player]:Remove()
                        healthESP[player] = nil
                    end
                end
            elseif healthESP[player] then
                healthESP[player]:Remove()
                healthESP[player] = nil
            end
        end
    end

    -- Highlight ESP
    if highlightESPEnabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                if teamCheckEnabled and player.Team == localPlayer.Team then
                    if highlightESP[player] then
                        highlightESP[player]:Destroy()
                        highlightESP[player] = nil
                    end
                    continue
                end

                if not highlightESP[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HighlightESP"
                    highlight.FillTransparency = 1
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                    highlight.Adornee = player.Character
                    highlightESP[player] = highlight
                end
            elseif highlightESP[player] then
                highlightESP[player]:Destroy()
                highlightESP[player] = nil
            end
        end
    end

    -- Aiming
    if aimingEnabled and holdingRMB and lockedTarget then
        local targetChar = lockedTarget.Character
        if targetChar and targetChar:FindFirstChild(targetPart) then
            local humanoidRootPart = targetChar:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local currentTime = tick()
                if lastPosition and (currentTime - lastCheckTime) >= checkInterval then
                    local distanceMoved = (humanoidRootPart.Position - lastPosition).Magnitude
                    if distanceMoved > distanceThreshold then
                        lockedTarget = nil
                        print("Target moved too far, lock broken.")
                        return
                    end
                    lastCheckTime = currentTime
                end
                lastPosition = humanoidRootPart.Position
            end

            local targetPos = targetChar[targetPart].Position
            local direction = (targetPos - camera.CFrame.Position).Unit
            local smoothFactor = math.max(0.1, (50 - smoothing) / 50)

            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector:Lerp(direction, smoothFactor))
        else
            lockedTarget = nil
        end
    end
end)

-- handling for aim
userInput.InputBegan:Connect(function(input, gameProcessed)
    if aimingEnabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
        if not holdingRMB then
            holdingRMB = true
            lockedTarget = getClosestPlayerToCursor()
            if lockedTarget then
                local humanoidRootPart = lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart")
                lastPosition = humanoidRootPart and humanoidRootPart.Position or nil
                lastCheckTime = tick()
            end
        end
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRMB = false
        lockedTarget = nil
        lastPosition = nil
    end
end)

-- helper
function getClosestPlayerToCursor()
    local mouse = localPlayer:GetMouse()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheckEnabled and player.Team == localPlayer.Team then
                continue
            end

            local screenPos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end
