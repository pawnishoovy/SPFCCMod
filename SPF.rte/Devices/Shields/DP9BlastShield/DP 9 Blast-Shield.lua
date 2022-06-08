function Create(self)

	self.oldWoundCount = 0;
	self.actualGibWoundLimit = self.GibWoundLimit;
	self.GibWoundLimit = 200;
	
	self.strideSound = CreateSoundContainer("DP 9 Blast-Shield Stride", "SPF.rte");
	self.strideTimer = Timer();

end
function Update(self)

	self.parent = self:GetRootParent();
	
	if IsAHuman(self.parent) then
		if ToAHuman(self.parent).StrideFrame and self.strideTimer:IsPastSimMS(400) then
			self.strideTimer:Reset();
			self.strideSound:Play(self.Pos);
		end
	end

	if self.WoundCount > self.oldWoundCount then
		if self.WoundCount - self.oldWoundCount > 10 then
			self:RemoveWounds((self.WoundCount - self.oldWoundCount) / 2)
		end
		if self.WoundCount > self.actualGibWoundLimit then
			self:GibThis();
		end
	end
	
	self.oldWoundCount = self.WoundCount;

end