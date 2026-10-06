-- COMPATIBLE MOBILE SPEED UI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Dynamically find PlayerGui regardless of execution environment
local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")

-- 1. CREATE THE INTERFACE PROGRAMMATICALLY
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Container Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.4, -60) -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.Visible = true
frame.Parent = screenGui

-- Speed Display Text
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Name = "SpeedDisplay"
speedDisplay.Size = UDim2.new(1, 0, 0, 40)
speedDisplay.Position = UDim2.new(0, 0, 0, 10)
speedDisplay.BackgroundTransparency = 1
speedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDisplay.TextSize = 20
speedDisplay.Font = Enum.Font.SourceSansBold
speedDisplay.Text = "Speed: 16"
speedDisplay.Parent = frame

-- Plus Button (+)
local plusButton = Instance.new("TextButton")
plusButton.Name = "PlusButton"
plusButton.Size = UDim2.new(0, 60, 0, 50)
plusButton.Position = UDim2.new(0.6, -20, 0.5, 0)
plusButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextSize = 24
plusButton.Font = Enum.Font.SourceSansBold
plusButton.Text = "+"
plusButton.Parent = frame

-- Minus Button (-)
local minusButton = Instance.new("TextButton")
minusButton.Name = "MinusButton"
minusButton.Size = UDim2.new(0, 60, 0, 50)
minusButton.Position = UDim2.new(0.4, -40, 0.5, 0)
minusButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextSize = 24
minusButton.Font = Enum.Font.SourceSansBold
minusButton.Text = "-"
minusButton.Parent = frame

-- Toggle Menu Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleMenuButton"
toggleButton.Size = UDim2.new(0, 120, 0, 45)
toggleButton.Position = UDim2.new(0.05, 0, 0.85, -22) -- Bottom left for mobile thumb access
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Text = "Toggle Speed UI"
toggleButton.Parent = screenGui

-- 2. CORE FUNCTIONALITY & SPEED CONFIGURATION
local currentSpeed = 16
local minSpeed = 0
local maxSpeed = 250 -- Increased maximum speed limit
local speedStep = 10 -- Changes speed by 10 per click for faster adjustments

-- Function to get the current character's humanoid safely
local function getHumanoid()
    local character = player.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Function to safely update the player's movement speed and screen text
local function applySpeedSettings()
    speedDisplay.Text = "Speed: " .. tostring(currentSpeed)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
    end
end

-- Monitor when the player respawns to re-apply the speed instantly
player.CharacterAdded:Connect(function()
    task.wait(0.5) -- Give the character half a second to load completely
    applySpeedSettings()
end)

-- Regularly double-check speed in case the game tries to force it back to 16
task.spawn(function()
    while task.wait(0.5) do
        applySpeedSettings()
    end
end)

-- 3. INTERACTIVE TOUCH EVENTS (MOBILE OPTIMIZED)

-- Toggle menu visibility
toggleButton.Activated:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Increase speed tap tracking
plusButton.Activated:Connect(function()
	if currentSpeed + speedStep <= maxSpeed then
		currentSpeed = currentSpeed + speedStep
		applySpeedSettings()
	end
end)

-- Decrease speed tap tracking
minusButton.Activated:Connect(function()
	if currentSpeed - speedStep >= minSpeed then
		currentSpeed = currentSpeed - speedStep
		applySpeedSettings()
	end
end)
