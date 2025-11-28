autoImport("ItemCell")
DragCursorPanel = class("DragCursorPanel", BaseView)
DragCursorPanel.ViewType = UIViewType.DragLayer
DragCursorPanel.Instance = nil

function DragCursorPanel:Init()
  DragCursorPanel.Instance = self
  self.cursorContainer = UICursorWithTween.Instance.gameObject
  self.cell = nil
end

function DragCursorPanel:GetCell(cellClass, cellPrefab)
  if self.cell == nil or self.cell.class ~= cellClass then
    if not cellPrefab then
      return
    end
    local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPrefab), self.cursorContainer)
    local cell = cellClass.new(cellpfb)
    self.cell = cell
  end
  return self.cell
end

function DragCursorPanel.ShowItemCell(dragitem)
  local cell = DragCursorPanel.Instance:GetCell(ItemCell, "ItemCell")
  local itemData = dragitem.data.itemdata
  cell:SetData(itemData)
  UICursorWithTween.SetGameObject(cell.gameObject)
end

function DragCursorPanel.ShowItemCell_NoQuality(dragitem)
  local cell = DragCursorPanel.Instance:GetCell(ItemCell, "ItemCell")
  local itemData = dragitem.data.itemdata
  
  function cell.SetPic()
  end
  
  function cell.UpdateCardSlot()
  end
  
  cell:SetData(itemData)
  UICursorWithTween.SetGameObject(cell.gameObject)
end

function DragCursorPanel.ShowGemCell(dragitem)
  local itemData = dragitem.data
  if itemData.gemAttrData and itemData.gemAttrData.available == false or itemData.gemSkillData and itemData.gemSkillData.available == false then
    return
  end
  local cell = DragCursorPanel.Instance:GetCell(GemCell, "GemCell")
  cell:HideNum()
  cell:SetShowNewTag(false)
  cell:SetShowEmbeddedTip(false)
  cell:SetShowToUpgradeTip(false)
  cell:SetShowFavoriteTip(false)
  cell:SetData(itemData)
  cell:TryDestroyCollider()
  cell.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 1)
  UICursorWithTween.SetGameObject(cell.gameObject)
end

function DragCursorPanel.ShowEmojiCell(dragitem)
  local cell = DragCursorPanel.Instance:GetCell(UIEmojiCell, "UIEmojiCell")
  cell:SetData(dragitem.data)
  cell:SetEditMode(UIEmojiEditMode.None)
  cell:TryDestroyCollider()
  UICursorWithTween.SetGameObject(cell.gameObject)
end

function DragCursorPanel.JustShowIcon(dragitem)
  if not dragitem.icon then
    return
  end
  UICursorWithTween.Set(dragitem.icon.atlas, dragitem.icon.spriteName)
end

function DragCursorPanel.ShowSaveNewCell(dragitem)
  local cell = DragCursorPanel.Instance:GetCell(SaveNewCell, "SaveNewCell")
  cell:SetData(dragitem.data)
  cell.line:SetActive(false)
  cell.selectCover.gameObject:SetActive(false)
  cell.gameObject:GetComponent(BoxCollider).enabled = false
  cell.ddGo:GetComponent(BoxCollider).enabled = false
  UICursorWithTween.SetGameObject(cell.gameObject)
  cell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(100, 0, 0)
end
