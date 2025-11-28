autoImport("RepositoryViewBagPage")
autoImport("RepositoryViewItemPage")
RepositoryView = class("RepositoryView", ContainerView)
RepositoryView.ViewType = UIViewType.NormalLayer
RepositoryView.Tab = {
  RepositoryTab = 1,
  CommonTab = 2,
  HomeTab = 3
}
RepositoryView.TabName = {
  RepositoryTab = ZhString.RepositoryView_RepositoryTabName,
  CommonTab = ZhString.RepositoryView_CommonTabName,
  HomeTab = ZhString.RepositoryView_HomeTabName
}

function RepositoryView:Init()
  self.ListenerEvtMap = {}
  self.repositoryViewBagPage = self:AddSubView("RepositoryViewBagPage", RepositoryViewBagPage)
  self.repositoryViewItemPage = self:AddSubView("RepositoryViewItemPage", RepositoryViewItemPage)
  self.chooseEquipIndex = nil
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function RepositoryView:OnEnter()
  self.super.OnEnter(self)
  self:handleCameraQuestStart()
  if self.viewdata.viewdata.furniture then
    HomeManager.Me():RegisterWorkingHomeStore(self.viewdata.viewdata.furniture)
  end
  ServiceItemProxy.Instance:CallOnOffStoreItemCmd(true)
end

function RepositoryView:handleCameraQuestStart()
  local npcData = self.viewdata.viewdata.npcdata
  if npcData then
    printRed("RepositoryView handleCameraQuestStart")
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  end
end

function RepositoryView:OnExit()
  ServiceItemProxy.Instance:CallOnOffStoreItemCmd(false)
  ServiceItemProxy.Instance:CallBrowsePackage(BagProxy.BagType.Storage)
  ServiceItemProxy.Instance:CallBrowsePackage(BagProxy.BagType.PersonalStorage)
  HomeManager.Me():RegisterWorkingHomeStore()
  self:CameraReset()
  TipsView.Me():HideCurrent()
  RepositoryView.super.OnExit(self)
end

function RepositoryView:FindObjs()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.repositoryTab = self:FindComponent("RepositoryTab", UIToggle)
  self.commonTab = self:FindComponent("CommonTab", UIToggle)
  self.homeTab = self:FindComponent("HomeTab", UIToggle)
  self.tabToggles = {
    self.repositoryTab,
    self.commonTab,
    self.homeTab
  }
  self.numMap = {}
  self.numMap.RepositoryNum = self:FindComponent("RepositoryNum", UILabel, self.repositoryTab.gameObject)
  self.numMap.CommonNum = self:FindComponent("CommonNum", UILabel, self.commonTab.gameObject)
  self.numMap.HomeNum = self:FindComponent("HomeNum", UILabel, self.homeTab.gameObject)
  self.tabIconSpMap = {}
  self.tabIconSpMap[RepositoryView.Tab.RepositoryTab] = self:FindComponent("Icon", UISprite, self.repositoryTab.gameObject)
  self.tabIconSpMap[RepositoryView.Tab.CommonTab] = self:FindComponent("Icon", UISprite, self.commonTab.gameObject)
  self.tabIconSpMap[RepositoryView.Tab.HomeTab] = self:FindComponent("Icon", UISprite, self.homeTab.gameObject)
end

function RepositoryView:AddEvts()
  local onChange = function(tab, viewTab)
    if not tab or not tab.value then
      return
    end
    self.viewTab = viewTab
    RepositoryViewProxy.Instance:SetViewTab(self.viewTab)
    self.repositoryViewItemPage:InitShow()
    self.repositoryViewBagPage:InitShow()
    for vt, sp in pairs(self.tabIconSpMap) do
      sp.color = vt == viewTab and ColorUtil.TabColor_DeepBlue or ColorUtil.TabColor_White
    end
  end
  EventDelegate.Add(self.repositoryTab.onChange, function()
    onChange(self.repositoryTab, RepositoryView.Tab.RepositoryTab)
  end)
  EventDelegate.Add(self.commonTab.onChange, function()
    onChange(self.commonTab, RepositoryView.Tab.CommonTab)
  end)
  EventDelegate.Add(self.homeTab.onChange, function()
    onChange(self.homeTab, RepositoryView.Tab.HomeTab)
  end)
  local longPressEvent = function(obj, state)
    self:PassEvent(TipLongPressEvent.RepositoryView, {
      state,
      obj.gameObject
    })
  end
  for _, toggle in pairs(self.tabToggles) do
    local longPress = toggle:GetComponent(UILongPress)
    longPress.pressEvent = longPressEvent
  end
  self:AddEventListener(TipLongPressEvent.RepositoryView, self.HandleLongPress, self)
end

function RepositoryView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.ItemReArrage, self.HandleItemReArrage)
  self:AddListenEvt(MyselfEvent.LevelUp, self.HandleLevelUp)
end

function RepositoryView:InitShow()
  self.commonTab.gameObject:SetActive(not GameConfig.SystemForbid.Store)
  self.homeTab.gameObject:SetActive(self.viewdata.viewdata.furniture ~= nil)
  self:UpdateNum()
  for _, toggle in ipairs(self.tabToggles) do
    TabNameTip.SwitchShowTabIconOrLabel(self:FindGO("Icon", toggle.gameObject), self:FindGO("Label", toggle.gameObject))
  end
end

function RepositoryView:HandleItemUpdate(note)
  self.repositoryViewBagPage:HandleItemUpdate(note)
  self.repositoryViewItemPage:HandleItemUpdate(note)
  self:UpdateNum()
end

function RepositoryView:HandleItemReArrage(note)
  self.repositoryViewBagPage:HandleItemReArrage(note)
  self.repositoryViewItemPage:HandleItemReArrage(note)
end

function RepositoryView:HandleLevelUp(note)
  self.repositoryViewBagPage:HandleLevelUp(note)
  self.repositoryViewItemPage:HandleLevelUp(note)
end

local numNameDataFuncMap = {
  RepositoryNum = "GetPersonalRepositoryBagData",
  CommonNum = "GetRepositoryBagData",
  HomeNum = "GetHomeRepositoryBagData"
}
local numNameBagTypeMap = {
  RepositoryNum = BagProxy.BagType.PersonalStorage,
  CommonNum = BagProxy.BagType.Storage,
  HomeNum = BagProxy.BagType.Home
}

function RepositoryView:UpdateNum()
  local bagIns = BagProxy.Instance
  local dataFunc, bagData, total, max
  for name, num in pairs(self.numMap) do
    dataFunc = numNameDataFuncMap[name]
    bagData = dataFunc and bagIns[dataFunc] and bagIns[dataFunc](bagIns)
    total = bagData and #bagData:GetItemsWithoutNoPile(ItemNormalList.TabConfig[1])
    max = numNameBagTypeMap[name] and bagIns:GetBagUpLimit(numNameBagTypeMap[name])
    if total and max then
      if total >= max then
        num.gameObject:SetActive(true)
        num.text = total .. "/" .. max
      else
        num.gameObject:SetActive(false)
      end
    end
  end
end

function RepositoryView:GetPackTypeFromViewTab(viewTab)
  viewTab = viewTab or self.viewTab
  local packType
  if viewTab == RepositoryView.Tab.RepositoryTab then
    packType = SceneItem_pb.EPACKTYPE_PERSONAL_STORE
  elseif viewTab == RepositoryView.Tab.CommonTab then
    packType = SceneItem_pb.EPACKTYPE_STORE
  elseif viewTab == RepositoryView.Tab.HomeTab then
    packType = SceneItem_pb.EPACKTYPE_HOME
  end
  return packType
end

function RepositoryView:CallOneClickPutStore(itemPageIndex)
  self.repositoryViewItemPage:CallOneClickPutStore(itemPageIndex)
end

local tabNameTipOffset = {210, 8}

function RepositoryView:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, RepositoryView.TabName[go.name], false, go:GetComponent(UISprite), NGUIUtil.AnchorSide.Right, tabNameTipOffset)
end
