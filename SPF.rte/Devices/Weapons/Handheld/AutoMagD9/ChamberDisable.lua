function OnDetach(self)

	self:DisableScript("SPF.rte/Devices/Weapons/Handheld/AutoMagD9/Chamber.lua");
	self.ReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("SPF.rte/Devices/Weapons/Handheld/AutoMagD9/Chamber.lua");
	
end