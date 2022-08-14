function Create(self)

	self.spillLoop = CreateSoundContainer("SPF Rum Spill Loop", "SPF.rte");
	self.drinkSound = CreateSoundContainer("SPF Rum Drink", "SPF.rte");

	self.originalStanceOffset = Vector(6, 8);
	
	self.rotation = 0;
	self.stance = Vector(0, 0);
	
	self.flipTimer = Timer();
	
	self.drinkTimer = Timer();
	self.keepDrinkTimer = Timer();

end
function Update(self)

	self.spillLoop.Pos = self.Pos;
	
	self.parent = self:GetRootParent();
	if IsAHuman(self.parent) and ToAHuman(self.parent).Head then
	
		if self.flipTimer:IsPastSimMS(250) then
		
			if self.HFlipped ~= self.oldHFlipped then
				self:Deactivate();
				self.flipTimer:Reset();
			end
		
			self.parent = ToAHuman(self.parent);
			local controller = self.parent:GetController();
			controller:SetState(Controller.AIM_SHARP,false);
			
			local stanceTarget = Vector(0, 0);
			local rotationTarget = 0;
		
			--local jointOffset = Vector(self.JointOffset.X * self.FlipFactor, self.JointOffset.Y):RadRotate(self.RotAngle);
			--self.Pos = self.Pos - jointOffset + Vector(jointOffset.X, jointOffset.Y):RadRotate(-self.rotation);
			
			local dist = SceneMan:ShortestDistance(self.Pos, self.parent.Head.Pos + Vector(0, 4), SceneMan.SceneWrapsX)
			
			if self:IsActivated() or (self.firstActivate and not self.keepDrinkTimer:IsPastSimMS(500)) then
			
				self.firstActivate = true;
			
				local factor = math.max(0, (self.parent:GetAimAngle(false) / math.pi/2) * 5);
				
				local extraStance = self.tooClose and Vector(math.abs(dist.X*1.4), 3) or Vector(0, 0)
			
				stanceTarget = Vector((4 + 4 * factor) + extraStance.X, (-15 + 8 * factor) + extraStance.Y);
				
				local angle = dist.AbsRadAngle;
				
				local min_value = -math.pi
				local max_value = math.pi
				local value = angle - self.RotAngle
				local result;
				
				local range = max_value - min_value;
				if range <= 0 then
					result = min_value;
				else
					local ret = (value - min_value) % range;
					if ret < 0 then ret = ret + range end
					result = ret + min_value;
				end
				
				
				local annoyingFix = self.HFlipped and 0.6 or 0
				rotationTarget = result * math.max(0.7, factor) + annoyingFix
				
				
			else
				stanceTarget = Vector(0, 0);
				rotationTarget = 0
			end
			
			self.stance = stanceTarget
			
			rotationTarget = math.max(math.min(rotationTarget, math.pi/2), -math.pi/2)
			self.rotation = rotationTarget
			
			self.StanceOffset = self.originalStanceOffset + self.stance
			self.InheritedRotAngleOffset = self.rotation
			
			if controller:IsState(Controller.PRIMARY_ACTION) then
				self.keepDrinkTimer:Reset();
			end
			
			if self:IsActivated() or not self.keepDrinkTimer:IsPastSimMS(500) then
				if dist.X * self.FlipFactor > -3 and not self.tooClose then
					self.tooClose = true;
					print(dist.X)
				end
			
				if self.RotAngle * self.FlipFactor > 1.6 and self.Magazine and self.Magazine.RoundCount > 0 then
					if not self.Drinking then
						self.Drinking = true;
						if self.parent:IsOrganic() or string.find(self.parent:GetEntryWoundPresetName(), "Flesh") then
							
						else
							self.spillLoop:Play(self.Pos);
							self.Robotic = true;
							self.parent:SetNumberValue("Robo Drink Rum", 1);
						end
					else
						if self.drinkTimer:IsPastSimMS(100) then
							self.drinkTimer:Reset()
							self.Magazine.RoundCount = self.Magazine.RoundCount - 1;
							if not self.Robotic then
								self.drinkSound:Play(self.Pos);
								self.parent.Health = self.parent.Health + 1;
								if self.parent.Health > self.parent.MaxHealth then
									self.parent.Health = self.parent.MaxHealth;
								end
							end
						end
					end
				elseif self.Drinking then
					self.Drinking = false;
					if self.Robotic then
						self.Robotic = false;
						self.spillLoop:FadeOut(100);
					end
					
				end
		
			elseif self.Drinking then
				self.tooClose = false;
				self.Drinking = false;
				if self.Robotic then
					self.Robotic = false;
					self.spillLoop:FadeOut(100);
				end
			else
				self.tooClose = false;
			end
			
			self.oldHFlipped = self.HFlipped;
		end
		
	else
		self.parent = nil;
		self.rotation = 0;
		self.stance = Vector(0, 0);
	end
		

end

function OnDestroy(self)

	self.spillLoop:Stop(-1);
	
end
