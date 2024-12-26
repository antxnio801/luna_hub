local Creator = {

	Signals = {}
}
Creator.ClassName = "Creator"

function Creator:AddSignal(Signal, Function)
	table.insert(Creator.Signals, Signal:Connect(Function))
end

function Creator:DisconnectAllSignals()

	for Idx = #Creator.Signals, 1, -1 do

		local Connection = table.remove(Creator.Signals, Idx)
		Connection:Disconnect()
	end
end

function Creator:RandomString()

	local length = math.random(10,20)
	local array = {}

	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

return Creator