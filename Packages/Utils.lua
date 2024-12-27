local Utils = {}

function Utils:RandomString()

	local length = math.random(20, 30)
	local array = {}

	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

function Utils:FastWait(s)

	if not s then return game:GetService("RunService").RenderStepped:Wait() end

	local start = tick()
	while tick() - start < s do game:GetService("RunService").RenderStepped:Wait() end
end

return Utils