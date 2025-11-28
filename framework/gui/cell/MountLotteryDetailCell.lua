MountLotteryDetailCell = class("MountLotteryDetailCell", ItemCell)

function MountLotteryDetailCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  MountLotteryDetailCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function MountLotteryDetailCell:FindObjs()
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.bought = self:FindGO("Bought")
end

function MountLotteryDetailCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MountLotteryDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  self.data = data
  if self.data then
    if not self.data.itemData then
      local idata = ItemData.new("LotteryItem", data.itemid)
      idata.num = self.data.count
      self.data.itemData = idata
    end
    MountLotteryDetailCell.super.SetData(self, self.data.itemData)
    if self.rate and not data.got then
      self.rate.text = string.format(ZhString.Lottery_DetailRate, data.weight / MountLotteryProxy.Instance:GetWeightByIndex(data.round) * 100)
      self.rate.gameObject:SetActive(true)
    elseif data.got then
      self.rate.gameObject:SetActive(false)
    end
    if self.bought then
      self.bought:SetActive(data.got)
    end
  end
end
