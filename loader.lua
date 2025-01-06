if not LPH_OBFUSCATED then LPH_JIT_MAX = function(f) return f end; LPH_NO_VIRTUALIZE = function(f) return f end; end
local IsMobile = game:GetService("UserInputService").TouchEnabled

if _G.luna_hub then

	warn("Luna hub is already loaded!")
	return
end

_G.luna_hub = true

local luna_enviorment = {}
luna_enviorment.luna_version = game:HttpGet("https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/version.txt")

local Creator = loadstring(game:HttpGet("https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Creator.lua"))()
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Utils.lua"))()

local FluentUI = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

ESP:Toggle(true); ESP.Names = true; ESP.Tracers = false; ESP.Boxes = false; ESP.Players = false;

function luna_enviorment:Notify(text)

	FluentUI:Notify({

		Title = 'Luna Hub ' .. tostring(luna_enviorment.luna_version),

		Content = tostring(text),
		Duration = 3
	})
end

luna_enviorment:Notify("Waiting for player to respawn.")

local LP = game:GetService("Players").LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

local placeInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local _tick = tick()

local Window = FluentUI:CreateWindow({

	Title = tostring(placeInfo.Name) .. ' - Luna Hub',
	SubTitle = tostring(luna_enviorment.luna_version),

	TabWidth = 160,
	Size = IsMobile and UDim2.fromOffset(460, 300) or UDim2.fromOffset(580, 460),

	Acrylic = false,
	Theme = "Dark",

	MinimizeKey = Enum.KeyCode.LeftControl
})

luna_enviorment.UI = Window

local Tabs = {

	Information = Window:AddTab({ Title = "Information", Icon = "rbxassetid://13068679896" }),
	Client = Window:AddTab({ Title = "Client", Icon = "rbxassetid://13056311431" }),

	Visuals = Window:AddTab({ Title = "Visuals", Icon = "rbxassetid://16095715259" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://13538470108" }),
}

local Options = FluentUI.Options
local MobileButton = nil

if IsMobile then
	MobileButton = Creator:NewMobileButton({

		Position = UDim2.fromOffset(-20, -180),
		Size = UDim2.fromOffset(60, 60),

		Image = "rbxassetid://11433648214",

		__callback = function(value)

			if not value then
				return
			end

			Window.Minimize()
		end,
	})
end

------------// INFORMATION \\------------


local info_gameTimer_text = Tabs.Information:AddParagraph({

	Title = "Game Timer",
	Content = "Value: 0"
})

local info_powerTimer_text = Tabs.Information:AddParagraph({

	Title = "Power Timer",
	Content = "Value: 0"
})

local info_rakeHealth_text = Tabs.Information:AddParagraph({

	Title = "Rake Health",
	Content = "Health: 0"
})

Tabs.Information:AddButton({

	Title = "Discord Server",
	--Description = "Very important button",

	Callback = function()

		if everyClipboard then

			everyClipboard('https://discord.com/invite/AFaPCuz8Ta')	
			luna_enviorment:Notify("Copied to clipboard!\ndiscord.gg/AFaPCuz8Ta")
		end

		if httprequest then

			httprequest({

				Url = 'http://127.0.0.1:6463/rpc?v=1',

				Method = 'POST',

				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 'https://discord.com'
				},

				Body = game:GetService("HttpService"):JSONEncode({

					cmd = 'INVITE_BROWSER',

					nonce = game:GetService("HttpService"):GenerateGUID(false),
					args = { code = 'AFaPCuz8Ta' }
				})
			})
		end
	end
})

Creator:AddSignal(game:GetService("RunService").RenderStepped, LPH_NO_VIRTUALIZE(function()
	pcall(function()

		repeat task.wait() if FluentUI.Unloaded then break end until workspace:FindFirstChild("Rake")
		repeat task.wait() if FluentUI.Unloaded then break end until workspace:FindFirstChild("Rake"):FindFirstChildOfClass("Humanoid")

		info_rakeHealth_text:SetDesc('Health: ' .. math.floor(workspace:FindFirstChild("Rake"):FindFirstChildOfClass("Humanoid").Health))
	end)
end))

Creator:AddSignal(game:GetService("ReplicatedStorage"):WaitForChild("Timer"):GetPropertyChangedSignal("Value"), function()
	info_gameTimer_text:SetDesc('Value: ' .. game:GetService("ReplicatedStorage"):WaitForChild("Timer").Value)
end)

Creator:AddSignal(game:GetService("ReplicatedStorage"):WaitForChild("PowerValues"):WaitForChild("PowerLevel"):GetPropertyChangedSignal("Value"), function()
	info_powerTimer_text:SetDesc('Value: ' .. game:GetService("ReplicatedStorage"):WaitForChild("PowerValues"):WaitForChild("PowerLevel").Value)
end)

------------// MAIN \\------------

local startInfStamina = function()
	LPH_JIT_MAX(function() 
		
		for _, v in pairs(getloadedmodules()) do 
			if v.Name == "M_H" then
				
				local module = require(v)
				local old_idnex;
				
				old_idnex = hookfunction(module.TakeStamina, function(__a, __b)
					
					if __b > 0 then
						return old_idnex(__a, -0.5)
					end 
					
					return old_idnex(__a, __b)
				end)
			end
		end	
	end)()
end

Tabs.Client:AddToggle("main_stamina_toggle", { Title = "Infinite Stamina", Default = false }):OnChanged(function()

	if not Options.main_stamina_toggle.Value then return end
	if FluentUI.Unloaded then return end
	
	startInfStamina()
end)

Tabs.Client:AddToggle("main_jumpCooldown_toggle", { Title = "No jump cooldown", Default = false })

Creator:AddSignal(game:GetService("UserInputService").JumpRequest, function() 
	
	Character = LP.Character or LP.CharacterAdded:Wait()

	repeat task.wait()

		if FluentUI.Unloaded then break end
		if not Options.main_jumpCooldown_toggle.Value then break end

	until Character ~= nil

	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	RootPart = Character:FindFirstChild("HumanoidRootPart")

	repeat task.wait() until Character:FindFirstChildOfClass("Humanoid")
	local humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Options.main_jumpCooldown_toggle.Value then return end
	if FluentUI.Unloaded then return end

	if humanoid.FloorMaterial ~= Enum.Material.Air then
		humanoid:ChangeState("Jumping")
	end
end)

local minWalkSpeed, maxWalkSpeed, currentWalkSpeed = 20, 30, 20

local startFastWalk = function()

	local old__index;
	old__index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(__a, __b)

		if not checkcaller() and __a:IsA("Humanoid") and __a:IsDescendantOf(Character) and __b == "WalkSpeed" then
			return 12
		end
		return old__index(__a, __b)
	end))

	local old__newindex;
	old__newindex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(__a, __b, __v)

		if not checkcaller() and __a:IsA("Humanoid") and __a:IsDescendantOf(Character) and __b == "WalkSpeed" then
			return __v
		end
		return old__newindex(__a, __b, __v)
	end))

	Humanoid.WalkSpeed = currentWalkSpeed
end

Tabs.Client:AddToggle("main_fastWalk_toggle", { Title = "Fast walk", Default = false }):OnChanged(function()

	if not Options.main_fastWalk_toggle.Value then

		pcall(function()
			Humanoid.WalkSpeed = 12
		end)
		return
	end

	startFastWalk()
end)

Tabs.Client:AddSlider("main_walkSpeedMult_slider", {

	Title = "Fast walk multiplier",

	Default = 1,
	Min = 1,

	Max = 100,
	Rounding = 1,

	Callback = function(Value)

		currentWalkSpeed = math.floor(minWalkSpeed + ((Value - 1) / (100 - 1)) * (maxWalkSpeed - minWalkSpeed))

		pcall(function()

			if not Options.main_fastWalk_toggle.Value then return end
			if FluentUI.Unloaded then return end
			
			LP.Character.Humanoid.WalkSpeed = currentWalkSpeed
		end)
	end
})

local old__namecall;
Tabs.Client:AddToggle("main_fallDamage_toggle", { Title = "Remove fall damage", Default = false })

pcall(function()	
	old__namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)

		local args = { ... }
		local method = getnamecallmethod()

		if tostring(self) == "FD_Event" and method == "FireServer" and Options.main_fallDamage_toggle.Value and not FluentUI.Unloaded then
			return nil
		end

		return old__namecall(self, unpack(args))
	end))
end)

Tabs.Client:AddToggle("main_day_loop_toggle", { Title = "Always day", Default = false })

Creator:AddSignal(game:GetService("RunService").RenderStepped, LPH_NO_VIRTUALIZE(function()
	
	if FluentUI.Unloaded then return end
	
	if Options.main_fog_loop_toggle.Value then

		game:GetService("Lighting").FogEnd = math.huge

	else

		game:GetService("Lighting").FogEnd = game:GetService("ReplicatedStorage"):WaitForChild("CurrentLightingProperties"):FindFirstChild("FogEnd").Value
	end

	if not Options.main_day_loop_toggle.Value then return end
	if FluentUI.Unloaded then return end
	
	for _, v in pairs(game:GetService("ReplicatedStorage"):WaitForChild("DayProperties"):GetChildren()) do
		
		if not Options.main_day_loop_toggle.Value then break end
		if FluentUI.Unloaded then break end
		
		if tostring(v) == "FogEnd" then
			
			if Options.main_fog_loop_toggle.Value then
				
				game:GetService("Lighting").FogEnd = math.huge
				
			else
				
				game:GetService("Lighting").FogEnd = game:GetService("ReplicatedStorage"):WaitForChild("CurrentLightingProperties"):FindFirstChild("FogEnd").Value
			end
			
		else
			
			if not game:GetService("ReplicatedStorage"):WaitForChild("CurrentLightingProperties"):FindFirstChild(tostring(v)) then continue end
			
			game.Lighting[tostring(v)] = v.Value
			game:GetService("ReplicatedStorage"):WaitForChild("CurrentLightingProperties")[tostring(v)].Value = v.Value
		end
	end
end))

Tabs.Client:AddToggle("main_fog_loop_toggle", { Title = "Remove fog", Default = false })

Creator:AddSignal(LP.CharacterAdded, function(character) 

	repeat task.wait() until character:FindFirstChildOfClass("Humanoid")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	task.wait(.3)
	if FluentUI.Unloaded then return end

	if Options.main_fastWalk_toggle.Value then
		startFastWalk()
	end

	if Options.main_stamina_toggle.Value then
		startInfStamina()
	end
end)

------------// ESP \\-----------

Tabs.Visuals:AddToggle("esp_players_toggle", { Title = "Players ESP", Default = false }):OnChanged(function()
	ESP.Players = Options.esp_players_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_rake_toggle", { Title = "Rake ESP", Default = false }):OnChanged(function()
	ESP.rake = Options.esp_rake_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_supply_toggle", { Title = "Supply ESP", Default = false }):OnChanged(function()
	ESP.supply = Options.esp_supply_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_bearTrap_toggle", { Title = "Bear Traps ESP", Default = false }):OnChanged(function()
	ESP.bear_trap = Options.esp_bearTrap_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_locations_toggle", { Title = "Locations ESP", Default = false }):OnChanged(function()
	ESP.locations = Options.esp_locations_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_scrap_toggle", { Title = "Scraps ESP", Default = false }):OnChanged(function()
	ESP.scrap = Options.esp_scrap_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_flareGun_toggle", { Title = "Flare Gun ESP", Default = false }):OnChanged(function()
	ESP.flare_gun = Options.esp_flareGun_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_tracers_toggle", { Title = "Toggle Tracers", Default = false }):OnChanged(function()
	ESP.Tracers = Options.esp_tracers_toggle.Value
end)

Tabs.Visuals:AddToggle("esp_boxes_toggle", { Title = "Toggle Boxes", Default = false }):OnChanged(function()
	ESP.Boxes = Options.esp_boxes_toggle.Value
end)

ESP:AddObjectListener(workspace, {

	Name = "Rake",
	CustomName = "Rake",

	PrimaryPart = function(obj)
		local root = obj:FindFirstChild("HumanoidRootPart")

		while not root do 
			task.wait()
			root = obj:FindFirstChild("HumanoidRootPart")
		end

		return root 
	end, 

	Color = Color3.fromRGB(255, 0, 0),
	IsEnabled = "rake"
})

ESP:AddObjectListener(workspace:WaitForChild("Debris"):WaitForChild("SupplyCrates"), {

	Name = "Box",
	CustomName = "Supply Drop",

	PrimaryPart = function(obj)
		local root = obj:FindFirstChild("HitBox")

		while not root do
			task.wait()
			root = obj:FindFirstChild("HitBox")
		end

		return root
	end, 

	Color = Color3.fromRGB(0, 255, 0),
	IsEnabled = "supply"
})

ESP:AddObjectListener(workspace:WaitForChild("Debris"):WaitForChild("Traps"), {

	Name = "RakeTrapModel",
	CustomName = "Bear Trap",

	PrimaryPart = function(obj)
		local root = obj:FindFirstChild("HitBox")

		while not root do
			task.wait()
			root = obj:FindFirstChild("HitBox")
		end

		return root
	end, 

	Color = Color3.fromRGB(255, 255, 255),
	IsEnabled = "bear_trap"
})

ESP:AddObjectListener(workspace, {

	Name = "FlareGunPickUp",
	CustomName = "Flare Gun",

	PrimaryPart = function(obj)
		
		local root = obj:FindFirstChild("FlareGun")

		while not root do
			task.wait()
			root = obj:FindFirstChild("FlareGun")
		end

		return root
	end, 

	Color = Color3.fromRGB(255, 85, 0),
	IsEnabled = "flare_gun"
})

for _, v in pairs(workspace:WaitForChild("Filter"):WaitForChild("LocationPoints"):GetChildren()) do
	if v:IsA("BasePart") or v:IsA("Part") then 

		ESP:Add(v, {

			Name = tostring((v.Name):gsub("MSG", "")),
			IsEnabled = "locations",

			Color = Color3.fromRGB(170, 255, 255)
		})
	end 
end

for _, v in pairs(workspace:WaitForChild("Filter"):WaitForChild("ScrapSpawns"):GetChildren()) do
	if v:IsA("BasePart") or v:IsA("Part") then 
		
		if v:FindFirstChildOfClass("Model") then
			
			ESP:Add(v:FindFirstChildOfClass("Model"):WaitForChild("Scrap"), {

				Name = tostring((v:FindFirstChildOfClass("Model").Name):gsub("%d", "")),
				IsEnabled = "scrap",

				Color = Color3.fromRGB(170, 85, 0)
			})
		end
		
		v.ChildAdded:Connect(function(child)
			ESP:Add(child:WaitForChild("Scrap"), {

				Name = tostring((child.Name):gsub("%d", "")),
				IsEnabled = "scrap",

				Color = Color3.fromRGB(170, 85, 0)
			})
		end)
	end 
end

------------// MISC \\------------

local startThirdPersonCam = function()

	local old__newindex;
	old__newindex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(__a, __b, __v)

		if not checkcaller() and __a == LP and __b == "CameraMaxZoomDistance" and Options.main_thirdPerson_toggle.Value and not FluentUI.Unloaded then
			return old__newindex(__a, __b, 10)
		end

		return old__newindex(__a, __b, __v)
	end))
end

Tabs.Misc:AddToggle("main_thirdPerson_toggle", { Title = "Third Person camera", Default = false }):OnChanged(function()

	if not Options.main_thirdPerson_toggle.Value then return end
	if FluentUI.Unloaded then return end
	
	startThirdPersonCam()
end)

Creator:AddSignal(game:GetService("RunService").RenderStepped, LPH_NO_VIRTUALIZE(function()
	
	if FluentUI.Unloaded then return end

	if not Options.main_thirdPerson_toggle.Value then
		
		LP.CameraMaxZoomDistance = .5
		LP.CameraMinZoomDistance = .5
		
		return
	end

	LP.CameraMaxZoomDistance = 10
	LP.CameraMinZoomDistance = 10
end))

local ultraFlashlight = function()
	
	local flashlight = LP.Backpack:FindFirstChild("Flashlight") or Character:FindFirstChild("Flashlight")

	if not flashlight then 
		flashlight = LP.Backpack:FindFirstChild("UpgradedFlashlight") or Character:FindFirstChild("UpgradedFlashlight")
	end

	if not flashlight then return end
	if flashlight:GetAttribute("Modified") then return end

	flashlight.Handle.Flashlight.Light.Light1.Brightness = 10 
	flashlight.Handle.Flashlight.Light.Light1.Angle = 100

	flashlight:setAttribute("Modified", true)
end

Tabs.Misc:AddToggle("misc_ultraFlashlight_toggle", { Title = "Ultra flashlight", Default = false }):OnChanged(function(value)
	
	if not Options.misc_ultraFlashlight_toggle.Value then return end
	
	pcall(function()
		ultraFlashlight()
	end)
end)

Creator:AddSignal(game:GetService("RunService").RenderStepped, LPH_NO_VIRTUALIZE(function()

	if not Options.misc_ultraFlashlight_toggle.Value then return end
	if FluentUI.Unloaded then return end

	pcall(function()
		ultraFlashlight()
	end)
end))

local stunStickAuraCooldown = false
Tabs.Misc:AddToggle("main_stunAura_toggle", { Title = "StunStick aura", Default = false })

Creator:AddSignal(game:GetService("RunService").RenderStepped, LPH_NO_VIRTUALIZE(function()

	if not Options.main_stunAura_toggle.Value then return end
	if FluentUI.Unloaded then return end

	pcall(function()

		repeat task.wait() if FluentUI.Unloaded then break end until workspace:FindFirstChild("Rake")
		repeat task.wait() if FluentUI.Unloaded then break end until workspace:FindFirstChild("Rake"):FindFirstChildOfClass("Humanoid")

		Character = LP.Character or LP.CharacterAdded:Wait()

		repeat task.wait()

			if FluentUI.Unloaded then break end
			if not Options.main_stunAura_toggle.Value then break end

		until Character ~= nil

		Humanoid = Character:FindFirstChildOfClass("Humanoid")
		RootPart = Character:FindFirstChild("HumanoidRootPart")

		repeat task.wait()

			if FluentUI.Unloaded then break end
			if not Options.main_stunAura_toggle.Value then break end

		until Humanoid ~= nil and RootPart ~= nil

		repeat task.wait()

			if FluentUI.Unloaded then break end
			if not Options.main_stunAura_toggle.Value then break end

		until Humanoid.Health > 0

		repeat task.wait() if FluentUI.Unloaded then break end until Character:FindFirstChild("StunStick")

		local rake = workspace:FindFirstChild("Rake")
		local StunStick = Character:FindFirstChild("StunStick")

		if (RootPart.Position - rake:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 15 and not stunStickAuraCooldown then

			StunStick:FindFirstChild("Event"):FireServer("S")
			StunStick:FindFirstChild("Event"):FireServer("H", rake:FindFirstChild("Torso"))

			stunStickAuraCooldown = true
			task.wait(.5)
			stunStickAuraCooldown = false
		end
	end)
end))

Tabs.Misc:AddToggle("misc_wheelChair_toggle", { Title = "Remove WheelChair collision", Default = false }):OnChanged(function(value)
	pcall(function()
		workspace:WaitForChild("Filter"):WaitForChild("InvisibleWalls"):WaitForChild("INVIS").CanCollide = not value
	end)
end)

Tabs.Misc:AddButton({

	Title = "Destroy map borders",
	--Description = "Very important button",

	Callback = function()
		
		for _, border in pairs(workspace:WaitForChild("Filter"):WaitForChild("InvisibleWalls"):GetChildren()) do 
			border:Destroy()
		end

		luna_enviorment:Notify("Flare gun not found, try again later!")
	end
})

Tabs.Misc:AddButton({

	Title = "Get a lot of points",
	--Description = "Very important button",

	Callback = function()
		
		if LP.Backpack:WaitForChild("ScrapFolder"):WaitForChild("Points").Value <= 0 then

			luna_enviorment:Notify("You need at least one scrap collected!")
			return
		end
		
		if game:GetService("ReplicatedStorage"):WaitForChild("Night").Value then
			
			luna_enviorment:Notify("You can use this in day time!")
			return
		end

		if (RootPart.Position - workspace:WaitForChild("Map"):WaitForChild("Shack"):WaitForChild("ShopPart").Position).Magnitude > 7 then
			
			luna_enviorment:Notify("You must be near to shop to use this!")
			return
		end

		for i = 0, 250, 1 do 
			game:GetService("ReplicatedStorage"):WaitForChild("ShopEvent"):FireServer("SellScraps", "Scraps")
		end
	end
})

Tabs.Misc:AddToggle("main_autoFlareGun_toggle", { Title = "Auto grab Flare Gun", Default = false })

Creator:AddSignal(workspace.ChildAdded, function(child)
	if child and tostring(child) == "FlareGunPickUp" and Options.main_autoFlareGun_toggle.Value then
		
		coroutine.resume(coroutine.create(function()	
			luna_enviorment:Notify("Attemping to grab flare gun..")
		end))

		repeat task.wait()

			if not workspace:FindFirstChild("FlareGunPickUp") then break end
			
			Character = LP.Character or LP.CharacterAdded:Wait()

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_autoFlareGun_toggle.Value then break end

			until Character ~= nil

			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			RootPart = Character:FindFirstChild("HumanoidRootPart")

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_autoFlareGun_toggle.Value then break end

			until Humanoid ~= nil and RootPart ~= nil

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_autoFlareGun_toggle.Value then break end

			until Humanoid.Health > 0
			
			repeat task.wait()
				
				if FluentUI.Unloaded then break end
				if not Options.main_autoFlareGun_toggle.Value then break end
				
			until workspace:FindFirstChild("FlareGunPickUp"):FindFirstChild("FlareGun")
			
			local flaregun = workspace:FindFirstChild("FlareGunPickUp"):FindFirstChild("FlareGun")
			RootPart.CFrame = flaregun.CFrame + Vector3.new(0, 1, 0)

		until not workspace:FindFirstChild("FlareGunPickUp")

		if LP.Backpack:FindFirstChild("FlareGun") or Character:FindFirstChild("FlareGun") then

			luna_enviorment:Notify("Flare gun succesfully collected!")
			return
		end

		luna_enviorment:Notify("Flare gun not found, try again later!")
	end
end)

Tabs.Misc:AddButton({

	Title = "Grab Flare Gun",
	--Description = "Very important button",

	Callback = function()
		coroutine.resume(coroutine.create(function()	
			luna_enviorment:Notify("Attemping to grab flare gun..")
		end))
		
		repeat task.wait()
			
			if not workspace:FindFirstChild("FlareGunPickUp") then break end
			
			Character = LP.Character or LP.CharacterAdded:Wait()

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_stunAura_toggle.Value then break end

			until Character ~= nil

			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			RootPart = Character:FindFirstChild("HumanoidRootPart")

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_stunAura_toggle.Value then break end

			until Humanoid ~= nil and RootPart ~= nil

			repeat task.wait()

				if FluentUI.Unloaded then break end
				if not Options.main_stunAura_toggle.Value then break end

			until Humanoid.Health > 0
			
			local flaregun = workspace:FindFirstChild("FlareGunPickUp").FlareGun
			RootPart.CFrame = flaregun.CFrame + Vector3.new(0, 1, 0)
			
		until not workspace:FindFirstChild("FlareGunPickUp")

		if LP.Backpack:FindFirstChild("FlareGun") or Character:FindFirstChild("FlareGun") then

			luna_enviorment:Notify("Flare gun succesfully collected!")
			return
		end

		luna_enviorment:Notify("Flare gun not found, try again later!")
	end
})

Tabs.Misc:AddButton({

	Title = "Chat spy",
	--Description = "Very important button",

	Callback = function()
		luna_enviorment:Notify("Chat spy activated!")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/dehoisted/Chat-Spy/refs/heads/main/source/main.lua",true))()
	end
})

------------// AUTOFARMS \\------------

------------// END \\------------

Window:SelectTab(1)
luna_enviorment:Notify('Luna hub succesfully loaded in ' .. math.floor(tick() - _tick) .. 's. Enjoy!')

coroutine.resume(coroutine.create(LPH_NO_VIRTUALIZE(function()

	repeat task.wait() until FluentUI.Unloaded
	if MobileButton then MobileButton:Remove() end

	Creator:DisconnectAll()
	ESP:Toggle(false)
	
	_G.luna_hub = nil
end)()))
