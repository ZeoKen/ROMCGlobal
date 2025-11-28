autoImport("MaterialItemCell")
TechTreeLeafCommonTip = class("TechTreeLeafCommonTip", CoreView)
TechTreeLeafCommonTipFuncState = {
  Inaccessible = 0,
  Unlock = 1,
  UnlockAndMake = 2,
  Upgrade = 3
}
local proxyIns

function TechTreeLeafCommonTip:ctor(obj, tipStick)
  TechTreeLeafCommonTip.super.ctor(self, obj)
  self.tipStick = tipStick
  if not proxyIns then
    proxyIns = TechTreeProxy.Instance
  end
  self:FindObjs()
  self:AddEvents()
  self:InitTip()
  self:RegisterGuide()
end

function TechTreeLeafCommonTip:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  local itemGO = self:FindGO("Item")
  self.iconSp = self:FindComponent("Sprite", UISprite, itemGO)
  self.iconLabel = self:FindComponent("Label", UILabel, itemGO)
  self.iconLabel2 = self:FindComponent("Label2", UILabel, itemGO)
  self.desc = self:FindComponent("Desc", UILabel)
  self.matParent = self:FindGO("Materials")
  self.matTitle = self:FindComponent("Label", UILabel, self.matParent)
  self.matGrid = self:FindComponent("Grid", UIGrid, self.matParent)
  self.funcBtn = self:FindGO("FuncBtn")
  self.funcBtnBg = self:FindComponent("Background", UIMultiSprite, self.funcBtn)
  self.funcBtnLabel = self:FindComponent("Label", UILabel, self.funcBtn)
  self.tipCloseBtn = self:FindGO("TipCloseBtn")
end

function TechTreeLeafCommonTip:AddEvents()
  self:AddClickEvent(self.funcBtn, function()
    if self.tipFunc then
      self:tipFunc()
    end
  end)
  if self.tipCloseBtn then
    self:AddClickEvent(self.tipCloseBtn, function()
      self:Hide()
    end)
  end
end

function TechTreeLeafCommonTip:InitTip()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.materials = {}
  self.matCtrl = UIGridListCtrl.new(self.matGrid, MaterialItemCell, "MaterialItemCell")
  self.matCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
end

function TechTreeLeafCommonTip:SetData(leafId, treeId)
  if not proxyIns:CheckLeafIdValid(leafId) then
    self.leafId = nil
    self.level = nil
    return
  end
  self.treeId = treeId
  self.leafId = leafId
  self.level = proxyIns:GetCurLevelOfLeaf(self.leafId)
  self:SetIconAndName()
  self:SetDesc()
  self:SetMaterials()
  self:SetFunc()
end

function TechTreeLeafCommonTip:SetIconAndName()
  proxyIns:TrySetLeafIcon(self.leafId, self.iconSp)
  self.iconLabel.text = proxyIns:GetNameOfLeaf(self.leafId, self.level)
  self.iconLabel2.text = self.level and string.format(ZhString.TechTree_LeafLevelFormat, self.level) or ""
end

function TechTreeLeafCommonTip:SetDesc()
  self.desc.text = proxyIns:GetDescOfLeaf(self.leafId, self.level, self.treeId) or ""
end

function TechTreeLeafCommonTip:SetMaterials()
  proxyIns:GetUnlockItemsOfLeaf(self.leafId, self:GetUnlockTargetLevel(), self.materials)
  local hasMat = next(self.materials) ~= nil
  self.matParent:SetActive(hasMat)
  self.bg.bottomAnchor.absolute = hasMat and -301 or -150
  if hasMat then
    self.matCtrl:ResetDatas(self.materials)
    self.matGrid.repositionNow = true
  end
end

function TechTreeLeafCommonTip:SetFunc()
  self.matTitle.text = ZhString.TechTree_CommonTipUnlockMaterialTitle
  local state
  if proxyIns:IsLeafUnlocked(self.leafId, self.treeId) then
    if self.level then
      local maxLevel = proxyIns:GetMaxLevelOfLeaf(self.leafId)
      if maxLevel <= self.level then
        state = TechTreeLeafCommonTipFuncState.Inaccessible
        self.funcBtnLabel.text = ZhString.TechTree_CommonTipUpgraded
      else
        local upgradeable = proxyIns:IsLeafUpgradeable(self.leafId)
        state = upgradeable and TechTreeLeafCommonTipFuncState.Upgrade or TechTreeLeafCommonTipFuncState.Inaccessible
        self.funcBtnLabel.text = ZhString.TechTree_CommonTipUpgrade
      end
      self.matTitle.text = ZhString.TechTree_CommonTipUpgradeMaterialTitle
    else
      state = TechTreeLeafCommonTipFuncState.Inaccessible
      self.funcBtnLabel.text = ZhString.TechTree_CommonTipUnlocked
    end
  else
    local isToy = proxyIns:IsToyLeaf(self.leafId)
    if proxyIns:IsLeafAvailable(self.leafId, self.treeId) then
      state = isToy and TechTreeLeafCommonTipFuncState.UnlockAndMake or TechTreeLeafCommonTipFuncState.Unlock
    else
      state = TechTreeLeafCommonTipFuncState.Inaccessible
    end
    self.funcBtnLabel.text = isToy and ZhString.TechTree_CommonTipToyLocked or ZhString.TechTree_CommonTipLocked
  end
  self:SetFuncBtnState(state)
end

local funcBtnLabelEffectColorMap = {
  [0] = ColorUtil.NGUIGray,
  [1] = ColorUtil.ButtonLabelGreen,
  [2] = ColorUtil.ButtonLabelOrange,
  [3] = ColorUtil.ButtonLabelBlue
}

function TechTreeLeafCommonTip:SetFuncBtnState(state)
  state = state or TechTreeLeafCommonTipFuncState.Inaccessible
  self.funcBtnBg.CurrentState = state
  self.funcBtnLabel.effectColor = funcBtnLabelEffectColorMap[state]
  self.tipFunc = state ~= TechTreeLeafCommonTipFuncState.Inaccessible and self.Unlock or nil
end

function TechTreeLeafCommonTip:SetTipCloseBtnActive(isActive)
  if not self.tipCloseBtn then
    return
  end
  isActive = isActive and true or false
  self.tipCloseBtn:SetActive(isActive)
end

local itemTipOffset = {-210, -30}

function TechTreeLeafCommonTip:OnMouseClick(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, nil, itemTipOffset)
  end
end

function TechTreeLeafCommonTip:OnItemUpdate()
  self:SetMaterials()
  self:SetFunc()
end

function TechTreeLeafCommonTip:OnLeafUnlock()
  if proxyIns:IsLeafUnlocked(self.leafId, self.treeId) then
    local level = proxyIns:GetCurLevelOfLeaf(self.leafId)
    if level then
      local maxLevel = proxyIns:GetMaxLevelOfLeaf(self.leafId)
      if level >= maxLevel then
        self:Hide()
        return
      end
    else
      self:Hide()
      return
    end
  end
  self:SetData(self.leafId, self.treeId)
end

function TechTreeLeafCommonTip:Unlock()
  TechTreeProxy.CallUnlockLeaf(self.leafId, self:GetUnlockTargetLevel(), self.treeId)
end

function TechTreeLeafCommonTip:GetUnlockTargetLevel()
  return (self.level or 0) + 1
end

function TechTreeLeafCommonTip:RegisterGuide()
  self:AddOrRemoveGuideId(self.funcBtn, 506)
end

function TechTreeLeafCommonTip:OnExit()
  if self.matCtrl then
    self.matCtrl:Destroy()
  end
end
