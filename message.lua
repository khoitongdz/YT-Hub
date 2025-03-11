--By: khoitongdz
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local task = task

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "BloxFruitsHubV2"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 25, 0, 25)
logoButton.Position = UDim2.new(0, 10, 0, 10)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://126229665034471"
logoButton.Parent = screenGui

local isUIOpen = true
local function toggleUI()
    isUIOpen = not isUIOpen
    mainFrame.Visible = isUIOpen
end
logoButton.MouseButton1Click:Connect(toggleUI)

local FPSLabel = Instance.new("TextLabel", screenGui)
FPSLabel.Size = UDim2.new(0, 100, 0, 30)
FPSLabel.Position = UDim2.new(1, -110, 0, 10)
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: ..."
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 18
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right

local fps = 0
runService.RenderStepped:Connect(function()
    fps = fps + 1
end)

spawn(function()
    while wait(0.5) do
        FPSLabel.Text = "FPS: " .. fps * 2  -- Tính FPS thực tế
        fps = 0
    end
end)

local function FixLag()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    game.Lighting.Brightness = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Trail") or v:IsA("Sparkles") then v:Destroy() end
        if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        if v:IsA("Sound") then v.Volume = 0 end
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.Color = Color3.fromRGB(200, 200, 200) end
        if v:IsA("MeshPart") then v.TextureID = ""; v.Color = Color3.fromRGB(200, 200, 200) end
    end
    print("✅ Fix Lag hoàn tất!")
end

local speedEnabled = false
local function ToggleSpeed()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        speedEnabled = not speedEnabled
        humanoid.WalkSpeed = speedEnabled and 300 or 260
    end
end

local jumpEnabled = false
local function ToggleJumpPower()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        jumpEnabled = not jumpEnabled
        humanoid.JumpPower = jumpEnabled and 350 or 250
    end
end

local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 45)
    button.Position = UDim2.new(0.05, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.TextSize = 18
    button.Font = Enum.Font.GothamBold
    button.Parent = mainFrame
    local enabled = false
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)
end

createButton("🛠️ Fix Lag", 0.1, FixLag)
createButton("⚡ Chạy Nhanh", 0.3, ToggleSpeed)
createButton("🔥 Nhảy Cao", 0.5, ToggleJumpPower)
