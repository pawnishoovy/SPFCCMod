function Create(self)

	self.scopeOnSound = CreateSoundContainer("ScopeOn UnnamedBoltie", "SPF.rte");
	self.scopeOffSound = CreateSoundContainer("ScopeOff UnnamedBoltie", "SPF.rte");

	self.scopeAttachment = nil;
	for attachable in self.Attachables do
		
		if string.find(attachable.PresetName, "Scope") then
			self.scopeAttachment = attachable
			self.scopeAttachment.InheritsRotAngle = true
			self.scopeAttachment:AddScript("SPF.rte/Devices/Weapons/Handheld/UnnamedBoltie/ScopeAttachment.lua") -- SAFE MEASURE
			self.scopeAttachment.Frame = 1;
		end
	end
end

function Update(self)
	
	if self.scopeAttachment and not self:NumberValueExists("LostScopeAttachment") then
		self.scopeAttachment:ClearForces();
		self.scopeAttachment:ClearImpulseForces();
		
		self.scopeAttachment:RemoveWounds(self.scopeAttachment.WoundCount);
		
		self.scopeAttachment.GetsHitByMOs = false;
			
		if self:NumberValueExists("Toggle Scope") then
			self:RemoveNumberValue("Toggle Scope");
			self.scopeAttachment.Frame = (self.scopeAttachment.Frame + 1) % 2;
			
			self.originalSharpLength = self.originalSharpLength == 450 and 200 or 450
			local toggledToScope = self.originalSharpLength == 450
			
			
			if toggledToScope then
				self.scopeOnSound:Play(self.Pos);
			else
				self.scopeOffSound:Play(self.Pos);
			end
			
		end
		-- if self:NumberValueExists("MagRotation") then
			-- self.scopeAttachment.RotAngle = self.RotAngle + self:GetNumberValue("MagRotation");
		-- end
		-- if self:NumberValueExists("MagOffsetX") and self:NumberValueExists("MagOffsetY") then
			-- self.scopeAttachment.Pos = self.scopeAttachment.Pos + Vector(self:GetNumberValue("MagOffsetX"), self:GetNumberValue("MagOffsetY"));
		-- end
	end
	
end



