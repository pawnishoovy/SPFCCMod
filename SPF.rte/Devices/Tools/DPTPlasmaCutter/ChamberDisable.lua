function OnDetach(self)

	self:DisableScript("SPF.rte/Devices/Weapons/Handheld/DPTPlasmaCutter/Chamber.lua");
	self.BaseReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("SPF.rte/Devices/Weapons/Handheld/DPTPlasmaCutter/Chamber.lua");
	
end