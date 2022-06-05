function UnnamedScopeToggle(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		if gun then
			gun:SetNumberValue("Toggle Scope", 1);
		end
	end
end