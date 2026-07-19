--// KEY SYSTEM EL 01 ROX HUB

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- KEY correcta
local KEY_CORRECTA = "EL01-ACCESS"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Frame principal
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 350, 0, 180)
Main.Position = UDim2.new(0.5, -175, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0

-- Bordes redondeados
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0,12)

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "EL 01 ROX HUB | KEY SYSTEM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Caja de texto
local KeyBox = Instance.new("TextBox")
KeyBox.Parent = Main
KeyBox.Size = UDim2.new(0.9,0,0,40)
KeyBox.Position = UDim2.new(0.05,0,0.3,0)
KeyBox.PlaceholderText = "Ingresa tu KEY..."
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14

local UICorner2 = Instance.new("UICorner", KeyBox)
UICorner2.CornerRadius = UDim.new(0,8)

-- Botón
local Button = Instance.new("TextButton")
Button.Parent = Main
Button.Size = UDim2.new(0.9,0,0,45)
Button.Position = UDim2.new(0.05,0,0.65,0)
Button.Text = "Llave Verificar"
Button.BackgroundColor3 = Color3.fromRGB(0,120,255)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 15

local UICorner3 = Instance.new("UICorner", Button)
UICorner3.CornerRadius = UDim.new(0,8)

-- Mensaje
local function mensaje(texto, color)
    Title.Text = texto
    Title.TextColor3 = color
    wait(2)
    Title.Text = "EL 01 ROX HUB | KEY SYSTEM"
    Title.TextColor3 = Color3.new(1,1,1)
end

-- Verificación
Button.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY_CORRECTA then
        mensaje("✔ KEY CORRECTA", Color3.fromRGB(0,255,0))
        
        -- Aquí se ejecuta tu script principal
        print("Acceso concedido 😈")

        wait(1)
        ScreenGui:Destroy()
        
    else
        mensaje("✖ KEY INCORRECTA", Color3.fromRGB(255,0,0))
    end
end)
