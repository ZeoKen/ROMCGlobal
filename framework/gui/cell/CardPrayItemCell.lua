autoImport("ItemCardCell")
CardPrayItemCell = class("CardPrayItemCell", ItemCardCell)

function CardPrayItemCell:Init()
  local container = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCardCell", container)
  obj.transform.localPosition = LuaVector3.Zero()
  CardPrayItemCell.super.Init(self)
  self:_FindObj()
end

function CardPrayItemCell:_FindObj()
  self.chooseObj = self:FindGO("Choose")
  self.collider = self.cardQuality.gameObject:AddComponent(BoxCollider)
  self.collider.size = LuaGeometry.GetTempVector3(80, 80, 80)
  self.cardQuality.gameObject:AddComponent(UIDragScrollView)
  self:AddClickEvent(self.collider.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local longPress = self.cardQuality.gameObject:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
end

function CardPrayItemCell:SetData(data)
  CardPrayItemCell.super.SetData(self, data)
  self:UpdateChoose()
end

function CardPrayItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function CardPrayItemCell:UpdateChoose()
  if self.data and self.data.staticData and self.data.staticData.id == self.chooseId then
    self.chooseObj:SetActive(true)
  else
    self.chooseObj:SetActive(false)
  end
end

function CardPrayItemCell:SetLocalScale(scale)
  LuaGameObject.SetLocalScaleGO(self.gameObject, scale, scale, scale)
end
