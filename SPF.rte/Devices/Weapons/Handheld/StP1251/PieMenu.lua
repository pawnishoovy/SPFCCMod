function StP1251A(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "StP1 251 Fragmentation Magazine";
		if gun.Magazine == nil or (gun.Magazine ~= nil and gun.Magazine.PresetName ~= magSwitchName) then
			gun:SetNextMagazineName(magSwitchName);
			if not gun:IsReloading() then
				gun:Reload();
				gun:SetNumberValue("Switched", 1);
			end
			gun:SetNumberValue("Frag Round", 1);
		end
	end
end

function StP1251B(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "StP1 251 Incendiary Magazine";
		if gun.Magazine == nil or (gun.Magazine ~= nil and gun.Magazine.PresetName ~= magSwitchName) then
			gun:SetNextMagazineName(magSwitchName);
			if not gun:IsReloading() then
				gun:Reload();
				gun:SetNumberValue("Switched", 1);
			end
			gun:RemoveNumberValue("Frag Round");
		end
	end
end