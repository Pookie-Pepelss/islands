--[[

$$$$$$$\                      $$\       $$\         $$\         
$$  __$$\                     $$ |      \__|        $  |        
$$ |  $$ | $$$$$$\   $$$$$$\  $$ |  $$\ $$\  $$$$$$\\_/$$$$$$$\ 
$$$$$$$  |$$  __$$\ $$  __$$\ $$ | $$  |$$ |$$  __$$\ $$  _____|
$$  ____/ $$ /  $$ |$$ /  $$ |$$$$$$  / $$ |$$$$$$$$ |\$$$$$$\  
$$ |      $$ |  $$ |$$ |  $$ |$$  _$$<  $$ |$$   ____| \____$$\ 
$$ |      \$$$$$$  |\$$$$$$  |$$ | \$$\ $$ |\$$$$$$$\ $$$$$$$  |
\__|       \______/  \______/ \__|  \__|\__| \_______|\_______/ 
                                                                                                                             
                                                                
$$$$$$\ $$\    $$\ $$\      $$\                                 
\_$$  _|$$ |   $$ |$$$\    $$$ |                                 
  $$ |  $$ |   $$ |$$$$\  $$$$ |                                 
  $$ |  \$$\  $$  |$$\$$\$$ $$ |                               
  $$ |   \$$\$$  / $$ \$$$  $$ |                                 
  $$ |    \$$$  /  $$ |\$  /$$ |                                 
$$$$$$\    \$  /   $$ | \_/ $$ |                                 
\______|    \_/    \__|     \__| 		 

]]
					  
if _G.VendingManagerCleanup then
	pcall(_G.VendingManagerCleanup)
end

local isExecComp = true
local requiredFuncs = {"hookfunction", "hookmetamethod", "newcclosure", "getrawmetatable", "setreadonly"}

local CompatibilityGui = Instance.new("ScreenGui")
CompatibilityGui.Name = "CompatibilityCheckUI"
if gethui then CompatibilityGui.Parent = gethui() else CompatibilityGui.Parent = game:GetService("CoreGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 100)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = CompatibilityGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Checking Compatibility..."
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0.8, 0, 0, 6)
BarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
BarBg.BorderSizePixel = 0
BarBg.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

local TweenService = game:GetService("TweenService")
TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

for _, func in ipairs(requiredFuncs) do
	if not (getgenv and getgenv()[func]) and not _G[func] and not (debug and debug[func]) and type(getfenv()[func]) ~= "function" then
		isExecComp = false
	end
end

CompatibilityGui:Destroy()

-- freecam
loadstring(game:HttpGet("https://pastebin.com/raw/6ngxJT8b"))()

Window = Window or nil
Rayfield = Rayfield or nil
labelPool = labelPool or {}
espLabels = espLabels or {}
espCache = espCache or {}
selectionBoxLines = selectionBoxLines or {}
selectedVendingMachines = selectedVendingMachines or {}
setmetatable(selectedVendingMachines, {__mode = "k"})
CircleLines = CircleLines or {}

local openingEnabled = openingEnabled or false
local loopCoinEnabled = loopCoinEnabled or false
local loopItemEnabled = loopItemEnabled or false
local atmLoopEnabled = false
local isCleaningUp = false

releaseLabel = releaseLabel or function(lab) if lab and type(lab.Remove) == "function" then lab:Remove() end end

local activeConnections = {}
local activeLoops = {}

local function registerConnection(conn)
	table.insert(activeConnections, conn)
	return conn
end

local function registerLoop(thread)
	table.insert(activeLoops, thread)
	return thread
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pookie's IVM",
   Icon = 0,
   LoadingTitle = "Islands Vending Manager",
   LoadingSubtitle = "by PookiePepelss",
   ShowText = "made by someone very cool",
   Theme = "Ocean", -- Change the theme if u want here "Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "VendingSettings"
   },
   Discord = {
      Enabled = true,
      Invite = "QZWrvrqkwb",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local VendingTab = Window:CreateTab("Vending Managment", 6942650339)
local ChestTab = Window:CreateTab("Chest", 99252073072597)
local ATMTab = Window:CreateTab("ATM", 14832381261)
local OpeningTab = Window:CreateTab("Opening", 78111289121317)
local MiscTab = Window:CreateTab("Misc", 136882854117051)
local SettingsTab = Window:CreateTab("Settings", 7059346373)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HS = game:GetService("HttpService")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Backpack = LP:WaitForChild("Backpack")

local withdrawLoopDelay = 0.2
local vendingActionDelay = 0.001
local coinLoopDelay = 0.3
local atmLoopDelay = 0.1
local vendingRadius = 15
local selectionBoxUpdateRate = 2
local maxSelectionBoxes = 20
local maxVendingsPerCycle = 20

local vendingBoundingBoxCache = setmetatable({}, {__mode = "k"})
local targetVendingMode = "All"
local selectedVendMode = 0
local ItemMode = nil
local CoinMode = nil
local atmMode = "Deposit"
local chestMode = "Deposit"
local itemLoopGeneration = 0
local coinLoopGeneration = 0
local atmLoopGeneration = 0
local chestLoopGeneration = 0
local coinActionInProgress = false
local selectionModeEnabled = false
local selectionBoxUpdateCounter = 0
local allBackpackItems = {}
local filteredItems = {}

local ItemNameMap = {}
local function formatItemName(name)
	local newName = name:gsub("(%l)(%u)", "%1 %2")
	newName = newName:sub(1,1):upper() .. newName:sub(2)
	newName = newName:gsub("_", " ")
	return newName
end
local function registerItemName(internal, instance)
	local display
	if instance then
		local s, r = pcall(function() return instance.DisplayName end)
		if s and r and type(r) == "string" and #r > 0 then
			display = r
		end
	end
	if not display then
		display = formatItemName(internal)
	end
	ItemNameMap[display] = internal
	return display
end

local function getVendingBoundingBox(vendingModel)
	if not vendingModel then return nil end
	if vendingBoundingBoxCache[vendingModel] then return vendingBoundingBoxCache[vendingModel] end
	
	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
	local hasValidParts = false
	
	local sellingContents = vendingModel:FindFirstChild("SellingContents")
	
	for _, d in ipairs(vendingModel:GetDescendants()) do
		if d:IsA("BasePart") then
			if sellingContents and d:IsDescendantOf(sellingContents) then
				continue
			end
			
			local pos = d.Position
			local size = d.Size
			
			local halfSize = size * 0.5
			
			local cf = d.CFrame
			local corners = {
				cf * Vector3.new(-halfSize.X, -halfSize.Y, -halfSize.Z),
				cf * Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
				cf * Vector3.new(halfSize.X, halfSize.Y, -halfSize.Z),
				cf * Vector3.new(-halfSize.X, halfSize.Y, -halfSize.Z),
				cf * Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
				cf * Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
				cf * Vector3.new(halfSize.X, halfSize.Y, halfSize.Z),
				cf * Vector3.new(-halfSize.X, halfSize.Y, halfSize.Z),
			}
			
			for _, corner in ipairs(corners) do
				minX = math.min(minX, corner.X)
				maxX = math.max(maxX, corner.X)
				minY = math.min(minY, corner.Y)
				maxY = math.max(maxY, corner.Y)
				minZ = math.min(minZ, corner.Z)
				maxZ = math.max(maxZ, corner.Z)
			end
			hasValidParts = true
		end
	end
	
	if not hasValidParts or minX == math.huge then return nil end
	
	local result = {
		min = Vector3.new(minX, minY, minZ),
		max = Vector3.new(maxX, maxY, maxZ),
		center = Vector3.new((minX + maxX)/2, (minY + maxY)/2, (minZ + maxZ)/2)
	}
	vendingBoundingBoxCache[vendingModel] = result
	return result
end

local function updateSelectionBoxes()
	local cam = workspace.CurrentCamera
	if not cam then return end
	
	for vending, lines in pairs(selectionBoxLines) do
		if not selectedVendingMachines[vending] then
			for _, line in ipairs(lines) do
				pcall(function() line:Remove() end)
			end
			selectionBoxLines[vending] = nil
		end
	end
	
	local selectedList = {}
	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	
	local selectionCount = 0
	for _ in pairs(selectedVendingMachines) do selectionCount = selectionCount + 1 end

	if selectionCount > maxSelectionBoxes then
		for vending, _ in pairs(selectedVendingMachines) do
			if hrp then
				local part = vending:FindFirstChildWhichIsA("BasePart") or vending.PrimaryPart
				local dist = part and (part.Position - hrp.Position).Magnitude or 0
				table.insert(selectedList, {machine = vending, dist = dist})
			else
				table.insert(selectedList, {machine = vending, dist = 0})
			end
		end
		table.sort(selectedList, function(a, b) return a.dist < b.dist end)
	else
		for vending, _ in pairs(selectedVendingMachines) do
			table.insert(selectedList, {machine = vending})
		end
	end
	
	local displayBoxes = {}
	for i = 1, math.min(#selectedList, maxSelectionBoxes) do
		displayBoxes[selectedList[i].machine] = true
	end
	
	for vending, lines in pairs(selectionBoxLines) do
		if not displayBoxes[vending] then
			for _, line in ipairs(lines) do
				pcall(function() line:Remove() end)
			end
			selectionBoxLines[vending] = nil
		end
	end
	
	for vending, _ in pairs(displayBoxes) do
		local bbox = getVendingBoundingBox(vending)
		if not bbox then
			if selectionBoxLines[vending] then
				for _, line in ipairs(selectionBoxLines[vending]) do
					pcall(function() line:Remove() end)
				end
				selectionBoxLines[vending] = nil
			end
			continue
		end
		
		local min, max = bbox.min, bbox.max
		local corners = {
			Vector3.new(min.X, min.Y, min.Z),
			Vector3.new(max.X, min.Y, min.Z),
			Vector3.new(max.X, max.Y, min.Z),
			Vector3.new(min.X, max.Y, min.Z),
			Vector3.new(min.X, min.Y, max.Z),
			Vector3.new(max.X, min.Y, max.Z),
			Vector3.new(max.X, max.Y, max.Z),
			Vector3.new(min.X, max.Y, max.Z),
		}
		
		local edges = {
			{1,2}, {2,3}, {3,4}, {4,1},
			{5,6}, {6,7}, {7,8}, {8,5},
			{1,5}, {2,6}, {3,7}, {4,8}
		}
		
		if not selectionBoxLines[vending] then
			selectionBoxLines[vending] = {}
			for i = 1, 12 do
				local line = Drawing.new("Line")
				line.Color = Color3.fromRGB(0, 255, 0)
				line.Thickness = 2
				line.Transparency = 0.5
				table.insert(selectionBoxLines[vending], line)
			end
		end
		
		local lineIndex = 1
		for _, edge in ipairs(edges) do
			local p1 = corners[edge[1]]
			local p2 = corners[edge[2]]
			local sp1, vis1 = cam:WorldToViewportPoint(p1)
			local sp2, vis2 = cam:WorldToViewportPoint(p2)
			
			local line = selectionBoxLines[vending][lineIndex]
			if vis1 and vis2 then
				line.From = Vector2.new(sp1.X, sp1.Y)
				line.To = Vector2.new(sp2.X, sp2.Y)
				line.Visible = true
			else
				line.Visible = false
			end
			lineIndex += 1
		end
	end
end

registerConnection(RunS.RenderStepped:Connect(function()
	if not selectionModeEnabled then return end
	updateSelectionBoxes()
end))

local function getNetRemote(path)
	return RS.rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(path)
end

local function shouldOperateOnVending(vendingMachine)
	if not selectionModeEnabled then return true end
	return selectedVendingMachines[vendingMachine] == true
end

local VENDING_OPEN = getNetRemote("deGzdggahhjo/qkXeOxsmwiafothorpqogpS")
local VENDING_EDIT = getNetRemote("deGzdggahhjo/yceVHErjjNihyeXjwKeyzfnyrwmcnaWnCo")
local VENDING_TRANS = getNetRemote("deGzdggahhjo/yeuvbxxakbeqDdlofjxFiBwq")
local VENDING_COINS_WITHDRAW = getNetRemote("deGzdggahhjo/ytaJiyomainKgxefgrkF")
local VENDING_COINS_DEPOSIT = getNetRemote("deGzdggahhjo/ggzImj")
local VENDING_CLOSE = getNetRemote("deGzdggahhjo/QaardducNrilqsmxdiotkewau")
local VENDING_MODE = getNetRemote("deGzdggahhjo/rLPziSaNkyol")
local ATM_REMOTE = getNetRemote("TransactionBankBalance")
local CHEST_TRANS = getNetRemote("CLIENT_CHEST_TRANSACTION")
local CLIENT_REQUEST_22 = RS.rbxts_include.node_modules["@rbxts"].net.out._NetManaged:WaitForChild("client_request_22")
local CLIENT_EAT_FOOD = RS.rbxts_include.node_modules["@rbxts"].net.out._NetManaged:WaitForChild("CLIENT_EAT_FOOD")

local function GetBackpackItems()
	local items = {}
	local seen = {}
	for _, item in ipairs(Backpack:GetChildren()) do
		if not seen[item.Name] then
			local display = registerItemName(item.Name, item)
			table.insert(items, display)
			seen[item.Name] = true
		end
	end
	table.sort(items)
	return #items > 0 and items or {"Empty"}
end

local function parseAmount(txt)
	txt = tostring(txt or ""):upper():gsub("%s", "")
	local num, suffix = txt:match("^([%d%.]+)([KMB]?)$")
	if not num then return nil end
	
	num = tonumber(num)
	if not num then return nil end
	
	if suffix == "K" or suffix == "k" then
		return math.floor(num * 1_000)
	elseif suffix == "M" or suffix == "m" then
		return math.floor(num * 1_000_000)
	elseif suffix == "B" or suffix == "b" then
		return math.floor(num * 1_000_000_000)
	else
		return math.floor(num)
	end
end

local function formatNumber(num)
	if num >= 1_000_000_000_000 then
		return string.format("%.1f", num / 1_000_000_000_000) .. "T"
	elseif num >= 1_000_000_000 then
		return string.format("%.1f", num / 1_000_000_000) .. "B"
	elseif num >= 1_000_000 then
		return string.format("%.1f", num / 1_000_000) .. "M"
	elseif num >= 1_000 then
		return string.format("%.1f", num / 1_000) .. "K"
	else
		return tostring(math.floor(num))
	end
end

local function fireVendingSession(guid, vendingMachine, action, data)
	data = data or {}
	data.player_tracking_category = "join_from_web"
	data.vendingMachine = vendingMachine
	data.action = action
	
	VENDING_TRANS:FireServer(guid, {data})
end

local function closeVendingSession(vendingMachine)
	pcall(function()
		VENDING_CLOSE:FireServer({vendingMachine = vendingMachine})
	end)
end

local function getSortedVendingsInRadius()
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return {} end

	local islands = WS:FindFirstChild("Islands")
	if not islands then return {} end

	local candidates = {}
	local radiusSq = vendingRadius * vendingRadius
	local hrpPos = hrp.Position

	for _, island in ipairs(islands:GetChildren()) do
		local blocks = island:FindFirstChild("Blocks")
		if not blocks then continue end

		for _, v in ipairs(blocks:GetChildren()) do
			if v.Name ~= "vendingMachine1" and v.Name ~= "vendingMachine" and v.Name ~= "vendingMachineIndustrial" then continue end

			local part = v:FindFirstChildWhichIsA("BasePart")
			if not part then continue end
			
			local pPos = part.Position
			local dx = pPos.X - hrpPos.X
			local dy = pPos.Y - hrpPos.Y
			local dz = pPos.Z - hrpPos.Z
			local distSq = dx*dx + dy*dy + dz*dz

			if distSq > radiusSq then continue end
			if not shouldOperateOnVending(v) then continue end

			if targetVendingMode ~= "All" then
				local m = v:GetAttribute("Mode")
				if m == nil then
					local modeVal = v:FindFirstChild("Mode")
					if modeVal then m = modeVal.Value end
				end
				m = m or 0
				if targetVendingMode == "Sell" and m ~= 0 then continue end
				if targetVendingMode == "Buy" and m ~= 1 then continue end
			end

			table.insert(candidates, {v = v, dist = distSq})
		end
	end

	table.sort(candidates, function(a, b) return a.dist < b.dist end)
	
	local result = {}
	for _, c in ipairs(candidates) do
		table.insert(result, c.v)
	end
	return result
end

local function withdrawVendingsInRadius(withdrawAll, customAmount, showNotif, loopGen, itemName)
	if showNotif == nil then showNotif = true end
	if loopGen and loopGen ~= itemLoopGeneration then return end

	local queue = {}
	local sortedVendings = getSortedVendingsInRadius()

	for _, v in ipairs(sortedVendings) do
		if #queue >= maxVendingsPerCycle then break end

			local contents = v:FindFirstChild("SellingContents")
			if not contents or #contents:GetChildren() == 0 then continue end

			if itemName and type(itemName) == "string" then
				local it = contents:FindFirstChild(itemName)
				if not it then
					for _, child in ipairs(contents:GetChildren()) do
						if child.Name:lower() == itemName:lower() then
							it = child
							break
						end
					end
				end
				if it then
					local amt = it:FindFirstChild("Amount")
					if amt and amt.Value > 0 then
						local withdrawAmount = amt.Value
						if customAmount and customAmount > 0 then
							withdrawAmount = math.min(customAmount, amt.Value)
						end
						if withdrawAmount > 0 then
							table.insert(queue, {v = v, items = {{tool = it, amount = withdrawAmount}}})
						end
					end
				end
			else
				local itemsList = {}
				for _, item in ipairs(contents:GetChildren()) do
					local amt = item:FindFirstChild("Amount")
					if amt and amt.Value > 0 then
						local withdrawAmount = amt.Value
						if customAmount and customAmount > 0 then
							withdrawAmount = math.min(customAmount, amt.Value)
						end
						if withdrawAmount > 0 then
							table.insert(itemsList, {tool = item, amount = withdrawAmount})
						end
					end
				end
				if #itemsList > 0 then
					table.insert(queue, {v = v, items = itemsList})
				end
			end
	end

	if #queue == 0 then return end

	local processed = 0
	local active = 0
	for _, entry in ipairs(queue) do
		local vendingRef = entry.v
		active = active + 1
		task.spawn(function()
			for _, itEntry in ipairs(entry.items) do
				local guid = HS:GenerateGUID(false)
				VENDING_OPEN:FireServer(guid, {{vendingMachine = vendingRef}})
				VENDING_EDIT:FireServer(guid, {{vendingMachine = vendingRef}})
				task.wait(0.001)

				fireVendingSession(guid, vendingRef, "withdraw", {
					tool = itEntry.tool,
					amount = itEntry.amount,
				})
				
				closeVendingSession(vendingRef)
				task.wait(0.001)
			end
			processed = processed + 1
			active = active - 1
		end)
	end

	while active > 0 do
		if loopGen and loopGen ~= itemLoopGeneration then break end
		task.wait(0.05)
	end

end

local function withdrawVendingsCoinsInRadius(amount, showNotif, singleTransaction, loopGen)
	if showNotif == nil then showNotif = true end
	if loopGen and loopGen ~= coinLoopGeneration then
		return
	end
	if coinActionInProgress then
		return
	end
	coinActionInProgress = true
	local queue = {}
	for _, v in ipairs(getSortedVendingsInRadius()) do
		if loopGen and loopGen ~= coinLoopGeneration then coinActionInProgress = false; return end
		local coinBalance = v:FindFirstChild("CoinBalance")
		if coinBalance and coinBalance.Value > 0 then
			table.insert(queue, v)
		end
		if #queue >= maxVendingsPerCycle then break end
	end
	if #queue == 0 then
		coinActionInProgress = false
		return
	end
	local processed = 0
	local active = 0
	for _, v in ipairs(queue) do
		if loopGen and loopGen ~= coinLoopGeneration then break end
		active = active + 1
		task.spawn(function()
			if loopGen and loopGen ~= coinLoopGeneration then active = active - 1; return end

			local guid = HS:GenerateGUID(false)
			VENDING_OPEN:FireServer(guid, {{vendingMachine = v}})
			VENDING_EDIT:FireServer(guid, {{vendingMachine = v}})
			task.wait(0.01)

			if loopGen and loopGen ~= coinLoopGeneration then closeVendingSession(v); active = active - 1; return end

			local withdrawAmount = amount
			if withdrawAmount == nil then -- This is for "Withdraw Max"
				local coinBalance = v:FindFirstChild("CoinBalance")
				withdrawAmount = coinBalance and coinBalance.Value or 0
			end

			if withdrawAmount and withdrawAmount > 0 then
				VENDING_COINS_WITHDRAW:FireServer(guid, {{
					vendingMachine = v,
					player_tracking_category = "join_from_web",
					amount = withdrawAmount,
				}})
				processed = processed + 1
			end

			closeVendingSession(v)
			active = active - 1
		end)
	end

		while active > 0 do
			if loopGen and loopGen ~= coinLoopGeneration then break end
			task.wait(0.05)
		end
	coinActionInProgress = false
end
local function depositItemsInRadius(itemName, amount, showNotif, loopGen)
	if showNotif == nil then showNotif = true end
	if loopGen and loopGen ~= itemLoopGeneration then return 0 end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return 0 end

	local tool = Backpack:FindFirstChild(itemName)
	if not tool and LP.Character then
		tool = LP.Character:FindFirstChild(itemName)
	end
	if not tool then return 0 end

	local deposited = 0

	local perCallAmount = nil
	if amount and amount > 0 then
		perCallAmount = amount
	end
	local desiredAmount = nil
	if not perCallAmount then
		local val = tool:FindFirstChild("Value")
		desiredAmount = (val and val.Value) or 1
	end

	local queue = {}
	local sortedVendings = getSortedVendingsInRadius()

	for _, v in ipairs(sortedVendings) do
		if #queue >= maxVendingsPerCycle then break end

			local contents = v:FindFirstChild("SellingContents")
			local skip = false
			local existingAmount = 0
			if contents then
				for _, it in ipairs(contents:GetChildren()) do
					local amt = it:FindFirstChild("Amount")
					if amt and amt.Value > 0 then
						if it.Name ~= itemName then
							skip = true
							break
						else
							existingAmount = existingAmount + (amt.Value or 0)
						end
					end
				end
			end
			if skip then continue end

			if perCallAmount == nil then
				if existingAmount >= desiredAmount then continue end
			end

			local depositAmount = 0
			if perCallAmount then
				depositAmount = perCallAmount
			else
				depositAmount = desiredAmount
				if existingAmount > 0 then
					depositAmount = math.max(0, desiredAmount - existingAmount)
				end
			end
			if depositAmount <= 0 then continue end

			local toolRef = Backpack:FindFirstChild(itemName)
			if not toolRef and LP.Character then
				toolRef = LP.Character:FindFirstChild(itemName)
			end
			if not toolRef then continue end

			table.insert(queue, {v = v, depositAmount = depositAmount, existingAmount = existingAmount})
	end

	local active = 0
	for _, entry in ipairs(queue) do
		local vendingRef = entry.v
		local depositAmount = entry.depositAmount
		local existingAmount = entry.existingAmount
		local toolRef = Backpack:FindFirstChild(itemName)
		if not toolRef and LP.Character then
			toolRef = LP.Character:FindFirstChild(itemName)
		end
		if not toolRef then break end
		local guid = HS:GenerateGUID(false)
		active = active + 1
		task.spawn(function()
			VENDING_OPEN:FireServer(guid, {{vendingMachine = vendingRef}})
			VENDING_EDIT:FireServer(guid, {{vendingMachine = vendingRef}})
			task.wait(0.001)
			task.wait(0.001)

			fireVendingSession(guid, vendingRef, "deposit", {
				tool = toolRef,
				amount = depositAmount,
			})

			closeVendingSession(vendingRef)
			active = active - 1
		end)
	end

	while active > 0 do
		if loopGen and loopGen ~= itemLoopGeneration then break end
		task.wait(0.05)
	end

	deposited = #queue

	return deposited
end

local function depositCoinsIntoVending(depositAmount, showNotif, singleTransaction, loopGen, parallel, maxConcurrent)
	if showNotif == nil then showNotif = true end
	if loopGen and loopGen ~= coinLoopGeneration then return end
	if coinActionInProgress then return end
	coinActionInProgress = true
	local processed = 0
	local MAX_VENDING_CAPACITY = 5_000_000_000
	local queue = {}
	local sortedVendings = getSortedVendingsInRadius()
	for _, v in ipairs(sortedVendings) do
		if loopGen and loopGen ~= coinLoopGeneration then coinActionInProgress = false; return end
		table.insert(queue, v)
		if #queue >= maxVendingsPerCycle then break end
	end
	if #queue == 0 then coinActionInProgress = false; return end
	local function processVending(v)
		if loopGen and loopGen ~= coinLoopGeneration then return false end
		local guid = HS:GenerateGUID(false)
		VENDING_OPEN:FireServer(guid, {{vendingMachine = v}})
		VENDING_EDIT:FireServer(guid, {{vendingMachine = v}})
		task.wait(0.001)
		task.wait(0.001)

		local vendingCoinBalance = v:FindFirstChild("CoinBalance")
		local currentBalance = vendingCoinBalance and vendingCoinBalance.Value or 0
		local playerCoins = LP:GetAttribute("Coins") or 0
		if currentBalance >= MAX_VENDING_CAPACITY and vendingCoinBalance then
			closeVendingSession(v)
			return false
		end
		if playerCoins <= 0 then
			closeVendingSession(v)
			return false
		end

		local spaceAvailable = MAX_VENDING_CAPACITY - currentBalance
		local amountToDeposit = 0
		if depositAmount and depositAmount > 0 then
			amountToDeposit = math.min(depositAmount, spaceAvailable, playerCoins)
		else
			amountToDeposit = math.min(playerCoins, spaceAvailable)
		end
		if amountToDeposit <= 0 then
			closeVendingSession(v)
			return false
		end

		if loopGen and loopGen ~= coinLoopGeneration then
			closeVendingSession(v)
			return false
		end
		VENDING_COINS_DEPOSIT:FireServer(guid, {{
			vendingMachine = v,
			player_tracking_category = "join_from_web",
			amount = amountToDeposit,
		}})
		closeVendingSession(v)
		return true
	end

	if depositAmount and depositAmount > 0 then
		local active = 0
		for _, v in ipairs(queue) do
			if loopGen and loopGen ~= coinLoopGeneration then break end
			active = active + 1
			task.spawn(function()
				local ok = false
				if singleTransaction then
					ok = processVending(v)
				else
					local attempts = 0
					while attempts < 50 do
						attempts = attempts + 1
						if loopGen and loopGen ~= coinLoopGeneration then break end
						ok = processVending(v)
						if ok then break end
						task.wait(0.001)
					end
				end
				if ok then processed = processed + 1 end
				active = active - 1
			end)
		end

		while active > 0 do
			if loopGen and loopGen ~= coinLoopGeneration then break end
			task.wait(0.05)
		end
	elseif not parallel then
		for _, v in ipairs(queue) do
			if loopGen and loopGen ~= coinLoopGeneration then break end

			local ok = false
			if singleTransaction then
				ok = processVending(v)
			else
				local attempts = 0
				while attempts < 50 do
					attempts = attempts + 1
					if loopGen and loopGen ~= coinLoopGeneration then break end
					ok = processVending(v)
					if ok then break end
					task.wait(0.001)
				end
			end

			if ok then processed = processed + 1 end
			task.wait(vendingActionDelay)
			if processed >= maxVendingsPerCycle then break end
		end
	else
		maxConcurrent = math.max(1, maxConcurrent or 24)
		maxConcurrent = math.min(maxConcurrent, #queue)
		local idx = 1

		local workers = {}
		for w = 1, maxConcurrent do
			workers[w] = task.spawn(function()
				while true do
					if loopGen and loopGen ~= coinLoopGeneration then break end
					local i = idx
					idx = idx + 1
					if i > #queue then break end
					local v = queue[i]

					local ok = false
					if singleTransaction then
						ok = processVending(v)
					else
						local attempts = 0
						while attempts < 50 do
							attempts = attempts + 1
							if loopGen and loopGen ~= coinLoopGeneration then break end
							ok = processVending(v)
							if ok then break end
							task.wait(0.001)
						end
					end

					if ok then
						processed = processed + 1
					end

					task.wait(vendingActionDelay)
					if processed >= maxVendingsPerCycle then break end
				end
			end)
		end

		while true do
			if loopGen and loopGen ~= coinLoopGeneration then break end
			if idx > #queue then break end
			task.wait(0.05)
		end
		task.wait(0.2)
	end
	coinActionInProgress = false
end

	local function setPriceInRadius(amount)
		local processed = 0
		local sortedVendings = getSortedVendingsInRadius()
		for _, v in ipairs(sortedVendings) do
			if processed >= maxVendingsPerCycle then break end

				local guid = HS:GenerateGUID(false)
				VENDING_OPEN:FireServer(guid, {{vendingMachine = v}})
				VENDING_EDIT:FireServer(guid, {{vendingMachine = v}})
				task.wait(0.001)
				task.wait(0.001)
			
				local finalPrice = amount
				if not finalPrice then
					finalPrice = v:GetAttribute("Price") or v:GetAttribute("TransactionPrice")
					if not finalPrice then
						local pVal = v:FindFirstChild("Price") or v:FindFirstChild("TransactionPrice")
						if pVal then finalPrice = pVal.Value end
					end
				end

				if finalPrice then
					VENDING_MODE:FireServer(guid, {{
						mode = selectedVendMode,
						vendingMachine = v,
						player_tracking_category = "join_from_web",
						transactionPrice = finalPrice,
					}})
					processed = processed + 1
				end
			
				closeVendingSession(v)
				task.wait(0.001)
		end

		if processed > 0 then
			local actionText = amount and "Price Set" or "Mode Set"
			local selectionInfo = selectionModeEnabled and " (selected)" or ""
			Rayfield:Notify({Title = actionText .. selectionInfo, Content = "Updated " .. processed .. " machine(s)", Duration = 2, Image = 11401835376})
		end
	end

local ScannerSection = VendingTab:CreateSection("Scanner")

local ScanButton = VendingTab:CreateButton({
	Name = "Scan Vending Machines",
	Callback = function()
		local islands = WS:FindFirstChild("Islands")
		if not islands then
			Rayfield:Notify({Title = "Scan Vendings", Content = "No Islands found", Duration = 3, Image = 11401835376})
			return
		end
		
		task.spawn(function()
			local count = 0
			local totalCoins = 0
			local totalItems = 0
			local processed = 0
			for _, island in ipairs(islands:GetChildren()) do
				local blocks = island:FindFirstChild("Blocks")
				if not blocks then continue end
				for _, v in ipairs(blocks:GetChildren()) do
					processed = processed + 1
					if processed % 500 == 0 then task.wait() end
					if v.Name ~= "vendingMachine1" and v.Name ~= "vendingMachine" and v.Name ~= "vendingMachineIndustrial" then continue end
					local part = v:FindFirstChildWhichIsA("BasePart")
					if not part then continue end
					count += 1
					local coinBalance = v:FindFirstChild("CoinBalance")
					if coinBalance then
						totalCoins += coinBalance.Value
					end
					local contents = v:FindFirstChild("SellingContents")
					if contents then
						for _, item in ipairs(contents:GetChildren()) do
							local amt = item:FindFirstChild("Amount")
							if amt and amt.Value > 0 then
								totalItems += amt.Value
							end
						end
					end
				end
			end
			
			Rayfield:Notify({
				Title = "Vending Machines",
				Content = "Found " .. tostring(count) .. " machine(s) | Items: " .. formatNumber(totalItems) .. " | Coins: " .. formatNumber(totalCoins),
				Duration = 3,
				Image = 11401835376,
			})
		end)
	end,
})

local FilterSection = VendingTab:CreateSection("Filters")

local TargetModeDropdown = VendingTab:CreateDropdown({
	Name = "Target Machine Mode",
	Options = {"All", "Sell", "Buy"},
	CurrentOption = {"All"},
	MultipleOptions = false,
	Flag = "TargetModeDropdown",
	Callback = function(Options)
		targetVendingMode = Options[1] or "All"
	end,
})

local ItemSection = VendingTab:CreateSection("Item Selection")

local ItemAmountValue = ""
local Input = VendingTab:CreateInput({
	Name = "Item Amount",
	CurrentValue = "",
	PlaceholderText = "1-1000",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(Text)
		ItemAmountValue = Text
	end,
})

local Dropdown = VendingTab:CreateDropdown({
	Name = "Select Item",
	Options = GetBackpackItems(),
	CurrentOption = { "Empty" },
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Options)
		local display = Options[1] or "Empty"
		selectedVendItem = ItemNameMap[display] or display
	end,
})

VendingTab:CreateButton({
	Name = "Refresh Items",
	Callback = function()
		allBackpackItems = GetBackpackItems()
		filteredItems = allBackpackItems

		if Dropdown and Dropdown.Refresh then
			local currentSelection = Dropdown.CurrentOption and Dropdown.CurrentOption[1]
			local defaultOption = filteredItems[1] or "Empty"
			
			local newSelection = defaultOption
			if currentSelection then
				for _, item in ipairs(filteredItems) do
					if item == currentSelection then
						newSelection = currentSelection
						break
					end
				end
			end

			Dropdown:Refresh(filteredItems, newSelection)
		end
	end
})

local ItemActionSection = VendingTab:CreateSection("Item Actions")

local ItemModeDropdown = VendingTab:CreateDropdown({
	Name = "Select Item Mode",
	Options = {"Deposit", "Withdraw", "Deposit (Max)", "Withdraw (Max)"},
	CurrentOption = {"None"},
	MultipleOptions = false,
	Flag = "ItemModeDropdown",
	Callback = function(Options)
		ItemMode = Options[1] or "Deposit"
	end,
})

local ItemActionButton = VendingTab:CreateButton({
	Name = "Perform Item Action (Radius)",
	Callback = function()
		if ItemMode == "Deposit" then
			local display = Dropdown.CurrentOption and Dropdown.CurrentOption[1] or "Empty"
			local selectedItem = ItemNameMap[display] or display
			local amount = tonumber(ItemAmountValue) or 1
			if selectedItem ~= "Empty" then
				depositItemsInRadius(selectedItem, amount)
			end
		elseif ItemMode == "Deposit (Max)" then
			local display = Dropdown.CurrentOption and Dropdown.CurrentOption[1] or "Empty"
			local selectedItem = ItemNameMap[display] or display
			if selectedItem ~= "Empty" then
				local tool = Backpack:FindFirstChild(selectedItem)
				if tool then
					depositItemsInRadius(selectedItem, 999999999)
				end
			end
		elseif ItemMode == "Withdraw" then
			local amount = tonumber(ItemAmountValue) or nil
			withdrawVendingsInRadius(false, amount, true, nil, nil)
		elseif ItemMode == "Withdraw (Max)" then
			withdrawVendingsInRadius(true, nil, true, nil, nil)
		end
	end,
})

VendingTab:CreateDivider()

itemLoopThread = nil

local LoopItemToggle = VendingTab:CreateToggle({
	Name = "Loop Item Action (Radius)",
	CurrentValue = false,
	Flag = "LoopItemToggle",
	Callback = function(Value)
		loopItemEnabled = Value
		if Value then
			itemLoopGeneration = itemLoopGeneration + 1
			local myGen = itemLoopGeneration
			itemLoopThread = task.spawn(function()
				while loopItemEnabled do
					if ItemMode == "Deposit" then
						local display = Dropdown.CurrentOption and Dropdown.CurrentOption[1] or "Empty"
						local selectedItem = ItemNameMap[display] or display
						local amount = tonumber(ItemAmountValue) or 1
						if selectedItem ~= "Empty" then
							depositItemsInRadius(selectedItem, amount, false, myGen)
						end
					elseif ItemMode == "Deposit (Max)" then
						local display = Dropdown.CurrentOption and Dropdown.CurrentOption[1] or "Empty"
						local selectedItem = ItemNameMap[display] or display
						if selectedItem ~= "Empty" then
							local tool = Backpack:FindFirstChild(selectedItem)
							if tool then
								local amount = tool:FindFirstChild("Value")
								if amount then
									depositItemsInRadius(selectedItem, amount.Value, false, myGen)
								else
									depositItemsInRadius(selectedItem, 999999999, false, myGen)
								end
							end
						end
					elseif ItemMode == "Withdraw" then
						local amount = tonumber(ItemAmountValue) or nil
						withdrawVendingsInRadius(false, amount, false, myGen, nil)
					elseif ItemMode == "Withdraw (Max)" then
						withdrawVendingsInRadius(true, nil, false, myGen, nil)
					end
					if loopItemEnabled then
						task.wait(withdrawLoopDelay)
					end
				end
			end)
			registerLoop(itemLoopThread)
		else
			loopItemEnabled = false
			if itemLoopThread then
				task.cancel(itemLoopThread)
				itemLoopThread = nil
			end
		end
	end,
})

local ItemLoopDelaySlider = VendingTab:CreateSlider({
	Name = "Item Loop Delay",
	Range = {0.3, 25},
	Increment = 0.1,
	Suffix = " seconds",
	CurrentValue = withdrawLoopDelay,
	Flag = "ItemLoopDelaySlider",
	Callback = function(Value)
		withdrawLoopDelay = Value
	end,
})

local PriceSection = VendingTab:CreateSection("Price & Mode Management")

local PriceModeDropdown = VendingTab:CreateDropdown({
	Name = "Vending Mode",
	Options = {"Sell", "Buy"},
	CurrentOption = {"None"},
	MultipleOptions = false,
	Flag = "PriceModeDropdown",
	Callback = function(Options)
		local mode = Options[1] or "Sell"
		if mode == "Sell" then
			selectedVendMode = 0
		elseif mode == "Buy" then
			selectedVendMode = 1
		end
	end,
})

local PriceInputValue = ""
local PriceInput = VendingTab:CreateInput({
	Name = "Price",
	CurrentValue = "",
	PlaceholderText = "example: 1B",
	RemoveTextAfterFocusLost = false,
	Flag = "PriceInput",
	Callback = function(Text)
		PriceInputValue = Text
	end,
})

local SetPriceButton = VendingTab:CreateButton({
	Name = "Set Price For Vending Machines (Radius)",
	Callback = function()
		local amount = parseAmount(PriceInputValue)
		setPriceInRadius(amount)
	end,
})

local CoinSection = VendingTab:CreateSection("Coin Management")

local CoinInputValue = ""
local CoinInput = VendingTab:CreateInput({
	Name = "Coin Amount",
	CurrentValue = "",
	PlaceholderText = "example: 1B",
	RemoveTextAfterFocusLost = false,
	Flag = "CoinInput",
	Callback = function(Text)
		CoinInputValue = Text
	end,
})

local CoinModeDropdown = VendingTab:CreateDropdown({
	Name = "Select Coin Mode",
	Options = {"Deposit", "Withdraw", "Deposit (Max)", "Withdraw (Max)"},
	CurrentOption = {"None"},
	MultipleOptions = false,
	Flag = "CoinModeDropdown",
	Callback = function(Options)
		CoinMode = Options[1] or "Deposit"
	end,
})

local CoinActionButton = VendingTab:CreateButton({
	Name = "Perform Coin Action (Radius)",
	Callback = function()
		if CoinMode == "Deposit" then
			if CoinInputValue == "" or CoinInputValue == nil then return end
			local amount = parseAmount(CoinInputValue)
			if not amount or amount <= 0 then return end
			depositCoinsIntoVending(amount, true, true)
		elseif CoinMode == "Deposit (Max)" then
			depositCoinsIntoVending(LP:GetAttribute("Coins") or 0, true, true)
		elseif CoinMode == "Withdraw" then
			if CoinInputValue == "" or CoinInputValue == nil then return end
			local amount = parseAmount(CoinInputValue)
			if not amount or amount <= 0 then return end
			withdrawVendingsCoinsInRadius(amount, true, true)
		elseif CoinMode == "Withdraw (Max)" or CoinMode == "Withdraw (All)" then
			    withdrawVendingsCoinsInRadius(nil, true, true)
		end
	end,
})

VendingTab:CreateDivider()

coinLoopThread = nil

local LoopCoinToggle = VendingTab:CreateToggle({
	Name = "Loop Coin Action (Radius)",
	CurrentValue = false,
	Flag = "LoopCoinToggle",
	Callback = function(Value)
		loopCoinEnabled = Value
		if Value then
			coinLoopGeneration = coinLoopGeneration + 1
			local myGen = coinLoopGeneration
			coinLoopThread = task.spawn(function()
				while loopCoinEnabled do
					if CoinMode == "Deposit" then
						if CoinInputValue ~= "" and CoinInputValue ~= nil then
							local amount = parseAmount(CoinInputValue)
							if amount and amount > 0 then
								task.spawn(function()
									depositCoinsIntoVending(amount, false, true, myGen)
								end)
							end
						end
					elseif CoinMode == "Deposit (Max)" then
						local maxCoins = LP:GetAttribute("Coins") or 0
						if maxCoins > 0 then
							task.spawn(function()
									depositCoinsIntoVending(maxCoins, false, true, myGen)
							end)
						end
					elseif CoinMode == "Withdraw" then
						if CoinInputValue ~= "" and CoinInputValue ~= nil then
							local amount = parseAmount(CoinInputValue)
							if amount and amount > 0 then
								task.spawn(function()
									withdrawVendingsCoinsInRadius(amount, false, false, myGen)
								end)
							end
						end
					elseif CoinMode == "Withdraw (Max)" or CoinMode == "Withdraw (All)" then
						 task.spawn(function()
								withdrawVendingsCoinsInRadius(nil, false, false, myGen)
							end)
					end
					if loopCoinEnabled then
						task.wait(coinLoopDelay)
					end
				end
			end)
			registerLoop(coinLoopThread)
		else
			loopCoinEnabled = false
			if coinLoopThread then
				task.cancel(coinLoopThread)
				coinLoopThread = nil
			end
		end
	end,
})

local CoinLoopDelaySlider = VendingTab:CreateSlider({
	Name = "Coin Action Loop Delay",
	Range = {0.1, 25},
	Increment = 0.1,
	Suffix = " seconds",
	CurrentValue = coinLoopDelay,
	Flag = "CoinLoopDelaySlider",
	Callback = function(Value)
		coinLoopDelay = Value
	end,
})

local ATMSection = ATMTab:CreateSection("ATM Operations")

local ATMInputValue = ""
local ATMInput = ATMTab:CreateInput({
	Name = "Amount",
	CurrentValue = "",
	PlaceholderText = "example: 1B",
	RemoveTextAfterFocusLost = false,
	Flag = "ATMInput",
	Callback = function(Text)
		ATMInputValue = Text
	end,
})

local ATMModeDropdown = ATMTab:CreateDropdown({
	Name = "Select ATM Mode",
	Options = {"Deposit", "Withdraw"},
	CurrentOption = {"Deposit"},
	MultipleOptions = false,
	Flag = "ATMModeDropdown",
	Callback = function(Options)
		atmMode = Options[1] or "Deposit"
	end,
})

local function performAtmAction()
    local amount = parseAmount(ATMInputValue)
    if not (amount and amount > 0) then return end

    local transferType = (atmMode == "Withdraw" and "WITHDRAWAL") or "DEPOSIT"
    
    local guid = HS:GenerateGUID(false)
    ATM_REMOTE:FireServer(guid, {{
        accountType = "PERSONAL",
        transferType = transferType,
        amount = amount
    }})
end

local ATMActionButton = ATMTab:CreateButton({
	Name = "Perform ATM Action",
	Callback = performAtmAction
})

ATMTab:CreateDivider()

atmLoopThread = nil
local LoopATMToggle = ATMTab:CreateToggle({
	Name = "Loop ATM Action",
	CurrentValue = false,
	Flag = "LoopATMToggle",
	Callback = function(Value)
		atmLoopEnabled = Value
		if Value then
			atmLoopGeneration = atmLoopGeneration + 1
			local myGen = atmLoopGeneration
			atmLoopThread = task.spawn(function()
				while atmLoopEnabled and myGen == atmLoopGeneration do
					performAtmAction()
					task.wait(atmLoopDelay)
				end
			end)
			registerLoop(atmLoopThread)
		else
			atmLoopEnabled = false
			if atmLoopThread then
				task.cancel(atmLoopThread)
				atmLoopThread = nil
			end
		end
	end,
})

local ATMLoopDelaySlider = ATMTab:CreateSlider({
	Name = "ATM Loop Delay",
	Range = {0.1, 10},
	Increment = 0.1,
	Suffix = " seconds",
	CurrentValue = atmLoopDelay,
	Flag = "ATMLoopDelaySlider",
	Callback = function(Value)
		atmLoopDelay = Value
	end,
})

local chestAction = "Deposit"
local chestLoopEnabled = false
local chestLoopThread = nil
local chestLoopDelay = 0.3

local chestTypes = {
	"All",
	"Expanded Diamond Chest",
	"Diamond Chest",
	"Industrial Medium Chest",
	"Medium Chest",
	"Industrial Medium Chest (IO)",
	"Timed Industrial Chest",
	"Large Chest",
	"Industrial Large Chest",
	"Industrial Large Chest (IO)",
	"Small Chest"
}

local chestMap = {
	["All"] = "All",
	["Expanded Diamond Chest"] = "diamondChestT2",
	["Diamond Chest"] = "diamondChestT1",
	["Industrial Medium Chest"] = "chestMediumIndustrial",
	["Medium Chest"] = "chestMedium",
	["Industrial Medium Chest (IO)"] = "chestMediumIndustrialIO",
	["Timed Industrial Chest"] = "chestIndustrialTimed",
	["Large Chest"] = "chestLarge",
	["Industrial Large Chest"] = "chestLargeIndustrial",
	["Industrial Large Chest (IO)"] = "chestLargeIndustrialIO",
	["Small Chest"] = "chestSmall"
}
local selectedChestType = "All"
local useHeldItemChest = false
local chestItemAmountValue = ""
local selectedChestItem = "Empty"

local function getChestsInRadius()
	local list = {}
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return list end

	local islands = WS:FindFirstChild("Islands")
	if not islands then return list end

	local radiusSq = vendingRadius * vendingRadius
	local hrpPos = hrp.Position

	for _, island in ipairs(islands:GetChildren()) do
		local blocks = island:FindFirstChild("Blocks")
		if not blocks then continue end
		for _, v in ipairs(blocks:GetChildren()) do
			local selectedInternal = chestMap[selectedChestType] or "All"
			local isMatch = false
			if selectedInternal == "All" then
				for _, t in pairs(chestMap) do
					if t ~= "All" and v.Name == t then
						isMatch = true
						break
					end
				end
			elseif v.Name == selectedInternal then
				isMatch = true
			end
			
			if not isMatch then continue end

			local part = v:FindFirstChildWhichIsA("BasePart") or v.PrimaryPart
			if not part then continue end

			local pPos = part.Position
			local dx = pPos.X - hrpPos.X
			local dy = pPos.Y - hrpPos.Y
			local dz = pPos.Z - hrpPos.Z
			local distSq = dx*dx + dy*dy + dz*dz

			if distSq <= radiusSq then
				table.insert(list, v)
			end
		end
	end
	return list
end

local function getChestItemsCombined()
	local items = {}
	local seen = {}
	
	for _, item in ipairs(Backpack:GetChildren()) do
		if not seen[item.Name] then
			local display = registerItemName(item.Name, item)
			table.insert(items, display)
			seen[item.Name] = true
		end
	end
	
	local chests = getChestsInRadius()
	for _, chest in ipairs(chests) do
		local contents = chest:FindFirstChild("Contents")
		if contents then
			for _, item in ipairs(contents:GetChildren()) do
				if not seen[item.Name] then
					local display = registerItemName(item.Name, item)
					table.insert(items, display)
					seen[item.Name] = true
				end
			end
		end
	end
	
	table.sort(items)
	return #items > 0 and items or {"Empty"}
end

local function performChestAction(loopGen)
    if loopGen and loopGen ~= chestLoopGeneration then return end

    local chests = getChestsInRadius()
    if #chests == 0 then return end

    local amount = parseAmount(chestItemAmountValue) or 1

    local tool = nil
    if useHeldItemChest then
        local char = LP.Character
        tool = char and char:FindFirstChildWhichIsA("Tool")
    else
        tool = Backpack:FindFirstChild(selectedChestItem) or (LP.Character and LP.Character:FindFirstChild(selectedChestItem))
    end
    
    if not tool then Rayfield:Notify({Title = "Chest Action", Content = "No item to deposit.", Duration = 2}); return end
    
    local maxAmt = 1
    local amtObj = tool:FindFirstChild("Amount")
    if amtObj then maxAmt = amtObj.Value end
    local depositAmt = amount
    if depositAmt > maxAmt then depositAmt = maxAmt end
    
    if depositAmt <= 0 then return end

    for _, chest in ipairs(chests) do
        if loopGen and loopGen ~= chestLoopGeneration then break end
        pcall(function()
            CHEST_TRANS:InvokeServer({
                chest = chest,
                player_tracking_category = "join_from_web",
                amount = depositAmt,
                tool = tool,
                action = "deposit"
            })
        end)
        task.wait(0.05)
    end
end

local ChestScannerSection = ChestTab:CreateSection("Scanner")

ChestTab:CreateButton({
	Name = "Scan Chests",
	Callback = function()
		local islands = WS:FindFirstChild("Islands")
		if not islands then return end
		
		local count = 0
		local totalItems = 0
		
		for _, island in ipairs(islands:GetChildren()) do
			local blocks = island:FindFirstChild("Blocks")
			if not blocks then continue end
			for _, v in ipairs(blocks:GetChildren()) do
				local selectedInternal = chestMap[selectedChestType] or "All"
				local isMatch = false
				if selectedInternal == "All" then
					for _, t in pairs(chestMap) do
						if t ~= "All" and v.Name == t then
							isMatch = true
							break
						end
					end
				elseif v.Name == selectedInternal then
					isMatch = true
				end
				
				if not isMatch then continue end
				
				count = count + 1
				local contents = v:FindFirstChild("Contents")
				if contents then
					for _, item in ipairs(contents:GetChildren()) do
						local amt = item:FindFirstChild("Amount")
						if amt then
							totalItems = totalItems + amt.Value
						end
					end
				end
			end
		end
		
		Rayfield:Notify({
			Title = "Chest Scan (" .. selectedChestType .. ")",
			Content = "Found " .. count .. " chests | Items: " .. formatNumber(totalItems),
			Duration = 3,
			Image = 4483345998,
		})
	end,
})

local ChestItemSection = ChestTab:CreateSection("Item Selection")

local ChestItemDropdown = nil

ChestItemDropdown = ChestTab:CreateDropdown({
    Name = "Select Item",
    Options = {"Empty"},
    CurrentOption = {"Empty"},
    MultipleOptions = false,
    Callback = function(Option)
        local display = Option[1]
        selectedChestItem = ItemNameMap[display] or display
    end,
})
pcall(function()
    ChestItemDropdown:Refresh(getChestItemsCombined(), "Empty")
end)
ChestTab:CreateButton({
	Name = "Refresh Items",
	Callback = function()
        pcall(function()
            ChestItemDropdown:Refresh(getChestItemsCombined(), selectedChestItem ~= "Empty" and selectedChestItem or nil)
        end)
    end
})

ChestTab:CreateToggle({
    Name = "Use Held Item",
    CurrentValue = false,
    Callback = function(Value)
        useHeldItemChest = Value
    end,
})

ChestTab:CreateInput({
    Name = "Item Amount",
    CurrentValue = "",
    PlaceholderText = "Amount (e.g. 1k)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        chestItemAmountValue = Text
    end,
})

local ChestActionSection = ChestTab:CreateSection("Chest Actions")

ChestTab:CreateDropdown({
    Name = "Chest Type",
    Options = chestTypes,
    CurrentOption = {"All"},
    MultipleOptions = false,
    Callback = function(Option)
        selectedChestType = Option[1]
    end,
})

local chestActionCooldown = false
ChestTab:CreateButton({
	Name = "Deposit (Radius)",
    Callback = function()
        if chestActionCooldown then return end
        chestActionCooldown = true
        task.delay(0.5, function() chestActionCooldown = false end)
        performChestAction()
    end,
})

ChestTab:CreateDivider()

ChestTab:CreateToggle({
    Name = "Loop Deposit",
    CurrentValue = false,
    Callback = function(Value)
        chestLoopEnabled = Value
        if Value then
            chestLoopGeneration = chestLoopGeneration + 1
            local myGen = chestLoopGeneration
            chestLoopThread = task.spawn(function()
                while chestLoopEnabled and myGen == chestLoopGeneration do
                    performChestAction(myGen)
                    task.wait(chestLoopDelay)
                end
            end)
            registerLoop(chestLoopThread)
        else
            if chestLoopThread then
                task.cancel(chestLoopThread)
                chestLoopThread = nil
            end
        end
    end,
})

ChestTab:CreateSlider({
    Name = "Loop Delay",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = chestLoopDelay,
    Callback = function(Value)
        chestLoopDelay = Value
    end,
})

local OpeningSection = OpeningTab:CreateSection("Present Opening")

local openingSpeed = 0.1
local lastOpeningTime = 0

local OpeningToggle = OpeningTab:CreateToggle({
	Name = "Auto Open Presents",
	CurrentValue = false,
	Flag = "OpeningToggle",
	Callback = function(Value)
		openingEnabled = Value
	end,
})

local SpeedSlider = OpeningTab:CreateSlider({
	Name = "Opening Speed",
	Range = {0.05, 2},
	Increment = 0.01,
	Suffix = " seconds",
	CurrentValue = 0.1,
	Flag = "OpeningSpeedSlider",
	Callback = function(Value)
		openingSpeed = Value
	end,
})

registerConnection(RunS.Heartbeat:Connect(function(deltaTime)
	if openingEnabled then
		lastOpeningTime = lastOpeningTime + deltaTime
		if lastOpeningTime >= openingSpeed then
			lastOpeningTime = 0
			CLIENT_REQUEST_22:InvokeServer({})
		end
	end
end))

local ChestOpenerSection = OpeningTab:CreateSection("Chest/Cauldron Opener")

local chestOpenerEnabled = false
local chestWalkEnabled = false
local selectedOpenerType = "All"
local openerTypes = {"All", "Cauldron", "Treasure Chest", "Dungeon Chest", "Serpent Egg", "Dragon Egg"}
local openerLoopThread = nil

OpeningTab:CreateDropdown({
	Name = "Opener Type",
	Options = openerTypes,
	CurrentOption = {"All"},
	MultipleOptions = false,
	Callback = function(Option)
		selectedOpenerType = Option[1]
	end,
})

OpeningTab:CreateToggle({
	Name = "Auto Open",
	CurrentValue = false,
	Callback = function(Value)
		chestOpenerEnabled = Value
		if Value then
			openerLoopThread = task.spawn(function()
				while chestOpenerEnabled do
					local foundTarget = false
					pcall(function()
						local char = LP.Character
						local hrp = char and char:FindFirstChild("HumanoidRootPart")
						if hrp then
							local bestTarget = nil
							local bestDist = math.huge
							
							local islands = workspace:FindFirstChild("Islands")
							if islands then
								for _, island in ipairs(islands:GetChildren()) do
									local blocks = island:FindFirstChild("Blocks")
									if blocks then
										for _, v in ipairs(blocks:GetChildren()) do
											local name = v.Name
											local isMatch = false
											if selectedOpenerType == "All" then
												if name:find("cauldron") or name:find("treasureChest") or name:find("dungeonChest") or name:find("serpentEgg") or name:find("dragonEgg") then
													isMatch = true
												end
											elseif selectedOpenerType == "Cauldron" and name:find("cauldron") then
												isMatch = true
											elseif selectedOpenerType == "Treasure Chest" and name:find("treasureChest") then
												isMatch = true
											elseif selectedOpenerType == "Dungeon Chest" and name:find("dungeonChest") then
												isMatch = true
											elseif selectedOpenerType == "Serpent Egg" and name:find("serpentEgg") then
												isMatch = true
											elseif selectedOpenerType == "Dragon Egg" and name:find("dragonEgg") then
												isMatch = true
											end
											
											if isMatch then
												local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
												if prompt and prompt.Enabled then
													local part = prompt.Parent
													if part and part:IsA("Attachment") then part = part.Parent end
													if part and part:IsA("Model") then
														part = part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart", true)
													end
													
													if part and part:IsA("BasePart") then
														local dist = (part.Position - hrp.Position).Magnitude
														if dist < bestDist then
															bestDist = dist
															bestTarget = {prompt = prompt, part = part}
														end
													end
												end
											end
										end
									end
								end
							end
							
							if bestTarget then
								foundTarget = true
								if chestWalkEnabled then
									local hum = char:FindFirstChild("Humanoid")
									if hum then
										hum:MoveTo(bestTarget.part.Position)
										
										local targetPos = bestTarget.part.Position
										local myPos = hrp.Position
										local dir = (targetPos - myPos) * Vector3.new(1, 0, 1)
										
										if dir.Magnitude > 1 then
											dir = dir.Unit
											local params = RaycastParams.new()
											local filter = {char, bestTarget.part}
											local targetModel = bestTarget.part:FindFirstAncestorOfClass("Model")
											if targetModel then table.insert(filter, targetModel) end
											params.FilterDescendantsInstances = filter
											params.FilterType = Enum.RaycastFilterType.Exclude
											local result = workspace:Raycast(myPos, dir * 4, params)
											if result and result.Instance and result.Instance.CanCollide then
												hum.Jump = true
											end
										end
									end
								end
								
								local dist = (bestTarget.part.Position - hrp.Position).Magnitude
								if dist <= bestTarget.prompt.MaxActivationDistance + 2 then
									if fireproximityprompt then
										fireproximityprompt(bestTarget.prompt)
									else
										local oldHold = bestTarget.prompt.HoldDuration
										bestTarget.prompt.HoldDuration = 0
										bestTarget.prompt:InputHoldBegin()
										task.wait()
										bestTarget.prompt:InputHoldEnd()
										bestTarget.prompt.HoldDuration = oldHold
									end
								end
							end
						end
					end)

					if not foundTarget then
						local islands = workspace:FindFirstChild("Islands")
						if islands then
							local detected = false
							local con = islands.DescendantAdded:Connect(function(desc)
								if (desc.Name:find("cauldron") or desc.Name:find("treasureChest") or desc.Name:find("dungeonChest") or desc.Name:find("serpentEgg") or desc.Name:find("dragonEgg")) then
									detected = true
								end
							end)
							local start = tick()
							while chestOpenerEnabled and not detected and (tick() - start < 1) do
								task.wait(0.1)
							end
							con:Disconnect()
						else
							task.wait(1)
						end
					else
						task.wait(0.1)
					end
				end
			end)
			registerLoop(openerLoopThread)
		else
			if openerLoopThread then
				task.cancel(openerLoopThread)
				openerLoopThread = nil
			end
		end
	end,
})

OpeningTab:CreateToggle({
	Name = "Walk to Target",
	CurrentValue = false,
	Callback = function(Value)
		chestWalkEnabled = Value
	end,
})

local ModulesSection = MiscTab:CreateSection("Modules")

local seedSpreaderEnabled = false
local selectedSeed = "wheat"
local seedCrops = {
	"onion", "carrot", "wheat", "berryBush", "blackberryBush", "blueberryBush", "cactus", "candyCane", "chiliPepper", "cranberryBush", "crystallineIvy", "dragonfruit", "grape", "melon", "optuntia", "pineapple", "potato", "pumpkin", "radish", "raspberryBush", "rice", "seaweed", "spinach", "spirit", "starfruit", "strawberryBush", "tomato", "vineStem", "voidParasite"
}
local cropLookup = {}
local formattedSeeds = {}
local seedMap = {}

for _, c in ipairs(seedCrops) do
	cropLookup[c] = true
	local display = formatItemName(c)
	table.insert(formattedSeeds, display)
	seedMap[display] = c
end
table.sort(formattedSeeds)

local original_namecall

if isExecComp then
	MiscTab:CreateToggle({
		Name = "Seed Spreader Override",
		CurrentValue = false,
		Flag = "SeedSpreaderToggle",
		Callback = function(Value)
			seedSpreaderEnabled = Value
		end,
	})

	MiscTab:CreateDropdown({
		Name = "Select Seed",
		Options = formattedSeeds,
		CurrentOption = {formatItemName("wheat")},
		MultipleOptions = false,
		Callback = function(Option)
			local display = Option[1]
			selectedSeed = seedMap[display] or "wheat"
		end,
	})

	task.spawn(function()
		local mt = getrawmetatable(game)
		original_namecall = mt.__namecall
		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			local method = getnamecallmethod()
			local method = getnamecallmethod and getnamecallmethod()
			if not method then return original_namecall(self, ...) end
			local args = {...}

			if method == "InvokeServer" and self.Name == "CLIENT_BLOCK_PLACE_REQUEST" and seedSpreaderEnabled then
				local char = LP.Character
				local tool = char and char:FindFirstChildWhichIsA("Tool")
				if tool and string.find(string.lower(tool.Name), "seedspreader") and type(args[1]) == "table" then
					local block = args[1].blockType
					if block then
						local clean = string.gsub(block, "_crop", "")
						if cropLookup[block] or cropLookup[clean] then
							args[1].blockType = selectedSeed
						end
					end
				end
			end

			if setnamecallmethod then
				setnamecallmethod(method)
			end
			return original_namecall(self, unpack(args))
		end)
		setreadonly(mt, true)
	end)
else
	MiscTab:CreateButton({
		Name = "Executor Not Supported",
		Callback = function()
			Rayfield:Notify({Title = "Compatibility", Content = "Your executor is missing required functions.", Image = 14563958666, Duration = 3})
		end,
	})
end

local originalSickleGetNearbyBlocks = nil
MiscTab:CreateToggle({
	Name = "Sickle Range Bypass",
	CurrentValue = false,
	Flag = "SickleRangeBypass",
	Callback = function(Value)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local TS = ReplicatedStorage:WaitForChild("TS", 5)
		if not TS then return end

		local SickleUtilsModule = TS:WaitForChild("tool"):WaitForChild("tools"):WaitForChild("tool-utils"):WaitForChild("sickle-utils")
		local SickleUtils = require(SickleUtilsModule)

		if not originalSickleGetNearbyBlocks then
			originalSickleGetNearbyBlocks = SickleUtils.SickleUtils.getNearbyBlocks
		end

		if Value then
			local BlockMetaModule = TS:WaitForChild("block"):WaitForChild("block-meta")
			local ArrayUtilModule = TS:WaitForChild("util"):WaitForChild("array-utils")
			local BlockUtilsModule = TS:WaitForChild("util"):WaitForChild("block-utils")

			local BlockMeta = require(BlockMetaModule).BlockMeta
			local ArrayUtil = require(ArrayUtilModule).ArrayUtil
			local BlockUtils = require(BlockUtilsModule).BlockUtils

			local OVERRIDE_RADIUS = 10
			local OVERRIDE_LIMIT = 100

			SickleUtils.SickleUtils.getNearbyBlocks = function(position, config)
				local regionSize = Vector3.new(OVERRIDE_RADIUS * 2, OVERRIDE_RADIUS * 2, OVERRIDE_RADIUS * 2)
				local cframe = CFrame.new(position)
				local overlapParams = OverlapParams.new()
				
				overlapParams.FilterType = Enum.RaycastFilterType.Exclude
				local player = game:GetService("Players").LocalPlayer
				if player and player.Character then
					overlapParams.FilterDescendantsInstances = {player.Character}
				else
					overlapParams.FilterDescendantsInstances = {}
				end
				
				local foundBlocks = {}
				local seenBlocks = {}
				local processedParents = {}
				
				local parts = game:GetService("Workspace"):GetPartBoundsInBox(cframe, regionSize, overlapParams)
				for i = 1, #parts do
					local part = parts[i]
					local parent = part.Parent
					
					if not parent or seenBlocks[parent] or processedParents[parent] then
						continue
					end

					local block = BlockUtils.getIslandBlockFromChild(part)
					
					if block then
						if not seenBlocks[block] then
							seenBlocks[block] = true
							
							local isValid = false
							
							if block:FindFirstChild("stage") then
								local meta = BlockMeta[block.Name]
								
								if meta then
									local noHarvest = meta.noPlayerHarvest
									
									if not noHarvest and meta.cropHarvestConfig then
										isValid = true
									end
								end
							end
							
							if isValid then
								table.insert(foundBlocks, block)
							end
						end
						
						if parent ~= block then
							processedParents[parent] = true
						end
					else
						processedParents[parent] = true
					end
				end
				
				return ArrayUtil.sortReduced(foundBlocks, OVERRIDE_LIMIT, function(a, b)
					local distA = a.Position - position
					local distB = b.Position - position
					return distA:Dot(distA) < distB:Dot(distB)
				end)
			end
		else
			if originalSickleGetNearbyBlocks then
				SickleUtils.SickleUtils.getNearbyBlocks = originalSickleGetNearbyBlocks
			end
		end
	end,
})

local FoodAutomationSection = MiscTab:CreateSection("Food Automation")

local eatLoopEnabled = false
local eatLoopThread = nil
local eatLoopDelay = 0.1

MiscTab:CreateToggle({
	Name = "Loop Eat Held Item",
	CurrentValue = false,
	Flag = "EatLoopToggle",
	Callback = function(Value)
		eatLoopEnabled = Value
		if eatLoopEnabled then
			eatLoopThread = task.spawn(function()
				while eatLoopEnabled do
					pcall(function()
						local char = LP.Character
						if char then
							local tool = char:FindFirstChildWhichIsA("Tool")
							if tool then
								CLIENT_EAT_FOOD:InvokeServer({tool = tool})
							end
						end
					end)
					task.wait(eatLoopDelay)
				end
			end)
			registerLoop(eatLoopThread)
		else
			if eatLoopThread then
				task.cancel(eatLoopThread)
				eatLoopThread = nil
			end
		end
	end,
})

MiscTab:CreateSlider({
	Name = "Eat Loop Delay",
	Range = {0.1, 900},
	Increment = 0.1,
	Suffix = " seconds",
	CurrentValue = 0.1,
	Flag = "EatLoopDelaySlider",
	Callback = function(Value)
		eatLoopDelay = Value
	end,
})

local UICustomizationSection = MiscTab:CreateSection("UI Customization")

MiscTab:CreateInput({
	Name = "Join Code Spoofer",
	CurrentValue = "",
	PlaceholderText = "Enter code...",
	RemoveTextAfterFocusLost = false,
	Flag = "JoinCodeSpooferInput",
	Callback = function(Text)
		local jc = LP:FindFirstChild("JoinCode")
		if jc then
			jc.Value = Text
		end
	end,
})

MiscTab:CreateToggle({
	Name = "Hardcore Mode UI",
	CurrentValue = false,
	Flag = "HardcoreModeToggle",
	Callback = function(Value)
		local hc = LP:FindFirstChild("HardcoreMode")
		if hc then
			hc.Value = Value
		end
	end,
})

local ExtraSection = MiscTab:CreateSection("Extra")

local inviteUsername = ""
MiscTab:CreateInput({
	Name = "Player Username",
	CurrentValue = "",
	PlaceholderText = "Username",
	RemoveTextAfterFocusLost = false,
	Flag = "InvitePlayerInput",
	Callback = function(Text)
		inviteUsername = Text
	end,
})

MiscTab:CreateButton({
	Name = "Invite Player",
	Callback = function()
		if inviteUsername == "" then return end
		task.spawn(function()
			local success, userId = pcall(function()
				return Players:GetUserIdFromNameAsync(inviteUsername)
			end)
			
			if success and userId then
				local CLIENT_INVITE = RS.rbxts_include.node_modules["@rbxts"].net.out._NetManaged:WaitForChild("client_request_8")
				CLIENT_INVITE:InvokeServer({
					userId = userId,
					name = inviteUsername
				})
				Rayfield:Notify({Title = "Invite Sent", Content = "Invited " .. inviteUsername, Duration = 3, Image = 11401835376})
			else
				Rayfield:Notify({Title = "Invite Failed", Content = "Could not find user: " .. inviteUsername, Duration = 3, Image = 11401835376})
			end
		end)
	end,
})

local SettingsSection = SettingsTab:CreateSection("Visuals")

local CircleToggle = false
local CircleSegments = 32
local CircleColor = Color3.fromRGB(200, 150, 255)
local CircleThickness = 3
local CircleRadius = vendingRadius
local CircleHeightOffset = 0.5
local CircleUpdateCounter = 0

local CircleLines = {}
for i = 1, CircleSegments do
	local line = Drawing.new("Line")
	line.Visible = false
	line.Color = CircleColor
	line.Thickness = CircleThickness
	table.insert(CircleLines, line)
end

local function UpdateCircle()
	if not CircleToggle then return end
	if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
	
	CircleUpdateCounter = CircleUpdateCounter + 1
	if CircleUpdateCounter < 2 then return end
	CircleUpdateCounter = 0
	
	local hrp = LP.Character.HumanoidRootPart
	local center = hrp.Position + Vector3.new(0, CircleHeightOffset, 0)

	local angleIncrement = math.pi * 2 / CircleSegments
	for i = 1, CircleSegments do
		local theta1 = angleIncrement * (i - 1)
		local theta2 = angleIncrement * i

		local x1 = center.X + math.cos(theta1) * CircleRadius
		local z1 = center.Z + math.sin(theta1) * CircleRadius
		local x2 = center.X + math.cos(theta2) * CircleRadius
		local z2 = center.Z + math.sin(theta2) * CircleRadius

		local pos1 = Vector3.new(x1, center.Y, z1)
		local pos2 = Vector3.new(x2, center.Y, z2)

		local screen1, onScreen1 = workspace.CurrentCamera:WorldToViewportPoint(pos1)
		local screen2, onScreen2 = workspace.CurrentCamera:WorldToViewportPoint(pos2)

		local line = CircleLines[i]
		line.From = Vector2.new(screen1.X, screen1.Y)
		line.To = Vector2.new(screen2.X, screen2.Y)
		line.Visible = onScreen1 and onScreen2
	end
end

registerConnection(RunS.RenderStepped:Connect(UpdateCircle))

local espLabels = {}
local espEnabled = false
local espCache = {}
local cachedVendingMachines = {}
local espScannerActive = false

local labelPool = {}
local function acquireLabel()
	local label
	if #labelPool > 0 then
		label = table.remove(labelPool)
	else
		label = Drawing.new("Text")
		label.Size = 14
		label.Center = true
		label.Outline = true
	end
	label.Visible = true
	return label
end

releaseLabel = function(lab)
	if not lab then return end
	pcall(function()
		lab.Visible = false
		lab.Text = ""
	end)
	table.insert(labelPool, lab)
end

local ESP_UPDATE_INTERVAL = 0.3
local espScanAccumulator = 0
local MAX_ESP_LABELS = 2

local _candidates = {}
local _enforceList = {}
local _tostring = tostring
local _table_concat = table.concat
local _math_huge = math.huge

local function getTableSize(t)
	local n = 0
	for _ in pairs(t) do n = n + 1 end
	return n
end

local function clearTable(t)
	for i = 1, #t do t[i] = nil end
end

local function enforceMaxEsp()
	local count = getTableSize(espLabels)
	if count <= MAX_ESP_LABELS then return end

	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for i = 1, #_enforceList do _enforceList[i] = nil end
	local hrpPos = hrp.Position
	for v, data in pairs(espLabels) do
		local model = data.model
		if model and model.Parent then
			local pos = data.worldPos or getVendingTopPosition(model)
			if pos then
				local dx = pos.X - hrpPos.X
				local dy = pos.Y - hrpPos.Y
				local dz = pos.Z - hrpPos.Z
				local distSq = dx * dx + dy * dy + dz * dz
				_enforceList[#_enforceList + 1] = {v = v, distSq = distSq}
			else
				_enforceList[#_enforceList + 1] = {v = v, distSq = math.huge}
			end
		else
			_enforceList[#_enforceList + 1] = {v = v, distSq = math.huge}
		end
	end

	table.sort(_enforceList, function(a, b) return a.distSq > b.distSq end)

	while getTableSize(espLabels) > MAX_ESP_LABELS do
		local entry = table.remove(_enforceList, 1)
		if not entry then break end
		local v = entry.v
		if espLabels[v] then
			pcall(function() releaseLabel(espLabels[v].label) end)
			espLabels[v] = nil
			espCache[v] = nil
		end
	end
end

local function EspScannerLoop()
	while espEnabled and espScannerActive do
		local newCache = {}
		local islands = WS:FindFirstChild("Islands")
		if islands then
			for _, island in ipairs(islands:GetChildren()) do
				if not espEnabled then break end
				local blocks = island:FindFirstChild("Blocks")
				if blocks then
					local children = blocks:GetChildren()
					for i, v in ipairs(children) do
						if not espEnabled then break end
						if v.Name == "vendingMachine1" or v.Name == "vendingMachine" or v.Name == "vendingMachineIndustrial" then
							local part = v:FindFirstChildWhichIsA("BasePart") or v.PrimaryPart
							if part then
								table.insert(newCache, {v = v, part = part})
							end
						end
						if i % 300 == 0 then task.wait() end
					end
				end
				task.wait()
			end
		end
		cachedVendingMachines = newCache
		task.wait(3)
	end
	espScannerActive = false
end

local function UpdateVendingESP_Scan(deltaTime)
	if not espEnabled then return end
	
	espScanAccumulator = espScanAccumulator + (deltaTime or 0)
	if espScanAccumulator < ESP_UPDATE_INTERVAL then
		return
	end
	espScanAccumulator = 0

	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		for _, labelData in pairs(espLabels) do
			pcall(function() releaseLabel(labelData.label) end)
		end
		espLabels = {}
		espCache = {}
		return
	end

	local islands = WS:FindFirstChild("Islands")
	if not islands then return end

	clearTable(_candidates)
	local candidates = _candidates
	local vendingRadiusSq = vendingRadius * vendingRadius
	local hrpPos = hrp.Position

	for _, data in ipairs(cachedVendingMachines) do
		local v = data.v
		local part = data.part
		if not v or not v.Parent or not part or not part.Parent then continue end

		local partPos = part.Position
		local dx = partPos.X - hrpPos.X
		local dy = partPos.Y - hrpPos.Y
		local dz = partPos.Z - hrpPos.Z
		local distSq = dx * dx + dy * dy + dz * dz
		
		if distSq > vendingRadiusSq then continue end

		candidates[#candidates + 1] = {v = v, topPos = partPos + Vector3.new(0, 2, 0), distSq = distSq}
	end

	local activeVendings = {}
	local limit = math.min(#candidates, MAX_ESP_LABELS)
	
	if #candidates > MAX_ESP_LABELS then
		table.sort(candidates, function(a,b) return a.distSq < b.distSq end)
	end
	
	for i = 1, limit do
		local entry = candidates[i]
		local v = entry.v
		activeVendings[v] = true
		
		local coinBalance = v:FindFirstChild("CoinBalance")
		local coins = coinBalance and coinBalance.Value or 0
		local contents = v:FindFirstChild("SellingContents")
		local itemCount = 0
		if contents then
			for _, item in ipairs(contents:GetChildren()) do
				local amt = item:FindFirstChild("Amount")
				local a = 0
				if amt and type(amt.Value) == "number" then
					a = amt.Value
				end
				if a > 0 then
					itemCount = itemCount + a
				end
			end
		end
		
		local hasChanged = not espCache[v]
		if espCache[v] then
			local cached = espCache[v]
			hasChanged = cached.coins ~= coins or cached.itemCount ~= itemCount
		end

		if hasChanged then
			espCache[v] = { coins = coins, itemCount = itemCount }

			local labelText = coins .. " Coins | " .. itemCount .. " Items"
			if espLabels[v] then
				local label = espLabels[v].label
				if label then
					label.Text = labelText
					espLabels[v].worldPos = entry.topPos
				end
			else
				local label = acquireLabel()
				if label then
					label.Text = labelText
					label.Color = Color3.fromRGB(100, 200, 255)
					label.Size = 13
					label.Center = true
					label.Outline = true
					espLabels[v] = { label = label, model = entry.v, worldPos = entry.topPos }
				end
			end
		end
	end

	for v, labelData in pairs(espLabels) do
		if not activeVendings[v] then
			pcall(function() releaseLabel(labelData.label) end)
			espLabels[v] = nil
			espCache[v] = nil
		end
	end

	enforceMaxEsp()
end

local function UpdateVendingESP_Render()
	if not espEnabled then return end
	
	local cam = workspace.CurrentCamera
	if not cam then return end

	for v, labelData in pairs(espLabels) do
		local model = labelData.model
		if not model or not model.Parent then
			pcall(function() releaseLabel(labelData.label) end)
			espLabels[v] = nil
			espCache[v] = nil
		else
			local label = labelData.label
			if label then
				local worldPos = labelData.worldPos or getVendingTopPosition(model)
				if not worldPos then continue end
				
				local pos = worldPos + Vector3.new(0, 1.5, 0)
				local screenPos, onScreen = cam:WorldToViewportPoint(pos)
				
				if onScreen then
					label.Position = Vector2.new(screenPos.X, screenPos.Y)
					label.Visible = true
				else
					label.Visible = false
				end
			end
		end
	end
end

registerConnection(RunS.Heartbeat:Connect(UpdateVendingESP_Scan))
registerConnection(RunS.RenderStepped:Connect(UpdateVendingESP_Render))




local function getVendingMachineAtMouse()
	local mouse = LP:GetMouse()
	local camera = workspace.CurrentCamera
	local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
	
	local islands = WS:FindFirstChild("Islands")
	if not islands then return nil end
	
	local closest = nil
	local closestDist = math.huge
	
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local searchRadius = 100
	
	for _, island in ipairs(islands:GetChildren()) do
		local blocks = island:FindFirstChild("Blocks")
		if not blocks then continue end
		
		for _, v in ipairs(blocks:GetChildren()) do
			if v.Name ~= "vendingMachine1" and v.Name ~= "vendingMachine" and v.Name ~= "vendingMachineIndustrial" then continue end
			
			local part = v:FindFirstChildWhichIsA("BasePart")
			if not part then continue end
			
			if hrp and (part.Position - hrp.Position).Magnitude > searchRadius then continue end
			
			local bbox = getVendingBoundingBox(v)
			if not bbox then continue end
			
			local minP, maxP = bbox.min, bbox.max
			local rayOrigin = unitRay.Origin
			local rayDirection = unitRay.Direction
			
			local components = {{rayOrigin.X, rayDirection.X}, {rayOrigin.Y, rayDirection.Y}, {rayOrigin.Z, rayDirection.Z}}
			local minBounds = {minP.X, minP.Y, minP.Z}
			local maxBounds = {maxP.X, maxP.Y, maxP.Z}
			
			local tmin, tmax = -math.huge, math.huge
			local hit = true
			for axis = 1, 3 do
				local rayOrig = components[axis][1]
				local rayDir = components[axis][2]
				if math.abs(rayDir) > 1e-6 then
					local t1 = (minBounds[axis] - rayOrig) / rayDir
					local t2 = (maxBounds[axis] - rayOrig) / rayDir
					if t1 > t2 then t1, t2 = t2, t1 end
					tmin = math.max(tmin, t1)
					tmax = math.min(tmax, t2)
				elseif rayOrig < minBounds[axis] or rayOrig > maxBounds[axis] then
					hit = false
					break
				end
			end
			
			if hit and tmin <= tmax and tmin > 0 then
				if tmin < closestDist then
					closestDist = tmin
					closest = v
				end
			end
		end
	end
	
	return closest
end

registerConnection(UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not selectionModeEnabled then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local isCtrlHeld = UIS:IsKeyDown(Enum.KeyCode.LeftAlt) or UIS:IsKeyDown(Enum.KeyCode.RightAlt) or
							UIS:IsKeyDown(Enum.KeyCode.LeftMeta) or UIS:IsKeyDown(Enum.KeyCode.RightMeta)
		if isCtrlHeld then
			local vending = getVendingMachineAtMouse()
			if vending then
				selectedVendingMachines[vending] = not selectedVendingMachines[vending]
				if not selectedVendingMachines[vending] then
					selectedVendingMachines[vending] = nil
				end
			end
		end
	end
end))

SettingsTab:CreateToggle({
	Name = "Show Vending Radius",
	CurrentValue = false,
	Flag = "ShowCircleToggle",
	Callback = function(Value)
		CircleToggle = Value
		if not Value then
			for _, line in ipairs(CircleLines) do
				line.Visible = false
			end
		end
	end,
})

SettingsTab:CreateToggle({
	Name = "Show Vending ESP (Laggy)",
	CurrentValue = false,
	Flag = "ShowVendingESP",
	Callback = function(Value)
		espEnabled = Value
		if not espEnabled then
			espScannerActive = false
			for _, labelData in pairs(espLabels) do
				releaseLabel(labelData.label)
			end
			espLabels = {}
			espCache = {}
		else
			if not espScannerActive then
				espScannerActive = true
				task.spawn(EspScannerLoop)
			end
		end
	end,
})

SettingsTab:CreateSlider({
	Name = "Max ESP Labels",
	Range = {1, 100},
	Increment = 1,
	Suffix = " labels",
	CurrentValue = MAX_ESP_LABELS,
	Flag = "MaxESPLabelsSlider",
	Callback = function(Value)
		MAX_ESP_LABELS = math.max(0, math.floor(Value))
		enforceMaxEsp()
	end,
})

SettingsTab:CreateDivider()

local originalPerformanceSettings = nil
SettingsTab:CreateToggle({
	Name = "Performance Mode",
	CurrentValue = false,
	Flag = "PerformanceModeToggle",
	Callback = function(Value)
		local Lighting = game:GetService("Lighting")
		if Value then
			if not originalPerformanceSettings then
				originalPerformanceSettings = {
					GlobalShadows = Lighting.GlobalShadows,
					Technology = Lighting.Technology,
					QualityLevel = settings().Rendering.QualityLevel,
				}
			end

			Lighting.GlobalShadows = false
			Lighting.Technology = Enum.Technology.Compatibility
			settings().Rendering.QualityLevel = 1
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				end
			end
		else
			if originalPerformanceSettings then
				Lighting.GlobalShadows = originalPerformanceSettings.GlobalShadows
				Lighting.Technology = originalPerformanceSettings.Technology
				settings().Rendering.QualityLevel = originalPerformanceSettings.QualityLevel
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
						v.Enabled = true
					end
				end
				originalPerformanceSettings = nil
			end
		end
	end,
})

local ConfigSection = SettingsTab:CreateSection("Configuration")

local ignoreRadiusEnabled = false

local VendingRadiusSlider = SettingsTab:CreateSlider({
	Name = "Vending Radius",
	Range = {5, 450},
	Increment = 0.5,
	Suffix = " studs",
	CurrentValue = vendingRadius,
	Flag = "VendingRadiusSlider",
	Callback = function(Value)
		if not ignoreRadiusEnabled then
			vendingRadius = Value
			CircleRadius = Value
		end
	end,
})

SettingsTab:CreateToggle({
	Name = "Ignore Radius",
	CurrentValue = false,
	Flag = "IgnoreRadiusToggle",
	Callback = function(Value)
		ignoreRadiusEnabled = Value
		if Value then
			vendingRadius = 10000
			CircleRadius = 10000
			if VendingRadiusSlider.Disable then VendingRadiusSlider:Disable() end
		else
			vendingRadius = 15
			CircleRadius = 15
			if VendingRadiusSlider.Enable then VendingRadiusSlider:Enable() end
		end
	end,
})

SettingsTab:CreateDivider()

SettingsTab:CreateToggle({
	Name = "Selection Mode (Alt+Click)",
	CurrentValue = false,
	Flag = "SelectionModeToggle",
	Callback = function(Value)
		selectionModeEnabled = Value
		if not Value then
			for vending, lines in pairs(selectionBoxLines) do
				for _, line in ipairs(lines) do
					pcall(function() line:Remove() end)
				end
			end
			selectionBoxLines = {}
			selectedVendingMachines = {}
			Rayfield:Notify({Title = "Selection Mode", Content = "Selection Mode Disabled", Duration = 2, Image = 11401835376})
		else
			Rayfield:Notify({Title = "Selection Mode", Content = "Hold Alt and click vending machines to select them", Duration = 3, Image = 11401835376})
		end
	end,
})

SettingsTab:CreateButton({
	Name = "Clear Selection",
	Callback = function()
		for vending, lines in pairs(selectionBoxLines) do
			for _, line in ipairs(lines) do
				pcall(function() line:Remove() end)
			end
		end
		selectionBoxLines = {}
		selectedVendingMachines = {}
		vendingBoundingBoxCache = {}
		Rayfield:Notify({Title = "Selection", Content = "All selections cleared", Duration = 2, Image = 11401835376})
	end,
})

local SettingsSection = SettingsTab:CreateSection("Game Settings")

local SeasonOptions = {"summer", "winter", "fall"}
local SeasonChoice = "summer"

local SeasonPresses = {}
local PRESS_THRESHOLD = 10
local PRESS_WINDOW = 5

local SeasonDropdown = SettingsTab:CreateDropdown({
	Name = "Season",
	Options = SeasonOptions,
	CurrentOption = {SeasonChoice},
	MultipleOptions = false,
	Flag = "SeasonDropdown",
	Callback = function(Options)
		SeasonChoice = Options[1] or "summer"
	end,
})

local SetSeasonButton = SettingsTab:CreateButton({
	Name = "Set Season",
	Callback = function()
		local currentTime = tick()
		
		for i = #SeasonPresses, 1, -1 do
			if currentTime - SeasonPresses[i] > PRESS_WINDOW then
				table.remove(SeasonPresses, i)
			end
		end
		
		table.insert(SeasonPresses, currentTime)
		
		if #SeasonPresses >= PRESS_THRESHOLD then
			Rayfield:Notify({Title = "Secret Message", Content = "Jolly is a femboy", Duration = 5, Image = 11401835376})
			SeasonPresses = {}
		else
			local s = SeasonChoice or "summer"
			local seasonObj = WS:FindFirstChild("Season")
			if seasonObj and seasonObj.Value ~= nil then
				pcall(function() seasonObj.Value = s end)
				Rayfield:Notify({Title = "Season", Content = "Set Season to " .. s, Duration = 3, Image = 11401835376})
			else
				pcall(function() WS:SetAttribute("Season", s) end)
				Rayfield:Notify({Title = "Season", Content = "Set workspace Season attribute to " .. s, Duration = 3, Image = 11401835376})
			end
		end
	end,
})

local SettingsSection = SettingsTab:CreateSection("Danger Zone")

_G.VendingManagerCleanup = function()
	if isCleaningUp then return end
	isCleaningUp = true

	for _, connection in ipairs(activeConnections) do
		if connection then
			if connection.Disconnect then
				connection:Disconnect() 
			elseif connection.disconnect then
				connection:disconnect()
			end
		end
	end
	activeConnections = {}

	for _, thread in ipairs(activeLoops) do
		if thread then task.cancel(thread) end
	end
	activeLoops = {}

	loopCoinEnabled = false
	loopItemEnabled = false
	openingEnabled = false
	chestOpenerEnabled = false
	chestLoopEnabled = false
	atmLoopEnabled = false
	espScannerActive = false
	seedSpreaderEnabled = false
	eatLoopEnabled = false

	if original_namecall then
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		mt.__namecall = original_namecall
		setreadonly(mt, true)
		original_namecall = nil
	end

	if originalSickleGetNearbyBlocks then
		local TS = RS:FindFirstChild("TS")
		if TS then
			local SickleUtilsModule = TS:FindFirstChild("tool") and TS.tool:FindFirstChild("tools") and TS.tool.tools:FindFirstChild("tool-utils") and TS.tool.tools["tool-utils"]:FindFirstChild("sickle-utils")
			if SickleUtilsModule then
				require(SickleUtilsModule).SickleUtils.getNearbyBlocks = originalSickleGetNearbyBlocks
			end
		end
	end

	if CircleLines then
		for _, line in ipairs(CircleLines) do line:Remove() end
	end
	CircleLines = {}

	if selectionBoxLines then
		for _, lines in pairs(selectionBoxLines) do
			for _, line in ipairs(lines) do line:Remove() end
		end
	end
	selectionBoxLines = {}
	selectedVendingMachines = {}
	vendingBoundingBoxCache = {}

	if espLabels then
		for _, data in pairs(espLabels) do if data.label then data.label:Remove() end end
	end
	espLabels = {}
	espCache = {}
	if labelPool then
		for _, lab in ipairs(labelPool) do lab:Remove() end
	end
	labelPool = {}
	
	local c = game:GetService("CoreGui"):FindFirstChild("VendingMachineListUI")
	if c then c:Destroy() end
	if gethui then
		local h = gethui():FindFirstChild("VendingMachineListUI")
		if h then h:Destroy() end
	end

	if Window and type(Window.Destroy) == "function" then Window:Destroy() end
	if Rayfield and type(Rayfield.Destroy) == "function" then Rayfield:Destroy() end
	Window, Rayfield = nil, nil

	_G.VendingManagerCleanup = nil
end

if Window and type(Window.Destroy) == "function" then
	local oldDestroy = Window.Destroy
	Window.Destroy = function(self, ...)
		if not isCleaningUp and _G.VendingManagerCleanup then
			pcall(_G.VendingManagerCleanup)
		else
			return oldDestroy(self, ...)
		end
	end
end

registerConnection(LP.OnTeleport:Connect(function()
	if _G.VendingManagerCleanup then
		pcall(_G.VendingManagerCleanup)
	end
end))

SettingsTab:CreateButton({
	Name = "Unload Script",
	Callback = function()
		if _G.VendingManagerCleanup then
			_G.VendingManagerCleanup()
		end
	end,
})
