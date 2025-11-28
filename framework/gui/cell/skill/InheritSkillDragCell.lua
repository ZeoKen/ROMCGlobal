autoImport("DragDropCell")
InheritSkillDragCell = class("InheritSkillDragCell", BaseCell)
InheritSkillDragCell.Empty = "InheritSkillDragCell_Empty"

function InheritSkillDragCell:Init()
  self:FindObjs()
end

function InheritSkillDragCell:FindObjs()
  self.icon = self:FindComponent("Icon", UISprite)
  self.skillLevel = self:FindComponent("SkillLevel", UILabel)
  self.bg = self:FindGO("Bg")
  self.costBg = self:FindGO("CostBg")
  self.costLabel = self:FindComponent("Cost", UILabel)
  local dragItem = self.gameObject:GetComponent(UIDragItem)
  self.dragDrop = DragDropCell.new(dragItem, 0.01)
  self.dragDrop.dragDropComponent.data = self
  
  function self.dragDrop.dragDropComponent.OnReplace(obj)
    if obj ~= nil then
      self:PlayUISound(AudioMap.UI.SkillBookPlace)
      self:DispatchEvent(DragDropEvent.SwapObj, {source = obj, target = self})
    end
  end
  
  function self.dragDrop.dragDropComponent.OnDropEmpty(obj)
    if obj.type == UIDragItem.DragDropType.Target or obj.type == UIDragItem.DragDropType.Both then
      self:DispatchEvent(DragDropEvent.DropEmpty, self)
    end
  end
  
  function self.dragDrop.dragDropComponent.GetObserved()
    return self
  end
  
  self:AddClickEvent(self.gameObject, function()
    self:OnCellClick()
  end)
end

function InheritSkillDragCell:SetData(data)
  self.data = data
  if data and data ~= InheritSkillDragCell.Empty then
    IconManager:SetSkillIconByProfess(data.staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
    self.skillLevel.text = data.level > 0 and string.format("Lv.%s", data.level) or ""
    self.bg:SetActive(false)
    self.costBg:SetActive(true)
    self.costLabel.text = data:GetCostPoint()
    self:UpdateDragable(true)
  else
    self.icon.spriteName = nil
    self.skillLevel.text = ""
    self.bg:SetActive(true)
    self.costBg:SetActive(false)
    self:UpdateDragable(false)
  end
end

function InheritSkillDragCell:UpdateDragable(dragable)
  self.dragDrop:SetDragEnable(dragable)
end

function InheritSkillDragCell:OnCellDestroy()
  if self.dragDrop then
    self.dragDrop:OnDestroy()
    TableUtility.TableClear(self.dragDrop)
    self.dragDrop = nil
  end
end

function InheritSkillDragCell:OnCellClick()
  if self.data and self.data ~= InheritSkillDragCell.Empty then
    self:PassEvent(MouseEvent.MouseClick, self)
  end
end
