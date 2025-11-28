local baseCell = autoImport("BaseCell")
AdventureEquipComposeTreeCell = class("AdventureEquipComposeTreeCell", baseCell)
autoImport("AdventrueResearchItemCell")

function AdventureEquipComposeTreeCell:Init()
  self:InitView()
end

function AdventureEquipComposeTreeCell:InitView()
  self.step2GO = self:FindGO("Step2")
  local step2Obj = self:LoadPreferb("cell/AdventrueResearchItemCell", self.step2GO)
  self.step2Cell = AdventrueResearchItemCell.new(step2Obj)
  self.step2Cell:AddEventListener(MouseEvent.MouseClick, self.handleClickCell, self)
  self.step2Cell:AddEventListener(MouseEvent.LongPress, self.handleLongPress, self)
  local longPress = self.step2Cell.gameObject:GetComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:PassEvent(MouseEvent.LongPress, self.step2Cell)
    end
  end
  
  self.step2Line = self:FindGO("Line", self.step2GO):GetComponent(UISprite)
  self.step1GO = self:FindGO("Step1")
  self.step1ItemContainer = self:FindGO("Step1Item", self.step1GO)
  local step1Obj = self:LoadPreferb("cell/AdventrueResearchItemCell", self.step1GO)
  self.step1Cell = AdventrueResearchItemCell.new(step1Obj)
  self.step1Cell:AddEventListener(MouseEvent.MouseClick, self.handleClickCell, self)
  longPress = self.step1Cell.gameObject:GetComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:PassEvent(MouseEvent.LongPress, self.step1Cell)
    end
  end
  
  self.step1Line = self:FindGO("Line", self.step1GO):GetComponent(UISprite)
end

function AdventureEquipComposeTreeCell:SetData(data)
  self.step2Cell:SetData(data)
  local hasStep1Equip = false
  local targetItemData
  local srdIDs, srcType = BagProxy.GetSurceEquipIds(data.staticData.id)
  if srdIDs and 0 < #srdIDs then
    for i = 1, #srdIDs do
      local newSrdIDs, newSrcType = BagProxy.GetSurceEquipIds(srdIDs[i])
      if newSrcType == 2 then
        local targetItemId = math.min(unpack(newSrdIDs))
        targetItemData = ItemData.new("UpgradeSource", targetItemId)
        hasStep1Equip = true
        break
      end
    end
  end
  self.step1GO:SetActive(hasStep1Equip)
  self.step2ItemData = data
  if hasStep1Equip then
    self.step1ItemData = targetItemData
    self.step1Cell:SetData(targetItemData)
  end
  if self.indexInList and 1 < self.indexInList then
    self.step2Cell:SetScale(0.85)
    self.step1Cell:SetScale(0.85)
    self.step2Line.height = 3
    self.step1Line.height = 3
  else
    self.step2Cell:SetScale(1)
    self.step1Cell:SetScale(1)
    self.step2Line.height = 4
    self.step1Line.height = 4
  end
end

function AdventureEquipComposeTreeCell:handleClickCell(cellCtrl)
  xdlog("点击合成树内容")
  local data = cellCtrl.data
  self:PassEvent(MouseEvent.MouseClick, cellCtrl)
end

function AdventureEquipComposeTreeCell:handleLongPress(cellCtrl)
  self:PassEvent(MouseEvent.LongPress, cellCtrl)
end

function AdventureEquipComposeTreeCell:OnCellDestroy()
  AdventureEquipComposeTreeCell.super.OnCellDestroy(self)
  if self.step2Cell then
    GameObject.DestroyImmediate(self.step2Cell.gameObject)
    self.step2Cell = nil
  end
  if self.step1Cell then
    GameObject.DestroyImmediate(self.step1Cell.gameObject)
    self.step1Cell = nil
  end
end

function AdventureEquipComposeTreeCell:UpdateItemGrey()
  if self.step2ItemData then
    self.step2Cell:SetIconlocked(BagProxy.Instance:GetItemNumByStaticID(self.step2ItemData.staticData.id) == 0)
  end
  if self.step1ItemData then
    self.step1Cell:SetIconlocked(BagProxy.Instance:GetItemNumByStaticID(self.step1ItemData.staticData.id) == 0)
  end
end
