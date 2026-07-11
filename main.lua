local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// INTRO LOADING CON PARTÍCULAS Y MÚSICA \\--
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "IntroLoading"
IntroGui.ResetOnSpawn = false
IntroGui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BorderSizePixel = 0
Background.Parent = IntroGui

-- MÚSICA DE INTRO
task.spawn(function()
    local url = "https://www.image2url.com/r2/default/audio/1783635121087-4fc6d640-7dee-449b-9819-af5c7d87086f.mp3"
    local fileName = "intro_musica.mp3"

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        writefile(fileName, response)
        local assetPath = getcustomasset(fileName)

        local sound = Instance.new("Sound")
        sound.SoundId = assetPath
        sound.Volume = 2
        sound.Looped = true
        sound.Parent = workspace.CurrentCamera

        task.wait(1)
        sound:Play()

        -- Parar música cuando termine la intro
        task.wait(23)
        sound:Stop()
        sound:Destroy()
    else
        warn("Error al descargar música: ".. tostring(response))
    end
end)

-- PARTÍCULAS
local ParticlesFolder = Instance.new("Folder", Background)

for i = 1, 40 do
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
	dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
	dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
	dot.BorderSizePixel = 0
	dot.BackgroundTransparency = math.random(20,60)/100
	dot.Parent = ParticlesFolder

	local corner = Instance.new("UICorner", dot)
	corner.CornerRadius = UDim.new(1,0)

	task.spawn(function()
		while dot.Parent do
			local newPos = UDim2.new(math.random(), 0, math.random(), 0)
			local tween = TweenService:Create(dot, TweenInfo.new(math.random(4,8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = newPos
			})
			tween:Play()
			tween.Completed:Wait()
		end
	end)
end

-- LOGO (AÚN MÁS ARRIBA)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0,160,0,160)
Logo.Position = UDim2.new(0.5,-80,0.40,-80)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://112454650572091"
Logo.Parent = Background

-- BARRA
local BarBG = Instance.new("Frame")
BarBG.Size = UDim2.new(0,300,0,5)
BarBG.Position = UDim2.new(0.5,-150,0.7,0)
BarBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
BarBG.BorderSizePixel = 0
BarBG.Parent = Background

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
Bar.BorderSizePixel = 0
Bar.Parent = BarBG

local tween = TweenService:Create(Bar, TweenInfo.new(23, Enum.EasingStyle.Linear), { -- 23 SEGUNDOS
	Size = UDim2.new(1,0,1,0)
})
tween:Play()
tween.Completed:Wait()

-- FADE
local fade = TweenService:Create(Background, TweenInfo.new(0.5), {
	BackgroundTransparency = 1
})
fade:Play()
fade.Completed:Wait()

IntroGui:Destroy()

--// SISTEMA DE KEY CON BAN FALSO \\--
local KeySystem = Instance.new("ScreenGui")
KeySystem.Name = "KeySystem"
KeySystem.ResetOnSpawn = false
KeySystem.Parent = PlayerGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, 0, 1, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyFrame.BackgroundTransparency = 1
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeySystem

local KeyBox = Instance.new("Frame")
KeyBox.Size = UDim2.new(0, 350, 0, 200)
KeyBox.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyBox.BorderSizePixel = 0
KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "EL 01 ROX HUB | KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyBox

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 70)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyInput.BorderSizePixel = 0
KeyInput.PlaceholderText = "Ingresa tu KEY..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyBox

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(1, -40, 0, 40)
CheckKeyBtn.Position = UDim2.new(0, 20, 0, 130)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CheckKeyBtn.BorderSizePixel = 0
CheckKeyBtn.Text = "Llave Verificar"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.TextSize = 14
CheckKeyBtn.Font = Enum.Font.GothamBold
CheckKeyBtn.Parent = KeyBox

local CheckKeyCorner = Instance.new("UICorner")
CheckKeyCorner.CornerRadius = UDim.new(0, 6)
CheckKeyCorner.Parent = CheckKeyBtn

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, -40, 0, 20)
KeyStatus.Position = UDim2.new(0, 20, 0, 175)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
KeyStatus.TextSize = 12
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.Parent = KeyBox

local BanScreen = Instance.new("Frame")
BanScreen.Size = UDim2.new(1, 0, 1, 0)
BanScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BanScreen.BorderSizePixel = 0
BanScreen.Visible = false
BanScreen.ZIndex = 10
BanScreen.Parent = KeySystem

local BanTitle = Instance.new("TextLabel")
BanTitle.Size = UDim2.new(1, 0, 0, 60)
BanTitle.Position = UDim2.new(0, 0, 0.35, 0)
BanTitle.BackgroundTransparency = 1
BanTitle.Text = "KEY INCORRECTA"
BanTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
BanTitle.TextSize = 32
BanTitle.Font = Enum.Font.GothamBold
BanTitle.ZIndex = 11
BanTitle.Parent = BanScreen

local BanReason = Instance.new("TextLabel")
BanReason.Size = UDim2.new(1, -40, 0, 60)
BanReason.Position = UDim2.new(0, 20, 0.48, 0)
BanReason.BackgroundTransparency = 1
BanReason.Text = "EL 01 ROX HUB TE EXPULSÓ\n\nSerás expulsado en 3 segundos..."
BanReason.TextColor3 = Color3.fromRGB(255, 255, 255)
BanReason.TextSize = 18
BanReason.Font = Enum.Font.Gotham
BanReason.TextWrapped = true
BanReason.ZIndex = 11
BanReason.Parent = BanScreen

CheckKeyBtn.MouseButton1Click:Connect(function()
	if KeyInput.Text == "EL 01-HR820LQ82" then -- Key cambiada bro
		KeyStatus.Text = "Key Correcta! Cargando..."
		KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
		wait(1)
		
		local tween = TweenService:Create(KeyFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
		tween:Play()
		tween.Completed:Connect(function()
			KeySystem:Destroy()
			LoadHub()
		end)
	else
		KeyBox.Visible = false
		BanScreen.Visible = true
		
		wait(3)
		Player:Kick("KEY INCORRECTA\nEL 01 ROX HUB TE EXPULSÓ")
	end
end)

--// CARGAR HUB \\--
function LoadHub()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "EL01ROXHub"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local MainButton = Instance.new("ImageButton")
	MainButton.Name = "MainButton"
	MainButton.Size = UDim2.new(0, 45, 0, 45)
	MainButton.Position = UDim2.new(0, 15, 0.28, 0)
	MainButton.BackgroundTransparency = 1
	MainButton.BorderSizePixel = 0
	MainButton.Image = "rbxassetid://120746982271111"
	MainButton.ScaleType = Enum.ScaleType.Fit
	MainButton.Active = true
	MainButton.Draggable = true
	MainButton.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainButton

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 550, 0, 320)
	MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = false
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

	local ParticleHolder = Instance.new("Frame")
	ParticleHolder.Size = UDim2.new(1, 0, 1, 0)
	ParticleHolder.BackgroundTransparency = 1
	ParticleHolder.BorderSizePixel = 0
	ParticleHolder.ZIndex = 0
	ParticleHolder.Parent = MainFrame

	local function CreateParticle()
		local particle = Instance.new("Frame")
		local size = math.random(1, 3)
		particle.Size = UDim2.new(0, size, 0, size)
		particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
		particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		particle.BackgroundTransparency = math.random(40, 70) / 100
		particle.BorderSizePixel = 0
		particle.ZIndex = 0
		particle.Parent = ParticleHolder

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = particle

		spawn(function()
			local speed = math.random(15, 35) / 1000
			while particle.Parent do
				particle.Position = particle.Position + UDim2.new(0, 0, speed, 0)
				if particle.Position.Y.Scale > 1 then
					particle.Position = UDim2.new(math.random(), 0, -0.05, 0)
				end
				RunService.Heartbeat:Wait()
			end
		end)
	end

	for i = 1, 100 do
		CreateParticle()
	end

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
	TopBar.BorderSizePixel = 0
	TopBar.ZIndex = 2
	TopBar.Parent = MainFrame

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 8)
	TopCorner.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "Murder Mystery 2 | FREE V1"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 3
	Title.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -32, 0, 2)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 18
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.ZIndex = 3
	CloseBtn.Parent = TopBar

	local SideMenu = Instance.new("ScrollingFrame")
	SideMenu.Size = UDim2.new(0, 140, 1, -35)
	SideMenu.Position = UDim2.new(0, 0, 0, 35)
	SideMenu.BackgroundColor3 = Color3.fromRGB(18, 23, 35)
	SideMenu.BorderSizePixel = 0
	SideMenu.ScrollBarThickness = 2
	SideMenu.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
	SideMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
	SideMenu.ClipsDescendants = true
	SideMenu.ZIndex = 1
	SideMenu.Parent = MainFrame

	local SideList = Instance.new("UIListLayout")
	SideList.Padding = UDim.new(0, 0)
	SideList.Parent = SideMenu

	SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SideMenu.CanvasSize = UDim2.new(0, 0, 0, SideList.AbsoluteContentSize.Y)
	end)

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(1, -140, 1, -35)
	ContentHolder.Position = UDim2.new(0, 140, 0, 35)
	ContentHolder.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	ContentHolder.BorderSizePixel = 0
	ContentHolder.ClipsDescendants = true
	ContentHolder.ZIndex = 1
	ContentHolder.Parent = MainFrame

	local SettingsPanel = Instance.new("ScrollingFrame")
	SettingsPanel.Size = UDim2.new(1, 0, 1, 0)
	SettingsPanel.BackgroundTransparency = 1
	SettingsPanel.BorderSizePixel = 0
	SettingsPanel.ScrollBarThickness = 2
	SettingsPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
	SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, 330)
	SettingsPanel.Visible = true
	SettingsPanel.ZIndex = 1
	SettingsPanel.Parent = ContentHolder

	local ConfigsLabel = Instance.new("TextLabel")
	ConfigsLabel.Size = UDim2.new(1, 0, 0, 30)
	ConfigsLabel.Position = UDim2.new(0, 0, 0, 5)
	ConfigsLabel.BackgroundTransparency = 1
	ConfigsLabel.Text = "Configs"
	ConfigsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigsLabel.TextSize = 16
	ConfigsLabel.Font = Enum.Font.GothamBold
	ConfigsLabel.Parent = SettingsPanel

	local ConfigListLabel = Instance.new("TextLabel")
	ConfigListLabel.Size = UDim2.new(1, -20, 0, 20)
	ConfigListLabel.Position = UDim2.new(0, 10, 0, 40)
	ConfigListLabel.BackgroundTransparency = 1
	ConfigListLabel.Text = "Config List"
	ConfigListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigListLabel.TextSize = 12
	ConfigListLabel.Font = Enum.Font.Gotham
	ConfigListLabel.TextXAlignment = Enum.TextXAlignment.Left
	ConfigListLabel.Parent = SettingsPanel

	local ConfigListBox = Instance.new("Frame")
	ConfigListBox.Size = UDim2.new(1, -20, 0, 30)
	ConfigListBox.Position = UDim2.new(0, 10, 0, 60)
	ConfigListBox.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	ConfigListBox.BorderSizePixel = 0
	ConfigListBox.Parent = SettingsPanel

	local ConfigListCorner = Instance.new("UICorner")
	ConfigListCorner.CornerRadius = UDim.new(0, 4)
	ConfigListCorner.Parent = ConfigListBox

	local ConfigListArrow = Instance.new("TextLabel")
	ConfigListArrow.Size = UDim2.new(0, 20, 1, 0)
	ConfigListArrow.Position = UDim2.new(1, -20, 0, 0)
	ConfigListArrow.BackgroundTransparency = 1
	ConfigListArrow.Text = "▼"
	ConfigListArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigListArrow.TextSize = 10
	ConfigListArrow.Font = Enum.Font.Gotham
	ConfigListArrow.Parent = ConfigListBox

	local ConfigNameLabel = Instance.new("TextLabel")
	ConfigNameLabel.Size = UDim2.new(1, -20, 0, 20)
	ConfigNameLabel.Position = UDim2.new(0, 10, 0, 100)
	ConfigNameLabel.BackgroundTransparency = 1
	ConfigNameLabel.Text = "Config Name"
	ConfigNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigNameLabel.TextSize = 12
	ConfigNameLabel.Font = Enum.Font.Gotham
	ConfigNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	ConfigNameLabel.Parent = SettingsPanel

	local ConfigNameBox = Instance.new("TextBox")
	ConfigNameBox.Size = UDim2.new(1, -20, 0, 30)
	ConfigNameBox.Position = UDim2.new(0, 10, 0, 120)
	ConfigNameBox.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	ConfigNameBox.BorderSizePixel = 0
	ConfigNameBox.PlaceholderText = "Enter Value..."
	ConfigNameBox.Text = ""
	ConfigNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigNameBox.TextSize = 12
	ConfigNameBox.Font = Enum.Font.Gotham
	ConfigNameBox.Parent = SettingsPanel

	local ConfigNameCorner = Instance.new("UICorner")
	ConfigNameCorner.CornerRadius = UDim.new(0, 4)
	ConfigNameCorner.Parent = ConfigNameBox

	local function CreateBlueButton(text, yPos)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -20, 0, 28)
		btn.Position = UDim2.new(0, 10, 0, yPos)
		btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		btn.BorderSizePixel = 0
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 13
		btn.Font = Enum.Font.GothamBold
		btn.Parent = SettingsPanel

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		return btn
	end

	CreateBlueButton("Load Config", 160)
	CreateBlueButton("Save Config", 192)
	CreateBlueButton("Delete Config", 224)
	CreateBlueButton("Load Latest Config", 256)
	CreateBlueButton("Refresh Config List", 288)

	local CreditsPanel = Instance.new("ScrollingFrame")
	CreditsPanel.Size = UDim2.new(1, 0, 1, 0)
	CreditsPanel.BackgroundTransparency = 1
	CreditsPanel.BorderSizePixel = 0
	CreditsPanel.ScrollBarThickness = 2
	CreditsPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
	CreditsPanel.CanvasSize = UDim2.new(0, 0, 0, 500)
	CreditsPanel.Visible = false
	CreditsPanel.ZIndex = 1
	CreditsPanel.Parent = ContentHolder

	-- CRÉDITO 1 - wxrkbrxz
	local CreditBox1 = Instance.new("Frame")
	CreditBox1.Size = UDim2.new(1, -20, 0, 110)
	CreditBox1.Position = UDim2.new(0, 10, 0, 10)
	CreditBox1.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	CreditBox1.BorderSizePixel = 0
	CreditBox1.Parent = CreditsPanel

	local CreditBox1Corner = Instance.new("UICorner")
	CreditBox1Corner.CornerRadius = UDim.new(0, 6)
	CreditBox1Corner.Parent = CreditBox1

	local Photo1 = Instance.new("ImageLabel")
	Photo1.Size = UDim2.new(0, 30, 0, 30)
	Photo1.Position = UDim2.new(0, 10, 0, 5)
	Photo1.BackgroundTransparency = 1
	Photo1.Image = "rbxassetid://117956353701129"
	Photo1.ScaleType = Enum.ScaleType.Fit
	Photo1.Parent = CreditBox1

	local Photo1Corner = Instance.new("UICorner")
	Photo1Corner.CornerRadius = UDim.new(0, 6)
	Photo1Corner.Parent = Photo1

	local TikTok1 = Instance.new("TextLabel")
	TikTok1.Size = UDim2.new(0, 200, 0, 30)
	TikTok1.Position = UDim2.new(0, 45, 0, 5)
	TikTok1.BackgroundTransparency = 1
	TikTok1.Text = "TikTok @wxrkbrxz"
	TikTok1.TextColor3 = Color3.fromRGB(255, 255, 255)
	TikTok1.TextSize = 12
	TikTok1.Font = Enum.Font.Gotham
	TikTok1.TextXAlignment = Enum.TextXAlignment.Left
	TikTok1.Parent = CreditBox1

	local CreditsLabel1 = Instance.new("TextLabel")
	CreditsLabel1.Size = UDim2.new(1, 0, 0, 20)
	CreditsLabel1.Position = UDim2.new(0, 0, 0, 40)
	CreditsLabel1.BackgroundTransparency = 1
	CreditsLabel1.Text = "Credits"
	CreditsLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditsLabel1.TextSize = 12
	CreditsLabel1.Font = Enum.Font.GothamBold
	CreditsLabel1.Parent = CreditBox1

	local Divider1 = Instance.new("Frame")
	Divider1.Size = UDim2.new(1, -40, 0, 1)
	Divider1.Position = UDim2.new(0, 20, 0, 60)
	Divider1.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
	Divider1.BorderSizePixel = 0
	Divider1.Parent = CreditBox1

	local CreditName1 = Instance.new("TextLabel")
	CreditName1.Size = UDim2.new(1, 0, 0, 30)
	CreditName1.Position = UDim2.new(0, 0, 0, 70)
	CreditName1.BackgroundTransparency = 1
	CreditName1.Text = "EL 01 ROX HUB"
	CreditName1.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditName1.TextSize = 14
	CreditName1.Font = Enum.Font.Gotham
	CreditName1.Parent = CreditBox1

	-- CRÉDITO 2 - ITACHI
	local CreditBox2 = Instance.new("Frame")
	CreditBox2.Size = UDim2.new(1, -20, 0, 110)
	CreditBox2.Position = UDim2.new(0, 10, 0, 130)
	CreditBox2.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	CreditBox2.BorderSizePixel = 0
	CreditBox2.Parent = CreditsPanel

	local CreditBox2Corner = Instance.new("UICorner")
	CreditBox2Corner.CornerRadius = UDim.new(0, 6)
	CreditBox2Corner.Parent = CreditBox2

	local Photo2 = Instance.new("ImageLabel")
	Photo2.Size = UDim2.new(0, 30, 0, 30)
	Photo2.Position = UDim2.new(0, 10, 0, 5)
	Photo2.BackgroundTransparency = 1
	Photo2.Image = "rbxassetid://116305977254575"
	Photo2.ScaleType = Enum.ScaleType.Fit
	Photo2.Parent = CreditBox2

	local Photo2Corner = Instance.new("UICorner")
	Photo2Corner.CornerRadius = UDim.new(0, 6)
	Photo2Corner.Parent = Photo2

	local TikTok2 = Instance.new("TextLabel")
	TikTok2.Size = UDim2.new(0, 200, 0, 30)
	TikTok2.Position = UDim2.new(0, 45, 0, 5)
	TikTok2.BackgroundTransparency = 1
	TikTok2.Text = "TikTok @itachi_19029"
	TikTok2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TikTok2.TextSize = 12
	TikTok2.Font = Enum.Font.Gotham
	TikTok2.TextXAlignment = Enum.TextXAlignment.Left
	TikTok2.Parent = CreditBox2

	local CreditsLabel2 = Instance.new("TextLabel")
	CreditsLabel2.Size = UDim2.new(1, 0, 0, 20)
	CreditsLabel2.Position = UDim2.new(0, 0, 0, 40)
	CreditsLabel2.BackgroundTransparency = 1
	CreditsLabel2.Text = "Credits"
	CreditsLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditsLabel2.TextSize = 12
	CreditsLabel2.Font = Enum.Font.GothamBold
	CreditsLabel2.Parent = CreditBox2

	local Divider2 = Instance.new("Frame")
	Divider2.Size = UDim2.new(1, -40, 0, 1)
	Divider2.Position = UDim2.new(0, 20, 0, 60)
	Divider2.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
	Divider2.BorderSizePixel = 0
	Divider2.Parent = CreditBox2

	local CreditName2 = Instance.new("TextLabel")
	CreditName2.Size = UDim2.new(1, 0, 0, 30)
	CreditName2.Position = UDim2.new(0, 0, 0, 70)
	CreditName2.BackgroundTransparency = 1
	CreditName2.Text = "ITACHI HUB"
	CreditName2.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditName2.TextSize = 14
	CreditName2.Font = Enum.Font.Gotham
	CreditName2.Parent = CreditBox2

	-- CRÉDITO 3 - ZYROX
	local CreditBox3 = Instance.new("Frame")
	CreditBox3.Size = UDim2.new(1, -20, 0, 110)
	CreditBox3.Position = UDim2.new(0, 10, 0, 250)
	CreditBox3.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	CreditBox3.BorderSizePixel = 0
	CreditBox3.Parent = CreditsPanel

	local CreditBox3Corner = Instance.new("UICorner")
	CreditBox3Corner.CornerRadius = UDim.new(0, 6)
	CreditBox3Corner.Parent = CreditBox3

	local Photo3 = Instance.new("ImageLabel")
	Photo3.Size = UDim2.new(0, 30, 0, 30)
	Photo3.Position = UDim2.new(0, 10, 0, 5)
	Photo3.BackgroundTransparency = 1
	Photo3.Image = "rbxassetid://134220729933827"
	Photo3.ScaleType = Enum.ScaleType.Fit
	Photo3.Parent = CreditBox3

	local Photo3Corner = Instance.new("UICorner")
	Photo3Corner.CornerRadius = UDim.new(0, 6)
	Photo3Corner.Parent = Photo3

	local TikTok3 = Instance.new("TextLabel")
	TikTok3.Size = UDim2.new(0, 200, 0, 30)
	TikTok3.Position = UDim2.new(0, 45, 0, 5)
	TikTok3.BackgroundTransparency = 1
	TikTok3.Text = "TikTok @forcehub101"
	TikTok3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TikTok3.TextSize = 12
	TikTok3.Font = Enum.Font.Gotham
	TikTok3.TextXAlignment = Enum.TextXAlignment.Left
	TikTok3.Parent = CreditBox3

	local CreditsLabel3 = Instance.new("TextLabel")
	CreditsLabel3.Size = UDim2.new(1, 0, 0, 20)
	CreditsLabel3.Position = UDim2.new(0, 0, 0, 40)
	CreditsLabel3.BackgroundTransparency = 1
	CreditsLabel3.Text = "Credits"
	CreditsLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditsLabel3.TextSize = 12
	CreditsLabel3.Font = Enum.Font.GothamBold
	CreditsLabel3.Parent = CreditBox3

	local Divider3 = Instance.new("Frame")
	Divider3.Size = UDim2.new(1, -40, 0, 1)
	Divider3.Position = UDim2.new(0, 20, 0, 60)
	Divider3.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
	Divider3.BorderSizePixel = 0
	Divider3.Parent = CreditBox3

	local CreditName3 = Instance.new("TextLabel")
	CreditName3.Size = UDim2.new(1, 0, 0, 30)
	CreditName3.Position = UDim2.new(0, 0, 0, 70)
	CreditName3.BackgroundTransparency = 1
	CreditName3.Text = "ZYROX HUB"
	CreditName3.TextColor3 = Color3.fromRGB(255, 255, 255)
	CreditName3.TextSize = 14
	CreditName3.Font = Enum.Font.Gotham
	CreditName3.Parent = CreditBox3

	local tabs = {
		Home = nil,
		Main = nil,
		Miscellaneous = nil,
		Jugador = nil,
		Map = nil,
		Troll = nil,
		Servidor = nil,
		Settings = SettingsPanel,
		Credits = CreditsPanel
	}

	local function CreateSideButton(text, selected)
		local btn = Instance.new
