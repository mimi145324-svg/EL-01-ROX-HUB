-- EL 01 ROX HUB VERSIÓN FINAL V7.5 - HITBOX COLOR FIX
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "EL 01 ROX HUB",
   LoadingTitle = "EL 01 ROX HUB",
   LoadingSubtitle = "VERSIÓN FINAL V7.5",
   ConfigurationSaving = { Enabled = true, FolderName = "EL01ROXHUB", FileName = "EL01Config" }
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
_G.AimEnabled = false
_G.Smooth = 0.2
_G.LinePos = "Abajo"
_G.LineESP = false
_G.LineColor = Color3.fromRGB(0,255,0)
_G.StretchEnabled = false
_G.FOVValue = 90
_G.NormalFOV = Camera.FieldOfView
_G.HighlightESP = false
_G.HighlightColor = Color3.fromRGB(255,0,0)
_G.HitboxEnabled = false
_G.HitboxSize = 10
_G.HitboxColor = Color3.fromRGB(255,0,0)
_G.HitboxPart = "Cuerpo"
_G.ShowFOV = false
_G.FOVSize = 150
_G.FOVColor = Color3.fromRGB(255,0,0)
_G.SkeletonESP = false
_G.SkeletonColor = Color3.fromRGB(255,255,255)
_G.BoxESP = false
_G.BoxColor = Color3.fromRGB(255,255,255)
_G.BoxSize = 1
_G.BoxThickness = 2
_G.NameESP = false
_G.NameColor = Color3.fromRGB(255,255,255)
_G.NameSize = 16
_G.HealthESP = false
_G.HealthColor = Color3.fromRGB(0,255,0)
_G.HealthSize = 1
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.NormalSpeed = 16
_G.NoclipEnabled = false
_G.SpinEnabled = false
_G.SpinSpeed = 10
_G.SkyEnabled = true
_G.InfJumpEnabled = false
_G.BigJumpEnabled = false
_G.JumpValue = 50
_G.NormalJump = 50
_G.FakeLagEnabled = false
_G.RemoverHold = false
_G.InfPlatform = false
_G.AutoFire = false
_G.AutoFireDelay = 0.15
_G.AltoKills = false
_G.NoReload = false
_G.Wallbang = true
_G.Invisible = false
local CustomSkyId = { SkyboxBk = "rbxassetid://93890239383229", SkyboxDn = "rbxassetid://112454650572091", SkyboxFt = "rbxassetid://73098720230830", SkyboxLf = "rbxassetid://134080730103642", SkyboxRt = "rbxassetid://122393134916832", SkyboxUp = "rbxassetid://93890239383229" }
local function ApplyCustomSky() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end local sky = Instance.new("Sky") sky.SkyboxBk = CustomSkyId.SkyboxBk sky.SkyboxDn = CustomSkyId.SkyboxDn sky.SkyboxFt = CustomSkyId.SkyboxFt sky.SkyboxLf = CustomSkyId.SkyboxLf sky.SkyboxRt = CustomSkyId.SkyboxRt sky.SkyboxUp = CustomSkyId.SkyboxUp sky.Parent = Lighting end
local function RemoveCustomSky() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end Instance.new("Sky").Parent = Lighting end
task.spawn(function() ApplyCustomSky() end)
UserInputService.JumpRequest:Connect(function() if _G.InfJumpEnabled then local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end end)
local FrozenPlayers = {}
local function FreezePlayer(char) if FrozenPlayers[char] then return end local hrp = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if hrp and hum then FrozenPlayers[char] = { Pos = hrp.CFrame, Vel = hrp.Velocity } hum.AutoRotate = false hum:ChangeState(Enum.HumanoidStateType.Physics) end end
local function UnfreezePlayer(char) local data = FrozenPlayers[char] if not data then return end local hrp = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if hrp then hrp.Velocity = data.Vel end if hum then hum.AutoRotate = true hum:ChangeState(Enum.HumanoidStateType.GettingUp) end FrozenPlayers[char] = nil end
local Platforms = {} local LastPlatform = nil
local function CreatePlatform() local char = LocalPlayer.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end local hrp = char.HumanoidRootPart local plat = Instance.new("Part") plat.Size = Vector3.new(10,1,10) plat.Position = hrp.Position - Vector3.new(0,4,0) plat.Anchored = true plat.Transparency = 0.5 plat.Color = Color3.fromRGB(0,255,0) plat.Material = Enum.Material.Neon plat.CanCollide = true plat.Parent = workspace table.insert(Platforms, plat) if #Platforms > 15 then local old = table.remove(Platforms, 1) if old then old:Destroy() end end LastPlatform = plat task.delay(5, function() if plat and plat.Parent then pcall(function() plat:Destroy() end) end end) end
local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "FOVGui" ScreenGui.ResetOnSpawn = false ScreenGui.IgnoreGuiInset = true pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end) if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end local FOVFrame = Instance.new("Frame") FOVFrame.AnchorPoint = Vector2.new(0.5,0.5) FOVFrame.Position = UDim2.new(0.5,0,0.5,0) FOVFrame.Size = UDim2.new(0, 300, 0, 300) FOVFrame.BackgroundTransparency = 1 FOVFrame.Visible = false FOVFrame.Parent = ScreenGui local UIStroke = Instance.new("UIStroke") UIStroke.Thickness = 1 UIStroke.Color = Color3.fromRGB(255,0,0) UIStroke.Parent = FOVFrame local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(1,0) UICorner.Parent = FOVFrame
local OriginalSizes = {} local function SaveOriginal(char) if OriginalSizes[char] then return end OriginalSizes[char] = {} for _,part in pairs(char:GetChildren()) do if part:IsA("BasePart") then OriginalSizes[char][part.Name] = {Size = part.Size, Trans = part.Transparency, Color = part.Color, Mat = part.Material} end end end local function RestoreHitbox(char) if not char then return end local data = OriginalSizes[char] if data then for _,part in pairs(char:GetChildren()) do if part:IsA("BasePart") and data[part.Name] then part.Size = data[part.Name].Size part.Transparency = data[part.Name].Trans part.Color = data[part.Name].Color part.Material = data[part.Name].Mat end end end end
local SavedPositions = {} local function SaveAllPositions() SavedPositions = {} for _,plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character:FindFirstChild("HumanoidRootPart") then SavedPositions[plr] = plr.Character.HumanoidRootPart.CFrame end end end local function RestoreAllPositions() for plr, cframe in pairs(SavedPositions) do if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then pcall(function() plr.Character.HumanoidRootPart.CFrame = cframe plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end) end end SavedPositions = {} end local function RemoverAllOnce() local myChar = LocalPlayer.Character if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end local myPos = myChar.HumanoidRootPart.CFrame local count = 0 for _,plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character:FindFirstChild("HumanoidRootPart") then local hrp = plr.Character.HumanoidRootPart count = count + 1 local angle = math.rad(count * (360 / math.max(1, #Players:GetPlayers()-1))) local offset = Vector3.new(math.cos(angle)*5, 0, math.sin(angle)*5) pcall(function() hrp.CFrame = myPos + offset hrp.Velocity = Vector3.new(0,0,0) end) end end return count end
local function GetClosestWallbang() local target, dist = nil, math.huge local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then local pos,vis = Camera:WorldToViewportPoint(p.Character.Head.Position) if vis then local mag = (Vector2.new(pos.X,pos.Y) - center).Magnitude if _G.ShowFOV then if mag > _G.FOVSize then continue end end if mag < dist then dist = mag target = p end end end end return target end
local function GetAllPlayersWallbang() local list = {} for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then table.insert(list, p) end end return list end
local function ApplyHitbox(char) if not char then return end SaveOriginal(char) local size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize) if _G.HitboxPart == "Cuerpo" then local part = char:FindFirstChild("HumanoidRootPart") if part then part.Size = size part.Transparency = 0.5 part.Color = _G.HitboxColor part.Material = Enum.Material.Neon part.CanCollide = false end elseif _G.HitboxPart == "Cabeza" then local part = char:FindFirstChild("Head") if part then part.Size = size part.Transparency = 0.5 part.Color = _G.HitboxColor part.Material = Enum.Material.Neon part.CanCollide = false end elseif _G.HitboxPart == "Pies" then for _,n in pairs({"LeftFoot","RightFoot","LeftLowerLeg","RightLowerLeg","Left Leg","Right Leg"}) do local part = char:FindFirstChild(n) if part then part.Size = size part.Transparency = 0.5 part.Color = _G.HitboxColor part.Material = Enum.Material.Neon part.CanCollide = false end end end end
local function AltoKillsFunc() for _,plr in pairs(GetAllPlayersWallbang()) do pcall(function() Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position) local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") if tool then tool:Activate() end VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(0.02) VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0) end) end end
local function NoReloadLoop() if not _G.NoReload then return end pcall(function() local char = LocalPlayer.Character if char then local tool = char:FindFirstChildOfClass("Tool") if tool then for _,v in pairs(tool:GetDescendants()) do if v:IsA("IntValue") or v:IsA("NumberValue") then local name = v.Name:lower() if name:find("ammo") or name:find("mag") or name:find("bullet") or name:find("clip") then v.Value = 999 end end end if tool:GetAttribute("Ammo") then tool:SetAttribute("Ammo", 999) end if tool:GetAttribute("Mag") then tool:SetAttribute("Mag", 999) end end end end) end
local OldTrans = {} local function SetInvisible(v) local char = LocalPlayer.Character if not char then return end if v then OldTrans = {} for _,part in pairs(char:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then OldTrans[part] = part.Transparency part.Transparency = 1 elseif part:IsA("Decal") then OldTrans[part] = part.Transparency part.Transparency = 1 end end else for part,trans in pairs(OldTrans) do pcall(function() part.Transparency = trans end) end OldTrans = {} end end

local AimTab = Window:CreateTab("🎯AIM", 4483362458)
AimTab:CreateToggle({ Name = "Activar AIM", CurrentValue = false, Flag = "AimFlag", Callback = function(v) _G.AimEnabled = v end })
AimTab:CreateSlider({ Name = "Suavidad AIM", Range = {0.05,1}, Increment = 0.05, CurrentValue = 0.2, Flag = "SmoothFlag", Callback = function(v) _G.Smooth = v end })
AimTab:CreateSection("AUTO FIRE WALLBANG")
AimTab:CreateToggle({ Name = "AUTO FIRE - Dispara solo", CurrentValue = false, Flag = "AutoFireFlag", Callback = function(v) _G.AutoFire = v end })
AimTab:CreateToggle({ Name = "Atraviesa paredes", CurrentValue = true, Flag = "WallbangFlag", Callback = function(v) _G.Wallbang = v end })
AimTab:CreateSlider({ Name = "Velocidad disparo", Range = {0.05, 1}, Increment = 0.05, CurrentValue = 0.15, Flag = "AutoFireDelayFlag", Callback = function(v) _G.AutoFireDelay = v end })
AimTab:CreateSection("ALTO KILLS + NO RECARGAR")
AimTab:CreateToggle({ Name = "ALTO KILLS - Dispara a todos", CurrentValue = false, Flag = "AltoKillsFlag", Callback = function(v) _G.AltoKills = v end })
AimTab:CreateButton({ Name = "ALTO KILLS AHORA", Callback = function() AltoKillsFunc() end })
AimTab:CreateToggle({ Name = "NO RECARGAR", CurrentValue = false, Flag = "NoReloadFlag", Callback = function(v) _G.NoReload = v end })
AimTab:CreateSection("CÁMARA ESTIRADA")
AimTab:CreateToggle({ Name = "ESTIRAR CÁMARA", CurrentValue = false, Flag = "StretchFlag", Callback = function(v) _G.StretchEnabled = v if not v then Camera.FieldOfView = _G.NormalFOV else Camera.FieldOfView = _G.FOVValue end end })
AimTab:CreateSlider({ Name = "Cuánto lo quieres estirar", Range = {70, 120}, Increment = 1, CurrentValue = 90, Flag = "FOVValueFlag", Callback = function(v) _G.FOVValue = v if _G.StretchEnabled then Camera.FieldOfView = v end end })
AimTab:CreateSection("FOV")
AimTab:CreateToggle({ Name = "FOV", CurrentValue = false, Flag = "FOVFlag", Callback = function(v) _G.ShowFOV = v FOVFrame.Visible = v end })
AimTab:CreateSlider({ Name = "Tamaño FOV", Range = {20, 800}, Increment = 5, CurrentValue = 150, Flag = "FOVSizeFlag", Callback = function(v) _G.FOVSize = v FOVFrame.Size = UDim2.new(0, v*2, 0, v*2) end })
AimTab:CreateColorPicker({ Name = "Color FOV", Color = Color3.fromRGB(255,0,0), Flag = "FOVColorFlag", Callback = function(v) _G.FOVColor = v UIStroke.Color = v end })
AimTab:CreateSlider({ Name = "Grosor FOV", Range = {1, 5}, Increment = 0.5, CurrentValue = 1, Flag = "FOVThickFlag", Callback = function(v) UIStroke.Thickness = v end })
AimTab:CreateSection("REMOVER")
AimTab:CreateButton({ Name = "REMOVER - Traer una vez", Callback = function() RemoverAllOnce() end })
AimTab:CreateToggle({ Name = "REMOVER HOLD", CurrentValue = false, Flag = "RemoverHoldFlag", Callback = function(v) _G.RemoverHold = v if v then SaveAllPositions() else RestoreAllPositions() end end })
AimTab:CreateSection("HITBOX")
AimTab:CreateToggle({ Name = "Activar Hitbox", CurrentValue = false, Flag = "HitboxFlag", Callback = function(v) _G.HitboxEnabled = v if not v then for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then RestoreHitbox(p.Character) end end OriginalSizes = {} end end })
AimTab:CreateDropdown({ Name = "Parte del Hitbox", Options = {"Cabeza","Cuerpo","Pies"}, CurrentOption = {"Cuerpo"}, Flag = "HitboxPartFlag", Callback = function(v) _G.HitboxPart = v[1] end })
AimTab:CreateSlider({ Name = "Tamaño Hitbox", Range = {2, 30}, Increment = 1, CurrentValue = 10, Flag = "HitboxSizeFlag", Callback = function(v) _G.HitboxSize = v end })
AimTab:CreateColorPicker({ Name = "Color Hitbox", Color = Color3.fromRGB(255,0,0), Flag = "HitboxColorFlag", Callback = function(v) _G.HitboxColor = v end })

local ESPTab = Window:CreateTab("👁️ESP", 4483362458)
ESPTab:CreateToggle({ Name="Line ESP", CurrentValue=false, Flag="LineFlag", Callback=function(v) _G.LineESP=v end })
ESPTab:CreateDropdown({ Name="Posición Línea", Options={"Arriba","Medio","Abajo"}, CurrentOption={"Abajo"}, Flag="LinePosFlag", Callback=function(v) _G.LinePos = v[1] end })
ESPTab:CreateColorPicker({ Name="Color Línea", Color=Color3.fromRGB(0,255,0), Flag="LineColorFlag", Callback=function(v) _G.LineColor=v end })
ESPTab:CreateSection("BOXES")
ESPTab:CreateToggle({ Name = "Boxes ESP", CurrentValue = false, Flag = "BoxFlag", Callback = function(v) _G.BoxESP = v end })
ESPTab:CreateSlider({ Name = "Tamaño Boxes", Range = {0.5, 3}, Increment = 0.1, CurrentValue = 1, Flag = "BoxSizeFlag", Callback = function(v) _G.BoxSize = v end })
ESPTab:CreateSlider({ Name = "Grosor Boxes", Range = {1, 5}, Increment = 1, CurrentValue = 2, Flag = "BoxThickFlag", Callback = function(v) _G.BoxThickness = v end })
ESPTab:CreateColorPicker({ Name = "Color Boxes", Color = Color3.fromRGB(255,255,255), Flag = "BoxColorFlag", Callback = function(v) _G.BoxColor = v end })
ESPTab:CreateSection("NAME")
ESPTab:CreateToggle({ Name = "Name ESP", CurrentValue = false, Flag = "NameFlag", Callback = function(v) _G.NameESP = v end })
ESPTab:CreateSlider({ Name = "Tamaño Name", Range = {10, 30}, Increment = 1, CurrentValue = 16, Flag = "NameSizeFlag", Callback = function(v) _G.NameSize = v end })
ESPTab:CreateColorPicker({ Name = "Color Name", Color = Color3.fromRGB(255,255,255), Flag = "NameColorFlag", Callback = function(v) _G.NameColor = v end })
ESPTab:CreateSection("VIDA")
ESPTab:CreateToggle({ Name = "Vida ESP - Barra verde", CurrentValue = false, Flag = "HealthFlag", Callback = function(v) _G.HealthESP = v end })
ESPTab:CreateSlider({ Name = "Tamaño Vida", Range = {0.5, 3}, Increment = 0.1, CurrentValue = 1, Flag = "HealthSizeFlag", Callback = function(v) _G.HealthSize = v end })
ESPTab:CreateColorPicker({ Name = "Color Vida", Color = Color3.fromRGB(0,255,0), Flag = "HealthColorFlag", Callback = function(v) _G.HealthColor = v end })
ESPTab:CreateSection("Highlight")
ESPTab:CreateToggle({ Name = "Highlight ESP", CurrentValue = false, Flag="HighlightFlag", Callback = function(v) _G.HighlightESP = v end })
ESPTab:CreateColorPicker({ Name = "Color Highlight", Color = Color3.fromRGB(255,0,0), Flag="HighlightColorFlag", Callback = function(v) _G.HighlightColor = v end })
ESPTab:CreateSection("Esqueleto")
ESPTab:CreateToggle({ Name = "ESP Esqueleto", CurrentValue = false, Flag="SkeleFlag", Callback = function(v) _G.SkeletonESP = v end })
ESPTab:CreateColorPicker({ Name = "Color Esqueleto", Color = Color3.fromRGB(255,255,255), Flag="SkeleColorFlag", Callback = function(v) _G.SkeletonColor = v end })

local MiscTab = Window:CreateTab("???", 4483362458)
MiscTab:CreateSection("INVISIBLE")
MiscTab:CreateToggle({ Name = "INVISIBLE", CurrentValue = false, Flag = "InvisibleFlag", Callback = function(v) _G.Invisible = v SetInvisible(v) end })
MiscTab:CreateSection("MOVIMIENTO")
MiscTab:CreateToggle({ Name = "Activar Speed", CurrentValue = false, Flag="SpeedFlag", Callback = function(v) _G.SpeedEnabled = v local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then if v then _G.NormalSpeed = hum.WalkSpeed hum.WalkSpeed = _G.SpeedValue else hum.WalkSpeed = _G.NormalSpeed end end end end })
MiscTab:CreateSlider({ Name = "Velocidad Speed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Flag="SpeedValueFlag", Callback = function(v) _G.SpeedValue = v if _G.SpeedEnabled then local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = v end end end end })
MiscTab:CreateSection("PLATAFORMA")
MiscTab:CreateToggle({ Name = "SALTO INFINITO PLATAFORMA", CurrentValue = false, Flag = "InfPlatFlag", Callback = function(v) _G.InfPlatform = v if not v then for _,plat in pairs(Platforms) do pcall(function() plat:Destroy() end) end Platforms = {} end end })
MiscTab:CreateSection("SALTOS")
MiscTab:CreateToggle({ Name = "Infinity Jump", CurrentValue = false, Flag="InfJumpFlag", Callback = function(v) _G.InfJumpEnabled = v end })
MiscTab:CreateToggle({ Name = "Salto Grande", CurrentValue = false, Flag="BigJumpFlag", Callback = function(v) _G.BigJumpEnabled = v local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then if v then _G.NormalJump = hum.JumpPower hum.UseJumpPower = true hum.JumpPower = _G.JumpValue else hum.JumpPower = _G.NormalJump end end end end })
MiscTab:CreateSlider({ Name = "Cuánto puedes saltar", Range = {50, 500}, Increment = 5, CurrentValue = 50, Flag="JumpValueFlag", Callback = function(v) _G.JumpValue = v if _G.BigJumpEnabled then local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.UseJumpPower = true hum.JumpPower = v end end end end })
MiscTab:CreateSection("FAKE LAG")
MiscTab:CreateToggle({ Name = "Fake Lag (Congelar jugadores)", CurrentValue = false, Flag="FakeLagFlag", Callback = function(v) _G.FakeLagEnabled = v if not v then for char,_ in pairs(FrozenPlayers) do UnfreezePlayer(char) end FrozenPlayers = {} end end })
MiscTab:CreateSection("OTROS")
MiscTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Flag="NoclipFlag", Callback = function(v) _G.NoclipEnabled = v end })
MiscTab:CreateToggle({ Name = "Activar Spin", CurrentValue = false, Flag="SpinFlag", Callback = function(v) _G.SpinEnabled = v end })
MiscTab:CreateSlider({ Name = "Velocidad Spin", Range = {1, 100}, Increment = 1, CurrentValue = 10, Flag="SpinSpeedFlag", Callback = function(v) _G.SpinSpeed = v end })
MiscTab:CreateSection("SKY")
MiscTab:CreateToggle({ Name = "Sky Custom", CurrentValue = true, Flag="SkyFlag", Callback = function(v) _G.SkyEnabled = v if v then ApplyCustomSky() else RemoveCustomSky() end end })

local CreditTab = Window:CreateTab("Créditos", 4483362458)
CreditTab:CreateParagraph({Title = "EL 01 ROX HUB", Content = "VERSIÓN FINAL V7.5\nTodo arreglado\nCreado por EL 01 ROX HUB"})
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateButton({ Name = "Guardar Configuración", Callback = function() Rayfield:SaveConfiguration() end })
SettingsTab:CreateButton({ Name = "Quitar Configuración", Callback = function() if isfile and delfile and isfile("EL01ROXHUB/EL01Config.json") then delfile("EL01ROXHUB/EL01Config.json") end end })

local LastFire = 0
local LastKills = 0
local function AutoFireFunc() if not _G.AutoFire then return end if tick() - LastFire < _G.AutoFireDelay then return end local target = GetClosestWallbang() if not target or not target.Character then return end pcall(function() local char = LocalPlayer.Character if char then local tool = char:FindFirstChildOfClass("Tool") if tool then tool:Activate() end end VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(0.05) VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0) end) LastFire = tick() end
local ESP = {} local Highlights = {} local SkeletonLines = {} local BoxESP = {} local NameESP = {} local HealthBars = {}
local function CreateESPData(plr)
    if not BoxESP[plr] then BoxESP[plr] = Drawing.new("Square") BoxESP[plr].Thickness = _G.BoxThickness BoxESP[plr].Filled = false BoxESP[plr].Visible = false end
    if not NameESP[plr] then NameESP[plr] = Drawing.new("Text") NameESP[plr].Center = true NameESP[plr].Outline = true NameESP[plr].Visible = false NameESP[plr].Font = 2 end
    if not HealthBars[plr] then HealthBars[plr] = { Back = Drawing.new("Line"), Front = Drawing.new("Line"), Text = Drawing.new("Text") } HealthBars[plr].Back.Thickness = 4 HealthBars[plr].Back.Color = Color3.fromRGB(0,0,0) HealthBars[plr].Front.Thickness = 4 HealthBars[plr].Text.Center = true HealthBars[plr].Text.Outline = true HealthBars[plr].Text.Font = 2 HealthBars[plr].Back.Visible = false HealthBars[plr].Front.Visible = false HealthBars[plr].Text.Visible = false end
    if not SkeletonLines[plr] then local lines = {} for i=1,15 do lines[i] = Drawing.new("Line") lines[i].Thickness = 2 lines[i].Visible = false end SkeletonLines[plr] = lines end
end
Players.PlayerRemoving:Connect(function(plr) if ESP[plr] then pcall(function() ESP[plr].Line:Remove() end) ESP[plr] = nil end if Highlights[plr] then pcall(function() Highlights[plr]:Destroy() end) Highlights[plr] = nil end if SkeletonLines[plr] then for _,l in pairs(SkeletonLines[plr]) do l:Remove() end SkeletonLines[plr]=nil end if BoxESP[plr] then pcall(function() BoxESP[plr]:Remove() end) BoxESP[plr]=nil end if NameESP[plr] then pcall(function() NameESP[plr]:Remove() end) NameESP[plr]=nil end if HealthBars[plr] then pcall(function() HealthBars[plr].Back:Remove() HealthBars[plr].Front:Remove() HealthBars[plr].Text:Remove() end) HealthBars[plr]=nil end end)
local function GetPos(char, name) local part = char:FindFirstChild(name) if part then local pos,vis = Camera:WorldToViewportPoint(part.Position) return Vector2.new(pos.X,pos.Y), vis end return nil,false end
RunService.Stepped:Connect(function() if _G.NoclipEnabled then local char = LocalPlayer.Character if char then for _,part in pairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end end end)
RunService.RenderStepped:Connect(function()
    if _G.StretchEnabled then Camera.FieldOfView = _G.FOVValue end
    if _G.AimEnabled then local t = GetClosestWallbang() if t and t.Character and t.Character:FindFirstChild("Head") then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), _G.Smooth) end end
    if _G.AutoFire then AutoFireFunc() end
    if _G.AltoKills then if tick() - LastKills > 0.5 then AltoKillsFunc() LastKills = tick() end end
    if _G.NoReload then NoReloadLoop() end
    if _G.HitboxEnabled then for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then ApplyHitbox(p.Character) end end end
    if _G.SpeedEnabled then local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum and hum.WalkSpeed ~= _G.SpeedValue then hum.WalkSpeed = _G.SpeedValue end end end
    if _G.BigJumpEnabled then local char = LocalPlayer.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum and hum.JumpPower ~= _G.JumpValue then hum.UseJumpPower = true hum.JumpPower = _G.JumpValue end end end
    if _G.SpinEnabled then local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0) end end
    if _G.InfPlatform then local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then local hum = char:FindFirstChildOfClass("Humanoid") local hrp = char.HumanoidRootPart if hum:GetState() == Enum.HumanoidStateType.Jumping or hrp.Velocity.Y > 2 then local ray = workspace:Raycast(hrp.Position, Vector3.new(0,-6,0)) if not ray then if not LastPlatform or (hrp.Position.Y - LastPlatform.Position.Y) > 6 then CreatePlatform() end end end end end
    if _G.FakeLagEnabled then for _,plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character then local char = plr.Character local hrp = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if hrp and hum then if not FrozenPlayers[char] then FreezePlayer(char) end hrp.CFrame = FrozenPlayers[char].Pos hrp.Velocity = Vector3.new(0,0,0) hum:ChangeState(Enum.HumanoidStateType.Physics) end end end end
    if _G.RemoverHold then local myChar = LocalPlayer.Character if myChar and myChar:FindFirstChild("HumanoidRootPart") then local myPos = myChar.HumanoidRootPart.CFrame local count = 0 for _,plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character:FindFirstChild("HumanoidRootPart") then count = count + 1 local angle = math.rad(count * (360 / math.max(1, #Players:GetPlayers()-1))) local offset = Vector3.new(math.cos(angle)*5, 0, math.sin(angle)*5) pcall(function() local hrp = plr.Character.HumanoidRootPart hrp.CFrame = myPos + offset hrp.Velocity = Vector3.new(0,0,0) end) end end end end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if not ESP[plr] then ESP[plr] = { Line = Drawing.new("Line") } ESP[plr].Line.Thickness = 2 end
            CreateESPData(plr)
            local char = plr.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char.HumanoidRootPart
                local head = char.Head
                local topPos, topVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local botPos, botVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                local headPos, headVis = Camera:WorldToViewportPoint(head.Position)
                local visible = topVis or botVis or headVis
                if _G.LineESP and headVis then local fromY = _G.LinePos == "Arriba" and 0 or _G.LinePos == "Medio" and Camera.ViewportSize.Y/2 or Camera.ViewportSize.Y ESP[plr].Line.From = Vector2.new(Camera.ViewportSize.X/2, fromY) ESP[plr].Line.To = Vector2.new(headPos.X,headPos.Y) ESP[plr].Line.Color = _G.LineColor ESP[plr].Line.Visible = true else ESP[plr].Line.Visible = false end
                if _G.HighlightESP then if not Highlights[plr] or Highlights[plr].Parent ~= char then if Highlights[plr] then Highlights[plr]:Destroy() end local hl = Instance.new("Highlight") hl.FillTransparency = 0.5 hl.OutlineTransparency = 0 hl.Parent = char hl.Adornee = char Highlights[plr] = hl end Highlights[plr].FillColor = _G.HighlightColor Highlights[plr].OutlineColor = _G.HighlightColor Highlights[plr].Enabled = true else if Highlights[plr] then Highlights[plr].Enabled = false end end
                if _G.BoxESP and visible then local height = math.abs(botPos.Y - topPos.Y) local width = height * 0.6 width = width * _G.BoxSize height = height * _G.BoxSize BoxESP[plr].Size = Vector2.new(width, height) BoxESP[plr].Position = Vector2.new(topPos.X - width/2, topPos.Y - height*0.15) BoxESP[plr].Color = _G.BoxColor BoxESP[plr].Thickness = _G.BoxThickness BoxESP[plr].Visible = true else BoxESP[plr].Visible = false end
                if _G.NameESP and headVis then NameESP[plr].Text = plr.Name NameESP[plr].Position = Vector2.new(headPos.X, topPos.Y - 20) NameESP[plr].Color = _G.NameColor NameESP[plr].Size = _G.NameSize NameESP[plr].Visible = true else NameESP[plr].Visible = false end
                if _G.HealthESP and visible then local healthPercent = hum.Health / hum.MaxHealth local barHeight = math.abs(botPos.Y - topPos.Y) * _G.HealthSize local barX = topPos.X - (math.abs(botPos.Y - topPos.Y) * 0.6 * _G.BoxSize)/2 - 6 HealthBars[plr].Back.From = Vector2.new(barX, botPos.Y) HealthBars[plr].Back.To = Vector2.new(barX, topPos.Y) HealthBars[plr].Back.Thickness = 4 * _G.HealthSize HealthBars[plr].Back.Visible = true local greenY = botPos.Y - (barHeight * healthPercent) HealthBars[plr].Front.From = Vector2.new(barX, botPos.Y) HealthBars[plr].Front.To = Vector2.new(barX, greenY) HealthBars[plr].Front.Color = _G.HealthColor HealthBars[plr].Front.Thickness = 4 * _G.HealthSize HealthBars[plr].Front.Visible = true HealthBars[plr].Text.Text = math.floor(hum.Health).. "" HealthBars[plr].Text.Position = Vector2.new(barX, greenY - 10) HealthBars[plr].Text.Color = _G.HealthColor HealthBars[plr].Text.Size = 14 HealthBars[plr].Text.Visible = true else HealthBars[plr].Back.Visible = false HealthBars[plr].Front.Visible = false HealthBars[plr].Text.Visible = false end
                if _G.SkeletonESP then local h = GetPos(char,"Head") local ut = GetPos(char,"UpperTorso") local lt = GetPos(char,"LowerTorso") local la1 = GetPos(char,"LeftUpperArm") local la2 = GetPos(char,"LeftLowerArm") local lh = GetPos(char,"LeftHand") local ra1 = GetPos(char,"RightUpperArm") local ra2 = GetPos(char,"RightLowerArm") local rh = GetPos(char,"RightHand") local ll1 = GetPos(char,"LeftUpperLeg") local ll2 = GetPos(char,"LeftLowerLeg") local rl1 = GetPos(char,"RightUpperLeg") local rl2 = GetPos(char,"RightLowerLeg") local lfoot = GetPos(char,"LeftFoot") local rfoot = GetPos(char,"RightFoot") local con = {{h,ut},{ut,la1},{la1,la2},{la2,lh},{ut,ra1},{ra1,ra2},{ra2,rh},{ut,lt},{lt,ll1},{ll1,ll2},{ll2,lfoot},{lt,rl1},{rl1,rl2},{rl2,rfoot}} for i,par in ipairs(con) do local a,b = par[1],par[2] if a and b then SkeletonLines[plr][i].From = a SkeletonLines[plr][i].To = b SkeletonLines[plr][i].Color = _G.SkeletonColor SkeletonLines[plr][i].Visible = true else SkeletonLines[plr][i].Visible = false end end else for _,l in pairs(SkeletonLines[plr]) do l.Visible = false end end
            else if ESP[plr] then ESP[plr].Line.Visible = false end if BoxESP[plr] then BoxESP[plr].Visible = false end if NameESP[plr] then NameESP[plr].Visible = false end if HealthBars[plr] then HealthBars[plr].Back.Visible = false HealthBars[plr].Front.Visible = false HealthBars[plr].Text.Visible = false end if SkeletonLines[plr] then for _,l in pairs(SkeletonLines[plr]) do l.Visible=false end end end
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char) task.wait(1) if _G.SpeedEnabled then local hum = char:WaitForChild("Humanoid") hum.WalkSpeed = _G.SpeedValue end if _G.BigJumpEnabled then local hum = char:WaitForChild("Humanoid") hum.UseJumpPower = true hum.JumpPower = _G.JumpValue end if _G.Invisible then task.wait(0.5) SetInvisible(true) end for _,plat in pairs(Platforms) do pcall(function() plat:Destroy() end) end Platforms = {} end)
