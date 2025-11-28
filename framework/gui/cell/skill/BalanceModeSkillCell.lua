local BaseCell = autoImport("BaseCell")
BalanceModeSkillCell = class("BalanceModeSkillCell", BaseCell)
local vector3 = LuaVector3.Zero()

function BalanceModeSkillCell:Init()
  self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
  self.nameBg = self:FindGO("NameBg"):GetComponent(UIMultiSprite)
  self.skillIcon = self:FindGO("SkillIcon"):GetComponent(UISprite)
  self.qualityBg = self:FindGO("CircleBg"):GetComponent(UISprite)
  self.clickCell = self:FindGO("SkillBg")
  self.dragDrop = DragDropCell.new(self.clickCell:GetComponent(UIDragItem), 0.1)
  self.dragDrop.dragDropComponent.data = self
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell_NoQuality
  self:SetEvent(self.clickCell, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:SetDoubleClick(self.clickCell, function()
    self:PassEvent(MouseEvent.DoubleClick, self)
  end)
  
  function self.dragDrop.dragDropComponent.OnStart(data)
    GameFacade.Instance:sendNotification(DragDropEvent.StartDrag, self)
  end
  
  function self.dragDrop.onManualEndDrag()
    GameFacade.Instance:sendNotification(DragDropEvent.EndDrag, self)
  end
  
  self.circleBg = self:FindGO("CircleBg")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.circleBg:SetActive(true)
  self.skillIcon.width = 60
  self.skillIcon.height = 60
  self.nameBg.CurrentState = 1
  LuaVector3.Better_Set(vector3, 67, 0, 0)
  self.nameBg.transform.localPosition = vector3
  self.nameBg.width = 186
  self:UpdateDragable()
end

function BalanceModeSkillCell:SetData(data)
  self.data = data
  self.type = data and data.type
  self.isArtifact = data and data.isArtifact
  self.id = data and data.id
  self.staticData = self.id and Table_Item[self.id]
  local itemData
  if self.type == 1 or self.type == 2 then
    local equipExtraceionInfo = Table_EquipExtraction[self.id]
    if equipExtraceionInfo then
      local staticData = self.id and Table_Item[self.id]
      IconManager:SetItemIcon(staticData.Icon, self.skillIcon)
      self.skillName.text = staticData.NameZh
    end
    itemData = ItemData.new("DragItem", self.id)
  elseif self.isArtifact ~= nil then
    local artifactData = Table_PersonalArtifactCompose[self.id]
    if artifactData then
      local staticData = self.id and Table_Item[self.id]
      IconManager:SetItemIcon(staticData.Icon, self.skillIcon)
      self.skillName.text = staticData.NameZh
    end
    itemData = ItemData.new("DragItem", self.id)
  elseif self.data.isMemory ~= nil then
    local memoryStaticData = Table_ItemMemoryEffect[self.id]
    self.skillName.text = memoryStaticData and memoryStaticData.PreviewDesc or ""
    local groupType = self.data.groupType
    local itemID
    if self.data.isUpgradeMemory then
      itemID = EquipMemoryProxy.PosEnumUpgradeItemID[groupType]
    else
      itemID = EquipMemoryProxy.PosEnumItemID[groupType]
    end
    local staticData = Table_Item[itemID]
    if staticData then
      IconManager:SetItemIcon(staticData and staticData.Icon, self.skillIcon)
      itemData = ItemData.new("DragItem", itemID)
      itemData.hideMemoryCorner = true
      self:SetQualityBg(staticData.Quality)
    end
  end
  local isChoose = data.isChoose or false
  self.chooseSymbol:SetActive(isChoose)
  self.dragDrop.dragDropComponent.data.itemdata = itemData
end

function BalanceModeSkillCell:SetQualityBg(quality)
  if quality == 1 then
    local spName = "com_icon_bottom3"
    self.qualityBg.atlas = RO.AtlasMap.GetAtlas("NewCom")
    self.qualityBg.spriteName = spName
  else
    self.qualityBg.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    if quality == 2 then
      self.qualityBg.spriteName = "refine_bg_green"
    elseif quality == 3 then
      self.qualityBg.spriteName = "refine_bg_blue"
    elseif quality == 4 then
      self.qualityBg.spriteName = "refine_bg_purple"
    elseif quality == 5 then
      self.qualityBg.spriteName = "refine_bg_orange"
    elseif quality == 6 then
      self.qualityBg.spriteName = "refine_bg_red"
    end
  end
end

function BalanceModeSkillCell:UpdateDragable()
  self.dragDrop:SetDragEnable(true)
end

function BalanceModeSkillCell:GetSimulateSkillItemData()
  return self.data
end
