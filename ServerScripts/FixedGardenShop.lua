-- FIXED GARDEN SHOP - Put in ServerScriptService
local Workspace = game:GetService("Workspace")

print("[SHOP] Advanced garden shop system started")

local SHOP_REFRESH_TIME = 120 -- 2 minutes
local SHOP_STOCK = 10 -- Max bricks per refresh

-- Wait for Bases to exist
while not Workspace:FindFirstChild("Bases") do
	wait(0.1)
end

local Bases = Workspace.Bases

-- Brick types with rarity and base values
local BRICK_TYPES = {
	COMMON = {
		name = "Common Brick",
		baseValue = 1000,
		moneyPerTick = 1000,
		color = BrickColor.new("Dark stone grey"),
		rarity = "Common"
	},
	UNCOMMON = {
		name = "Uncommon Brick",
		baseValue = 3000,
		moneyPerTick = 3000,
		color = BrickColor.new("Bright green"),
		rarity = "Uncommon"
	},
	RARE = {
		name = "Rare Brick",
		baseValue = 8000,
		moneyPerTick = 8000,
		color = BrickColor.new("Bright blue"),
		rarity = "Rare"
	},
	EPIC = {
		name = "Epic Brick",
		baseValue = 20000,
		moneyPerTick = 20000,
		color = BrickColor.new("Magenta"),
		rarity = "Epic"
	},
	LEGENDARY = {
		name = "Legendary Brick",
		baseValue = 50000,
		moneyPerTick = 50000,
		color = BrickColor.new("Bright yellow"),
		rarity = "Legendary"
	}
}

-- Create shop folder
local shopFolder = Instance.new("Folder")
shopFolder.Name = "GardenShop"
shopFolder.Parent = Workspace

-- Store shop inventory
_G.ShopInventory = {}

-- Function to get random brick type
local function getRandomBrickType()
	local rarities = {"COMMON", "COMMON", "COMMON", "UNCOMMON", "UNCOMMON", "RARE", "RARE", "EPIC", "LEGENDARY"}
	local selected = rarities[math.random(1, #rarities)]
	return BRICK_TYPES[selected]
end

-- Function to spawn bricks in shop
local function spawnShopBricks()
	print("[SHOP] Refreshing garden...")
	
	-- Remove old bricks
	for _, brick in pairs(shopFolder:GetChildren()) do
		if brick.Name == "ShopBrick" then
			brick:Destroy()
		end
	end
	
	_G.ShopInventory = {}
	
	-- Spawn new random bricks
	for i = 1, SHOP_STOCK do
		local brickType = getRandomBrickType()
		local brick = Instance.new("Part")
		brick.Name = "ShopBrick"
		brick.Shape = Enum.PartType.Block
		brick.Size = Vector3.new(1, 1, 1)
		brick.BrickColor = brickType.color
		brick.TopSurface = Enum.SurfaceType.Smooth
		brick.BottomSurface = Enum.SurfaceType.Smooth
		brick.CanCollide = true
		brick.Position = shopFolder.Position + Vector3.new((i % 5) * 3 - 6, math.floor(i / 5) * 3 + 2, 0)
		brick.Parent = shopFolder
		
		-- Store brick info
		local shopItem = {
			brick = brick,
			type = brickType.name,
			rarity = brickType.rarity,
			price = brickType.baseValue,
			moneyPerTick = brickType.moneyPerTick,
			sold = false
		}
		table.insert(_G.ShopInventory, shopItem)
		
		-- Billboard with price and rarity
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Size = UDim2.new(3, 0, 2, 0)
		billboardGui.MaxDistance = 150
		billboardGui.Parent = brick
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 0.3
		label.BackgroundColor3 = Color3.new(0, 0, 0)
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextSize = 14
		label.Font = Enum.Font.GothamBold
		label.Text = brickType.rarity .. "\n$" .. brickType.baseValue
		label.Parent = billboardGui
		
		print("[SHOP] Created " .. brickType.rarity .. " brick for $" .. brickType.baseValue)
end
end

-- Setup click detection for shop bricks
local function setupClicks()
	while true do
		wait(0.2)
		
		for _, shopItem in pairs(_G.ShopInventory) do
			if shopItem.brick and shopItem.brick.Parent and not shopItem.sold then
				if not shopItem.brick:FindFirstChild("ClickDetector") then
					local click = Instance.new("ClickDetector")
					click.MaxActivationDistance = 100
					click.Parent = shopItem.brick
					
					click.MouseClick:Connect(function(player)
						if not shopItem.sold and _G.PlayerMoney[player.UserId] >= shopItem.price then
							_G.PlayerMoney[player.UserId] = _G.PlayerMoney[player.UserId] - shopItem.price
							shopItem.sold = true
							print("[SHOP] " .. player.Name .. " bought " .. shopItem.rarity .. " brick")
							
							local playerBase = Bases:FindFirstChild("Base_" .. player.UserId)
							if playerBase then
								-- Animation: brick grows
								shopItem.brick.Parent = playerBase
								shopItem.brick.Name = "Brick"
								shopItem.brick:SetAttribute("MoneyPerTick", shopItem.moneyPerTick)
								shopItem.brick:SetAttribute("Rarity", shopItem.rarity)
								
								-- Growth animation
								local originalSize = shopItem.brick.Size
								shopItem.brick.Size = Vector3.new(0.1, 0.1, 0.1)
								
								for scale = 0.1, 1, 0.1 do
									shopItem.brick.Size = originalSize * scale
									wait(0.05)
								end
								shopItem.brick.Size = originalSize
								
								local msg = Instance.new("Message")
								msg.Text = player.Name .. " grew a " .. shopItem.rarity .. " brick for $" .. shopItem.price .. "!"
								msg.Parent = Workspace
								game:GetService("Debris"):AddItem(msg, 3)
							end
						elseif not shopItem.sold then
							local msg = Instance.new("Message")
							msg.Text = player.Name .. " needs $" .. shopItem.price .. " for this " .. shopItem.rarity .. " brick!"
							msg.Parent = Workspace
							game:GetService("Debris"):AddItem(msg, 2)
						end
					end)
				end
			end
		end
	end
end

-- Start refresh loop
spawn(function()
	while true do
		spawnShopBricks()
		wait(SHOP_REFRESH_TIME)
	end
end)

-- Start click detection
spawn(setupClicks)

-- Initial spawn
wait(1)
spawnShopBricks()
