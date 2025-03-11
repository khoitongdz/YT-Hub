-- HOAN TOAN VIET LAI SCRIPT BLOX FRUITS
-- HO TRO FULL EXECUTOR + TOI UU HIEU SUAT

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local task = task -- Tối ưu hiệu suất

-- Kiểm tra executor để đảm bảo tương thích
local executor = "Unknown"
if syn then executor = "Synapse X" elseif fluxus then executor = "Fluxus" elseif is_protosmasher_loaded then executor = "ProtoSmasher" elseif KRNL_LOADED then executor = "KRNL" elseif secure_load then executor = "Script-Ware" end
print("[INFO] Script chạy trên executor: " .. executor)

-- UI chinh (Giao diện mới)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "KenonHubV2"

-- Khung UI chính
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

-- Tiêu đề UI
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚔️ Blox Fruits - Auto Hub ⚔️"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Logo mở UI
local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(0, 20, 0, 20)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://126229665034471"
logoButton.Parent = screenGui

-- Hiệu ứng bật/tắt UI
local isUIOpen = true
local function toggleUI()
    isUIOpen = not isUIOpen
    if isUIOpen then
        mainFrame.Visible = true
        tweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
    else
        local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            if not isUIOpen then mainFrame.Visible = false end
        end)
    end
end
logoButton.MouseButton1Click:Connect(toggleUI)

-- Tạo nút bật/tắt (UI mới đẹp hơn)
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

-- Fast Attack Siêu Nhanh + Tăng Tầm Đánh Tự Động
createButton("⚡ Fast Attack Siêu Nhanh", 0.2, function(state)
    task.spawn(function()
        while state do
            local closestEnemy = nil
            local closestDistance = math.huge
            
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local distance = (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestEnemy = enemy
                        closestDistance = distance
                    end
                end
            end
            
            if closestEnemy and closestDistance <= 300 then -- Tăng tầm đánh lên 300
                player.Character.HumanoidRootPart.CFrame = CFrame.new(closestEnemy.HumanoidRootPart.Position) * CFrame.new(0, 0, -3)
                replicatedStorage.Remotes.CommF_:InvokeServer("StartAttack")
            end
            
            task.wait(0.002) -- Giảm delay để đánh siêu nhanh
        end
    end)
end)

-- ESP Player (Tối ưu hóa hiệu suất)
createButton("👀 ESP Player", 0.6, function(state)
    task.spawn(function()
        while state do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = v.Character:FindFirstChild("HumanoidRootPart")
                        box.Size = Vector3.new(4, 6, 4)
                        box.Color3 = Color3.new(1, 0, 0)
                        box.Transparency = 0.5
                        box.AlwaysOnTop = true
                        box.Name = "ESPBox"
                        box.Parent = v.Character
                    end
                end
            end
            task.wait(1)
        end
    end)
end)
