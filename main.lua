local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- IDs de música - AGREGUÉ LA NUEVA
local musicIDs = {
	"rbxassetid://107382726709308",
	"rbxassetid://140263092143532", 
	"rbxassetid://139223724536054",
	"rbxassetid://114607540355383",
	"rbxassetid://104432262795616",
	"rbxassetid://80089119005067" -- Tu música nueva
}

-- LOS 3 SKIES QUE QUEDARON
local skyIDs = {
	["Sky 1"] = "125827537017339",
	["Sky 2"] = "71683904817100", 
	["Sky 3"] = "116276153232780"
}

-- GUI PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EL01ROXHUB"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- BOTÓN REDONDO ARRASTRABLE
local roundButton = Instance.new("ImageButton")
roundButton.Name = "RoundButton"
roundButton.Size = UDim2.new(0, 60, 0, 60)
roundButton.Position = UDim2.new(0, 30, 0.5, -30)
roundButton.BackgroundTransparency = 1
roundButton.Image = "rbxassetid://116276153232780"
roundButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = roundButton

-- MENÚ PRINCIPAL ARRASTRABLE
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Size = UDim2.new(0, 220, 0, 480) -- Más alto pa la música nueva
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Variables para minimizar
local isMinimized = false
local normalSize = UDim2.new(0, 220, 0, 480)
local miniSize = UDim2.new(0, 220, 0, 35)

-- SCROLLING FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 520) -- Más grande pa la música nueva
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
scrollFrame.Parent = mainFrame

-- TÍTULO DEL MENÚ CON RAINBOW
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 35)
titleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleFrame.BackgroundTransparency = 0.3
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleFrame

-- TEXTO RAINBOW
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "EL 01 ROX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleFrame

-- BOTÓN MINIMIZAR/MAXIMIZAR
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -64, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
minimizeBtn.BackgroundTransparency = 0.2
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleFrame

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 6)
miniCorner.Parent = minimizeBtn

-- BOTÓN X ROJA PARA CERRAR
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundTransparency = 0.2
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- EFECTO RAINBOW PARA EL TÍTULO
spawn(function()
	while wait(0.1) do
		if not title or not title.Parent then break end
		local hue = tick() % 5 / 5
		title.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

-- FUNCIÓN DE MINIMIZAR/MAXIMIZAR
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = miniSize}):Play()
		scrollFrame.Visible = false
		minimizeBtn.Text = "+"
	else
		TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = normalSize}):Play()
		wait(0.3)
		scrollFrame.Visible = true
		minimizeBtn.Text = "–"
	end
end)

-- FUNCIÓN DE CERRAR CON LA X
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- MÚSICA
local musicLabel = Instance.new("TextLabel")
musicLabel.Size = UDim2.new(1, -16, 0, 20)
musicLabel.Position = UDim2.new(0, 8, 0, 8)
musicLabel.BackgroundTransparency = 1
musicLabel.Text = "Música: [6]"
musicLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
musicLabel.TextSize = 14
musicLabel.Font = Enum.Font.GothamBold
musicLabel.TextXAlignment = Enum.TextXAlignment.Left
musicLabel.Parent = scrollFrame

local currentSound = nil
for i, id in ipairs(musicIDs) do
	local musicBtn = Instance.new("TextButton")
	musicBtn.Size = UDim2.new(1, -16, 0, 28)
	musicBtn.Position = UDim2.new(0, 8, 0, 30 + (i-1)*32)
	musicBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	musicBtn.BackgroundTransparency = 0.3
	musicBtn.BorderSizePixel = 0
	musicBtn.Text = "Sound ".. i
	musicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	musicBtn.TextSize = 13
	musicBtn.Font = Enum.Font.Gotham
	musicBtn.Parent = scrollFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = musicBtn
	
	musicBtn.MouseButton1Click:Connect(function()
		if currentSound then currentSound:Destroy() end
		currentSound = Instance.new("Sound")
		currentSound.SoundId = id
		currentSound.Volume = 5
		currentSound.Looped = true
		currentSound.Parent = SoundService
		currentSound:Play()
		
		TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
		wait(0.1)
		TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
end

-- SECCIÓN DE SKY
local skyLabel = Instance.new("TextLabel")
skyLabel.Size = UDim2.new(1, -16, 0, 20)
skyLabel.Position = UDim2.new(0, 8, 0, 225) -- Ajustado pa la música nueva
skyLabel.BackgroundTransparency = 1
skyLabel.Text = "Skybox: [3]"
skyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
skyLabel.TextSize = 14
skyLabel.Font = Enum.Font.GothamBold
skyLabel.TextXAlignment = Enum.TextXAlignment.Left
skyLabel.Parent = scrollFrame

-- Botones de Sky
local skyYPos = 250
for name, id in pairs(skyIDs) do
	local skyBtn = Instance.new("TextButton")
	skyBtn.Size = UDim2.new(1, -16, 0, 28)
	skyBtn.Position = UDim2.new(0, 8, 0, skyYPos)
	skyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
	skyBtn.BackgroundTransparency = 0.3
	skyBtn.BorderSizePixel = 0
	skyBtn.Text = name
	skyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	skyBtn.TextSize = 13
	skyBtn.Font = Enum.Font.GothamBold
	skyBtn.Parent = scrollFrame
	
	local skyBtnCorner = Instance.new("UICorner")
	skyBtnCorner.CornerRadius = UDim.new(0, 6)
	skyBtnCorner.Parent = skyBtn
	
	skyBtn.MouseButton1Click:Connect(function()
		for _, v in pairs(Lighting:GetChildren()) do
			if v:IsA("Sky") then v:Destroy() end
		end
		local newSky = Instance.new("Sky")
		newSky.Parent = Lighting
		for _, face in pairs({'Bk','Dn','Ft','Lf','Rt','Up'}) do
			newSky['Skybox'..face] = 'rbxassetid://'..id
		end
		
		TweenService:Create(skyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 120)}):Play()
		wait(0.1)
		TweenService:Create(skyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 100, 180)}):Play()
	end)
	
	skyYPos = skyYPos + 32
end

-- BOTÓN QUITAR SKY
local removeSkyBtn = Instance.new("TextButton")
removeSkyBtn.Size = UDim2.new(1, -16, 0, 32)
removeSkyBtn.Position = UDim2.new(0, 8, 0, skyYPos + 8)
removeSkyBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 0)
removeSkyBtn.BackgroundTransparency = 0.3
removeSkyBtn.BorderSizePixel = 0
removeSkyBtn.Text = "Quitar Sky"
removeSkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
removeSkyBtn.TextSize = 13
removeSkyBtn.Font = Enum.Font.GothamBold
removeSkyBtn.Parent = scrollFrame

local removeSkyCorner = Instance.new("UICorner")
removeSkyCorner.CornerRadius = UDim.new(0, 6)
removeSkyCorner.Parent = removeSkyBtn

removeSkyBtn.MouseButton1Click:Connect(function()
	for _, v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then v:Destroy() end
	end
	TweenService:Create(removeSkyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 130, 0)}):Play()
	wait(0.1)
	TweenService:Create(removeSkyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 80, 0)}):Play()
end)

-- BOTÓN PARAR MÚSICA
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -16, 0, 32)
stopBtn.Position = UDim2.new(0, 8, 0, skyYPos + 48)
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopBtn.BackgroundTransparency = 0.3
stopBtn.BorderSizePixel = 0
stopBtn.Text = "Parar Música"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 13
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = scrollFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

stopBtn.MouseButton1Click:Connect(function()
	if currentSound then 
		currentSound:Stop()
		currentSound:Destroy()
		currentSound = nil
	end
end)

-- SECCIÓN DE CRÉDITOS
local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(1, -16, 0, 60)
creditFrame.Position = UDim2.new(0, 8, 0, skyYPos + 95)
creditFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
creditFrame.BackgroundTransparency = 0.3
creditFrame.BorderSizePixel = 0
creditFrame.Parent = scrollFrame

local creditCorner = Instance.new("UICorner")
creditCorner.CornerRadius = UDim.new(0, 8)
creditCorner.Parent = creditFrame

-- Texto "Crédito"
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 18)
creditLabel.Position = UDim2.new(0, 0, 0, 2)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Crédito"
creditLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditLabel.TextSize = 11
creditLabel.Font = Enum.Font.Gotham
creditLabel.Parent = creditFrame

-- Foto redonda
local profilePic = Instance.new("ImageLabel")
profilePic.Size = UDim2.new(0, 35, 0, 35)
profilePic.Position = UDim2.new(0, 8, 0, 20)
profilePic.BackgroundTransparency = 1
profilePic.Image = "rbxassetid://116276153232780"
profilePic.Parent = creditFrame

local picCorner = Instance.new("UICorner")
picCorner.CornerRadius = UDim.new(1, 0)
picCorner.Parent = profilePic

-- Nombre EL 01 HUB
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -50, 0, 16)
nameLabel.Position = UDim2.new(0, 48, 0, 20)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "EL 01 HUB"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 13
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = creditFrame

-- TikTok
local tiktokLabel = Instance.new("TextLabel")
tiktokLabel.Size = UDim2.new(1, -50, 0, 14)
tiktokLabel.Position = UDim2.new(0, 48, 0, 36)
tiktokLabel.BackgroundTransparency = 1
tiktokLabel.Text = "TikTok: wxrkbrxz"
tiktokLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
tiktokLabel.TextSize = 11
tiktokLabel.Font = Enum.Font.Gotham
tiktokLabel.TextXAlignment = Enum.TextXAlignment.Left
tiktokLabel.Parent = creditFrame

-- FUNCIONES DE ARRASTRE
roundButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Arrastrar botón redondo
local dragging, dragInput, dragStart, startPos
roundButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = roundButton.Position
	end
end)

roundButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		roundButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Arrastrar menú
local draggingMenu, dragInputMenu, dragStartMenu, startPosMenu
titleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMenu = true
		dragStartMenu = input.Position
		startPosMenu = mainFrame.Position
	end
end)

titleFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputMenu = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInputMenu and draggingMenu then
		local delta = input.Position - dragStartMenu
		mainFrame.Position = UDim2.new(startPosMenu.X.Scale, startPosMenu.X.Offset + delta.X, startPosMenu.Y.Scale, startPosMenu.Y.Offset + delta.Y)
	end
end)
