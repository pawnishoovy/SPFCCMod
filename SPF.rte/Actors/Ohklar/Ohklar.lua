function Create(self)

	self.stepSound = CreateSoundContainer("SPF Ohklar Step", "SPF.rte");	
	self.landSound = CreateSoundContainer("SPF Ohklar Land", "SPF.rte");
	
	self.spotVoiceSound = CreateSoundContainer("SPF Ohklar VO Spot", "SPF.rte");
	self.idleVoiceSound = CreateSoundContainer("SPF Ohklar VO Idle", "SPF.rte");
	
	self.voiceSound = self.idleVoiceSound;

	self.spotVoiceLineTimer = Timer();
	self.spotVoiceLineDelay = 15000;	
	
	 -- in MS
	self.spotDelayMin = 4000;
	self.spotDelayMax = 8000;
	
	-- extremely epic, 2000-tier combat/idle mode system
	self.inCombat = false;
	self.combatExitTimer = Timer();
	self.combatExitDelay = 10000;
	
	-- leg Collision Detection system
	self.foot = 0;
    self.feetContact = {false, false}
    self.feetTimers = {Timer(), Timer()}
	self.footstepTime = 100 -- 2 Timers to avoid noise	
	
	
	self.jumpStop = Timer();
	
	self.altitude = 0;
	self.wasInAir = false;
	
	self.moveSoundTimer = Timer();
	
end

function OnStride(self)

	if self.BGFoot and self.FGFoot then

		local startPos = self.foot == 0 and self.BGFoot.Pos or self.FGFoot.Pos
		self.foot = (self.foot + 1) % 2
		
		local pos = Vector(0, 0);
		SceneMan:CastObstacleRay(startPos, Vector(0, 9), pos, Vector(0, 0), self.ID, self.Team, 0, 3);				
		local terrPixel = SceneMan:GetTerrMatter(pos.X, pos.Y)
		
		if terrPixel ~= 0 then -- 0 = air
			self.stepSound:Play(self.Pos);
		end
		
	elseif self.BGFoot then
	
		local startPos = self.BGFoot.Pos
		
		local pos = Vector(0, 0);
		SceneMan:CastObstacleRay(startPos, Vector(0, 9), pos, Vector(0, 0), self.ID, self.Team, 0, 3);				
		local terrPixel = SceneMan:GetTerrMatter(pos.X, pos.Y)
		
		if terrPixel ~= 0 then -- 0 = air
			self.stepSound:Play(self.Pos);
		end
		
	elseif self.FGFoot then
	
		local startPos = self.FGFoot.Pos
		
		local pos = Vector(0, 0);
		SceneMan:CastObstacleRay(startPos, Vector(0, 9), pos, Vector(0, 0), self.ID, self.Team, 0, 3);				
		local terrPixel = SceneMan:GetTerrMatter(pos.X, pos.Y)
		
		if terrPixel ~= 0 then -- 0 = air
			self.stepSound:Play(self.Pos);
		end
		
	end
	
end

function Update(self)

	local iniPainOrDeath = self.PainSound:IsBeingPlayed() or self.DeathSound:IsBeingPlayed()

	if iniPainOrDeath then
		self.voiceSound:Stop(-1);
	else
		self.voiceSound.Pos = self.Pos;
	end

	self.controller = self:GetController();

	-- Leg Collision Detection system
    --local i = 0
	if self:IsPlayerControlled() then -- AI doesn't update its own foot checking when playercontrolled so we have to do it
		if self.Vel.Y > 10 then
			self.wasInAir = true;
		else
			self.wasInAir = false;
		end
		for i = 1, 2 do
			--local foot = self.feet[i]
			local foot = nil
			--local leg = self.legs[i]
			if i == 1 then
				foot = self.FGFoot 
			else
				foot = self.BGFoot 
			end

			--if foot ~= nil and leg ~= nil and leg.ID ~= rte.NoMOID then
			if foot ~= nil then
				local footPos = foot.Pos				
				local mat = nil
				local pixelPos = footPos + Vector(0, 4)
				self.footPixel = SceneMan:GetTerrMatter(pixelPos.X, pixelPos.Y)
				--PrimitiveMan:DrawLinePrimitive(pixelPos, pixelPos, 13)
				if self.footPixel ~= 0 then
					mat = SceneMan:GetMaterialFromID(self.footPixel)
				--	PrimitiveMan:DrawLinePrimitive(pixelPos, pixelPos, 162);
				--else
				--	PrimitiveMan:DrawLinePrimitive(pixelPos, pixelPos, 13);
				end
				
				local movement = (self.controller:IsState(Controller.MOVE_LEFT) == true or self.controller:IsState(Controller.MOVE_RIGHT) == true or self.Vel.Magnitude > 3)
				if mat ~= nil then
					--PrimitiveMan:DrawTextPrimitive(footPos, mat.PresetName, true, 0);
					if self.feetContact[i] == false then
						self.feetContact[i] = true
						if self.feetTimers[i]:IsPastSimMS(self.footstepTime) and movement then																	
							self.feetTimers[i]:Reset()
						end
					end
				else
					if self.feetContact[i] == true then
						self.feetContact[i] = false
						if self.feetTimers[i]:IsPastSimMS(self.footstepTime) and movement then
							self.feetTimers[i]:Reset()
						end
					end
				end
			end
		end
	else
		if self.AI.flying == true and self.wasInAir == false then
			self.wasInAir = true;
		elseif self.AI.flying == false and self.wasInAir == true then
			self.wasInAir = false;
			if self.moveSoundTimer:IsPastSimMS(500) then
				self.landSound:Play(self.Pos);
				self.stepSound:Play(self.Pos);
				self.moveSoundTimer:Reset();
			end
		end
	end
	
	if self.wasInAir then
		if (self:IsPlayerControlled() and self.feetContact[1] == true or self.feetContact[2] == true) and self.jumpStop:IsPastSimMS(100) then
			self.wasInAir = false;
			if self.Vel.Y > 0 and self.moveSoundTimer:IsPastSimMS(500) then
				self.landSound:Play(self.Pos);
				self.stepSound:Play(self.Pos);
				self.moveSoundTimer:Reset();			
				
			end
		end
	end
	
	-- SPOT ENEMY REACTION
	-- works off of the native AI's target
	
	if not self.LastTargetID then
		self.LastTargetID = -1
	end
	
	if (not self:IsPlayerControlled()) and self.AI.Target and IsAHuman(self.AI.Target) then
	
		self.inCombat = true;
		self:SetNumberValue("InCombat", 1)
		self.combatExitTimer:Reset();
	
		self.spotVoiceLineTimer:Reset();
		
		if self.spotAllowed ~= false then
			
			if self.LastTargetID == -1 then
				self.LastTargetID = self.AI.Target.UniqueID
				-- Target spotted
				
				if not self.AI.Target:NumberValueExists("SPF Enemy Spotted Age") or -- If no timer exists
				self.AI.Target:GetNumberValue("SPF Enemy Spotted Age") < (self.AI.Target.Age - self.AI.Target:GetNumberValue("SPF Enemy Spotted Delay")) or -- If the timer runs out of time limit
				math.random(0, 100) < 15 -- Small chance to ignore timers, to spice things up
				then
					-- Setup the delay timer
					self.AI.Target:SetNumberValue("SPF Enemy Spotted Age", self.AI.Target.Age)
					self.AI.Target:SetNumberValue("SPF Enemy Spotted Delay", math.random(self.spotDelayMin, self.spotDelayMax))
					
					self.spotAllowed = false;
					
					if (not iniPainOrDeath) and not self.voiceSound:IsBeingPlayed() and math.random(0, 100) < 25 then
						self.voiceSound = self.spotVoiceSound;
						self.voiceSound:Play(self.Pos);
					end
					
				end
			else
				-- Refresh the delay timer
				if self.AI.Target:NumberValueExists("SPF Enemy Spotted Age") then
					self.AI.Target:SetNumberValue("SPF Enemy Spotted Age", self.AI.Target.Age)
				end
			end
		end
	else
		if self.spotVoiceLineTimer:IsPastSimMS(self.spotVoiceLineDelay) then
			self.spotAllowed = true;
		end
		if self.combatExitTimer:IsPastSimMS(self.combatExitDelay) and self.inCombat == true then
			self.inCombat = false;
			self:RemoveNumberValue("InCombat")
			if (not iniPainOrDeath) and not self.voiceSound:IsBeingPlayed() and math.random(0, 100) < 10 then
				self.voiceSound = self.idleVoiceSound;
				self.voiceSound:Play(self.Pos);
			end
		end
		if self.LastTargetID ~= -1 then
			self.LastTargetID = -1
			-- Target lost
			--print("TARGET LOST!")
		end
	end

end