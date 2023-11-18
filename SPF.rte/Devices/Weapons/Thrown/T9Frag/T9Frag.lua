dofile("SPF.rte/SPFSettings.lua")

function Create(self)

	self.pullPinSound = CreateSoundContainer("SPF Grenade Pin Pull", "SPF.rte");
	self.spoonEjectSound = CreateSoundContainer("SPF Grenade Spoon Eject", "SPF.rte");
	
	self.bounceHardSound = CreateSoundContainer("SPF Grenade Bounce Hard", "SPF.rte");
	self.bounceSoftSound = CreateSoundContainer("SPF Grenade Bounce Soft", "SPF.rte");
	self.rollSound = CreateSoundContainer("SPF Grenade Roll", "SPF.rte");
	
	self.fuzeDelay = 3000;
	
	self.lastVel = Vector(self.Vel.X, self.Vel.Y)
	
	self.impulse = Vector()
	self.bounceSoundTimer = Timer()	

end

function Update(self)

	self.impulse = (self.Vel - self.lastVel) / TimerMan.DeltaTimeSecs * self.Vel.Magnitude * 0.1
	self.lastVel = Vector(self.Vel.X, self.Vel.Y)

	if self.fuze then
	
		if self.fuze:IsPastSimMS(3000) then
			self:GibThis();
		end
		
	elseif self.activated then
	
		local player = IsActor(self:GetRootParent()) and ToActor(self:GetRootParent()):IsPlayerControlled();
		local input = player and UInputMan:KeyPressed(SPFSettings.GrenadeCookHotkey);
	
		if not self:IsAttached() or input then
			self.Frame = 2;
			self.fuze = Timer();
			self.spoonEjectSound:Play(self.Pos);
			local spoon = CreateMOSRotating("T9 Frag Grenade Spoon", "SPF.rte");
			spoon.Vel = self.Vel + Vector (-2 * self.FlipFactor, -2):RadRotate(self.RotAngle);
			spoon.Pos = self.Pos + Vector(2 * self.FlipFactor, -1):RadRotate(self.RotAngle);
			MovableMan:AddParticle(spoon);
			
		end
		
	elseif self:IsAttached() and ToActor(self:GetRootParent()):GetController():IsState(Controller.PRIMARY_ACTION) then
		self.Frame = 1;
		self.pullPinSound:Play(self.Pos);
		local pin = CreateMOSRotating("T9 Frag Grenade Pin", "SPF.rte");
		pin.Vel = self.Vel + Vector (0, -3):RadRotate(self.RotAngle);
		pin.Pos = self.Pos + Vector(0, -2):RadRotate(self.RotAngle);
		MovableMan:AddParticle(pin);
		self.activated = true;
	end
end

function OnCollideWithTerrain(self, terrainID)
	if self.bounceSoundTimer:IsPastSimMS(50) then
		if self.impulse.Magnitude > 25 then -- Hit
			self.bounceHardSound:Play(self.Pos);
			self.bounceSoundTimer:Reset()
		elseif self.impulse.Magnitude > 11 then -- Hit
			self.bounceSoftSound:Play(self.Pos);
			self.bounceSoundTimer:Reset()
		elseif self.impulse.Magnitude > 5 and not self.rollPlayed then -- Roll
			self.rollSound:Play(self.Pos);
			self.bounceSoundTimer:Reset()
			self.rollPlayed = true;
		end
	end
end