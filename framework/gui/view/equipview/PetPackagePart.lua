autoImport("CoreView")
PetPackagePart = class("PetPackagePart", CoreView)
autoImport("BagItemCell")
autoImport("PetBagItemCell")
autoImport("WrapListCtrl")
PetPackagePart.IsNoticeShow = "ServantMainView_IsNoticeShow"

function PetPackagePart:ctor()
end

local PetPackagePart_Path = "GUI/v1/part/PetPackagePart"

function PetPackagePart:CreateSelf(parent)
  if self.inited == true then
    return
  end
  self.inited = true
  self.gameObject = self:LoadPreferb_ByFullPath(PetPackagePart_Path, parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
end

function PetPackagePart:InitPart()
  self:InitScrollPull()
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    TipManager.Instance:CloseItemTip()
    self:Hide()
  end)
  self.petHelpButton = self:FindGO("PetHelpButton")
  self:RegistShowGeneralHelpByHelpID(2100, self.petHelpButton)
  self.sortBtn = self:FindGO("SortBtn")
  self.sortBtnSp = self.sortBtn and self.sortBtn:GetComponent(UISprite)
  self:AddClickEvent(self.sortBtn, function()
    self:ShowPetFilterTip()
  end)
  local container = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(container, PetBagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 4, 104)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.quickTitle = self:FindComponent("QuickTitle", UILabel)
  self.quickTitle.text = ZhString.PetPackagePart_QuickPetTitle
  self.quickGrid = self:FindGO("QuickItemGrid"):GetComponent(UIGrid)
  self.quickItemCtrl = UIGridListCtrl.new(self.quickGrid, PetBagItemCell, "BagItemCell")
  self.quickItemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickQuickItemCell, self)
  self.quickItemCells = self.quickItemCtrl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.resetBtn = self:FindGO("ResetBtn", self.noneTip)
  self:AddClickEvent(self.resetBtn, function()
    self:ResetPetFilter()
  end)
  self.resetBtn:SetActive(false)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
  
  self:MapEvent()
end

function PetPackagePart:InitScrollPull()
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
  
  function self.scrollView.OnBackToStop()
    self.waitting.text = ZhString.ItemNormalList_Refreshing
  end
  
  function self.scrollView.OnStop()
    self.scrollView:Revert()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_PET)
  end
  
  function self.scrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and ZhString.ItemNormalList_PullRefresh or ZhString.ItemNormalList_CanRefresh
  end
  
  function self.scrollView.OnRevertFinished()
    self.waitting.text = ZhString.ItemNormalList_PullRefresh
  end
end

function PetPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PetPackagePart:ClickItemCell(cellCtl)
  self:SetChoose(cellCtl)
  self:SetChoosen()
end

function PetPackagePart:SetChoose(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  if data == nil or data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey or type(data) ~= "table" or data.staticData == nil then
    self.chooseId = 0
    self:ShowPackageItemTip()
    return
  end
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowPackageItemTip(data, go)
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
end

function PetPackagePart:ClickQuickItemCell(cellCtl)
  self:SetChoose(cellCtl)
  self:SetChoosen()
end

function PetPackagePart:SetChoosen()
  for _, cell in pairs(self.quickItemCells) do
    cell:SetChooseId(self.chooseId)
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

local PACK_FASHION_LEFTVIEWSTATE = "PackageView_LeftViewState_Fashion"

function PetPackagePart:ShowPackageItemTip(data, cellGO)
  if data == nil or data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey or type(data) ~= "table" or data.staticData == nil then
    self:ShowItemTip()
    return
  end
  local offset = {
    [1] = 190,
    [2] = 0
  }
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local state = FunctionItemFunc.Me():GetLeftViewState()
  local funcConfig = {}
  local baseFunc = FunctionItemFunc.GetItemFuncIds(data.staticData.id, nil, state == PACK_FASHION_LEFTVIEWSTATE)
  if baseFunc then
    for i = 1, #baseFunc do
      table.insert(funcConfig, baseFunc[i])
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback,
    funcConfig = funcConfig
  }
  local itemtip = self:ShowItemTip(sdata, self.normalStick, NGUIUtil.AnchorSide.Right, offset)
  if itemtip and itemtip.ActiveFavorite then
    itemtip:ActiveFavorite()
  end
  itemtip:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(itemtip.gameObject)
end

function PetPackagePart:UpdateInfo(items, quickItems)
  local petBag = BagProxy.Instance.petBagData
  items = items or petBag:GetItems()
  quickItems = quickItems or petBag:GetQuickItems()
  self.allItems = items
  self.allQuickItems = quickItems
  local filteredItems = self:FilterPetItems(items)
  local filteredQuickItems = self:FilterPetItems(quickItems)
  local hasFilter = self:HasPetFilter()
  if #filteredItems == 0 then
    self.noneTip:SetActive(true)
    self.resetBtn:SetActive(hasFilter)
    self.scrollView.gameObject:SetActive(false)
  else
    self.noneTip:SetActive(false)
    self.resetBtn:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
  end
  self.itemCtrl:ResetDatas(filteredItems)
  self.quickItemCtrl:ResetDatas(filteredQuickItems)
  self:UpdateDataSign(items, quickItems)
end

function PetPackagePart:HasPetFilter()
  local filter = self.petFilter
  if not filter then
    return false
  end
  if filter.keyword and filter.keyword ~= "" then
    return true
  end
  for _, selected in pairs(filter.groups or {}) do
    for _, enabled in pairs(selected) do
      if enabled then
        return true
      end
    end
  end
  return false
end

function PetPackagePart:ResetPetFilter()
  local tip = TipsView.Me().currentTip
  if tip and TipsView.Me():IsCurrentTip(PetPropTypeTip) and tip.OnResetBtnClick then
    tip:OnResetBtnClick(true)
  end
  self.petFilter = {
    keyword = "",
    groups = {}
  }
  self:UpdateInfo(self.allItems, self.allQuickItems)
  self.scrollView:ResetPosition()
  self.itemCtrl:ResetPosition()
end

function PetPackagePart:ShowPetFilterTip()
  local data = {
    callback = self.OnPetFilterChanged,
    param = self,
    keyword = self.petFilter and self.petFilter.keyword or "",
    groups = self.petFilter and self.petFilter.groups or nil
  }
  local tip = TipManager.Instance:ShowPetPropTypeTip(data, self.sortBtnSp, NGUIUtil.AnchorSide.Right, {250, -50})
  if tip then
    tip:AddIgnoreBounds(self.gameObject)
    self:AddIgnoreBounds(tip.gameObject)
  end
end

function PetPackagePart:OnPetFilterChanged(filter)
  self.petFilter = filter or {
    keyword = "",
    groups = {}
  }
  self:UpdateInfo(self.allItems, self.allQuickItems)
  self.scrollView:ResetPosition()
  self.itemCtrl:ResetPosition()
end

local PetContains = function(text, keyword)
  if not text or keyword == "" then
    return false
  end
  return string.find(string.lower(tostring(text)), string.lower(keyword), 1, true) ~= nil
end
local PetLocalized = function(text)
  if not text then
    return nil
  end
  if OverSea and OverSea.LangManager and OverSea.LangManager.Instance then
    return OverSea.LangManager.Instance():GetLangByKey(text) or text
  end
  return text
end
local PET_SKILL_KEYS = {
  "Skill_1",
  "ContractSkill",
  "Skill_3",
  "Skill_4",
  "Skill_2",
  "Skill_5"
}
local GetConfigPetSkillIds = function(petCfg)
  local result = {}
  if not petCfg then
    return result
  end
  for i = 1, #PET_SKILL_KEYS do
    local skillCfg = petCfg[PET_SKILL_KEYS[i]]
    if skillCfg and skillCfg[1] then
      local maxLevel = skillCfg[2] or 1
      local skillId = skillCfg[1] - skillCfg[1] % 1000 + maxLevel
      if not Table_Skill[skillId] then
        skillId = skillCfg[1]
      end
      result[#result + 1] = skillId
    end
  end
  return result
end
local PetMountCanEquipByConfig = function(petCfg, friendlv)
  if not petCfg or petCfg.CanEquip ~= 1 then
    return false
  end
  local cond = petCfg.EquipCondition
  if not cond or cond.friendlv == nil then
    return false
  end
  return (friendlv or 0) >= cond.friendlv
end

function PetPackagePart:GetPetFilterContext(item)
  if type(item) ~= "table" or item.staticData == nil then
    return nil
  end
  local egg = item.petEggInfo
  local petCfg = egg and egg.petid and Table_Pet[egg.petid] or nil
  petCfg = petCfg or Game.Config_EggPet and Game.Config_EggPet[item.staticData.id] or nil
  local petid = petCfg and petCfg.id or egg and egg.petid
  if not petid or petid == 0 then
    return nil
  end
  return {
    egg = egg,
    petid = petid,
    petCfg = petCfg,
    monsterCfg = Table_Monster[petid]
  }
end

function PetPackagePart:IsPetSearchMatch(item, keyword)
  if keyword == "" then
    return true
  end
  local ctx = self:GetPetFilterContext(item)
  if not ctx then
    if type(item) ~= "table" or item.staticData == nil then
      return false
    end
    return PetContains(item.staticData.NameZh, keyword)
  end
  if ctx.egg and PetContains(ctx.egg.name, keyword) then
    return true
  end
  if ctx.petCfg and PetContains(PetLocalized(ctx.petCfg.Name), keyword) then
    return true
  end
  if ctx.monsterCfg and PetContains(PetLocalized(ctx.monsterCfg.NameZh), keyword) then
    return true
  end
  local skillDatas = ctx.egg and ctx.egg:GetSkillDisplayDatasForUI() or GetConfigPetSkillIds(ctx.petCfg)
  for i = 1, #skillDatas do
    local skillID = type(skillDatas[i]) == "table" and skillDatas[i].skillId or skillDatas[i]
    local skillCfg = skillID and Table_Skill[skillID]
    if skillCfg and PetContains(PetLocalized(skillCfg.NameZh), keyword) then
      return true
    end
    if not skillCfg and skillID then
      skillCfg = Table_Skill[skillID - skillID % 1000]
      if skillCfg and PetContains(PetLocalized(skillCfg.NameZh), keyword) then
        return true
      end
    end
  end
  return false
end

function PetPackagePart:IsPetGroupMatch(item, groupID, selected)
  local hasSelected = false
  for _, value in pairs(selected or {}) do
    if value then
      hasSelected = true
      break
    end
  end
  if not hasSelected then
    return true
  end
  if type(item) ~= "table" or item.staticData == nil then
    return false
  end
  if groupID == "favorite" then
    local favorite = item.isFavorite == true
    for id, enabled in pairs(selected) do
      if enabled and (favorite == id or tostring(favorite) == id) then
        return true
      end
    end
    return false
  end
  local ctx = self:GetPetFilterContext(item)
  if not ctx then
    return false
  end
  local egg = ctx.egg
  local value
  if groupID == "level" then
    local maxLevel = GameConfig and GameConfig.System and GameConfig.System.maxbaselevel
    if type(maxLevel) ~= "number" or maxLevel <= 0 then
      maxLevel = 0
      for level, _ in pairs(Table_PetBaseLevel or {}) do
        if type(level) == "number" and level > maxLevel then
          maxLevel = level
        end
      end
      maxLevel = 0 < maxLevel and maxLevel or 170
    end
    local lv
    if egg then
      lv = egg.lv or 0
    else
      lv = 1
    end
    for id, enabled in pairs(selected) do
      local minLv = (id - 1) * 10 + 1
      local maxLv = math.min(id * 10, maxLevel)
      if enabled and lv >= minLv and lv <= maxLv then
        return true
      end
    end
    return false
  elseif groupID == "friendlv" then
    value = egg and egg.friendlv or 0
  elseif groupID == "nature" then
    value = ctx.monsterCfg and ctx.monsterCfg.Nature
  elseif groupID == "race" then
    value = ctx.monsterCfg and ctx.monsterCfg.Race
  elseif groupID == "shape" then
    value = ctx.monsterCfg and ctx.monsterCfg.Shape
  elseif groupID == "mount" then
    if egg then
      value = egg:PetMountCanEquip()
    else
      value = PetMountCanEquipByConfig(ctx.petCfg, 0)
    end
  elseif groupID == "pvp" then
    value = (ctx.petCfg and ctx.petCfg.IsPvpPet and 0 < ctx.petCfg.IsPvpPet) == true
  end
  for id, enabled in pairs(selected) do
    if enabled and (value == id or tostring(value) == id) then
      return true
    end
  end
  return false
end

function PetPackagePart:FilterPetItems(items)
  local result = {}
  local filter = self.petFilter or {
    keyword = "",
    groups = {}
  }
  for i = 1, #(items or {}) do
    local item = items[i]
    if self:IsPetSearchMatch(item, filter.keyword or "") then
      local matched = true
      for groupID, selected in pairs(filter.groups or {}) do
        if not self:IsPetGroupMatch(item, groupID, selected) then
          matched = false
          break
        end
      end
      if matched then
        result[#result + 1] = item
      end
    end
  end
  return result
end

function PetPackagePart:UpdatePetCD()
  if self.itemCells then
    for _, cell in pairs(self.itemCells) do
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  if self.quickItemCells then
    for _, cell in pairs(self.quickItemCells) do
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
end

local GetPetItemSign = function(items)
  local sign = ""
  if items then
    for i = 1, #items do
      local data = items[i]
      sign = sign .. tostring(type(data) == "table" and data.id or data) .. ";"
    end
  end
  return sign
end

function PetPackagePart:UpdateDataSign(items, quickItems)
  self.itemDataCount = items and #items or 0
  self.itemDataSign = GetPetItemSign(items)
  self.quickItemDataSign = GetPetItemSign(quickItems)
end

function PetPackagePart:IsDataSignChanged(items, quickItems)
  return self.itemDataCount ~= (items and #items or 0) or self.itemDataSign ~= GetPetItemSign(items) or self.quickItemDataSign ~= GetPetItemSign(quickItems)
end

function PetPackagePart:RefreshPetCellState()
  if self.itemCells then
    for _, cell in pairs(self.itemCells) do
      if cell.UpdatePetFighting then
        cell:UpdatePetFighting(cell.data)
      end
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  if self.quickItemCells then
    for _, cell in pairs(self.quickItemCells) do
      if cell.UpdatePetFighting then
        cell:UpdatePetFighting(cell.data)
      end
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  self:SetChoosen()
end

function PetPackagePart:HandlePetUpdate()
  local petBag = BagProxy.Instance.petBagData
  local items = petBag:GetItems()
  local quickItems = petBag:GetQuickItems()
  if self:IsDataSignChanged(items, quickItems) then
    self:UpdateInfo()
  else
    self:RefreshPetCellState()
  end
  self:UpdateCurrentItemTipFavorite()
end

function PetPackagePart:UpdateCurrentItemTipFavorite()
  local tip = TipsView.Me().currentTip
  if not (tip and TipsView.Me():IsCurrentTip(ItemFloatTip)) or not tip.UpdateFavorite then
    return
  end
  local itemdata = tip.data and tip.data.itemdata
  local currentData = itemdata and BagProxy.Instance:GetItemByGuid(itemdata.id, SceneItem_pb.EPACKTYPE_PET)
  tip:UpdateFavorite(currentData or itemdata)
end

function PetPackagePart:HandleItemUpdate()
  self:UpdatePetCD()
  self:UpdateCurrentItemTipFavorite()
end

local tempV3 = LuaVector3()

function PetPackagePart:SetPos(x, y, z)
  if self.gameObject then
    LuaVector3.Better_Set(tempV3, x, y, z)
    self.gameObject.transform.position = tempV3
    self:UpdateLocalPosCache()
  end
end

function PetPackagePart:UpdateLocalPosCache()
  self.localPos_x, self.localPos_y, self.localPos_z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
end

function PetPackagePart:SetLocalOffset(x, y, z)
  LuaVector3.Better_Set(tempV3, self.localPos_x + x, self.localPos_y + y, self.localPos_z + z)
  self.gameObject.transform.localPosition = tempV3
end

function PetPackagePart:MapEvent()
end

function PetPackagePart:Show()
  if not self.inited then
    return
  end
  local petBag = BagProxy.Instance.petBagData
  local items = petBag:GetItems()
  local isNoticeShow = FunctionPlayerPrefs.Me():GetBool(PetPackagePart.IsNoticeShow)
  if not isNoticeShow and 0 < #items then
    self.closecomp.enabled = false
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PetPackagePopView",
      viewdata = {msgid = 8026}
    })
  end
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ItemEvent.PetUpdate, self.HandlePetUpdate, self)
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.HandleItemUpdate, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserCDTimeUserCmd, self.UpdatePetCD, self)
  EventManager.Me():AddEventListener(UICloseEvent.GeneralHelpClose, self.ResetClosecomp, self)
  EventManager.Me():AddEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():AddEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
  self:UpdateInfo(items)
  self.itemCtrl:ResetPosition()
  self:SetChoosen()
end

function PetPackagePart:Hide()
  if not self.inited then
    return
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_PET)
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.PetUpdate, self.HandlePetUpdate, self)
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.HandleItemUpdate, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserCDTimeUserCmd, self.UpdatePetCD, self)
  EventManager.Me():RemoveEventListener(UICloseEvent.GeneralHelpClose, self.ResetClosecomp, self)
  EventManager.Me():RemoveEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():RemoveEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
  self.chooseId = 0
  self.petFilter = {
    keyword = "",
    groups = {}
  }
  TipManager.Instance:CloseTipByClassType(PetPropTypeTip)
end

function PetPackagePart:ResetClosecomp()
  self:HandleEnableCloseComp(true)
end

function PetPackagePart:HandleEnableCloseComp(var)
  self.closecomp.enabled = var
end
