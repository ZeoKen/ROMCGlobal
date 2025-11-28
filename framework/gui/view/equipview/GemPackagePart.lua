autoImport("BagItemCell")
autoImport("WrapListCtrl")
autoImport("GemCell")
GemPackagePart = class("GemPackagePart", CoreView)
local localPosCache = LuaVector3.Zero()
local isSortOrderDescending
local isNewPredicate = function(data)
  return data.IsNew and data:IsNew()
end
local skillGemComparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp2 ~= nil then
    return comp2
  end
  local comp3 = GemProxy.PredicateComparer(l, r, isNewPredicate)
  if comp3 ~= nil then
    return comp3
  end
  return GemProxy.BasicComparer(l, r)
end
local attrGemComparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp2 ~= nil then
    return comp2
  end
  local comp3 = GemProxy.PredicateComparer(l, r, isNewPredicate)
  if comp3 ~= nil then
    return comp3
  end
  return GemProxy.GetAttributeItemDataLevelComparer(isSortOrderDescending)(l, r)
end
local secretLandComparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp2 ~= nil then
    return comp2
  end
  local comp3 = GemProxy.PredicateComparer(l, r, isNewPredicate)
  if comp3 ~= nil then
    return comp3
  end
  return GemProxy.SecretLandComparer(l, r)
end

function GemPackagePart:ctor()
end

function GemPackagePart:CreateSelf(parent)
  if self.isInited == true then
    return
  end
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/GemPackagePart", parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
  self.isInited = true
end

function GemPackagePart:InitPart()
  GemProxy.Instance:InitSkillProfessionFilter()
  self:InitItemScroll()
  self:InitItemCtrls()
  self:InitTabs()
  self:InitFilterCtrls()
  local hideFunc = function()
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_GEM_ATTR)
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_GEM_SKILL)
    ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND)
    self:Hide()
  end
  self:AddButtonEvent("CloseButton", hideFunc)
  self:AddButtonEvent("ArrangeBtn", function()
    self:TryArrange()
  end)
  self.attributePanelCtrl = self:FindGO("AttributePanel")
  self.patternGO = self:FindGO("pattern3")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.arrangeBtn = self:FindGO("ArrangeBtn")
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.closeComp.callBack = hideFunc
end

function GemPackagePart:InitItemScroll()
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.panel = self.scrollView.panel
end

function GemPackagePart:InitItemCtrls()
  self.itemContainer = self:FindGO("ItemContainer")
  self.listCtrl = WrapListCtrl.new(self.itemContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 100, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.itemCells = self.listCtrl:GetCells()
end

function GemPackagePart:InitTabs()
  local tabParent = self:FindGO("Tabs")
  local sps = UIUtil.GetAllComponentsInChildren(tabParent, UISprite)
  for i = 1, #sps do
    sps[i]:MakePixelPerfect()
  end
  local lab1, lab2
  self.attributeTabObj = self:FindGO("SkillTab")
  self:AddClickEvent(self.attributeTabObj, function()
    self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_SKILL)
  end)
  self:initGemTabName(self.attributeTabObj, ZhString.Gem_Skill)
  self.skillTabObj = self:FindGO("AttributeTab")
  self:AddClickEvent(self.skillTabObj, function()
    self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_ATTR)
  end)
  self:initGemTabName(self.skillTabObj, ZhString.Gem_Attribute)
  self.secretAreaTabObj = self:FindGO("SecretAreaTab")
  if self.secretAreaTabObj then
    self:AddClickEvent(self.secretAreaTabObj, function()
      self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND)
    end)
    self:initGemTabName(self.secretAreaTabObj, ZhString.Gem_SecretLand)
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Gem.SecretlandGemMenuID) or GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND) then
    self.secretAreaTabObj:SetActive(false)
  end
  if GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_ATTR) then
    self.attributeTabObj:SetActive(false)
  end
  if GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SKILL) then
    self.skillTabObj:SetActive(false)
  end
end

function GemPackagePart:initGemTabName(parent, str)
  local lab1 = self:FindComponent("Label1", UILabel, parent)
  local lab2 = self:FindComponent("Label2", UILabel, parent)
  if not lab1 or not lab2 then
    return
  end
  lab1, lab2 = str, str
end

function GemPackagePart:UpdateSecretAreaTab()
  if not self.secretAreaTabObj then
    return
  end
end

function GemPackagePart:InitProfessionFilter()
  local obsoleteSkillProfessionFilterPop = self:FindGO("SkillProfessionFilterPop")
  if obsoleteSkillProfessionFilterPop then
    self:Hide(obsoleteSkillProfessionFilterPop)
  end
  self.professionTipStick = self:FindComponent("ProfessionTipStick", UIWidget)
  self.professionFilterLab = self:FindComponent("ProfessionFilterLab", UILabel)
  self.professionFilterLab.text = GemProxy.Instance:GetCurProfressionName()
  self:AddClickEvent(self.professionFilterLab.gameObject, function()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.professionTipStick)
  end)
end

function GemPackagePart:InitFavorToggle()
  self.favorToggle = self:FindComponent("FavorToggle", UIToggle, self.skillCtrl)
  self:AddClickEvent(self.favorToggle.gameObject, function()
    self:UpdatePage()
  end)
end

function GemPackagePart:InitSkillQualityFilter()
  local obsoleteSkillClassFilterPopObj = self:FindGO("SkillClassFilterPop")
  if obsoleteSkillClassFilterPopObj then
    self:Hide(obsoleteSkillClassFilterPopObj)
  end
  local qualityTabRoot = self:FindGO("SkillQualityTabRoot")
  self:Show(qualityTabRoot)
  for togName, tableData in pairs(GemProxy.QualityTogs) do
    self[togName] = self:FindGO(togName, qualityTabRoot)
    self[togName .. "lab1"] = self:FindComponent("Label1", UILabel, self[togName])
    self[togName .. "lab1"].text = tableData.value
    self[togName .. "lab2"] = self:FindComponent("Label2", UILabel, self[togName])
    self[togName .. "lab2"].text = tableData.value
    self:AddClickEvent(self[togName], function()
      local key = GemProxy.QualityTogs[togName].key
      if self.curSkillClassFilterPopData == key then
        return
      end
      self.curTog = self[togName]:GetComponent(UIToggle)
      self.curSkillClassFilterPopData = key
      self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_SKILL)
    end)
  end
end

function GemPackagePart:InitFilterCtrls()
  self.attributeCtrl = self:FindGO("AttributeCtrl")
  self.skillCtrl = self:FindGO("SkillCtrl")
  self.secretLandCtrl = self:FindGO("SecretLandCtrl")
  self.attributeLvSortOrderTrans = self:FindGO("SortOrder").transform
  isSortOrderDescending = true
  self:AddButtonEvent("AttributeLvSort", function()
    isSortOrderDescending = not isSortOrderDescending
    local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalEulerAngles(self.attributeLvSortOrderTrans))
    tempV3.z = (tempV3.z + 180) % 360
    self.attributeLvSortOrderTrans.localEulerAngles = tempV3
    self:UpdatePage()
  end)
  self:TryInitFilterPopOfView("AttributeFilterPop", function()
    self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_ATTR)
  end, GemAttributeFilter)
  self:InitSkillQualityFilter()
  self:InitProfessionFilter()
  self:InitFavorToggle()
  self.secretLandFilterType = 0
  self:TryInitFilterPopOfView("SecretLandFilterPop", function(type)
    self.secretLandFilterType = type
    self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND)
  end, GemSecretLandFilter, GemSecretLandFilterData)
end

function GemPackagePart:UpdatePage(bagType, noResetPos)
  self.attributeCtrl:SetActive(false)
  self.skillCtrl:SetActive(false)
  self.secretLandCtrl:SetActive(false)
  self.attributePanelCtrl:SetActive(false)
  self.currentBagType = bagType or self.currentBagType or SceneItem_pb.EPACKTYPE_GEM_SKILL
  local bagItems, newPatternY, newPanelY, newPanelHeight
  if self.currentBagType == SceneItem_pb.EPACKTYPE_GEM_SKILL then
    bagItems = GemProxy.GetSkillItemDataByFilterDatasOfView(self)
    table.sort(bagItems, skillGemComparer)
    self.skillCtrl:SetActive(true)
    newPanelY = 0
    newPanelHeight = 390
  elseif self.currentBagType == SceneItem_pb.EPACKTYPE_GEM_ATTR then
    bagItems = GemProxy.GetAttributeItemDataByFilterDatasOfView(self)
    table.sort(bagItems, attrGemComparer)
    self.attributeCtrl:SetActive(true)
    self.attributePanelCtrl:SetActive(true)
    newPanelY = 38
    newPanelHeight = 364
  elseif self.currentBagType == SceneItem_pb.EPACKTYPE_GEM_SECRETLAND then
    newPanelY = 0
    newPanelHeight = 440
    bagItems = GemProxy.GetSecretLandItemDataByTypeOfView(self)
    table.sort(bagItems, secretLandComparer)
    self.secretLandCtrl:SetActive(true)
  end
  if not bagItems then
    LogUtility.Warning("Cannot update gem package when bagData = nil!")
    return
  end
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.patternGO.transform))
  local tmpClipRegion = self.panel.baseClipRegion
  tmpClipRegion.y = newPanelY
  tmpClipRegion.w = newPanelHeight
  self.panel.baseClipRegion = tmpClipRegion
  if #bagItems == 0 then
    self.noneTip:SetActive(true)
    self.arrangeBtn:SetActive(false)
    self.scrollView.gameObject:SetActive(false)
    newPatternY = -262
    tempV3.y = newPatternY
    self.patternGO.transform.localPosition = tempV3
    return
  else
    newPatternY = self.currentBagType == SceneItem_pb.EPACKTYPE_GEM_ATTR and -262 or -163
    self.patternGO.transform.localPosition = tempV3
    self.noneTip:SetActive(false)
    self.arrangeBtn:SetActive(true)
    self.scrollView.gameObject:SetActive(true)
  end
  self.listCtrl:ResetDatas(bagItems, not noResetPos)
  self.scrollView.enabled = true
end

function GemPackagePart:UpdateInfo(noResetPos)
  self:UpdatePage(self.currentBagType or SceneItem_pb.EPACKTYPE_GEM_SKILL, noResetPos)
end

function GemPackagePart:TryArrange()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemAskForArrangeRangePopUp
  })
end

function GemPackagePart:OnClickCell(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowGemTip(go, data)
  else
    self.chooseId = 0
    TipManager.CloseTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChoose(self.chooseId)
  end
  cellCtl:TryClearNewTag()
end

function GemPackagePart:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick, nil, nil, function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChoose(self.chooseId)
    end
  end, true)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.itemContainer)
  self:AddIgnoreBounds(tip.gameObject)
end

function GemPackagePart:SetPos(x, y, z)
  if self.gameObject then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, z)
    self:UpdateLocalPosCache()
  end
end

function GemPackagePart:UpdateLocalPosCache()
  LuaVector3.Better_Set(localPosCache, LuaGameObject.GetLocalPosition(self.gameObject.transform))
end

function GemPackagePart:SetLocalOffset(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(localPosCache[1] + x, localPosCache[2] + y, localPosCache[3] + z)
end

function GemPackagePart:InitFilterParam()
  self.favorToggle:Set(false)
  self.curSkillClassFilterPopData = 0
  self.curSkillProfessionFilterPopData = {}
  if self.curTog then
    self.curTog:Set(false)
  end
  if not self.allTog then
    self.allTog = self.AllTab:GetComponent(UIToggle)
  end
  self.allTog:Set(true)
  GemProxy.Instance:SetCurNewProfessionFilterData(0)
  self.professionFilterLab.text = GemProxy.Instance:GetCurProfressionName()
end

function GemPackagePart:Show()
  if not self.isInited then
    LogUtility.Warning("Trying to show GemPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(true)
  self:InitFilterParam()
  self:UpdatePage()
  EventManager.Me():AddEventListener(ItemEvent.GemUpdate, self.OnGemUpdate, self)
  EventManager.Me():AddEventListener(GemEvent.ProfessionChanged, self.OnProfessionChanged, self)
end

function GemPackagePart:Hide()
  if not self.isInited then
    LogUtility.Warning("Trying to hide GemPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.GemUpdate, self.OnGemUpdate, self)
  EventManager.Me():RemoveEventListener(GemEvent.ProfessionChanged, self.OnProfessionChanged, self)
end

function GemPackagePart:OnProfessionChanged()
  self.curSkillProfessionFilterPopData = GemProxy.Instance:GetCurNewProfessionFilterData()
  self.professionFilterLab.text = GemProxy.Instance:GetCurProfressionName()
  self:UpdatePage(SceneItem_pb.EPACKTYPE_GEM_SKILL)
end

function GemPackagePart:OnGemUpdate()
  self:UpdatePage()
  TipManager.CloseTip()
end

function GemPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end
