autoImport("ItemNewCell")
ComodoBuildingMusicBoxListCell = class("ComodoBuildingMusicBoxListCell", CoreView)
local ins

function ComodoBuildingMusicBoxListCell:ctor(obj)
  if not ins then
    ins = ComodoBuildingProxy.Instance
  end
  ComodoBuildingMusicBoxListCell.super.ctor(self, obj)
  self.itemCell = ItemNewCell.new(self.gameObject)
  self.got = self:FindGO("Got")
  self:AddClickEvent(self.itemCell.iconGO, function()
    self:PassEvent(HappyShopEvent.SelectIconSprite, self)
  end)
  self.itemData = ItemData.new()
end

function ComodoBuildingMusicBoxListCell:SetData(data)
  self.data = data
  self.itemData:ResetData("lottery", data.ProductID)
  self.itemData.num = data.ProductCount
  self.itemCell:SetData(self.itemData)
  self.got:SetActive(ins:CheckLotteryGot(data.id))
end
