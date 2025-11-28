LotteryBaseCell = class("LotteryBaseCell", ItemCell)

function LotteryBaseCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  LotteryBaseCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function LotteryBaseCell:FindObjs()
  self.rateGO = self:FindGO("Rate")
  if self.rateGO then
    self.rateLabel = self.rateGO:GetComponent(UILabel)
  end
  self.ownedGO = self:FindGO("Bought")
end

function LotteryBaseCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function LotteryBaseCell:SetData(data)
  self.gameObject:SetActive(not not data)
  self.rawData = data
  if self.rawData then
    LotteryBaseCell.super.SetData(self, self.rawData:GetItemData())
    local owned = not not self.rawData.owned
    self.rateGO:SetActive(not owned)
    self.ownedGO:SetActive(owned)
    if not owned then
      self.rateLabel.text = string.format(OverSea.LangManager.Instance():GetLangByKey(ZhString.Lottery_DetailRate), self.rawData.rate)
    end
  end
end
