ComodoBuildingSendItemCell = class("ComodoBuildingSendItemCell", CoreView)

function ComodoBuildingSendItemCell:ctor(obj)
  ComodoBuildingSendItemCell.super.ctor(self, obj)
  self.icon = self:FindComponent("Icon", UISprite)
  self.star = self:FindComponent("Star", UISprite)
  self.got = self:FindGO("Got")
  self.choose = self:FindGO("ChooseSymbol")
  self.longPress = self.gameObject:GetComponent(UILongPress)
  if self.star then
    IconManager:SetUIIcon("icon_40", self.star)
  end
  if self.longPress then
    function self.longPress.pressEvent(g, state)
      self:PassEvent(MouseEvent.LongPress, {state, self})
    end
  end
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ComodoBuildingSendItemCell:SetData(data)
  local flag = data ~= nil and data.id ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.id = data.id
  local succ
  if Table_Item[data.id] then
    succ = IconManager:SetItemIcon(Table_Item[data.id].Icon, self.icon)
  else
    succ = IconManager:SetNpcMonsterIconByID(data.id, self.icon)
  end
  if not succ then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.icon.color = data.grey == true and ColorUtil.NGUIShaderGray or ColorUtil.NGUIWhite
  self.star.gameObject:SetActive(data.hasStar == true)
  if self.got then
    self.got:SetActive(data.got == true)
  end
  self:UpdateChoose()
end

function ComodoBuildingSendItemCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function ComodoBuildingSendItemCell:UpdateChoose()
  if not self.choose then
    return
  end
  self.choose:SetActive(self.chooseId == self.id)
end

function ComodoBuildingSendItemCell:SetLongPressTime(time)
  self.longPress.pressTime = time or 0.8
end
