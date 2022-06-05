
function Create(self)
	self.Vel = self.Vel+Vector(5*math.random(),0):RadRotate(math.random()*(math.pi*2));
	self.time = math.random(20,130);
	self.timer = Timer();
end

function Update(self)

	if self.timer:IsPastSimMS(self.time) then
		self.timer:Reset();

		self.Mass = self.Mass*0.9;
		self.Sharpness = self.Sharpness*0.9;
	end
end