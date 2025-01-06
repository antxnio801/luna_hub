local Creator = {}
local Signals = {}

local __cg = game:GetService("CoreGui")

function Creator.New(__i, __p, __c)

	local obj = Instance.new(__i)

	for i, v in pairs(__p or {}) do

		obj[i] = v

		for _, child in pairs(__c or {}) do
			child.Parent = obj;
		end

	end

	return obj;
end

function Creator:NewMobileButton(__info)

	local __ui = __cg:FindFirstChild("MobileUI")

	if not __cg:FindFirstChild("MobileUI") then

		__ui = Instance.new("ScreenGui", __cg)
		__ui.Name = "MobileUI"

		__ui.IgnoreGuiInset = true
		__ui.DisplayOrder = math.huge
	end

	local __b = Creator.New("ImageButton", {

		Parent = __ui,
		AnchorPoint = Vector2.new(1, 1),

		Position = UDim2.fromScale(1, 1) + (__info.Position or UDim2.new()),
		Size = __info.Size or UDim2.fromOffset(70, 70),

		BackgroundTransparency = 1,
		Image = "rbxassetid://9631050557"
	})

	local __i = Creator.New("ImageLabel", {

		Parent = __b,

		AnchorPoint = Vector2.new(.5, .5),
		BackgroundTransparency = 1,

		Position = UDim2.fromScale(.5, .5),	
		Size = UDim2.fromScale(0.6, .6),

		ImageTransparency = .5,

		Image = __info.Image or "",
		ScaleType = Enum.ScaleType.Fit
	})

	__b.MouseButton1Down:Connect(function()

		__b.Image = "rbxassetid://9631393323"
		__i.ImageColor3 = Color3.new(0, 0, 0)

		__info.__callback(true)
	end);

	__b.MouseButton1Up:Connect(function()

		__b.Image = "rbxassetid://9631050557"
		__i.ImageColor3 = Color3.new(1, 1, 1)

		__info.__callback(false)
	end);

	local __t = {}

	function __t:Remove()
		__b:Destroy()
	end

	return __t
end


function Creator:AddSignal(s, __f)
	table.insert(Signals, s:Connect(__f))
end

function Creator:DisconnectAll()

	for Idx = #Signals, 1, -1 do

		local Connection = table.remove(Signals, Idx)
		Connection:Disconnect()
	end
end

return Creator
