local BaseCell = autoImport("BaseCell")
GemPageAttributeCell = class("GemPageAttributeCell", BaseCell)
local manualEndDragReplaceInterval = 400

function GemPageAttributeCell:ctor(go, id, pageData)
  self.id = id
  self.pageData = pageData
  GemPageAttributeCell.super.ctor(self, go)
end

function GemPageAttributeCell:Init()
  self.iconSp = self:FindComponent("Icon", UISprite)
  self.frameSp = self:FindComponent("Frame", UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.unavailableGO = self:FindGO("Unavailable")
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self:SetDragEnable(true)
  local ddComp = self.dragDrop.dragDropComponent
  ddComp.OnCursor = DragCursorPanel.ShowGemCell
  
  function ddComp.OnReplace(data)
    if not self:GetDragEnable() then
      return
    end
    if not GemEmbedPage.ManualEndDragTime then
      return
    end
    if GemEmbedPage.GetNowManualEndDragInterval() > manualEndDragReplaceInterval then
      GemEmbedPage.ClearManualEndDragTime()
      return
    end
    if not self:CheckIsDataValid(data) then
      self:TryRemoveIncoming(data)
      return
    end
    if self.data and self.data.id == data.id then
      return
    end
    if not GemProxy.Instance:CheckIfCanReplaceSameName(data, self.id) then
      MsgManager.ShowMsgByID(36006)
      return
    end
    self:TryEmbed(data)
  end
  
  function ddComp.OnDropEmpty(dragItem)
    if not self:GetDragEnable() then
      return
    end
    dragItem:StopDrag()
    self:TryRemoveSelf()
  end
  
  function self.dragDrop.onManualStartDrag()
    self:PassEvent(ItemEvent.GemDragStart, self)
  end
  
  function self.dragDrop.onManualEndDrag()
    self:PassEvent(ItemEvent.GemDragEnd, self)
    GemEmbedPage.RecordManualEndDragTime()
  end
  
  self.neighborIds = GemProxy.Instance.gemPageAttributeCellNeighborMap[self.id]
  self:AddClickEvent(self.gameObject, function()
    if not self.available then
      MsgManager.FloatMsg(nil, ZhString.Gem_PageCellUnavailableTip)
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GemPageAttributeCell:SetData(data)
  self.data = data
  self.iconSp.gameObject:SetActive(data ~= nil)
  self.chooseSymbol:SetActive(GemProxy.Instance.choosePageCellID == self.id)
  self:UpdateLevel()
  self:UpdateName()
  self:UpdateAvailability()
  self:UpdateFrame()
  if data and type(data) == "table" then
    local staticItemData = Table_Item[data.staticData.id]
    if not staticItemData then
      LogUtility.WarningFormat("Cannot find static item data of gem whose staticId = {0}", data.staticData.id)
      return
    end
    if IconManager:SetItemIcon(staticItemData.Icon, self.iconSp) then
      self.iconSp:MakePixelPerfect()
      local scale = data.secretLandDatas and 0.6 or 0.8
      self.iconSp.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, 1)
    end
  else
    self:DestroyAllEffects()
  end
  self.dragDrop.dragDropComponent.data = BagItemCell.CheckData(data) and data or nil
end

function GemPageAttributeCell:SetChoose(isChosen)
  isChosen = isChosen and true or false
  self.chooseSymbol:SetActive(isChosen)
end

function GemPageAttributeCell:UpdateLevel()
  if not self.levelLabel then
    return
  end
  local attrData = self.data and self.data.gemAttrData
  self.levelLabel.gameObject:SetActive(attrData ~= nil)
  if attrData then
    self.levelLabel.text = attrData.lv
  end
end

function GemPageAttributeCell:SetShowName(isShow)
  self.isShowName = isShow and true or false
  self:UpdateName()
end

function GemPageAttributeCell:UpdateName()
  if self.isShowName then
    local sData = self.data and self.data.staticData
    local str = sData and string.gsub(sData.NameZh, ZhString.Gem_PageCellNameSuffix, "") or ""
    if StringUtil.IsEmpty(str) then
      self.isShowName = false
    else
      self.nameLabel.text = str
    end
  end
  self.nameLabel.gameObject:SetActive(self.isShowName or false)
end

function GemPageAttributeCell:UpdateAvailability()
  self:SetAvailable(true)
end

function GemPageAttributeCell:SetAvailable(isAvailable)
  self.available = isAvailable and true or false
  if self.unavailableGO then
    self.unavailableGO:SetActive(not self.available)
  end
  self:SetDragEnable(self.available)
  if self.available then
    self:DestroyUnavailableEffect()
  else
    self:PlayUnavailableEffect()
  end
end

function GemPageAttributeCell:UpdateFrame()
  self:SetFrameActive(self.data)
end

function GemPageAttributeCell:SetFrameActive(isActive)
  if not self.frameSp then
    return
  end
  isActive = isActive and true or false
  self.frameSp.gameObject:SetActive(isActive)
  if isActive then
    self.frameSp.color = self.available and ColorUtil.NGUIWhite or ColorUtil.TitleGray
  end
end

function GemPageAttributeCell:SetDragEnable(isEnable)
  isEnable = isEnable and true or false
  self.dragDrop:SetDragEnable(isEnable)
end

function GemPageAttributeCell:GetDragEnable()
  return self.dragDrop:GetDragEnable()
end

function GemPageAttributeCell:CheckIsDataValid(data)
  return GemProxy.CheckContainsGemAttrData(data)
end

function GemPageAttributeCell:TryEmbed(newData)
  GemProxy.CallEmbed(SceneItem_pb.EGEMTYPE_ATTR, newData.id, self.id)
end

function GemPageAttributeCell:TryRemoveSelf()
  if not self.data then
    return
  end
  GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_ATTR, self.data.id)
end

function GemPageAttributeCell:TryRemoveIncoming(data)
  if GemProxy.CheckContainsGemSkillData(data) then
    GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_SKILL, data.id)
  end
end

function GemPageAttributeCell:PlayEmbedSuccessEffect(container, ignoreAvailability)
  if self.embedEffect then
    self.embedEffect:Destroy()
  end
  if not ignoreAvailability and not self.available then
    return
  end
  self.embedEffect = self:PlayPageCellEffect(self:GetEmbedSuccessEffectId(), container, true)
end

function GemPageAttributeCell:PlaySkillValidEffect(container, forcePlay)
  if not GemProxy.allSkilGemActive and not forcePlay then
    self:DestroySkillValidEffect()
    return
  end
  if self.validEffect and not forcePlay then
    return
  end
  self:DestroySkillValidEffect()
  self.validEffect = self:PlayPageCellEffect(self:GetSkillValidEffectId(), container, true)
end

function GemPageAttributeCell:PlayUnavailableEffect(container)
  self:DestroyAllEffects()
  self.unavailableEffect = self:PlayPageCellEffect(self:GetUnavailableEffectId(), container)
end

function GemPageAttributeCell:DestroyEmbedSuccessEffect()
  if self.embedEffect then
    self.embedEffect:Destroy()
    self.embedEffect = nil
  end
end

function GemPageAttributeCell:DestroySkillValidEffect()
  if self.validEffect then
    self.validEffect:Destroy()
    self.validEffect = nil
  end
end

function GemPageAttributeCell:DestroyUnavailableEffect()
  if self.unavailableEffect then
    self.unavailableEffect:Destroy()
    self.unavailableEffect = nil
  end
end

function GemPageAttributeCell:PlayPageCellEffect(id, container, resetLocalPos, callBack)
  local effect = self:PlayUIEffect(id, container or self.gameObject)
  if effect and resetLocalPos then
    effect:ResetLocalPosition(self.trans.localPosition)
  end
  return effect
end

function GemPageAttributeCell:DestroyAllEffects()
  self:DestroyEmbedSuccessEffect()
  self:DestroySkillValidEffect()
  self:DestroyUnavailableEffect()
end

function GemPageAttributeCell:GetEmbedSuccessEffectId()
  return EffectMap.UI.GemAttrEmbed
end

function GemPageAttributeCell:GetSkillValidEffectId()
  return EffectMap.UI.GemAttrSkillValid
end

function GemPageAttributeCell:GetUnavailableEffectId()
  return EffectMap.UI.GemUnavailable
end
