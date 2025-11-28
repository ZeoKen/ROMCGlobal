autoImport("ExtractionItemCell")
ExtractionPackagePart = class("ExtractionPackagePart", CoreView)
local localPosCache = LuaVector3.Zero()

function ExtractionPackagePart:ctor()
end

function ExtractionPackagePart:CreateSelf(parent)
  if self.isInited == true then
    return
  end
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/ExtractionPackagePart", parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
  self.isInited = true
end

function ExtractionPackagePart:InitPart()
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.itemContainer = self:FindGO("ItemContainer")
  self.listCtrl = ListCtrl.new(self.itemContainer:GetComponent(UIGrid), ExtractionItemCell, "Extraction/BagExtractionItemCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.listCtrl:AddEventListener(MouseEvent.DoubleClick, self.OnDoubleClickCell, self)
  self:InitTabs()
  self:AddButtonEvent("CloseButton", function()
    self:Hide()
  end)
  self:AddButtonEvent("FunctionBtn", function()
    TipManager.CloseTip()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MagicBoxPanel
    })
    self:Hide()
  end)
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    self:Hide()
  end
  
  self:ShowTab(1, true)
end

function ExtractionPackagePart:InitTabs()
  local tabRootGO = self:FindGO("Tabs")
  self.tabs = {}
  local tabNames = {
    "AllTab",
    "OffenseTab",
    "DefenseTab"
  }
  local tabIcons = {
    "",
    "tab_icon_attack",
    "tab_icon_defense"
  }
  for i, name in ipairs(tabNames) do
    local tabGO = self:FindGO(name, tabRootGO)
    self:AddClickEvent(tabGO, function()
      self:ShowTab(i)
    end)
    local normalGO = self:FindGO("Normal", tabGO)
    local selectedGO = self:FindGO("Selected", tabGO)
    local iconName = tabIcons[i]
    if iconName and iconName ~= "" then
      local normalIconSp = normalGO:GetComponent(UISprite)
      if normalIconSp then
        IconManager:SetUIIcon(iconName, normalIconSp)
      end
      local selectedIconSp = selectedGO:GetComponent(UISprite)
      if selectedIconSp then
        IconManager:SetUIIcon(iconName, selectedIconSp)
      end
    end
    self.tabs[i] = {
      index = i,
      rootGO = tabGO,
      normalGO = normalGO,
      selectedGO = selectedGO
    }
  end
end

function ExtractionPackagePart:OnDoubleClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  local funcIds = GameConfig.ExtractionItemFuncIds
  if not funcIds then
    return
  end
  for _, funcid in ipairs(funcIds) do
    local config = GameConfig.ItemFunction[funcid]
    if config and FunctionItemFunc.Me():CheckFuncState(config.type, data) == ItemFuncState.Active then
      local func = FunctionItemFunc.Me():GetFuncById(funcid)
      if type(func) == "function" then
        func(data)
        break
      end
    end
  end
  self:UpdateChooseId()
end

function ExtractionPackagePart:OnClickCell(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self:UpdateChooseId(newChooseId)
    self:ShowItemTip(go, data)
  else
    self:UpdateChooseId()
  end
end

local tipOffset = {190, 0}

function ExtractionPackagePart:ShowItemTip(cellGO, data)
  if not data then
    TipManager.CloseTip()
    return
  end
  local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, cellGO.transform, Space.World)
  tipOffset[1] = 0 < x and -650 or 190
  self.tipData = self.tipData or {
    ignoreBounds = {
      self.itemContainer
    },
    callback = function()
      self:UpdateChooseId()
    end
  }
  self.tipData.itemdata = data
  self.tipData.funcConfig = GameConfig.ExtractionItemFuncIds
  local tip = ExtractionPackagePart.super.ShowItemTip(self, self.tipData, self.normalStick, NGUIUtil.AnchorSide.Right, tipOffset)
  if tip then
    self:AddIgnoreBounds(tip.gameObject)
  end
end

function ExtractionPackagePart:SetPos(x, y, z)
  if self.gameObject then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, z)
    self:UpdateLocalPosCache()
  end
end

function ExtractionPackagePart:UpdateLocalPosCache()
  LuaVector3.Better_Set(localPosCache, LuaGameObject.GetLocalPosition(self.gameObject.transform))
end

function ExtractionPackagePart:SetLocalOffset(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(localPosCache[1] + x, localPosCache[2] + y, localPosCache[3] + z)
end

function ExtractionPackagePart:Show()
  if not self.isInited then
    LogUtility.Warning("Trying to show ExtractionPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(true)
  self:ShowTab(1, true)
  self:SetAnchorSide()
  EventManager.Me():AddEventListener(ServiceEvent.NUserExtractionQueryUserCmd, self.OnItemUpdate, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserExtractionOperateUserCmd, self.OnItemUpdate, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserExtractionActiveUserCmd, self.OnItemUpdate, self)
end

function ExtractionPackagePart:Hide()
  if not self.isInited then
    LogUtility.Warning("Trying to hide ExtractionPackagePart without initializing it first.")
    return
  end
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserExtractionQueryUserCmd, self.OnItemUpdate, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserExtractionOperateUserCmd, self.OnItemUpdate, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserExtractionActiveUserCmd, self.OnItemUpdate, self)
end

function ExtractionPackagePart:OnItemUpdate()
  self:UpdateTabContent()
  self:OnClickCell()
end

function ExtractionPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function ExtractionPackagePart:UpdateChooseId(id)
  id = id or 0
  self.chooseId = id
  if id == 0 then
    TipManager.CloseTip()
  end
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseId(self.chooseId)
  end
end

function ExtractionPackagePart:ShowTab(tabIndex, force)
  if self.selectedTab ~= tabIndex or force then
    self.selectedTab = tabIndex
    for i, tab in ipairs(self.tabs) do
      if i == tabIndex then
        tab.normalGO:SetActive(false)
        tab.selectedGO:SetActive(true)
      else
        tab.normalGO:SetActive(true)
        tab.selectedGO:SetActive(false)
      end
    end
    self:UpdateTabContent()
  end
end

function ExtractionPackagePart:UpdateInfo()
  self:UpdateTabContent()
end

function ExtractionPackagePart:UpdateTabContent()
  local proxy = AttrExtractionProxy.Instance
  local dataList
  if self.selectedTab == 2 then
    dataList = proxy:GetOffenseItemDataList()
  elseif self.selectedTab == 3 then
    dataList = proxy:GetDefenseItemDataList()
  else
    dataList = proxy:GetAllItemDataList()
  end
  proxy:SortExtractionItemDataList(dataList)
  self.listCtrl:ResetDatas(dataList or {})
  if dataList and 0 < #dataList then
    self.noneTip:SetActive(false)
  else
    self.noneTip:SetActive(true)
  end
end

function ExtractionPackagePart:SetAnchorSide(side)
  side = side or NGUIUtil.AnchorSide.Left
  if self.anchorSide ~= side then
    self.anchorSide = side
    if side == NGUIUtil.AnchorSide.Right then
      self:SetLocalOffset(440, 0, 0)
    else
      self:SetLocalOffset(0, 0, 0)
    end
  end
end
