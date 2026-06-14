-- UPDATED MONEY SYSTEM - Put in ServerScriptService (REPLACE the old GameManager)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

print("[GAME] Starting Advanced Brick Game...")

local GOAL = 100000000000000
local MONEY_TICK = 1

_G.PlayerMoney = _G.PlayerMoney or {}

if not Workspace:FindFirstChild("Bases") then
	local basesFolder = Instance.new("Folder")
	basesFolder.Name = "Bases"
	basesFolder.Parent = Workspace
end

local Bases = Workspace.Bases

Players.PlayerAdded:Connect(function(player)
	print("[GAME] " .. player.Name .. " joined!")
	_G.PlayerMoney[player.UserId] = 0
	
	local base = Instance.new("Folder")
	base.Name = "Base_" .. player.UserId
	base.Parent = Bases
	
	local spawnBrick = Instance.new("Part")
	spawnBrick.Name = "SpawnBrick"
	spawnBrick.Size = Vector3.new(6, 1, 6)
	spawnBrick.Position = base.Position + Vector3.new(0, 0.5, 0)
	spawnBrick.BrickColor = BrickColor.new("Dark stone grey")
	spawnBrick.TopSurface = Enum.SurfaceType.Smooth
	spawnBrick.BottomSurface = Enum.SurfaceType.Smooth
	spawnBrick.CanCollide = true
	spawnBrick.Parent = base
	
	local brick = Instance.new("Part")
	brick.Name = "Brick"
	brick.Shape = Enum.PartType.Block
	brick.Size = Vector3.new(1, 1, 1)
	brick.BrickColor = BrickColor.new("Dark stone grey")
	brick.TopSurface = Enum.SurfaceType.Smooth
	brick.BottomSurface = Enum.SurfaceType.Smooth
	brick.CanCollide = true
	brick.Position = base.Position + Vector3.new(0, 3, 0)
	brick:SetAttribute("MoneyPerTick", 1000)
	brick:SetAttribute("Rarity", "Common")
	brick.Parent = base
	
	player.CharacterAdded:Connect(function(char)
		wait(0.1)
		char:MoveTo(base.Position + Vector3.new(0, 5, 0))
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	_G.PlayerMoney[player.UserId] = nil
end)

-- Money generation with per-brick values
while true do
	wait(MONEY_TICK)
	
	for userId, money in pairs(_G.PlayerMoney) do
		local base = Bases:FindFirstChild("Base_" .. userId)
		if base then
			local totalEarnings = 0
			for _, child in pairs(base:GetChildren()) do
				if child.Name == "Brick" then
					local moneyPerTick = child:GetAttribute("MoneyPerTick") or 1000
					totalEarnings = totalEarnings + moneyPerTick
				end
			end
			
			_G.PlayerMoney[userId] = _G.PlayerMoney[userId] + totalEarnings
			
			if _G.PlayerMoney[userId] >= GOAL then
				local player = Players:GetPlayerByUserId(userId)
				if player then
					print("[GAME] " .. player.Name .. " WON!")
					local msg = Instance.new("Message")
					msg.Text = player.Name .. " REACHED 100 TRILLION DOLLARS!"
					msg.Parent = Workspace
					game:GetService("Debris"):AddItem(msg, 10)
				end
			end
		end
	end
end
