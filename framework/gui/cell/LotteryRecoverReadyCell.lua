LotteryRecoverReadyCell = class("LotteryRecoverReadyCell", ItemCell)

function LotteryRecoverReadyCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  LotteryRecoverReadyCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:HideNum()
end

function LotteryRecoverReadyCell:FindObjs()
  self.sub = self:FindGO("Sub")
  self.count = self:FindGO("Count"):GetComponent(UILabel)
end

function LotteryRecoverReadyCell:AddEvts()
  self:AddClickEvent(self.sub, function()
    self:PassEvent(LotteryEvent.Select, self)
  end)
end

function LotteryRecoverReadyCell:UpdateSub(data)
  data = data or self.data
  self.sub:SetActive(data.selectCount > 0)
end

function LotteryRecoverReadyCell:UpdateCount()
  self.count.text = tostring(self.data.selectCount)
end

function LotteryRecoverReadyCell:SelectCount(offset)
  if self.data:SelectCount(offset) then
    self:UpdateSub()
    self:UpdateCount()
  end
end

function LotteryRecoverReadyCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  local lotteryRecoverData = LotteryProxy.Instance:GetRecoverData(data.lotteryType, data.guid)
  LotteryRecoverReadyCell.super.SetData(self, lotteryRecoverData.itemData)
  self.data = lotteryRecoverData
  self:ActiveNewTag(false)
  self:HideBgSp()
  self:UpdateCount()
  self:UpdateSub()
end
