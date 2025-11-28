autoImport("ItemCell")
AdventrueResearchItemCell = class("AdventrueResearchItemCell", ItemCell)

function AdventrueResearchItemCell:Init()
  self:AddCellClickEvent()
  self.unlockCt = self:FindGO("unlockCt")
  self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
  self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
  AdventrueResearchItemCell.super.Init(self)
  local longPress = self.gameObject:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:PassEvent(MouseEvent.LongPress, self)
    end
  end
end

function AdventrueResearchItemCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.BagChooseSymbol:SetActive(true)
    else
      self.BagChooseSymbol:SetActive(false)
    end
  end
end

function AdventrueResearchItemCell:SetEvent(evtObj, event, hideSound)
  local hideType = {hideClickSound = true, hideClickEffect = true}
  self:AddClickEvent(evtObj, event, hideType)
end

function AdventrueResearchItemCell:SetData(data)
  self.data = data
  AdventrueResearchItemCell.super.SetData(self, data)
  self.invalid:SetActive(false)
  self:setIsSelected(false)
  if not data then
    self.unlockCt:SetActive(false)
    return
  end
  self:setIsSelected(data.isSelected)
  self.status = true
  if data.type == SceneManual_pb.EMANUALTYPE_EQUIP then
    self.status = AdventureDataProxy.Instance:checkEquipIsUnlock(self.data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or data.type == SceneManual_pb.EMANUALTYPE_ITEM then
    self.status = AdventureDataProxy.Instance:checkShopItemIsUnlock(self.data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_MATE then
    if data.staticData.Icon and data.staticData.Icon ~= "" then
      self:Show(self.icon.gameObject)
      local sus = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
      if not sus then
        IconManager:SetFaceIcon("boli", self.icon)
      end
      self.icon:MakePixelPerfect()
    else
      self:Hide(self.icon.gameObject)
    end
    self.status = AdventureDataProxy.Instance:checkMercenaryCatIsUnlock(self.data:getCatId())
  end
  self:setItemIsLock()
end

function AdventrueResearchItemCell:setItemIsLock()
  if self.status then
    self.unlockCt:SetActive(false)
  else
    self.unlockCt:SetActive(true)
  end
end

function AdventrueResearchItemCell:SetScale(scale)
  if scale then
    self.itemObj.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  end
end

function AdventrueResearchItemCell:SetActiveSymbol(active)
end

function AdventrueResearchItemCell:SetQuestIcon(itemType)
end

function AdventrueResearchItemCell:SetShopCorner(itemType)
end

function AdventrueResearchItemCell:SetPetFlag(itemType)
end

function AdventrueResearchItemCell:SetUseItemInvalid(data)
end

function AdventrueResearchItemCell:SetInvalid(b)
end

function AdventrueResearchItemCell:SetLimitTimeCorner(data)
end

function AdventrueResearchItemCell:UpdateNumLabel(scount, x, y, z)
end

function AdventrueResearchItemCell:UpdateRefineLevel(refinelv, withBuff)
end
