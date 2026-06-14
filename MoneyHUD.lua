-- MoneyHUD.lua - Display money and bricks UI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Money Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0, 300, 0, 50)
moneyLabel.Position = UDim2.new(0.02, 0, 0.02, 0)
moneyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
moneyLabel.BackgroundTransparency = 0.5
moneyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
moneyLabel.TextSize = 24
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "Money: $0"
moneyLabel.Parent = screenGui

-- Bricks Label
local bricksLabel = Instance.new("TextLabel")
bricksLabel.Name = "BricksLabel"
bricksLabel.Size = UDim2.new(0, 300, 0, 50)
bricksLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
bricksLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bricksLabel.BackgroundTransparency = 0.5
bricksLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
bricksLabel.TextSize = 24
bricksLabel.Font = Enum.Font.GothamBold
bricksLabel.Text = "Bricks: 0"
bricksLabel.Parent = screenGui

-- Goal Label
local goalLabel = Instance.new("TextLabel")
goalLabel.Name = "GoalLabel"
goalLabel.Size = UDim2.new(0, 400, 0, 50)
goalLabel.Position = UDim2.new(0.02, 0, 0.18, 0)
goalLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
goalLabel.BackgroundTransparency = 0.5
goalLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
goalLabel.TextSize = 20
goalLabel.Font = Enum.Font.GothamBold
goalLabel.Text = "Goal: $100,000,000,000,000"
goalLabel.Parent = screenGui