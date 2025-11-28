local BaseCell = autoImport("BaseCell")
RecommendEquipCellForER = class("RecommendEquipCellForER", BaseCell)
autoImport("SetQuickItemCell")

function RecommendEquipCellForER:Init()
  self:FindObjs()
  self:AddCellClickEvent()
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell
  self.dragDrop:SetDragEnable(true)
  
  function self.dragDrop.dragDropComponent.OnReplace(data)
    if data then
      if not data.itemdata then
        LogUtility.Error(string.format("[%s] OnReplace() Error : data.itemData == nil!", self.__cname))
        return nil
      end
      if not data.itemdata.equipInfo then
        LogUtility.Error(string.format("[%s] OnReplace() Error : data.itemData.equipInfo == nil! id = %s", self.__cname, tostring(itemData.staticData.id)))
        return nil
      end
      if not data.itemdata.equipInfo.equipData then
        LogUtility.Error(string.format("[%s] OnReplace() Error : data.itemData.equipInfo.equipData == nil! id = %s", self.__cname, tostring(itemData.staticData.id)))
        return nil
      end
      if not EquipRecommendMainNew.Instance:CheckoutTargetSlotByType(self.pos, data.itemdata.equipInfo.equipData.EquipType) then
        return nil
      end
      self:PassEvent(SetQuickItemCell.SwapObj, {surce = data, target = self})
    end
  end
  
  function self.dragDrop.dragDropComponent.OnDropEmpty(data)
    self:RemoveQuickItem()
  end
  
  self.remove = self:FindGO("Remove")
  self:AddClickEvent(self.remove, function(go)
    self:RemoveQuickItem()
  end)
  self.Root_UIDragScrollView = self.gameObject:GetComponent(UIDragScrollView)
  self:Select(false)
end

function RecommendEquipCellForER:CanDrag(value)
  self.dragDrop:SetDragEnable(value)
end

function RecommendEquipCellForER:RemoveUIDragScrollView()
  self.Root_UIDragScrollView.enabled = false
end

function RecommendEquipCellForER:SetQuickPos(pos)
  self.pos = pos
  if self.data then
    self.dragDrop.dragDropComponent.data = {
      itemdata = self.data,
      pos = self.pos
    }
    self.remove:SetActive(false)
  else
    self.remove:SetActive(false)
  end
end

function RecommendEquipCellForER:RemoveQuickItem()
  local data = self.data
  if data and self.pos then
    local key = {
      guid = nil,
      type = nil,
      pos = self.pos - 1
    }
  end
end

function RecommendEquipCellForER:FindObjs()
  self.item = self:FindGO("ItemCell")
  self.itemCell = ItemCell.new(self.item)
  self.select = self:FindGO("Select")
end

function RecommendEquipCellForER:GetEquipId()
  if self.data then
    return self.data.staticData.id
  else
    return nil
  end
end

function RecommendEquipCellForER:SetData(data)
  RecommendEquipCellForER.super.SetData(self, data)
  self.data = data
  self.itemCell:SetData(data)
  if data then
    self.dragDrop.dragDropComponent.data = {
      itemdata = data,
      pos = self.pos
    }
    self.remove:SetActive(false)
  else
    self.remove:SetActive(false)
  end
end

function RecommendEquipCellForER:SetPosition(pos)
  self.gameObject.transform.position = pos
end

function RecommendEquipCellForER:Select(isSelect)
  self.select:SetActive(isSelect)
end
