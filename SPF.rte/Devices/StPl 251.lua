function Update(self)

	if self.Magazine ~= nil and self.Magazine.RoundCount <= 0 then
		self:Reload();
	end

end

function StPl251A(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "StPl 251 Fragmentation Magazine";
		if gun.Magazine == nil or (gun.Magazine ~= nil and gun.Magazine.PresetName ~= magSwitchName) then
			gun:SetNextMagazineName(magSwitchName);
			gun:Reload();
		end
	end
end

function StPl251B(actor)
	local gun = ToAHuman(actor).EquippedItem;
	if gun ~= nil then
		local gun = ToHDFirearm(gun);
		local magSwitchName = "StPl 251 Incendiary Magazine";
		if gun.Magazine == nil or (gun.Magazine ~= nil and gun.Magazine.PresetName ~= magSwitchName) then
			gun:SetNextMagazineName(magSwitchName);
			gun:Reload();
		end
	end
end