CardMakeNewCell = class("CardMakeNewCell", ItemCell)

function CardMakeNewCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  CardMakeNewCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function CardMakeNewCell:FindObjs()
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.itemType = self:FindComponent("ItemType", UILabel)
  self.choose = self:FindGO("ChooseSymbol")
  self.makeableMark = self:FindGO("Makeable")
  self.inStore = self:FindGO("InStore")
  self.canStore = self:FindGO("CanStore")
end

function CardMakeNewCell:AddEvts()
  self:AddCellClickEvent()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(CardMakeEvent.Select, self)
  end)
end

function CardMakeNewCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    CardMakeNewCell.super.SetData(self, data.itemData)
    self.itemType.text = ItemUtil.GetItemTypeName(data.itemData.staticData)
    self.choose:SetActive(data.isChoose)
    self.makeableMark:SetActive(data:IsMakeable())
    local advData = AdventureDataProxy.Instance:GetItemByStaticIDFromBag(data.itemData.staticData.id, SceneManual_pb.EMANUALTYPE_CARD)
    if advData then
      self.inStore:SetActive(advData.store)
      local isCanStore = not advData.store and AdventureDataProxy.Instance:checkFashionCanStore(advData) and true or false
      self.canStore:SetActive(isCanStore)
    else
      self.inStore:SetActive(false)
      self.canStore:SetActive(false)
    end
  end
  self.data = data
end

function CardMakeNewCell:SetChoose(isChoose)
  if self.data then
    self.data:SetChoose(isChoose)
    self.choose:SetActive(isChoose)
  end
end
