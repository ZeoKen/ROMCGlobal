local baseCell = autoImport("BaseCell")
RoadOfHeroTargetCell = class("RoadOfHeroTargetCell", baseCell)

function RoadOfHeroTargetCell:Init()
  self.desc = self.gameObject:GetComponent(UILabel)
  self.lock = self:FindGO("Lock")
  self.finish = self:FindGO("Finish")
  self.star = self:FindGO("Star"):GetComponent(UIMultiSprite)
end

function RoadOfHeroTargetCell:SetData(data)
  self.data = data
  local desc = data.desc
  self.desc.text = desc or ""
  local isChallenge = data.pass or false
  local isUnlock = data.unlock
  if isChallenge then
    self.star:SetActive(true)
    self.star.CurrentState = isUnlock and 1 or 0
  else
    self.lock:SetActive(not isUnlock)
    self.finish:SetActive(isUnlock)
  end
end
