autoImport("ItemCell")
GemCell = class("GemCell", ItemCell)
GemCell.MultiSelectStyle = {
  None = 0,
  ShowSelectedCount = 1,
  HideSelectedCount = 2
}
GemCell.SkillBgSpriteNames = {
  "levelB",
  "levelA",
  "levelS",
  "levelS"
}
GemCell.SkillBgSculptedSpriteNames = {
  "levelB+",
  "levelA+",
  "levelS+",
  "levelS+"
}
GemCell.AttrBgSpriteName = "levelD"
GemCell.SkillQualitySpriteNames = {
  "Rune_bg_icon_02b",
  "Rune_bg_icon_03a",
  "Rune_bg_icon_04s",
  "Rune_bg_icon_04s2"
}
local gemTipOffset, gemTipData = {}, {}

function GemCell:Init()
  GemCell.super.Init(self)
  self.bg = self:FindComponent("Background", UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.grey = self:FindGO("Grey")
  self.bagSlot = self:FindGO("BagSlot")
  self.emptyTip = self:FindGO("EmptyTip")
  self.spMask = self:FindComponent("Mask", UISprite)
  self.nameLabel = self:FindComponent("NameLabel", UILabel)
  self.gemLevel = self:FindGO("GemLevel")
  self.gemLevelLabel = self:FindComponent("GemLevelLabel", UILabel)
  self.gemQuality = self:FindComponent("GemQuality", UISprite)
  self.selectedGO = self:FindGO("Selected")
  self.selectedLabel = self:FindComponent("SelectedLabel", UILabel)
  self.selectedTick = self:FindGO("Tick", self.selectedGO)
  self.toUpgradeTip = self:FindGO("ToUpgradeTip")
  self.embeddedTip = self:FindGO("EmbeddedTip")
  self.deleteGO = self:FindGO("Delete")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.boxCollider = self.item.transform.parent.gameObject:GetComponent(BoxCollider)
  if self.selectedTick then
    self.selectedTickTrans = self.selectedTick.transform
  end
  self.starParent = self:FindGO("Stars")
  self.stars = {}
  for i = 1, 3 do
    self.stars[i] = self:FindComponent(tostring(i), UISprite, self.starParent)
  end
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
  self:AddCellLongPressEvent()
  self:AddCellDeleteIconClickEvent()
  self.isShowToUpgradeTip = false
  self.isShowEmbeddedTip = true
  self.isShowBagSlot = false
  self.isShowDeleteIcon = false
  self.isShowFavoriteTip = true
  self.isShowNewTag = true
  self.isShowNameLabel = true
  self.multiSelectStyle = GemCell.MultiSelectStyle.None
  self.selectedCount = 0
end

function GemCell:SetData(data)
  GemCell.super.SetData(self, data)
  self:UpdateBg()
  self:UpdateChoose()
  self:UpdateMultiSelect()
  self:UpdateNameLabel()
  self:UpdateGemLevel()
  self:UpdateGemQuality()
  self:UpdateStars()
  self:UpdateUpgradeTip()
  self:UpdateEmbeddedTip()
  self:UpdateClickDisabled()
  self:UpdateDeleteIcon()
  self:UpdateFavoriteTip()
  self:UpdateNewTag()
  if self.boxCollider then
    self.boxCollider.enabled = true
  end
end

function GemCell:SetClickDisablePredicate(disablePredicate, arg)
  if disablePredicate and type(disablePredicate) ~= "function" then
    LogUtility.Error("Invalid argument: disablePredicate")
    return
  end
  self.clickDisablePredicate = disablePredicate
  self.clickDisablePredicateArg = disablePredicate and arg
  self:UpdateClickDisabled()
end

function GemCell:SetMultiSelectStyle(style)
  style = style or 0
  self.multiSelectStyle = style
  self:UpdateMultiSelect()
end

function GemCell:SetChoose(curChooseId)
  self.curChooseId = curChooseId or 0
  self:UpdateChoose()
end

function GemCell:SetMultiSelectModel(selectedReference)
  if selectedReference and self.multiSelectStyle == GemCell.MultiSelectStyle.None then
    LogUtility.Warning("You're trying to do SetMultiSelectModel while the multiSelectStyle is None!")
  end
  self.selectedReference = selectedReference
  self:UpdateMultiSelect()
end

function GemCell:SetShowNameLabel(isShow)
  self.isShowNameLabel = isShow and true or false
  self:UpdateNameLabel()
end

function GemCell:SetShowToUpgradeTip(isShowTip)
  self.isShowToUpgradeTip = isShowTip and true or false
  self:UpdateUpgradeTip()
end

function GemCell:SetShowEmbeddedTip(isShowTip)
  self.isShowEmbeddedTip = isShowTip and true or false
  self:UpdateEmbeddedTip()
end

function GemCell:SetShowDeleteIcon(isShow)
  self.isShowDeleteIcon = isShow and true or false
  self:UpdateDeleteIcon()
end

function GemCell:SetShowBagSlot(isShow)
  self.isShowBagSlot = isShow and true or false
  self:UpdateBg()
end

function GemCell:SetShowFavoriteTip(isShow)
  self.isShowFavoriteTip = isShow and true or false
  self:UpdateFavoriteTip()
end

function GemCell:SetShowNewTag(isShow)
  self.isShowNewTag = isShow and true or false
  self:UpdateNewTag()
end

function GemCell:UpdateClickDisabled()
  self.isClickDisabled = self.clickDisablePredicate and self.clickDisablePredicate(self, self.clickDisablePredicateArg) or false
  local invalidFlag = false
  if self.data and GemProxy.Instance:CheckSecretLandTypeInvalid(self.data) and not GemProxy.Instance:IsEmbedded(self.data.id) and GemProxy.Instance:IsContainerViewOpen() then
    invalidFlag = true
  end
  self.cellInvalid = self.isClickDisabled or invalidFlag
  self.invalid:SetActive(self.cellInvalid)
end

function GemCell:UpdateBg()
  local quality = GemProxy.GetSkillQualityFromItemData(self.data)
  if quality then
    local spriteNames = GemProxy.CheckGemIsSculpted(self.data) and GemCell.SkillBgSculptedSpriteNames or GemCell.SkillBgSpriteNames
    IconManager:SetUIIcon(spriteNames[quality], self.bg)
  elseif GemProxy.CheckContainsGemAttrData(self.data) then
    IconManager:SetUIIcon(GemCell.AttrBgSpriteName, self.bg)
  else
    local newComAtlas = RO.AtlasMap.GetAtlas("NewCom")
    self.bg.atlas = newComAtlas
    self.bg.spriteName = "com_icon_bottom3"
  end
  self.bg:MakePixelPerfect()
  if self.emptyTip then
    self.emptyTip:SetActive(self.data == BagItemEmptyType.Empty)
  end
  if self.bagSlot then
    self.bagSlot:SetActive((self.isShowBagSlot or self.data) and true or false)
  end
  if self.grey then
    self.grey:SetActive(self.data == nil)
  end
end

function GemCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(self.curChooseId ~= nil and self.curChooseId ~= 0 and not self:CheckDataIsNilOrEmpty() and self.data.id == self.curChooseId)
end

function GemCell:UpdateMultiSelect()
  self:HideMask()
  if not self.selectedGO then
    return
  end
  self.selectedGO:SetActive(false)
  if self.multiSelectStyle == GemCell.MultiSelectStyle.None then
    return
  end
  self:SetSelectedCountWithSelectedDatas()
  if self.selectedCount > 0 then
    self:ShowMask()
    self.selectedGO:SetActive(true)
    local tempV3 = LuaGeometry.GetTempVector3(0, 0, 0)
    if self.multiSelectStyle == GemCell.MultiSelectStyle.ShowSelectedCount then
      self.selectedLabel.text = string.format(ZhString.Gem_SelectedCount, self.selectedCount)
      tempV3.y = 14
    elseif self.multiSelectStyle == GemCell.MultiSelectStyle.HideSelectedCount then
      self.selectedLabel.text = ""
    end
    self.selectedTickTrans.localPosition = tempV3
  else
    self:HideMask()
  end
end

function GemCell:UpdateNameLabel()
  if not self.nameLabel then
    return
  end
  if self:CheckDataIsNilOrEmpty() then
    self.nameLabel.text = ""
    return
  end
  self.nameLabel.text = GemProxy.GetSimpleGemName(self.data.staticData)
  self.nameLabel.gameObject:SetActive(self.isShowNameLabel)
end

function GemCell:UpdateNumLabel(scount, x, y, z)
  if GemProxy.CheckContainsGemSecretLandData(self.data) then
    return
  end
  x = x or 37.2
  y = y or -39
  z = z or 0
  GemCell.super.UpdateNumLabel(self, scount, x, y, z)
end

function GemCell:UpdateGemLevel()
  if not self.gemLevel then
    return
  end
  local data = self.data
  local lv = data and data.gemAttrData and data.gemAttrData.lv
  if not lv and data and data.secretLandDatas and data.secretLandDatas.unlock then
    lv = data.secretLandDatas.lv
  end
  local isActive = lv ~= nil and type(lv) == "number" and 1 <= lv
  self.gemLevel:SetActive(isActive)
  if isActive then
    self.gemLevelLabel.text = tostring(lv)
  end
end

function GemCell:UpdateGemQuality()
  if not self.gemQuality then
    return
  end
  local quality = GemProxy.GetSkillQualityFromItemData(self.data)
  self.gemQuality.gameObject:SetActive(quality ~= nil)
  if quality then
    self.gemQuality.spriteName = GemCell.SkillQualitySpriteNames[quality]
  end
end

function GemCell:UpdateStars()
  local isHide = self:CheckDataIsNilOrEmpty() or not GemProxy.CheckContainsGemSkillData(self.data)
  self.starParent:SetActive(not isHide)
  if isHide then
    return
  end
  local goldStarCount, silverStarCount = self.data.gemSkillData:GetStarCounts()
  for i = 1, 3 do
    self.stars[i].enabled = false
  end
  for i = 1, goldStarCount do
    self.stars[i].enabled = true
    IconManager:SetUIIcon("icon_40", self.stars[i])
  end
  for i = goldStarCount + 1, math.min(3, goldStarCount + silverStarCount) do
    self.stars[i].enabled = true
    IconManager:SetUIIcon("icon_41", self.stars[i])
  end
end

function GemCell:UpdateUpgradeTip()
  self.toUpgradeTip:SetActive(self.isShowToUpgradeTip and true)
end

function GemCell:UpdateEmbeddedTip()
  self.embeddedTip:SetActive(self.isShowEmbeddedTip and GemProxy.CheckIsEmbedded(self.data))
end

function GemCell:UpdateDeleteIcon()
  if not self.deleteGO then
    return
  end
  self.deleteGO:SetActive(self.isShowDeleteIcon and not self:CheckDataIsNilOrEmpty() and self.multiSelectStyle ~= GemCell.MultiSelectStyle.None and self.selectedCount and self.selectedCount > 0)
end

function GemCell:UpdateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self.favoriteTip:SetActive(not (not self.isShowFavoriteTip or self:CheckDataIsNilOrEmpty()) and GemProxy.CheckIsFavorite(self.data) or false)
end

function GemCell:UpdateNewTag()
  if not self.newTag then
    return
  end
  self.newTag:SetActive(self.isShowNewTag and not self:CheckDataIsNilOrEmpty() and self.data:IsNew() and not self.favoriteTip.activeSelf and not self.embeddedTip.activeSelf and not self.toUpgradeTip.activeSelf)
end

function GemCell:AddCellClickEvent()
  self:SetEvent(self.gameObject, function()
    if self.isClickDisabled then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GemCell:AddCellDoubleClickEvt()
  self:SetDoubleClick(self.gameObject, function()
    if self.isClickDisabled then
      return
    end
    self:PassEvent(MouseEvent.DoubleClick, self)
  end)
end

function GemCell:AddCellLongPressEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if not longPress then
    return
  end
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
end

function GemCell:AddCellDeleteIconClickEvent()
  self:SetEvent(self.deleteGO, function()
    if self.isClickDisabled then
      return
    end
    self:PassEvent(ItemEvent.GemDelete, self)
  end)
end

function GemCell:TryDestroyCollider()
  if not self.boxCollider then
    return
  end
  Component.Destroy(self.boxCollider)
  self.boxCollider = nil
  if not self.deleteGO then
    return
  end
  GameObject.Destroy(self.deleteGO)
  self.deleteGO = nil
end

function GemCell:SetSelectedCountWithSelectedDatas()
  self.selectedCount = 0
  if self.selectedReference and self.data then
    if type(self.selectedReference) ~= "table" then
      LogUtility.Error("SelectedReference is not table while setting selectedCount!")
      return
    end
    for _, sData in pairs(self.selectedReference) do
      if sData.id == self.data.id then
        self.selectedCount = sData.num + self.selectedCount
      end
    end
  end
end

function GemCell:ForceShowDeleteIcon()
  if not self.deleteGO then
    return
  end
  self.deleteGO:SetActive(true)
end

function GemCell:ForceHideDeleteIcon()
  if not self.deleteGO then
    return
  end
  self.deleteGO:SetActive(false)
end

function GemCell:ActiveNewTag()
  return
end

function GemCell:TryClearNewTag()
  if self:CheckDataIsNilOrEmpty() then
    return
  end
  if self.data.isNew == true then
    self.data.isNew = false
  end
  self:UpdateNewTag()
end

function GemCell:CheckDataIsNilOrEmpty()
  return not BagItemCell.CheckData(self.data)
end

function GemCell.ShowGemTip(cellGO, data, stick, side, offset, callback, isShowFuncBtns)
  if not data then
    TipManager.CloseTip()
    return
  end
  TableUtility.TableClear(gemTipData)
  gemTipData.itemdata = data
  gemTipData.callback = callback
  gemTipData.isShowFuncBtns = isShowFuncBtns or false
  return TipManager.Instance:ShowGemItemTip(gemTipData, stick, side or NGUIUtil.AnchorSide.Right, offset or GemCell.GetDefaultGemTipOffsetFromCell(cellGO))
end

function GemCell.GetDefaultGemTipOffsetFromCell(cellGO)
  gemTipOffset[1] = 0
  gemTipOffset[2] = 0
  if cellGO then
    local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, cellGO.transform, Space.World)
    if 0 < x then
      gemTipOffset[1] = -650
    else
      gemTipOffset[1] = 190
    end
  end
  return gemTipOffset
end
