-- GameManager.lua - Main game controller
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local GOAL_MONEY = 100000000000000 -- 100 trillion
local PLAYERS_MAX = 10
local STEAL_PENALTY = 0.25 -- 25% loss
local MONEY_TICK_RATE = 1 -- seconds between money generation
local MONEY_PER_BRICK = 1000 -- money earned per brick per tick

-- Player data storage
local playerData = {}

-- Initialize player when they join
Players.PlayerAdded:Connect(function(player)
	if #Players:GetPlayers() > PLAYERS_MAX then
		player:Kick("Server is full (Max 10 players)")
		return
	end
	
	-- Create player data
	playerData[player.UserId] = {
		money = 0,
		bricks = 0,
		player = player
	}
	
	-- Create player base folder
	local baseFolder = Instance.new("Folder")
	baseFolder.Name = "PlayerBase_" .. player.UserId
	baseFolder.Parent = Workspace:FindFirstChild("Bases") or Workspace
	
	-- Give player a starter brick
	local starterBrick = createBrick(player, baseFolder)
	
	print(player.Name .. " joined the game!")
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player.UserId] = nil
	print(player.Name .. " left the game")
end)

-- Money generation loop
while true do
	wait(MONEY_TICK_RATE)
	
	for userId, data in pairs(playerData) do
		local bricksInBase = getBricksInBase(data.player)
		local moneyGenerated = bricksInBase * MONEY_PER_BRICK
		data.money = data.money + moneyGenerated
		data.bricks = bricksInBase
		
		-- Check if player won
		if data.money >= GOAL_MONEY then
			announceWinner(data.player, data.money)
		end
		
		-- Update player's GUI
		updatePlayerGUI(data.player, data.money, data.bricks)
	end
end

-- Helper function: Get bricks in player's base
function getBricksInBase(player)
	local baseFolder = Workspace:FindFirstChild("PlayerBase_" .. player.UserId)
	if not baseFolder then return 0 end
	
	local count = 0
	for _, brick in pairs(baseFolder:GetChildren()) do
		if brick:IsA("Part") and brick.Name == "Brick" then
			count = count + 1
		end
	end
	return count
end

-- Helper function: Create a brick
function createBrick(player, parent)
	local brick = Instance.new("Part")
	brick.Name = "Brick"
	brick.Shape = Enum.PartType.Block
	brick.Size = Vector3.new(1, 1, 1)
	brick.BrickColor = BrickColor.new(math.random(1, 127))
	brick.CanCollide = true
	brick.TopSurface = Enum.SurfaceType.Smooth
	brick.BottomSurface = Enum.SurfaceType.Smooth
	brick.Parent = parent
	
	-- Add custom attributes
	brick:SetAttribute("OwnerUserId", player.UserId)
	brick:SetAttribute("OwnerName", player.Name)
	
	-- Random position in base
	brick.Position = parent.Position + Vector3.new(math.random(-10, 10), math.random(5, 15), math.random(-10, 10))
	
	return brick
end

-- Helper function: Announce winner
function announceWinner(player, money)
	print(player.Name .. " has won with $" .. tostring(money))
	
	-- Broadcast to all players
	local message = Instance.new("Message")
	message.Text = player.Name .. " has won with $" .. formatMoney(money) .. "!"
	message.Parent = Workspace
	game:GetService("Debris"):AddItem(message, 5)
end

-- Helper function: Format large numbers
function formatMoney(num)
	if num >= 1e15 then return string.format("%.2f T", num / 1e15)
	elseif num >= 1e12 then return string.format("%.2f T", num / 1e12)
	elseif num >= 1e9 then return string.format("%.2f B", num / 1e9)
	elseif num >= 1e6 then return string.format("%.2f M", num / 1e6)
	elseif num >= 1e3 then return string.format("%.2f K", num / 1e3)
	else return tostring(num) end
end

-- Helper function: Update player GUI
function updatePlayerGUI(player, money, bricks)
	local playerGui = player:WaitForChild("PlayerGui")
	local hud = playerGui:FindFirstChild("MoneyHUD")
	
	if hud then
		local moneyLabel = hud:FindFirstChild("MoneyLabel")
		local bricksLabel = hud:FindFirstChild("BricksLabel")
		
		if moneyLabel then
			moneyLabel.Text = "Money: $" .. formatMoney(money)
		end
		if bricksLabel then
			bricksLabel.Text = "Bricks: " .. bricks
		end
	end
end