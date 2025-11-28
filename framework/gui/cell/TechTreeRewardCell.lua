local baseCell = autoImport("BaseCell")
TechTreeRewardCell = class("TechTreeRewardCell", baseCell)

function TechTreeRewardCell:Init()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.numLab = self:FindComponent("NumLabel", UILabel)
  self.first = self:FindGO("First")
  self.got = self:FindGO("Got")
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.timeLabel.gameObject:SetActive(false)
  local obj = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(0.65, 0.65, 0.65)
  self.cardCell = ItemCardCell.new(obj)
  local sps = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIWidget, true)
  for i = 1, #sps do
    sps[i].depth = 5 + sps[i].depth
  end
  self:AddCellClickEvent()
end

function TechTreeRewardCell:SetData(data)
  self.id = data and data.id or nil
  self.gameObject:SetActive(self.id ~= nil)
  if self.id then
    if Table_Card[self.id] then
      self.cardCell.gameObject:SetActive(true)
      self.cardCell:SetData(ItemData.new("CardItem", self.id))
      self.icon.gameObject:SetActive(false)
    else
      self.cardCell.gameObject:SetActive(false)
      self.icon.gameObject:SetActive(true)
      IconManager:SetItemIcon(Table_Item[self.id].Icon, self.icon)
    end
    if data.minnum and data.maxnum then
      self.numLab.text = string.format("%s~%s", data.minnum, data.maxnum)
    else
      self.numLab.text = data.num and data.num > 1 and tostring(data.num) or ""
    end
    self:SetFirst(data.isFirst)
    self:SetGot(data.isGot)
  end
end

function TechTreeRewardCell:SetFirst(isFirst)
  self.first:SetActive(isFirst and true or false)
end

function TechTreeRewardCell:SetGot(got)
  self.got:SetActive(got and true or false)
end

function TechTreeRewardCell:HandleDragScroll(dragComp)
  UIUtil.HandleDragScrollForObj(self.gameObject, dragComp)
end

function TechTreeRewardCell:SetRefreshLabel(endStamp)
  if endStamp then
    self.timeLabel.gameObject:SetActive(true)
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, function(owner, deltaTime)
      local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(endStamp)
      if 0 < leftDay then
        leftHour = leftHour + leftDay * 24
      end
      self.timeLabel.text = string.format("%02d:%02d", leftHour, leftMin)
    end, self, 1)
  else
    self.timeLabel.gameObject:SetActive(false)
  end
end

function TechTreeRewardCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
  self.cardCell = nil
end
