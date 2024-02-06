--[[MULTITHREAD]]--

function Create(self)

	self.parentSet = false;
	
	-- Sounds --
	
	self.preSound = CreateSoundContainer("Pre S&W 400 M", "SPF.rte");
	self.reflectionOutdoorsSound = CreateSoundContainer("ReflectionOutdoors S&W 400 M", "SPF.rte");
	
	self.reloadPrepareSounds = {}
	self.reloadPrepareSounds.CylinderOpen = nil;
	self.reloadPrepareSounds.EjectShells = nil;
	self.reloadPrepareSounds.SpeedLoaderIn = CreateSoundContainer("SpeedLoaderInPrepare S&W 400 M", "SPF.rte");
	self.reloadPrepareSounds.SpeedLoaderOff = nil;
	self.reloadPrepareSounds.CylinderClose = nil;
	self.reloadPrepareSounds.HammerBack = nil;
	
	self.reloadPrepareLengths = {}
	self.reloadPrepareLengths.CylinderOpen = 0
	self.reloadPrepareLengths.EjectShells = 0
	self.reloadPrepareLengths.SpeedLoaderIn = 160
	self.reloadPrepareLengths.SpeedLoaderOff = 0
	self.reloadPrepareLengths.CylinderClose = 0
	self.reloadPrepareLengths.HammerBack = 0
	
	self.reloadPrepareDelay = {}
	self.reloadPrepareDelay.CylinderOpen = 400
	self.reloadPrepareDelay.EjectShells = 270
	self.reloadPrepareDelay.SpeedLoaderIn = 1000
	self.reloadPrepareDelay.SpeedLoaderOff = 300
	self.reloadPrepareDelay.CylinderClose = 700
	self.reloadPrepareDelay.HammerBack = 100
	
	self.reloadAfterSounds = {}
	self.reloadAfterSounds.CylinderOpen = CreateSoundContainer("CylinderOpen S&W 400 M", "SPF.rte");
	self.reloadAfterSounds.EjectShells = CreateSoundContainer("EjectShells S&W 400 M", "SPF.rte");
	self.reloadAfterSounds.SpeedLoaderIn = CreateSoundContainer("SpeedLoaderIn S&W 400 M", "SPF.rte");
	self.reloadAfterSounds.SpeedLoaderOff = CreateSoundContainer("SpeedLoaderOff S&W 400 M", "SPF.rte");
	self.reloadAfterSounds.CylinderClose = CreateSoundContainer("CylinderClose S&W 400 M", "SPF.rte");
	self.reloadAfterSounds.HammerBack = CreateSoundContainer("HammerBack S&W 400 M", "SPF.rte");
	
	self.reloadAfterDelay = {}
	self.reloadAfterDelay.CylinderOpen = 270
	self.reloadAfterDelay.EjectShells = 340
	self.reloadAfterDelay.SpeedLoaderIn = 150
	self.reloadAfterDelay.SpeedLoaderOff = 300
	self.reloadAfterDelay.CylinderClose = 440
	self.reloadAfterDelay.HammerBack = 200
	
	self.lastAge = self.Age
	
	self.originalSharpLength = self.SharpLength
	
	self.originalStanceOffset = Vector(math.abs(self.StanceOffset.X), self.StanceOffset.Y)
	self.originalSharpStanceOffset = Vector(self.SharpStanceOffset.X, self.SharpStanceOffset.Y)
	
	self.rotation = 0
	self.rotationTarget = 0
	self.rotationSpeed = 9
	
	self.horizontalAnim = 0
	self.verticalAnim = 0
	
	self.angVel = 0
	self.lastRotAngle = self.RotAngle
	
	self.FireTimer = Timer();
	self.smokeDelayTimer = Timer();
	self.canSmoke = false
	
	self.reloadTimer = Timer();
	
	self.reloadPhase = 0;
	
	self.Frame = 1;
	self.BaseReloadTime = 9999;
	
	self.fireDelayTimer = Timer();
	self.delayedFire = false
	self.delayedFireTimer = Timer();
	self.delayedFireTimeMS = 70
	self.delayedFireEnabled = true
	self.activated = false
	
	-- Progressive Recoil System 
	self.recoilAcc = 0 -- for sinous
	self.recoilStr = 0 -- for accumulator
	self.recoilStrength = 27 -- multiplier for base recoil added to the self.recoilStr when firing
	self.recoilPowStrength = 0.2 -- multiplier for self.recoilStr when firing
	self.recoilRandomUpper = 1.5 -- upper end of random multiplier (1 is lower)
	self.recoilDamping = 0.3
	
	self.recoilMax = 15 -- in deg.
	self.originalSharpLength = self.SharpLength
	-- Progressive Recoil System 
end

function ThreadedUpdate(self)
	self.rotationTarget = 0 -- ZERO IT FIRST AAAA!!!!!
	
	if self.ID == self.RootID then
		self.parent = nil;
		self.parentSet = false;
	elseif self.parentSet == false then
		local actor = MovableMan:GetMOFromID(self.RootID);
		if actor and IsAHuman(actor) then
			self.parent = ToAHuman(actor);
			self.parentSet = true;
		end
	end
	
    -- Smoothing
    local min_value = -math.pi;
    local max_value = math.pi;
    local value = self.RotAngle - self.lastRotAngle
    local result;
    local ret = 0
    
    local range = max_value - min_value;
    if range <= 0 then
        result = min_value;
    else
        ret = (value - min_value) % range;
        if ret < 0 then ret = ret + range end
        result = ret + min_value;
    end
    
    self.lastRotAngle = self.RotAngle
    self.angVel = (result / TimerMan.DeltaTimeSecs) * self.FlipFactor
    
    if self.lastHFlipped ~= nil then
        if self.lastHFlipped ~= self.HFlipped then
            self.lastHFlipped = self.HFlipped
            self.angVel = 0
        end
    else
        self.lastHFlipped = self.HFlipped
    end
	
	-- Check if switched weapons/hide in the inventory, etc.
	if self.Age > (self.lastAge + TimerMan.DeltaTimeSecs * 2000) then
		if self.delayedFire then
			self.delayedFire = false
		end
		self.fireDelayTimer:Reset()
	end
	self.lastAge = self.Age + 0
	
	local controller = self.parent and self.parent:GetController() or nil
	if self.parent and (self:IsReloading() or self.reChamber == true) then
	
		self.fireDelayTimer:Reset()
		
		if self.reloadPhase == 0 then
		
			self.reloadDelay = self.reloadPrepareDelay.CylinderOpen;
			self.afterDelay = self.reloadAfterDelay.CylinderOpen;		
			
			self.prepareSound = self.reloadPrepareSounds.CylinderOpen;
			self.prepareSoundLength = self.reloadPrepareLengths.CylinderOpen;
			self.afterSound = self.reloadAfterSounds.CylinderOpen;
			
			self.rotationTarget = -5 * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)
			
		elseif self.reloadPhase == 1 then
		
			--self.Frame = self.ReloadCylinderFrameEnd
			
			self.reloadDelay = self.reloadPrepareDelay.EjectShells;
			self.afterDelay = self.reloadAfterDelay.EjectShells;		
			
			self.prepareSound = self.reloadPrepareSounds.EjectShells;
			self.prepareSoundLength = self.reloadPrepareLengths.EjectShells;
			self.afterSound = self.reloadAfterSounds.EjectShells;
			--
			self.rotationTarget = 15-- * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)
			
		elseif self.reloadPhase == 2 then
		
			self.reloadDelay = self.reloadPrepareDelay.SpeedLoaderIn;
			self.afterDelay = self.reloadAfterDelay.SpeedLoaderIn;		
			
			self.prepareSound = self.reloadPrepareSounds.SpeedLoaderIn;
			self.prepareSoundLength = self.reloadPrepareLengths.SpeedLoaderIn;
			self.afterSound = self.reloadAfterSounds.SpeedLoaderIn;
			--
			self.rotationTarget = 10 * math.pow(self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay), 3)
			
		elseif self.reloadPhase == 3 then		
		
			self.reloadDelay = self.reloadPrepareDelay.SpeedLoaderOff;
			self.afterDelay = self.reloadAfterDelay.SpeedLoaderOff;		
			
			self.prepareSound = self.reloadPrepareSounds.SpeedLoaderOff;
			self.prepareSoundLength = self.reloadPrepareLengths.SpeedLoaderOff;
			self.afterSound = self.reloadAfterSounds.SpeedLoaderOff;
			--
			self.rotationTarget = -35 * math.pow(self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay), 3)
			
		elseif self.reloadPhase == 4 then		
		
			self.reloadDelay = self.reloadPrepareDelay.CylinderClose;
			self.afterDelay = self.reloadAfterDelay.CylinderClose;		
			
			self.prepareSound = self.reloadPrepareSounds.CylinderClose;
			self.prepareSoundLength = self.reloadPrepareLengths.CylinderClose;
			self.afterSound = self.reloadAfterSounds.CylinderClose;
			--
			
		elseif self.reloadPhase == 5 then
		
			if self:IsReloading() then
				self.reloadDelay = self.reloadPrepareDelay.HammerBack * 4;
			else
				self.reloadDelay = self.reloadPrepareDelay.HammerBack;
			end
			
			self.afterDelay = self.reloadAfterDelay.HammerBack;		
			
			self.prepareSound = self.reloadPrepareSounds.HammerBack;
			self.prepareSoundLength = self.reloadPrepareLengths.HammerBack;
			self.afterSound = self.reloadAfterSounds.HammerBack;
			
			self.rotationTarget = 9
			
			--			
			
		end
		
		if self.reloadTimer:IsPastSimMS(self.reloadDelay - self.prepareSoundLength) and self.prepareSoundPlayed ~= true then
			self.prepareSoundPlayed = true;
			if self.prepareSound then
				self.prepareSound:Play(self.Pos)
			end
		end
		
		if self.reloadTimer:IsPastSimMS(self.reloadDelay) then
		
			if self.reloadPhase == 0 then
			
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*3)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 2)
				
				-- self.Frame = self.ReloadCylinderFrameStart + math.floor(factor * (self.ReloadCylinderFrameEnd - self.ReloadCylinderFrameStart))
				
			elseif self.reloadPhase == 1 then
				
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*4)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 1)
				-- factor = math.sin(factor * math.pi) -- goes back and forth
				
				-- self.Frame = self.ReloadEjectFrameStart + math.floor(factor * (self.ReloadEjectFrameEnd - self.ReloadEjectFrameStart))
				
			elseif self.reloadPhase == 4 then
			
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*3)
				
				-- local factor = math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1)
				-- self.Frame = self.ReloadCylinderFrameStart + math.floor((1 - factor) * (self.ReloadCylinderFrameEnd - self.ReloadCylinderFrameStart))

			end
			
			if self.afterSoundPlayed ~= true then
			
				if self.reloadPhase == 0 then
					self.phaseOnStop = 1;

				elseif self.reloadPhase == 1 then
					self.phaseOnStop = 2;
					
					for i = 1, 5 do
						local shell = CreateMOSParticle("Casing");
						shell.Pos = self.Pos;
						shell.Vel = Vector(math.random(-4, -2)*self.FlipFactor, 0):RadRotate(self.RotAngle);
						MovableMan:AddParticle(shell);
					end
					
				elseif self.reloadPhase == 2 then						
					self.phaseOnStop = 3;
				
				elseif self.reloadPhase == 3 then						
					self.phaseOnStop = 4;	
					
				elseif self.reloadPhase == 5 then						
					self.Frame = 1;
					
					self.angVel = self.angVel - 5
					
				else
					self.phaseOnStop = nil;

				end
			
				self.afterSoundPlayed = true;
				if self.afterSound then
					self.afterSound:Play(self.Pos)
				end
			end
			
			if self.reloadTimer:IsPastSimMS(self.reloadDelay + self.afterDelay) then
				self.phaseOnStop = nil;
				self.reloadTimer:Reset();
				self.prepareSoundPlayed = false;
				self.afterSoundPlayed = false;
					
				if self.reloadPhase == 4 then
					if self.needsChamber == true then
						self.reloadChamber = true;
						self.reloadPhase = 5;
						self.reChamber = false;
					else
						self.reChamber = false;
						self.BaseReloadTime = 0;
						self.reloadPhase = 0;
					end
					
				elseif self.reloadPhase == 5 then
					if self:IsReloading() then
						self.reChamber = false;
						self.reloadChamber = false;
						self.reloadPhase = 0;
					else
						self.reChamber = false;
						self.BaseReloadTime = 0;
						self.reloadPhase = 0;
					end
					self.needsChamber = false;
					
				else
					self.reloadPhase = self.reloadPhase + 1;
				end
			end
		end
		
	else
		
		self.reloadTimer:Reset();
		self.prepareSoundPlayed = false;
		self.afterSoundPlayed = false;
		if self.phaseOnStop then
			self.reloadPhase = self.phaseOnStop;
			self.phaseOnStop = nil;
		end
		if self.needsChamber then
			self.reloadPhase = 5;
		end
		self.BaseReloadTime = 9999;
	
	end
	
	if self:DoneReloading() == true then
		self.fireDelayTimer:Reset()
		self.Magazine.RoundCount = 5
	end	


	local fire = self:IsActivated() and self.RoundInMagCount > 0;
	
	if self.RoundInMagCount > 0 then
		self:Deactivate()
	end

	if self.parent and self.delayedFirstShot == true then
		
		--if self.parent:GetController():IsState(Controller.WEAPON_FIRE) and not self:IsReloading() then
		if fire and not self:IsReloading() then
			if not self.Magazine or self.Magazine.RoundCount < 1 then
				--self:Reload()
				self:Activate()
			elseif not self.activated and not self.delayedFire and self.fireDelayTimer:IsPastSimMS(1 / (self.RateOfFire / 60) * 1000) then
				self.activated = true
				
				self.preSound:Play(self.Pos);
				self.Frame = 0;
				
				self.fireDelayTimer:Reset()
				
				self.delayedFire = true
				self.delayedFireTimer:Reset()
			end
		else
			if self.activated then
				self.activated = false
			end
		end
	elseif fire == false then
		self.delayedFirstShot = true;
	end
	
	if self.FiredFrame then
		
		self.reloadPhase = 5;
	
		self.needsChamber = true;
		self.canChamber = false;
		self.reloadChamber = true;
	
		self.horizontalAnim = 24
	
		self.FireTimer:Reset();
	
		self.angVel = self.angVel - RangeRand(0.7,1.1) * 10
		
		self.canSmoke = true
		
		for i = 1, 5 do
			local Effect = CreateMOSParticle("Tiny Smoke Ball 1", "Base.rte")
			if Effect then
				Effect.Pos = self.MuzzlePos;
				Effect.Vel = (self.Vel + Vector(RangeRand(-20,20), RangeRand(-20,20)) + Vector(150*self.FlipFactor,0):RadRotate(self.RotAngle)) / 30
				MovableMan:AddParticle(Effect)
			end
		end
		
		local Effect = CreateMOSParticle("Side Thruster Blast Ball 1", "Base.rte")
		if Effect then
			Effect.Pos = self.MuzzlePos;
			Effect.Vel = (self.Vel + Vector(150*self.FlipFactor,0):RadRotate(self.RotAngle)) / 10
			MovableMan:AddParticle(Effect)
		end

		local outdoorRays = 0;
		
		local indoorRays = 0;
		
		local bigIndoorRays = 0;

		if self.parent and self.parent:IsPlayerControlled() then
			self.rayThreshold = 2; -- this is the first ray check to decide whether we play outdoors
			local Vector2 = Vector(0,-700); -- straight up
			local Vector2Left = Vector(0,-700):RadRotate(45*(math.pi/180));
			local Vector2Right = Vector(0,-700):RadRotate(-45*(math.pi/180));			
			local Vector2SlightLeft = Vector(0,-700):RadRotate(22.5*(math.pi/180));
			local Vector2SlightRight = Vector(0,-700):RadRotate(-22.5*(math.pi/180));		
			local Vector3 = Vector(0,0); -- dont need this but is needed as an arg
			local Vector4 = Vector(0,0); -- dont need this but is needed as an arg

			self.ray = SceneMan:CastObstacleRay(self.Pos, Vector2, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.rayRight = SceneMan:CastObstacleRay(self.Pos, Vector2Right, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.rayLeft = SceneMan:CastObstacleRay(self.Pos, Vector2Left, Vector3, Vector4, self.RootID, self.Team, 128, 7);			
			self.raySlightRight = SceneMan:CastObstacleRay(self.Pos, Vector2SlightRight, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.raySlightLeft = SceneMan:CastObstacleRay(self.Pos, Vector2SlightLeft, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			
			self.rayTable = {self.ray, self.rayRight, self.rayLeft, self.raySlightRight, self.raySlightLeft};
		else
			self.rayThreshold = 1; -- has to be different for AI
			local Vector2 = Vector(0,-700); -- straight up
			local Vector3 = Vector(0,0); -- dont need this but is needed as an arg
			local Vector4 = Vector(0,0); -- dont need this but is needed as an arg		
			self.ray = SceneMan:CastObstacleRay(self.Pos, Vector2, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			
			self.rayTable = {self.ray};
		end
		
		for _, rayLength in ipairs(self.rayTable) do
			if rayLength < 0 then
				outdoorRays = outdoorRays + 1;
			elseif rayLength > 170 then
				bigIndoorRays = bigIndoorRays + 1;
			else
				indoorRays = indoorRays + 1;
			end
		end
		
		if outdoorRays >= self.rayThreshold then
			self.reflectionOutdoorsSound:Play(self.Pos);
		end
	end
	
	if self.needsChamber == true and not self:IsReloading() and not (self.reChamber == true) then
		self:Deactivate();
		self.delayedFirstShot = false;
		if self.canChamber == false then
			if not fire then
				self.canChamber = true
			end
		elseif fire then
			if self.RoundInMagCount == 0 then
				self:Reload();
				self.reChamber = true
				self.reloadPhase = 5;
			else
				self.reloadChamber = false;
				self.reChamber = true
				self.reloadPhase = 5;
			end
		end
	end
	
	if self.delayedFire and self.delayedFireTimer:IsPastSimMS(self.delayedFireTimeMS) then
		self:Activate()	
		self.delayedFire = false
		self.delayedFirstShot = false;
	end
	
	-- Animation
	if self.parent then
		self.horizontalAnim = math.floor(self.horizontalAnim / (1 + TimerMan.DeltaTimeSecs * 24.0) * 1000) / 1000
		self.verticalAnim = math.floor(self.verticalAnim / (1 + TimerMan.DeltaTimeSecs * 15.0) * 1000) / 1000
		
		local stance = Vector()
		stance = stance + Vector(-1,0) * self.horizontalAnim -- Horizontal animation
		stance = stance + Vector(0,5) * self.verticalAnim -- Vertical animation
		
		self.rotationTarget = self.rotationTarget - (self.angVel * 4)
		
		-- Progressive Recoil Update
		if self.FiredFrame then
			self.recoilStr = self.recoilStr + ((math.random(10, self.recoilRandomUpper * 10) / 10) * 0.5 * self.recoilStrength) + (self.recoilStr * 0.6 * self.recoilPowStrength)
			self:SetNumberValue("recoilStrengthBase", self.recoilStrength * (1 + self.recoilPowStrength) / self.recoilDamping)
		end
		self:SetNumberValue("recoilStrengthCurrent", self.recoilStr)
		
		self.recoilStr = math.floor(self.recoilStr / (1 + TimerMan.DeltaTimeSecs * 8.0 * self.recoilDamping) * 1000) / 1000
		self.recoilAcc = (self.recoilAcc + self.recoilStr * TimerMan.DeltaTimeSecs) % (math.pi * 4)
		
		local recoilA = (math.sin(self.recoilAcc) * self.recoilStr) * 0.05 * self.recoilStr
		local recoilB = (math.sin(self.recoilAcc * 0.5) * self.recoilStr) * 0.01 * self.recoilStr
		local recoilC = (math.sin(self.recoilAcc * 0.25) * self.recoilStr) * 0.05 * self.recoilStr
		
		local recoilFinal = math.max(math.min(recoilA + recoilB + recoilC, self.recoilMax), -self.recoilMax)
		
		self.SharpLength = math.max(self.originalSharpLength - (self.recoilStr * 3 + math.abs(recoilFinal)), 0)
		
		self.rotationTarget = self.rotationTarget + recoilFinal -- apply the recoil
		-- Progressive Recoil Update		
		
		self.rotation = (self.rotation + self.rotationTarget * TimerMan.DeltaTimeSecs * self.rotationSpeed) / (1 + TimerMan.DeltaTimeSecs * self.rotationSpeed)
		local total = math.rad(self.rotation) * self.FlipFactor
		
		self.InheritedRotAngleOffset = total * self.FlipFactor;
		-- self.RotAngle = self.RotAngle + total;
		-- self:SetNumberValue("MagRotation", total);
		
		-- local jointOffset = Vector(self.JointOffset.X * self.FlipFactor, self.JointOffset.Y):RadRotate(self.RotAngle);
		-- local offsetTotal = Vector(jointOffset.X, jointOffset.Y):RadRotate(-total) - jointOffset
		-- self.Pos = self.Pos + offsetTotal;
		-- self:SetNumberValue("MagOffsetX", offsetTotal.X);
		-- self:SetNumberValue("MagOffsetY", offsetTotal.Y);
		
		self.StanceOffset = Vector(self.originalStanceOffset.X, self.originalStanceOffset.Y) + stance
		self.SharpStanceOffset = Vector(self.originalSharpStanceOffset.X, self.originalSharpStanceOffset.Y) + stance
	end
	
	if self.canSmoke and not self.FireTimer:IsPastSimMS(2500) then

		if self.smokeDelayTimer:IsPastSimMS(120) then
			
			local poof = CreateMOSParticle("Tiny Smoke Ball 1");
			poof.Pos = self.Pos + Vector(self.MuzzleOffset.X * self.FlipFactor, self.MuzzleOffset.Y):RadRotate(self.RotAngle);
			poof.Lifetime = poof.Lifetime * RangeRand(0.3, 1.3) * 0.9;
			poof.Vel = self.Vel * 0.1
			poof.GlobalAccScalar = RangeRand(0.9, 1.0) * -0.4; -- Go up and down
			MovableMan:AddParticle(poof);
			self.smokeDelayTimer:Reset()
		end
	end
end