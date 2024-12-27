local Creator = {}
local Signals = {}

local Packages = script.Parent

local Acrylic = require(Packages:WaitForChild("Acrylic"))
local Signal = require(Packages:WaitForChild("Signal"))

local IsStudio = game:GetService("RunService"):IsStudio()

local loadstring = IsStudio and require(script:WaitForChild("Loadstring")) or loadstring
local _HttpGet = IsStudio and game:GetService("ReplicatedStorage"):WaitForChild("HttpGet") or nil

local Acrylic = IsStudio and loadstring(_HttpGet:InvokeServer('https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Acrylic.lua'))() or loadstring(game:HttpGet('https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Acrylic.lua'))()
local Signal = IsStudio and loadstring(_HttpGet:InvokeServer('https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Signal.lua'))() or loadstring(game:HttpGet('https://raw.githubusercontent.com/antxnio801/luna_hub/refs/heads/main/Packages/Signal.lua'))()

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

function Creator:NewSignal(__f)
	
	local signal = Signal.new()
	table.insert(Signals, signal:Connect(__f))
	
	return signal
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

function Creator:BlurFrame(f)

	Acrylic:BindFrame(f, {

		Transparency = 0.98;
		BrickColor = BrickColor.new('Institutional white');
	})
	
	local __t = {}
	
	function __t:Remove()
		Acrylic:UnbindFrame(f)
	end
	
	return __t
end

return Creator
