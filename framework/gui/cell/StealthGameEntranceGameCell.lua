local baseCell = autoImport("BaseCell")
StealthGameEntranceGameCell = class("StealthGameEntranceGameCell", baseCell)
local picIns

function StealthGameEntranceGameCell:Init()
  if not picIns then
    picIns = PictureManager.Instance
  end
  self.tex = self:FindComponent("Tex", UITexture)
  self.label = self:FindComponent("Label", UILabel)
  self.finished = self:FindGO("Finished")
  self.choose = self:FindGO("Choose")
  self:AddCellClickEvent()
end

function StealthGameEntranceGameCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.texName = data.Pic
  picIns:SetSevenRoyalFamiliesTexture(self.texName, self.tex)
  self.label.text = Table_Map[data.id].NameZh
  self:UpdateFinished()
  self:UpdateChoose()
end

function StealthGameEntranceGameCell:OnExit()
  if self.texName then
    picIns:UnloadSevenRoyalFamiliesTexture(self.texName, self.tex)
  end
end

function StealthGameEntranceGameCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function StealthGameEntranceGameCell:UpdateFinished()
  local cfg, count, dungeonIns = self.data.PointToReward, 0, DungeonProxy.Instance
  for i = 1, #cfg do
    if dungeonIns:CheckClientRaidAchRewarded(cfg[i].Point) then
      count = count + 1
    end
  end
  local finished = count == #cfg
  self.finished:SetActive(finished)
  self.tex.color = finished and ColorUtil.NGUIDeepGray or ColorUtil.NGUIWhite
end

function StealthGameEntranceGameCell:UpdateChoose()
  self.choose:SetActive(self.data ~= nil and self.chooseId == self.data.id)
end
