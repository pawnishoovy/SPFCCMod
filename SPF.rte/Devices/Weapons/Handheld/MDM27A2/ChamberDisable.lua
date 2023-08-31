function OnDetach(self)

	self:DisableScript("SPF.rte/Devices/Weapons/Handheld/MDM27A2/Chamber.lua");
	self.BaseReloadTime = 5000;
	self.Frame = 0;
	
	if self.prepareSound then 
		self.prepareSound:Stop(-1); -- it's very long
	end
	
end

function OnAttach(self)

	self:EnableScript("SPF.rte/Devices/Weapons/Handheld/MDM27A2/Chamber.lua");
	
end