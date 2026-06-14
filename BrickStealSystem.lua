-- BrickStealSystem.lua - Handles stealing bricks from other players
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local STEAL_PENALTY = 0.25 -- 25% money loss when brick is stolen

-- Detect when a brick is clicked to steal it
local function setupBrickClickDetection()
	while true do
		wait(0.1)
		
		-- Find all bricks in the game
		for _, baseFolder in pairs(Workspace:GetChildren()) do
			if baseFolder.Name:match("PlayerBase_") then
				for _, brick in pairs(baseFolder:GetChildren()) do
					if brick:IsA("Part") and brick.Name == "Brick" and not brick:FindFirstChild("ClickDetector") then
						local clickDetector = Instance.new("ClickDetector")
						clickDetector.Parent = brick
						
						clickDetector.MouseClick:Connect(function(player)
							stealBrick(player, brick, baseFolder)
						end)
					end
				end
			end
		end
	end
end

-- Function to steal a brick
function stealBrick(thief, brick, victimBase)
	local victimUserId = tonumber(victimBase.Name:match("%d+$"))
	local thiefUserId = thief.UserId
	
	-- Can't steal your own bricks
	if victimUserId == thiefUserId then
		return
	end
	
	-- Deduct 25% from thief's money
	local gameManager = _G.GameManager or {}
	if gameManager.playerData and gameManager.playerData[thiefUserId] then
		local stolenAmount = gameManager.playerData[thiefUserId].money * STEAL_PENALTY
		gameManager.playerData[thiefUserId].money = gameManager.playerData[thiefUserId].money - stolenAmount
		
		print(thief.Name .. " stole a brick! Lost $" .. tostring(stolenAmount))
	end
	
	-- Move brick to thief's base
	local thiefBase = Workspace:FindFirstChild("PlayerBase_" .. thiefUserId)
	if thiefBase then
		brick.Parent = thiefBase
		brick:SetAttribute("OwnerUserId", thiefUserId)
		brick:SetAttribute("OwnerName", thief.Name)
		brick.BrickColor = BrickColor.new(math.random(1, 127))
		
		-- Notify players
		local message = Instance.new("Message")
		message.Text = thief.Name .. " stole a brick from " .. brick:GetAttribute("OwnerName") .. "!"
		message.Parent = Workspace
		game:GetService("Debris"):AddItem(message, 3)
	end
end

-- Start the system
spawn(setupBrickClickDetection)