local lib = {
	
	__initialized = Instance.new("BindableEvent")
}

function lib:__int()

	lib.__i = true
	lib.__initialized:Fire()
end

function lib:CheckInitialized()

	if not lib.__i then
		lib.__initialized.Event:Wait()
	end
	return lib
end

return lib
