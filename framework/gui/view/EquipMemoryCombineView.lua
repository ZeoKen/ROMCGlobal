autoImport("CommonCombineView")
EquipMemoryCombineView = class("EquipMemoryCombineView", CommonCombineView)
EquipMemoryCombineView.ViewType = UIViewType.NormalLayer
local fkCfg = {
  EquipMemoryEmbedView = {
    name = ZhString.EquipMemory_Equip,
    icon = "memory_icon_1"
  },
  EquipMemoryUpgradeView = {
    name = ZhString.EquipMemory_Upgrade,
    icon = "memory_icon_2"
  },
  EquipMemoryDecomposeView = {
    name = ZhString.EquipMemory_Decompose,
    icon = "memory_icon_3"
  },
  EquipMemoryAttrResetView = {
    name = ZhString.EquipMemory_AttrReset,
    icon = "memory_icon_4"
  },
  EquipMemoryWaxView = {
    name = ZhString.EquipMemory_AddWax,
    icon = "memory_icon_5"
  },
  EquipMemoryAdvanceView = {
    name = ZhString.EquipMemory_Advance,
    icon = "tab_icon_pinzhiup"
  }
}

function EquipMemoryCombineView:InitConfig()
  self.TabGOName = {
    "Tab1",
    "Tab2",
    "Tab3",
    "Tab4"
  }
  self.TabIconMap = {
    Tab1 = "memory_icon_1",
    Tab2 = "memory_icon_2",
    Tab3 = "memory_icon_4",
    Tab4 = "tab_icon_pinzhiup"
  }
  self.TabName = {
    ZhString.EquipMemory_Equip,
    ZhString.EquipMemory_Upgrade,
    ZhString.EquipMemory_AttrReset,
    ZhString.EquipMemory_Advance
  }
  self.TabViewList = {
    PanelConfig.EquipMemoryEmbedView,
    PanelConfig.EquipMemoryUpgradeView,
    PanelConfig.EquipMemoryAttrResetView,
    PanelConfig.EquipMemoryAdvanceView
  }
end

function EquipMemoryCombineView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end

function EquipMemoryCombineView:InitData()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcData = viewdata.npcdata
    self.index = viewdata.index or 1
    self.itemdata = viewdata.itemdata
    if self.itemdata then
      local sitePos = self.itemdata.equiped == 1 and ItemUtil.EquipPosConfig[self.itemdata.index] and self.itemdata.index or nil
      if not sitePos then
        local curEquipSite = self.itemdata and self.itemdata.equipInfo and self.itemdata.equipInfo:GetEquipSite()
        sitePos = curEquipSite and curEquipSite[1]
      end
      local validPoses = {}
      for _, info in pairs(Table_ItemMemory) do
        local equipPoses = info.CanEquip and info.CanEquip.EquipPos
        for i = 1, #equipPoses do
          if not validPoses[equipPoses[i]] then
            validPoses[equipPoses[i]] = 1
          end
        end
      end
      if sitePos and validPoses[sitePos] then
        self.itemdata.sitePos = sitePos
      end
    end
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

function EquipMemoryCombineView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end

function EquipMemoryCombineView:InitView()
  EquipMemoryCombineView.super.InitView(self)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self:AddListenEvt(ItemEvent.EquipChooseSuccess, self.HandleSwitchMemory)
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self.isFromBag = self.viewdata.viewdata and self.viewdata.viewdata.isFromBag
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.closeBtn = self:FindGO("CloseButton")
  self.closeBtn:SetActive(not self.isCombine)
end

function EquipMemoryCombineView:JumpPanel(tabIndex)
  if self.itemdata then
    local sitePos = self.itemdata.sitePos
    if not sitePos then
      local guid = self.itemdata.id
      local item = guid and BagProxy.Instance:GetItemByGuid(guid)
      self.itemdata = item
    else
      local posData = EquipMemoryProxy.Instance:GetPosData(sitePos)
      if posData then
        local _itemData = ItemData.new("EquipedMemory", self.itemdata.staticData.id)
        _itemData.equipMemoryData = posData:Clone()
        _itemData.equiped = 1
        _itemData.sitePos = sitePos
        self.itemdata = _itemData
      else
        self.itemdata = nil
      end
    end
  end
  if self.customTabs then
    local panel = self.customTabs[tabIndex].panel
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      self.viewdata.viewdata.isCombine = true
      self.viewdata.viewdata.itemdata = self.itemdata
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    self:_JumpPanel(panel.class, viewdata)
  else
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      self.viewdata.viewdata.isCombine = true
      self.viewdata.viewdata.itemdata = self.itemdata
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    if tabIndex == 1 then
      self:SetStackViewIndex(1)
      self:_JumpPanel("EquipMemoryEmbedView", viewdata)
    elseif tabIndex == 2 then
      self:SetStackViewIndex(2)
      self:_JumpPanel("EquipMemoryUpgradeView", viewdata)
    elseif tabIndex == 3 then
      self:SetStackViewIndex(3)
      self:_JumpPanel("EquipMemoryAttrResetView", viewdata)
    elseif tabIndex == 4 then
      self:SetStackViewIndex(4)
      self:_JumpPanel("EquipMemoryAdvanceView", viewdata)
    end
  end
end

function EquipMemoryCombineView:OnEnter()
  EquipMemoryCombineView.super.super.OnEnter(self)
  self:TabChangeHandler(self.index)
  EventManager.Me():AddEventListener(EquipMemoryEvent.JumpToAttrReset, self.ReturnToResetView, self)
end

function EquipMemoryCombineView:ReturnToResetView()
  local index = 3
  if self.customTabs then
    for i = 1, #self.customTabs do
      local panel = self.customTabs[i]
      if panel.panel.class == "EquipMemoryAttrResetView" then
        index = i
        break
      end
    end
  end
  xdlog("返回重置", index)
  self:TabChangeHandler(index)
end

function EquipMemoryCombineView:CloseSelf()
  EquipMemoryCombineView.super.CloseSelf(self)
end

function EquipMemoryCombineView:OnExit()
  EquipMemoryCombineView.super.super.OnExit(self)
  EventManager.Me():RemoveEventListener(EquipMemoryEvent.JumpToAttrReset, self.ReturnToResetView, self)
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
      className = "EquipMemoryUpgradeView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EquipMemoryAttrResetView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EquipMemoryDecomposeView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EquipMemoryEmbedView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EquipMemoryWaxView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EquipMemoryAdvanceView",
      needRollBack = false
    })
  end
end

function EquipMemoryCombineView:HandleSwitchMemory(note)
  local item = note.body
  self.itemdata = item
end
