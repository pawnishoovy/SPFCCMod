function OnDetach(self)

	self:DisableScript("SPF.rte/Devices/Weapons/Handheld/StP1251/Chamber.lua");
	self.BaseReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("SPF.rte/Devices/Weapons/Handheld/StP1251/Chamber.lua");
	
end