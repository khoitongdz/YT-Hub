-- Tự động phát hiện executor để tối ưu code
local executor = identifyexecutor and identifyexecutor() or "Unknown"
if executor == "Synapse X" or executor == "Script-Ware" then
    print("🔥 Đang chạy trên executor mạnh: " .. executor)
else
    print("⚠️ Đang chạy trên executor yếu: " .. executor .. ", tự động tối ưu...")
end

local player = game.Players.LocalPlayer
local tweenService = game:GetService("TweenService")

-- UI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "BloxFruitsHub"

-- Main UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = false
mainFrame.BackgroundTransparency = 1

-- Logo mở UI
local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0, 10, 0, 10)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://126229665034471" -- ID ảnh logo
logoButton.Parent = screenGui

-- Hiệu ứng mở/tắt UI
local isUIOpen = false
local function toggleUI()
    isUIOpen = not isUIOpen
    if isUIOpen then
        mainFrame.Visible = true
        tweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    else
        local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            if not isUIOpen then mainFrame.Visible = false end
        end)
    end
end
logoButton.MouseButton1Click:Connect(toggleUI)

-- Hàm tạo nút bật/tắt
local function createToggle(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.Position = UDim2.new(0.1, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.Text = name
    button.Parent = mainFrame
    local enabled = false

    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(70, 70, 70)
        callback(enabled)
    end)
end

-- Auto Attack
createToggle("⚔️ Auto Attack", 0.2, function(state)
    while state do
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartAttack")
        end
        wait(0.1)
    end
end)
-- **Tăng tầm đánh**
createToggle("📏 Tăng Tầm Đánh", 0.5, function(state)
    if state then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Tool") and (v:FindFirstChild("Handle") or v:FindFirstChild("Gun")) then
                v.Handle.Size = Vector3.new(60, 60, 60) -- Tăng phạm vi va chạm
                if v:FindFirstChild("Hitbox") then
                    v.Hitbox.Size = Vector3.new(60, 60, 60) -- Tăng hitbox
                end
            end
        end
    else
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                v.Handle.Size = Vector3.new(1, 1, 1) -- Trả lại kích thước gốc
                if v:FindFirstChild("Hitbox") then
                    v.Hitbox.Size = Vector3.new(1, 1, 1)
                end
            end
        end
    end
end)

-- ESP (Xuyên tường thấy Player)
createToggle("👀 ESP Player", 0.65, function(state)
    while state do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and not v.Character:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment", v.Character)
                box.Name = "ESPBox"
                box.Adornee = v.Character:FindFirstChild("HumanoidRootPart")
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = Color3.new(1, 0, 0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 5
            end
        end
        wait(1)
    end
end)
-- Nút tắt script
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0, 40)
closeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Text = "Tắt"
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
