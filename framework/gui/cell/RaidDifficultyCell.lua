local baseCell = autoImport("BaseCell")
RaidDifficultyCell = class("RaidDifficultyCell", baseCell)
local _BgSpriteName = {
  unlockSp = "Novicecopy_bg_06",
  unlockSp2 = "Novicecopy_bg_15",
  lockSp = "Novicecopy_bg_07",
  unlockOutlineColor = Color(0.4980392156862745, 0.6941176470588235, 0.8705882352941177, 1),
  unlock2OutlineColor = Color(0.592156862745098, 0.5686274509803921, 0.8313725490196079, 1),
  lockOutlineColor = Color(0.3803921568627451, 0.3803921568627451, 0.3803921568627451, 1)
}

function RaidDifficultyCell:Init()
  RaidDifficultyCell.super.Init(self)
  self:FindObj()
  self:AddCellClickEvent()
end

function RaidDifficultyCell:FindObj()
  self.root = self:FindGO("Root")
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.bg = self:FindComponent("Sprite", UISprite, self.root)
  self.choosenObj = self:FindGO("Choosen", self.root)
  self.desc = self:FindComponent("Desc", UILabel, self.root)
  self.finishGo = self:FindGO("Finish", self.root)
  self.lockGo = self:FindGO("Lock", self.root)
  self.stars = {}
  for i = 1, 3 do
    self.stars[i] = self:FindGO("Star" .. i):GetComponent(UIMultiSprite)
  end
end

function RaidDifficultyCell:SetData(data)
  self.data = data
  if data == PveEntranceProxy.EmptyDiff then
    self:Show(self.emptyRoot)
    self:Hide(self.root)
    return
  end
  self:Hide(self.emptyRoot)
  self:Show(self.root)
  local entranceData = data.staticEntranceData
  self.diff = entranceData.staticDifficulty
  local isPveCard = entranceData:IsPveCard()
  self.desc.text = entranceData:GetDifficultyDesc()
  local open = PveEntranceProxy.Instance:IsOpen(data.id)
  self.lockGo:SetActive(not open)
  if not open then
    self.bg.spriteName = _BgSpriteName.lockSp
    self.desc.effectColor = _BgSpriteName.lockOutlineColor
  else
    self.bg.spriteName = entranceData:IsHardMode() and _BgSpriteName.unlockSp2 or _BgSpriteName.unlockSp
    self.desc.effectColor = entranceData:IsHardMode() and _BgSpriteName.unlock2OutlineColor or _BgSpriteName.unlockOutlineColor
  end
  self:UpdateChoose()
  local max_challengeCount = entranceData.staticData.ChallengeCount
  if isPveCard then
    max_challengeCount = max_challengeCount + (PveEntranceProxy.Instance.pveCard_addTimes or 0)
  end
  local server_challengeCount = data:GetPassTime()
  if isPveCard or entranceData:IsElement() or entranceData:IsStarArk() then
    self.finishGo:SetActive(data:GetQuick())
  else
    self.finishGo:SetActive(max_challengeCount == server_challengeCount)
  end
  local starStatus = 0
  for i = 1, 3 do
    self.stars[i].CurrentState = i <= starStatus and 1 or 0
  end
end

function RaidDifficultyCell:SetChoosen(id)
  self.chooseDifficulty = id
  self:UpdateChoose()
end

function RaidDifficultyCell:UpdateChoose()
  if self.diff and self.chooseDifficulty and self.diff == self.chooseDifficulty then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end
