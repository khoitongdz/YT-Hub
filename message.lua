-- Kenon Hub - Auto Chat Full Executor
local messages = {" "}
local delay = 35 -- Thời gian giữa các tin nhắn (mặc định 35 giây)
local running = false
local speedBoost = false -- Biến kiểm soát tăng tốc độ chạy
local superSpeed = false -- Biến kiểm soát Super Chạy
local speedValue = 16 -- Giá trị tốc độ chạy có thể chỉnh trong UI

-- Kiểm tra executor
local isSupported = (syn and syn.request) or (secure_request) or (http and http.request) or (fluxus and fluxus.request) or request
if not isSupported then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kenon Hub",
        Text = "Executor không hỗ trợ!",
        Duration = 5
    })
    return
end

-- Tạo UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("ImageButton")
local StatusLabel = Instance.new("TextButton")
local TimeLabel = Instance.new("TextLabel")
local OverlayText = Instance.new("TextLabel")
local MessageBox = Instance.new("TextBox")
local DelayBox = Instance.new("TextBox")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "KenonHubUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, -75) -- Canh giữa màn hình
MainFrame.Visible = false

ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.9, 0, 0.1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://15377289473" -- Thay ID bằng logo của bạn

-- Cho phép kéo thả logo
local dragging, offset
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        offset = input.Position - ToggleButton.AbsolutePosition
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        ToggleButton.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
    end
end)

StatusLabel.Parent = MainFrame
StatusLabel.Text = "Auto Chat: OFF"
StatusLabel.Size = UDim2.new(1, 0, 0.2, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StatusLabel.BorderSizePixel = 0

TimeLabel.Parent = MainFrame
TimeLabel.Text = "Server Time: 00:00"
TimeLabel.Size = UDim2.new(1, 0, 0.2, 0)
TimeLabel.Position = UDim2.new(0, 0, 0.2, 0)
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.BackgroundTransparency = 1

MessageBox.Parent = MainFrame
MessageBox.PlaceholderText = "Nhập tin nhắn..."
MessageBox.Text = table.concat(messages, " | ")
MessageBox.Size = UDim2.new(1, -10, 0.2, 0)
MessageBox.Position = UDim2.new(0, 5, 0.4, 0)
MessageBox.TextColor3 = Color3.fromRGB(0, 255, 0)
MessageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

DelayBox.Parent = MainFrame
DelayBox.PlaceholderText = "Nhập delay (giây)..."
DelayBox.Text = tostring(delay)
DelayBox.Size = UDim2.new(1, -10, 0.2, 0)
DelayBox.Position = UDim2.new(0, 5, 0.6, 0)
DelayBox.TextColor3 = Color3.fromRGB(0, 255, 255)
DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Dòng chữ lớn giữa màn hình khi Auto Chat bật
OverlayText.Parent = ScreenGui
OverlayText.Text = ""
OverlayText.Size = UDim2.new(1, 0, 0.1, 0)
OverlayText.Position = UDim2.new(0, 0, 0.45, 0)
OverlayText.TextColor3 = Color3.fromRGB(255, 0, 0)
OverlayText.TextScaled = true
OverlayText.BackgroundTransparency = 1
OverlayText.Visible = false

-- Cập nhật thời gian trong server
task.spawn(function()
    while true do
        local timeInMinutes = math.floor(workspace.DistributedGameTime / 60)
        local hours = math.floor(timeInMinutes / 60)
        local minutes = timeInMinutes % 60
        TimeLabel.Text = string.format("Server Time: %02d:%02d", hours, minutes)
        wait(1)
    end
end)

-- Auto Chat function
local function startAutoChat()
    running = true
    StatusLabel.Text = "Auto Chat: ON"
    OverlayText.Visible = true

    -- Cập nhật nội dung tin nhắn và delay từ UI
    local inputMessages = MessageBox.Text
    if inputMessages ~= "" then
        messages = {}
        for msg in string.gmatch(inputMessages, "[^|]+") do
            table.insert(messages, msg:match("^%s*(.-)%s*$")) -- Loại bỏ khoảng trắng thừa
        end
    end

    local inputDelay = tonumber(DelayBox.Text)
    if inputDelay and inputDelay > 0 then
        delay = inputDelay
    end

    while running do
        for _, msg in ipairs(messages) do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            wait(delay)
        end
    end
end

local function stopAutoChat()
    running = false
    StatusLabel.Text = "Auto Chat: OFF"
    OverlayText.Visible = false
end

-- Nút bật/tắt UI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Nhấn vào StatusLabel để bật/tắt auto chat
StatusLabel.MouseButton1Click:Connect(function()
    if running then
        stopAutoChat()
    else
        startAutoChat()
    end
end)
SpeedBox.Parent = MainFrame
SpeedBox.PlaceholderText = "Nhập tốc độ (1-100)..."
SpeedBox.Text = tostring(speedValue)
SpeedBox.Size = UDim2.new(1, -10, 0.15, 0)
SpeedBox.Position = UDim2.new(0, 5, 0.9, 0)
SpeedBox.TextColor3 = Color3.fromRGB(255, 165, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local function toggleSuperSpeed()
    superSpeed = not superSpeed
    if superSpeed then
        SuperSpeedLabel.Text = "Super Chạy: ON"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        SuperSpeedLabel.Text = "Super Chạy: OFF"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
end

SuperSpeedLabel.MouseButton1Click:Connect(function()
    toggleSuperSpeed()
end)

SpeedBox.FocusLost:Connect(function()
    local inputSpeed = tonumber(SpeedBox.Text)
    if inputSpeed and inputSpeed >= 1 and inputSpeed <= 100 then
        speedValue = inputSpeed
        if not superSpeed then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        end
    else
        SpeedBox.Text = tostring(speedValue)
    end
end)
