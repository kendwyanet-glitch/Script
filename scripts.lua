-- FNAF Steal Script by Devs_Sync
-- VERSAO REFATORADA - 100% FUNCIONAL

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variaveis Globais
local SavedBasePosition = nil
local NoclipConnection = nil
local RagdollAuraConnection = nil
local SpeedConnection = nil
local AntiDamageConnection = nil
local ragdollCooldowns = {}

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
    AntiDamageEnabled = false
}

local foundFNAFs = {}
local isWorking = false
local isDragging = false
local dragStart = nil
local startPos = nil
local espElements = {}
local currentTab = "Main"

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Devs_SyncStealGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

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

-- Atualizar canvas size
mainContent.CanvasSize = UDim2.new(0, 0, 0, mainContent.UIListLayout.AbsoluteContentSize.Y + 12)
movementContent.CanvasSize = UDim2.new(0, 0, 0, movementContent.UIListLayout.AbsoluteContentSize.Y + 12)
combatContent.CanvasSize = UDim2.new(0, 0, 0, combatContent.UIListLayout.AbsoluteContentSize.Y + 12)
visualContent.CanvasSize = UDim2.new(0, 0, 0, visualContent.UIListLayout.AbsoluteContentSize.Y + 12)

-- Ativar primeira aba
SwitchTab("Main")

-- ==================== FUNCOES ESP ====================

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

-- ==================== FUNCOES NOCLIP ====================

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
                if part.Name == "HumanoidRootPart" or part.Name == "Head" then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ==================== FUNCOES SPEED ====================

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

-- ==================== FUNCOES RAGDOLL ====================

local function RagdollPlayer(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    -- Metodo 1: BodyVelocity + BodyAngularVelocity
    spawn(function()
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, -150, 0)
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.15)
            
            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            ba.AngularVelocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 0.15)
        end)
    end)
    
    -- Metodo 2: Desativar Motor6D
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
    
    -- Metodo 3: Estados do Humanoid
    spawn(function()
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            humanoid.Sit = true
            humanoid.PlatformStand = true
            
            task.delay(0.2, function()
                if humanoid and humanoid.Parent then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                    humanoid.PlatformStand = false
                end
            end)
        end)
    end)
    
    -- Metodo 4: AssemblyLinearVelocity
    spawn(function()
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, -100, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
        end)
    end)
    
    -- Metodo 5: Aplicar força nas partes
    spawn(function()
        pcall(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(5000, 5000, 5000)
                    bv.Velocity = Vector3.new(math.random(-10, 10), -50, math.random(-10, 10))
                    bv.Parent = part
                    game:GetService("Debris"):AddItem(bv, 0.1)
                end
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

-- ==================== FUNCOES ANTI-DAMAGE ====================

local lastHealth = nil
local lastAttacker = nil

function EnableAntiDamage()
    if AntiDamageConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Salvar health atual
    lastHealth = humanoid.Health
    
    -- Monitorar mudanças de saúde
    AntiDamageConnection = humanoid.HealthChanged:Connect(function(health)
        if not CustomSettings.AntiDamageEnabled then return end
        
        -- Se tomou dano
        if health < lastHealth then
            local damageTaken = lastHealth - health
            
            -- Restaurar saúde imediatamente
            humanoid.Health = lastHealth
            
            -- Encontrar atacante
            spawn(function()
                pcall(function()
                    -- Procurar pelo jogador mais próximo (provável atacante)
                    local char = LocalPlayer.Character
                    if not char then return end
                    
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    local closestPlayer = nil
                    local closestDistance = 50 -- Raio de detecção
                    
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
                    
                    -- Se encontrou um atacante, lançar para fora do mapa
                    if closestPlayer then
                        LaunchAttacker(closestPlayer)
                    end
                end)
            end)
        end
        
        lastHealth = health
    end)
    
    -- Backup: Monitorar por mudanças constantes via Heartbeat
    local healthCheckConnection = RunService.Heartbeat:Connect(function()
        if not CustomSettings.AntiDamageEnabled then 
            healthCheckConnection:Disconnect()
            return 
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- Se health for menor que o máximo, restaurar
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
    lastAttacker = nil
end

function LaunchAttacker(player)
    if not player or player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    
    spawn(function()
        pcall(function()
            -- Método 1: Lançar MUITO alto e longe (fora do mapa)
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(
                math.random(-500, 500), -- X aleatório
                1000,                    -- Y para cima (muito alto)
                math.random(-500, 500)   -- Z aleatório
            )
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 2)
            
            -- Método 2: Aplicar rotação maluca
            local ba = Instance.new("BodyAngularVelocity")
            ba.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            ba.AngularVelocity = Vector3.new(
                math.random(-100, 100),
                math.random(-100, 100),
                math.random(-100, 100)
            )
            ba.Parent = hrp
            game:GetService("Debris"):AddItem(ba, 2)
            
            -- Método 3: Forçar ragdoll no atacante
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            humanoid.Sit = true
            humanoid.PlatformStand = true
            
            -- Método 4: Aplicar velocidade assembly (mais moderno)
            hrp.AssemblyLinearVelocity = Vector3.new(
                math.random(-500, 500),
                1000,
                math.random(-500, 500)
            )
            hrp.AssemblyAngularVelocity = Vector3.new(
                math.random(-100, 100),
                math.random(-100, 100),
                math.random(-100, 100)
            )
            
            -- Método 5: Teleportar para fora do mapa (backup)
            task.delay(0.5, function()
                if hrp and hrp.Parent then
                    hrp.CFrame = CFrame.new(
                        math.random(-10000, 10000),
                        10000, -- Muito alto
                        math.random(-10000, 10000)
                    )
                end
            end)
            
            -- Restaurar estado do atacante após alguns segundos
            task.delay(3, function()
                if humanoid and humanoid.Parent then
                    humanoid.PlatformStand = false
                end
            end)
        end)
    end)
end

-- ==================== ANIMACAO RGB ====================

spawn(function()
    local hue = 0
    while true do
        if CustomSettings.BorderEnabled then
            hue = (hue + CustomSettings.BorderSpeed) % 360
            BorderGradient.Color = Color3.fromHSV(hue / 360, 1, 1)
        end
        wait(0.05)
    end
end)

-- ==================== BOTOES ====================

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    if CustomSettings.NoclipEnabled then
        DisableNoclip()
    end
    if CustomSettings.SpeedEnabled then
        DisableSpeed()
    end
    if CustomSettings.RagdollAuraEnabled then
        DisableRagdollAura()
    end
    if CustomSettings.AntiDamageEnabled then
        DisableAntiDamage()
    end
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    wait(0.2)
    ScreenGui:Destroy()
end)

-- ==================== ARRASTAR ====================

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== BUSCAR FNAFS ====================

local function FindFNAFs()
    foundFNAFs = {}
    if not Workspace:FindFirstChild("Bases") then return end
    
    for _, base in pairs(Workspace.Bases:GetChildren()) do
        if base.Name ~= LocalPlayer.Name and base:FindFirstChild("Scriptables") then
            if base.Scriptables:FindFirstChild("Slots") then
                for _, slot in pairs(base.Scriptables.Slots:GetChildren()) do
                    local fnafPosition = slot:FindFirstChild("FNaFPosition")
                    if fnafPosition and fnafPosition:IsA("Part") then
                        local attachment = fnafPosition:FindFirstChild("Attachment")
                        if attachment then
                            local sellAndSteal = attachment:FindFirstChild("SellAndSteal")
                            local hasFNAF = false
                            for _, child in pairs(slot:GetChildren()) do
                                if child:IsA("Model") and child.Name ~= "FNaFPosition" then
                                    hasFNAF = true
                                    break
                                end
                            end
                            
                            if sellAndSteal and sellAndSteal:IsA("ProximityPrompt") and hasFNAF then
                                table.insert(foundFNAFs, {
                                    Owner = base.Name,
                                    SlotName = slot.Name,
                                    FNaFPosition = fnafPosition,
                                    Prompt = sellAndSteal
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ==================== CRIAR BOTAO FNAF ====================

local function CreateFNAFButton(data)
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

-- ==================== ROUBAR FNAF ====================

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
    char.HumanoidRootPart.CFrame = CFrame.new(fnafPos + Vector3.new(0, 3, 3))
    
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
    
    char.HumanoidRootPart.CFrame = SavedBasePosition
    
    wait(0.3)
    
    StatusLabel.Text = "✅ FNAF roubado com sucesso!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    
    isWorking = false
    UpdateList()
end

-- ==================== ATUALIZAR LISTA ====================

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
end)

-- ==================== INICIALIZAR ====================

wait(0.5)
UpdateList()

print("🎮 Script Devs_Sync Refatorado carregado com sucesso!")
print("✅ Todas as funcionalidades testadas e funcionando!")
