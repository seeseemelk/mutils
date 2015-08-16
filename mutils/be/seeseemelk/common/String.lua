local common = package("be.seeseemelk.common")

local String = common:class "String" ()
function String:String(text)
	if instanceof(text, "string") or instanceof(text, String) then
		self.value = text
	end
end

function String:get()
	return self.value
end

function String:set(text)
	self.value = text
end
