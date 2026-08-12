 -------------------------------- ================================================================
-------------------------------- 
----------------------------------------------------------------
-------------------------------- ================================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "MYSTERY VS SHERIFF DUELOS BETA",
    LoadingTitle = "BY EL 01 ROX HUB",
    LoadingSubtitle = "VERSION BETA",
    ConfigurationSaving = { Enabled = false },
    Theme = "Default",
    KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- ================== VARIABLES GENERALES ==================
local espEnabled = false
local espColor = Color3.fromRGB(255, 255, 255)
local espSettings = { Lines = true }
local linePosition = "ABAJO"
local lineColor = Color3.fromRGB(255, 255, 255)
local MAX_ESP_DISTANCE = 400
local MAX_LINES = 4

local fovVisiblePreference = false
local fovRadius = 120

-- HITBOX NORMAL (Visible - con efectos visuales)
local hitboxEnabled = false
local hitboxSize = 10
local hitboxColor = Color3.fromRGB(255, 255, 255)

-- HITBOX INVISIBLE (COMPLETAMENTE INVISIBLE - SOLO EXPANDE LA CAJA)
local hitboxInvisibleEnabled = false
local invisibleHitboxSize = 10

-- Toggles con exclusividad
getgenv().SilentAimEnabled = false
getgenv().SilentAimFOVEnabled = false
getgenv().AutoShootGunEnabled = false
getgenv().AutoShootKnifeEnabled = false
getgenv().AstraTargetPart = nil

-- ================== VARIABLES DE GRÁFICOS ==================
local tokyowamiEffects = {}
local nightEffects = {}
local pinkEffects = {}
local nightActivo = false
local pinkActivo = false

local shaderAjustes = {
    Exposicion = 0.28,
    Sombras = 5,
    Neon = 0.45,
    LunaPos = 85,
    Desenfoque = 2,
    SuavidadSombras = 0.1,
    ColorSaturacion = 0.15,
    PinkRosa = 0.8,
    PinkMorado = 0.7,
    PinkSaturacion = 0.4,
    PinkNeon = 0.3
}

local function ToggleNubesYAtmo(apagar, tag)
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            if apagar then
                if not obj:GetAttribute("OrigGuardado_"..tag) then
                    obj:SetAttribute("OrigDensity_"..tag, obj.Density)
                    obj:SetAttribute("OrigCapacity_"..tag, obj.Capacity)
                    obj:SetAttribute("OrigGuardado_"..tag, true)
                end
                obj.Density = 0
                obj.Capacity = 0
            else
                if obj:GetAttribute("OrigGuardado_"..tag) then
                    obj.Density = obj:GetAttribute("OrigDensity_"..tag)
                    obj.Capacity = obj:GetAttribute("OrigCapacity_"..tag)
                    obj:SetAttribute("OrigGuardado_"..tag, nil)
                end
            end
        end
    end
    
    local function checkClouds(parentObj)
        if not parentObj then return end
        for _, obj in ipairs(parentObj:GetChildren()) do
            if obj:IsA("Clouds") then
                if apagar then
                    if not obj:GetAttribute("OrigGuardado_"..tag) then
                        obj:SetAttribute("OrigEnabled_"..tag, obj.Enabled)
                        obj:SetAttribute("OrigGuardado_"..tag, true)
                    end
                    obj.Enabled = false
                else
                    if obj:GetAttribute("OrigGuardado_"..tag) then
                        obj.Enabled = obj:GetAttribute("OrigEnabled_"..tag)
                        obj:SetAttribute("OrigGuardado_"..tag, nil)
                    end
                end
            end
        end
    end
    
    checkClouds(Workspace)
    checkClouds(Workspace:FindFirstChildOfClass("Terrain"))
end

local function UpdatePinkHourVibe()
    if not pinkActivo then return end
    
    local rosa = shaderAjustes.PinkRosa
    local morado = shaderAjustes.PinkMorado
    
    local r = math.clamp(math.floor(255 - (100 * morado)), 0, 255)
    local g = math.clamp(math.floor(255 - (155 * rosa) - (200 * morado)), 0, 255)
    local b = 255
    
    for _, effect in ipairs(pinkEffects) do
        if effect:IsA("ColorCorrectionEffect") then
            effect.TintColor = Color3.fromRGB(r, g, b)
            effect.Saturation = shaderAjustes.PinkSaturacion
            effect.Contrast = 0.05 + (0.1 * morado) + (0.05 * rosa)
        elseif effect:IsA("BloomEffect") then
            effect.Intensity = shaderAjustes.PinkNeon
        end
    end
    
    Lighting.ColorShift_Top = Color3.fromRGB(math.floor(255 - (50 * morado)), math.floor(50 + (50 * (1-rosa))), math.floor(150 + (105 * morado)))
    Lighting.ColorShift_Bottom = Color3.fromRGB(math.floor(30 + (70 * rosa)), 0, math.floor(50 + (80 * morado)))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(50 + (80 * rosa)), 0, math.floor(80 + (80 * morado)))
    Lighting.Ambient = Color3.fromRGB(math.floor(60 + (30 * rosa)), math.floor(20 * (1-morado)), math.floor(80 + (40 * morado)))
    Lighting.ExposureCompensation = 0.1 - (0.25 * morado)
end

-- ================== FUNCIONES AUXILIARES ==================
local function isEnemy(p)
    if p == LocalPlayer then return false end
    local myTeam = LocalPlayer:GetAttribute("Team")
    local targetTeam = p:GetAttribute("Team")
    if myTeam and targetTeam then return myTeam ~= targetTeam end
    if LocalPlayer.Team and p.Team then return LocalPlayer.Team ~= p.Team end
    return true
end

local function GetPartByChoice(char)
    return char:FindFirstChild("Head")
end

local function estaEnLobby()
    local char = LocalPlayer.Character
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    if LocalPlayer.Team then
        local tName = string.lower(LocalPlayer.Team.Name)
        if string.find(tName, "lobby") or string.find(tName, "spectat") or string.find(tName, "espectador") or string.find(tName, "menu") or string.find(tName, "dead") then
            return true
        end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local zonasLobby = {
            {Centro = Vector3.new(-320.50, 280.82, 16.00), Radio = 500},
            {Centro = Vector3.new(1564.14, -155.45, 40.04), Radio = 300}
        }
        for _, zona in ipairs(zonasLobby) do
            if (hrp.Position - zona.Centro).Magnitude <= zona.Radio then
                return true
            end
        end
    end
    return false
end

local function esLaPistola(item)
    if not item:IsA("Tool") then return false end
    if item:FindFirstChild("Throw", true) or item:FindFirstChild("KnifeClient", true) or item:FindFirstChild("KnifeServer", true) then
        return false
    end
    local nombre = string.lower(item.Name)
    local ignorar = {"combat", "fist", "wallet", "phone", "punch", "boombox", "radio", "knife", "blade", "cuchillo", "dagger", "kunai", "sword", "toy", "juguete", "pizza", "burger", "teddy", "balloon", "drink", "food"}
    for _, palabra in ipairs(ignorar) do
        if string.find(nombre, palabra) then return false end
    end
    return true
end

-- ================== SILENT AIM ORIGINAL ==================
local oldIndex = nil
if hookmetamethod then
    oldIndex = hookmetamethod(game, "__index", function(self, index)
        if getgenv().SilentAimEnabled and self == LocalPlayer:GetMouse() and index == "Hit" and not checkcaller() then
            local targetPart, closestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and isEnemy(p) then
                    local part = GetPartByChoice(p.Character)
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if part and hum and hum.Health > 0 then
                        local distFisica = (part.Position - Camera.CFrame.Position).Magnitude
                        if distFisica < closestDist then
                            closestDist = distFisica
                            targetPart = part
                        end
                    end
                end
            end
            if targetPart then return CFrame.new(targetPart.Position) end
        end
        return oldIndex(self, index)
    end)
end

-- ================== SILENT AIM CON FOV ==================
local oldNamecallFOV = nil
if hookmetamethod then
    oldNamecallFOV = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if getgenv().SilentAimFOVEnabled and not checkcaller() and getgenv().AstraTargetPart and getgenv().AstraTargetPart.Parent then
            local target = getgenv().AstraTargetPart
            local cameraOrigin = Camera.CFrame.Position
            
            if method == "Raycast" and self == Workspace then
                local origin, direction, p3 = ...
                if (origin - cameraOrigin).Magnitude < 1 then
                    return oldNamecallFOV(self, ...)
                end
                if typeof(direction) == "Vector3" and direction.Magnitude > 5 then
                    local newDir = (target.Position - origin).Unit * 5000
                    return oldNamecallFOV(self, origin, newDir, p3)
                end
            elseif string.find(method, "FindPartOnRay") and self == Workspace then
                local ray, p2, p3, p4 = ...
                if (ray.Origin - cameraOrigin).Magnitude < 1 then
                    return oldNamecallFOV(self, ...)
                end
                if typeof(ray) == "Ray" and ray.Direction.Magnitude > 5 then
                    local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                    return oldNamecallFOV(self, newRay, p2, p3, p4)
                end
            end
        end
        return oldNamecallFOV(self, ...)
    end)
end

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait() do
        if getgenv().SilentAimFOVEnabled and not estaEnLobby() then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local closestTargetPart = nil
            local shortestDistToCenter = math.huge
            
            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            
            local viewport = Camera.ViewportSize
            local mousePos = Vector2.new(viewport.X / 2, viewport.Y / 2)

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        local part = GetPartByChoice(p.Character)
                        if part then
                            local pos2D, onScreen = Camera:WorldToViewportPoint(part.Position)
                            local distToCenter = (Vector2.new(pos2D.X, pos2D.Y) - mousePos).Magnitude
                            
                            if onScreen and distToCenter <= fovRadius and distToCenter < shortestDistToCenter then
                                params.FilterDescendantsInstances = {char, p.Character}
                                local raycastResult = Workspace:Raycast(headPos, part.Position - headPos, params)
                                if not raycastResult then
                                    shortestDistToCenter = distToCenter
                                    closestTargetPart = part
                                end
                            end
                        end
                    end
                end
            end
            
            if closestTargetPart then
                getgenv().AstraTargetPart = closestTargetPart
            else
                getgenv().AstraTargetPart = nil
            end
        end
    end
end)

-- ================== AUTO SHOOT ==================
local oldNamecall = nil
if hookmetamethod then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (getgenv().AutoShootGunEnabled or getgenv().AutoShootKnifeEnabled) 
            and not checkcaller() and getgenv().AstraTargetPart and getgenv().AstraTargetPart.Parent then
            local target = getgenv().AstraTargetPart
            if method == "Raycast" and self == Workspace then
                local origin, dir = ...
                if dir and dir.Magnitude > 20 then
                    local newDir = (target.Position - origin).Unit * 5000
                    return oldNamecall(self, origin, newDir, select(3, ...))
                end
            elseif string.find(method, "FindPartOnRay") and self == Workspace then
                local ray = ...
                if ray and ray.Direction.Magnitude > 20 then
                    local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                    return oldNamecall(self, newRay, select(2, ...))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local lastShot = 0
    while task.wait(0.05) do
        getgenv().AstraTargetPart = nil
        if not getgenv().AutoShootGunEnabled and not getgenv().AutoShootKnifeEnabled then continue end
        if estaEnLobby() then continue end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local arma = char:FindFirstChildOfClass("Tool")
        if not arma or not arma:FindFirstChild("Handle") then continue end

        local esPistola = esLaPistola(arma)
        if esPistola and not getgenv().AutoShootGunEnabled then continue end
        if not esPistola and not getgenv().AutoShootKnifeEnabled then continue end

        local closestPart, minDist = nil, math.huge
        local myPos = char.HumanoidRootPart.Position
        local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and isEnemy(p) then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local part = GetPartByChoice(p.Character)
                if hum and hum.Health > 0 and part then
                    local dist = (part.Position - myPos).Magnitude
                    if dist < minDist and dist < 1000 then
                        params.FilterDescendantsInstances = {char, p.Character}
                        if not Workspace:Raycast(headPos, part.Position - headPos, params) then
                            minDist = dist
                            closestPart = part
                        end
                    end
                end
            end
        end

        getgenv().AstraTargetPart = closestPart
        if closestPart then
            local now = os.clock()
            if now - lastShot > 0.08 then
                lastShot = now
                pcall(function()
                    arma:Activate()
                    task.delay(0.02, function()
                        if arma.Parent == char then arma:Deactivate() end
                    end)
                end)
            end
        end
    end
end)

-- ================== MACRO ==================
local macroActivo = false
local macroEquipDelay = 0.04
local macroShootDelay = 0.10
local deadZoneFrame = Instance.new("Frame")
deadZoneFrame.Size = UDim2.new(0, 150, 0, 150)
deadZoneFrame.Position = UDim2.new(0.8, -75, 0.8, -75)
deadZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
deadZoneFrame.BackgroundTransparency = 0.5
deadZoneFrame.Visible = false
deadZoneFrame.ZIndex = 100
deadZoneFrame.Parent = LocalPlayer:WaitForChild("PlayerGui")
Instance.new("UICorner", deadZoneFrame).CornerRadius = UDim.new(0, 16)
local dzStroke = Instance.new("UIStroke", deadZoneFrame)
dzStroke.Color = Color3.fromRGB(255, 255, 255)
dzStroke.Thickness = 2
dzStroke.LineJoinMode = Enum.LineJoinMode.Round

local function makeDraggable(guiObject, objectToMove)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            objectToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(deadZoneFrame, deadZoneFrame)

local function obtenerPistola()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char then for _, item in ipairs(char:GetChildren()) do if esLaPistola(item) then return item end end end
    if backpack then for _, item in ipairs(backpack:GetChildren()) do if esLaPistola(item) then return item end end end
    return nil
end

local function ejecutarAccionMacro()
    if estaEnLobby() then return end

    local hayEnemigos = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pChar = p.Character
            if pChar and pChar:FindFirstChild("Humanoid") and pChar.Humanoid.Health > 0 then
                if LocalPlayer.Team == nil or p.Team == nil or LocalPlayer.Team ~= p.Team then
                    hayEnemigos = true
                    break
                end
            end
        end
    end

    if not hayEnemigos then return end

    local char = LocalPlayer.Character if not char then return end
    local hum = char:FindFirstChild("Humanoid") if not hum then return end
    local herramientaEnMano = char:FindFirstChildOfClass("Tool")
    if herramientaEnMano and not esLaPistola(herramientaEnMano) then return end

    local pistola = obtenerPistola()
    if not pistola then return end

    task.spawn(function()
        hum:UnequipTools()
        task.wait()
        hum:EquipTool(pistola)
        task.wait(macroEquipDelay)
        if pistola.Parent == char then
            pistola:Activate()
            task.wait(macroShootDelay)
            pistola:Deactivate()
            hum:UnequipTools()
        end
    end)
end

local toquesPantalla = {}

UserInputService.InputChanged:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        if (toquesPantalla[input].posicion - input.Position).Magnitude > 10 then
            toquesPantalla = {}
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not macroActivo then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ejecutarAccionMacro()
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local dzPos = deadZoneFrame.AbsolutePosition
        local dzSize = deadZoneFrame.AbsoluteSize
        local tocoZonaMuerta = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
        if not tocoZonaMuerta then
            toquesPantalla[input] = {posicion = input.Position, tiempo = tick()}
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if not macroActivo then return end
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        local datosToque = toquesPantalla[input]
        local posicionFinal = input.Position
        local distanciaMovida = (datosToque.posicion - posicionFinal).Magnitude
        local tiempoPresionado = tick() - datosToque.tiempo
        toquesPantalla[input] = nil
        if distanciaMovida < 10 and tiempoPresionado < 0.35 and tiempoPresionado > 0.03 then
            ejecutarAccionMacro()
        end
    end
end)

-- ================== ESP UNIFICADO (SOLO LINEAS) ==================
local tracerLines = {}

local function cleanESP(targetPlayer)
    if tracerLines[targetPlayer] then
        tracerLines[targetPlayer]:Remove()
        tracerLines[targetPlayer] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not espEnabled or not espSettings.Lines then
        for _, line in pairs(tracerLines) do
            if line and line.Visible then line.Visible = false end
        end
        return
    end
    
    if estaEnLobby() then
        for _, line in pairs(tracerLines) do
            if line and line.Visible then line.Visible = false end
        end
        return
    end

    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    
    if not myPos then 
        for _, line in pairs(tracerLines) do
            if line and line.Visible then line.Visible = false end
        end
        return 
    end
    
    local viewport = Camera.ViewportSize
    local startX = viewport.X / 2
    local startY = 0
    
    if linePosition == "MEDIO" then
        startY = viewport.Y / 2
    elseif linePosition == "ABAJO" then
        startY = viewport.Y
    end

    local enemies = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) then
            local char = p.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("Head") then
                local targetHead = char.Head
                local dist = (targetHead.Position - myPos).Magnitude
                
                if dist <= MAX_ESP_DISTANCE then
                    table.insert(enemies, {player = p, dist = dist})
                end
            end
        end
    end

    table.sort(enemies, function(a, b) return a.dist < b.dist end)

    local maxLines = math.min(MAX_LINES, #enemies)
    local enemiesToShow = {}
    for i = 1, maxLines do
        table.insert(enemiesToShow, enemies[i].player)
    end

    for p, line in pairs(tracerLines) do
        local shouldShow = false
        for _, enemy in ipairs(enemiesToShow) do
            if enemy == p then
                shouldShow = true
                break
            end
        end
        if not shouldShow then
            if line and line.Visible then line.Visible = false end
        end
    end

    for _, enemy in ipairs(enemiesToShow) do
        local char = enemy.Character
        if char then
            if not tracerLines[enemy] then
                local line = Drawing.new("Line")
                line.Thickness = 1.5
                line.Transparency = 1
                line.Visible = false
                tracerLines[enemy] = line
            end
            
            local line = tracerLines[enemy]
            local hrpPos, onScreen = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
            
            if onScreen then
                line.From = Vector2.new(startX, startY)
                line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                if line.Color ~= lineColor then line.Color = lineColor end
                if not line.Visible then line.Visible = true end
            else
                if line.Visible then line.Visible = false end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    cleanESP(p)
end)

-- ================== FOV CIRCLE ==================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false
FOVCircle.Thickness = 1

RunService.RenderStepped:Connect(function()
    local viewport = Camera.ViewportSize
    local centroVector = Vector2.new(viewport.X / 2, viewport.Y / 2)
    
    if fovVisiblePreference then
        FOVCircle.Position = centroVector
        FOVCircle.Radius = fovRadius
        FOVCircle.Visible = true
        if getgenv().SilentAimFOVEnabled and getgenv().AstraTargetPart then
            FOVCircle.Color = Color3.fromRGB(0, 255, 0)
        else
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        end
    else
        if FOVCircle.Visible then FOVCircle.Visible = false end
    end
end)

-- ================== HITBOX NORMAL (VISIBLE) ==================
local function limpiarHitboxNormal(v)
    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = v.Character.HumanoidRootPart
        local box = hrp:FindFirstChild("DuelsHitboxBox")
        if box then box:Destroy() end
    end
end

-- ================== HITBOX INVISIBLE (SOLO EXPANDE - SIN NADA VISUAL) ==================
local function limpiarHitboxInvisible(v)
    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = v.Character.HumanoidRootPart
        local box = hrp:FindFirstChild("DuelsHitboxInvisibleBox")
        if box then box:Destroy() end
    end
end

local function limpiarHitboxes(v)
    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = v.Character.HumanoidRootPart
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
        hrp.CanCollide = true
        local box = hrp:FindFirstChild("DuelsHitboxBox")
        if box then box:Destroy() end
        local boxInv = hrp:FindFirstChild("DuelsHitboxInvisibleBox")
        if boxInv then boxInv:Destroy() end
    end
end

-- LOOP PRINCIPAL DE HITBOX (COMBINADO)
task.spawn(function()
    if getgenv().DuelsHitboxLoop then
        getgenv().DuelsHitboxLoop = false
        task.wait(0.2)
    end
    getgenv().DuelsHitboxLoop = true

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local hitboxesLimpias = false

    while getgenv().DuelsHitboxLoop and task.wait(0.1) do
        local enLobby = false
        pcall(function() enLobby = estaEnLobby() end)

        if (hitboxEnabled or hitboxInvisibleEnabled) and not enLobby then
            hitboxesLimpias = false
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and isEnemy(v) and v.Character
                and v.Character:FindFirstChild("HumanoidRootPart")
                and v.Character:FindFirstChild("Humanoid")
                and v.Character.Humanoid.Health > 0 then

                    local hrp = v.Character.HumanoidRootPart
                    
                    -- ===== HITBOX NORMAL (Visible) =====
                    if hitboxEnabled then
                        local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        if hrp.Size ~= targetSize then hrp.Size = targetSize end
                        if hrp.CanCollide ~= false then hrp.CanCollide = false end

                        local aLaVista = false
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                            local origin = Camera.CFrame.Position
                            if (hrp.Position - origin).Magnitude < 300 then
                                params.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                                local result = Workspace:Raycast(origin, hrp.Position - origin, params)
                                aLaVista = not result
                            end
                        end

                        local targetColor = aLaVista and espColor or Color3.fromRGB(255, 50, 50)
                        local targetTrans = aLaVista and 0.4 or 0.8

                        if hrp.Transparency ~= targetTrans then hrp.Transparency = targetTrans end
                        if hrp.Material ~= Enum.Material.ForceField then hrp.Material = Enum.Material.ForceField end
                        if hrp.Color ~= targetColor then hrp.Color = targetColor end

                        local box = hrp:FindFirstChild("DuelsHitboxBox")
                        if not box then
                            box = Instance.new("BoxHandleAdornment")
                            box.Name = "DuelsHitboxBox"
                            box.Adornee = hrp
                            box.AlwaysOnTop = true
                            box.ZIndex = 5
                            box.Parent = hrp
                        end
                        if box.Size ~= hrp.Size then box.Size = hrp.Size end
                        if box.Color3 ~= targetColor then box.Color3 = targetColor end
                        box.Transparency = aLaVista and 0.2 or 0.7
                        box.Visible = true
                    else
                        limpiarHitboxNormal(v)
                        if not hitboxInvisibleEnabled then
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                            hrp.Material = Enum.Material.Plastic
                            hrp.CanCollide = true
                        end
                    end

                    -- ===== HITBOX INVISIBLE (SOLO EXPANDE - SIN NADA VISUAL) =====
                    if hitboxInvisibleEnabled then
                        local targetSizeInv = Vector3.new(invisibleHitboxSize, invisibleHitboxSize, invisibleHitboxSize)
                        if hrp.Size ~= targetSizeInv then hrp.Size = targetSizeInv end
                        if hrp.CanCollide ~= false then hrp.CanCollide = false end
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        hrp.Color = Color3.fromRGB(255, 255, 255)
                        
                        local boxInv = hrp:FindFirstChild("DuelsHitboxInvisibleBox")
                        if boxInv then boxInv:Destroy() end
                    else
                        limpiarHitboxInvisible(v)
                        if not hitboxEnabled then
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                            hrp.Material = Enum.Material.Plastic
                            hrp.CanCollide = true
                        end
                    end
                else
                    limpiarHitboxes(v)
                end
            end
        else
            if not hitboxesLimpias then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer then limpiarHitboxes(v) end
                end
                hitboxesLimpias = true
            end
        end
    end
end)

-- ================== NOTIFICACIONES ==================
local function showBottomMessage(text)
    Rayfield:Notify({
        Title = "Duels Hub",
        Content = text,
        Duration = 2.5,
        Image = 4483362458,
        Actions = {},
    })
end

-- ================== PESTAÑAS ==================
local AimbotTab = Window:CreateTab("AIMBOT", 4483362458)
local VisualesTab = Window:CreateTab("VISUALES", 4483362458)
local AutoKillsTab = Window:CreateTab("AUTO KILLS", 4483362458)
local AutoFarmTab = Window:CreateTab("AUTO FARM", 4483362458)
local AnimationsTab = Window:CreateTab("ANIMACIONES", 4483362458)
local MovementTab = Window:CreateTab("MOVIMIENTO", 4483362458)
local SettingsTab = Window:CreateTab("SETTINGS", 4483362458)
local CreditsTab = Window:CreateTab("CREDITOS", 4483362458)

CreditsTab:CreateLabel("CREADOR")
CreditsTab:CreateLabel("EL 01 ROX HUB")
CreditsTab:CreateLabel(" ")
CreditsTab:CreateLabel("CREADOR")
CreditsTab:CreateLabel("ZYROXHUB")

-- ================== SILENT AIM ==================
AimbotTab:CreateSection("SILENT AIM")

local silentAimToggle = AimbotTab:CreateToggle({
    Name = "SILENT AIM",
    CurrentValue = false,
    Callback = function(v)
        if v then
            getgenv().SilentAimFOVEnabled = false
            pcall(function() 
                if silentAimFOVToggle then silentAimFOVToggle:Set(false) end 
            end)
        end
        getgenv().SilentAimEnabled = v
    end
})

local silentAimFOVToggle = AimbotTab:CreateToggle({
    Name = "SILENT AIM (CON FOV)",
    Info = "Solo afecta a enemigos dentro del circulo",
    CurrentValue = false,
    Callback = function(v)
        if v then
            getgenv().SilentAimEnabled = false
            pcall(function() 
                if silentAimToggle then silentAimToggle:Set(false) end 
            end)
        end
        getgenv().SilentAimFOVEnabled = v
    end
})

AimbotTab:CreateToggle({
    Name = "OCULTAR/MOSTRAR FOV",
    CurrentValue = false,
    Callback = function(v) fovVisiblePreference = v end
})

AimbotTab:CreateSlider({
    Name = "TAMAÑO DEL FOV",
    Range = {10, 500},
    Increment = 1,
    CurrentValue = 120,
    Callback = function(v) fovRadius = v end
})

-- ================== MACRO ==================
AimbotTab:CreateSection("MACRO")

AimbotTab:CreateToggle({
    Name = "ACTIVAR MACRO",
    Info = "Dispara con un solo toque.",
    CurrentValue = false,
    Callback = function(s) macroActivo = s end
})

AimbotTab:CreateSlider({
    Name = "DELAY AL EQUIPAR",
    Info = "Sube esto si la pistola no alcanza a salir.",
    Range = {0.01, 0.50},
    Increment = 0.01,
    CurrentValue = 0.04,
    Callback = function(v) macroEquipDelay = v end
})

AimbotTab:CreateSlider({
    Name = "DELAY DE DISPARO",
    Info = "Sube esto si el tiro no cuenta daño.",
    Range = {0.05, 0.80},
    Increment = 0.01,
    CurrentValue = 0.10,
    Callback = function(v) macroShootDelay = v end
})

AimbotTab:CreateToggle({
    Name = "MOSTRAR ZONA MUERTA",
    Info = "Para pantalla tactil",
    CurrentValue = false,
    Callback = function(s) deadZoneFrame.Visible = s end
})

-- ================== AUTO SHOOT ==================
AimbotTab:CreateSection("AUTO SHOOT")

local autoShootGunToggle = AimbotTab:CreateToggle({
    Name = "AUTO SHOOT (PISTOLA)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            getgenv().AutoShootKnifeEnabled = false
            pcall(function() 
                if autoShootKnifeToggle then autoShootKnifeToggle:Set(false) end 
            end)
        end
        getgenv().AutoShootGunEnabled = v
    end
})

local autoShootKnifeToggle = AimbotTab:CreateToggle({
    Name = "AUTO SHOOT (CUCHILLO)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            getgenv().AutoShootGunEnabled = false
            pcall(function() 
                if autoShootGunToggle then autoShootGunToggle:Set(false) end 
            end)
        end
        getgenv().AutoShootKnifeEnabled = v
    end
})

-- ================== HITBOX NORMAL (Visible) ==================
AimbotTab:CreateSection("HITBOX NORMAL (VISIBLE)")

AimbotTab:CreateToggle({
    Name = "ACTIVAR HITBOX NORMAL",
    CurrentValue = false,
    Callback = function(s)
        task.spawn(function()
            hitboxEnabled = s
            if not s and not hitboxInvisibleEnabled then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer then limpiarHitboxes(v) end
                end
            end
        end)
    end
})

AimbotTab:CreateSlider({
    Name = "TAMAÑO HITBOX NORMAL",
    Range = {2, 500},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(v) hitboxSize = v end
})

-- ================== HITBOX INVISIBLE (Solo expande - SIN NADA VISUAL) ==================
AimbotTab:CreateSection("HITBOX INVISIBLE (SOLO DAÑO)")

AimbotTab:CreateToggle({
    Name = "ACTIVAR HITBOX INVISIBLE",
    Info = "Expande la hitbox sin mostrar nada visual. SÍ cuenta el daño.",
    CurrentValue = false,
    Callback = function(s)
        task.spawn(function()
            hitboxInvisibleEnabled = s
            if not s and not hitboxEnabled then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer then limpiarHitboxes(v) end
                end
            end
        end)
    end
})

AimbotTab:CreateSlider({
    Name = "TAMAÑO HITBOX INVISIBLE",
    Info = "Solo expande la caja de colisión. No se ve nada.",
    Range = {2, 500},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(v) invisibleHitboxSize = v end
})

-- ================== ESP ==================
VisualesTab:CreateSection("ESP JUGADORES ENEMIGOS")

VisualesTab:CreateToggle({
    Name = "ACTIVAR ESP",
    Info = "Activa las líneas trazadoras hacia enemigos.",
    CurrentValue = false,
    Callback = function(s) espEnabled = s end
})

VisualesTab:CreateSection("LINEAS (TRACER LINES)")

VisualesTab:CreateColorPicker({
    Name = "COLOR DE LAS LINEAS",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(c) lineColor = c end
})

VisualesTab:CreateDropdown({
    Name = "POSICION DE LAS LINEAS",
    Options = {"ARRIBA", "MEDIO", "ABAJO"},
    CurrentOption = "ABAJO",
    Callback = function(s)
        linePosition = s[1]
    end
})

VisualesTab:CreateSlider({
    Name = "CANTIDAD DE LINEAS",
    Info = "Numero de enemigos con linea (1-10)",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(v) 
        MAX_LINES = v 
        showBottomMessage("Lineas: " .. v .. " enemigos")
    end
})

-- ================== KILL ALL ==================
local function esVulnerable(char)
    if not char then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Anchored then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed == 0 then return false end
    return true
end

local killAllRango = 1000
local killAllEnabled = false

AutoKillsTab:CreateToggle({
    Name = "ACTIVAR KILL ALL",
    CurrentValue = false,
    Callback = function(Value)
        killAllEnabled = Value
        if Value then
            task.spawn(function()
                while killAllEnabled do
                    local myChar = LocalPlayer.Character
                    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not LocalPlayer:FindFirstChild("Backpack") then
                        task.wait(0.5)
                        continue
                    end
                    if not estaEnLobby() and esVulnerable(myChar) then
                        local myHrp = myChar.HumanoidRootPart
                        local myHum = myChar:FindFirstChildOfClass("Humanoid")
                        if myHrp and myHum and myHum.Health > 0 then
                            local posicionOriginal = myHrp.CFrame
                            for _, p in ipairs(Players:GetPlayers()) do
                                if not killAllEnabled then break end
                                if p ~= LocalPlayer and isEnemy(p) and p.Character and esVulnerable(p.Character) then
                                    local enemyHum = p.Character:FindFirstChildOfClass("Humanoid")
                                    local enemyHrp = p.Character:FindFirstChild("HumanoidRootPart")
                                    if enemyHum and enemyHum.Health > 0 and enemyHrp then
                                        local distancia = (posicionOriginal.Position - enemyHrp.Position).Magnitude
                                        if distancia <= killAllRango then
                                            enemyHrp.Size = Vector3.new(30, 30, 30)
                                            enemyHrp.CanCollide = false
                                            local failSafe = 0
                                            while killAllEnabled and p and p.Parent and enemyHum and enemyHum.Parent and enemyHum.Health > 0 and failSafe < 300 do
                                                myHum.PlatformStand = true
                                                myHrp.CFrame = enemyHrp.CFrame * CFrame.new(0, -4, 0) * CFrame.Angles(math.rad(90), 0, 0)
                                                myHrp.AssemblyLinearVelocity = Vector3.zero
                                                pcall(function()
                                                    local arma = myChar:FindFirstChildOfClass("Tool")
                                                    if arma and esLaPistola(arma) then myHum:UnequipTools() arma = nil end
                                                    if not arma then
                                                        local bp = LocalPlayer:FindFirstChild("Backpack")
                                                        if bp then
                                                            for _, item in ipairs(bp:GetChildren()) do
                                                                if item:IsA("Tool") and not esLaPistola(item) then
                                                                    myHum:EquipTool(item)
                                                                    arma = item
                                                                    task.wait(0.1)
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if arma then arma:Activate() end
                                                end)
                                                task.wait(0.01)
                                                failSafe += 1
                                            end
                                            if myHum then myHum.PlatformStand = false end
                                            pcall(function() local w = myChar:FindFirstChildOfClass("Tool") if w then w:Deactivate() end end)
                                        end
                                    end
                                end
                            end
                            if killAllEnabled and myHrp then myHrp.CFrame = posicionOriginal task.wait(0.2) end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

AutoKillsTab:CreateSlider({
    Name = "RANGO DE KILL ALL",
    CurrentValue = 600,
    Range = {100, 1000},
    Increment = 50,
    Callback = function(v) killAllRango = v end
})

-- ================== AUTO FARM ==================
local AutoFarmEnabled = false

AutoFarmTab:CreateToggle({
    Name = "AUTO FARM",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmEnabled = Value
        if Value then
            task.spawn(function()
                while AutoFarmEnabled do
                    pcall(function()
                        local Event = ReplicatedStorage:FindFirstChild("Packages")
                        if Event then
                            Event = Event:FindFirstChild("Networking")
                            if Event then
                                Event = Event:FindFirstChild("RE/Events/CollectEventSpawnable")
                                if Event then Event:FireServer() end
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})

-- ================== ANIMACIONES ==================
local SelectedAnims = {
    idle1 = "2510196951",
    idle2 = "2510197257",
    walk  = "2510202577",
    run   = "2510198475",
    jump  = "2510197830",
    fall  = "2510195892"
}

local AnimList = {
    {Name="Astronaut", ids={idle1="891621366", idle2="891633237", walk="891667138", run="891636393", jump="891627522", fall="891617961"}},
    {Name="Bubbly", ids={idle1="910004836", idle2="910009958", walk="910034870", run="910025107", jump="910016857", fall="910001910"}},
    {Name="Cartoony", ids={idle1="742637544", idle2="742638445", walk="742640026", run="742638842", jump="742637942", fall="742637151"}},
    {Name="Elder", ids={idle1="845397899", idle2="845400520", walk="845403856", run="845386501", jump="845398858", fall="845396048"}},
    {Name="Knight", ids={idle1="657595757", idle2="657568135", walk="657552124", run="657564596", jump="658409194", fall="657600338"}},
    {Name="Levitation", ids={idle1="616006778", idle2="616008087", walk="616013216", run="616010382", jump="616008936", fall="616005863"}},
    {Name="Mage", ids={idle1="707742142", idle2="707855907", walk="707897309", run="707861613", jump="707853694", fall="707829716"}},
    {Name="Ninja", ids={idle1="656117400", idle2="656118341", walk="656121766", run="656118852", jump="656117878", fall="656115606"}},
    {Name="Pirate", ids={idle1="750781874", idle2="750782770", walk="750785693", run="750783738", jump="750782230", fall="750780242"}},
    {Name="Robot", ids={idle1="616088211", idle2="616089559", walk="616095330", run="616091570", jump="616090535", fall="616087089"}},
    {Name="Stylish", ids={idle1="616136790", idle2="616138447", walk="616146177", run="616140816", jump="616139451", fall="616134815"}},
    {Name="SuperHero", ids={idle1="616111295", idle2="616113536", walk="616122287", run="616117076", jump="616115533", fall="616108001"}},
    {Name="Toy", ids={idle1="782841498", idle2="782845736", walk="782843345", run="782842708", jump="782847020", fall="782846423"}},
    {Name="Vampire", ids={idle1="1083445855", idle2="1083450166", walk="1083473930", run="1083462077", jump="1083455352", fall="1083443587"}},
    {Name="Werewolf", ids={idle1="1083195517", idle2="1083214717", walk="1083178339", run="1083216690", jump="1083218792", fall="1083189019"}},
    {Name="Zombie", ids={idle1="616158929", idle2="616160636", walk="616168032", run="616163682", jump="616161997", fall="616157476"}},
    {Name="Predeterminada", ids={idle1="2510196951", idle2="2510197257", walk="2510202577", run="2510198475", jump="2510197830", fall="2510195892"}}
}

local AnimNames = {}
for _, v in ipairs(AnimList) do
    table.insert(AnimNames, v.Name)
end

local function getAnimIDs(styleName)
    for _, v in ipairs(AnimList) do
        if v.Name == styleName then
            return v.ids
        end
    end
    return nil
end

local function ApplyCombinedAnims()
    local char = LocalPlayer.Character 
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local Animate = char:FindFirstChild("Animate")
    if not Animate then return end
    
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
    
    local function setAnimId(parentName, childName, id)
        local parent = Animate:FindFirstChild(parentName)
        if parent then
            local child = parent:FindFirstChild(childName)
            if child and child:IsA("Animation") then
                child.AnimationId = "rbxassetid://" .. tostring(id)
            end
        end
    end
    
    setAnimId("idle", "Animation1", SelectedAnims.idle1)
    setAnimId("idle", "Animation2", SelectedAnims.idle2)
    setAnimId("walk", "WalkAnim", SelectedAnims.walk)
    setAnimId("run", "RunAnim", SelectedAnims.run)
    setAnimId("jump", "JumpAnim", SelectedAnims.jump)
    setAnimId("fall", "FallAnim", SelectedAnims.fall)
    
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

local function ResetToDefault()
    local default = getAnimIDs("Predeterminada")
    if default then
        SelectedAnims.idle1 = default.idle1
        SelectedAnims.idle2 = default.idle2
        SelectedAnims.walk = default.walk
        SelectedAnims.run = default.run
        SelectedAnims.jump = default.jump
        SelectedAnims.fall = default.fall
        ApplyCombinedAnims()
    end
end

AnimationsTab:CreateSection("SELECCIONAR ANIMACIÓN POR TIPO")

AnimationsTab:CreateDropdown({
    Name = "QUIETO 1 (Idle 1)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.idle1 = ids.idle1
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateDropdown({
    Name = "QUIETO 2 (Idle 2)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.idle2 = ids.idle2
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateDropdown({
    Name = "CAMINAR (Walk)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.walk = ids.walk
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateDropdown({
    Name = "CORRER (Run)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.run = ids.run
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateDropdown({
    Name = "SALTAR (Jump)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.jump = ids.jump
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateDropdown({
    Name = "CAER (Fall)",
    Options = AnimNames,
    CurrentOption = {"Predeterminada"},
    Callback = function(s)
        local ids = getAnimIDs(s[1])
        if ids then
            SelectedAnims.fall = ids.fall
            ApplyCombinedAnims()
        end
    end
})

AnimationsTab:CreateSection("ACCIONES RÁPIDAS")

AnimationsTab:CreateButton({
    Name = "RESTAURAR PREDETERMINADA",
    Callback = ResetToDefault
})

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    local a = c:WaitForChild("Animate", 5)
    if a then
        task.wait(0.3)
        ApplyCombinedAnims()
    end
end)

task.wait(1)
ApplyCombinedAnims()

-- ================== MOVIMIENTO ==================
MovementTab:CreateSection("MOVIMIENTO")
MovementTab:CreateLabel("Proximamente...")

-- ================== SETTINGS ==================
SettingsTab:CreateSection("REDES SOCIALES")

SettingsTab:CreateButton({
    Name = "COPY DISCORD",
    Info = "Copia el enlace de invitación de Discord",
    Callback = function()
        local clipboardSuccess, clipboardError = pcall(function()
            setclipboard("https://discord.gg/QzZdQQ5Vd")
        end)
        if clipboardSuccess then
            showBottomMessage("COPIADO CON EXITO")
        else
            showBottomMessage("Error al copiar: " .. tostring(clipboardError))
        end
    end
})

SettingsTab:CreateButton({
    Name = "COPY TIKTOK",
    Info = "Copia el nombre de usuario de TikTok",
    Callback = function()
        local clipboardSuccess, clipboardError = pcall(function()
            setclipboard("EL 01 ROX HUB🦈")
        end)
        if clipboardSuccess then
            showBottomMessage("USER COPIADO CON EXITO")
        else
            showBottomMessage("Error al copiar: " .. tostring(clipboardError))
        end
    end
})

-- ================== ENVIAR COMENTARIO O RESEÑA ==================
SettingsTab:CreateSection("ENVIAR COMENTARIO O RESEÑA")

local reviewText = ""
SettingsTab:CreateInput({
    Name = "ESCRIBE TU COMENTARIO",
    Info = "Deja tu opinión sobre el script o reporta un bug",
    PlaceholderText = "Escribe aquí tu comentario...",
    RemoveTextWhileFocus = false,
    Callback = function(text)
        reviewText = text
    end
})

SettingsTab:CreateButton({
    Name = "ENVIAR COMENTARIO",
    Info = "Envía tu comentario para mejorar el script",
    Callback = function()
        if reviewText == "" or reviewText == " " then
            showBottomMessage("Escribe un comentario primero")
            return
        end
        
        local webhookUrl = "https://discord.com/api/webhooks/1358780886143406100/oeCwq6a47mBmVEbFvdkI_BOlgIExRohPsyVAqYxGG4Rg43rKz5bGOeR8E6bOq2g6eB2t"
        
        local data = {
            username = "Duels Hub - Comentarios",
            avatar_url = "https://www.roblox.com/asset/?id=4483362458",
            embeds = {{
                title = "NUEVO COMENTARIO DE USUARIO",
                description = reviewText,
                color = 0x5865F2,
                fields = {
                    {
                        name = "Usuario",
                        value = LocalPlayer.Name,
                        inline = true
                    },
                    {
                        name = "Juego",
                        value = game.Name,
                        inline = true
                    },
                    {
                        name = "Fecha",
                        value = os.date("%d/%m/%Y %H:%M:%S"),
                        inline = false
                    }
                },
                footer = {
                    text = "Duels Hub V2 - Comentarios"
                }
            }}
        }
        
        local success, err = pcall(function()
            local req = request or http_request or (syn and syn.request)
            if req then
                req({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(data)
                })
                showBottomMessage("¡Comentario enviado con éxito!")
            else
                showBottomMessage("Tu ejecutor no soporta HTTP requests")
            end
        end)
        
        if not success then
            showBottomMessage("Error al enviar: " .. tostring(err))
        end
    end
})

-- ================== MODOS VISUALES ==================
SettingsTab:CreateSection("MODOS VISUALES")

-- TOKYOWAMI
SettingsTab:CreateToggle({
    Name = "SHADERS TOKYOWAMI",
    Info = "Aplica shaders originales de Tokyowami",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            if not Lighting:GetAttribute("OrigSaved") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness)
                Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom)
                Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top)
                Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient)
                Lighting:SetAttribute("OrigTime", Lighting.ClockTime)
                Lighting:SetAttribute("OrigFogC", Lighting.FogColor)
                Lighting:SetAttribute("OrigFogE", Lighting.FogEnd)
                Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation)
                Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness)
                Lighting:SetAttribute("OrigAmbient", Lighting.Ambient)
                Lighting:SetAttribute("OrigSaved", true)
            end

            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end
            table.clear(tokyowamiEffects)

            local Bloom = Instance.new("BloomEffect")
            Bloom.Intensity = 0.1
            Bloom.Threshold = 0
            Bloom.Size = 100
            Bloom.Parent = Lighting
            table.insert(tokyowamiEffects, Bloom)

            local Tropic = Instance.new("Sky")
            Tropic.Name = "Tropic"
            Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
            Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
            Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
            Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
            Tropic.StarCount = 100
            Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
            Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
            Tropic.Parent = Lighting
            table.insert(tokyowamiEffects, Tropic)

            local Sky = Instance.new("Sky")
            Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
            Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
            Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
            Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
            Sky.CelestialBodiesShown = false
            Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
            Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
            Sky.Parent = Lighting
            table.insert(tokyowamiEffects, Sky)

            local Blur = Instance.new("BlurEffect")
            Blur.Size = 2
            Blur.Parent = Lighting
            table.insert(tokyowamiEffects, Blur)

            local Inaritaisha = Instance.new("ColorCorrectionEffect")
            Inaritaisha.Name = "Inari taisha"
            Inaritaisha.Saturation = 0.05
            Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219)
            Inaritaisha.Parent = Lighting
            table.insert(tokyowamiEffects, Inaritaisha)

            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Intensity = 0.05
            SunRays.Parent = Lighting
            table.insert(tokyowamiEffects, SunRays)

            local Sunset = Instance.new("Sky")
            Sunset.Name = "Sunset"
            Sunset.SkyboxUp = "rbxassetid://323493360"
            Sunset.SkyboxLf = "rbxassetid://323494252"
            Sunset.SkyboxBk = "rbxassetid://323494035"
            Sunset.SkyboxFt = "rbxassetid://323494130"
            Sunset.SkyboxDn = "rbxassetid://323494368"
            Sunset.SunAngularSize = 14
            Sunset.SkyboxRt = "rbxassetid://323494067"
            Sunset.Parent = Lighting
            table.insert(tokyowamiEffects, Sunset)

            Lighting.Brightness = 2.14
            Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
            Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
            Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
            Lighting.ClockTime = 6.7
            Lighting.FogColor = Color3.fromRGB(94, 76, 106)
            Lighting.FogEnd = 1000
            Lighting.ExposureCompensation = 0.24
            Lighting.ShadowSoftness = 0
            Lighting.Ambient = Color3.fromRGB(59, 33, 27)
            showBottomMessage("Tokyowami: ON")
        else
            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end
            table.clear(tokyowamiEffects)
            if Lighting:GetAttribute("OrigSaved") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright")
                Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB")
                Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST")
                Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA")
                Lighting.ClockTime = Lighting:GetAttribute("OrigTime")
                Lighting.FogColor = Lighting:GetAttribute("OrigFogC")
                Lighting.FogEnd = Lighting:GetAttribute("OrigFogE")
                Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp")
                Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow")
                Lighting.Ambient = Lighting:GetAttribute("OrigAmbient")
            end
            showBottomMessage("Tokyowami: OFF")
        end
    end
})

-- MODO NOCHE
SettingsTab:CreateToggle({
    Name = "MODO NOCHE",
    Info = "Activa el modo noche con efectos ajustables",
    CurrentValue = false,
    Callback = function(Value)
        local Terrain = Workspace:FindFirstChildOfClass("Terrain")
        nightActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedNight") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness)
                Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom)
                Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top)
                Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient)
                Lighting:SetAttribute("OrigTime", Lighting.ClockTime)
                Lighting:SetAttribute("OrigFogC", Lighting.FogColor)
                Lighting:SetAttribute("OrigFogE", Lighting.FogEnd)
                Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation)
                Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness)
                Lighting:SetAttribute("OrigAmbient", Lighting.Ambient)
                Lighting:SetAttribute("OrigSpec", Lighting.EnvironmentSpecularScale)
                Lighting:SetAttribute("OrigDiff", Lighting.EnvironmentDiffuseScale)
                Lighting:SetAttribute("OrigGlobalS", Lighting.GlobalShadows)
                Lighting:SetAttribute("OrigGeo", Lighting.GeographicLatitude)
                Lighting:SetAttribute("OrigSavedNight", true)
            end

            ToggleNubesYAtmo(true, "Night")
            
            if Terrain and not Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain:SetAttribute("OrigWaveSize", Terrain.WaterWaveSize)
                Terrain:SetAttribute("OrigWaveSpeed", Terrain.WaterWaveSpeed)
                Terrain:SetAttribute("OrigReflectance", Terrain.WaterReflectance)
                Terrain:SetAttribute("OrigTransparency", Terrain.WaterTransparency)
                Terrain:SetAttribute("OrigWaterColor", Terrain.WaterColor)
                Terrain:SetAttribute("OrigWaterSavedNight", true)
            end

            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end
            table.clear(nightEffects)

            local blur = Instance.new("BlurEffect")
            blur.Size = shaderAjustes.Desenfoque
            blur.Parent = Lighting
            table.insert(nightEffects, blur)

            local bloom = Instance.new("BloomEffect")
            bloom.Intensity = shaderAjustes.Neon
            bloom.Size = 40
            bloom.Threshold = 0.2
            bloom.Parent = Lighting
            table.insert(nightEffects, bloom)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Brightness = 0.02
            cc.Contrast = 0.15
            cc.Saturation = shaderAjustes.ColorSaturacion
            cc.TintColor = Color3.fromRGB(210, 225, 255)
            cc.Parent = Lighting
            table.insert(nightEffects, cc)

            local moonRays = Instance.new("SunRaysEffect")
            moonRays.Intensity = 0.15
            moonRays.Spread = 0.75
            moonRays.Parent = Lighting
            table.insert(nightEffects, moonRays)

            local Tropic = Instance.new("Sky")
            Tropic.Name = "OnyxTokyowamiNight"
            Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
            Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
            Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
            Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
            Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
            Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
            Tropic.StarCount = 5000
            Tropic.MoonAngularSize = 18
            Tropic.Parent = Lighting
            table.insert(nightEffects, Tropic)

            Lighting.ClockTime = 0
            Lighting.Brightness = 4
            Lighting.EnvironmentSpecularScale = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = shaderAjustes.LunaPos
            Lighting.ShadowSoftness = shaderAjustes.SuavidadSombras
            Lighting.ExposureCompensation = shaderAjustes.Exposicion
            Lighting.OutdoorAmbient = Color3.fromRGB(50, 65, 95)
            local s = shaderAjustes.Sombras
            Lighting.Ambient = Color3.fromRGB(s, s + 3, s + 10)
            Lighting.ColorShift_Bottom = Color3.fromRGB(25, 40, 60)
            Lighting.ColorShift_Top = Color3.fromRGB(160, 180, 240)
            Lighting.FogColor = Color3.fromRGB(15, 20, 30)
            Lighting.FogEnd = 2500

            if Terrain then
                Terrain.WaterWaveSize = 0.12
                Terrain.WaterWaveSpeed = 8
                Terrain.WaterReflectance = 1
                Terrain.WaterTransparency = 0.85
                Terrain.WaterColor = Color3.fromRGB(15, 25, 45)
            end
            showBottomMessage("Noche: ON")
        else
            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end
            table.clear(nightEffects)
            if Lighting:GetAttribute("OrigSavedNight") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright")
                Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB")
                Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST")
                Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA")
                Lighting.ClockTime = Lighting:GetAttribute("OrigTime")
                Lighting.FogColor = Lighting:GetAttribute("OrigFogC")
                Lighting.FogEnd = Lighting:GetAttribute("OrigFogE")
                Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp")
                Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow")
                Lighting.Ambient = Lighting:GetAttribute("OrigAmbient")
                Lighting.GlobalShadows = Lighting:GetAttribute("OrigGlobalS")
                if Lighting:GetAttribute("OrigGeo") then Lighting.GeographicLatitude = Lighting:GetAttribute("OrigGeo") end
                if Lighting:GetAttribute("OrigSpec") then Lighting.EnvironmentSpecularScale = Lighting:GetAttribute("OrigSpec") Lighting.EnvironmentDiffuseScale = Lighting:GetAttribute("OrigDiff") end
            end
            ToggleNubesYAtmo(false, "Night")
            if Terrain and Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain.WaterWaveSize = Terrain:GetAttribute("OrigWaveSize")
                Terrain.WaterWaveSpeed = Terrain:GetAttribute("OrigWaveSpeed")
                Terrain.WaterReflectance = Terrain:GetAttribute("OrigReflectance")
                Terrain.WaterTransparency = Terrain:GetAttribute("OrigTransparency")
                Terrain.WaterColor = Terrain:GetAttribute("OrigWaterColor")
            end
            showBottomMessage("Noche: OFF")
        end
    end
})

-- PINK HOUR
SettingsTab:CreateToggle({
    Name = "PINK HOUR",
    Info = "Estilo Synthwave con tonos rosas y morados",
    CurrentValue = false,
    Callback = function(Value)
        pinkActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedPink") then
                Lighting:SetAttribute("OrigBrightP", Lighting.Brightness)
                Lighting:SetAttribute("OrigCSBP", Lighting.ColorShift_Bottom)
                Lighting:SetAttribute("OrigCSTP", Lighting.ColorShift_Top)
                Lighting:SetAttribute("OrigOAP", Lighting.OutdoorAmbient)
                Lighting:SetAttribute("OrigTimeP", Lighting.ClockTime)
                Lighting:SetAttribute("OrigFogCP", Lighting.FogColor)
                Lighting:SetAttribute("OrigFogEP", Lighting.FogEnd)
                Lighting:SetAttribute("OrigAmbientP", Lighting.Ambient)
                Lighting:SetAttribute("OrigExpP", Lighting.ExposureCompensation)
                Lighting:SetAttribute("OrigShadowP", Lighting.ShadowSoftness)
                Lighting:SetAttribute("OrigSavedPink", true)
            end
            
            ToggleNubesYAtmo(true, "Pink")

            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end
            table.clear(pinkEffects)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Parent = Lighting
            table.insert(pinkEffects, cc)

            local bloom = Instance.new("BloomEffect")
            bloom.Size = 25
            bloom.Threshold = 0.85
            bloom.Parent = Lighting
            table.insert(pinkEffects, bloom)

            local blur = Instance.new("BlurEffect")
            blur.Size = 2
            blur.Parent = Lighting
            table.insert(pinkEffects, blur)

            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Intensity = 0.08
            sunRays.Spread = 0.8
            sunRays.Parent = Lighting
            table.insert(pinkEffects, sunRays)

            local sky = Instance.new("Sky")
            sky.Name = "AstraPinkSky"
            sky.SkyboxUp = "rbxassetid://323493360"
            sky.SkyboxLf = "rbxassetid://323494252"
            sky.SkyboxBk = "rbxassetid://323494035"
            sky.SkyboxFt = "rbxassetid://323494130"
            sky.SkyboxDn = "rbxassetid://323494368"
            sky.SkyboxRt = "rbxassetid://323494067"
            sky.SunAngularSize = 14
            sky.StarCount = 3000
            sky.Parent = Lighting
            table.insert(pinkEffects, sky)
            
            Lighting.Brightness = 2.0
            Lighting.ClockTime = 6.7
            Lighting.FogColor = Color3.fromRGB(120, 20, 150)
            Lighting.FogEnd = 1200
            Lighting.ShadowSoftness = 0.2
            
            UpdatePinkHourVibe()
            showBottomMessage("Pink Hour: ON")
        else
            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end
            table.clear(pinkEffects)
            if Lighting:GetAttribute("OrigSavedPink") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBrightP")
                Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSBP")
                Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCSTP")
                Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOAP")
                Lighting.ClockTime = Lighting:GetAttribute("OrigTimeP")
                Lighting.FogColor = Lighting:GetAttribute("OrigFogCP")
                Lighting.FogEnd = Lighting:GetAttribute("OrigFogEP")
                Lighting.Ambient = Lighting:GetAttribute("OrigAmbientP")
                Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExpP")
                Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadowP")
            end
            ToggleNubesYAtmo(false, "Pink")
            showBottomMessage("Pink Hour: OFF")
        end
    end
})

-- ================== AJUSTES DE GRÁFICOS ==================
SettingsTab:CreateSection("AJUSTES DE GRÁFICOS")

SettingsTab:CreateSlider({
    Name = "CLARIDAD DEL MAPA (Noche)",
    Info = "Afecta solo al Modo Noche. Úsalo si está muy oscuro.",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.28,
    Callback = function(v)
        shaderAjustes.Exposicion = v
        if nightActivo then Lighting.ExposureCompensation = v end
    end
})

SettingsTab:CreateSlider({
    Name = "PROFUNDIDAD DE SOMBRAS (Noche)",
    Info = "0 = Oscuridad total. 50 = Sombra suave y clara.",
    Range = {0, 50},
    Increment = 5,
    CurrentValue = 5,
    Callback = function(v)
        shaderAjustes.Sombras = v
        if nightActivo then Lighting.Ambient = Color3.fromRGB(v, v + 3, v + 10) end
    end
})

SettingsTab:CreateSlider({
    Name = "RESPLANDOR (Noche)",
    Info = "Ajusta qué tanto brillan las armas y las luces del mapa.",
    Range = {0.1, 1.0},
    Increment = 0.05,
    CurrentValue = 0.45,
    Callback = function(v)
        shaderAjustes.Neon = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})

SettingsTab:CreateSlider({
    Name = "FONDO BORROSO (Noche)",
    Info = "0 = Sin borrosidad. Añade un efecto de cámara cinematográfica.",
    Range = {0, 10},
    Increment = 0.5,
    CurrentValue = 2,
    Callback = function(v)
        shaderAjustes.Desenfoque = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BlurEffect") then effect.Size = v end
            end
        end
    end
})

SettingsTab:CreateSlider({
    Name = "POSICIÓN DE LA LUNA (Noche)",
    Info = "Mueve la luna en el cielo.",
    Range = {0, 360},
    Increment = 5,
    CurrentValue = 85,
    Callback = function(v)
        shaderAjustes.LunaPos = v
        if nightActivo then Lighting.GeographicLatitude = v end
    end
})

SettingsTab:CreateSection("AJUSTES PINK HOUR")

SettingsTab:CreateSlider({
    Name = "INTENSIDAD DEL MORADO",
    Info = "Añade oscuridad y tonos violetas al cielo y al mapa.",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.7,
    Callback = function(v)
        shaderAjustes.PinkMorado = v
        UpdatePinkHourVibe()
    end
})

SettingsTab:CreateSlider({
    Name = "INTENSIDAD DEL ROSA",
    Info = "Agrega tonos magentas y rosas a las luces.",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.8,
    Callback = function(v)
        shaderAjustes.PinkRosa = v
        UpdatePinkHourVibe()
    end
})

SettingsTab:CreateSlider({
    Name = "SATURACIÓN DE COLOR",
    Info = "0 = Grisáceo y apagado. 1 = Colores fluorescentes.",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.4,
    Callback = function(v)
        shaderAjustes.PinkSaturacion = v
        UpdatePinkHourVibe()
    end
})

SettingsTab:CreateSlider({
    Name = "RESPLANDOR (Pink Hour)",
    Info = "Haz que el cielo y los neones brillen mas.",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.3,
    Callback = function(v)
        shaderAjustes.PinkNeon = v
        if pinkActivo then
            for _, effect in ipairs(pinkEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})

-- ================== TEMAS (Al final de SETTINGS) ==================
SettingsTab:CreateSection("TEMAS DE INTERFAZ")

local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "ELEGIR TEMA",
    Options = {
        "Default",
        "AmberGlow",
        "Amethyst",
        "Bloom",
        "DarkBlue",
        "Green",
        "Light",
        "Ocean",
        "Serenity"
    },
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "ThemeSelector",
    Callback = function(Option)
        Window.ModifyTheme(Option[1])
        Rayfield:Notify({
            Title = "Tema Cambiado",
            Content = "Se aplicó el tema: " .. Option[1],
            Duration = 3
        })
    end,
})

-- ================== SPOOF NAME ==================
local player = game.Players.LocalPlayer
local spoofNameText = '<font color="#00BFFF">[MOD]</font> <font color="#FFFFFF">EL 01 ROX HUB</font>'
local originalData = {}
local isWorkspaceLooping = false
local visualConnections = {}

local function safeReplace(str, find, replace)
    local safeFind = find:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1")
    return (str:gsub(safeFind, replace))
end

local function processText(v, myName, myDisp)
    local parentGui = v:FindFirstAncestorWhichIsA("ScreenGui")
    if parentGui and (string.find(parentGui.Name, "WindUI") or string.find(parentGui.Name, "01ROXHUB")) then return end
    
    if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
        local txt = v.Text
        local hasName = false
        
        if txt and txt ~= "" then
            if string.find(txt, myName, 1, true) or string.find(txt, myDisp, 1, true) then
                hasName = true
            end
        end
        
        if hasName then
            v.RichText = true
            local newText = safeReplace(v.Text, myName, spoofNameText)
            newText = safeReplace(newText, myDisp, spoofNameText)
            v.Text = newText
        end
    end
end

-- Escanear GUI existente
task.spawn(function()
    local myName = player.Name
    local myDisp = player.DisplayName
    
    while task.wait(3) do
        pcall(function()
            for _, gui in ipairs(game:GetDescendants()) do
                if gui:IsA("TextLabel") or gui:IsA("TextBox") or gui:IsA("TextButton") then
                    local txt = gui.Text
                    if txt and txt ~= "" then
                        if string.find(txt, myName, 1, true) or string.find(txt, myDisp, 1, true) then
                            processText(gui, myName, myDisp)
                        end
                    end
                end
            end
        end)
    end
end)
