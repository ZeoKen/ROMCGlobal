local _RaceConfig = GameConfig.MonsterAttr.Race
PveMonsterCell = class("PveMonsterCell", BaseCell)

function PveMonsterCell:Init()
  PveMonsterCell.super.Init(self)
  self:FindObj()
end

function PveMonsterCell:FindObj()
  self.raceLab = self:FindComponent("RaceLab", UILabel)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.faceIcon = self:FindComponent("Icon", UISprite)
  self.natureIcon = self:FindComponent("Nature", UISprite)
  self.choosenObj = self:FindGO("Choosen")
  local bg = self:FindGO("Bg")
  self:SetEvent(bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PveMonsterCell:SetData(monsterId)
  self.data = monsterId
  local monsterStaticData = Table_Monster[monsterId]
  if not monsterStaticData then
    redlog("Table_Monster未找到ID : ", monsterId)
    return
  end
  self.nameLab.text = monsterStaticData.NameZh
  IconManager:SetFaceIcon(monsterStaticData.Icon, self.faceIcon)
  local race = monsterStaticData.Race
  if StringUtil.IsEmpty(race) or not _RaceConfig[race] then
    self:Hide(self.raceLab)
  else
    self:Show(self.raceLab)
    self.raceLab.text = _RaceConfig[race]
  end
  local nature = monsterStaticData.Nature
  if StringUtil.IsEmpty(nature) then
    self:Hide(self.natureIcon)
  else
    self:Show(self.natureIcon)
    IconManager:SetUIIcon(nature, self.natureIcon)
  end
  self:UpdateChoose()
end

function PveMonsterCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end

function PveMonsterCell:UpdateChoose()
  if self.data and self.chooseId and self.data == self.chooseId then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end
