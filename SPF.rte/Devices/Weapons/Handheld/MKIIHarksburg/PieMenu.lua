function MKIIHFA(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "MKII Harksburg Flarepistol Explosive Flare Magazine";
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

function MKIIHFB(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "MKII Harksburg Flarepistol Fragmentation Flare Magazine";
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