MultiProfessionNewView = class("MultiProfessionNewView", ContainerView)
MultiProfessionNewView.ViewType = UIViewType.NormalLayer
local _ArrayClear = TableUtility.ArrayClear
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy, _PictureManager
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEX = Asset_Role.PartIndexEx
local _MyGender, _MyRace
local _SceneName = "Scenesc_chuangjue"
local _EnviromentID = 231
local tempVector3 = LuaVector3.Zero()
local cameraConfig = {
  position = LuaVector3.New(1.28, 1.47, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -27.5, 0),
  fieldOfView = 66,
  backScale = Vector3(16, 9, 1)
}
autoImport("WrapInfiniteListCtrl")
autoImport("ProfessionNewPage")
autoImport("ProfessionChooseCell")
autoImport("ProfessionPageBasePart")
autoImport("ProfessionNewHeroPage")
autoImport("ProfessionSaveLoadNewPage")
autoImport("NewHappyShopBuyItemCell")
local _PictureManager = PictureManager.Instance
local helpID = {
  [2] = 32593
}

function MultiProfessionNewView:Init()
  FunctionCameraEffect.Me():ResetEffect(nil, true)
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  _ProfessionProxy = ProfessionProxy.Instance
  _PictureManager = PictureManager.Instance
  self:FindObjs()
  self:AddListenerEvts()
  self:AddCloseButtonEvent()
end

function MultiProfessionNewView:FindObjs()
  self.anchor_top = self:FindGO("Anchor_Top")
  self.professionPageTog = self:FindGO("ProfessionPageTog")
  self.professionPageCheck = self:FindGO("CheckMark", self.professionPageTog)
  self.saveAndLoadPageTog = self:FindGO("SaveAndLoadPageTog")
  self.saveAndLoadPageCheck = self:FindGO("CheckMark", self.saveAndLoadPageTog)
  self.professionPageContainer = self:FindGO("ProfessionPageContainer")
  self.ymirPageContainer = self:FindGO("YmirPageContainer")
  self.basePartContainer = self:FindGO("BasePartContainer")
  self.roleTexture = self:FindGO("RoleTexture")
  self:AddDragEvent(self.roleTexture, function(obj, delta)
    self:RotateRoleEvt(obj, delta)
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.meterorContainer = self:FindGO("meterorContainer", self.effectContainer)
  self.butterflyContainer = self:FindGO("butterflyContainer", self.effectContainer)
  self.switchEffectContainer = self:FindGO("switchEffectContainer", self.effectContainer)
  self.helpBtn = self:FindGO("HelpBtn")
  if not self.basePart then
    self.basePart = self:AddSubView("ProfessionPageBasePart", ProfessionPageBasePart)
  end
  if not self.professionPage then
    self.professionPage = self:AddSubView("ProfessionNewPage", ProfessionNewPage)
    self.professionPageContainer:SetActive(false)
  end
  self.professionHeroPage = self:AddSubView("ProfessionNewHeroPage", ProfessionNewHeroPage)
  self.professionHeroPage.gameObject:SetActive(false)
  self:AddTabChangeEvent(self.professionPageTog, self.professionPageContainer, 1)
  self:AddTabChangeEvent(self.saveAndLoadPageTog, self.ymirPageContainer, 2)
  if self.viewdata then
    if self.viewdata.viewdata and self.viewdata.viewdata.tab then
      self:TabChangeHandler(self.viewdata.viewdata.tab)
    else
      local savedTab = SaveInfoProxy.Instance:GetSavedTabIndex()
      if savedTab then
        self:TabChangeHandler(savedTab)
      else
        self:TabChangeHandler(PanelConfig.ProfessionNewPage.tab)
      end
    end
  else
    local savedTab = SaveInfoProxy.Instance:GetSavedTabIndex()
    if savedTab then
      self:TabChangeHandler(savedTab)
    else
      self:TabChangeHandler(PanelConfig.ProfessionNewPage.tab)
    end
  end
  self:CreateShopItemCell()
end

function MultiProfessionNewView:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd)
  self:AddListenEvt(ServiceEvent.NUserLoadRecordUserCmd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserUpdateRecordInfoUserCmd, self.HandleRecvUpdateRecordInfoUserCmd)
  self:AddListenEvt(ServiceEvent.NUserUpdateBranchInfoUserCmd, self.HandleRecvUpdateBranchInfoUserCmd)
  self:AddListenEvt(SaveNewCell.StatusChange, self.OnStatusChange)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  EventManager.Me():AddEventListener(ChangeProfessionPanelEvent.UpdateSlotIndex, self.HandleRecvUpdateRecordSlotIndexCmd, self)
end

function MultiProfessionNewView:TabChangeHandler(key)
  if self.curTab == key then
    return
  end
  if key == PanelConfig.ProfessionNewPage.tab then
    if self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage:Hide()
    end
    self.curTab = key
    if not self.professionPage then
      self.professionPage = self:AddSubView("ProfessionNewPage", ProfessionNewPage)
    end
    self.professionPage:RefreshJobChooseSlider(true)
    self.professionPage:RefreshPage()
    self:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.CurJob)
    FunctionMultiProfession.Me():TargetMoveTween(1, 0.5)
    self:SetSwitchEffectPos(1)
    self:SetEquipPartPos(1)
    self:UpdateHelpBtn()
  elseif key == 2 then
    if not FunctionUnLockFunc.Me():CheckCanOpen(9005, true) then
      return
    end
    self.curTab = key
    if self.professionPage then
      self.professionPage:RefreshJobChooseSlider(false)
    end
    FunctionMultiProfession.Me():TargetMoveTween(2, 0.5)
    if not self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage = self:AddSubView("ProfessionSaveLoadNewPage", ProfessionSaveLoadNewPage)
    else
      self.professionSaveLoadNewPage:Show()
    end
    self.basePart:ResetClassIconTween()
    self:SetSwitchEffectPos(2)
    self:SetEquipPartPos(2)
    self:UpdateHelpBtn()
  end
  if not MultiProfessionNewView.super.TabChangeHandler(self, key) then
    return
  end
  SaveInfoProxy.Instance:SetSavedTabIndex(key)
  self.basePart:SetCurTabIndex(key)
  self.professionPageCheck:SetActive(key == PanelConfig.ProfessionNewPage.tab)
  self.saveAndLoadPageCheck:SetActive(key == 2)
end

function MultiProfessionNewView:SwitchPageStatus(TweenGroup)
  self.basePart:UpdatePageTween(TweenGroup)
end

function MultiProfessionNewView:ResetClassIconTween()
  self.basePart:ResetClassIconTween()
end

function MultiProfessionNewView:PlayAdvancedClassTween(index)
  self.basePart:PlayAdvancedClassTween(index)
end

function MultiProfessionNewView:UpdateProps(classid)
  self.basePart:UpdateProps(classid)
end

function MultiProfessionNewView:SetProps(props)
  self.basePart:SetProps(props)
end

function MultiProfessionNewView:UpdatePolygon(classid)
  self.basePart:UpdatePolygon(classid)
end

function MultiProfessionNewView:SetPolygonValue(index, value, showPlus)
  self.basePart:SetPolyonValue(index, value, showPlus)
end

function MultiProfessionNewView:SetAttrRootActive(bool)
  self.basePart:SetAttrRootActive(bool)
end

function MultiProfessionNewView:SetMaxJobTipActive(bool)
  self.basePart:SetMaxJobTipActive(bool)
end

function MultiProfessionNewView:UpdateCurClassBranch(classid, showAdvance, showLevel, jobLevel)
  self.basePart:UpdateCurClassBranch(classid, showAdvance, showLevel, jobLevel)
end

function MultiProfessionNewView:UpdateClassBranchByBranchType(classid, showAdvance, showLevel, jobLevel)
  self.basePart:UpdateClassBranchByBranchType(classid, showAdvance, showLevel, jobLevel)
end

function MultiProfessionNewView:GetAdvClassList()
  return self.basePart:GetAdvClassList()
end

function MultiProfessionNewView:SetEquip(equipData)
  self.basePart:UpdateEquip(equipData)
end

function MultiProfessionNewView:ShowEquip(bool)
  self.basePart:ShowEquip(bool)
end

function MultiProfessionNewView:UpdateNodeSwitch(index)
  self.basePart:UpdateSwitchNode(index)
end

function MultiProfessionNewView:UpdateClassProcess(list, type)
  self.basePart:UpdateClassProcess(list, type)
end

function MultiProfessionNewView:ShowPreviewTip(bool)
  self.basePart:ShowPreviewTip(bool)
end

function MultiProfessionNewView:RefreshNodes(classid)
  self.basePart:RefreshNodes(classid)
end

function MultiProfessionNewView:SetFateBtnState(state)
  self.basePart:SetFateBtnState(state)
end

function MultiProfessionNewView:SetClassGOClickState(state)
  self.basePart:SetClassGOClickState(state)
end

function MultiProfessionNewView:SetEquipPartPos(index)
  self.basePart:SetEquipPartPos(index)
end

function MultiProfessionNewView:OnProfessionSaveLoadPageShow()
  self:SetFateBtnState(false)
  self:SetClassGOClickState(false)
end

function MultiProfessionNewView:OnProfessionSaveLoadPageHide()
  self:SetFateBtnState(true)
  self:SetClassGOClickState(true)
  self:SetSwitchNodeActive(true)
end

function MultiProfessionNewView:SwitchHeroStory(classid)
  self.professionHeroPage:SetProfession(classid)
end

function MultiProfessionNewView:SwitchToNode(index)
  if self.curTab == 1 then
    if index == 1 then
      if self.professionHeroPage.gameObject.activeSelf then
        self.professionHeroPage:StartInoutAnim(2, function()
          self.professionHeroPage.gameObject:SetActive(false)
        end)
      end
      FunctionMultiProfession.Me():TargetMoveTween(1, 0.4)
      self.professionPage:ShowFuncPart(true)
    elseif index == 2 then
      if not self.professionPage:CheckEquipCanShow() then
        MsgManager.ShowMsgByID(40312)
        return false
      end
      if self.professionHeroPage.gameObject.activeSelf then
        self.professionHeroPage:StartInoutAnim(2, function()
          self.professionHeroPage.gameObject:SetActive(false)
        end)
      end
      FunctionMultiProfession.Me():TargetMoveTween(1, 0.4)
      self.professionPage:ShowFuncPart(false)
    elseif index == 3 then
      local curProfession = self.professionHeroPage.selectedProfession
      if GameConfig.Profession.HeroStoryForbid and TableUtility.ArrayFindIndex(GameConfig.Profession.HeroStoryForbid, curProfession) > 0 then
        MsgManager.ShowMsgByID(43010)
        return false
      end
      if ProfessionProxy.IsHero(curProfession) then
        if not ProfessionProxy.Instance:IsThisIdYiGouMai(curProfession) then
          MsgManager.ShowMsgByID(43247)
          return false
        end
      else
        local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
        if not S_data[curProfession] then
          MsgManager.ShowMsgByID(43247)
          return false
        else
          local curProf = S_data[curProfession].profession
          local jobDepth = ProfessionProxy.GetJobDepth(curProf)
          if jobDepth == 1 then
            MsgManager.ShowMsgByID(43510)
            return
          end
        end
      end
      self.professionHeroPage.gameObject:SetActive(true)
      self.professionHeroPage:StartInoutAnim(1)
      FunctionMultiProfession.Me():TargetMoveTween(3, 0.5)
      self.professionPage:ShowFuncPart(false)
    end
  elseif self.curTab == 2 then
    if self.professionHeroPage.gameObject.activeSelf then
      self.professionHeroPage:StartInoutAnim(2, function()
        self.professionHeroPage.gameObject:SetActive(false)
      end)
    end
    FunctionMultiProfession.Me():TargetMoveTween(2, 0.4, index)
    if self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage:OnNodeSwitch(index)
    end
  end
  return true
end

function MultiProfessionNewView:SetSwitchNodeActive(active)
  self.basePart:SetSwitchNodeActive(active)
end

function MultiProfessionNewView:CreateShopItemCell()
  self.shopItemCellGO = self:LoadPreferb("cell/NewHappyShopBuyItemCell", self.gameObject, true)
  self.shopItemCellGO.transform.localPosition = LuaGeometry.GetTempVector3(100, 22)
  self.shopItemCellGO:SetActive(false)
end

function MultiProfessionNewView:ShowShopPurchaseCell(shopItemData)
  local itemData = Table_Item[shopItemData.goodsID]
  if shopItemData.isDeposit then
    itemData = Table_Item[shopItemData.itemID]
  end
  if itemData then
    if not self.shopItemCell then
      self.shopItemCell = NewHappyShopBuyItemCell.new(self.shopItemCellGO)
    end
    self.shopItemCell:SetData(shopItemData)
  end
end

function MultiProfessionNewView:ShowSwitchEffect()
  self:PlayUIEffect(EffectMap.UI.ProfessionPageJobSwitch, self.switchEffectContainer, true)
end

function MultiProfessionNewView:SetSwitchEffectPos(index)
  if index == 1 then
    self.switchEffectContainer.transform.localPosition = LuaGeometry.GetTempVector3(40, 0, 0)
  elseif index == 2 then
    self.switchEffectContainer.transform.localPosition = LuaGeometry.GetTempVector3(100, 0, 0)
  end
end

function MultiProfessionNewView:UpdateHelpBtn()
  if not self.curTab then
    self.helpBtn:SetActive(false)
    return
  end
  local helpid = helpID[self.curTab]
  self:TryOpenHelpViewById(helpid, nil, self.helpBtn)
end

function MultiProfessionNewView:RecvProfessionQueryUserCmd(data)
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_ProfessionDatas) do
    if v.iscurrent then
      ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
    end
  end
end

function MultiProfessionNewView:CallHeroTicketShop()
  local hero_ticket_shop = GameConfig.Profession.hero_ticket_shop or {
    812,
    1,
    56597
  }
  HappyShopProxy.Instance:InitShop(nil, hero_ticket_shop[2], hero_ticket_shop[1])
end

function MultiProfessionNewView:OnEnter()
  self.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  FunctionMultiProfession.Me():Launch()
  self:CallHeroTicketShop()
  self:PlayUIEffect(EffectMap.UI.ProfessionPageMeteror, self.meterorContainer)
  self:PlayUIEffect(EffectMap.UI.ProfessionPageButterfly, self.butterflyContainer)
  FunctionBGMCmd.Me():PlayUIBgm("Title_SevenRoyal", 0)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.ReviveLayer, false)
  CameraFilterProxy.Instance:Pause()
end

function MultiProfessionNewView:OnExit()
  FunctionMultiProfession.Me():Shutdown()
  local mount = BagProxy.Instance.roleEquip:GetMount()
  local vp = nil ~= mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort
  self:CameraRotateToMe(false, vp, nil, nil, 0)
  self:CameraReset()
  FunctionBGMCmd.Me():StopUIBgm()
  EventManager.Me():RemoveEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.ReviveLayer, true)
  TimeLimitShopProxy.Instance:viewPopUp()
  CameraFilterProxy.Instance:Resume()
  if self.viewdata.viewdata and self.viewdata.viewdata.fromRechargeHero then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THero, nil, {
      profIdOnce = self.viewdata.viewdata.fromRechargeHero
    })
  end
  if TriplePlayerPvpProxy.Instance:InPreparation() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TriplePlayerPvpChooseProView
    })
  end
  MultiProfessionNewView.super.OnExit(self)
end

function MultiProfessionNewView:HandleRecvUpdateRecordInfoUserCmd(note)
  self.recordInfoInited, self.typeBranchNeedCheck = self.professionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd()
  if self.recordInfoInited then
    self:SwitchToNode(1)
  end
end

function MultiProfessionNewView:HandleRecvUpdateBranchInfoUserCmd(note)
  if not self.recordInfoInited and BranchInfoSaveProxy.Instance:HasRecordData(self.typeBranchNeedCheck) then
    local inited = self.professionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd()
    if inited then
      self:SwitchToNode(1)
    end
    self.recordInfoInited = inited
  end
end

function MultiProfessionNewView:HandleRecvUpdateRecordSlotIndexCmd(note)
  if self.curTab == 2 then
    self.professionSaveLoadNewPage:SetSaveList()
  end
end

function MultiProfessionNewView:OnStatusChange()
  if self.professionSaveLoadNewPage then
    self.professionSaveLoadNewPage:OnStatusChange()
  end
end

function MultiProfessionNewView:RotateRoleEvt(go, delta)
  FunctionMultiProfession.Me():RotateModel(-delta.x)
end

function MultiProfessionNewView:CloseSelf()
  MultiProfessionNewView.super.CloseSelf(self)
end
