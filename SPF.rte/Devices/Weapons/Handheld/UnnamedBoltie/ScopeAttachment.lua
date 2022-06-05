
function OnDetach(self, exParent)
	exParent:SetNumberValue("LostScopeAttachment", 1)
	self.ToDelete = true
end
