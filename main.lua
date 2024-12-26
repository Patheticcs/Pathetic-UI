local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.025, 0, 0, 0)
MainFrame.Size = UDim2.new(0, 771, 0, 700)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame


local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, 0, 0, 70)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Pathetic"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = false
TextLabel.TextSize = 48
TextLabel.Position = UDim2.new(0, 0, 0, 30)
TextLabel.Parent = MainFrame

local Frame_3 = Instance.new("Frame")
Frame_3.BackgroundTransparency = 1
Frame_3.Size = UDim2.new(1, 0, 1, -50)
Frame_3.Position = UDim2.new(0, 0, 0, 50)
Frame_3.Parent = MainFrame


local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 130, 0, 130)
UIGridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIGridLayout.Parent = Frame_3

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Frame_3


local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 110)
UIPadding.Parent = Frame_3

local function createButton(text, size)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 0
	button.Size = size
	button.Font = Enum.Font.GothamBold
	button.Text = text
	button.TextColor3 = Color3.fromRGB(0, 0, 0)
	button.TextScaled = false
	button.TextSize = 14
	button.Parent = Frame_3

	-- Add rounded corners to the button
	local buttonUICorner = Instance.new("UICorner")
	buttonUICorner.CornerRadius = UDim.new(0, 16)  -- Adjust the corner radius as needed
	buttonUICorner.Parent = button

	return button
end


local function toggleButtonState(button, isEnabled)
	if isEnabled then
		button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		button.TextColor3 = Color3.fromRGB(0, 0, 0)
	end
end

local dragging = false
local dragInput, startPos, startPosFrame

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startPosFrame = MainFrame.Position
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - startPos
		MainFrame.Position = UDim2.new(
			startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X,
			startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y
		)
	end
end)

MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

local ButtonResize = createButton("Hitbox Expander", UDim2.new(0, 150, 0, 66))
local resizeEnabled = false
local originalSizes = {}

ButtonResize.MouseButton1Click:Connect(function()
	resizeEnabled = not resizeEnabled
	toggleButtonState(ButtonResize, resizeEnabled)

	_G.Disabled = not resizeEnabled
	_G.HeadSize = 25

	if resizeEnabled then
		for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
			if player.Name ~= game:GetService('Players').LocalPlayer.Name then
				pcall(function()
					local character = player.Character
					if character and character:FindFirstChild('HumanoidRootPart') then
						originalSizes[player.Name] = character.HumanoidRootPart.Size
					end
				end)
			end
		end
	end

	game:GetService('RunService').RenderStepped:Connect(function()
		for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
			if player.Name ~= game:GetService('Players').LocalPlayer.Name then
				pcall(function()
					local character = player.Character
					if character and character:FindFirstChild('HumanoidRootPart') then
						local hrp = character.HumanoidRootPart
						local humanoid = character:FindFirstChildOfClass('Humanoid')

						if not _G.Disabled then
							hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
							hrp.Transparency = 0.99
							hrp.BrickColor = BrickColor.new("Red")
							hrp.Material = "Neon"
							hrp.CanCollide = false

							if humanoid then
								humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
							end
						else
							-- Restore original size and properties
							if originalSizes[player.Name] then
								hrp.Size = originalSizes[player.Name]
								hrp.Transparency = 0
								hrp.BrickColor = BrickColor.new("Medium stone grey")
								hrp.Material = "Plastic"
								hrp.CanCollide = true

								if humanoid then
									humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
								end
							end
						end
					end
				end)
			end
		end
	end)
end)

-- 666 Button
local ButtonDark = createButton("666", UDim2.new(0, 150, 0, 40))
local is666ModeEnabled = false

local originalLighting = {
	ClockTime = Lighting.ClockTime,
	FogColor = Lighting.FogColor,
	FogStart = Lighting.FogStart,
	FogEnd = Lighting.FogEnd,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}

-- Function to capture original appearance
local function captureOriginalState(character)
	local state = {}

	-- Store states for all relevant objects
	for _, obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			state[obj] = {
				Type = "BasePart",
				Color = obj.Color,
				Material = obj.Material,
				Transparency = obj.Transparency
			}
		elseif obj:IsA("Decal") and obj.Name == "face" then
			state[obj] = {
				Type = "Decal",
				Texture = obj.Texture,
				Transparency = obj.Transparency,
				Color3 = obj.Color3
			}
		end
	end

	return state
end

-- Function to restore original appearance
local function restoreOriginalState(character, originalState)
	if not character or not originalState then return end

	for obj, state in pairs(originalState) do
		if obj and obj.Parent then  -- Check if object still exists
			if state.Type == "BasePart" then
				obj.Color = state.Color
				obj.Material = state.Material
				obj.Transparency = state.Transparency
			elseif state.Type == "Decal" and obj.Name == "face" then
				obj.Texture = state.Texture
				obj.Transparency = state.Transparency
				obj.Color3 = state.Color3
			end
		end
	end

	-- Remove fire effect if it exists
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		local fire = humanoidRootPart:FindFirstChild("DarkModeFire")
		if fire then
			fire:Destroy()
		end
	end

	-- Remove black skin color and revert to original skin color
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- Retrieve the original HumanoidDescription
		local originalDescription = players:GetHumanoidDescriptionFromUserId(humanoid.UserId)

		-- Set the skin colors based on the original description
		if originalDescription then
			humanoid:ApplyDescription(originalDescription)
		end
	end
end

-- Store original states for each player
local originalStates = {}

-- Function to apply 666 effect
local function apply666Effect(character)
	if not character then return end

	local player = Players:GetPlayerFromCharacter(character)
	if player and not originalStates[player.UserId] then
		originalStates[player.UserId] = captureOriginalState(character)
	end

	for _, obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Color = Color3.fromRGB(0, 0, 0)
			obj.Material = Enum.Material.SmoothPlastic
		elseif obj:IsA("Decal") and obj.Name == "face" then
			obj.Texture = "rbxassetid://45345525662"
		end
	end

	-- Add fire effect
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart and not humanoidRootPart:FindFirstChild("DarkModeFire") then
		local fire = Instance.new("Fire")
		fire.Name = "DarkModeFire"
		fire.Size = 15
		fire.Heat = 50
		fire.Color = Color3.fromRGB(255, 0, 0)
		fire.SecondaryColor = Color3.fromRGB(255, 127, 0)
		fire.Parent = humanoidRootPart
	end
end

ButtonDark.MouseButton1Click:Connect(function()
	is666ModeEnabled = not is666ModeEnabled
	toggleButtonState(ButtonDark, is666ModeEnabled)

	if is666ModeEnabled then
		-- Clear previous states
		originalStates = {}

		-- Apply dark lighting
		Lighting.ClockTime = 0
		Lighting.FogColor = Color3.fromRGB(0, 0, 0)
		Lighting.FogStart = 0
		Lighting.FogEnd = 300
		Lighting.Ambient = Color3.fromRGB(0, 0, 0)
		Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)

		-- Start the continuous effect loop
		spawn(function()
			while is666ModeEnabled do
				for _, player in ipairs(Players:GetPlayers()) do
					if player.Character then
						apply666Effect(player.Character)
					end
				end
				wait(0.1)
			end
		end)

	else
		-- Restore lighting
		Lighting.ClockTime = originalLighting.ClockTime
		Lighting.FogColor = originalLighting.FogColor
		Lighting.FogStart = originalLighting.FogStart
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.Ambient = originalLighting.Ambient
		Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient

		-- Restore all players to their original state
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and originalStates[player.UserId] then
				restoreOriginalState(player.Character, originalStates[player.UserId])
			end
		end
	end
end)

-- Handle character respawning
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if is666ModeEnabled then
			-- If mode is enabled, capture state after character loads
			wait(0.1)  -- Wait for character to fully load
			originalStates[player.UserId] = captureOriginalState(character)
		else
			-- If mode is disabled, ensure character loads with original appearance
			originalStates[player.UserId] = nil
		end
	end)
end)

-- Raining Fire Button
local ButtonFire = createButton("Raining Fire", UDim2.new(0, 150, 0, 40))
local fireEnabled = false

ButtonFire.MouseButton1Click:Connect(function()
	fireEnabled = not fireEnabled
	toggleButtonState(ButtonFire, fireEnabled)

	if fireEnabled then
		spawn(function()
			while fireEnabled do
				local character = Players.LocalPlayer.Character
				if character then
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						local fireball = Instance.new("Part")
						fireball.Shape = Enum.PartType.Ball
						fireball.Material = Enum.Material.Neon
						fireball.Size = Vector3.new(8, 8, 8)
						fireball.Position = rootPart.Position + Vector3.new(math.random(-50, 50), math.random(20, 100), math.random(-50, 50))
						fireball.Anchored = true
						fireball.CanCollide = false
						fireball.Color = Color3.fromRGB(255, 100, 0)
						fireball.Parent = workspace

						local fire = Instance.new("Fire")
						fire.Size = 25
						fire.Heat = 50
						fire.Color = Color3.fromRGB(255, 0, 0)
						fire.SecondaryColor = Color3.fromRGB(255, 127, 0)
						fire.Parent = fireball

						local light = Instance.new("PointLight")
						light.Color = Color3.fromRGB(255, 150, 0)
						light.Range = 20
						light.Brightness = 5
						light.Parent = fireball

						game:GetService("Debris"):AddItem(fireball, 5)
					end
				end
				wait(0.5)
			end
		end)
	end
end)

-- Fly Button
local ButtonFly = createButton("Fly", UDim2.new(0, 150, 0, 40))
local flying = false

ButtonFly.MouseButton1Click:Connect(function()
	flying = not flying
	toggleButtonState(ButtonFly, flying)

	local character = Players.LocalPlayer.Character
	if not character then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	if flying then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FlyForce"
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = humanoidRootPart

		spawn(function()
			while flying and humanoidRootPart and bodyVelocity do
				local moveDirection = Vector3.new(
					UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0),
					UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0),
					UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0)
				)

				bodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveDirection * 100)
				wait()
			end
		end)
	else
		local bodyVelocity = humanoidRootPart:FindFirstChild("FlyForce")
		if bodyVelocity then
			bodyVelocity:Destroy()
		end
	end
end)

-- No Clip Button
local ButtonNoClip = createButton("No Clip", UDim2.new(0, 150, 0, 40))
local noclipping = false
local noclipConnection

ButtonNoClip.MouseButton1Click:Connect(function()
	noclipping = not noclipping
	toggleButtonState(ButtonNoClip, noclipping)if noclipping then
		noclipConnection = game:GetService('RunService').Stepped:Connect(function()
			if noclipping then
				local character = Players.LocalPlayer.Character
				if character then
					for _, part in pairs(character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
	end
end)

-- Create ESP Button

local ButtonESP = createButton("ESP", UDim2.new(0, 150, 0, 40))
local buttonUICorner = Instance.new("UICorner")
buttonUICorner.CornerRadius = UDim.new(0, 16)
buttonUICorner.Parent = ButtonESP


local espEnabled = false  -- Track the state of ESP
local highlights = {}  -- Store highlight objects for easy removal

-- Simple ESP Script for Roblox (Highlights the body of players in white with a black outline)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to create the ESP highlight
local function createESP(player)
	local char = player.Character
	if not char then return end

	-- Create the Highlight object
	local highlight = Instance.new("Highlight")
	highlight.Parent = game.CoreGui
	highlight.Adornee = char
	highlight.FillColor = Color3.fromRGB(255, 255, 255)  -- White highlight
	highlight.OutlineColor = Color3.fromRGB(0, 0, 0)  -- Black outline
	highlight.FillTransparency = 0.6  -- Adjust transparency of highlight
	highlight.OutlineTransparency = 0.5  -- Adjust transparency of outline

	-- Store the highlight object for later removal
	highlights[player] = highlight

	-- Clean up when the player is removed
	player.CharacterRemoving:Connect(function()
		highlight:Destroy()
		highlights[player] = nil
	end)
end

-- Enable ESP for each player, including those already in the game
local function enableESPForAllPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		player.CharacterAdded:Connect(function()
			if espEnabled then
				createESP(player)
			end
		end)

		-- If player already has a character when the script starts, create the ESP
		if player.Character then
			createESP(player)
		end
	end
end

-- Disable ESP by destroying all the highlights
local function disableESP()
	for player, highlight in pairs(highlights) do
		if highlight then
			highlight:Destroy()
		end
	end
	highlights = {}  -- Clear the stored highlights
end

-- Button click function for enabling/disabling ESP
ButtonESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleButtonState(ButtonESP, espEnabled)

	if espEnabled then
		enableESPForAllPlayers()  -- Enable ESP for players
	else
		disableESP()  -- Disable ESP and remove all highlights
	end
end)

-- Listen for new players joining and create ESP for them if enabled
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if espEnabled then
			createESP(player)
		end
	end)
end)

-- Cleanup any existing ESP on players when the script starts
if espEnabled then
	enableESPForAllPlayers()
end

-- INF Jump Button
local ButtonINFJump = createButton("INF Jump", UDim2.new(0, 150, 0, 40))
local InfiniteJumpEnabled = false

game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJumpEnabled then
		game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

ButtonINFJump.MouseButton1Click:Connect(function()
	InfiniteJumpEnabled = not InfiniteJumpEnabled
	toggleButtonState(ButtonINFJump, InfiniteJumpEnabled)
end)

-- Aimbot Button
local ButtonAimbot = createButton("Aimbot", UDim2.new(0, 150, 0, 40))
local aimbotEnabled = false

ButtonAimbot.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	toggleButtonState(ButtonAimbot, aimbotEnabled)

	if aimbotEnabled then
		local Camera = workspace.CurrentCamera
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local TweenService = game:GetService("TweenService")
		local LocalPlayer = Players.LocalPlayer
		local Holding = false
		local maxDistance = 1000 -- Distance limit for the aimbot (in studs)

		_G.AimbotEnabled = true
		_G.TeamCheck = false
		_G.AimPart = "Head"
		_G.Sensitivity = 0
		_G.CircleSides = 64
		_G.CircleColor = Color3.fromRGB(255, 255, 255)
		_G.CircleTransparency = 0
		_G.CircleRadius = 200
		_G.CircleFilled = false
		_G.CircleVisible = true
		_G.CircleThickness = 1

		local FOVCircle = Drawing.new("Circle")
		FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
		FOVCircle.Radius = _G.CircleRadius
		FOVCircle.Filled = _G.CircleFilled
		FOVCircle.Color = _G.CircleColor
		FOVCircle.Visible = _G.CircleVisible
		FOVCircle.Transparency = _G.CircleTransparency
		FOVCircle.NumSides = _G.CircleSides
		FOVCircle.Thickness = _G.CircleThickness

		-- Function to get the closest player
		local function GetClosestPlayer()
			local closestPlayer = nil
			local closestDistance = _G.CircleRadius

			for _, player in pairs(Players:GetPlayers()) do
				if player.Name ~= LocalPlayer.Name then
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild(_G.AimPart) then
						local aimPartPos = player.Character[_G.AimPart].Position
						local screenPos = Camera:WorldToScreenPoint(aimPartPos)
						local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
						local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

						-- Get the distance between the local player and the target player
						local playerDistance = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude

						if distance < closestDistance and playerDistance <= maxDistance then
							closestPlayer = player
							closestDistance = distance
						end
					end
				end
			end

			return closestPlayer
		end

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton2 then
				Holding = true
			end
		end)

		UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton2 then
				Holding = false
			end
		end)

		RunService.RenderStepped:Connect(function()
			if aimbotEnabled then
				FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
				FOVCircle.Radius = _G.CircleRadius
				FOVCircle.Filled = _G.CircleFilled
				FOVCircle.Color = _G.CircleColor
				FOVCircle.Visible = _G.CircleVisible
				FOVCircle.Transparency = _G.CircleTransparency
				FOVCircle.NumSides = _G.CircleSides
				FOVCircle.Thickness = _G.CircleThickness

				if Holding then
					local targetPlayer = GetClosestPlayer()
					if targetPlayer then
						local targetPos = targetPlayer.Character[_G.AimPart].Position
						TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
							CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
						}):Play()
					end
				end
			end
		end)
	else
		_G.AimbotEnabled = false
		_G.CircleVisible = false
		if FOVCircle then
			FOVCircle.Visible = false
		end
	end
end)
