autoImport("PetAdventureView")
autoImport("PetComposeView")
autoImport("PetWorkSpaceView")
PetView = class("PetView", ContainerView)
PetView.ViewType = UIViewType.NormalLayer
PetView.TabName = {
  [1] = ZhString.PetView_PetAdventureTabName,
  [2] = ZhString.PetView_PetComposeTabName,
  [3] = ZhString.PetView_PetWorkSpaceTabName
}
local BGTEXTURE = {
  "home_blueprint_bg_paper2_lower",
  "home_blueprint_bg_paper2_upper",
  "home_blueprint_bg_paper2_right",
  "pet_bg_bg",
  "pet_bg_bg01"
}

function PetView:Init()
  self:InitShow()
  self:FindObjs()
  self:AddEvts()
  self:InitTex()
end

function PetView:FindObjs()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.adventureToggle, 4, {-5, -5})
  self.viewTitle = self:FindComponent("ViewTitleLab", UILabel)
  self.BgLowerTex = self:FindComponent("BgLower", UITexture)
  self.BgUpperTex = self:FindComponent("BgUpper", UITexture)
  self.BgRightTex = self:FindComponent("BgRight", UITexture)
  self.BgTexture2 = self:FindComponent("BgTexture2", UITexture)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  elseif self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandler(self.viewdata.viewdata.tab)
  else
    self:TabChangeHandler(PanelConfig.PetAdventureView.tab)
  end
  local tabList, icon = {
    self.adventureToggle,
    self.composeToggle,
    self.workToggle
  }
  self.tabIconSpList = {}
  for i, v in ipairs(tabList) do
    local longPress = v:GetComponent(UILongPress)
    if longPress then
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.PetView, {state, i})
      end
    end
    icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    TabNameTip.SwitchShowTabIconOrLabel(icon, Game.GameObjectUtil:DeepFindChild(v, "Lab"))
  end
  self:AddEventListener(TipLongPressEvent.PetView, self.HandleLongPress, self)
end

function PetView:AddEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ScenePetWorkSpaceUpdate, self.HandlePetWorkNtf)
  self:AddListenEvt(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, self.HandlePetWorkNtf)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandlePetWorkNtf)
  self:AddListenEvt(ItemEvent.PetUpdate, self.HandlePetWorkNtf)
  self:AddListenEvt(ServiceEvent.ScenePetQueryBattlePetCmd, self.HandleBattlePet)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.HandleStopAct)
  self:AddListenEvt(ServiceEvent.ScenePetWorkSpaceDataUpdatePetCmd, self.HandlePetWorkSpaceDataUpdate)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandlePetWorkSpaceDataUpdate)
end

function PetView:HandlePetWorkNtf()
  if self.PetWorkSpaceView then
    self.PetWorkSpaceView:HandleNtf()
  end
end

function PetView:HandlePetWorkSpaceDataUpdate()
  if self.PetWorkSpaceView then
    self.PetWorkSpaceView:UpdatePlayTimeRewardBtn()
  end
end

function PetView:HandleBattlePet(note)
  if self.PetWorkSpaceView then
    self.PetWorkSpaceView:HandleBattlePet(note)
  end
end

function PetView:HandleStopAct(note)
  if self.PetWorkSpaceView then
    self.PetWorkSpaceView:HandleStopAct(note)
  end
end

function PetView:HandleLongPress(param)
  local isPressing, i = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, PetView.TabName[i], false, self.coreTabMap[i].go:GetComponent(UISprite))
end

function PetView:TabChangeHandler(key)
  if not PetView.super.TabChangeHandler(self, key) then
    return
  end
  if key == PanelConfig.PetComposeView.tab then
    if not self.PetComposeView then
      self.PetComposeView = self:AddSubView("PetComposeView", PetComposeView)
    end
  elseif key == PanelConfig.PetWorkSpaceView.tab and not self.PetWorkSpaceView then
    self.PetWorkSpaceView = self:AddSubView("PetWorkSpaceView", PetWorkSpaceView)
  end
  self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  self.viewTitle.text = PetView.TabName[key]
end

function PetView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

function PetView:InitTex()
  PictureManager.Instance:SetHome(BGTEXTURE[1], self.BgLowerTex)
  PictureManager.Instance:SetHome(BGTEXTURE[2], self.BgUpperTex)
  PictureManager.Instance:SetHome(BGTEXTURE[3], self.BgRightTex)
  PictureManager.Instance:SetUI(BGTEXTURE[4], self.BgTexture2)
end

function PetView:InitShow()
  self.adventureObj = self:FindGO("AdventureView")
  self.composeObj = self:FindGO("ComposeView")
  self.workObj = self:FindGO("WorkView")
  self.adventureToggle = self:FindGO("AdventureTog")
  self.composeToggle = self:FindGO("ComposeTog")
  self.workToggle = self:FindGO("WorkTog")
  self.PetAdventureView = self:AddSubView("PetAdventureView", PetAdventureView)
  self:AddTabChangeEvent(self.adventureToggle, self.adventureObj, PanelConfig.PetAdventureView)
  self:AddTabChangeEvent(self.composeToggle, self.composeObj, PanelConfig.PetComposeView)
  self:AddTabChangeEvent(self.workToggle, self.workObj, PanelConfig.PetWorkSpaceView)
end

function PetView:HandleClose()
  if self.PetComposeView then
    self.PetComposeView:HandleClose()
  end
end

function PetView:OnEnter()
  EventManager.Me():AddEventListener(QuickBuyEvent.CloseUI, self.HandleClose, self)
  PetView.super.OnEnter(self)
end

function PetView:OnExit()
  PictureManager.Instance:UnLoadUI()
  PictureManager.Instance:UnloadPetWorkSpace()
  PictureManager.Instance:UnloadPetTexture()
  PictureManager.Instance:UnLoadHome()
  EventManager.Me():RemoveEventListener(QuickBuyEvent.CloseUI, self.HandleClose, self)
  if self.PetComposeView then
    self.PetComposeView:ResetModel()
  end
  PetView.super.OnExit(self)
end
