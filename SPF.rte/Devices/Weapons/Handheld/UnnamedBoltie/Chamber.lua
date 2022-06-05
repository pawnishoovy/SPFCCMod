function Create(self)

	self.parentSet = false;
	
	-- Sounds --
	
	self.preSound = CreateSoundContainer("Pre UnnamedBoltie", "SPF.rte");
	self.reflectionOutdoorsSound = CreateSoundContainer("ReflectionOutdoors UnnamedBoltie", "SPF.rte");
	
	self.reloadPrepareSounds = {}
	self.reloadPrepareSounds.BoltUp = nil
	self.reloadPrepareSounds.BoltBack = nil
	self.reloadPrepareSounds.RoundIn = nil
	self.reloadPrepareSounds.BoltForward = nil
	self.reloadPrepareSounds.BoltDown = nil
	
	self.reloadPrepareLengths = {}
	self.reloadPrepareLengths.BoltUp = 0
	self.reloadPrepareLengths.BoltBack = 0
	self.reloadPrepareLengths.RoundIn = 0
	self.reloadPrepareLengths.BoltForward = 0
	self.reloadPrepareLengths.BoltDown = 0
	
	self.reloadPrepareDelay = {}
	self.reloadPrepareDelay.BoltUp = 100
	self.reloadPrepareDelay.BoltBack = 135
	self.reloadPrepareDelay.RoundIn = 200
	self.reloadPrepareDelay.BoltForward = 225
	self.reloadPrepareDelay.BoltDown = 150
	
	self.reloadAfterSounds = {}
	self.reloadAfterSounds.BoltUp = CreateSoundContainer("BoltUp UnnamedBoltie", "SPF.rte");
	self.reloadAfterSounds.BoltBack = CreateSoundContainer("BoltBack UnnamedBoltie", "SPF.rte");
	self.reloadAfterSounds.RoundIn = CreateSoundContainer("RoundIn UnnamedBoltie", "SPF.rte");
	self.reloadAfterSounds.BoltForward = CreateSoundContainer("BoltForward UnnamedBoltie", "SPF.rte");
	self.reloadAfterSounds.BoltDown = CreateSoundContainer("BoltDown UnnamedBoltie", "SPF.rte");
	
	self.reloadAfterDelay = {}
	self.reloadAfterDelay.BoltUp = 85
	self.reloadAfterDelay.BoltBack = 200
	self.reloadAfterDelay.RoundIn = 200
	self.reloadAfterDelay.BoltForward = 100
	self.reloadAfterDelay.BoltDown = 150
	
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
	
	self.ammoCount = 5
	
	self.reloadTimer = Timer();
	
	self.reloadPhase = 0;
	
	self.ReloadTime = 9999;
	
	self.fireDelayTimer = Timer();
	self.delayedFire = false
	self.delayedFireTimer = Timer();
	self.delayedFireTimeMS = 40
	self.delayedFireEnabled = true
	self.activated = false
	
	-- Progressive Recoil System 
	self.recoilAcc = 0 -- for sinous
	self.recoilStr = 0 -- for accumulator
	self.recoilStrength = 26 -- multiplier for base recoil added to the self.recoilStr when firing
	self.recoilPowStrength = 0.2 -- multiplier for self.recoilStr when firing
	self.recoilRandomUpper = 1.3 -- upper end of random multiplier (1 is lower)
	self.recoilDamping = 0.4
	
	self.recoilMax = 15 -- in deg.
	self.originalSharpLength = self.SharpLength
	-- Progressive Recoil System 
end

function Update(self)
	self.Frame = 0;
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
	-- PAWNIS RELOAD ANIMATION HERE
	if self.parent and (self:IsReloading() or self.Chamber == true) then
		if controller and self:IsReloading() then controller:SetState(Controller.AIM_SHARP,false) end
		
		local screen = ActivityMan:GetActivity():ScreenOfPlayer(controller.Player);
		
		self.fireDelayTimer:Reset();
		
		--PrimitiveMan:DrawTextPrimitive(parent.Pos + Vector(0, -25), tostring(self.reloadPhase), false, 0);
		--PrimitiveMan:DrawTextPrimitive(parent.Pos + Vector(0, -18), self.chamberOnReload and "CHAMBER" or "---", false, 0);
		
		if self.reloadPhase == 0 then

			self.reloadDelay = self.reloadPrepareDelay.BoltUp;
			self.afterDelay = self.reloadAfterDelay.BoltUp;		
			
			self.prepareSound = self.reloadPrepareSounds.BoltUp;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltUp;
			self.afterSound = self.reloadAfterSounds.BoltUp;
			--
			self.rotationTarget = 15-- * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)
			
		elseif self.reloadPhase == 1 then
		
		--	self.FrameLocal = self.FrameIntermediate

			self.reloadDelay = self.reloadPrepareDelay.BoltBack;
			self.afterDelay = self.reloadAfterDelay.BoltBack;		
			if self:IsReloading() then
				self.afterDelay = self.reloadAfterDelay.BoltBack * 2;
			end
			
			self.prepareSound = self.reloadPrepareSounds.BoltBack;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltBack;
			self.afterSound = self.reloadAfterSounds.BoltBack;
			--
			self.rotationTarget = 15-- * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)			
			
		elseif self.reloadPhase == 2 then
		
			--self.FrameLocal = self.FrameRange
		
			self.reloadDelay = self.reloadPrepareDelay.RoundIn;
			self.afterDelay = self.reloadAfterDelay.RoundIn;		
			
			self.prepareSound = self.reloadPrepareSounds.RoundIn;
			self.prepareSoundLength = self.reloadPrepareLengths.RoundIn;
			self.afterSound = self.reloadAfterSounds.RoundIn;
			--
			self.rotationTarget = 18 * (math.pow(self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay), 3) - 0.5) * 2	
			
		elseif self.reloadPhase == 3 then
		
			--self.FrameLocal = self.FrameRange

			self.reloadDelay = self.reloadPrepareDelay.BoltForward;
			if self:IsReloading() then
				self.reloadDelay = self.reloadPrepareDelay.BoltForward * 2;
			end
			self.afterDelay = self.reloadAfterDelay.BoltForward;		
			
			self.prepareSound = self.reloadPrepareSounds.BoltForward;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltForward;
			self.afterSound = self.reloadAfterSounds.BoltForward;
			--
			self.rotationTarget = 15-- * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)
			
		elseif self.reloadPhase == 4 then
		
		--	self.FrameLocal = self.FrameIntermediate

			self.reloadDelay = self.reloadPrepareDelay.BoltDown;
			self.afterDelay = self.reloadAfterDelay.BoltDown;		
			
			self.prepareSound = self.reloadPrepareSounds.BoltDown;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltDown;
			self.afterSound = self.reloadAfterSounds.BoltDown;
			--
			self.rotationTarget = 2-- * self.reloadTimer.ElapsedSimTimeMS / (self.reloadDelay + self.afterDelay)
			
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
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*2)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 2)
				
				-- PrimitiveMan:DrawLinePrimitive(parent.Pos + Vector(0, -25), parent.Pos + Vector(0, -25) + Vector(0, -25):RadRotate(math.pi * (factor - 0.5)), 122);
				
				-- self.FrameLocal = math.floor(factor * (self.FrameIntermediate) + 0.5)
				
				-- self.rotationTarget = -5 + -15 * factor	
				
			elseif self.reloadPhase == 1 then
			
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*2)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 2)
				
				-- PrimitiveMan:DrawLinePrimitive(parent.Pos + Vector(0, -25), parent.Pos + Vector(0, -25) + Vector(0, -25):RadRotate(math.pi * (factor - 0.5)), 122);
				
				-- self.FrameLocal = self.FrameIntermediate + math.floor(factor * (self.FrameRange - self.FrameIntermediate) + 0.5)
				
				-- self.rotationTarget = -5 + -15 * factor
				
			elseif self.reloadPhase == 2 then
			
				if controller:IsState(Controller.WEAPON_FIRE) then
					self.breakReload = true;
					PrimitiveMan:DrawTextPrimitive(screen, self.parent.AboveHUDPos + Vector(0, 30), "Interrupting...", true, 1);
				end
				
			elseif self.reloadPhase == 3 then
			
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*2)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 0.5)
				
				-- self.FrameLocal = math.floor((1 - factor) * (self.FrameRange) + 0.5)
				
				-- PrimitiveMan:DrawLinePrimitive(parent.Pos + Vector(0, -25), parent.Pos + Vector(0, -25) + Vector(0, -25):RadRotate(math.pi * ((1 - factor) - 0.5)), 122);
				
				-- self.rotationTarget = -15 - -10 * factor
			
			elseif self.reloadPhase == 4 then
			
				-- local minTime = self.reloadDelay
				-- local maxTime = self.reloadDelay + ((self.afterDelay/5)*2)
				
				-- local factor = math.pow(math.min(math.max(self.reloadTimer.ElapsedSimTimeMS - minTime, 0) / (maxTime - minTime), 1), 0.5)
				
				-- self.FrameLocal = self.FrameIntermediate - math.floor(factor * (self.FrameRange - self.FrameIntermediate) + 0.5)
				
				-- PrimitiveMan:DrawLinePrimitive(parent.Pos + Vector(0, -25), parent.Pos + Vector(0, -25) + Vector(0, -25):RadRotate(math.pi * ((1 - factor) - 0.5)), 122);
				
				-- self.rotationTarget = -15 - -10 * factor
				
			end
			
			if self.afterSoundPlayed ~= true then
			
			
				if self.reloadPhase == 0 then
					self.phaseOnStop = 1
					
					self.oneInChamberNegatorValue = -1;
					
				elseif self.reloadPhase == 1 then
					self.phaseOnStop = 2;
					
					if self.spentRound ~= true then
						self.ammoCount = math.max(self.ammoCount - 1, 0)
					end
					
					local shell = CreateMOSParticle("Casing");
					shell.Pos = self.Pos;
					shell.Vel = Vector(math.random(-4, -2)*self.FlipFactor, -5):RadRotate(self.RotAngle);
					MovableMan:AddParticle(shell);
					
					self.boltBack = true;
					self.spentRound = false;
			
				elseif self.reloadPhase == 2 then
				
					self.ammoCount = self.ammoCount + 1
					
					if self.ammoCount == 5 then	
						self.phaseOnStop = 3;
					else
						self.phaseOnStop = 2;
					end
					
					self.verticalAnim = self.verticalAnim + 1	

				elseif self.reloadPhase == 3 then
					self.phaseOnStop = 4;
					self.boltBack = false;
				
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
				
				if self.reloadPhase == 1 then
					if self.reChamber == true and not self:IsReloading() then
						self.reloadPhase = 3;
						self.reChamber = false;
						
					elseif self:IsReloading() then
						self.reChamber = false;
						self.Chamber = false;
						self.reloadPhase = 2;
						
					end
					
				elseif self.reloadPhase == 2 then	
					
					if self.ammoCount == 5 or self.breakReload == true then
						self.reloadPhase = 3;
						self.breakReload = false;
					else
						self.reloadPhase = 2; -- the ride never ends (until we're at max)
					end

				elseif self.reloadPhase == 3 then
					
					if self.Chamber == true and self:IsReloading() then
						self.Chamber = false;
						self.reloadPhase = 1;
					else
						self.reloadPhase = 4;
					end
					
				elseif self.reloadPhase == 4 then
				
					if self.Chamber == true and self:IsReloading() then
						self.Chamber = false;
						self.reloadPhase = 0;
					else
						self.boltBack = false;
						self.Chamber = false;
						self.reChamber = false;
						self.ReloadTime = 0;
						self.reloadPhase = 0;
					end

				else
					self.reloadPhase = self.reloadPhase + 1;
				end
			end
		end
		
	else
		self.rotationTarget = 0
		
		-- if self.boltBack == true then
			-- self.FrameLocal = self.FrameRange;
		-- else
			-- self.FrameLocal = 0;
		-- end
		
		self.reloadTimer:Reset();
		self.prepareSoundPlayed = false;
		self.afterSoundPlayed = false;
		
		if self.phaseOnStop then
			self.reloadPhase = self.phaseOnStop;
			self.phaseOnStop = nil;
		end
		
		self.ReloadTime = 30000;
	end
	
	if self:DoneReloading() then
		self.fireDelayTimer:Reset()
		self.Magazine.RoundCount = self.ammoCount;
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
	
		self.reloadPhase = 0
	
		self.ammoCount = self.ammoCount - 1
	
		self.spentRound = true;
		self.canChamber = false;
	
		self.horizontalAnim = math.min(7, math.max(20, self.recoilStrength));
	
		self.FireTimer:Reset();
	
		self.angVel = self.angVel - RangeRand(0.7,1.1) * 15
		
		self.canSmoke = true
		
		for i = 1, 6 do
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
	
	if self.delayedFire and self.delayedFireTimer:IsPastSimMS(self.delayedFireTimeMS) then
		self:Activate()	
		self.delayedFire = false
		self.delayedFirstShot = false;
	end
	
	if self.spentRound == true and not self:IsReloading() and not (self.Chamber == true or self.reChamber == true) then
		self.delayedFirstShot = false
		if self.canChamber == false then
			if (controller and not fire) then
				self.canChamber = true
			end
		elseif (controller and fire) then
			if self.ammoCount == 0 then
				self:Reload();
			else
				self.Chamber = true
				self.reChamber = true
				self.reloadPhase = 0
			end
		end
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