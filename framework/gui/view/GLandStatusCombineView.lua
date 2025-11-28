autoImport("CommonTabListCell")
GLandStatusCombineView = class("GLandStatusCombineView", BaseView)
GLandStatusCombineView.ViewType = UIViewType.PopUpLayer
local fkCfg = {
  GLandChallengeView = {
    name = ZhString.GvgLandChallengeView_GVGTarget,
    icon = "tab_icon_162"
  },
  GLandStatusListView = {
    name = ZhString.GvgLandChallengeView_GVGStatus,
    icon = "tab_icon_163"
  }
}

function GLandStatusCombineView:InitConfig()
  self.TabGOName = {"Tab1", "Tab2"}
  self.TabIconMap = {
    Tab1 = "tab_icon_162",
    Tab2 = "tab_icon_163"
  }
  self.TabName = {
    ZhString.GvgLandChallengeView_GVGTarget,
    ZhString.GvgLandChallengeView_GVGStatus
  }
  self.TabViewList = {
    PanelConfig.GLandChallengeView,
    PanelConfig.GLandStatusListView
  }
end

function GLandStatusCombineView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end

function GLandStatusCombineView:InitData()
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

function GLandStatusCombineView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end

function GLandStatusCombineView:InitView()
  self.grid = self:FindComponent("TabGrid", UIGrid)
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
  if self.cells[1] then
    RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_EXCELLENT_REWARD, self.cells[1].gameObject, 40)
  end
  self.grid:Reposition()
  self.closeBtn = self:FindGO("CloseButton", self.gameObject)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, self.HandleGvgOpenFire)
  self:AddListenEvt(GVGEvent.GVG_TraceToCity, self.CloseSelf)
end

function GLandStatusCombineView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if self.customTabs then
    TabNameTip.OnLongPress(isPressing, self.customTabs[index].name, false, self.cells[index].sp)
  else
    TabNameTip.OnLongPress(isPressing, self.TabName[index], false, self.cells[index].sp)
  end
end

function GLandStatusCombineView:TabChangeHandler(key)
  if self.tab_key == key then
    return
  end
  local func = function()
    self.tab_key = key
    if not GLandStatusCombineView.super.TabChangeHandler(self, key) then
      return
    end
    self:JumpPanel(key)
    if self.cells and self.cells[key] then
      self.cells[key].toggle.value = true
    end
  end
  if key == 1 then
    local hasGuild = false
    local mercenaryGuildID = GuildProxy.Instance.myMercenaryGuildId
    if mercenaryGuildID and 0 < mercenaryGuildID then
      hasGuild = true
    end
    local myGuildID = GuildProxy.Instance.guildId
    if myGuildID and 0 < myGuildID then
      hasGuild = true
    end
    if not GuildProxy.Instance:IHaveGuild() then
      MsgManager.ConfirmMsgByID(43573, function()
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.GuildFindPopUp
        })
        self:CloseSelf()
      end, function()
        func()
      end, nil)
    else
      func()
    end
  else
    func()
  end
end

function GLandStatusCombineView:JumpPanel(tabIndex)
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
    self:_JumpPanel("GLandChallengeView", {isCombine = true})
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("GLandStatusListView", {isCombine = true})
    self.OnClickChooseBordCell_data = nil
  end
end

function GLandStatusCombineView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function GLandStatusCombineView:OnEnter()
  GLandStatusCombineView.super.OnEnter(self)
  self:TabChangeHandler(self.index or 1)
end

function GLandStatusCombineView:CloseSelf()
  GLandStatusCombineView.super.CloseSelf(self)
end

function GLandStatusCombineView:OnExit()
  GLandStatusCombineView.super.OnExit(self)
  if self.viewdata.viewdata and self.viewdata.viewdata.tabs then
    for i = 1, #self.viewdata.viewdata.tabs do
      local panel = self.viewdata.viewdata.tabs[i]
      self:sendNotification(UIEvent.CloseUI, {
        className = panel.class,
        needRollBack = false
      })
    end
  else
    self:sendNotification(UIEvent.CloseUI, {
      className = "GLandChallengeView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "GLandStatusListView",
      needRollBack = false
    })
  end
  self:CameraReset()
  if self.exitCallback then
    self.exitCallback()
    self.exitCallback = nil
  end
end

function GLandStatusCombineView:HandleGvgOpenFire(note)
  local isEntranceOpen = GvgProxy.Instance:IsGvgFlagShow()
  if not isEntranceOpen then
    self:CloseSelf()
  end
end
