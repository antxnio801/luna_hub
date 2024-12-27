local lib = {
	
	__initialized = Instance.new("BindableEvent")
}

function lib:__int()
		
	print("A")
	
	task.wait(math.random(1,  3))
	
	print("XD")
	
	lib.__i = true
	lib.__initialized:Fire()
end

function lib:CheckInitialized()

	if not lib.__i then
		lib.__initialized.Event:Wait()
	end
	
	print("SI")
	return lib
end

return lib