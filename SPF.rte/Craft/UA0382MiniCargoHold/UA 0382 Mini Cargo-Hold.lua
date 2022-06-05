function Create(self)

	self.incomingSound = CreateSoundContainer("UA 0382 Mini Cargo-Hold Incoming", "SPF.rte");
	self.incomingSound:Play(self.Pos);
	
	--Choose a random horizontal direction
	local randomDirection = 0;
	--If velocity was pre-defined before spawning, don't randomize horizontal velocity or position
	if self.Vel.X == 0 then
		randomDirection = math.random() < 0.5 and 1 or -1;
		--Try not to fly off the edge in non-wrapping scenes
		if not SceneMan.SceneWrapsX then
			randomDirection = self.Pos.X > (SceneMan.SceneWidth - 100) and -1 or (self.Pos.X < 100 and 1 or randomDirection);
		end
		self.AngularVel = -randomDirection * math.random(10);
	else
		self.AngularVel = -self.Vel.X;
	end
	--Randomize velocities
	self.RotAngle = RangeRand(0, math.pi * 2);
	self.Pos = Vector(self.Pos.X - randomDirection * math.random(100), self.Pos.Y);
	local velocity = Vector(randomDirection * math.random(10), math.min(10 + 10 * 1500/SceneMan.SceneHeight, 100));
	self.Vel = self.Vel + velocity:SetMagnitude(math.max(velocity.Magnitude - self.Vel.Magnitude, 0));

end

function Update(self)
	self.incomingSound.Pos = self.Pos;
	if self.Age > 2000 and self.Vel.Magnitude < 5 then
		self.Health = 0;
	end
	if self.HatchState == 2 then
		self.HatchOpenSound = nil;
	end
	
	--Apply damage to the actors inside based on impulse forces
	if self.TravelImpulse.Magnitude > self.Mass then
		for actor in self.Inventory do
			if actor and IsActor(actor) and string.find(actor.Material.PresetName, "Flesh") then
				actor = ToActor(actor);
				--The following method is a slightly revised version of the hardcoded impulse damage system
				local impulse = self.TravelImpulse.Magnitude - actor.ImpulseDamageThreshold;
				local damage = impulse/(actor.GibImpulseLimit * 0.1 + actor.Material.StructuralIntegrity * 10);
				actor.Health = damage > 0 and actor.Health - damage or actor.Health;
			end
		end
	end
	if self.GibTimer:IsPastSimTimeLimit() then
		self:GibThis();
	elseif (self.Vel.Largest + math.abs(self.AngularVel)) > 5 or self.AIMode == Actor.AIMODE_STAY then
		self.GibTimer:Reset();
	elseif self.HatchState == ACraft.CLOSED then
		self:OpenHatch();
	end	
	
end

function OnCollideWithTerrain(self)
	self.incomingSound:Stop(-1);
	
	if not self.Impacted then
		self.Impacted = true;
		self.impactSound = CreateSoundContainer("UA 0382 Mini Cargo-Hold Impact", "SPF.rte")
		self.impactSound:Play(self.Pos);
	end
		
end

function Destroy(self)
	ActivityMan:GetActivity():ReportDeath(self.Team, -1);
end