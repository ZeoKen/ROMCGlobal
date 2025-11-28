autoImport("CommonTabListCell")
CommonCombineView = class("CommonCombineView", BaseView)
CommonCombineView.ViewType = UIViewType.NormalLayer
local fkCfg = {
  EquipUpgradeView = {
    name = ZhString.EquipUpgradePopUp_Upgrade,
    icon = "tab_btn_icon_zhuangbeishegnji"
  },
  EquipMfrView = {
    name = ZhString.EquipMake_Name,
    icon = "tab_btn_icon_zhuangbeizhizuo_"
  }
}

function CommonCombineView:InitConfig()
  self.TabGOName = {
    "Tab1",
    "Tab2",
    "Tab3"
  }
  self.TabIconMap = {
    Tab1 = "tab_btn_icon_zhuangbeishegnji"
  }
  self.TabName = {
    ZhString.EquipUpgradePopUp_Upgrade
  }
  self.TabViewList = {
    PanelConfig.EquipUpgradeView
  }
end

function CommonCombineView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end

function CommonCombineView:InitData()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcData = viewdata.npcdata
    self.index = viewdata.index or 1
    self.OnClickChooseBordCell_data = viewdata.OnClickChooseBordCell_data
    self.isFromBag = viewdata.isFromBag
    if viewdata.tabs then
      self.customTabs = {}
      for i = 1, #viewdata.tabs do
        local panel = viewdata.tabs[i]
        if type(panel) == "string" then
          panel = PanelConfig[panel]
        end
        xdlog("有customTab", panel.class)
        local cfg = panel and panel.class and fkCfg[panel.class]
        if cfg then
          table.insert(self.customTabs, {
            name = cfg.name,
            icon = cfg.icon,
            type = cfg.type,
            panel = panel
          })
        else
          redlog("panel.class", panel.class)
        end
      end
    end
  end
end

function CommonCombineView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end

function CommonCombineView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.cells = {}
  local tabName, longPress, tabObj
  if self.customTabs then
    local uesTabs = math.min(#self.customTabs, #self.TabGOName)
    xdlog("设置tab", uesTabs)
    for i = 1, uesTabs do
      tabName = self.TabGOName[i]
      tabObj = self:FindGO(tabName)
      self:Show(tabObj)
      self.cells[i] = CommonTabListCell.new(tabObj)
      self.cells[i]:SetIcon(self.customTabs[i].icon, self.customTabs[i].type)
      local check = {
        tab = i,
        id = self.customTabs[i].panel.id
      }
      self:AddTabChangeEvent(self.cells[i].gameObject, nil, check)
      longPress = self.cells[i].gameObject:GetComponent(UILongPress)
      
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.EnchantCombineView, {state, i})
      end
    end
    for i = uesTabs + 1, #self.TabGOName do
      tabName = self.TabGOName[i]
      tabObj = self:FindGO(tabName)
      self:Hide(tabObj)
    end
  else
    for i = 1, #self.TabGOName do
      tabName = self.TabGOName[i]
      tabObj = self:FindGO(tabName)
      self:Show(tabObj)
      self.cells[i] = CommonTabListCell.new(self:FindGO(tabName))
      self.cells[i]:SetIcon(self.TabIconMap[tabName], self.TabType and self.TabType[i])
      local check = {
        tab = i,
        id = self.TabViewList[i].id
      }
      self:AddTabChangeEvent(self.cells[i].gameObject, nil, check)
      longPress = self.cells[i].gameObject:GetComponent(UILongPress)
      
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.EnchantCombineView, {state, i})
      end
    end
  end
  self.grid:Reposition()
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self.shopEnterBtn:SetActive(false)
  self:AddEventListener(TipLongPressEvent.EnchantCombineView, self.HandleLongPress, self)
  self.closeBtn = self:FindGO("CloseButton", self.gameObject)
  self:AddOrRemoveGuideId(self.closeBtn, 549)
end

function CommonCombineView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if self.customTabs then
    TabNameTip.OnLongPress(isPressing, self.customTabs[index].name, false, self.cells[index].sp)
  else
    TabNameTip.OnLongPress(isPressing, self.TabName[index], false, self.cells[index].sp)
  end
end

function CommonCombineView:TabChangeHandler(key)
  if self.tab_key == key then
    return
  end
  self.tab_key = key
  if not CommonCombineView.super.TabChangeHandler(self, key) then
    return
  end
  self:JumpPanel(key)
  if self.cells and self.cells[key] then
    self.cells[key].toggle.value = true
  end
end

function CommonCombineView:JumpPanel(tabIndex)
  if self.customTabs then
    local panel = self.customTabs[tabIndex].panel
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    if panel.class == "EquipUpgradeView" then
      viewdata.isFromHomeWorkbench = true
      viewdata.isCombine = true
      if self.viewdata and self.viewdata.viewdata then
        self.viewdata.viewdata.OnClickChooseBordCell_data = nil
      end
    end
    self:_JumpPanel(panel.class, viewdata)
  elseif tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("EquipUpgradeView", {
      isFromHomeWorkbench = true,
      isCombine = true,
      OnClickChooseBordCell_data = self.OnClickChooseBordCell_data
    })
    self.OnClickChooseBordCell_data = nil
  end
end

function CommonCombineView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function CommonCombineView:OnEnter()
  CommonCombineView.super.OnEnter(self)
  self.npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if self.npcInfo then
    local rootTrans = self.npcInfo.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
  else
    self:CameraFocusToMe()
  end
  self:TabChangeHandler(self.index or 1)
  EventManager.Me():AddEventListener(UIEvent.ExitCallback, self.SetExitCallback, self)
end

function CommonCombineView:ReturnToResetView()
  self:TabChangeHandler(3)
end

function CommonCombineView:SetExitCallback(callback)
  self.exitCallback = callback
end

function CommonCombineView:CloseSelf()
  CommonCombineView.super.CloseSelf(self)
end

function CommonCombineView:OnExit()
  CommonCombineView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(UIEvent.ExitCallback, self.SetExitCallback, self)
  if self.viewdata.viewdata and self.viewdata.viewdata.tabs then
    for i = 1, #self.viewdata.viewdata.tabs do
      local panel = self.viewdata.viewdata.tabs[i]
      self:sendNotification(UIEvent.CloseUI, {
        className = panel.class,
        needRollBack = false
      })
    end
  end
  self:CameraReset()
  if self.viewdata.viewdata.from_AdventureEquipComposeTip then
    local equipID = self.viewdata.viewdata.from_AdventureEquipComposeTip
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        tabId = SceneManual_pb.EMANUALTYPE_RESEARCH,
        selectItemId = equipID
      }
    })
  end
  EquipComposeProxy.Instance:SetCurOperEquipGuid(nil)
  if self.exitCallback then
    self.exitCallback()
    self.exitCallback = nil
  end
end
