PveBossCell = class("PveBossCell", BaseCell)

function PveBossCell:Init()
  PveBossCell.super.Init(self)
  self:FindObj()
end

function PveBossCell:FindObj()
  self.faceIcon = self:FindComponent("Icon", UISprite)
  self.choosenObj = self:FindGO("Choosen")
  local bg = self:FindGO("Bg")
  self.lvLab = self:FindComponent("Lv", UILabel)
  self:SetEvent(bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PveBossCell:SetData(monsterId)
  self.data = monsterId
  self.lvLab.text = string.format(ZhString.Pve_Lv, FunctionPve.Me():GetCurRecommendLv())
  local monsterStaticData = Table_Monster[monsterId]
  if not monsterStaticData then
    redlog("Table_Monster未找到ID : ", monsterId)
    return
  end
  IconManager:SetFaceIcon(monsterStaticData.Icon, self.faceIcon)
  self:UpdateChoose()
end

function PveBossCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end

function PveBossCell:UpdateChoose()
  if self.data and self.chooseId and self.data == self.chooseId then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end
