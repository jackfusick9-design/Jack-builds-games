-- ADVANCED GUI WITH SHOP - Put in StarterPlayer > StarterCharacterScripts as LocalScript
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

print("[GUI] Creating HUD for " .. player.Name)

local gui = Instance.new("ScreenGui")
gui.Name = "MoneyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Money Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0, 400, 0, 50)
moneyLabel.Position = UDim2.new(0.02, 0, 0.02, 0)
moneyLabel.BackgroundColor3 = Color3.new(0, 0, 0)
moneyLabel.BackgroundTransparency = 0.4
moneyLabel.TextColor3 = Color3.new(0, 1, 0)
moneyLabel.TextSize = 28
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "Money: $0"
moneyLabel.Parent = gui

-- Bricks Label
local bricksLabel = Instance.new("TextLabel")
bricksLabel.Name = "BricksLabel"
bricksLabel.Size = UDim2.new(0, 400, 0, 50)
bricksLabel.Position = UDim2.new(0.02, 0, 0.08, 0)
bricksLabel.BackgroundColor3 = Color3.new(0, 0, 0)
bricksLabel.BackgroundTransparency = 0.4
bricksLabel.TextColor3 = Color3.new(0.3, 0.8, 1)
bricksLabel.TextSize = 28
bricksLabel.Font = Enum.Font.GothamBold
bricksLabel.Text = "Bricks: 0"
bricksLabel.Parent = gui

-- Income Per Tick Label
local incomeLabel = Instance.new("TextLabel")
incomeLabel.Name = "IncomeLabel"
incomeLabel.Size = UDim2.new(0, 400, 0, 40)
incomeLabel.Position = UDim2.new(0.02, 0, 0.14, 0)
incomeLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0)
incomeLabel.BackgroundTransparency = 0.4
incomeLabel.TextColor3 = Color3.new(1, 1, 0)
incomeLabel.TextSize = 20
incomeLabel.Font = Enum.Font.Gotham
incomeLabel.Text = "Income: $0/sec"
incomeLabel.Parent = gui

-- Shop Button
local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0, 300, 0, 50)
shopButton.Position = UDim2.new(0.02, 0, 0.22, 0)
shopButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
shopButton.BackgroundTransparency = 0.3
shopButton.TextColor3 = Color3.new(1, 1, 1)
shopButton.TextSize = 24
shopButton.Font = Enum.Font.GothamBold
shopButton.Text = "🌱 Visit Garden Shop"
shopButton.Parent = gui

shopButton.MouseButton1Click:Connect(function()
	local shop = Workspace:FindFirstChild("GardenShop")
	if shop and player.Character then
		player.Character:MoveTo(shop.Position + Vector3.new(0, 5, 0))
		
		local msg = Instance.new("Message")
		msg.Text = "🌱 Welcome to the Garden! Click bricks to grow them in your garden!"
		msg.Parent = Workspace
		game:GetService("Debris"):AddItem(msg, 4)
	end
end)

-- Available bricks counter
local availableLabel = Instance.new("TextLabel")
availableLabel.Name = "AvailableLabel"
availableLabel.Size = UDim2.new(0, 400, 0, 40)
availableLabel.Position = UDim2.new(0.02, 0, 0.30, 0)
availableLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
availableLabel.BackgroundTransparency = 0.5
availableLabel.TextColor3 = Color3.new(1, 1, 0)
availableLabel.TextSize = 18
availableLabel.Font = Enum.Font.Gotham
availableLabel.Text = "Garden: Loading..."
availableLabel.Parent = gui

-- Update loop
while true do
	wait(0.5)
	
	if _G.PlayerMoney and _G.PlayerMoney[player.UserId] then
		local money = _G.PlayerMoney[player.UserId]
		
		local formatted
		if money >= 1e15 then
			formatted = string.format("%.2f T", money / 1e15)
		elseif money >= 1e12 then
			formatted = string.format("%.2f T", money / 1e12)
		elseif money >= 1e9 then
			formatted = string.format("%.2f B", money / 1e9)
		elseif money >= 1e6 then
			formatted = string.format("%.2f M", money / 1e6)
		elseif money >= 1e3 then
			formatted = string.format("%.2f K", money / 1e3)
		else
			formatted = tostring(math.floor(money))
		end
		
		moneyLabel.Text = "💰 Money: $" .. formatted
		
		local base = workspace.Bases:FindFirstChild("Base_" .. player.UserId)
		if base then
			local brickCount = 0
			local totalIncome = 0
			for _, child in pairs(base:GetChildren()) do
				if child.Name == "Brick" then
					brickCount = brickCount + 1
					local moneyPerTick = child:GetAttribute("MoneyPerTick") or 1000
					totalIncome = totalIncome + moneyPerTick
				end
			end
			bricksLabel.Text = "🌱 Bricks: " .. brickCount
			incomeLabel.Text = "📈 Income: $" .. totalIncome .. "/sec"
		end
		
		-- Update available bricks count
		if _G.ShopInventory then
			local available = 0
			for _, item in pairs(_G.ShopInventory) do
				if not item.sold then
					available = available + 1
				end
			end
			availableLabel.Text = "🌻 Garden: " .. available .. " bricks available (Refreshes every 2 min)"
		end
	end
end
