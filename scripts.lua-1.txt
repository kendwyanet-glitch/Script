-- FNAF Steal Script by Devs_Sync
-- VERSAO REFATORADA - 100% FUNCIONAL

local success, err = pcall(function()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Obter o local correto para a GUI
local ScreenParent = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

-- Variaveis Globais
local SavedBasePosition = nil
local NoclipConnection = nil
local RagdollAuraConnection = nil
local SpeedConnection = nil
local AntiDamageConnection = nil
local ragdollCooldowns = {}
local isMinimized = false
local SavedMainSize = nil
local SavedMainPosition = nil

local CustomSettings = {
    SpeedEnabled = false,
    SpeedValue = 50,
    NoclipEnabled = false,
    RagdollAuraEnabled = false,
    RagdollDistance = 15,
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 100, 100),
    BorderEnabled = false,
    BorderSpeed = 3,
    AntiDamageEnabled = false,
    InvisibilityEnabled = false,
    BaseTimerESPEnabled = false
}

local foundFNAFs = {}
local isWorking = false
local isDragging = false
local dragStart = nil
local startPos = nil
local espElements = {}
local baseTimerElements = {}
local BaseTimerConnection = nil
local currentTab = "Main"

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Devs_SyncStealGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ScreenParent

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Borda Gradiente
local BorderGradient = Instance.new("UIStroke")
BorderGradient.Name = "BorderGradient"
BorderGradient.Color = Color3.fromRGB(100, 100, 255)
BorderGradient.Thickness = 2
BorderGradient.Transparency = 0.3
BorderGradient.Parent = MainFrame

-- Barra de Titulo
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 16)
TitleBarCorner.Parent = TitleBar

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0, 16)
TitleBarFix.Position = UDim2.new(0, 0, 1, -16)
TitleBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 36, 0, 36)
LogoFrame.Position = UDim2.new(0, 12, 0.5, -18)
LogoFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = TitleBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = LogoFrame

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255))
}
LogoGradient.Rotation = 45
LogoGradient.Parent = LogoFrame

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "D"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBold
LogoText.Parent = LogoFrame

-- Titulo
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 56, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Devs Sync"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 150, 0, 14)
Subtitle.Position = UDim2.new(0, 56, 0, 26)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Premium Edition"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

-- Botao Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

-- Botao Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Botao Fechar e Minimizar: implementar comportamento
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        SavedMainSize = MainFrame.Size
        SavedMainPosition = MainFrame.Position
        isMinimized = true
        TweenService:Create(MainFrame, TweenInfo.new(0.18), {Size = UDim2.new(0, 320, 0, 50)}):Play()
        TabsContainer.Visible = false
        ContentContainer.Visible = false
        BorderGradient.Transparency = 1
    else
        isMinimized = false
        if SavedMainSize then
            TweenService:Create(MainFrame, TweenInfo.new(0.18), {Size = SavedMainSize}):Play()
        end
        TabsContainer.Visible = true
        ContentContainer.Visible = true
        BorderGradient.Transparency = 0.3
    end
end)

-- Painel de Erros (toggle) para capturar mensagens do console
local recentErrors = {}
local function addRecentError(msg)
    table.insert(recentErrors, 1, msg)
    if #recentErrors > 30 then
        for i = 31, #recentErrors do recentErrors[i] = nil end
    end
end

local ErrorsBtn = Instance.new("TextButton")
ErrorsBtn.Size = UDim2.new(0, 28, 0, 28)
ErrorsBtn.Position = UDim2.new(1, -114, 0.5, -14)
ErrorsBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ErrorsBtn.BorderSizePixel = 0
ErrorsBtn.Text = "!"
ErrorsBtn.TextColor3 = Color3.fromRGB(255,255,255)
ErrorsBtn.TextSize = 16
ErrorsBtn.Font = Enum.Font.GothamBold
ErrorsBtn.Parent = TitleBar

local ErrorFrame = Instance.new("Frame")
ErrorFrame.Size = UDim2.new(0, 420, 0, 220)
ErrorFrame.Position = UDim2.new(1, -440, 0, 60)
ErrorFrame.BackgroundColor3 = Color3.fromRGB(20,20,26)
ErrorFrame.BorderSizePixel = 0
ErrorFrame.Visible = false
ErrorFrame.Parent = MainFrame

local errCorner = Instance.new("UICorner")
errCorner.CornerRadius = UDim.new(0, 8)
errCorner.Parent = ErrorFrame

local errBox = Instance.new("TextBox")
errBox.MultiLine = true
errBox.ClearTextOnFocus = false
errBox.Size = UDim2.new(1, -12, 1, -12)
errBox.Position = UDim2.new(0, 6, 0, 6)
errBox.BackgroundTransparency = 1
errBox.TextColor3 = Color3.fromRGB(230,230,230)
errBox.TextWrapped = true
errBox.TextXAlignment = Enum.TextXAlignment.Left
errBox.TextYAlignment = Enum.TextYAlignment.Top
errBox.Font = Enum.Font.Gotham
errBox.TextSize = 12
errBox.Text = ""
errBox.Parent = ErrorFrame

ErrorsBtn.MouseButton1Click:Connect(function()
    ErrorFrame.Visible = not ErrorFrame.Visible
    if ErrorFrame.Visible then
        errBox.Text = table.concat(recentErrors, "\n\n")
    end
end)

LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError or messageType == Enum.MessageType.MessageWarning or messageType == Enum.MessageType.MessageInfo then
        addRecentError(os.date("%X") .. " — " .. tostring(message))
        if ErrorFrame.Visible then
            errBox.Text = table.concat(recentErrors, "\n\n")
        end
    end
end)

-- Drag para mover o flutuante
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sistema de Abas
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -24, 0, 44)
TabsContainer.Position = UDim2.new(0, 12, 0, 62)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

local TabsList = Instance.new("UIListLayout")
TabsList.FillDirection = Enum.FillDirection.Horizontal
TabsList.Padding = UDim.new(0, 6)
TabsList.SortOrder = Enum.SortOrder.LayoutOrder
TabsList.Parent = TabsContainer

-- Conteudo das Abas
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -24, 1, -118)
ContentContainer.Position = UDim2.new(0, 12, 0, 112)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ==================== TODAS AS FUNCOES DE CORE ====================

-- Função auxiliar: SetCharacterCollisions
local function SetCharacterCollisions(char, canCollide)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = canCollide
        end
    end
end

-- Função auxiliar: SafeTeleport
local function SafeTeleport(char, targetCFrame)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local prevNoclip = CustomSettings.NoclipEnabled

    SetCharacterCollisions(char, false)
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame + Vector3.new(0, 5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
    task.wait(0.12)
    
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
    task.wait(0.08)

    -- Always restore collisions unless noclip is active
    if not prevNoclip then
        SetCharacterCollisions(char, true)
    end
end

-- Função auxiliar: RemoveExternalForces
local function RemoveExternalForces(char)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, fx in pairs(part:GetChildren()) do
                if fx:IsA("BodyVelocity") or fx:IsA("BodyForce") or fx:IsA("BodyGyro") or fx:IsA("BodyAngularVelocity") or fx:IsA("VectorForce") or fx:IsA("LinearVelocity") then
                    pcall(function() fx:Destroy() end)
                end
            end
            pcall(function()
                part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                part.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end)
        end
    end
end

-- ==================== FUNCOES GLOBAIS ====================

function CreateESP()
    ClearESP()
    if not CustomSettings.ESPEnabled then return end
    
    for _, data in pairs(foundFNAFs) do
        if data.FNaFPosition and data.FNaFPosition.Parent then
            local esp = Instance.new("BillboardGui")
            esp.Name = "FNaFESP"
            esp.Adornee = data.FNaFPosition
            esp.Size = UDim2.new(0, 120, 0, 50)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.AlwaysOnTop = true
            esp.Parent = data.FNaFPosition
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = CustomSettings.ESPColor
            frame.BackgroundTransparency = 0.6
            frame.BorderSizePixel = 0
            frame.Parent = esp
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -8, 1, -8)
            text.Position = UDim2.new(0, 4, 0, 4)
            text.BackgroundTransparency = 1
            text.Text = "🎮 " .. data.Owner .. "\n" .. data.SlotName
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 11
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = 0.5
            text.TextWrapped = true
            text.Parent = frame
            
            table.insert(espElements, esp)
        end
    end
end

function ClearESP()
    for _, esp in pairs(espElements) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    espElements = {}
end

function CreateBaseTimerESP()
    ClearBaseTimerESP()
    if not CustomSettings.BaseTimerESPEnabled then return end
    if not Workspace:FindFirstChild("Bases") then return end

    local function FindAdorneeForModel(model)
        if not model then return nil end
        if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then
            return model.PrimaryPart
        end
        local names = {"Base", "Root", "HumanoidRootPart", "BasePart"}
        for _, name in pairs(names) do
            local part = model:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                return part
            end
        end
        for _, desc in pairs(model:GetDescendants()) do
            if desc:IsA("BasePart") then
                return desc
            end
        end
        return nil
    end

    local function FormatTime(t)
        if not t then return "—" end
        if t <= 0 then return "Aberto" end
        local minutes = math.floor(t/60)
        local seconds = math.floor(t%60)
        return string.format("%02d:%02d", minutes, seconds)
    end

    for _, base in pairs(Workspace.Bases:GetChildren()) do
        local adornee = FindAdorneeForModel(base)
        if adornee then
            local gui = Instance.new("BillboardGui")
            gui.Name = "BaseTimerESP"
            gui.Adornee = adornee
            gui.Size = UDim2.new(0, 140, 0, 40)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.AlwaysOnTop = true
            gui.Parent = adornee

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = gui

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -8, 0, 16)
            nameLabel.Position = UDim2.new(0, 4, 0, 2)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = base.Name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Center
            nameLabel.Parent = frame

            local timerLabel = Instance.new("TextLabel")
            timerLabel.Size = UDim2.new(1, -8, 0, 18)
            timerLabel.Position = UDim2.new(0, 4, 0, 18)
            timerLabel.BackgroundTransparency = 1
            timerLabel.Text = "--:--"
            timerLabel.TextColor3 = Color3.fromRGB(200,200,200)
            timerLabel.TextSize = 10
            timerLabel.Font = Enum.Font.Gotham
            timerLabel.TextXAlignment = Enum.TextXAlignment.Center
            timerLabel.Parent = frame

            table.insert(baseTimerElements, {Base = base, Gui = gui, TimerLabel = timerLabel})
        end
    end

    if BaseTimerConnection then BaseTimerConnection:Disconnect() end
    BaseTimerConnection = RunService.Heartbeat:Connect(function()
        for _, entry in pairs(baseTimerElements) do
            local base = entry.Base
            local timerLabel = entry.TimerLabel
            if base and base.Parent and timerLabel then
                local remaining = nil
                local nv = base:FindFirstChild("OpenTime") or base:FindFirstChild("OpenCooldown") or base:FindFirstChild("NextOpen")
                if nv and nv:IsA("NumberValue") then
                    remaining = nv.Value
                else
                        local attr = base:GetAttribute("NextOpen") or base:GetAttribute("OpenAt")
                    if type(attr) == "number" then
                        remaining = attr - tick()
                    end
                end

                local function FormatTimeInner(t)
                    if not t then return "—" end
                    if t <= 0 then return "Aberto" end
                    local minutes = math.floor(t/60)
                    local seconds = math.floor(t%60)
                    return string.format("%02d:%02d", minutes, seconds)
                end
                timerLabel.Text = FormatTimeInner(remaining)
            end
        end
    end)
end

function ClearBaseTimerESP()
    if BaseTimerConnection then
        BaseTimerConnection:Disconnect()
        BaseTimerConnection = nil
    end
    for _, entry in pairs(baseTimerElements) do
        if entry.Gui and entry.Gui.Parent then
            entry.Gui:Destroy()
        end
    end
    baseTimerElements = {}
end

function EnableNoclip()
    if NoclipConnection then return end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if CustomSettings.NoclipEnabled then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

function EnableSpeed()
    if SpeedConnection then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CustomSettings.SpeedValue
    end
    
    SpeedConnection = RunService.Heartbeat:Connect(function()
        if CustomSettings.SpeedEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                if char.Humanoid.WalkSpeed ~= CustomSettings.SpeedValue then
                    char.Humanoid.WalkSpeed = CustomSettings.SpeedValue
                end
            end
        end
    end)
end

function DisableSpeed()
    if SpeedConnection then
        SpeedConnection:Disconnect()
        SpeedConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end

-- Invisibility helpers (robust storage + reconnect)
local invisSaved = {parts = {}, conn = nil, char = nil}

local function SaveAndHideCharacter(char)
    if not char then return end
    invisSaved.char = char
    invisSaved.parts = invisSaved.parts or {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if not invisSaved.parts[part] then
                invisSaved.parts[part] = {
                    Transparency = part.Transparency,
                    LocalTransparencyModifier = part.LocalTransparencyModifier
                }
            end
            pcall(function()
                part.Transparency = 1
                pcall(function() part.LocalTransparencyModifier = 1 end)
            end)
        elseif part:IsA("Decal") or part:IsA("Texture") then
            if not invisSaved.parts[part] then
                invisSaved.parts[part] = {Transparency = part.Transparency}
            end
            pcall(function() part.Transparency = 1 end)
        end
    end
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function() hrp.LocalTransparencyModifier = 1 end) end
    end)
end

local function RestoreCharacterVisibility()
    local char = invisSaved.char
    if not char then return end
    for inst, vals in pairs(invisSaved.parts or {}) do
        if inst and inst.Parent then
            pcall(function()
                if vals.Transparency ~= nil then inst.Transparency = vals.Transparency end
                if vals.LocalTransparencyModifier ~= nil and inst:IsA("BasePart") then
                    pcall(function() inst.LocalTransparencyModifier = vals.LocalTransparencyModifier end)
                end
            end)
        end
    end
    invisSaved.parts = {}
    invisSaved.char = nil
    -- no humanoid changes restored; invisibility is visual-only to avoid physics issues
end

function EnableInvisibility()
    CustomSettings.InvisibilityEnabled = true
    local char = LocalPlayer.Character
    if char then SaveAndHideCharacter(char) end
    if invisSaved.conn then
        pcall(function() invisSaved.conn:Disconnect() end)
        invisSaved.conn = nil
    end
    if char then
        invisSaved.conn = char.DescendantAdded:Connect(function()
            if CustomSettings.InvisibilityEnabled then
                task.wait(0.02)
                SaveAndHideCharacter(LocalPlayer.Character)
            end
        end)
    end
end

function DisableInvisibility()
    CustomSettings.InvisibilityEnabled = false
    if invisSaved.conn then
        pcall(function() invisSaved.conn:Disconnect() end)
        invisSaved.conn = nil
    end
    RestoreCharacterVisibility()
end

local function RagdollPlayer(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    spawn(function()
        pcall(function()
            local pushDir = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or hrp.Position))
            if pushDir and pushDir.Magnitude > 0 then
                pushDir = pushDir.Unit
            else
                pushDir = Vector3.new(math.random(-1,1), 0.5, math.random(-1,1)).Unit
            end

            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
            bv.Velocity = pushDir * 140 + Vector3.new(0, -40, 0)
            bv.P = 2000
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.8)

            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(2e6, 2e6, 2e6)
            ba.AngularVelocity = Vector3.new(math.random(-120,120), math.random(-120,120), math.random(-120,120))
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 0.8)

            -- small secondary shock after a short delay
            task.delay(0.08, function()
                pcall(function()
                    if hrp and hrp.Parent then
                        hrp.AssemblyLinearVelocity = (pushDir * 60) + Vector3.new(0, -120, 0)
                    end
                end)
            end)
        end)
    end)
    
    spawn(function()
        pcall(function()
            for _, joint in pairs(char:GetDescendants()) do
                if joint:IsA("Motor6D") or joint:IsA("Motor") then
                    joint.Enabled = false
                    task.delay(0.05, function()
                        if joint and joint.Parent then
                            joint.Enabled = true
                        end
                    end)
                end
            end
        end)
    end)
    
    spawn(function()
        pcall(function()
            pcall(function() humanoid:TakeDamage(20) end)
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll) end)
            pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false) end)
            pcall(function() humanoid.PlatformStand = true end)

            task.delay(1.2, function()
                if humanoid and humanoid.Parent then
                    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                    pcall(function() humanoid.PlatformStand = false end)
                end
            end)
        end)
    end)
    
    spawn(function()
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(math.random(-10,10), -40, math.random(-10,10))
            hrp.AssemblyAngularVelocity = Vector3.new(math.random(-30, 30), math.random(-30, 30), math.random(-30, 30))
        end)
    end)
    
    spawn(function()
        pcall(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local vb = Instance.new("BodyVelocity")
                    vb.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    vb.Velocity = Vector3.new(math.random(-60, 60), -80, math.random(-60, 60))
                    vb.P = 2000
                    vb.Parent = part
                    game:GetService("Debris"):AddItem(vb, 0.6)
                end
            end
        end)
    end)

    -- Forcar queda para o chao (tentativa extra)
    spawn(function()
        pcall(function()
            local down = Instance.new("BodyVelocity")
            down.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            down.Velocity = Vector3.new(0, -150, 0)
            down.P = 1250
            down.Parent = hrp
            game:GetService("Debris"):AddItem(down, 0.6)
        end)
    end)

    spawn(function()
        task.delay(1.5, function()
            if humanoid and humanoid.Parent then
                pcall(function() humanoid.PlatformStand = false end)
            end
        end)
    end)
end

function EnableRagdollAura()
    if RagdollAuraConnection then return end
    
    RagdollAuraConnection = RunService.Heartbeat:Connect(function()
        if not CustomSettings.RagdollAuraEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = player.Character
                if targetChar then
                    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local distance = (hrp.Position - targetHrp.Position).Magnitude
                        if distance <= CustomSettings.RagdollDistance then
                            local currentTime = tick()
                            if not ragdollCooldowns[player.UserId] or (currentTime - ragdollCooldowns[player.UserId]) > 0.2 then
                                ragdollCooldowns[player.UserId] = currentTime
                                RagdollPlayer(player)
                            end
                        end
                    end
                end
            end
        end
    end)
end

function DisableRagdollAura()
    if RagdollAuraConnection then
        RagdollAuraConnection:Disconnect()
        RagdollAuraConnection = nil
    end
    ragdollCooldowns = {}
end

function LaunchAttacker(player)
    if not player or player == LocalPlayer then return end

    if type(player) ~= "userdata" or not player:IsA("Player") then return end

    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    spawn(function()
        pcall(function()
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dir = Vector3.new(math.random(-0.5,0.5), 1, math.random(-0.5,0.5)).Unit
            if myHrp then
                local diff = hrp.Position - myHrp.Position
                if diff.Magnitude > 0.1 then
                    dir = diff.Unit + Vector3.new(0, 0.6, 0)
                end
            end

            local launchVelocity = dir.Unit * 200 + Vector3.new(0, 200, 0)

            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = launchVelocity
            bv.P = 1250
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 1)

            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            ba.AngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 1)

            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
                humanoid.Sit = true
                humanoid.PlatformStand = true
            end)

            pcall(function()
                hrp.AssemblyLinearVelocity = launchVelocity
                hrp.AssemblyAngularVelocity = Vector3.new(math.random(-20,20), math.random(-20,20), math.random(-20,20))
            end)

            task.delay(3, function()
                if humanoid and humanoid.Parent then
                    humanoid.PlatformStand = false
                end
            end)
        end)
    end)
end

local lastHealth = nil

function EnableAntiDamage()
    if AntiDamageConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    lastHealth = humanoid.Health
    
    AntiDamageConnection = humanoid.HealthChanged:Connect(function(health)
        if not CustomSettings.AntiDamageEnabled then return end

        if health < lastHealth then
            local damageTaken = lastHealth - health

            pcall(function() humanoid.Health = humanoid.MaxHealth end)

            local myChar = LocalPlayer.Character
            if myChar then
                RemoveExternalForces(myChar)
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    pcall(function()
                        myHrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        myHrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                        myHrp.Velocity = Vector3.new(0,0,0)
                    end)
                end

                -- Check for limbo fall immediately without extra PlatformStand
                task.delay(0.06, function()
                    local hrpNow = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if hrpNow and hrpNow.Parent then
                        if hrpNow.Position.Y < -50 then
                            if SavedBasePosition then
                                SafeTeleport(myChar, SavedBasePosition)
                            else
                                SafeTeleport(myChar, hrpNow.CFrame + Vector3.new(0,50,0))
                            end
                        end
                    end
                end)
            end

            spawn(function()
                pcall(function()
                    local myChar2 = LocalPlayer.Character
                    if not myChar2 then return end

                    local hrp = myChar2:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    local closestPlayer = nil
                    local closestDistance = 50

                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local targetChar = player.Character
                            if targetChar then
                                local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                                if targetHrp then
                                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end

                    if closestPlayer then
                        LaunchAttacker(closestPlayer)
                    end
                end)
            end)
        end

        lastHealth = health
    end)
    
    local healthCheckConnection = RunService.Heartbeat:Connect(function()
        if not CustomSettings.AntiDamageEnabled then 
            healthCheckConnection:Disconnect()
            return 
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

function DisableAntiDamage()
    if AntiDamageConnection then
        AntiDamageConnection:Disconnect()
        AntiDamageConnection = nil
    end
    lastHealth = nil
end

function FindFNAFs()
    foundFNAFs = {}
    if not Workspace:FindFirstChild("Bases") then return end

    for _, base in pairs(Workspace.Bases:GetChildren()) do
        if base.Name == LocalPlayer.Name then
            -- skip own base
        else
            -- search for any part named or functioning as FNaFPosition inside the base
            for _, desc in pairs(base:GetDescendants()) do
                if desc:IsA("BasePart") and (desc.Name == "FNaFPosition" or (type(desc.Name) == "string" and desc.Name:lower():find("fnafposition"))) then
                    local slot = desc.Parent
                    local fnafPosition = desc
                    -- try to find an Attachment on the part
                    local attachment = nil
                    for _, c in pairs(fnafPosition:GetChildren()) do
                        if c:IsA("Attachment") then
                            attachment = c
                            break
                        end
                    end

                    -- try to find a proximity prompt (SellAndSteal) in the attachment or nearby
                    local sellAndSteal = nil
                    if attachment then
                        sellAndSteal = attachment:FindFirstChild("SellAndSteal") or attachment:FindFirstChildOfClass("ProximityPrompt")
                    end
                    if not sellAndSteal then
                        -- search descendants of the slot for a ProximityPrompt named SellAndSteal
                        if slot then
                            for _, sdesc in pairs(slot:GetDescendants()) do
                                if sdesc:IsA("ProximityPrompt") then
                                    sellAndSteal = sdesc
                                    break
                                end
                            end
                        end
                    end

                    -- determine if slot contains a FNAF model
                    local hasFNAF = false
                    if slot then
                        for _, child in pairs(slot:GetChildren()) do
                            if child:IsA("Model") and child.Name ~= "FNaFPosition" then
                                hasFNAF = true
                                break
                            end
                        end
                    end

                    if sellAndSteal and hasFNAF then
                        table.insert(foundFNAFs, {
                            Owner = base.Name,
                            SlotName = slot and slot.Name or "Unknown",
                            FNaFPosition = fnafPosition,
                            Prompt = sellAndSteal
                        })
                    end
                end
            end
        end
    end
end

function StealFNAF(data)
    if isWorking then return end
    
    if not SavedBasePosition then
        StatusLabel.Text = "❌ Salve a base primeiro!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
        return
    end
    
    isWorking = true
    local char = LocalPlayer.Character
    
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        StatusLabel.Text = "❌ Erro no personagem!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
        isWorking = false
        return
    end
    
    if not data.FNaFPosition or not data.FNaFPosition.Parent or not data.Prompt or not data.Prompt.Parent then
        StatusLabel.Text = "⚠️ FNAF sumiu!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 100)
        isWorking = false
        UpdateList()
        return
    end
    
    StatusLabel.Text = "🚀 Indo para o FNAF..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    local fnafPos = data.FNaFPosition.Position
    SafeTeleport(char, CFrame.new(fnafPos + Vector3.new(0, 3, 3)))
    
    wait(0.2)
    
    StatusLabel.Text = "💎 Pegando FNAF..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
    
    pcall(function()
        for i = 1, 3 do
            if data.Prompt and data.Prompt.Parent then
                fireproximityprompt(data.Prompt)
                wait(0.1)
            end
        end
    end)
    
    wait(0.15)
    
    StatusLabel.Text = "🏠 Voltando para base..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 220)
    
    SafeTeleport(char, SavedBasePosition)
    
    wait(0.3)
    
    StatusLabel.Text = "✅ FNAF roubado com sucesso!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    
    isWorking = false
    UpdateList()
end

function UpdateList()
    for _, btn in pairs(ScrollFrame:GetChildren()) do
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then
            btn:Destroy()
        end
    end
    
    FindFNAFs()
    
    if #foundFNAFs == 0 then
        local noFNAF = Instance.new("TextLabel")
        noFNAF.Size = UDim2.new(1, -8, 0, 38)
        noFNAF.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        noFNAF.BorderSizePixel = 0
        noFNAF.Text = "😴 Nenhum FNAF encontrado"
        noFNAF.TextColor3 = Color3.fromRGB(160, 160, 180)
        noFNAF.TextSize = 10
        noFNAF.Font = Enum.Font.Gotham
        noFNAF.Parent = ScrollFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = noFNAF
    else
        for _, fnafData in pairs(foundFNAFs) do
            CreateFNAFButton(fnafData)
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    
    if CustomSettings.ESPEnabled then
        CreateESP()
    end
end

function CreateFNAFButton(data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 4, 0.5, -15)
    icon.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    icon.BorderSizePixel = 0
    icon.Text = "🎮"
    icon.TextSize = 16
    icon.Parent = btn
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = icon
    
    local ownerLabel = Instance.new("TextLabel")
    ownerLabel.Size = UDim2.new(1, -46, 0, 16)
    ownerLabel.Position = UDim2.new(0, 40, 0, 4)
    ownerLabel.BackgroundTransparency = 1
    ownerLabel.Text = data.Owner
    ownerLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    ownerLabel.TextSize = 11
    ownerLabel.Font = Enum.Font.GothamBold
    ownerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ownerLabel.Parent = btn
    
    local slotLabel = Instance.new("TextLabel")
    slotLabel.Size = UDim2.new(1, -46, 0, 14)
    slotLabel.Position = UDim2.new(0, 40, 0, 20)
    slotLabel.BackgroundTransparency = 1
    slotLabel.Text = data.SlotName
    slotLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    slotLabel.TextSize = 9
    slotLabel.Font = Enum.Font.Gotham
    slotLabel.TextXAlignment = Enum.TextXAlignment.Left
    slotLabel.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if not isWorking then
            StealFNAF(data)
        end
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
    end)
end

-- ==================== FUNCOES DE UI ====================

-- Criar Aba
local function CreateTab(name, icon, order)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(0, 70, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tab.BorderSizePixel = 0
    tab.Text = ""
    tab.LayoutOrder = order
    tab.Parent = TabsContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tab
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tab
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Position = UDim2.new(0, 0, 1, -16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
    nameLabel.TextSize = 8
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = tab
    
    return tab, iconLabel, nameLabel
end

-- Criar Conteudo da Aba
local function CreateTabContent(name)
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    content.Visible = false
    content.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    return content
end

-- Criar Card
local function CreateCard(parent, title, description)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = card
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = card
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 16)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 1
    titleLabel.Parent = card
    
    if description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 12)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        descLabel.TextSize = 9
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.LayoutOrder = 2
        descLabel.Parent = card
    end
    
    return card
end

-- Criar Toggle Moderno
local function CreateModernToggle(parent, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundTransparency = 1
    container.LayoutOrder = 100
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 44, 0, 24)
    toggleButton.Position = UDim2.new(1, -44, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(60, 60, 75)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local enabled = default
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(60, 60, 75)
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
    end)
    
    return container
end

-- Criar Slider Moderno
local function CreateModernSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundTransparency = 1
    container.LayoutOrder = 101
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 10
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 20)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = container
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local dragging = false
    
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. value
        callback(value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    return container
end

-- Criar Botao
local function CreateButton(parent, text, icon, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    button.BorderSizePixel = 0
    button.Text = ""
    button.LayoutOrder = 102
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
    }
    gradient.Rotation = 45
    gradient.Parent = button
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -40, 1, 0)
    buttonText.Position = UDim2.new(0, 40, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = text
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 12
    buttonText.Font = Enum.Font.GothamBold
    buttonText.Parent = button
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 16
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(120, 120, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        }):Play()
    end)
    
    return button
end

-- ==================== CRIAR ABAS ====================

local mainTab, mainIcon, mainName = CreateTab("Main", "🏠", 1)
local movementTab, movementIcon, movementName = CreateTab("Move", "🚀", 2)
local combatTab, combatIcon, combatName = CreateTab("Combat", "⚔️", 3)
local visualTab, visualIcon, visualName = CreateTab("Visual", "👁️", 4)

local mainContent = CreateTabContent("Main")
local movementContent = CreateTabContent("Move")
local combatContent = CreateTabContent("Combat")
local visualContent = CreateTabContent("Visual")

-- Trocar Aba
local function SwitchTab(tabName)
    currentTab = tabName
    
    -- Esconder todos os conteudos
    mainContent.Visible = false
    movementContent.Visible = false
    combatContent.Visible = false
    visualContent.Visible = false
    
    -- Resetar cores das abas
    for _, tab in pairs(TabsContainer:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            for _, child in pairs(tab:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = Color3.fromRGB(160, 160, 180)
                end
            end
        end
    end
    
    -- Ativar aba selecionada
    if tabName == "Main" then
        mainContent.Visible = true
        mainTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        mainIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Move" then
        movementContent.Visible = true
        movementTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        movementIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        movementName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Combat" then
        combatContent.Visible = true
        combatTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        combatIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        combatName.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tabName == "Visual" then
        visualContent.Visible = true
        visualTab.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        visualIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        visualName.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Conectar cliques das abas
mainTab.MouseButton1Click:Connect(function() SwitchTab("Main") end)
movementTab.MouseButton1Click:Connect(function() SwitchTab("Move") end)
combatTab.MouseButton1Click:Connect(function() SwitchTab("Combat") end)
visualTab.MouseButton1Click:Connect(function() SwitchTab("Visual") end)

-- ==================== ABA MAIN ====================

local statusCard = CreateCard(mainContent, "📍 Status", nil)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 28)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = "💾 Salve sua base primeiro!"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.LayoutOrder = 103
StatusLabel.Parent = statusCard

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = StatusLabel

local baseCard = CreateCard(mainContent, "🏠 Controle de Base", "Salve a posição da sua base")

CreateButton(baseCard, "Salvar Base", "💾", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        SavedBasePosition = char.HumanoidRootPart.CFrame
        StatusLabel.Text = "✅ Base salva com sucesso!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        StatusLabel.Text = "❌ Erro ao salvar base!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    end
end)

CreateButton(baseCard, "Voltar para Base", "🏠", function()
    if SavedBasePosition then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = SavedBasePosition
            StatusLabel.Text = "✅ Teleportado para base!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
    else
        StatusLabel.Text = "⚠️ Salve sua base primeiro!"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 150, 100)
    end
end)

local fnafCard = CreateCard(mainContent, "🎮 FNAFs Disponíveis", "Clique para roubar")

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0, 200)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
ScrollFrame.LayoutOrder = 103
ScrollFrame.Parent = fnafCard

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = ScrollFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 6)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.PaddingLeft = UDim.new(0, 4)
ListPadding.PaddingRight = UDim.new(0, 4)
ListPadding.Parent = ScrollFrame

CreateButton(fnafCard, "Atualizar Lista", "🔄", function()
    UpdateList()
end)

-- ==================== ABA MOVEMENT ====================

local noclipCard = CreateCard(movementContent, "👻 Noclip", "Atravesse paredes")

CreateModernToggle(noclipCard, "Ativar Noclip", CustomSettings.NoclipEnabled, function(enabled)
    CustomSettings.NoclipEnabled = enabled
    if enabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)

local speedCard = CreateCard(movementContent, "⚡ Speed", "Corra muito mais rápido")

CreateModernToggle(speedCard, "Ativar Speed", CustomSettings.SpeedEnabled, function(enabled)
    CustomSettings.SpeedEnabled = enabled
    if enabled then
        EnableSpeed()
    else
        DisableSpeed()
    end
end)

CreateModernSlider(speedCard, "Velocidade", 16, 200, CustomSettings.SpeedValue, function(value)
    CustomSettings.SpeedValue = value
    if CustomSettings.SpeedEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
end)

-- ==================== ABA COMBAT ====================

local antiDamageCard = CreateCard(combatContent, "🛡️ Anti-Damage", "Reflita o dano e lance atacantes para fora")

CreateModernToggle(antiDamageCard, "Ativar Anti-Damage", CustomSettings.AntiDamageEnabled, function(enabled)
    CustomSettings.AntiDamageEnabled = enabled
    if enabled then
        EnableAntiDamage()
    else
        DisableAntiDamage()
    end
end)

local ragdollCard = CreateCard(combatContent, "💥 Ragdoll Aura", "Derruba jogadores próximos")

CreateModernToggle(ragdollCard, "Ativar Ragdoll Aura", CustomSettings.RagdollAuraEnabled, function(enabled)
    CustomSettings.RagdollAuraEnabled = enabled
    if enabled then
        EnableRagdollAura()
    else
        DisableRagdollAura()
    end
end)

CreateModernSlider(ragdollCard, "Distância", 5, 30, CustomSettings.RagdollDistance, function(value)
    CustomSettings.RagdollDistance = value
end)

-- Toggle Invisibilidade (local)
CreateModernToggle(ragdollCard, "Tornar Invisível (local)", CustomSettings.InvisibilityEnabled, function(enabled)
    CustomSettings.InvisibilityEnabled = enabled
    if enabled then
        EnableInvisibility()
    else
        DisableInvisibility()
    end
end)

-- ==================== ABA VISUAL ====================

local espCard = CreateCard(visualContent, "👁️ ESP FNAFs", "Veja FNAFs através das paredes")

CreateModernToggle(espCard, "Ativar ESP", CustomSettings.ESPEnabled, function(enabled)
    CustomSettings.ESPEnabled = enabled
    if enabled then
        CreateESP()
    else
        ClearESP()
    end
end)

local borderCard = CreateCard(visualContent, "🌈 Borda RGB", "Borda colorida animada")

CreateModernToggle(borderCard, "Ativar Borda RGB", CustomSettings.BorderEnabled, function(enabled)
    CustomSettings.BorderEnabled = enabled
    BorderGradient.Thickness = enabled and 2 or 0
end)

CreateModernSlider(borderCard, "Velocidade", 1, 10, CustomSettings.BorderSpeed, function(value)
    CustomSettings.BorderSpeed = value
end)

-- Botao: ESP Timer para bases
CreateButton(visualContent, "ESP Timer", "⏱️", function()
    CustomSettings.BaseTimerESPEnabled = not CustomSettings.BaseTimerESPEnabled
    if CustomSettings.BaseTimerESPEnabled then
        CreateBaseTimerESP()
        StatusLabel.Text = "⏱️ ESP Timer ativado"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        ClearBaseTimerESP()
        StatusLabel.Text = "⏱️ ESP Timer desativado"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 180, 100)
    end
end)

-- Atualizar canvas size
mainContent.CanvasSize = UDim2.new(0, 0, 0, mainContent.UIListLayout.AbsoluteContentSize.Y + 12)
movementContent.CanvasSize = UDim2.new(0, 0, 0, movementContent.UIListLayout.AbsoluteContentSize.Y + 12)
combatContent.CanvasSize = UDim2.new(0, 0, 0, combatContent.UIListLayout.AbsoluteContentSize.Y + 12)
visualContent.CanvasSize = UDim2.new(0, 0, 0, visualContent.UIListLayout.AbsoluteContentSize.Y + 12)

-- Ativar primeira aba
SwitchTab("Main")

-- ==================== MANTER CONFIGS AO RESPAWN ====================

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    wait(0.1)
    
    if CustomSettings.SpeedEnabled then
        EnableSpeed()
    end
    
    if CustomSettings.NoclipEnabled then
        EnableNoclip()
    end
    
    if CustomSettings.RagdollAuraEnabled then
        EnableRagdollAura()
    end
    
    if CustomSettings.AntiDamageEnabled then
        EnableAntiDamage()
    end

    if CustomSettings.InvisibilityEnabled then
        EnableInvisibility()
    end
end)

-- ==================== INICIALIZAR ====================

UpdateList()

end) -- fechamento do pcall

if not success then
    warn("❌ ERRO ao carregar script: " .. tostring(err))
else
    print("🎮 Script Devs_Sync carregado com sucesso!")
end
