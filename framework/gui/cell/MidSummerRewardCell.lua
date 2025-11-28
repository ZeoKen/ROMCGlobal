MidSummerRewardCell = class("MidSummerRewardCell", CoreView)

function MidSummerRewardCell:ctor(obj)
  MidSummerRewardCell.super.ctor(self, obj)
  self.item = self:FindGO("Item")
  self.itemIcon = self:FindComponent("Icon", UISprite, self.item)
  self.itemNumLabel = self:FindComponent("NumLabel", UILabel, self.item)
  self.action = self:FindGO("Action")
  self.actionIcon = self:FindComponent("Icon", UISprite, self.action)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MidSummerRewardCell:SetData(data)
  self.data = data
  local t = type(data)
  if t == "table" and data.staticData then
    self.gameObject:SetActive(true)
    self.item:SetActive(true)
    self.action:SetActive(false)
    if data.staticData.Type == 1200 then
      if not IconManager:SetFaceIcon(data.staticData.Icon, self.itemIcon) then
        IconManager:SetFaceIcon("boli", self.itemIcon)
      end
    elseif not IconManager:SetItemIcon(data.staticData.Icon, self.itemIcon) then
      IconManager:SetItemIcon("item_45001", self.itemIcon)
    end
    self.itemNumLabel.text = data.num and data.num > 1 and tostring(data.num) or ""
  elseif t == "string" then
    self.gameObject:SetActive(true)
    self.item:SetActive(false)
    self.action:SetActive(true)
    if IconManager:SetActionIcon(data, self.actionIcon) then
      self.actionIcon:MakePixelPerfect()
    end
  else
    self.gameObject:SetActive(false)
  end
end
